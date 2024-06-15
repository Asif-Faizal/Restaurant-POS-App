import 'package:equatable/equatable.dart';
import '../../../data/models/extras_model.dart';

abstract class ExtraState extends Equatable {
  const ExtraState();

  @override
  List<Object> get props => [];
}

class ExtraLoading extends ExtraState {}

class ExtraLoaded extends ExtraState {
  final List<Extra> extras;

  const ExtraLoaded(this.extras);

  @override
  List<Object> get props => [extras];
}

class ExtraError extends ExtraState {
  final String message;

  const ExtraError(this.message);

  @override
  List<Object> get props => [message];
}
