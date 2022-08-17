// // import 'dart:typed_data';

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // // import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// // // import 'package:image_picker/image_picker.dart';
// // import 'package:flutter_form_bloc/flutter_form_bloc.dart';

// import 'package:flutterd/ui/mixins/material/platform.dart';
// import 'package:flutterd/ui/mixins/platform.dart';

// mixin MaterialReactiveFormInputPlatformMixin on InputPlatformMixin, MaterialPlatformMixin {
// //   @override
// //   Widget constructInputCheckbox<T extends BooleanFieldBloc<dynamic>>(BuildContext context, T value, String title, {bool readOnly = true}) {
// //     return CheckboxFieldBlocBuilder(
// //       booleanFieldBloc: value,
// //       isEnabled: readOnly,
// //       body: Text(title),
// //     );
// //   }

// //   @override
// //   Widget constructInputColor<T extends InputFieldBloc<Color?, dynamic>>(BuildContext context, T value, String title, String? hint, {bool signed = false, bool readOnly = false}) {
// //     return ColorFieldBlocBuilder(
// //       colorFieldBloc: value,
// //       decoration: InputDecoration(labelText: title, hintText: hint),
// //       animateWhenCanShow: false,
// //       colorPicker: (BuildContext? context, Color? initial) {
// //         return showDialogColor(context!, colors: colors, previous: initial!);
// //       },
// //       initialColor: Colors.transparent,
// //     );
// //   }

// //   @override
// //   Widget constructInputDropdown<T extends ValueItemSelectFieldBloc<String, String, dynamic>>(BuildContext context, T value, String text, String hint, {bool readOnly = true}) {
// //     return ValueItemDropdownFieldBlocBuilder<String, String>(
// //       selectFieldBloc: value,
// //       decoration: InputDecoration(
// //         // filled: true,
// //         hintText: hint,
// //         labelText: text,
// //       ),
// //       itemBuilder: (context, value) => FieldItem(
// //         child: Text(value),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget constructInputImage<T extends InputFieldBloc<Uint8List?, dynamic>>(BuildContext context, T value, String title, String? hint, {bool signed = false, bool readOnly = false}) {
// //     return ImageFieldBlocBuilder(
// //       imageFieldBloc: value,
// //       decoration: InputDecoration(labelText: title, hintText: hint),
// //       animateWhenCanShow: false,
// //       imagePicker: (BuildContext? context, Uint8List? initial) {
// //         return showDialogImage(context!, previous: initial!);
// //       },
// //       initialImage: null,
// //     );
// //   }

// //   @override
// //   Widget constructInputNumber<T extends TextFieldBloc<dynamic>>(BuildContext context, T value, String title, String? hint, {bool signed = false, bool readOnly = false}) {
// //     return TextFieldBlocBuilder(
// //       textFieldBloc: value,
// //       readOnly: readOnly,
// //       keyboardType: TextInputType.numberWithOptions(signed: signed, decimal: false),
// //       decoration: InputDecoration(labelText: title, hintText: hint),
// //     );
// //   }

// //   @override
// //   Widget constructInputNumberDecimal<T extends TextFieldBloc<dynamic>>(BuildContext context, T value, String title, String? hint, {bool signed = false, bool readOnly = false}) {
// //     return TextFieldBlocBuilder(
// //       textFieldBloc: value,
// //       readOnly: readOnly,
// //       keyboardType: TextInputType.numberWithOptions(signed: signed, decimal: true),
// //       decoration: InputDecoration(labelText: title, hintText: hint),
// //     );
// //   }

// //   @override
// //   Widget constructInputText<T extends TextFieldBloc<dynamic>>(BuildContext context, T value, String title, String? hint, {bool readOnly = false}) {
// //     return TextFieldBlocBuilder(
// //       textFieldBloc: value,
// //       readOnly: readOnly,
// //       decoration: InputDecoration(labelText: title, hintText: hint),
// //     );
// //   }

// //   @override
// //   Widget constructInputTextArea<T extends TextFieldBloc<dynamic>>(BuildContext context, T value, String title, String? hint,
// //       {int maxLines = 5, int minLines = 1, int? maxLength = 500, MaxLengthEnforcement maxLengthEnforced = MaxLengthEnforcement.enforced, bool readOnly = false}) {
// //     return TextFieldBlocBuilder(
// //       textFieldBloc: value,
// //       maxLines: maxLines,
// //       minLines: minLines,
// //       maxLength: maxLength,
// //       maxLengthEnforced: maxLengthEnforced,
// //       readOnly: readOnly,
// //       decoration: InputDecoration(labelText: title, hintText: hint),
// //     );
// //   }
// }
