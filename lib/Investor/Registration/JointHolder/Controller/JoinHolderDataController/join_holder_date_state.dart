import 'package:equatable/equatable.dart';
import 'package:mymfbox2_0/pojo/JointHolderPojo.dart';

class JoinHoldersDataState extends Equatable {
  final List<JointHolderPojo> jointHolderList;

  const JoinHoldersDataState({
    required this.jointHolderList,
  });

  @override
  List<Object?> get props => [jointHolderList];
}
