import 'package:equatable/equatable.dart';

import 'package:reactive_forms/reactive_forms.dart';

class ReactiveFormGroupWithObjectState<X> extends ReactiveFormGroupState {
  final X? object;
  const ReactiveFormGroupWithObjectState(super.formGroup, this.object);

  @override
  List<Object?> get props => [formGroup, object];
}

class ReactiveFormGroupState extends Equatable {
  final FormGroup? formGroup;
  const ReactiveFormGroupState(this.formGroup);

  @override
  List<Object?> get props => [formGroup];
}
