import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:flutterd/repositories/repository.dart';
import 'package:flutterd_logging_wrapper/logging.dart';

import 'package:flutterd_reactive_form_bloc/blocs/form/reactive_form_state.dart';

abstract class ReactiveFormBloc<X, U extends Repository> extends Cubit<ReactiveFormState<X>> {
  final BuildContext context;
  final String? identifier;
  final U repository;
  ReactiveFormBloc(this.context, this.identifier, this.repository) : super(ReactiveFormState<X>(null, null)) {
    init();
  }

  FormGroup initForm();

  init() {
    FormGroup form = initForm();
    emit(ReactiveFormState(form, state.object));

    Future.delayed(const Duration(milliseconds: 50), () {
      loading();
    });
  }

  Future<void> loading();

  submit() async {
    if (!state.formGroup!.dirty) {
      return;
    }
    if (state.object == null) {
      return;
    }

    try {
      if (await submitSave(state.object)) {
        await submitUpdate(state.object);
      }
    } catch (ex) {
      Logger().e('ReactiveFormBloc', 'submit', ex);
    }
  }

  Future<bool> submitSave(X? object);
  Future<void> submitUpdate(X? object) async {
    emit(ReactiveFormState(state.formGroup, object));
  }
}
