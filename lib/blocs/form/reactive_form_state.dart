import 'package:reactive_forms/reactive_forms.dart';

class ReactiveFormState<X> {
  final FormGroup? formGroup;
  final X? object;
  ReactiveFormState(this.formGroup, this.object);
}
