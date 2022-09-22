import 'package:equatable/equatable.dart';

import 'package:reactive_forms/reactive_forms.dart';

class ReactiveFormGroupWithObjectState<X> extends ReactiveFormGroupState {
  final X? object;
  const ReactiveFormGroupWithObjectState(super.formGroup, this.object, super.isNew);

  @override
  List<Object?> get props => [formGroup, object, isNew];
}

class ReactiveFormGroupState extends Equatable {
  final FormGroup? formGroup;
  final bool isNew;
  const ReactiveFormGroupState(this.formGroup, this.isNew);

  @override
  List<Object?> get props => [formGroup, isNew];
}
