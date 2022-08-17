import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

mixin InputPlatformMixin {
  Widget constructInputCheckbox(BuildContext context, String name, String title, {bool readOnly = false, EdgeInsetsGeometry? padding});
  Widget constructInputColor(BuildContext context, String name, {bool readOnly = false, EdgeInsetsGeometry? padding});
  // Widget constructInputDropdown<T>(BuildContext context, T value, String text, String hint, {bool readOnly = false, EdgeInsetsGeometry? padding});
  Widget constructInputImage(BuildContext context, String name, String title, String? hint, {bool readOnly = false});
  Widget constructInputNumber(BuildContext context, String name, String title, String? hint, {bool signed = false, bool readOnly = false, EdgeInsetsGeometry? padding});
  Widget constructInputNumberDecimal(BuildContext context, String name, String title, String? hint, {bool signed = false, bool readOnly = false, EdgeInsetsGeometry? padding});
  Widget constructInputText(BuildContext context, String name, String title, String? hint, {bool readOnly = false, EdgeInsetsGeometry? padding});
  Widget constructInputTextArea(BuildContext context, String name, String title, String? hint,
      {int maxLines = 5, int minLines = 1, int? maxLength = 500, MaxLengthEnforcement maxLengthEnforcement = MaxLengthEnforcement.enforced, bool readOnly = false, EdgeInsetsGeometry? padding});
}
