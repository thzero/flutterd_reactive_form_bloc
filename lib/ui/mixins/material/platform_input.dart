import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:reactive_color_picker/reactive_color_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_image_picker/reactive_image_picker.dart';

import 'package:flutterd/ui/mixins/material/platform.dart';
import 'package:flutterd/ui/mixins/platform.dart';
import 'package:flutterd_reactive_form_bloc/ui/mixins/platform_input.dart';

mixin MaterialReactiveFormInputPlatformMixin on InputPlatformMixin, MaterialPlatformMixin {
  @override
  Widget constructInputCheckbox(BuildContext context, String name, String title, {bool readOnly = false, EdgeInsetsGeometry? padding}) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: ReactiveCheckbox(
          formControlName: name,
        ));
  }

  @override
  Widget constructInputColor(BuildContext context, String name, {bool readOnly = false, EdgeInsetsGeometry? padding}) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: ReactiveMaterialColorPicker<Color>(
          formControlName: name,
        ));
  }

  // @override
  // Widget constructInputDropdown<T extends ValueItemSelectFieldBloc<String, String, dynamic>>(BuildContext context, T value, String text, String hint, {bool readOnly = true}) {
  //   return ValueItemDropdownFieldBlocBuilder<String, String>(
  //     selectFieldBloc: value,
  //     decoration: InputDecoration(
  //       // filled: true,
  //       hintText: hint,
  //       labelText: text,
  //     ),
  //     itemBuilder: (context, value) => FieldItem(
  //       child: Text(value),
  //     ),
  //   );
  // }

  @override
  Widget constructInputImage(BuildContext context, String name, String title, String? hint, {bool readOnly = false}) {
    return ReactiveImagePicker(
        formControlName: name,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          labelText: title,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          helperText: hint,
        ),
        inputBuilder: (onPressed) => constructButtonTapIcon(context, () async {
              onPressed();
            }, PlatformMixin.iconPhoto));
  }

  @override
  Widget constructInputNumber(BuildContext context, String name, String title, String? hint, {bool signed = false, bool readOnly = false, EdgeInsetsGeometry? padding}) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: ReactiveTextField(
          decoration: InputDecoration(
            hintText: hint,
            labelText: title,
          ),
          formControlName: name,
          keyboardType: TextInputType.numberWithOptions(signed: signed, decimal: false),
          readOnly: readOnly,
          showErrors: (control) => control.invalid && control.dirty,
        ));
  }

  @override
  Widget constructInputNumberDecimal(BuildContext context, String name, String title, String? hint, {bool signed = false, bool readOnly = false, EdgeInsetsGeometry? padding}) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: ReactiveTextField(
          decoration: InputDecoration(
            hintText: hint,
            labelText: title,
          ),
          formControlName: name,
          keyboardType: TextInputType.numberWithOptions(signed: signed, decimal: true),
          readOnly: readOnly,
          showErrors: (control) => control.invalid && control.dirty,
        ));
  }

  @override
  Widget constructInputText(BuildContext context, String name, String title, String? hint, {bool readOnly = false, EdgeInsetsGeometry? padding}) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: ReactiveTextField(
          decoration: InputDecoration(
            hintText: hint,
            labelText: title,
          ),
          formControlName: name,
          readOnly: readOnly,
          showErrors: (control) => control.invalid && control.dirty,
        ));
  }

  @override
  Widget constructInputTextArea(BuildContext context, String name, String title, String? hint,
      {int maxLines = 5, int minLines = 1, int? maxLength = 500, MaxLengthEnforcement maxLengthEnforcement = MaxLengthEnforcement.enforced, bool readOnly = false, EdgeInsetsGeometry? padding}) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: ReactiveTextField(
          decoration: InputDecoration(
            hintText: hint,
            labelText: title,
          ),
          formControlName: name,
          keyboardType: TextInputType.multiline,
          minLines: minLines,
          maxLines: maxLines,
          maxLengthEnforcement: maxLengthEnforcement,
          maxLength: maxLength,
          readOnly: readOnly,
          showErrors: (control) => control.invalid && control.dirty,
        ));
  }
}
