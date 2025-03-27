import 'package:equatable/equatable.dart';
import 'package:mymfbox2_0/Investor/Registration/RegistrationSuccessful/Model/nominee_auth_response.dart';

sealed class AuthenticateNomineeState extends Equatable {
  const AuthenticateNomineeState();

  @override
  List<Object?> get props => [];
}

final class AuthenticateNomineeInitialState extends AuthenticateNomineeState {}

final class AuthenticateNomineeLoadedState extends AuthenticateNomineeState {
  final AuthDetails authDetails;

  const AuthenticateNomineeLoadedState({
    required this.authDetails,
  });
}

final class AuthenticateNomineeLoadingState extends AuthenticateNomineeState {}

final class AuthenticateNomineeErrorState extends AuthenticateNomineeState {
  final String errorMessage;

  const AuthenticateNomineeErrorState({
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [];
}
