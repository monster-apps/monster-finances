import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'base/chips_input.dart';

class CustomChipsInput<T> extends FormBuilderField<List<T>> {
  final T Function(String) addChip;
  final bool allowChipEditing;
  final bool autocorrect;
  final bool autofocus;
  final bool obscureText;
  final Brightness keyboardAppearance;
  final ChipsBuilder<T> chipBuilder;
  final int? maxChips;
  final String? actionLabel;
  final TextCapitalization textCapitalization;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final TextOverflow textOverflow;
  final TextStyle? textStyle;

  CustomChipsInput({
    Key? key,
    //From Super
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    FocusNode? focusNode,
    FormFieldSetter<List<T>>? onSaved,
    FormFieldValidator<List<T>>? validator,
    InputDecoration decoration = const InputDecoration(),
    List<T> initialValue = const [],
    required String name,
    required this.addChip,
    required this.chipBuilder,
    ValueChanged<List<T>?>? onChanged,
    ValueTransformer<List<T>?>? valueTransformer,
    VoidCallback? onReset,
    this.actionLabel,
    this.allowChipEditing = false,
    this.autocorrect = false,
    this.autofocus = false,
    this.inputAction = TextInputAction.done,
    this.inputType = TextInputType.text,
    this.keyboardAppearance = Brightness.light,
    this.maxChips,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.textOverflow = TextOverflow.clip,
    this.textStyle,
  }) : super(
          autovalidateMode: autovalidateMode,
          decoration: decoration,
          enabled: enabled,
          focusNode: focusNode,
          initialValue: initialValue,
          key: key,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
          valueTransformer: valueTransformer,
          builder: (FormFieldState<List<T>?> field) {
            final state = field as FormBuilderChipsInputState<T>;

            return ChipsInput<T>(
              key: key,
              addChip: addChip,
              initialValue: field.value!,
              enabled: state.enabled,
              decoration: state.decoration,
              onChanged: (data) {
                field.didChange(data);
                debugPrint(data.toString());
              },
              maxChips: maxChips,
              chipBuilder: chipBuilder,
              textStyle: textStyle,
              actionLabel: actionLabel,
              autocorrect: autocorrect,
              inputAction: inputAction,
              inputType: inputType,
              keyboardAppearance: keyboardAppearance,
              obscureText: obscureText,
              textCapitalization: textCapitalization,
              allowChipEditing: allowChipEditing,
              autofocus: autofocus,
              focusNode: state.effectiveFocusNode,
              textOverflow: textOverflow,
            );
          },
        );

  @override
  FormBuilderChipsInputState<T> createState() =>
      FormBuilderChipsInputState<T>();
}

class FormBuilderChipsInputState<T>
    extends FormBuilderFieldState<CustomChipsInput<T>, List<T>> {}
