import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:flutterd/repositories/repository.dart';
import 'package:flutterd_logging_wrapper/logging.dart';

import 'package:flutterd_reactive_form_bloc/blocs/form/reactive_form_state.dart';

abstract class RepositoryReactiveFormBloc<X extends ReactiveFormGroupState, U extends Repository> extends ReactiveFormGroupBloc<X> {
  final U repository;
  RepositoryReactiveFormBloc(BuildContext context, String? identifier, this.repository, X state) : super(context, identifier, state);
}

abstract class ReactiveFormEvent extends Equatable {}

class FormUpdateReactiveFormGroupEvent extends ReactiveFormEvent {
  final FormGroup form;
  final bool initial;
  FormUpdateReactiveFormGroupEvent(this.form, this.initial);

  @override
  List<Object> get props => [];
}

abstract class ReactiveFormGroupBloc<X extends ReactiveFormGroupState> extends Bloc<ReactiveFormEvent, X> {
  final BuildContext context;
  final String? identifier;
  final Map<String, AbstractControl<dynamic>> _controls = {};

  ReactiveFormGroupBloc(this.context, this.identifier, X state) : super(state) {
    on<FormUpdateReactiveFormGroupEvent>(_handleFormUpdate);
    init();
  }

  X initStateWithFormGroup(FormGroup formGroup);

  FutureOr<void> _handleFormUpdate(FormUpdateReactiveFormGroupEvent event, Emitter<X> emit) async {
    try {
      // await m.acquire();
      emit(initStateWithFormGroup(event.form));
      if (event.initial) {
        await loading();
      }
    } on Exception {
      Logger().eM('ReactiveFormBloc', '_handleFormUpdate', 'Error');
    }
    // finally {
    //   m.release();
    // }
  }

  init() {
    try {
      _controls.clear();

      initFormControls(_controls);
      FormGroup form = initForm(_controls);
      initFormGroupSupplemental(form, _controls);
      // emit(ReactiveFormState(form, state.object));
      // add(FormUpdateReactiveFormEvent(form, true));

      Future.delayed(const Duration(milliseconds: 50), () {
        add(FormUpdateReactiveFormGroupEvent(form, true));
        // loading();
      });
    } catch (ex) {
      Logger().e(runtimeType.toString(), 'loading', ex);
    }
  }

  FormGroup initForm(Map<String, AbstractControl<dynamic>> controls) {
    return FormGroup(controls);
  }

  initFormControls(Map<String, AbstractControl<dynamic>> controls);

  initFormGroupSupplemental(FormGroup form, Map<String, AbstractControl<dynamic>> controls) {}

  Future<void> loading();

  reset() async {
    try {
      for (String key in _controls.keys) {
        updateValue(key, null);
      }
    } catch (ex) {
      Logger().e(runtimeType.toString(), 'reset', ex);
    }
  }

  save() async {
    if (state.formGroup == null || !state.formGroup!.dirty) {
      return;
    }

    try {
      if (await saveUpdate(state)) {
        await saveUpdateState(state);
        state.formGroup!.markAsPristine();
        state.formGroup!.markAsUntouched();
      }
    } catch (ex) {
      Logger().e(runtimeType.toString(), 'save', ex);
    }
  }

  Future<bool> saveUpdate(X state) async {
    return true;
  }

  Future<void> saveUpdateState(X state) async {
    if (state.formGroup != null) {
      add(FormUpdateReactiveFormGroupEvent(state.formGroup!, false));
    }
  }

  Future<bool> submitUpdate(X state) async {
    return true;
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

abstract class RepositoryReactiveFormGroupWithObjectCubit<X, U extends Repository> extends ReactiveFormGroupWithObjectCubit<X> {
  final U repository;
  RepositoryReactiveFormGroupWithObjectCubit(BuildContext context, String? identifier, this.repository) : super(context, identifier);
}

abstract class ReactiveFormGroupWithObjectCubit<X> extends Cubit<ReactiveFormGroupWithObjectState<X>> {
  final BuildContext context;
  final String? identifier;
  final Map<String, AbstractControl<dynamic>> _controls = {};

  ReactiveFormGroupWithObjectCubit(this.context, this.identifier) : super(ReactiveFormGroupWithObjectState<X>(null, null)) {
    init();
  }

  init() {
    _controls.clear();

    initFormControls(_controls);
    FormGroup form = initForm(_controls);
    initFormGroupSupplemental(form, _controls);
    emit(ReactiveFormGroupWithObjectState(form, state.object));

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
    try {
      for (String key in _controls.keys) {
        updateValue(key, null);
      }
    } catch (ex) {
      Logger().e(runtimeType.toString(), 'reset', ex);
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
      Logger().e(runtimeType.toString(), 'save', ex);
    }
  }

  submit() async {
    try {
      await submitUpdate(state.object);
    } catch (ex) {
      Logger().e(runtimeType.toString(), 'submit', ex);
    }
  }

  Future<bool> saveUpdate(X? object) async {
    return true;
  }

  Future<void> saveUpdateState(X? object) async {
    emit(ReactiveFormGroupWithObjectState(state.formGroup, object));
  }

  Future<bool> submitUpdate(X? object) async {
    return true;
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

abstract class RepositoryReactiveFormGroupCubit<U extends Repository> extends ReactiveFormGroupCubit {
  final U repository;
  RepositoryReactiveFormGroupCubit(BuildContext context, String? identifier, this.repository) : super(context, identifier);
}

abstract class ReactiveFormGroupCubit extends Cubit<ReactiveFormGroupState> {
  final BuildContext context;
  final String? identifier;
  final Map<String, AbstractControl<dynamic>> _controls = {};

  ReactiveFormGroupCubit(this.context, this.identifier) : super(const ReactiveFormGroupState(null)) {
    init();
  }

  init() {
    _controls.clear();

    initFormControls(_controls);
    FormGroup form = initForm(_controls);
    initFormGroupSupplemental(form, _controls);
    emit(ReactiveFormGroupState(form));

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
    try {
      for (String key in _controls.keys) {
        updateValue(key, null);
      }
    } catch (ex) {
      Logger().e(runtimeType.toString(), 'reset', ex);
    }
  }

  save() async {
    if (!state.formGroup!.dirty) {
      return;
    }

    try {
      if (await saveUpdate(state)) {
        await saveUpdateState(state);
      }
    } catch (ex) {
      Logger().e(runtimeType.toString(), 'save', ex);
    }
  }

  submit() async {
    try {
      await submitUpdate(state);
    } catch (ex) {
      Logger().e(runtimeType.toString(), 'submit', ex);
    }
  }

  Future<bool> saveUpdate(ReactiveFormGroupState state) async {
    return true;
  }

  Future<void> saveUpdateState(ReactiveFormGroupState state) async {
    if (state.formGroup != null) {
      emit(ReactiveFormGroupState(state.formGroup!));
    }
  }

  Future<bool> submitUpdate(ReactiveFormGroupState state) async {
    return true;
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
