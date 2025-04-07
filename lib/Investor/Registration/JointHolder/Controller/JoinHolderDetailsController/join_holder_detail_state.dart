import 'package:equatable/equatable.dart';

import '../../Models/join_holder_detail_response.dart';

sealed class JointHolderDetailsState extends Equatable {
  const JointHolderDetailsState();

  @override
  List<Object?> get props => [];
}

final class JointHolderDetailsInitialState extends JointHolderDetailsState {}

final class JointHolderDetailsLoadedState extends JointHolderDetailsState {
  final List<JoinHolderDetails> joinHolderList;

  const JointHolderDetailsLoadedState({
    required this.joinHolderList,
  });
}

final class JointHolderDetailsLoadingState extends JointHolderDetailsState {}

final class JointHolderDetailsErrorState extends JointHolderDetailsState {
  final String errorMessage;

  const JointHolderDetailsErrorState({
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [];
}
