import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:easy_mask/easy_mask.dart';

import 'package:reactive_color_picker/reactive_color_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_image_picker/reactive_image_picker.dart';

import 'package:flutterd/ui/mixins/material/platform.dart';
import 'package:flutterd/ui/mixins/platform.dart';
import 'package:flutterd_reactive_form_bloc/blocs/form/reactive_form_state.dart';
import 'package:flutterd_reactive_form_bloc/ui/mixins/platform_input.dart';

mixin MaterialReactiveFormInputPlatformMixin on InputPlatformMixin, MaterialPlatformMixin {
  @override
  Widget constructInputCheckbox(BuildContext context, String name, String title, {bool readOnly = false, EdgeInsetsGeometry? padding}) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
      ReactiveCheckbox(
        formControlName: name,
      ),
      Expanded(child: Text(title)),
    ]);
  }

  @override
  Widget constructInputColor(BuildContext context, String name, {bool readOnly = false, EdgeInsetsGeometry? padding}) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: ReactiveMaterialColorPicker<Color>(
          formControlName: name,
        ));
  }

  @override
  Widget constructInputDropdown(BuildContext context, String name, String text, String hint, Map<String, String> values, {bool readOnly = true, EdgeInsetsGeometry? padding, Widget? suffixIcon}) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: ReactiveDropdownField<String>(
          formControlName: name,
          decoration: InputDecoration(
            hintText: hint,
            labelText: text,
            suffixIcon: suffixIcon,
          ),
          items: List<DropdownMenuItem<String>>.from(
            values.entries.map((entry) {
              return DropdownMenuItem<String>(value: entry.key, child: Text(entry.value));
            }),
          ),
        ));
  }

  @override
  Widget constructInputDropdown2<X>(BuildContext context, String name, String text, String hint, Map<X, String> values, {bool readOnly = true, EdgeInsetsGeometry? padding, Widget? suffixIcon}) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: ReactiveDropdownField<X>(
          formControlName: name,
          decoration: InputDecoration(
            hintText: hint,
            labelText: text,
            suffixIcon: suffixIcon,
          ),
          items: List<DropdownMenuItem<X>>.from(
            values.entries.map((entry) {
              return DropdownMenuItem<X>(value: entry.key, child: Text(entry.value));
            }),
          ),
        ));
  }

  @override
  Widget constructInputDate(
    BuildContext context,
    String name,
    String text,
    String hint, {
    bool readOnly = true,
    EdgeInsetsGeometry? padding,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    firstDate ??= DateTime.now();
    lastDate ??= DateTime(2099, 1, 1, 0, 0);
    return ReactiveDatePicker(
      formControlName: name,
      builder: (context, picker, child) {
        return IconButton(
          onPressed: picker.showPicker,
          icon: const Icon(Icons.date_range),
        );
      },
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  @override
  Widget constructInputDateText(BuildContext context, String name, String title, String? hint, {bool readOnly = true, EdgeInsetsGeometry? padding, ReactiveFormFieldCallback? onTap, DateFormat? dateTimeFormat}) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: ReactiveTextField(
          decoration: InputDecoration(
            hintText: hint,
            labelText: title,
          ),
          valueAccessor: dateTimeFormat != null ? DateTimeValueAccessor(dateTimeFormat: dateTimeFormat) : null,
          formControlName: name,
          readOnly: readOnly,
          onTap: onTap,
          // showErrors: (control) => control.invalid || control.dirty,
        ));
  }

  @override
  Widget constructInputForm(BuildContext context, ReactiveFormGroupState state, Widget child, ReactiveFormConsumerActionsBuilder builder, {bool scrollable = true}) {
    return state.formGroup != null
        ? ReactiveForm(
            formGroup: state.formGroup!,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              scrollable
                  ? Expanded(
                      child: SingleChildScrollView(child: child),
                    )
                  : child,
              ReactiveFormConsumer(builder: (context, form, child) {
                return Row(mainAxisAlignment: MainAxisAlignment.end, children: builder(context, state));
              }),
            ]))
        : Container();
  }

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
  Widget constructInputNumber(BuildContext context, String name, String title, String? hint, {bool signed = false, bool readOnly = false, EdgeInsetsGeometry? padding, Map<String, ValidationMessageFunction>? validationMessages}) {
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
          validationMessages: validationMessages,
          // showErrors: (control) => control.invalid || control.dirty,
        ));
  }

  @override
  Widget constructInputNumberDecimal(BuildContext context, String name, String title, String? hint, {bool signed = false, bool readOnly = false, EdgeInsetsGeometry? padding, Map<String, ValidationMessageFunction>? validationMessages}) {
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
          validationMessages: validationMessages,
          // showErrors: (control) => control.invalid || control.dirty,
        ));
  }

  @override
  Widget constructInputText(BuildContext context, String name, String title, String? hint,
      {bool readOnly = false, EdgeInsetsGeometry? padding, List<String>? masks, Widget? prefixIcon, Widget? suffixIcon, ReactiveFormFieldCallback? onTap, Map<String, ValidationMessageFunction>? validationMessages}) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: ReactiveTextField(
          decoration: InputDecoration(
            hintText: hint,
            labelText: title,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
          formControlName: name,
          readOnly: readOnly,
          inputFormatters: masks != null && masks.isNotEmpty ? _iinputFormattersFromMasks(masks) : null,
          onTap: onTap,
          validationMessages: validationMessages,
          // showErrors: (control) => control.invalid || control.dirty,
        ));
  }

  @override
  Widget constructInputTextArea(BuildContext context, String name, String title, String? hint,
      {int maxLines = 5,
      int minLines = 1,
      int? maxLength = 500,
      MaxLengthEnforcement maxLengthEnforcement = MaxLengthEnforcement.enforced,
      bool readOnly = false,
      EdgeInsetsGeometry? padding,
      Map<String, ValidationMessageFunction>? validationMessages}) {
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
          validationMessages: validationMessages,
          // showErrors: (control) => control.invalid || control.dirty,
        ));
  }

  List<TextInputFormatter>? _iinputFormattersFromMasks(List<String>? masks) {
    if (masks == null) {
      return null;
    }

    List<TextInputFormatter> list = [];
    for (var item in masks) {
      list.add(TextInputMask(mask: item));
    }
    // List<TextInputFormatter> list = [];
    // for (var item in masks) {
    //   list.add(MaskTextInputFormatter(
    //     mask: item,
    //     type: MaskAutoCompletionType.lazy,
    //   ));
    // }
    return list;
  }
}
