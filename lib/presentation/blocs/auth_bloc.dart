import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/authenticate_user.dart';

// State
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSubmitted extends AuthEvent {
  final String username;
  final String password;

  const AuthSubmitted(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticateUser authenticateUser;

  AuthBloc(this.authenticateUser) : super(AuthInitial()) {
    on<AuthSubmitted>(_onAuthSubmitted);
  }

  Future<void> _onAuthSubmitted(
      AuthSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final isAuthenticated =
          await authenticateUser(event.username, event.password);
      if (isAuthenticated) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure('Incorrect passcode. Please try again.'));
      }
    } catch (error) {
      emit(AuthFailure('Failed to authenticate. Please try again later.'));
      print('Authentication error: $error');
    }
  }
}
