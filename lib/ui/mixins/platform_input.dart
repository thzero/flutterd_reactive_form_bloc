import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterd_reactive_form_bloc/blocs/form/reactive_form_state.dart';

typedef ReactiveFormConsumerActionsBuilder = List<Widget> Function(BuildContext context, ReactiveFormState state);

mixin InputPlatformMixin {
  Widget constructInputCheckbox(BuildContext context, String name, String title, {bool readOnly = false, EdgeInsetsGeometry? padding});
  Widget constructInputColor(BuildContext context, String name, {bool readOnly = false, EdgeInsetsGeometry? padding});
  Widget constructInputDropdown(BuildContext context, String name, String text, String hint, Map<String, String> values, {bool readOnly = true, EdgeInsetsGeometry? padding});
  Widget constructInputForm(BuildContext context, ReactiveFormState state, Widget child, ReactiveFormConsumerActionsBuilder builder);
  Widget constructInputImage(BuildContext context, String name, String title, String? hint, {bool readOnly = false});
  Widget constructInputNumber(BuildContext context, String name, String title, String? hint, {bool signed = false, bool readOnly = false, EdgeInsetsGeometry? padding});
  Widget constructInputNumberDecimal(BuildContext context, String name, String title, String? hint, {bool signed = false, bool readOnly = false, EdgeInsetsGeometry? padding});
  Widget constructInputText(BuildContext context, String name, String title, String? hint, {bool readOnly = false, EdgeInsetsGeometry? padding});
  Widget constructInputTextArea(BuildContext context, String name, String title, String? hint,
      {int maxLines = 5, int minLines = 1, int? maxLength = 500, MaxLengthEnforcement maxLengthEnforcement = MaxLengthEnforcement.enforced, bool readOnly = false, EdgeInsetsGeometry? padding});
}
