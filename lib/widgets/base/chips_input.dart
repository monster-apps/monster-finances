import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'text_cursor.dart';

typedef ChipSelected<T> = void Function(T data, bool selected);
typedef ChipsBuilder<T> = Widget Function(
    BuildContext context, ChipsInputState<T> state, T data);

const kObjectReplacementChar = 0xFFFD;

extension on TextEditingValue {
  String get normalCharactersText => String.fromCharCodes(
        text.codeUnits.where((ch) => ch != kObjectReplacementChar),
      );

  List<int> get replacementCharacters => text.codeUnits
      .where((ch) => ch == kObjectReplacementChar)
      .toList(growable: false);

  int get replacementCharactersCount => replacementCharacters.length;
}

class ChipsInput<T> extends StatefulWidget {
  const ChipsInput({
    Key? key,
    this.initialValue = const [],
    this.decoration = const InputDecoration(),
    this.enabled = true,
    required this.chipBuilder,
    required this.onChanged,
    required this.addChip,
    this.onChipTapped,
    this.maxChips,
    this.textStyle,
    this.inputType = TextInputType.text,
    this.textOverflow = TextOverflow.clip,
    this.obscureText = false,
    this.autocorrect = true,
    this.actionLabel,
    this.inputAction = TextInputAction.done,
    this.keyboardAppearance = Brightness.light,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.allowChipEditing = false,
    this.focusNode,
  })  : assert(maxChips == null || initialValue.length <= maxChips),
        super(key: key);

  final InputDecoration decoration;
  final TextStyle? textStyle;
  final bool enabled;
  final ValueChanged<List<T>> onChanged;
  final T Function(String) addChip;
  @Deprecated('Will be removed in the next major version')
  final ValueChanged<T>? onChipTapped;
  final ChipsBuilder<T> chipBuilder;
  final List<T> initialValue;
  final int? maxChips;
  final TextInputType inputType;
  final TextOverflow textOverflow;
  final bool obscureText;
  final bool autocorrect;
  final String? actionLabel;
  final TextInputAction inputAction;
  final Brightness keyboardAppearance;
  final bool autofocus;
  final bool allowChipEditing;
  final FocusNode? focusNode;

  // final Color cursorColor;

  final TextCapitalization textCapitalization;

  @override
  ChipsInputState<T> createState() => ChipsInputState<T>();
}

class ChipsInputState<T> extends State<ChipsInput<T>>
    implements TextInputClient {
  Set<T> _chips = <T>{};
  TextEditingValue _value = const TextEditingValue();

  // TextEditingValue _receivedRemoteTextEditingValue;
  TextInputConnection? _textInputConnection;
  final _layerLink = LayerLink();
  final _enteredTexts = <T, String>{};

  TextInputConfiguration get textInputConfiguration => TextInputConfiguration(
        inputType: widget.inputType,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        actionLabel: widget.actionLabel,
        inputAction: widget.inputAction,
        keyboardAppearance: widget.keyboardAppearance,
        textCapitalization: widget.textCapitalization,
      );

  bool get _hasInputConnection =>
      _textInputConnection != null && _textInputConnection!.attached;

  // bool get _hasReachedMaxChips =>
  //     widget.maxChips != null && _chips.length >= widget.maxChips!;

  // FocusAttachment _focusAttachment;
  late FocusNode _focusNode;

  RenderObject? get renderBox => context.findRenderObject();

  @override
  void initState() {
    super.initState();
    _chips.addAll(widget.initialValue);

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initOverlayEntry();
      if (mounted && widget.autofocus) {
        FocusScope.of(context).autofocus(_focusNode);
      }
    });
  }

  @override
  void dispose() {
    _closeInputConnectionIfNeeded();

    _focusNode.removeListener(_handleFocusChanged);
    if (null == widget.focusNode) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //TODO: Implement
  }

  void _handleFocusChanged() {
    if (_focusNode.hasFocus) {
      _openInputConnection();
    } else {
      _closeInputConnectionIfNeeded();
    }
    if (mounted) {
      setState(() {
        /*rebuild so that _TextCursor is hidden.*/
      });
    }
  }

  void _initOverlayEntry() {}

  void deleteChip(T data) {
    if (widget.enabled) {
      _chips.remove(data);
      if (_enteredTexts.containsKey(data)) _enteredTexts.remove(data);
      _updateTextInputState();
      widget.onChanged(_chips.toList(growable: false));
    }
  }

  void _openInputConnection() {
    if (!_hasInputConnection) {
      _textInputConnection = TextInput.attach(this, textInputConfiguration)
        ..setEditingState(_value);
    }
    _textInputConnection?.show();

    Future.delayed(const Duration(milliseconds: 100), () {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final RenderObject? renderBox = context.findRenderObject();
        await Scrollable.of(context)?.position.ensureVisible(renderBox!);
      });
    });
  }

  void _onSearchChanged(String value) async {}

  void _closeInputConnectionIfNeeded() {
    if (_hasInputConnection) {
      _textInputConnection?.close();
      _textInputConnection = null;
    }
  }

  @override
  void updateEditingValue(TextEditingValue value) {
    var oldTextEditingValue = _value;
    if (value.text != oldTextEditingValue.text) {
      setState(() {
        _value = value;
      });
      if (value.replacementCharactersCount <
          oldTextEditingValue.replacementCharactersCount) {
        var removedChip = _chips.last;
        _chips = Set.of(_chips.take(value.replacementCharactersCount));
        widget.onChanged(_chips.toList(growable: false));
        String? putText = '';
        if (widget.allowChipEditing && _enteredTexts.containsKey(removedChip)) {
          putText = _enteredTexts[removedChip];
          _enteredTexts.remove(removedChip);
        }
        _updateTextInputState(putText: putText);
      } else {
        _updateTextInputState();
      }
      _onSearchChanged(_value.normalCharactersText);
    }
  }

  void _updateTextInputState({replaceText = false, putText = ''}) {
    final updatedText =
        "${String.fromCharCodes(_chips.map((_) => kObjectReplacementChar))}${replaceText ? '' : _value.normalCharactersText}$putText";
    setState(() {
      _value = _value.copyWith(
        text: updatedText,
        selection: TextSelection.collapsed(offset: updatedText.length),
        //composing: TextRange(start: 0, end: text.length),
      );
    });
    _closeInputConnectionIfNeeded(); //Hack for #34 (https://github.com/danvick/flutter_chips_input/issues/34#issuecomment-684505282). TODO: Find permanent fix
    _textInputConnection ??= TextInput.attach(this, textInputConfiguration);
    _textInputConnection?.setEditingState(_value);
  }

  @override
  void performAction(TextInputAction action) {
    switch (action) {
      case TextInputAction.done:
      case TextInputAction.go:
      case TextInputAction.send:
      case TextInputAction.search:
        String enteredText = _value.normalCharactersText;
        if (enteredText.length > 2) {
          T newChip = widget.addChip(enteredText);
          _chips.add(newChip);
          _value = TextEditingValue.empty;
          _focusNode.unfocus();
        } else {
          _focusNode.unfocus();
        }
        break;
      default:
        _focusNode.unfocus();
        break;
    }
  }

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {}

  @override
  void didUpdateWidget(covariant ChipsInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {}

  @override
  void connectionClosed() {}

  @override
  TextEditingValue get currentTextEditingValue => _value;

  @override
  void showAutocorrectionPromptRect(int start, int end) {}

  @override
  AutofillScope? get currentAutofillScope => null;

  @override
  Widget build(BuildContext context) {
    var chipsChildren = _chips
        .map<Widget>((data) => widget.chipBuilder(context, this, data))
        .toList();

    final theme = Theme.of(context);

    chipsChildren.add(
      SizedBox(
        height: 32.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Text(
                _value.normalCharactersText,
                maxLines: 1,
                overflow: widget.textOverflow,
                style: widget.textStyle ??
                    theme.textTheme.subtitle1?.copyWith(height: 1.5),
              ),
            ),
            Flexible(
              flex: 0,
              child: TextCursor(resumed: _focusNode.hasFocus),
            ),
          ],
        ),
      ),
    );

    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (SizeChangedLayoutNotification val) {
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Column(
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(_focusNode);
                _textInputConnection?.show();
              },
              child: InputDecorator(
                decoration: widget.decoration,
                isFocused: _focusNode.hasFocus,
                isEmpty: _value.text.isEmpty && _chips.isEmpty,
                child: Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: chipsChildren,
                ),
              ),
            ),
            CompositedTransformTarget(
              link: _layerLink,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void insertTextPlaceholder(Size size) {
    // TODO: implement insertTextPlaceholder
  }

  @override
  void removeTextPlaceholder() {
    // TODO: implement removeTextPlaceholder
  }

  @override
  void showToolbar() {
    // TODO: implement showToolbar
  }
}
