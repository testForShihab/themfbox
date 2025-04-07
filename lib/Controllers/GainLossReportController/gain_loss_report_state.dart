import 'package:equatable/equatable.dart';
import 'package:mymfbox2_0/pojo/gain_loss_report_response.dart';

sealed class GainLossState extends Equatable {
  const GainLossState();

  @override
  List<Object?> get props => [];
}

final class GainLossInitialState extends GainLossState {}

final class GainLossLoadedState extends GainLossState {
  final GainLossDetails result;
  final List<String>? financialYears;
  final String? selectedFinancialYear;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isDebtSelected;
  final bool isDownloadingPdf;

  const GainLossLoadedState({
    required this.result,
    this.financialYears,
    this.selectedFinancialYear = '',
    this.startDate,
    this.endDate,
    this.isDebtSelected = false,
    this.isDownloadingPdf = false,
  });

  GainLossLoadedState copyWith({
    GainLossDetails? result,
    List<String>? financialYears,
    String? selectedFinancialYear,
    DateTime? startDate,
    DateTime? endDate,
    bool? isDebtSelected,
    bool? isDownloadingPdf,
  }) =>
      GainLossLoadedState(
        result: result ?? this.result,
        financialYears: financialYears ?? this.financialYears,
        selectedFinancialYear:
            selectedFinancialYear ?? this.selectedFinancialYear,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        isDebtSelected: isDebtSelected ?? this.isDebtSelected,
        isDownloadingPdf: isDownloadingPdf ?? this.isDownloadingPdf,
      );

  @override
  List<Object?> get props => [
        result,
        financialYears,
        selectedFinancialYear,
        startDate,
        endDate,
        isDebtSelected,
        isDownloadingPdf
      ];
}

final class GainLossLoadingState extends GainLossState {}

final class GainLossErrorState extends GainLossState {
  final String errorMessage;

  const GainLossErrorState({
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [];
}
