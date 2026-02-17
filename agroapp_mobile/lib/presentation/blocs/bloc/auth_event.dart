part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({
    required this.username,
    required this.password,
  });


}
// Para cerrar sesión
class LogoutRequested extends AuthEvent {}
// para ver si hay un inicio de sesion ua hecho
class CheckAuthStatus extends AuthEvent {}
