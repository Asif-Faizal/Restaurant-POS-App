import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TaxTypeEvent {}

class ToggleTaxType extends TaxTypeEvent {}

abstract class TaxTypeState {}

class InclusiveTax extends TaxTypeState {}

class ExclusiveTax extends TaxTypeState {}

class TaxTypeBloc extends Bloc<TaxTypeEvent, TaxTypeState> {
  TaxTypeBloc() : super(InclusiveTax()) {
    on<ToggleTaxType>((event, emit) {
      if (state is InclusiveTax) {
        emit(ExclusiveTax());
      } else {
        emit(InclusiveTax());
      }
    });
  }
}
