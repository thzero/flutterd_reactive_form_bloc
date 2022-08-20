import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:reactive_forms/reactive_forms.dart';

import 'package:flutterd_reactive_form_bloc/blocs/form/reactive_form_state.dart';

typedef ReactiveFormConsumerActionsBuilder = List<Widget> Function(BuildContext context, ReactiveFormState state);

mixin InputPlatformMixin {
  Widget constructInputCheckbox(BuildContext context, String name, String title, {bool readOnly = false, EdgeInsetsGeometry? padding});
  Widget constructInputColor(BuildContext context, String name, {bool readOnly = false, EdgeInsetsGeometry? padding});
  Widget constructInputDate(
    BuildContext context,
    String name,
    String text,
    String hint, {
    bool readOnly = true,
    EdgeInsetsGeometry? padding,
    DateTime? firstDate,
    DateTime? lastDate,
  });
  Widget constructInputDropdown(BuildContext context, String name, String text, String hint, Map<String, String> values, {bool readOnly = true, EdgeInsetsGeometry? padding});
  Widget constructInputForm(BuildContext context, ReactiveFormState state, Widget child, ReactiveFormConsumerActionsBuilder builder, {bool scrollable = true});
  Widget constructInputImage(BuildContext context, String name, String title, String? hint, {bool readOnly = false});
  Widget constructInputNumber(BuildContext context, String name, String title, String? hint, {bool signed = false, bool readOnly = false, EdgeInsetsGeometry? padding});
  Widget constructInputNumberDecimal(BuildContext context, String name, String title, String? hint, {bool signed = false, bool readOnly = false, EdgeInsetsGeometry? padding});
  Widget constructInputText(BuildContext context, String name, String title, String? hint, {bool readOnly = false, EdgeInsetsGeometry? padding, List<String>? masks});
  Widget constructInputTextArea(BuildContext context, String name, String title, String? hint,
      {int maxLines = 5, int minLines = 1, int? maxLength = 500, MaxLengthEnforcement maxLengthEnforcement = MaxLengthEnforcement.enforced, bool readOnly = false, EdgeInsetsGeometry? padding});

  static ValidatorFunction numeric({bool decimal = false, bool signed = false}) => NumericValidator(decimal: decimal, signed: signed).validate;
  static ValidatorFunction max<T>(T max) => NumericMaxValidator<T>(max).validate;
  static ValidatorFunction min<T>(T max) => NumericMinValidator<T>(max).validate;
}

class NumericMaxValidator<T> extends Validator<dynamic> {
  final T max;

  /// Constructs the instance of the validator.
  ///
  /// The argument [max] must not be null.
  NumericMaxValidator(this.max);

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final error = {
      ValidationMessage.max: <String, dynamic>{
        'max': max,
        'actual': control.value,
      },
    };

    if (control.value == null) {
      return null;
    }

    assert(control.value is Comparable<dynamic>, 'The MaxValidator validator is expecting a control of type `Comparable` but received a control of type ${control.value.runtimeType}');

    final comparableValue = control.value as Comparable<dynamic>;
    return comparableValue.compareTo(max) <= 0 ? null : error;
  }
}

class NumericMinValidator<T> extends Validator<dynamic> {
  final T min;

  /// Constructs the instance of the validator.
  ///
  /// The argument [min] must not be null.
  NumericMinValidator(this.min);

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final error = {
      ValidationMessage.min: <String, dynamic>{
        'min': min,
        'actual': control.value,
      },
    };

    if (control.value == null) {
      return null;
    }

    assert(control.value is Comparable<dynamic>, 'The MinValidator validator is expecting a control of type `Comparable` but received a control of type ${control.value.runtimeType}');

    final comparableValue = control.value as Comparable<dynamic>;
    return comparableValue.compareTo(min) >= 0 ? null : error;
  }
}

/// Validator that validates if control's value is a numeric value.
class NumericValidator extends Validator<dynamic> {
  final bool decimal;
  final bool signed;
  NumericValidator({this.decimal = false, this.signed = false}) {
    if (decimal && signed) {
      numberRegex = RegExp(r'^-?[0-9\.\,]+$');
    } else if (!decimal && signed) {
      numberRegex = RegExp(r'^-?[0-9\,]+$');
    } else if (decimal && !signed) {
      numberRegex = RegExp(r'^[0-9\.\,]+$');
    } else {
      numberRegex = RegExp(r'^[0-9\,]+$');
    }
  }

  /// The regex expression of a numeric string value.
  late RegExp numberRegex;

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    if (control.value == null) {
      return null;
    }

    return !numberRegex.hasMatch(control.value.toString()) ? <String, dynamic>{ValidationMessage.number: true} : null;
  }
}
