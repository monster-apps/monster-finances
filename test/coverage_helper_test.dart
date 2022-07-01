// ignore_for_file: unused_import

// file automatically generated by running:
// dart run coverage_helper.dart

import 'package:monster_finances/providers/account_query_provider.dart';
import 'package:monster_finances/providers/tag_list_provider.dart';
import 'package:monster_finances/providers/responsible_query_provider.dart';
import 'package:monster_finances/providers/category_query_provider.dart';
import 'package:monster_finances/providers/account_transaction_list_provider.dart';
import 'package:monster_finances/providers/transaction_query_provider.dart';
import 'package:monster_finances/providers/total_amount_by_account_provider.dart';
import 'package:monster_finances/providers/database_provider.dart';
import 'package:monster_finances/providers/last_responsible_selected_provider.dart';
import 'package:monster_finances/providers/total_amount_by_account_type_provider.dart';
import 'package:monster_finances/providers/category_list_provider.dart';
import 'package:monster_finances/providers/account_list_provider.dart';
import 'package:monster_finances/providers/transaction_list_provider.dart';
import 'package:monster_finances/providers/tag_query_provider.dart';
import 'package:monster_finances/providers/current_transaction_provider.dart';
import 'package:monster_finances/providers/responsible_list_provider.dart';
import 'package:monster_finances/providers/tags_selected_provider.dart';
import 'package:monster_finances/providers/current_account_provider.dart';
import 'package:monster_finances/providers/total_amount_provider.dart';
import 'package:monster_finances/utils/screen_util.dart';
import 'package:monster_finances/utils/text_util.dart';
import 'package:monster_finances/utils/select_account_util.dart';
import 'package:monster_finances/utils/initial_data/dev_data/account_data.dart';
import 'package:monster_finances/utils/initial_data/dev_data/transaction_data.dart';
import 'package:monster_finances/utils/initial_data/dev_data/account_responsible_data.dart';
import 'package:monster_finances/utils/initial_data/category_data.dart';
import 'package:monster_finances/utils/initial_data/account_type_data.dart';
import 'package:monster_finances/utils/initial_data/initial_data.dart';
import 'package:monster_finances/main.dart';
import 'package:monster_finances/config.dart';
import 'package:monster_finances/data/database/queries/tags.dart';
import 'package:monster_finances/data/database/queries/accounts.dart';
import 'package:monster_finances/data/database/queries/responsible.dart';
import 'package:monster_finances/data/database/queries/transactions.dart';
import 'package:monster_finances/data/database/queries/categories.dart';
import 'package:monster_finances/data/database/entities/account_responsible.dart';
import 'package:monster_finances/data/database/entities/account_type.dart';
import 'package:monster_finances/data/database/entities/account.dart';
import 'package:monster_finances/data/database/entities/tag.dart';
import 'package:monster_finances/data/database/entities/category.dart';
import 'package:monster_finances/data/database/entities/transaction.dart';
import 'package:monster_finances/data/database/store/store.dart';
import 'package:monster_finances/views/account_info_page/account_info_page.dart';
import 'package:monster_finances/views/account_transactions_page/account_transactions_page.dart';
import 'package:monster_finances/views/not_found.dart';
import 'package:monster_finances/views/wrapper_page.dart';
import 'package:monster_finances/views/splash_page.dart';
import 'package:monster_finances/views/overview_page/accounts_page.dart';
import 'package:monster_finances/views/empty_page.dart';
import 'package:monster_finances/views/transaction_page/transaction_page.dart';
import 'package:monster_finances/widgets/tags.dart';
import 'package:monster_finances/widgets/responsible_chips.dart';
import 'package:monster_finances/widgets/list_chip.dart';
import 'package:monster_finances/widgets/error_indicator.dart';
import 'package:monster_finances/widgets/progress_indicator.dart';
import 'package:monster_finances/widgets/list_input.dart';
import 'package:monster_finances/widgets/categories.dart';
import 'package:monster_finances/widgets/custom_chips_input.dart';
import 'package:monster_finances/widgets/base/chips_input.dart';
import 'package:monster_finances/widgets/base/text_cursor.dart';

void main() {}
