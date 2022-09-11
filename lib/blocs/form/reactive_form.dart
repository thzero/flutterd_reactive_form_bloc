import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:flutterd/repositories/repository.dart';
import 'package:flutterd_logging_wrapper/logging.dart';

import 'package:flutterd_reactive_form_bloc/blocs/form/reactive_form_state.dart';

abstract class RepositoryReactiveFormBloc<Y extends ReactiveFormEvent, X, U extends Repository> extends ReactiveFormBloc<Y, X> {
  final U repository;
  RepositoryReactiveFormBloc(BuildContext context, String? identifier, this.repository) : super(context, identifier);
}

abstract class ReactiveFormEvent extends Equatable {}

class FormUpdateReactiveFormEvent extends ReactiveFormEvent {
  final FormGroup form;
  FormUpdateReactiveFormEvent(this.form);

  @override
  List<Object> get props => [];
}

abstract class ReactiveFormBloc<Y extends ReactiveFormEvent, X> extends Bloc<Y, ReactiveFormState<X>> {
  final BuildContext context;
  final String? identifier;
  final Map<String, AbstractControl<dynamic>> _controls = {};

  ReactiveFormBloc(this.context, this.identifier) : super(ReactiveFormState<X>(null, null)) {
    init();
  }

  FutureOr<void> handleFormUpdate(FormUpdateReactiveFormEvent event, Emitter<ReactiveFormState<X>> emit) async {
    try {
      // await m.acquire();
      emit(ReactiveFormState(event.form, state.object));
    } on Exception {
      Logger().eM('ReactiveFormBloc', 'handleUpdate', 'Error');
    }
    // finally {
    //   m.release();
    // }
  }

  init() {
    _controls.clear();

    initFormControls(_controls);
    FormGroup form = initForm(_controls);
    initFormGroupSupplemental(form, _controls);
    // emit(ReactiveFormState(form, state.object));

    Future.delayed(const Duration(milliseconds: 50), () {
      loading();
    });
  }

  FormGroup initForm(Map<String, AbstractControl<dynamic>> controls) {
    return FormGroup(controls);
  }

  initFormControls(Map<String, AbstractControl<dynamic>> controls);

  initFormGroupSupplemental(FormGroup form, Map<String, AbstractControl<dynamic>> controls) {}

  Future<void> loading();

  reset() async {
    for (String key in _controls.keys) {
      updateValue(key, null);
    }
  }

  save() async {
    if (!state.formGroup!.dirty) {
      return;
    }
    if (state.object == null) {
      return;
    }

    try {
      if (await saveUpdate(state.object)) {
        await saveUpdateState(state.object);
      }
    } catch (ex) {
      Logger().e('ReactiveFormBloc', 'save', ex);
    }
  }

  submit() async {
    try {
      await submitUpdate(state.object);
    } catch (ex) {
      Logger().e('ReactiveFormBloc', 'submit', ex);
    }
  }

  Future<bool> saveUpdate(X? object) async {
    return true;
  }

  Future<bool> submitUpdate(X? object) async {
    return true;
  }

  Future<void> saveUpdateState(X? object) async {
    emit(ReactiveFormState(state.formGroup, object));
  }

  updateValue(String name, dynamic value) {
    var control = state.formGroup!.control(name);
    var value2 = control.value;
    control.updateValue(value);
    if (control.value != value2) {
      control.markAsDirty();
    }
  }
}

abstract class RepositoryReactiveFormCubit<X, U extends Repository> extends ReactiveFormCubit<X> {
  final U repository;
  RepositoryReactiveFormCubit(BuildContext context, String? identifier, this.repository) : super(context, identifier);
}

abstract class ReactiveFormCubit<X> extends Cubit<ReactiveFormState<X>> {
  final BuildContext context;
  final String? identifier;
  final Map<String, AbstractControl<dynamic>> _controls = {};

  ReactiveFormCubit(this.context, this.identifier) : super(ReactiveFormState<X>(null, null)) {
    init();
  }

  init() {
    _controls.clear();

    initFormControls(_controls);
    FormGroup form = initForm(_controls);
    initFormGroupSupplemental(form, _controls);
    emit(ReactiveFormState(form, state.object));

    Future.delayed(const Duration(milliseconds: 50), () {
      loading();
    });
  }

  FormGroup initForm(Map<String, AbstractControl<dynamic>> controls) {
    return FormGroup(controls);
  }

  initFormControls(Map<String, AbstractControl<dynamic>> controls);

  initFormGroupSupplemental(FormGroup form, Map<String, AbstractControl<dynamic>> controls) {}

  Future<void> loading();

  reset() async {
    for (String key in _controls.keys) {
      updateValue(key, null);
    }
  }

  save() async {
    if (!state.formGroup!.dirty) {
      return;
    }
    if (state.object == null) {
      return;
    }

    try {
      if (await saveUpdate(state.object)) {
        await saveUpdateState(state.object);
      }
    } catch (ex) {
      Logger().e('ReactiveFormBloc', 'save', ex);
    }
  }

  submit() async {
    try {
      await submitUpdate(state.object);
    } catch (ex) {
      Logger().e('ReactiveFormBloc', 'submit', ex);
    }
  }

  Future<bool> saveUpdate(X? object) async {
    return true;
  }

  Future<bool> submitUpdate(X? object) async {
    return true;
  }

  Future<void> saveUpdateState(X? object) async {
    emit(ReactiveFormState(state.formGroup, object));
  }

  updateValue(String name, dynamic value) {
    var control = state.formGroup!.control(name);
    var value2 = control.value;
    control.updateValue(value);
    if (control.value != value2) {
      control.markAsDirty();
    }
  }
}
