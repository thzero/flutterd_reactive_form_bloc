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
  RepositoryReactiveFormBloc(BuildContext? context, String? identifier, this.repository, X state) : super(context, identifier, state);
}

abstract class ReactiveFormEvent extends Equatable {}

class FormLoadReactiveFormGroupEvent extends ReactiveFormEvent {
  final FormGroup form;
  final bool initial;
  FormLoadReactiveFormGroupEvent(this.form, this.initial);

  @override
  List<Object> get props => [];
}

class FormLoadedReactiveFormGroupEvent extends ReactiveFormEvent {
  final bool isNew;
  FormLoadedReactiveFormGroupEvent(this.isNew);

  @override
  List<Object> get props => [];
}

class FormSavedReactiveFormGroupEvent extends ReactiveFormEvent {
  FormSavedReactiveFormGroupEvent();

  @override
  List<Object> get props => [];
}

abstract class ReactiveFormGroupBloc<X extends ReactiveFormGroupState> extends Bloc<ReactiveFormEvent, X> {
  final BuildContext? context;
  bool initialized = false;
  final String? identifier;
  final Map<String, AbstractControl<dynamic>> _controls = {};

  ReactiveFormGroupBloc(this.context, this.identifier, X state) : super(state) {
    on<FormLoadReactiveFormGroupEvent>(_handleFormLoad);
    on<FormLoadedReactiveFormGroupEvent>(_handleFormLoaded);
    on<FormSavedReactiveFormGroupEvent>(_handleFormSaved);
    init();
  }

  X initStateWith({FormGroup? formGroup, bool? isNew});

  FutureOr<void> _handleFormLoad(FormLoadReactiveFormGroupEvent event, Emitter<X> emit) async {
    try {
      // await m.acquire();
      emit(initStateWith(formGroup: event.form));
      if (event.initial) {
        bool isNew = await loading();
        add(FormLoadedReactiveFormGroupEvent(isNew));
        initialized = true;
      }
    } on Exception {
      Logger().eM('ReactiveFormBloc', '_handleFormLoad', 'Error');
    }
    // finally {
    //   m.release();
    // }
  }

  FutureOr<void> _handleFormLoaded(FormLoadedReactiveFormGroupEvent event, Emitter<X> emit) async {
    try {
      // await m.acquire();
      emit(initStateWith(isNew: event.isNew));
    } on Exception {
      Logger().eM('ReactiveFormBloc', '_handleFormLoaded', 'Error');
    }
    // finally {
    //   m.release();
    // }
  }

  FutureOr<void> _handleFormSaved(FormSavedReactiveFormGroupEvent event, Emitter<X> emit) async {
    try {
      // await m.acquire();
      emit(initStateWith());
    } on Exception {
      Logger().eM('ReactiveFormBloc', '_handleFormSaved', 'Error');
    }
    // finally {
    //   m.release();
    // }
  }

  init() {
    try {
      _controls.clear();

      initialized = false;

      initFormControls(_controls);
      FormGroup form = initForm(_controls);
      initFormGroupSupplemental(form);

      Future.delayed(const Duration(milliseconds: 50), () {
        add(FormLoadReactiveFormGroupEvent(form, true));
      });
    } catch (ex) {
      Logger().e(runtimeType.toString(), 'loading', ex);
    }
  }

  FormGroup initForm(Map<String, AbstractControl<dynamic>> controls) {
    return FormGroup(controls);
  }

  initFormControls(Map<String, AbstractControl<dynamic>> controls);

  initFormGroupSupplemental(FormGroup form) {}

  Future<bool> loading();

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
        emit(initStateWith(isNew: false));
      }
    } catch (ex) {
      Logger().e(runtimeType.toString(), 'save', ex);
    }
  }

  Future<bool> saveUpdate(X state) async {
    return true;
  }

  Future<void> saveUpdateState(X state) async {
    // if (state.formGroup != null) {
    //   add(FormSavedReactiveFormGroupEvent(state.formGroup!, false));
    // }
    add(FormSavedReactiveFormGroupEvent());
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
  bool initialized = false;

  ReactiveFormGroupWithObjectCubit(this.context, this.identifier) : super(ReactiveFormGroupWithObjectState<X>(null, null, false)) {
    init();
  }

  init() {
    _controls.clear();

    initialized = false;

    initFormControls(_controls);
    FormGroup form = initForm(_controls);
    initFormGroupSupplemental(form);
    emit(ReactiveFormGroupWithObjectState(form, state.object, false));

    Future.microtask(() async {
      await loading();
      Future.delayed(const Duration(milliseconds: 50), () {
        initialized = true;
      });
    });
  }

  FormGroup initForm(Map<String, AbstractControl<dynamic>> controls) {
    return FormGroup(controls);
  }

  initFormControls(Map<String, AbstractControl<dynamic>> controls);

  initFormGroupSupplemental(FormGroup form) {}

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
        emit(ReactiveFormGroupWithObjectState(state.formGroup, state.object, false));
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
    emit(ReactiveFormGroupWithObjectState(state.formGroup, object, false));
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

  ReactiveFormGroupCubit(this.context, this.identifier) : super(const ReactiveFormGroupState(null, false)) {
    init();
  }

  init() {
    _controls.clear();

    initFormControls(_controls);
    FormGroup form = initForm(_controls);
    initFormGroupSupplemental(form);
    emit(ReactiveFormGroupState(form, false));

    Future.delayed(const Duration(milliseconds: 50), () {
      loading();
    });
  }

  FormGroup initForm(Map<String, AbstractControl<dynamic>> controls) {
    return FormGroup(controls);
  }

  initFormControls(Map<String, AbstractControl<dynamic>> controls);

  initFormGroupSupplemental(FormGroup form) {}

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
        emit(ReactiveFormGroupState(state.formGroup, false));
      }
    } catch (ex) {
      Logger().e(runtimeType.toString(), 'save', ex);
    }
  }

  Future<bool> saveUpdate(ReactiveFormGroupState state) async {
    return true;
  }

  Future<void> saveUpdateState(ReactiveFormGroupState state) async {
    if (state.formGroup != null) {
      emit(ReactiveFormGroupState(state.formGroup!, false));
    }
  }

  submit() async {
    try {
      await submitUpdate(state);
    } catch (ex) {
      Logger().e(runtimeType.toString(), 'submit', ex);
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
