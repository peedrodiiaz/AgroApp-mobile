import 'package:agroapp_mobile/core/utils/token_manager.dart';
import 'package:agroapp_mobile/data/models/auth_response.dart';
import 'package:agroapp_mobile/data/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final TokenManager _tokenManager;

  AuthBloc({
    required AuthRepository authRepository,
    required TokenManager tokenManager,
  }) : _authRepository = authRepository,
        _tokenManager = tokenManager,
        super(AuthInitial()) {
          
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      
      final authResponse = await _authRepository.login(
        email: event.email,
        password: event.password,
      );
      await _tokenManager.saveToken(authResponse.token);
      await _tokenManager.saveRefreshToken(authResponse.refreshToken);

      emit(AuthAuthenticated(authResponse));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

    Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _tokenManager.deleteTokens();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final hasToken = await _tokenManager.hasToken();
    // Asi es para ver si hay un inicio de sesion
    if (hasToken) {
      final token = await _tokenManager.getToken();
      final refreshToken = await _tokenManager.getRefreshToken();
      
      emit(AuthAuthenticated(
        AuthResponse(
          token: token ?? '',
          refreshToken: refreshToken ?? '',
        ),
      ));
    } else {
      emit(AuthUnauthenticated());
    }
  }


}



