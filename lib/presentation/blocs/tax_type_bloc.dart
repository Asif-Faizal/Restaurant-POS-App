import 'package:flutter_bloc/flutter_bloc.dart';

// Define the events
abstract class TaxTypeEvent {}

class ToggleTaxType extends TaxTypeEvent {}

// Define the states
abstract class TaxTypeState {}

class InclusiveTax extends TaxTypeState {}

class ExclusiveTax extends TaxTypeState {}

// Create the Bloc
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
