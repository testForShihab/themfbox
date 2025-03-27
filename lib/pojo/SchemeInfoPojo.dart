class SchemeInfoPojo {
  num? status;
  String? statusMsg;
  String? msg;
  String? schemeName;
  String? schemeAmfiCode;
  num? nav;
  String? navDate;
  num? navChange;
  num? navChangePercentage;
  num? schemeInceptionReturn;
  num? benchmarkInceptionReturn;
  String? schemeObjective;
  String? schemeManager;
  String? schemeManagerBiography;
  String? riskometerValue;
  String? riskometerImage;
  String? isinNo;
  String? isinDivreinvstNo;
  String? amcLogo;
  String? schemeCategory;
  String? schemeCompany;
  String? schemeCompanyShortName;
  String? schemeInceptionDate;
  String? assetClass;
  String? schemeBenchmark;
  String? schemeBenchmarkCode;
  num? expenseRatioPercentage;
  String? expenseRatioDate;
  String? schemeStatus;
  num? minimumInvestment;
  num? minimumTopup;
  num? schemeAssets;
  String? schemeAssetDate;
  String? schemeTurnover;
  bool? isDividendScheme;
  String? volatility;
  String? schemeSipStartDate;
  String? schemeSipEndDate;
  String? schemeLumpsumStartDate;
  List<SchemePerformanceList>? schemePerformanceList;
  List<RiskStatisticsList>? riskStatisticsList;
  List<SchemePeerComparisionList>? schemePeerComparisionList;
  SchemeMapping? schemeMapping;
  SchemePerformances? schemePerformances;
  List<PeerComparisonResponse>? peerComparisonResponse;
  String? dividendList;
  String? assetAllocationList;
  String? marketCapList;
  FundPerformanceOverviewAgainstBenchmarkAndCategoryResponse?
      fundPerformanceOverviewAgainstBenchmarkAndCategoryResponse;
  AmcDetails? amcDetails;
  List<CreditRatings>? creditRatings;
  String? factsheetName;
  String? factsheetLink;
  String? portfolioName;
  String? portfolioLink;
  String? rtaCode;
  String? amcCode;
  num? week52HighNav;
  num? week52LowNav;
  String? dividendType;
  String? week52HighDate;
  String? week52LowDate;

  SchemeInfoPojo(
      {this.status,
      this.statusMsg,
      this.msg,
      this.schemeName,
      this.schemeAmfiCode,
      this.nav,
      this.navDate,
      this.navChange,
      this.navChangePercentage,
      this.schemeInceptionReturn,
      this.benchmarkInceptionReturn,
      this.schemeObjective,
      this.schemeManager,
      this.schemeManagerBiography,
      this.riskometerValue,
      this.riskometerImage,
      this.isinNo,
      this.isinDivreinvstNo,
      this.amcLogo,
      this.schemeCategory,
      this.schemeCompany,
      this.schemeCompanyShortName,
      this.schemeInceptionDate,
      this.assetClass,
      this.schemeBenchmark,
      this.schemeBenchmarkCode,
      this.expenseRatioPercentage,
      this.expenseRatioDate,
      this.schemeStatus,
      this.minimumInvestment,
      this.minimumTopup,
      this.schemeAssets,
      this.schemeAssetDate,
      this.schemeTurnover,
      this.isDividendScheme,
      this.volatility,
      this.schemeSipStartDate,
      this.schemeSipEndDate,
      this.schemeLumpsumStartDate,
      this.schemePerformanceList,
      this.riskStatisticsList,
      this.schemePeerComparisionList,
      this.schemeMapping,
      this.schemePerformances,
      this.peerComparisonResponse,
      this.dividendList,
      this.assetAllocationList,
      this.marketCapList,
      this.fundPerformanceOverviewAgainstBenchmarkAndCategoryResponse,
      this.amcDetails,
      this.creditRatings,
      this.factsheetName,
      this.factsheetLink,
      this.portfolioName,
      this.portfolioLink,
      this.rtaCode,
      this.amcCode,
      this.week52HighNav,
      this.week52LowNav,
      this.dividendType,
      this.week52HighDate,
      this.week52LowDate});

  SchemeInfoPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    schemeName = json['scheme_name'];
    schemeAmfiCode = json['scheme_amfi_code'];
    nav = json['nav'];
    navDate = json['nav_date'];
    navChange = json['nav_change'];
    navChangePercentage = json['nav_change_percentage'];
    schemeInceptionReturn = json['scheme_inception_return'];
    benchmarkInceptionReturn = json['benchmark_inception_return'];
    schemeObjective = json['scheme_objective'];
    schemeManager = json['scheme_manager'];
    schemeManagerBiography = json['scheme_manager_biography'];
    riskometerValue = json['riskometer_value'];
    riskometerImage = json['riskometer_image'];
    isinNo = json['isin_no'];
    isinDivreinvstNo = json['isin_divreinvst_no'];
    amcLogo = json['amc_logo'];
    schemeCategory = json['scheme_category'];
    schemeCompany = json['scheme_company'];
    schemeCompanyShortName = json['scheme_company_short_name'];
    schemeInceptionDate = json['scheme_inception_date'];
    assetClass = json['asset_class'];
    schemeBenchmark = json['scheme_benchmark'];
    schemeBenchmarkCode = json['scheme_benchmark_code'];
    expenseRatioPercentage = json['expense_ratio_percentage'];
    expenseRatioDate = json['expense_ratio_date'];
    schemeStatus = json['scheme_status'];
    minimumInvestment = json['minimum_investment'];
    minimumTopup = json['minimum_topup'];
    schemeAssets = json['scheme_assets'];
    schemeAssetDate = json['scheme_asset_date'];
    schemeTurnover = json['scheme_turnover'];
    isDividendScheme = json['is_dividend_scheme'];
    volatility = json['volatility'];
    schemeSipStartDate = json['scheme_sip_start_date'];
    schemeSipEndDate = json['scheme_sip_end_date'];
    schemeLumpsumStartDate = json['scheme_lumpsum_start_date'];
    if (json['scheme_performance_list'] != null) {
      schemePerformanceList = <SchemePerformanceList>[];
      json['scheme_performance_list'].forEach((v) {
        schemePerformanceList!.add(SchemePerformanceList.fromJson(v));
      });
    }
    if (json['risk_statistics_list'] != null) {
      riskStatisticsList = <RiskStatisticsList>[];
      json['risk_statistics_list'].forEach((v) {
        riskStatisticsList!.add(RiskStatisticsList.fromJson(v));
      });
    }
    if (json['scheme_peer_comparision_list'] != null) {
      schemePeerComparisionList = <SchemePeerComparisionList>[];
      json['scheme_peer_comparision_list'].forEach((v) {
        schemePeerComparisionList!.add(SchemePeerComparisionList.fromJson(v));
      });
    }
    schemeMapping = json['schemeMapping'] != null
        ? SchemeMapping.fromJson(json['schemeMapping'])
        : null;
    schemePerformances = json['schemePerformances'] != null
        ? SchemePerformances.fromJson(json['schemePerformances'])
        : null;
    if (json['peerComparisonResponse'] != null) {
      peerComparisonResponse = <PeerComparisonResponse>[];
      json['peerComparisonResponse'].forEach((v) {
        peerComparisonResponse!.add(PeerComparisonResponse.fromJson(v));
      });
    }
    dividendList = json['dividend_list'];
    assetAllocationList = json['asset_allocation_list'];
    marketCapList = json['market_cap_list'];
    fundPerformanceOverviewAgainstBenchmarkAndCategoryResponse = json[
                'fundPerformanceOverviewAgainstBenchmarkAndCategoryResponse'] !=
            null
        ? FundPerformanceOverviewAgainstBenchmarkAndCategoryResponse.fromJson(
            json['fundPerformanceOverviewAgainstBenchmarkAndCategoryResponse'])
        : null;
    amcDetails = json['amc_details'] != null
        ? AmcDetails.fromJson(json['amc_details'])
        : null;
    if (json['credit_ratings'] != null) {
      creditRatings = <CreditRatings>[];
      json['credit_ratings'].forEach((v) {
        creditRatings!.add(CreditRatings.fromJson(v));
      });
    }
    factsheetName = json['factsheet_name'];
    factsheetLink = json['factsheet_link'];
    portfolioName = json['portfolio_name'];
    portfolioLink = json['portfolio_link'];
    rtaCode = json['rta_code'];
    amcCode = json['amc_code'];
    week52HighNav = json['week_52_high_nav'];
    week52LowNav = json['week_52_low_nav'];
    dividendType = json['dividend_type'];
    week52HighDate = json['week_52_high_date'];
    week52LowDate = json['week_52_low_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_msg'] = statusMsg;
    data['msg'] = msg;
    data['scheme_name'] = schemeName;
    data['scheme_amfi_code'] = schemeAmfiCode;
    data['nav'] = nav;
    data['nav_date'] = navDate;
    data['nav_change'] = navChange;
    data['nav_change_percentage'] = navChangePercentage;
    data['scheme_inception_return'] = schemeInceptionReturn;
    data['benchmark_inception_return'] = benchmarkInceptionReturn;
    data['scheme_objective'] = schemeObjective;
    data['scheme_manager'] = schemeManager;
    data['scheme_manager_biography'] = schemeManagerBiography;
    data['riskometer_value'] = riskometerValue;
    data['riskometer_image'] = riskometerImage;
    data['isin_no'] = isinNo;
    data['isin_divreinvst_no'] = isinDivreinvstNo;
    data['amc_logo'] = amcLogo;
    data['scheme_category'] = schemeCategory;
    data['scheme_company'] = schemeCompany;
    data['scheme_company_short_name'] = schemeCompanyShortName;
    data['scheme_inception_date'] = schemeInceptionDate;
    data['asset_class'] = assetClass;
    data['scheme_benchmark'] = schemeBenchmark;
    data['scheme_benchmark_code'] = schemeBenchmarkCode;
    data['expense_ratio_percentage'] = expenseRatioPercentage;
    data['expense_ratio_date'] = expenseRatioDate;
    data['scheme_status'] = schemeStatus;
    data['minimum_investment'] = minimumInvestment;
    data['minimum_topup'] = minimumTopup;
    data['scheme_assets'] = schemeAssets;
    data['scheme_asset_date'] = schemeAssetDate;
    data['scheme_turnover'] = schemeTurnover;
    data['is_dividend_scheme'] = isDividendScheme;
    data['volatility'] = volatility;
    data['scheme_sip_start_date'] = schemeSipStartDate;
    data['scheme_sip_end_date'] = schemeSipEndDate;
    data['scheme_lumpsum_start_date'] = schemeLumpsumStartDate;
    if (schemePerformanceList != null) {
      data['scheme_performance_list'] =
          schemePerformanceList!.map((v) => v.toJson()).toList();
    }
    if (riskStatisticsList != null) {
      data['risk_statistics_list'] =
          riskStatisticsList!.map((v) => v.toJson()).toList();
    }
    if (schemePeerComparisionList != null) {
      data['scheme_peer_comparision_list'] =
          schemePeerComparisionList!.map((v) => v.toJson()).toList();
    }
    if (schemeMapping != null) {
      data['schemeMapping'] = schemeMapping!.toJson();
    }
    if (schemePerformances != null) {
      data['schemePerformances'] = schemePerformances!.toJson();
    }
    if (peerComparisonResponse != null) {
      data['peerComparisonResponse'] =
          peerComparisonResponse!.map((v) => v.toJson()).toList();
    }
    data['dividend_list'] = dividendList;
    data['asset_allocation_list'] = assetAllocationList;
    data['market_cap_list'] = marketCapList;
    if (fundPerformanceOverviewAgainstBenchmarkAndCategoryResponse != null) {
      data['fundPerformanceOverviewAgainstBenchmarkAndCategoryResponse'] =
          fundPerformanceOverviewAgainstBenchmarkAndCategoryResponse!.toJson();
    }
    if (amcDetails != null) {
      data['amc_details'] = amcDetails!.toJson();
    }
    if (creditRatings != null) {
      data['credit_ratings'] = creditRatings!.map((v) => v.toJson()).toList();
    }
    data['factsheet_name'] = factsheetName;
    data['factsheet_link'] = factsheetLink;
    data['portfolio_name'] = portfolioName;
    data['portfolio_link'] = portfolioLink;
    data['rta_code'] = rtaCode;
    data['amc_code'] = amcCode;
    data['week_52_high_nav'] = week52HighNav;
    data['week_52_low_nav'] = week52LowNav;
    data['dividend_type'] = dividendType;
    data['week_52_high_date'] = week52HighDate;
    data['week_52_low_date'] = week52LowDate;
    return data;
  }
}

class SchemePerformanceList {
  String? schemeName;
  String? schemeAmfiShortName;
  String? schemeInceptionDate;
  String? schemeInceptionDateString;
  num? oneWeekReturn;
  num? oneMonthReturn;
  num? threeMonthReturn;
  num? sixMonthReturn;
  num? oneYearReturn;
  num? twoYearReturn;
  num? threeYearReturn;
  num? fiveYearReturn;
  num? tenYearReturn;
  num? inceptionYearReturn;
  num? ytdReturn;
  String? logo;
  String? schemeAssetDate;
  num? schemeAssets;
  String? category;
  String? isin;
  String? schemeAmfiCode;

  SchemePerformanceList(
      {this.schemeName,
      this.schemeAmfiShortName,
      this.schemeInceptionDate,
      this.schemeInceptionDateString,
      this.oneWeekReturn,
      this.oneMonthReturn,
      this.threeMonthReturn,
      this.sixMonthReturn,
      this.oneYearReturn,
      this.twoYearReturn,
      this.threeYearReturn,
      this.fiveYearReturn,
      this.tenYearReturn,
      this.inceptionYearReturn,
      this.ytdReturn,
      this.logo,
      this.schemeAssetDate,
      this.schemeAssets,
      this.category,
      this.isin,
      this.schemeAmfiCode});

  SchemePerformanceList.fromJson(Map<String, dynamic> json) {
    schemeName = json['scheme_name'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeInceptionDate = json['scheme_inception_date'];
    schemeInceptionDateString = json['scheme_inception_date_string'];
    oneWeekReturn = json['one_week_return'];
    oneMonthReturn = json['one_month_return'];
    threeMonthReturn = json['three_month_return'];
    sixMonthReturn = json['six_month_return'];
    oneYearReturn = json['one_year_return'];
    twoYearReturn = json['two_year_return'];
    threeYearReturn = json['three_year_return'];
    fiveYearReturn = json['five_year_return'];
    tenYearReturn = json['ten_year_return'];
    inceptionYearReturn = json['inception_year_return'];
    ytdReturn = json['ytd_return'];
    logo = json['logo'];
    schemeAssetDate = json['scheme_asset_date'];
    schemeAssets = json['scheme_assets'];
    category = json['category'];
    isin = json['isin'];
    schemeAmfiCode = json['scheme_amfi_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheme_name'] = schemeName;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['scheme_inception_date'] = schemeInceptionDate;
    data['scheme_inception_date_string'] = schemeInceptionDateString;
    data['one_week_return'] = oneWeekReturn;
    data['one_month_return'] = oneMonthReturn;
    data['three_month_return'] = threeMonthReturn;
    data['six_month_return'] = sixMonthReturn;
    data['one_year_return'] = oneYearReturn;
    data['two_year_return'] = twoYearReturn;
    data['three_year_return'] = threeYearReturn;
    data['five_year_return'] = fiveYearReturn;
    data['ten_year_return'] = tenYearReturn;
    data['inception_year_return'] = inceptionYearReturn;
    data['ytd_return'] = ytdReturn;
    data['logo'] = logo;
    data['scheme_asset_date'] = schemeAssetDate;
    data['scheme_assets'] = schemeAssets;
    data['category'] = category;
    data['isin'] = isin;
    data['scheme_amfi_code'] = schemeAmfiCode;
    return data;
  }
}

class RiskStatisticsList {
  String? schemeCategory;
  num? volatilityCm3year;
  num? sharpratioCm3year;
  num? alphaCm1year;
  num? betaCm1year;
  num? yieldToMaturity;
  num? averageMaturity;
  String? shortinoRatio;

  RiskStatisticsList(
      {this.schemeCategory,
      this.volatilityCm3year,
      this.sharpratioCm3year,
      this.alphaCm1year,
      this.betaCm1year,
      this.yieldToMaturity,
      this.averageMaturity,
      this.shortinoRatio});

  RiskStatisticsList.fromJson(Map<String, dynamic> json) {
    schemeCategory = json['scheme_category'];
    volatilityCm3year = json['volatility_cm_3year'];
    sharpratioCm3year = json['sharpratio_cm_3year'];
    alphaCm1year = json['alpha_cm_1year'];
    betaCm1year = json['beta_cm_1year'];
    yieldToMaturity = json['yield_to_maturity'];
    averageMaturity = json['average_maturity'];
    shortinoRatio = json['shortino_ratio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['scheme_category'] = schemeCategory;
    data['volatility_cm_3year'] = volatilityCm3year;
    data['sharpratio_cm_3year'] = sharpratioCm3year;
    data['alpha_cm_1year'] = alphaCm1year;
    data['beta_cm_1year'] = betaCm1year;
    data['yield_to_maturity'] = yieldToMaturity;
    data['average_maturity'] = averageMaturity;
    data['shortino_ratio'] = shortinoRatio;
    return data;
  }
}

class SchemePeerComparisionList {
  String? schemeName;
  String? schemeAmfiShortName;
  String? schemeInceptionDate;
  String? schemeInceptionDateString;
  num? oneWeekReturn;
  num? oneMonthReturn;
  num? threeMonthReturn;
  num? sixMonthReturn;
  num? oneYearReturn;
  num? twoYearReturn;
  num? threeYearReturn;
  num? fiveYearReturn;
  num? tenYearReturn;
  num? inceptionYearReturn;
  num? ytdReturn;
  String? logo;
  String? schemeAssetDate;
  num? schemeAssets;
  String? category;
  String? isin;
  String? schemeAmfiCode;

  SchemePeerComparisionList(
      {this.schemeName,
      this.schemeAmfiShortName,
      this.schemeInceptionDate,
      this.schemeInceptionDateString,
      this.oneWeekReturn,
      this.oneMonthReturn,
      this.threeMonthReturn,
      this.sixMonthReturn,
      this.oneYearReturn,
      this.twoYearReturn,
      this.threeYearReturn,
      this.fiveYearReturn,
      this.tenYearReturn,
      this.inceptionYearReturn,
      this.ytdReturn,
      this.logo,
      this.schemeAssetDate,
      this.schemeAssets,
      this.category,
      this.isin,
      this.schemeAmfiCode});

  SchemePeerComparisionList.fromJson(Map<String, dynamic> json) {
    schemeName = json['scheme_name'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeInceptionDate = json['scheme_inception_date'];
    schemeInceptionDateString = json['scheme_inception_date_string'];
    oneWeekReturn = json['one_week_return'];
    oneMonthReturn = json['one_month_return'];
    threeMonthReturn = json['three_month_return'];
    sixMonthReturn = json['six_month_return'];
    oneYearReturn = json['one_year_return'];
    twoYearReturn = json['two_year_return'];
    threeYearReturn = json['three_year_return'];
    fiveYearReturn = json['five_year_return'];
    tenYearReturn = json['ten_year_return'];
    inceptionYearReturn = json['inception_year_return'];
    ytdReturn = json['ytd_return'];
    logo = json['logo'];
    schemeAssetDate = json['scheme_asset_date'];
    schemeAssets = json['scheme_assets'];
    category = json['category'];
    isin = json['isin'];
    schemeAmfiCode = json['scheme_amfi_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['scheme_name'] = schemeName;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['scheme_inception_date'] = schemeInceptionDate;
    data['scheme_inception_date_string'] = schemeInceptionDateString;
    data['one_week_return'] = oneWeekReturn;
    data['one_month_return'] = oneMonthReturn;
    data['three_month_return'] = threeMonthReturn;
    data['six_month_return'] = sixMonthReturn;
    data['one_year_return'] = oneYearReturn;
    data['two_year_return'] = twoYearReturn;
    data['three_year_return'] = threeYearReturn;
    data['five_year_return'] = fiveYearReturn;
    data['ten_year_return'] = tenYearReturn;
    data['inception_year_return'] = inceptionYearReturn;
    data['ytd_return'] = ytdReturn;
    data['logo'] = logo;
    data['scheme_asset_date'] = schemeAssetDate;
    data['scheme_assets'] = schemeAssets;
    data['category'] = category;
    data['isin'] = isin;
    data['scheme_amfi_code'] = schemeAmfiCode;
    return data;
  }
}

class SchemeMapping {
  num? id;
  String? schemeCompany;
  String? schemeBroadCategory;
  String? schemeAdvisorkhojCategory;
  String? taxCategory;
  String? schemeAmfiCode;
  String? schemeAmfiGrowthCode;
  bool? erstwhileSchemeMerged;
  String? erstwhileName;
  String? schemeAmfi;
  String? schemeAmfiUrl;
  String? schemeCams;
  String? schemeKarvy;
  String? schemeFranklin;
  String? schemeFranklinCode;
  String? schemeSundaram;
  String? isinNo;
  String? isinDivreinvstNo;
  String? isinSweepNo;
  bool? active;
  String? schemeInceptionDate;
  String? openOrClosed;
  String? schemeObjective;
  num? sipMinimumAmount;
  String? sipDates;
  String? riskometer;
  bool? dividendScheme;
  String? dividendType;
  String? url;
  num? volatility;
  num? sharpratio;
  num? mean;
  num? alpha;
  num? beta;
  num? yieldToMaturity;
  num? averageMaturity;
  String? schemeBenchmark;
  String? schemeBenchmarkCode;
  String? schemeAssetDate;
  num? schemeAssets;
  num? ter;
  String? terDate;
  String? schemeManager;
  String? schemeManagerBiography;
  String? assetClass;
  num? minimum;
  num? minimumTopup;
  String? portfolioTurnoverRatio;
  String? portfolioTurnoverRatioDate;
  num? etfScheme;
  String? categoryDescription;
  String? schemeAmfiCommon;
  num? veYtm;
  String? presAsset;
  String? numdIn;
  String? exit1;
  num? standardDeviation;
  num? marketCapLargecapPercent;
  num? marketCapMidcapPercent;
  num? marketCapSmallcapPercent;
  num? modifiedDuration;
  num? durationLast;
  num? maturityLast;
  num? ytmLast;
  String? schemeCompanyShortName;
  String? schemeAmfiShortName;
  String? categoryShortName;
  String? schemePlanType;
  String? miraeSchemeCode;
  String? schemeCamsProductcode;
  String? schemeKarvyProductcode;
  String? schemeSubCategory;
  num? sortinoRatio;
  String? schemeBenchmarkAdvisorkhoj;
  String? schemeBenchmarkAdvisorkhojCode;
  String? schemeEtfSymbol;
  String? miraeSchemeName;
  String? exit2;
  String? exit3;
  String? exit4;
  String? exit5;
  String? exit6;
  String? taxCategoryAdv;
  num? r2;

  SchemeMapping(
      {this.id,
      this.schemeCompany,
      this.schemeBroadCategory,
      this.schemeAdvisorkhojCategory,
      this.taxCategory,
      this.schemeAmfiCode,
      this.schemeAmfiGrowthCode,
      this.erstwhileSchemeMerged,
      this.erstwhileName,
      this.schemeAmfi,
      this.schemeAmfiUrl,
      this.schemeCams,
      this.schemeKarvy,
      this.schemeFranklin,
      this.schemeFranklinCode,
      this.schemeSundaram,
      this.isinNo,
      this.isinDivreinvstNo,
      this.isinSweepNo,
      this.active,
      this.schemeInceptionDate,
      this.openOrClosed,
      this.schemeObjective,
      this.sipMinimumAmount,
      this.sipDates,
      this.riskometer,
      this.dividendScheme,
      this.dividendType,
      this.url,
      this.volatility,
      this.sharpratio,
      this.mean,
      this.alpha,
      this.beta,
      this.yieldToMaturity,
      this.averageMaturity,
      this.schemeBenchmark,
      this.schemeBenchmarkCode,
      this.schemeAssetDate,
      this.schemeAssets,
      this.ter,
      this.terDate,
      this.schemeManager,
      this.schemeManagerBiography,
      this.assetClass,
      this.minimum,
      this.minimumTopup,
      this.portfolioTurnoverRatio,
      this.portfolioTurnoverRatioDate,
      this.etfScheme,
      this.categoryDescription,
      this.schemeAmfiCommon,
      this.veYtm,
      this.presAsset,
      this.numdIn,
      this.exit1,
      this.standardDeviation,
      this.marketCapLargecapPercent,
      this.marketCapMidcapPercent,
      this.marketCapSmallcapPercent,
      this.modifiedDuration,
      this.durationLast,
      this.maturityLast,
      this.ytmLast,
      this.schemeCompanyShortName,
      this.schemeAmfiShortName,
      this.categoryShortName,
      this.schemePlanType,
      this.miraeSchemeCode,
      this.schemeCamsProductcode,
      this.schemeKarvyProductcode,
      this.schemeSubCategory,
      this.sortinoRatio,
      this.schemeBenchmarkAdvisorkhoj,
      this.schemeBenchmarkAdvisorkhojCode,
      this.schemeEtfSymbol,
      this.miraeSchemeName,
      this.exit2,
      this.exit3,
      this.exit4,
      this.exit5,
      this.exit6,
      this.taxCategoryAdv,
      this.r2});

  SchemeMapping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schemeCompany = json['scheme_company'];
    schemeBroadCategory = json['scheme_broad_category'];
    schemeAdvisorkhojCategory = json['scheme_advisorkhoj_category'];
    taxCategory = json['tax_category'];
    schemeAmfiCode = json['scheme_amfi_code'];
    schemeAmfiGrowthCode = json['scheme_amfi_growth_code'];
    erstwhileSchemeMerged = json['erstwhile_scheme_merged'];
    erstwhileName = json['erstwhile_name'];
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiUrl = json['scheme_amfi_url'];
    schemeCams = json['scheme_cams'];
    schemeKarvy = json['scheme_karvy'];
    schemeFranklin = json['scheme_franklin'];
    schemeFranklinCode = json['scheme_franklin_code'];
    schemeSundaram = json['scheme_sundaram'];
    isinNo = json['isin_no'];
    isinDivreinvstNo = json['isin_divreinvst_no'];
    isinSweepNo = json['isin_sweep_no'];
    active = json['active'];
    schemeInceptionDate = json['scheme_inception_date'];
    openOrClosed = json['open_or_closed'];
    schemeObjective = json['scheme_objective'];
    sipMinimumAmount = json['sip_minimum_amount'];
    sipDates = json['sip_dates'];
    riskometer = json['riskometer'];
    dividendScheme = json['dividend_scheme'];
    dividendType = json['dividend_type'];
    url = json['url'];
    volatility = json['volatility'];
    sharpratio = json['sharpratio'];
    mean = json['mean'];
    alpha = json['alpha'];
    beta = json['beta'];
    yieldToMaturity = json['yield_to_maturity'];
    averageMaturity = json['average_maturity'];
    schemeBenchmark = json['scheme_benchmark'];
    schemeBenchmarkCode = json['scheme_benchmark_code'];
    schemeAssetDate = json['scheme_asset_date'];
    schemeAssets = json['scheme_assets'];
    ter = json['ter'];
    terDate = json['ter_date'];
    schemeManager = json['scheme_manager'];
    schemeManagerBiography = json['scheme_manager_biography'];
    assetClass = json['asset_class'];
    minimum = json['minimum'];
    minimumTopup = json['minimum_topup'];
    portfolioTurnoverRatio = json['portfolio_turnover_ratio'];
    portfolioTurnoverRatioDate = json['portfolio_turnover_ratio_date'];
    etfScheme = json['etf_scheme'];
    categoryDescription = json['category_description'];
    schemeAmfiCommon = json['scheme_amfi_common'];
    veYtm = json['ve_ytm'];
    presAsset = json['pres_asset'];
    numdIn = json['numd_in'];
    exit1 = json['exit1'];
    standardDeviation = json['standard_deviation'];
    marketCapLargecapPercent = json['market_cap_largecap_percent'];
    marketCapMidcapPercent = json['market_cap_midcap_percent'];
    marketCapSmallcapPercent = json['market_cap_smallcap_percent'];
    modifiedDuration = json['modified_duration'];
    durationLast = json['duration_last'];
    maturityLast = json['maturity_last'];
    ytmLast = json['ytm_last'];
    schemeCompanyShortName = json['scheme_company_short_name'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    categoryShortName = json['category_short_name'];
    schemePlanType = json['scheme_plan_type'];
    miraeSchemeCode = json['mirae_scheme_code'];
    schemeCamsProductcode = json['scheme_cams_productcode'];
    schemeKarvyProductcode = json['scheme_karvy_productcode'];
    schemeSubCategory = json['scheme_sub_category'];
    sortinoRatio = json['sortino_ratio'];
    schemeBenchmarkAdvisorkhoj = json['scheme_benchmark_advisorkhoj'];
    schemeBenchmarkAdvisorkhojCode = json['scheme_benchmark_advisorkhoj_code'];
    schemeEtfSymbol = json['scheme_etf_symbol'];
    miraeSchemeName = json['mirae_scheme_name'];
    exit2 = json['exit2'];
    exit3 = json['exit3'];
    exit4 = json['exit4'];
    exit5 = json['exit5'];
    exit6 = json['exit6'];
    taxCategoryAdv = json['tax_category_adv'];
    r2 = json['r2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['scheme_company'] = schemeCompany;
    data['scheme_broad_category'] = schemeBroadCategory;
    data['scheme_advisorkhoj_category'] = schemeAdvisorkhojCategory;
    data['tax_category'] = taxCategory;
    data['scheme_amfi_code'] = schemeAmfiCode;
    data['scheme_amfi_growth_code'] = schemeAmfiGrowthCode;
    data['erstwhile_scheme_merged'] = erstwhileSchemeMerged;
    data['erstwhile_name'] = erstwhileName;
    data['scheme_amfi'] = schemeAmfi;
    data['scheme_amfi_url'] = schemeAmfiUrl;
    data['scheme_cams'] = schemeCams;
    data['scheme_karvy'] = schemeKarvy;
    data['scheme_franklin'] = schemeFranklin;
    data['scheme_franklin_code'] = schemeFranklinCode;
    data['scheme_sundaram'] = schemeSundaram;
    data['isin_no'] = isinNo;
    data['isin_divreinvst_no'] = isinDivreinvstNo;
    data['isin_sweep_no'] = isinSweepNo;
    data['active'] = active;
    data['scheme_inception_date'] = schemeInceptionDate;
    data['open_or_closed'] = openOrClosed;
    data['scheme_objective'] = schemeObjective;
    data['sip_minimum_amount'] = sipMinimumAmount;
    data['sip_dates'] = sipDates;
    data['riskometer'] = riskometer;
    data['dividend_scheme'] = dividendScheme;
    data['dividend_type'] = dividendType;
    data['url'] = url;
    data['volatility'] = volatility;
    data['sharpratio'] = sharpratio;
    data['mean'] = mean;
    data['alpha'] = alpha;
    data['beta'] = beta;
    data['yield_to_maturity'] = yieldToMaturity;
    data['average_maturity'] = averageMaturity;
    data['scheme_benchmark'] = schemeBenchmark;
    data['scheme_benchmark_code'] = schemeBenchmarkCode;
    data['scheme_asset_date'] = schemeAssetDate;
    data['scheme_assets'] = schemeAssets;
    data['ter'] = ter;
    data['ter_date'] = terDate;
    data['scheme_manager'] = schemeManager;
    data['scheme_manager_biography'] = schemeManagerBiography;
    data['asset_class'] = assetClass;
    data['minimum'] = minimum;
    data['minimum_topup'] = minimumTopup;
    data['portfolio_turnover_ratio'] = portfolioTurnoverRatio;
    data['portfolio_turnover_ratio_date'] = portfolioTurnoverRatioDate;
    data['etf_scheme'] = etfScheme;
    data['category_description'] = categoryDescription;
    data['scheme_amfi_common'] = schemeAmfiCommon;
    data['ve_ytm'] = veYtm;
    data['pres_asset'] = presAsset;
    data['numd_in'] = numdIn;
    data['exit1'] = exit1;
    data['standard_deviation'] = standardDeviation;
    data['market_cap_largecap_percent'] = marketCapLargecapPercent;
    data['market_cap_midcap_percent'] = marketCapMidcapPercent;
    data['market_cap_smallcap_percent'] = marketCapSmallcapPercent;
    data['modified_duration'] = modifiedDuration;
    data['duration_last'] = durationLast;
    data['maturity_last'] = maturityLast;
    data['ytm_last'] = ytmLast;
    data['scheme_company_short_name'] = schemeCompanyShortName;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['category_short_name'] = categoryShortName;
    data['scheme_plan_type'] = schemePlanType;
    data['mirae_scheme_code'] = miraeSchemeCode;
    data['scheme_cams_productcode'] = schemeCamsProductcode;
    data['scheme_karvy_productcode'] = schemeKarvyProductcode;
    data['scheme_sub_category'] = schemeSubCategory;
    data['sortino_ratio'] = sortinoRatio;
    data['scheme_benchmark_advisorkhoj'] = schemeBenchmarkAdvisorkhoj;
    data['scheme_benchmark_advisorkhoj_code'] = schemeBenchmarkAdvisorkhojCode;
    data['scheme_etf_symbol'] = schemeEtfSymbol;
    data['mirae_scheme_name'] = miraeSchemeName;
    data['exit2'] = exit2;
    data['exit3'] = exit3;
    data['exit4'] = exit4;
    data['exit5'] = exit5;
    data['exit6'] = exit6;
    data['tax_category_adv'] = taxCategoryAdv;
    data['r2'] = r2;
    return data;
  }
}

class SchemePerformances {
  num? id;
  String? schemeVe;
  String? schemeVeCiticode;
  String? inceptionDate;
  String? priceDate;
  String? schemeAmfi;
  String? schemeAmfiShortName;
  String? schemeCategoryClass;
  String? schemeAmfiCode;
  String? schemeCategory;
  String? schemeBroadCategory;
  String? openOrClosed;
  num? returnsAbs7days;
  num? returnsAbs1month;
  num? returnsAbs3month;
  num? returnsAbs6month;
  num? returnsAbsYtd;
  num? returnsAbs1year;
  num? returnsCmp2year;
  num? returnsCmp3year;
  num? returnsCmp4year;
  num? returnsCmp5year;
  num? returnsCmp10year;
  num? returnsCmpInception;
  num? returnsAbs2007;
  num? returnsAbs2008;
  num? returnsAbs2009;
  num? returnsAbs2010;
  num? returnsAbs2011;
  num? returnsAbs2012;
  num? returnsAbs2013;
  num? returnsAbs2014;
  num? returnsAbs2015;
  num? returnsAbs2016;
  num? ter;
  String? terDate;
  num? price;
  num? priceChangeOnday;
  num? priceChangePercentOnday;
  String? schemeCompany;
  String? schemeAssetDate;
  num? schemeAssets;
  String? riskometer;
  String? navTable;
  String? url;
  num? etfScheme;
  String? isinNo;
  String? isinDivreinvstNo;
  String? isinSweepNo;
  bool? dividendScheme;
  String? schemePlanType;
  num? returnsAbs7daysRank;
  num? returnsAbs1monthRank;
  num? returnsAbs3monthRank;
  num? returnsAbs6monthRank;
  num? returnsAbsYtdRank;
  num? returnsAbs1yearRank;
  num? returnsCmp2yearRank;
  num? returnsCmp3yearRank;
  num? returnsCmp4yearRank;
  num? returnsCmp5yearRank;
  num? returnsCmp10yearRank;
  num? returnsCmpInceptionRank;
  num? returnsAbs7daysTotalrank;
  num? returnsAbs1monthTotalrank;
  num? returnsAbs3monthTotalrank;
  num? returnsAbs6monthTotalrank;
  num? returnsAbsYtdTotalrank;
  num? returnsAbs1yearTotalrank;
  num? returnsCmp2yearTotalrank;
  num? returnsCmp3yearTotalrank;
  num? returnsCmp4yearTotalrank;
  num? returnsCmp5yearTotalrank;
  num? returnsCmp10yearTotalrank;
  num? returnsCmpInceptionTotalrank;
  String? schemeCompanyShortName;
  String? schemeAmfiUrl;
  num? largecapPercent;
  num? midcapPercent;
  num? smallcapPercent;
  String? schemeManager;
  num? ytm;
  num? avgMaturity;
  num? modifiedDuration;
  num? ratingSov;
  num? ratingAaa;
  num? ratingAa;
  num? ratingOthers;
  num? ratingA;
  num? ratingD;
  num? ratingBb;
  num? ratingUnrated;
  num? ratingC;
  num? ratingBbb;
  num? ratingB;
  String? schemeBenchmark;
  String? veYtm;
  String? standardDeviation;
  String? marketCapLargecapPercent;
  String? marketCapMidcapPercent;
  String? marketCapSmallcapPercent;
  String? averageMaturity;
  String? alpha;
  String? beta;
  String? r2;
  String? sharpratio;
  String? mean;
  String? schemeAmfiCommon;
  String? categoryShortName;
  String? schemeSubCategory;
  String? sector1;
  num? sector1Hold;
  String? sector2;
  num? sector2Hold;
  String? sector3;
  num? sector3Hold;
  String? sector4;
  num? sector4Hold;
  String? sector5;
  num? sector5Hold;
  String? sector6;
  num? sector6Hold;
  String? sector7;
  num? sector7Hold;
  String? sector8;
  num? sector8Hold;
  String? sector9;
  num? sector9Hold;
  String? sector10;
  num? sector10Hold;
  String? amcLogo;
  String? schemeRating;
  String? inceptionDateStr;
  num? highNav52;
  num? lowNav52;
  num? highNavInception;
  num? oneMonthMaxNav;
  num? oneMonthMinNav;
  num? threeMonthMaxNav;
  num? threeMonthMinNav;
  num? sixMonthMaxNav;
  num? sixMonthMinNav;
  num? oneYearMaxNav;
  num? oneYearMinNav;
  num? threeYearMaxNav;
  num? threeYearMinNav;
  num? fiveYearMaxNav;
  num? fiveYearMinNav;
  String? lumpsum1yearValue;
  String? lumpsum3yearValue;
  String? lumpsum5yearValue;
  String? lumpsum10yearValue;
  String? oneYearLumpsumGrowth;
  String? threeYearLumpsumGrowth;
  String? fiveYearLumpsumGrowth;
  String? inceptionLumpsumGrowth;
  num? corpdebtHold;
  num? fdHold;
  num? codHold;
  num? cpaperHold;
  num? tbillHold;
  num? currLiabHold;
  num? otherHold;
  num? assetsHold;
  num? gsecHold;
  num? cashHold;
  String? aggressiveAllocation;
  String? modAggressiveAllocation;
  String? moderateAllocation;
  String? modConservativeAllocation;
  String? conservativeAllocation;
  String? schemeAssetStr;
  String? categoryAvgReturn;
  String? allocation;

  SchemePerformances(
      {this.id,
      this.schemeVe,
      this.schemeVeCiticode,
      this.inceptionDate,
      this.priceDate,
      this.schemeAmfi,
      this.schemeAmfiShortName,
      this.schemeCategoryClass,
      this.schemeAmfiCode,
      this.schemeCategory,
      this.schemeBroadCategory,
      this.openOrClosed,
      this.returnsAbs7days,
      this.returnsAbs1month,
      this.returnsAbs3month,
      this.returnsAbs6month,
      this.returnsAbsYtd,
      this.returnsAbs1year,
      this.returnsCmp2year,
      this.returnsCmp3year,
      this.returnsCmp4year,
      this.returnsCmp5year,
      this.returnsCmp10year,
      this.returnsCmpInception,
      this.returnsAbs2007,
      this.returnsAbs2008,
      this.returnsAbs2009,
      this.returnsAbs2010,
      this.returnsAbs2011,
      this.returnsAbs2012,
      this.returnsAbs2013,
      this.returnsAbs2014,
      this.returnsAbs2015,
      this.returnsAbs2016,
      this.ter,
      this.terDate,
      this.price,
      this.priceChangeOnday,
      this.priceChangePercentOnday,
      this.schemeCompany,
      this.schemeAssetDate,
      this.schemeAssets,
      this.riskometer,
      this.navTable,
      this.url,
      this.etfScheme,
      this.isinNo,
      this.isinDivreinvstNo,
      this.isinSweepNo,
      this.dividendScheme,
      this.schemePlanType,
      this.returnsAbs7daysRank,
      this.returnsAbs1monthRank,
      this.returnsAbs3monthRank,
      this.returnsAbs6monthRank,
      this.returnsAbsYtdRank,
      this.returnsAbs1yearRank,
      this.returnsCmp2yearRank,
      this.returnsCmp3yearRank,
      this.returnsCmp4yearRank,
      this.returnsCmp5yearRank,
      this.returnsCmp10yearRank,
      this.returnsCmpInceptionRank,
      this.returnsAbs7daysTotalrank,
      this.returnsAbs1monthTotalrank,
      this.returnsAbs3monthTotalrank,
      this.returnsAbs6monthTotalrank,
      this.returnsAbsYtdTotalrank,
      this.returnsAbs1yearTotalrank,
      this.returnsCmp2yearTotalrank,
      this.returnsCmp3yearTotalrank,
      this.returnsCmp4yearTotalrank,
      this.returnsCmp5yearTotalrank,
      this.returnsCmp10yearTotalrank,
      this.returnsCmpInceptionTotalrank,
      this.schemeCompanyShortName,
      this.schemeAmfiUrl,
      this.largecapPercent,
      this.midcapPercent,
      this.smallcapPercent,
      this.schemeManager,
      this.ytm,
      this.avgMaturity,
      this.modifiedDuration,
      this.ratingSov,
      this.ratingAaa,
      this.ratingAa,
      this.ratingOthers,
      this.ratingA,
      this.ratingD,
      this.ratingBb,
      this.ratingUnrated,
      this.ratingC,
      this.ratingBbb,
      this.ratingB,
      this.schemeBenchmark,
      this.veYtm,
      this.standardDeviation,
      this.marketCapLargecapPercent,
      this.marketCapMidcapPercent,
      this.marketCapSmallcapPercent,
      this.averageMaturity,
      this.alpha,
      this.beta,
      this.r2,
      this.sharpratio,
      this.mean,
      this.schemeAmfiCommon,
      this.categoryShortName,
      this.schemeSubCategory,
      this.sector1,
      this.sector1Hold,
      this.sector2,
      this.sector2Hold,
      this.sector3,
      this.sector3Hold,
      this.sector4,
      this.sector4Hold,
      this.sector5,
      this.sector5Hold,
      this.sector6,
      this.sector6Hold,
      this.sector7,
      this.sector7Hold,
      this.sector8,
      this.sector8Hold,
      this.sector9,
      this.sector9Hold,
      this.sector10,
      this.sector10Hold,
      this.amcLogo,
      this.schemeRating,
      this.inceptionDateStr,
      this.highNav52,
      this.lowNav52,
      this.highNavInception,
      this.oneMonthMaxNav,
      this.oneMonthMinNav,
      this.threeMonthMaxNav,
      this.threeMonthMinNav,
      this.sixMonthMaxNav,
      this.sixMonthMinNav,
      this.oneYearMaxNav,
      this.oneYearMinNav,
      this.threeYearMaxNav,
      this.threeYearMinNav,
      this.fiveYearMaxNav,
      this.fiveYearMinNav,
      this.lumpsum1yearValue,
      this.lumpsum3yearValue,
      this.lumpsum5yearValue,
      this.lumpsum10yearValue,
      this.oneYearLumpsumGrowth,
      this.threeYearLumpsumGrowth,
      this.fiveYearLumpsumGrowth,
      this.inceptionLumpsumGrowth,
      this.corpdebtHold,
      this.fdHold,
      this.codHold,
      this.cpaperHold,
      this.tbillHold,
      this.currLiabHold,
      this.otherHold,
      this.assetsHold,
      this.gsecHold,
      this.cashHold,
      this.aggressiveAllocation,
      this.modAggressiveAllocation,
      this.moderateAllocation,
      this.modConservativeAllocation,
      this.conservativeAllocation,
      this.schemeAssetStr,
      this.categoryAvgReturn,
      this.allocation});

  SchemePerformances.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schemeVe = json['scheme_ve'];
    schemeVeCiticode = json['scheme_ve_citicode'];
    inceptionDate = json['inception_date'];
    priceDate = json['price_date'];
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeCategoryClass = json['scheme_category_class'];
    schemeAmfiCode = json['scheme_amfi_code'];
    schemeCategory = json['scheme_category'];
    schemeBroadCategory = json['scheme_broad_category'];
    openOrClosed = json['open_or_closed'];
    returnsAbs7days = json['returns_abs_7days'];
    returnsAbs1month = json['returns_abs_1month'];
    returnsAbs3month = json['returns_abs_3month'];
    returnsAbs6month = json['returns_abs_6month'];
    returnsAbsYtd = json['returns_abs_ytd'];
    returnsAbs1year = json['returns_abs_1year'];
    returnsCmp2year = json['returns_cmp_2year'];
    returnsCmp3year = json['returns_cmp_3year'];
    returnsCmp4year = json['returns_cmp_4year'];
    returnsCmp5year = json['returns_cmp_5year'];
    returnsCmp10year = json['returns_cmp_10year'];
    returnsCmpInception = json['returns_cmp_inception'];
    returnsAbs2007 = json['returns_abs_2007'];
    returnsAbs2008 = json['returns_abs_2008'];
    returnsAbs2009 = json['returns_abs_2009'];
    returnsAbs2010 = json['returns_abs_2010'];
    returnsAbs2011 = json['returns_abs_2011'];
    returnsAbs2012 = json['returns_abs_2012'];
    returnsAbs2013 = json['returns_abs_2013'];
    returnsAbs2014 = json['returns_abs_2014'];
    returnsAbs2015 = json['returns_abs_2015'];
    returnsAbs2016 = json['returns_abs_2016'];
    ter = json['ter'];
    terDate = json['ter_date'];
    price = json['price'];
    priceChangeOnday = json['price_change_onday'];
    priceChangePercentOnday = json['price_change_percent_onday'];
    schemeCompany = json['scheme_company'];
    schemeAssetDate = json['scheme_asset_date'];
    schemeAssets = json['scheme_assets'];
    riskometer = json['riskometer'];
    navTable = json['nav_table'];
    url = json['url'];
    etfScheme = json['etf_scheme'];
    isinNo = json['isin_no'];
    isinDivreinvstNo = json['isin_divreinvst_no'];
    isinSweepNo = json['isin_sweep_no'];
    dividendScheme = json['dividend_scheme'];
    schemePlanType = json['scheme_plan_type'];
    returnsAbs7daysRank = json['returns_abs_7days_rank'];
    returnsAbs1monthRank = json['returns_abs_1month_rank'];
    returnsAbs3monthRank = json['returns_abs_3month_rank'];
    returnsAbs6monthRank = json['returns_abs_6month_rank'];
    returnsAbsYtdRank = json['returns_abs_ytd_rank'];
    returnsAbs1yearRank = json['returns_abs_1year_rank'];
    returnsCmp2yearRank = json['returns_cmp_2year_rank'];
    returnsCmp3yearRank = json['returns_cmp_3year_rank'];
    returnsCmp4yearRank = json['returns_cmp_4year_rank'];
    returnsCmp5yearRank = json['returns_cmp_5year_rank'];
    returnsCmp10yearRank = json['returns_cmp_10year_rank'];
    returnsCmpInceptionRank = json['returns_cmp_inception_rank'];
    returnsAbs7daysTotalrank = json['returns_abs_7days_totalrank'];
    returnsAbs1monthTotalrank = json['returns_abs_1month_totalrank'];
    returnsAbs3monthTotalrank = json['returns_abs_3month_totalrank'];
    returnsAbs6monthTotalrank = json['returns_abs_6month_totalrank'];
    returnsAbsYtdTotalrank = json['returns_abs_ytd_totalrank'];
    returnsAbs1yearTotalrank = json['returns_abs_1year_totalrank'];
    returnsCmp2yearTotalrank = json['returns_cmp_2year_totalrank'];
    returnsCmp3yearTotalrank = json['returns_cmp_3year_totalrank'];
    returnsCmp4yearTotalrank = json['returns_cmp_4year_totalrank'];
    returnsCmp5yearTotalrank = json['returns_cmp_5year_totalrank'];
    returnsCmp10yearTotalrank = json['returns_cmp_10year_totalrank'];
    returnsCmpInceptionTotalrank = json['returns_cmp_inception_totalrank'];
    schemeCompanyShortName = json['scheme_company_short_name'];
    schemeAmfiUrl = json['scheme_amfi_url'];
    largecapPercent = json['largecap_percent'];
    midcapPercent = json['midcap_percent'];
    smallcapPercent = json['smallcap_percent'];
    schemeManager = json['scheme_manager'];
    ytm = json['ytm'];
    avgMaturity = json['avg_maturity'];
    modifiedDuration = json['modified_duration'];
    ratingSov = json['rating_sov'];
    ratingAaa = json['rating_aaa'];
    ratingAa = json['rating_aa'];
    ratingOthers = json['rating_others'];
    ratingA = json['rating_a'];
    ratingD = json['rating_d'];
    ratingBb = json['rating_bb'];
    ratingUnrated = json['rating_unrated'];
    ratingC = json['rating_c'];
    ratingBbb = json['rating_bbb'];
    ratingB = json['rating_b'];
    schemeBenchmark = json['scheme_benchmark'];
    veYtm = json['ve_ytm'];
    standardDeviation = json['standard_deviation'];
    marketCapLargecapPercent = json['market_cap_largecap_percent'];
    marketCapMidcapPercent = json['market_cap_midcap_percent'];
    marketCapSmallcapPercent = json['market_cap_smallcap_percent'];
    averageMaturity = json['average_maturity'];
    alpha = json['alpha'];
    beta = json['beta'];
    r2 = json['r2'];
    sharpratio = json['sharpratio'];
    mean = json['mean'];
    schemeAmfiCommon = json['scheme_amfi_common'];
    categoryShortName = json['category_short_name'];
    schemeSubCategory = json['scheme_sub_category'];
    sector1 = json['sector1'];
    sector1Hold = json['sector1_hold'];
    sector2 = json['sector2'];
    sector2Hold = json['sector2_hold'];
    sector3 = json['sector3'];
    sector3Hold = json['sector3_hold'];
    sector4 = json['sector4'];
    sector4Hold = json['sector4_hold'];
    sector5 = json['sector5'];
    sector5Hold = json['sector5_hold'];
    sector6 = json['sector6'];
    sector6Hold = json['sector6_hold'];
    sector7 = json['sector7'];
    sector7Hold = json['sector7_hold'];
    sector8 = json['sector8'];
    sector8Hold = json['sector8_hold'];
    sector9 = json['sector9'];
    sector9Hold = json['sector9_hold'];
    sector10 = json['sector10'];
    sector10Hold = json['sector10_hold'];
    amcLogo = json['amc_logo'];
    schemeRating = json['scheme_rating'];
    inceptionDateStr = json['inception_date_str'];
    highNav52 = json['high_nav52'];
    lowNav52 = json['low_nav52'];
    highNavInception = json['high_nav_inception'];
    oneMonthMaxNav = json['one_month_max_nav'];
    oneMonthMinNav = json['one_month_min_nav'];
    threeMonthMaxNav = json['three_month_max_nav'];
    threeMonthMinNav = json['three_month_min_nav'];
    sixMonthMaxNav = json['six_month_max_nav'];
    sixMonthMinNav = json['six_month_min_nav'];
    oneYearMaxNav = json['one_year_max_nav'];
    oneYearMinNav = json['one_year_min_nav'];
    threeYearMaxNav = json['three_year_max_nav'];
    threeYearMinNav = json['three_year_min_nav'];
    fiveYearMaxNav = json['five_year_max_nav'];
    fiveYearMinNav = json['five_year_min_nav'];
    lumpsum1yearValue = json['lumpsum_1year_value'];
    lumpsum3yearValue = json['lumpsum_3year_value'];
    lumpsum5yearValue = json['lumpsum_5year_value'];
    lumpsum10yearValue = json['lumpsum_10year_value'];
    oneYearLumpsumGrowth = json['one_year_lumpsum_growth'];
    threeYearLumpsumGrowth = json['three_year_lumpsum_growth'];
    fiveYearLumpsumGrowth = json['five_year_lumpsum_growth'];
    inceptionLumpsumGrowth = json['inception_lumpsum_growth'];
    corpdebtHold = json['corpdebt_hold'];
    fdHold = json['fd_hold'];
    codHold = json['cod_hold'];
    cpaperHold = json['cpaper_hold'];
    tbillHold = json['tbill_hold'];
    currLiabHold = json['curr_liab_hold'];
    otherHold = json['other_hold'];
    assetsHold = json['assets_hold'];
    gsecHold = json['gsec_hold'];
    cashHold = json['cash_hold'];
    aggressiveAllocation = json['aggressive_allocation'];
    modAggressiveAllocation = json['mod_aggressive_allocation'];
    moderateAllocation = json['moderate_allocation'];
    modConservativeAllocation = json['mod_conservative_allocation'];
    conservativeAllocation = json['conservative_allocation'];
    schemeAssetStr = json['scheme_asset_str'];
    categoryAvgReturn = json['category_avg_return'];
    allocation = json['allocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['scheme_ve'] = schemeVe;
    data['scheme_ve_citicode'] = schemeVeCiticode;
    data['inception_date'] = inceptionDate;
    data['price_date'] = priceDate;
    data['scheme_amfi'] = schemeAmfi;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['scheme_category_class'] = schemeCategoryClass;
    data['scheme_amfi_code'] = schemeAmfiCode;
    data['scheme_category'] = schemeCategory;
    data['scheme_broad_category'] = schemeBroadCategory;
    data['open_or_closed'] = openOrClosed;
    data['returns_abs_7days'] = returnsAbs7days;
    data['returns_abs_1month'] = returnsAbs1month;
    data['returns_abs_3month'] = returnsAbs3month;
    data['returns_abs_6month'] = returnsAbs6month;
    data['returns_abs_ytd'] = returnsAbsYtd;
    data['returns_abs_1year'] = returnsAbs1year;
    data['returns_cmp_2year'] = returnsCmp2year;
    data['returns_cmp_3year'] = returnsCmp3year;
    data['returns_cmp_4year'] = returnsCmp4year;
    data['returns_cmp_5year'] = returnsCmp5year;
    data['returns_cmp_10year'] = returnsCmp10year;
    data['returns_cmp_inception'] = returnsCmpInception;
    data['returns_abs_2007'] = returnsAbs2007;
    data['returns_abs_2008'] = returnsAbs2008;
    data['returns_abs_2009'] = returnsAbs2009;
    data['returns_abs_2010'] = returnsAbs2010;
    data['returns_abs_2011'] = returnsAbs2011;
    data['returns_abs_2012'] = returnsAbs2012;
    data['returns_abs_2013'] = returnsAbs2013;
    data['returns_abs_2014'] = returnsAbs2014;
    data['returns_abs_2015'] = returnsAbs2015;
    data['returns_abs_2016'] = returnsAbs2016;
    data['ter'] = ter;
    data['ter_date'] = terDate;
    data['price'] = price;
    data['price_change_onday'] = priceChangeOnday;
    data['price_change_percent_onday'] = priceChangePercentOnday;
    data['scheme_company'] = schemeCompany;
    data['scheme_asset_date'] = schemeAssetDate;
    data['scheme_assets'] = schemeAssets;
    data['riskometer'] = riskometer;
    data['nav_table'] = navTable;
    data['url'] = url;
    data['etf_scheme'] = etfScheme;
    data['isin_no'] = isinNo;
    data['isin_divreinvst_no'] = isinDivreinvstNo;
    data['isin_sweep_no'] = isinSweepNo;
    data['dividend_scheme'] = dividendScheme;
    data['scheme_plan_type'] = schemePlanType;
    data['returns_abs_7days_rank'] = returnsAbs7daysRank;
    data['returns_abs_1month_rank'] = returnsAbs1monthRank;
    data['returns_abs_3month_rank'] = returnsAbs3monthRank;
    data['returns_abs_6month_rank'] = returnsAbs6monthRank;
    data['returns_abs_ytd_rank'] = returnsAbsYtdRank;
    data['returns_abs_1year_rank'] = returnsAbs1yearRank;
    data['returns_cmp_2year_rank'] = returnsCmp2yearRank;
    data['returns_cmp_3year_rank'] = returnsCmp3yearRank;
    data['returns_cmp_4year_rank'] = returnsCmp4yearRank;
    data['returns_cmp_5year_rank'] = returnsCmp5yearRank;
    data['returns_cmp_10year_rank'] = returnsCmp10yearRank;
    data['returns_cmp_inception_rank'] = returnsCmpInceptionRank;
    data['returns_abs_7days_totalrank'] = returnsAbs7daysTotalrank;
    data['returns_abs_1month_totalrank'] = returnsAbs1monthTotalrank;
    data['returns_abs_3month_totalrank'] = returnsAbs3monthTotalrank;
    data['returns_abs_6month_totalrank'] = returnsAbs6monthTotalrank;
    data['returns_abs_ytd_totalrank'] = returnsAbsYtdTotalrank;
    data['returns_abs_1year_totalrank'] = returnsAbs1yearTotalrank;
    data['returns_cmp_2year_totalrank'] = returnsCmp2yearTotalrank;
    data['returns_cmp_3year_totalrank'] = returnsCmp3yearTotalrank;
    data['returns_cmp_4year_totalrank'] = returnsCmp4yearTotalrank;
    data['returns_cmp_5year_totalrank'] = returnsCmp5yearTotalrank;
    data['returns_cmp_10year_totalrank'] = returnsCmp10yearTotalrank;
    data['returns_cmp_inception_totalrank'] = returnsCmpInceptionTotalrank;
    data['scheme_company_short_name'] = schemeCompanyShortName;
    data['scheme_amfi_url'] = schemeAmfiUrl;
    data['largecap_percent'] = largecapPercent;
    data['midcap_percent'] = midcapPercent;
    data['smallcap_percent'] = smallcapPercent;
    data['scheme_manager'] = schemeManager;
    data['ytm'] = ytm;
    data['avg_maturity'] = avgMaturity;
    data['modified_duration'] = modifiedDuration;
    data['rating_sov'] = ratingSov;
    data['rating_aaa'] = ratingAaa;
    data['rating_aa'] = ratingAa;
    data['rating_others'] = ratingOthers;
    data['rating_a'] = ratingA;
    data['rating_d'] = ratingD;
    data['rating_bb'] = ratingBb;
    data['rating_unrated'] = ratingUnrated;
    data['rating_c'] = ratingC;
    data['rating_bbb'] = ratingBbb;
    data['rating_b'] = ratingB;
    data['scheme_benchmark'] = schemeBenchmark;
    data['ve_ytm'] = veYtm;
    data['standard_deviation'] = standardDeviation;
    data['market_cap_largecap_percent'] = marketCapLargecapPercent;
    data['market_cap_midcap_percent'] = marketCapMidcapPercent;
    data['market_cap_smallcap_percent'] = marketCapSmallcapPercent;
    data['average_maturity'] = averageMaturity;
    data['alpha'] = alpha;
    data['beta'] = beta;
    data['r2'] = r2;
    data['sharpratio'] = sharpratio;
    data['mean'] = mean;
    data['scheme_amfi_common'] = schemeAmfiCommon;
    data['category_short_name'] = categoryShortName;
    data['scheme_sub_category'] = schemeSubCategory;
    data['sector1'] = sector1;
    data['sector1_hold'] = sector1Hold;
    data['sector2'] = sector2;
    data['sector2_hold'] = sector2Hold;
    data['sector3'] = sector3;
    data['sector3_hold'] = sector3Hold;
    data['sector4'] = sector4;
    data['sector4_hold'] = sector4Hold;
    data['sector5'] = sector5;
    data['sector5_hold'] = sector5Hold;
    data['sector6'] = sector6;
    data['sector6_hold'] = sector6Hold;
    data['sector7'] = sector7;
    data['sector7_hold'] = sector7Hold;
    data['sector8'] = sector8;
    data['sector8_hold'] = sector8Hold;
    data['sector9'] = sector9;
    data['sector9_hold'] = sector9Hold;
    data['sector10'] = sector10;
    data['sector10_hold'] = sector10Hold;
    data['amc_logo'] = amcLogo;
    data['scheme_rating'] = schemeRating;
    data['inception_date_str'] = inceptionDateStr;
    data['high_nav52'] = highNav52;
    data['low_nav52'] = lowNav52;
    data['high_nav_inception'] = highNavInception;
    data['one_month_max_nav'] = oneMonthMaxNav;
    data['one_month_min_nav'] = oneMonthMinNav;
    data['three_month_max_nav'] = threeMonthMaxNav;
    data['three_month_min_nav'] = threeMonthMinNav;
    data['six_month_max_nav'] = sixMonthMaxNav;
    data['six_month_min_nav'] = sixMonthMinNav;
    data['one_year_max_nav'] = oneYearMaxNav;
    data['one_year_min_nav'] = oneYearMinNav;
    data['three_year_max_nav'] = threeYearMaxNav;
    data['three_year_min_nav'] = threeYearMinNav;
    data['five_year_max_nav'] = fiveYearMaxNav;
    data['five_year_min_nav'] = fiveYearMinNav;
    data['lumpsum_1year_value'] = lumpsum1yearValue;
    data['lumpsum_3year_value'] = lumpsum3yearValue;
    data['lumpsum_5year_value'] = lumpsum5yearValue;
    data['lumpsum_10year_value'] = lumpsum10yearValue;
    data['one_year_lumpsum_growth'] = oneYearLumpsumGrowth;
    data['three_year_lumpsum_growth'] = threeYearLumpsumGrowth;
    data['five_year_lumpsum_growth'] = fiveYearLumpsumGrowth;
    data['inception_lumpsum_growth'] = inceptionLumpsumGrowth;
    data['corpdebt_hold'] = corpdebtHold;
    data['fd_hold'] = fdHold;
    data['cod_hold'] = codHold;
    data['cpaper_hold'] = cpaperHold;
    data['tbill_hold'] = tbillHold;
    data['curr_liab_hold'] = currLiabHold;
    data['other_hold'] = otherHold;
    data['assets_hold'] = assetsHold;
    data['gsec_hold'] = gsecHold;
    data['cash_hold'] = cashHold;
    data['aggressive_allocation'] = aggressiveAllocation;
    data['mod_aggressive_allocation'] = modAggressiveAllocation;
    data['moderate_allocation'] = moderateAllocation;
    data['mod_conservative_allocation'] = modConservativeAllocation;
    data['conservative_allocation'] = conservativeAllocation;
    data['scheme_asset_str'] = schemeAssetStr;
    data['category_avg_return'] = categoryAvgReturn;
    data['allocation'] = allocation;
    return data;
  }
}

class PeerComparisonResponse {
  num? id;
  String? schemeVe;
  String? schemeVeCiticode;
  String? inceptionDate;
  String? priceDate;
  String? schemeAmfi;
  String? schemeAmfiShortName;
  String? schemeCategoryClass;
  String? schemeAmfiCode;
  String? schemeCategory;
  String? schemeBroadCategory;
  String? openOrClosed;
  num? returnsAbs7days;
  num? returnsAbs1month;
  num? returnsAbs3month;
  num? returnsAbs6month;
  num? returnsAbsYtd;
  num? returnsAbs1year;
  num? returnsCmp2year;
  num? returnsCmp3year;
  num? returnsCmp4year;
  num? returnsCmp5year;
  num? returnsCmp10year;
  num? returnsCmpInception;
  num? returnsAbs2007;
  num? returnsAbs2008;
  num? returnsAbs2009;
  num? returnsAbs2010;
  num? returnsAbs2011;
  num? returnsAbs2012;
  num? returnsAbs2013;
  num? returnsAbs2014;
  num? returnsAbs2015;
  num? returnsAbs2016;
  num? ter;
  String? terDate;
  num? price;
  num? priceChangeOnday;
  num? priceChangePercentOnday;
  String? schemeCompany;
  String? schemeAssetDate;
  num? schemeAssets;
  String? riskometer;
  String? navTable;
  String? url;
  num? etfScheme;
  String? isinNo;
  String? isinDivreinvstNo;
  String? isinSweepNo;
  bool? dividendScheme;
  String? schemePlanType;
  num? returnsAbs7daysRank;
  num? returnsAbs1monthRank;
  num? returnsAbs3monthRank;
  num? returnsAbs6monthRank;
  num? returnsAbsYtdRank;
  num? returnsAbs1yearRank;
  num? returnsCmp2yearRank;
  num? returnsCmp3yearRank;
  num? returnsCmp4yearRank;
  num? returnsCmp5yearRank;
  num? returnsCmp10yearRank;
  num? returnsCmpInceptionRank;
  num? returnsAbs7daysTotalrank;
  num? returnsAbs1monthTotalrank;
  num? returnsAbs3monthTotalrank;
  num? returnsAbs6monthTotalrank;
  num? returnsAbsYtdTotalrank;
  num? returnsAbs1yearTotalrank;
  num? returnsCmp2yearTotalrank;
  num? returnsCmp3yearTotalrank;
  num? returnsCmp4yearTotalrank;
  num? returnsCmp5yearTotalrank;
  num? returnsCmp10yearTotalrank;
  num? returnsCmpInceptionTotalrank;
  String? schemeCompanyShortName;
  String? schemeAmfiUrl;
  num? largecapPercent;
  num? midcapPercent;
  num? smallcapPercent;
  String? schemeManager;
  num? ytm;
  num? avgMaturity;
  num? modifiedDuration;
  num? ratingSov;
  num? ratingAaa;
  num? ratingAa;
  num? ratingOthers;
  num? ratingA;
  num? ratingD;
  num? ratingBb;
  num? ratingUnrated;
  num? ratingC;
  num? ratingBbb;
  num? ratingB;
  String? schemeBenchmark;
  String? veYtm;
  String? standardDeviation;
  String? marketCapLargecapPercent;
  String? marketCapMidcapPercent;
  String? marketCapSmallcapPercent;
  String? averageMaturity;
  String? alpha;
  String? beta;
  String? r2;
  String? sharpratio;
  String? mean;
  String? schemeAmfiCommon;
  String? categoryShortName;
  String? schemeSubCategory;
  String? sector1;
  num? sector1Hold;
  String? sector2;
  num? sector2Hold;
  String? sector3;
  num? sector3Hold;
  String? sector4;
  num? sector4Hold;
  String? sector5;
  num? sector5Hold;
  String? sector6;
  num? sector6Hold;
  String? sector7;
  num? sector7Hold;
  String? sector8;
  num? sector8Hold;
  String? sector9;
  num? sector9Hold;
  String? sector10;
  num? sector10Hold;
  String? amcLogo;
  String? schemeRating;
  String? inceptionDateStr;
  num? highNav52;
  num? lowNav52;
  num? highNavInception;
  num? oneMonthMaxNav;
  num? oneMonthMinNav;
  num? threeMonthMaxNav;
  num? threeMonthMinNav;
  num? sixMonthMaxNav;
  num? sixMonthMinNav;
  num? oneYearMaxNav;
  num? oneYearMinNav;
  num? threeYearMaxNav;
  num? threeYearMinNav;
  num? fiveYearMaxNav;
  num? fiveYearMinNav;
  String? lumpsum1yearValue;
  String? lumpsum3yearValue;
  String? lumpsum5yearValue;
  String? lumpsum10yearValue;
  String? oneYearLumpsumGrowth;
  String? threeYearLumpsumGrowth;
  String? fiveYearLumpsumGrowth;
  String? inceptionLumpsumGrowth;
  num? corpdebtHold;
  num? fdHold;
  num? codHold;
  num? cpaperHold;
  num? tbillHold;
  num? currLiabHold;
  num? otherHold;
  num? assetsHold;
  num? gsecHold;
  num? cashHold;
  String? aggressiveAllocation;
  String? modAggressiveAllocation;
  String? moderateAllocation;
  String? modConservativeAllocation;
  String? conservativeAllocation;
  String? schemeAssetStr;
  String? categoryAvgReturn;
  String? allocation;

  PeerComparisonResponse(
      {this.id,
      this.schemeVe,
      this.schemeVeCiticode,
      this.inceptionDate,
      this.priceDate,
      this.schemeAmfi,
      this.schemeAmfiShortName,
      this.schemeCategoryClass,
      this.schemeAmfiCode,
      this.schemeCategory,
      this.schemeBroadCategory,
      this.openOrClosed,
      this.returnsAbs7days,
      this.returnsAbs1month,
      this.returnsAbs3month,
      this.returnsAbs6month,
      this.returnsAbsYtd,
      this.returnsAbs1year,
      this.returnsCmp2year,
      this.returnsCmp3year,
      this.returnsCmp4year,
      this.returnsCmp5year,
      this.returnsCmp10year,
      this.returnsCmpInception,
      this.returnsAbs2007,
      this.returnsAbs2008,
      this.returnsAbs2009,
      this.returnsAbs2010,
      this.returnsAbs2011,
      this.returnsAbs2012,
      this.returnsAbs2013,
      this.returnsAbs2014,
      this.returnsAbs2015,
      this.returnsAbs2016,
      this.ter,
      this.terDate,
      this.price,
      this.priceChangeOnday,
      this.priceChangePercentOnday,
      this.schemeCompany,
      this.schemeAssetDate,
      this.schemeAssets,
      this.riskometer,
      this.navTable,
      this.url,
      this.etfScheme,
      this.isinNo,
      this.isinDivreinvstNo,
      this.isinSweepNo,
      this.dividendScheme,
      this.schemePlanType,
      this.returnsAbs7daysRank,
      this.returnsAbs1monthRank,
      this.returnsAbs3monthRank,
      this.returnsAbs6monthRank,
      this.returnsAbsYtdRank,
      this.returnsAbs1yearRank,
      this.returnsCmp2yearRank,
      this.returnsCmp3yearRank,
      this.returnsCmp4yearRank,
      this.returnsCmp5yearRank,
      this.returnsCmp10yearRank,
      this.returnsCmpInceptionRank,
      this.returnsAbs7daysTotalrank,
      this.returnsAbs1monthTotalrank,
      this.returnsAbs3monthTotalrank,
      this.returnsAbs6monthTotalrank,
      this.returnsAbsYtdTotalrank,
      this.returnsAbs1yearTotalrank,
      this.returnsCmp2yearTotalrank,
      this.returnsCmp3yearTotalrank,
      this.returnsCmp4yearTotalrank,
      this.returnsCmp5yearTotalrank,
      this.returnsCmp10yearTotalrank,
      this.returnsCmpInceptionTotalrank,
      this.schemeCompanyShortName,
      this.schemeAmfiUrl,
      this.largecapPercent,
      this.midcapPercent,
      this.smallcapPercent,
      this.schemeManager,
      this.ytm,
      this.avgMaturity,
      this.modifiedDuration,
      this.ratingSov,
      this.ratingAaa,
      this.ratingAa,
      this.ratingOthers,
      this.ratingA,
      this.ratingD,
      this.ratingBb,
      this.ratingUnrated,
      this.ratingC,
      this.ratingBbb,
      this.ratingB,
      this.schemeBenchmark,
      this.veYtm,
      this.standardDeviation,
      this.marketCapLargecapPercent,
      this.marketCapMidcapPercent,
      this.marketCapSmallcapPercent,
      this.averageMaturity,
      this.alpha,
      this.beta,
      this.r2,
      this.sharpratio,
      this.mean,
      this.schemeAmfiCommon,
      this.categoryShortName,
      this.schemeSubCategory,
      this.sector1,
      this.sector1Hold,
      this.sector2,
      this.sector2Hold,
      this.sector3,
      this.sector3Hold,
      this.sector4,
      this.sector4Hold,
      this.sector5,
      this.sector5Hold,
      this.sector6,
      this.sector6Hold,
      this.sector7,
      this.sector7Hold,
      this.sector8,
      this.sector8Hold,
      this.sector9,
      this.sector9Hold,
      this.sector10,
      this.sector10Hold,
      this.amcLogo,
      this.schemeRating,
      this.inceptionDateStr,
      this.highNav52,
      this.lowNav52,
      this.highNavInception,
      this.oneMonthMaxNav,
      this.oneMonthMinNav,
      this.threeMonthMaxNav,
      this.threeMonthMinNav,
      this.sixMonthMaxNav,
      this.sixMonthMinNav,
      this.oneYearMaxNav,
      this.oneYearMinNav,
      this.threeYearMaxNav,
      this.threeYearMinNav,
      this.fiveYearMaxNav,
      this.fiveYearMinNav,
      this.lumpsum1yearValue,
      this.lumpsum3yearValue,
      this.lumpsum5yearValue,
      this.lumpsum10yearValue,
      this.oneYearLumpsumGrowth,
      this.threeYearLumpsumGrowth,
      this.fiveYearLumpsumGrowth,
      this.inceptionLumpsumGrowth,
      this.corpdebtHold,
      this.fdHold,
      this.codHold,
      this.cpaperHold,
      this.tbillHold,
      this.currLiabHold,
      this.otherHold,
      this.assetsHold,
      this.gsecHold,
      this.cashHold,
      this.aggressiveAllocation,
      this.modAggressiveAllocation,
      this.moderateAllocation,
      this.modConservativeAllocation,
      this.conservativeAllocation,
      this.schemeAssetStr,
      this.categoryAvgReturn,
      this.allocation});

  PeerComparisonResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schemeVe = json['scheme_ve'];
    schemeVeCiticode = json['scheme_ve_citicode'];
    inceptionDate = json['inception_date'];
    priceDate = json['price_date'];
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeCategoryClass = json['scheme_category_class'];
    schemeAmfiCode = json['scheme_amfi_code'];
    schemeCategory = json['scheme_category'];
    schemeBroadCategory = json['scheme_broad_category'];
    openOrClosed = json['open_or_closed'];
    returnsAbs7days = json['returns_abs_7days'];
    returnsAbs1month = json['returns_abs_1month'];
    returnsAbs3month = json['returns_abs_3month'];
    returnsAbs6month = json['returns_abs_6month'];
    returnsAbsYtd = json['returns_abs_ytd'];
    returnsAbs1year = json['returns_abs_1year'];
    returnsCmp2year = json['returns_cmp_2year'];
    returnsCmp3year = json['returns_cmp_3year'];
    returnsCmp4year = json['returns_cmp_4year'];
    returnsCmp5year = json['returns_cmp_5year'];
    returnsCmp10year = json['returns_cmp_10year'];
    returnsCmpInception = json['returns_cmp_inception'];
    returnsAbs2007 = json['returns_abs_2007'];
    returnsAbs2008 = json['returns_abs_2008'];
    returnsAbs2009 = json['returns_abs_2009'];
    returnsAbs2010 = json['returns_abs_2010'];
    returnsAbs2011 = json['returns_abs_2011'];
    returnsAbs2012 = json['returns_abs_2012'];
    returnsAbs2013 = json['returns_abs_2013'];
    returnsAbs2014 = json['returns_abs_2014'];
    returnsAbs2015 = json['returns_abs_2015'];
    returnsAbs2016 = json['returns_abs_2016'];
    ter = json['ter'];
    terDate = json['ter_date'];
    price = json['price'];
    priceChangeOnday = json['price_change_onday'];
    priceChangePercentOnday = json['price_change_percent_onday'];
    schemeCompany = json['scheme_company'];
    schemeAssetDate = json['scheme_asset_date'];
    schemeAssets = json['scheme_assets'];
    riskometer = json['riskometer'];
    navTable = json['nav_table'];
    url = json['url'];
    etfScheme = json['etf_scheme'];
    isinNo = json['isin_no'];
    isinDivreinvstNo = json['isin_divreinvst_no'];
    isinSweepNo = json['isin_sweep_no'];
    dividendScheme = json['dividend_scheme'];
    schemePlanType = json['scheme_plan_type'];
    returnsAbs7daysRank = json['returns_abs_7days_rank'];
    returnsAbs1monthRank = json['returns_abs_1month_rank'];
    returnsAbs3monthRank = json['returns_abs_3month_rank'];
    returnsAbs6monthRank = json['returns_abs_6month_rank'];
    returnsAbsYtdRank = json['returns_abs_ytd_rank'];
    returnsAbs1yearRank = json['returns_abs_1year_rank'];
    returnsCmp2yearRank = json['returns_cmp_2year_rank'];
    returnsCmp3yearRank = json['returns_cmp_3year_rank'];
    returnsCmp4yearRank = json['returns_cmp_4year_rank'];
    returnsCmp5yearRank = json['returns_cmp_5year_rank'];
    returnsCmp10yearRank = json['returns_cmp_10year_rank'];
    returnsCmpInceptionRank = json['returns_cmp_inception_rank'];
    returnsAbs7daysTotalrank = json['returns_abs_7days_totalrank'];
    returnsAbs1monthTotalrank = json['returns_abs_1month_totalrank'];
    returnsAbs3monthTotalrank = json['returns_abs_3month_totalrank'];
    returnsAbs6monthTotalrank = json['returns_abs_6month_totalrank'];
    returnsAbsYtdTotalrank = json['returns_abs_ytd_totalrank'];
    returnsAbs1yearTotalrank = json['returns_abs_1year_totalrank'];
    returnsCmp2yearTotalrank = json['returns_cmp_2year_totalrank'];
    returnsCmp3yearTotalrank = json['returns_cmp_3year_totalrank'];
    returnsCmp4yearTotalrank = json['returns_cmp_4year_totalrank'];
    returnsCmp5yearTotalrank = json['returns_cmp_5year_totalrank'];
    returnsCmp10yearTotalrank = json['returns_cmp_10year_totalrank'];
    returnsCmpInceptionTotalrank = json['returns_cmp_inception_totalrank'];
    schemeCompanyShortName = json['scheme_company_short_name'];
    schemeAmfiUrl = json['scheme_amfi_url'];
    largecapPercent = json['largecap_percent'];
    midcapPercent = json['midcap_percent'];
    smallcapPercent = json['smallcap_percent'];
    schemeManager = json['scheme_manager'];
    ytm = json['ytm'];
    avgMaturity = json['avg_maturity'];
    modifiedDuration = json['modified_duration'];
    ratingSov = json['rating_sov'];
    ratingAaa = json['rating_aaa'];
    ratingAa = json['rating_aa'];
    ratingOthers = json['rating_others'];
    ratingA = json['rating_a'];
    ratingD = json['rating_d'];
    ratingBb = json['rating_bb'];
    ratingUnrated = json['rating_unrated'];
    ratingC = json['rating_c'];
    ratingBbb = json['rating_bbb'];
    ratingB = json['rating_b'];
    schemeBenchmark = json['scheme_benchmark'];
    veYtm = json['ve_ytm'];
    standardDeviation = json['standard_deviation'];
    marketCapLargecapPercent = json['market_cap_largecap_percent'];
    marketCapMidcapPercent = json['market_cap_midcap_percent'];
    marketCapSmallcapPercent = json['market_cap_smallcap_percent'];
    averageMaturity = json['average_maturity'];
    alpha = json['alpha'];
    beta = json['beta'];
    r2 = json['r2'];
    sharpratio = json['sharpratio'];
    mean = json['mean'];
    schemeAmfiCommon = json['scheme_amfi_common'];
    categoryShortName = json['category_short_name'];
    schemeSubCategory = json['scheme_sub_category'];
    sector1 = json['sector1'];
    sector1Hold = json['sector1_hold'];
    sector2 = json['sector2'];
    sector2Hold = json['sector2_hold'];
    sector3 = json['sector3'];
    sector3Hold = json['sector3_hold'];
    sector4 = json['sector4'];
    sector4Hold = json['sector4_hold'];
    sector5 = json['sector5'];
    sector5Hold = json['sector5_hold'];
    sector6 = json['sector6'];
    sector6Hold = json['sector6_hold'];
    sector7 = json['sector7'];
    sector7Hold = json['sector7_hold'];
    sector8 = json['sector8'];
    sector8Hold = json['sector8_hold'];
    sector9 = json['sector9'];
    sector9Hold = json['sector9_hold'];
    sector10 = json['sector10'];
    sector10Hold = json['sector10_hold'];
    amcLogo = json['amc_logo'];
    schemeRating = json['scheme_rating'];
    inceptionDateStr = json['inception_date_str'];
    highNav52 = json['high_nav52'];
    lowNav52 = json['low_nav52'];
    highNavInception = json['high_nav_inception'];
    oneMonthMaxNav = json['one_month_max_nav'];
    oneMonthMinNav = json['one_month_min_nav'];
    threeMonthMaxNav = json['three_month_max_nav'];
    threeMonthMinNav = json['three_month_min_nav'];
    sixMonthMaxNav = json['six_month_max_nav'];
    sixMonthMinNav = json['six_month_min_nav'];
    oneYearMaxNav = json['one_year_max_nav'];
    oneYearMinNav = json['one_year_min_nav'];
    threeYearMaxNav = json['three_year_max_nav'];
    threeYearMinNav = json['three_year_min_nav'];
    fiveYearMaxNav = json['five_year_max_nav'];
    fiveYearMinNav = json['five_year_min_nav'];
    lumpsum1yearValue = json['lumpsum_1year_value'];
    lumpsum3yearValue = json['lumpsum_3year_value'];
    lumpsum5yearValue = json['lumpsum_5year_value'];
    lumpsum10yearValue = json['lumpsum_10year_value'];
    oneYearLumpsumGrowth = json['one_year_lumpsum_growth'];
    threeYearLumpsumGrowth = json['three_year_lumpsum_growth'];
    fiveYearLumpsumGrowth = json['five_year_lumpsum_growth'];
    inceptionLumpsumGrowth = json['inception_lumpsum_growth'];
    corpdebtHold = json['corpdebt_hold'];
    fdHold = json['fd_hold'];
    codHold = json['cod_hold'];
    cpaperHold = json['cpaper_hold'];
    tbillHold = json['tbill_hold'];
    currLiabHold = json['curr_liab_hold'];
    otherHold = json['other_hold'];
    assetsHold = json['assets_hold'];
    gsecHold = json['gsec_hold'];
    cashHold = json['cash_hold'];
    aggressiveAllocation = json['aggressive_allocation'];
    modAggressiveAllocation = json['mod_aggressive_allocation'];
    moderateAllocation = json['moderate_allocation'];
    modConservativeAllocation = json['mod_conservative_allocation'];
    conservativeAllocation = json['conservative_allocation'];
    schemeAssetStr = json['scheme_asset_str'];
    categoryAvgReturn = json['category_avg_return'];
    allocation = json['allocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['scheme_ve'] = schemeVe;
    data['scheme_ve_citicode'] = schemeVeCiticode;
    data['inception_date'] = inceptionDate;
    data['price_date'] = priceDate;
    data['scheme_amfi'] = schemeAmfi;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['scheme_category_class'] = schemeCategoryClass;
    data['scheme_amfi_code'] = schemeAmfiCode;
    data['scheme_category'] = schemeCategory;
    data['scheme_broad_category'] = schemeBroadCategory;
    data['open_or_closed'] = openOrClosed;
    data['returns_abs_7days'] = returnsAbs7days;
    data['returns_abs_1month'] = returnsAbs1month;
    data['returns_abs_3month'] = returnsAbs3month;
    data['returns_abs_6month'] = returnsAbs6month;
    data['returns_abs_ytd'] = returnsAbsYtd;
    data['returns_abs_1year'] = returnsAbs1year;
    data['returns_cmp_2year'] = returnsCmp2year;
    data['returns_cmp_3year'] = returnsCmp3year;
    data['returns_cmp_4year'] = returnsCmp4year;
    data['returns_cmp_5year'] = returnsCmp5year;
    data['returns_cmp_10year'] = returnsCmp10year;
    data['returns_cmp_inception'] = returnsCmpInception;
    data['returns_abs_2007'] = returnsAbs2007;
    data['returns_abs_2008'] = returnsAbs2008;
    data['returns_abs_2009'] = returnsAbs2009;
    data['returns_abs_2010'] = returnsAbs2010;
    data['returns_abs_2011'] = returnsAbs2011;
    data['returns_abs_2012'] = returnsAbs2012;
    data['returns_abs_2013'] = returnsAbs2013;
    data['returns_abs_2014'] = returnsAbs2014;
    data['returns_abs_2015'] = returnsAbs2015;
    data['returns_abs_2016'] = returnsAbs2016;
    data['ter'] = ter;
    data['ter_date'] = terDate;
    data['price'] = price;
    data['price_change_onday'] = priceChangeOnday;
    data['price_change_percent_onday'] = priceChangePercentOnday;
    data['scheme_company'] = schemeCompany;
    data['scheme_asset_date'] = schemeAssetDate;
    data['scheme_assets'] = schemeAssets;
    data['riskometer'] = riskometer;
    data['nav_table'] = navTable;
    data['url'] = url;
    data['etf_scheme'] = etfScheme;
    data['isin_no'] = isinNo;
    data['isin_divreinvst_no'] = isinDivreinvstNo;
    data['isin_sweep_no'] = isinSweepNo;
    data['dividend_scheme'] = dividendScheme;
    data['scheme_plan_type'] = schemePlanType;
    data['returns_abs_7days_rank'] = returnsAbs7daysRank;
    data['returns_abs_1month_rank'] = returnsAbs1monthRank;
    data['returns_abs_3month_rank'] = returnsAbs3monthRank;
    data['returns_abs_6month_rank'] = returnsAbs6monthRank;
    data['returns_abs_ytd_rank'] = returnsAbsYtdRank;
    data['returns_abs_1year_rank'] = returnsAbs1yearRank;
    data['returns_cmp_2year_rank'] = returnsCmp2yearRank;
    data['returns_cmp_3year_rank'] = returnsCmp3yearRank;
    data['returns_cmp_4year_rank'] = returnsCmp4yearRank;
    data['returns_cmp_5year_rank'] = returnsCmp5yearRank;
    data['returns_cmp_10year_rank'] = returnsCmp10yearRank;
    data['returns_cmp_inception_rank'] = returnsCmpInceptionRank;
    data['returns_abs_7days_totalrank'] = returnsAbs7daysTotalrank;
    data['returns_abs_1month_totalrank'] = returnsAbs1monthTotalrank;
    data['returns_abs_3month_totalrank'] = returnsAbs3monthTotalrank;
    data['returns_abs_6month_totalrank'] = returnsAbs6monthTotalrank;
    data['returns_abs_ytd_totalrank'] = returnsAbsYtdTotalrank;
    data['returns_abs_1year_totalrank'] = returnsAbs1yearTotalrank;
    data['returns_cmp_2year_totalrank'] = returnsCmp2yearTotalrank;
    data['returns_cmp_3year_totalrank'] = returnsCmp3yearTotalrank;
    data['returns_cmp_4year_totalrank'] = returnsCmp4yearTotalrank;
    data['returns_cmp_5year_totalrank'] = returnsCmp5yearTotalrank;
    data['returns_cmp_10year_totalrank'] = returnsCmp10yearTotalrank;
    data['returns_cmp_inception_totalrank'] = returnsCmpInceptionTotalrank;
    data['scheme_company_short_name'] = schemeCompanyShortName;
    data['scheme_amfi_url'] = schemeAmfiUrl;
    data['largecap_percent'] = largecapPercent;
    data['midcap_percent'] = midcapPercent;
    data['smallcap_percent'] = smallcapPercent;
    data['scheme_manager'] = schemeManager;
    data['ytm'] = ytm;
    data['avg_maturity'] = avgMaturity;
    data['modified_duration'] = modifiedDuration;
    data['rating_sov'] = ratingSov;
    data['rating_aaa'] = ratingAaa;
    data['rating_aa'] = ratingAa;
    data['rating_others'] = ratingOthers;
    data['rating_a'] = ratingA;
    data['rating_d'] = ratingD;
    data['rating_bb'] = ratingBb;
    data['rating_unrated'] = ratingUnrated;
    data['rating_c'] = ratingC;
    data['rating_bbb'] = ratingBbb;
    data['rating_b'] = ratingB;
    data['scheme_benchmark'] = schemeBenchmark;
    data['ve_ytm'] = veYtm;
    data['standard_deviation'] = standardDeviation;
    data['market_cap_largecap_percent'] = marketCapLargecapPercent;
    data['market_cap_midcap_percent'] = marketCapMidcapPercent;
    data['market_cap_smallcap_percent'] = marketCapSmallcapPercent;
    data['average_maturity'] = averageMaturity;
    data['alpha'] = alpha;
    data['beta'] = beta;
    data['r2'] = r2;
    data['sharpratio'] = sharpratio;
    data['mean'] = mean;
    data['scheme_amfi_common'] = schemeAmfiCommon;
    data['category_short_name'] = categoryShortName;
    data['scheme_sub_category'] = schemeSubCategory;
    data['sector1'] = sector1;
    data['sector1_hold'] = sector1Hold;
    data['sector2'] = sector2;
    data['sector2_hold'] = sector2Hold;
    data['sector3'] = sector3;
    data['sector3_hold'] = sector3Hold;
    data['sector4'] = sector4;
    data['sector4_hold'] = sector4Hold;
    data['sector5'] = sector5;
    data['sector5_hold'] = sector5Hold;
    data['sector6'] = sector6;
    data['sector6_hold'] = sector6Hold;
    data['sector7'] = sector7;
    data['sector7_hold'] = sector7Hold;
    data['sector8'] = sector8;
    data['sector8_hold'] = sector8Hold;
    data['sector9'] = sector9;
    data['sector9_hold'] = sector9Hold;
    data['sector10'] = sector10;
    data['sector10_hold'] = sector10Hold;
    data['amc_logo'] = amcLogo;
    data['scheme_rating'] = schemeRating;
    data['inception_date_str'] = inceptionDateStr;
    data['high_nav52'] = highNav52;
    data['low_nav52'] = lowNav52;
    data['high_nav_inception'] = highNavInception;
    data['one_month_max_nav'] = oneMonthMaxNav;
    data['one_month_min_nav'] = oneMonthMinNav;
    data['three_month_max_nav'] = threeMonthMaxNav;
    data['three_month_min_nav'] = threeMonthMinNav;
    data['six_month_max_nav'] = sixMonthMaxNav;
    data['six_month_min_nav'] = sixMonthMinNav;
    data['one_year_max_nav'] = oneYearMaxNav;
    data['one_year_min_nav'] = oneYearMinNav;
    data['three_year_max_nav'] = threeYearMaxNav;
    data['three_year_min_nav'] = threeYearMinNav;
    data['five_year_max_nav'] = fiveYearMaxNav;
    data['five_year_min_nav'] = fiveYearMinNav;
    data['lumpsum_1year_value'] = lumpsum1yearValue;
    data['lumpsum_3year_value'] = lumpsum3yearValue;
    data['lumpsum_5year_value'] = lumpsum5yearValue;
    data['lumpsum_10year_value'] = lumpsum10yearValue;
    data['one_year_lumpsum_growth'] = oneYearLumpsumGrowth;
    data['three_year_lumpsum_growth'] = threeYearLumpsumGrowth;
    data['five_year_lumpsum_growth'] = fiveYearLumpsumGrowth;
    data['inception_lumpsum_growth'] = inceptionLumpsumGrowth;
    data['corpdebt_hold'] = corpdebtHold;
    data['fd_hold'] = fdHold;
    data['cod_hold'] = codHold;
    data['cpaper_hold'] = cpaperHold;
    data['tbill_hold'] = tbillHold;
    data['curr_liab_hold'] = currLiabHold;
    data['other_hold'] = otherHold;
    data['assets_hold'] = assetsHold;
    data['gsec_hold'] = gsecHold;
    data['cash_hold'] = cashHold;
    data['aggressive_allocation'] = aggressiveAllocation;
    data['mod_aggressive_allocation'] = modAggressiveAllocation;
    data['moderate_allocation'] = moderateAllocation;
    data['mod_conservative_allocation'] = modConservativeAllocation;
    data['conservative_allocation'] = conservativeAllocation;
    data['scheme_asset_str'] = schemeAssetStr;
    data['category_avg_return'] = categoryAvgReturn;
    data['allocation'] = allocation;
    return data;
  }
}

class FundPerformanceOverviewAgainstBenchmarkAndCategoryResponse {
  SchemePerformances? schemePerformances;
  SchemePerformancesBenchmark? schemePerformancesBenchmark;
  SchemePerformancesCategory? schemePerformancesCategory;
  String? peerComparisonList;
  String? fundName;
  String? fundYtd;
  String? fundOneMonth;
  String? fundThreeMonth;
  String? fundOneYear;
  String? fundThreeYear;
  String? fundFiveYear;
  String? fundTenYear;
  String? categoryName;
  String? categoryYtd;
  String? categoryMonth;
  String? categoryThreeMonth;
  String? categoryOneYear;
  String? categoryThreeYear;
  String? categoryFiveYear;
  String? categoryTenYear;
  num? rankYtd;
  num? rankMonth;
  num? rankThreeMonth;
  num? rankOneYear;
  num? rankThreeYear;
  num? rankFiveYear;
  num? rankTenYear;
  num? noOfFundsYtd;
  num? noOfFundsOneMonth;
  num? noOfFundsThreeMonth;
  num? noOfFundsOneYear;
  num? noOfFundsThreeYear;
  num? noOfFundsFiveYear;
  num? noOfFundsTenYear;

  FundPerformanceOverviewAgainstBenchmarkAndCategoryResponse(
      {this.schemePerformances,
      this.schemePerformancesBenchmark,
      this.schemePerformancesCategory,
      this.peerComparisonList,
      this.fundName,
      this.fundYtd,
      this.fundOneMonth,
      this.fundThreeMonth,
      this.fundOneYear,
      this.fundThreeYear,
      this.fundFiveYear,
      this.fundTenYear,
      this.categoryName,
      this.categoryYtd,
      this.categoryMonth,
      this.categoryThreeMonth,
      this.categoryOneYear,
      this.categoryThreeYear,
      this.categoryFiveYear,
      this.categoryTenYear,
      this.rankYtd,
      this.rankMonth,
      this.rankThreeMonth,
      this.rankOneYear,
      this.rankThreeYear,
      this.rankFiveYear,
      this.rankTenYear,
      this.noOfFundsYtd,
      this.noOfFundsOneMonth,
      this.noOfFundsThreeMonth,
      this.noOfFundsOneYear,
      this.noOfFundsThreeYear,
      this.noOfFundsFiveYear,
      this.noOfFundsTenYear});

  FundPerformanceOverviewAgainstBenchmarkAndCategoryResponse.fromJson(
      Map<String, dynamic> json) {
    schemePerformances = json['schemePerformances'] != null
        ? SchemePerformances.fromJson(json['schemePerformances'])
        : null;
    schemePerformancesBenchmark = json['schemePerformancesBenchmark'] != null
        ? SchemePerformancesBenchmark.fromJson(
            json['schemePerformancesBenchmark'])
        : null;
    schemePerformancesCategory = json['schemePerformancesCategory'] != null
        ? SchemePerformancesCategory.fromJson(
            json['schemePerformancesCategory'])
        : null;
    peerComparisonList = json['peerComparisonList'];
    fundName = json['fund_name'];
    fundYtd = json['fund_ytd'];
    fundOneMonth = json['fund_one_month'];
    fundThreeMonth = json['fund_three_month'];
    fundOneYear = json['fund_one_year'];
    fundThreeYear = json['fund_three_year'];
    fundFiveYear = json['fund_five_year'];
    fundTenYear = json['fund_ten_year'];
    categoryName = json['category_name'];
    categoryYtd = json['category_ytd'];
    categoryMonth = json['category_month'];
    categoryThreeMonth = json['category_three_month'];
    categoryOneYear = json['category_one_year'];
    categoryThreeYear = json['category_three_year'];
    categoryFiveYear = json['category_five_year'];
    categoryTenYear = json['category_ten_year'];
    rankYtd = json['rank_ytd'];
    rankMonth = json['rank_month'];
    rankThreeMonth = json['rank_three_month'];
    rankOneYear = json['rank_one_year'];
    rankThreeYear = json['rank_three_year'];
    rankFiveYear = json['rank_five_year'];
    rankTenYear = json['rank_ten_year'];
    noOfFundsYtd = json['no_of_funds_ytd'];
    noOfFundsOneMonth = json['no_of_funds_one_month'];
    noOfFundsThreeMonth = json['no_of_funds_three_month'];
    noOfFundsOneYear = json['no_of_funds_one_year'];
    noOfFundsThreeYear = json['no_of_funds_three_year'];
    noOfFundsFiveYear = json['no_of_funds_five_year'];
    noOfFundsTenYear = json['no_of_funds_ten_year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (schemePerformances != null) {
      data['schemePerformances'] = schemePerformances!.toJson();
    }
    if (schemePerformancesBenchmark != null) {
      data['schemePerformancesBenchmark'] =
          schemePerformancesBenchmark!.toJson();
    }
    if (schemePerformancesCategory != null) {
      data['schemePerformancesCategory'] = schemePerformancesCategory!.toJson();
    }
    data['peerComparisonList'] = peerComparisonList;
    data['fund_name'] = fundName;
    data['fund_ytd'] = fundYtd;
    data['fund_one_month'] = fundOneMonth;
    data['fund_three_month'] = fundThreeMonth;
    data['fund_one_year'] = fundOneYear;
    data['fund_three_year'] = fundThreeYear;
    data['fund_five_year'] = fundFiveYear;
    data['fund_ten_year'] = fundTenYear;
    data['category_name'] = categoryName;
    data['category_ytd'] = categoryYtd;
    data['category_month'] = categoryMonth;
    data['category_three_month'] = categoryThreeMonth;
    data['category_one_year'] = categoryOneYear;
    data['category_three_year'] = categoryThreeYear;
    data['category_five_year'] = categoryFiveYear;
    data['category_ten_year'] = categoryTenYear;
    data['rank_ytd'] = rankYtd;
    data['rank_month'] = rankMonth;
    data['rank_three_month'] = rankThreeMonth;
    data['rank_one_year'] = rankOneYear;
    data['rank_three_year'] = rankThreeYear;
    data['rank_five_year'] = rankFiveYear;
    data['rank_ten_year'] = rankTenYear;
    data['no_of_funds_ytd'] = noOfFundsYtd;
    data['no_of_funds_one_month'] = noOfFundsOneMonth;
    data['no_of_funds_three_month'] = noOfFundsThreeMonth;
    data['no_of_funds_one_year'] = noOfFundsOneYear;
    data['no_of_funds_three_year'] = noOfFundsThreeYear;
    data['no_of_funds_five_year'] = noOfFundsFiveYear;
    data['no_of_funds_ten_year'] = noOfFundsTenYear;
    return data;
  }
}

class SchemePerformancesBenchmark {
  num? id;
  String? benchmarkName;
  String? citicode;
  String? priceDate;
  num? returnsAbs7days;
  num? returnsAbs1month;
  num? returnsAbs3month;
  num? returnsAbs6month;
  num? returnsAbsYtd;
  num? returnsAbs1year;
  num? returnsCmp2year;
  num? returnsCmp3year;
  num? returnsCmp4year;
  num? returnsCmp5year;
  num? returnsCmp10year;
  num? returnsCmpInception;
  num? returnsAbs2012;
  num? returnsAbs2013;
  num? returnsAbs2014;
  num? returnsAbs2015;
  num? returnsAbs2016;
  num? returnsCmp8year;
  num? returnsAbs2007;
  num? returnsAbs2008;
  num? returnsAbs2009;
  num? returnsAbs2010;
  num? returnsAbs2011;

  SchemePerformancesBenchmark(
      {this.id,
      this.benchmarkName,
      this.citicode,
      this.priceDate,
      this.returnsAbs7days,
      this.returnsAbs1month,
      this.returnsAbs3month,
      this.returnsAbs6month,
      this.returnsAbsYtd,
      this.returnsAbs1year,
      this.returnsCmp2year,
      this.returnsCmp3year,
      this.returnsCmp4year,
      this.returnsCmp5year,
      this.returnsCmp10year,
      this.returnsCmpInception,
      this.returnsAbs2012,
      this.returnsAbs2013,
      this.returnsAbs2014,
      this.returnsAbs2015,
      this.returnsAbs2016,
      this.returnsCmp8year,
      this.returnsAbs2007,
      this.returnsAbs2008,
      this.returnsAbs2009,
      this.returnsAbs2010,
      this.returnsAbs2011});

  SchemePerformancesBenchmark.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    benchmarkName = json['benchmark_name'];
    citicode = json['citicode'];
    priceDate = json['price_date'];
    returnsAbs7days = json['returns_abs_7days'];
    returnsAbs1month = json['returns_abs_1month'];
    returnsAbs3month = json['returns_abs_3month'];
    returnsAbs6month = json['returns_abs_6month'];
    returnsAbsYtd = json['returns_abs_ytd'];
    returnsAbs1year = json['returns_abs_1year'];
    returnsCmp2year = json['returns_cmp_2year'];
    returnsCmp3year = json['returns_cmp_3year'];
    returnsCmp4year = json['returns_cmp_4year'];
    returnsCmp5year = json['returns_cmp_5year'];
    returnsCmp10year = json['returns_cmp_10year'];
    returnsCmpInception = json['returns_cmp_inception'];
    returnsAbs2012 = json['returns_abs_2012'];
    returnsAbs2013 = json['returns_abs_2013'];
    returnsAbs2014 = json['returns_abs_2014'];
    returnsAbs2015 = json['returns_abs_2015'];
    returnsAbs2016 = json['returns_abs_2016'];
    returnsCmp8year = json['returns_cmp_8year'];
    returnsAbs2007 = json['returns_abs_2007'];
    returnsAbs2008 = json['returns_abs_2008'];
    returnsAbs2009 = json['returns_abs_2009'];
    returnsAbs2010 = json['returns_abs_2010'];
    returnsAbs2011 = json['returns_abs_2011'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['benchmark_name'] = benchmarkName;
    data['citicode'] = citicode;
    data['price_date'] = priceDate;
    data['returns_abs_7days'] = returnsAbs7days;
    data['returns_abs_1month'] = returnsAbs1month;
    data['returns_abs_3month'] = returnsAbs3month;
    data['returns_abs_6month'] = returnsAbs6month;
    data['returns_abs_ytd'] = returnsAbsYtd;
    data['returns_abs_1year'] = returnsAbs1year;
    data['returns_cmp_2year'] = returnsCmp2year;
    data['returns_cmp_3year'] = returnsCmp3year;
    data['returns_cmp_4year'] = returnsCmp4year;
    data['returns_cmp_5year'] = returnsCmp5year;
    data['returns_cmp_10year'] = returnsCmp10year;
    data['returns_cmp_inception'] = returnsCmpInception;
    data['returns_abs_2012'] = returnsAbs2012;
    data['returns_abs_2013'] = returnsAbs2013;
    data['returns_abs_2014'] = returnsAbs2014;
    data['returns_abs_2015'] = returnsAbs2015;
    data['returns_abs_2016'] = returnsAbs2016;
    data['returns_cmp_8year'] = returnsCmp8year;
    data['returns_abs_2007'] = returnsAbs2007;
    data['returns_abs_2008'] = returnsAbs2008;
    data['returns_abs_2009'] = returnsAbs2009;
    data['returns_abs_2010'] = returnsAbs2010;
    data['returns_abs_2011'] = returnsAbs2011;
    return data;
  }
}

class SchemePerformancesCategory {
  num? id;
  String? sector;
  num? returnsAbs7days;
  num? returnsAbs1month;
  num? returnsAbs3month;
  num? returnsAbs6month;
  num? returnsAbsYtd;
  num? returnsAbs1year;
  num? returnsCmp2year;
  num? returnsCmp3year;
  num? returnsCmp4year;
  num? returnsCmp5year;
  num? returnsCmp10year;
  num? returnsCmpInception;
  num? returnsAbs2012;
  num? returnsAbs2013;
  num? returnsAbs2014;
  num? returnsAbs2015;
  num? returnsAbs2016;
  num? volatilityCm3year;
  num? sharpratioCm3year;
  num? alphaCm1year;
  num? betaCm1year;
  num? yieldToMaturity;
  num? averageMaturity;
  num? returnsAbs2007;
  num? returnsAbs2008;
  num? returnsAbs2009;
  num? returnsAbs2010;
  num? returnsAbs2011;
  String? schemeBroadCategory;

  SchemePerformancesCategory(
      {this.id,
      this.sector,
      this.returnsAbs7days,
      this.returnsAbs1month,
      this.returnsAbs3month,
      this.returnsAbs6month,
      this.returnsAbsYtd,
      this.returnsAbs1year,
      this.returnsCmp2year,
      this.returnsCmp3year,
      this.returnsCmp4year,
      this.returnsCmp5year,
      this.returnsCmp10year,
      this.returnsCmpInception,
      this.returnsAbs2012,
      this.returnsAbs2013,
      this.returnsAbs2014,
      this.returnsAbs2015,
      this.returnsAbs2016,
      this.volatilityCm3year,
      this.sharpratioCm3year,
      this.alphaCm1year,
      this.betaCm1year,
      this.yieldToMaturity,
      this.averageMaturity,
      this.returnsAbs2007,
      this.returnsAbs2008,
      this.returnsAbs2009,
      this.returnsAbs2010,
      this.returnsAbs2011,
      this.schemeBroadCategory});

  SchemePerformancesCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sector = json['sector'];
    returnsAbs7days = json['returns_abs_7days'];
    returnsAbs1month = json['returns_abs_1month'];
    returnsAbs3month = json['returns_abs_3month'];
    returnsAbs6month = json['returns_abs_6month'];
    returnsAbsYtd = json['returns_abs_ytd'];
    returnsAbs1year = json['returns_abs_1year'];
    returnsCmp2year = json['returns_cmp_2year'];
    returnsCmp3year = json['returns_cmp_3year'];
    returnsCmp4year = json['returns_cmp_4year'];
    returnsCmp5year = json['returns_cmp_5year'];
    returnsCmp10year = json['returns_cmp_10year'];
    returnsCmpInception = json['returns_cmp_inception'];
    returnsAbs2012 = json['returns_abs_2012'];
    returnsAbs2013 = json['returns_abs_2013'];
    returnsAbs2014 = json['returns_abs_2014'];
    returnsAbs2015 = json['returns_abs_2015'];
    returnsAbs2016 = json['returns_abs_2016'];
    volatilityCm3year = json['volatility_cm_3year'];
    sharpratioCm3year = json['sharpratio_cm_3year'];
    alphaCm1year = json['alpha_cm_1year'];
    betaCm1year = json['beta_cm_1year'];
    yieldToMaturity = json['yield_to_maturity'];
    averageMaturity = json['average_maturity'];
    returnsAbs2007 = json['returns_abs_2007'];
    returnsAbs2008 = json['returns_abs_2008'];
    returnsAbs2009 = json['returns_abs_2009'];
    returnsAbs2010 = json['returns_abs_2010'];
    returnsAbs2011 = json['returns_abs_2011'];
    schemeBroadCategory = json['scheme_broad_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['sector'] = sector;
    data['returns_abs_7days'] = returnsAbs7days;
    data['returns_abs_1month'] = returnsAbs1month;
    data['returns_abs_3month'] = returnsAbs3month;
    data['returns_abs_6month'] = returnsAbs6month;
    data['returns_abs_ytd'] = returnsAbsYtd;
    data['returns_abs_1year'] = returnsAbs1year;
    data['returns_cmp_2year'] = returnsCmp2year;
    data['returns_cmp_3year'] = returnsCmp3year;
    data['returns_cmp_4year'] = returnsCmp4year;
    data['returns_cmp_5year'] = returnsCmp5year;
    data['returns_cmp_10year'] = returnsCmp10year;
    data['returns_cmp_inception'] = returnsCmpInception;
    data['returns_abs_2012'] = returnsAbs2012;
    data['returns_abs_2013'] = returnsAbs2013;
    data['returns_abs_2014'] = returnsAbs2014;
    data['returns_abs_2015'] = returnsAbs2015;
    data['returns_abs_2016'] = returnsAbs2016;
    data['volatility_cm_3year'] = volatilityCm3year;
    data['sharpratio_cm_3year'] = sharpratioCm3year;
    data['alpha_cm_1year'] = alphaCm1year;
    data['beta_cm_1year'] = betaCm1year;
    data['yield_to_maturity'] = yieldToMaturity;
    data['average_maturity'] = averageMaturity;
    data['returns_abs_2007'] = returnsAbs2007;
    data['returns_abs_2008'] = returnsAbs2008;
    data['returns_abs_2009'] = returnsAbs2009;
    data['returns_abs_2010'] = returnsAbs2010;
    data['returns_abs_2011'] = returnsAbs2011;
    data['scheme_broad_category'] = schemeBroadCategory;
    return data;
  }
}

class AmcDetails {
  String? amcName;
  String? startDate;
  String? website;
  String? address1;
  String? address2;
  String? address3;
  String? city;
  String? pincode;
  String? phone;
  String? fax;
  String? email;
  String? activeFunds;
  String? aumShare;
  String? aum;

  AmcDetails(
      {this.amcName,
      this.startDate,
      this.website,
      this.address1,
      this.address2,
      this.address3,
      this.city,
      this.pincode,
      this.phone,
      this.fax,
      this.email,
      this.activeFunds,
      this.aumShare,
      this.aum});

  AmcDetails.fromJson(Map<String, dynamic> json) {
    amcName = json['amc_name'];
    startDate = json['start_date'];
    website = json['website'];
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    city = json['city'];
    pincode = json['pincode'];
    phone = json['phone'];
    fax = json['fax'];
    email = json['email'];
    activeFunds = json['active_funds'];
    aumShare = json['aum_share'];
    aum = json['aum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['amc_name'] = amcName;
    data['start_date'] = startDate;
    data['website'] = website;
    data['address1'] = address1;
    data['address2'] = address2;
    data['address3'] = address3;
    data['city'] = city;
    data['pincode'] = pincode;
    data['phone'] = phone;
    data['fax'] = fax;
    data['email'] = email;
    data['active_funds'] = activeFunds;
    data['aum_share'] = aumShare;
    data['aum'] = aum;
    return data;
  }
}

class CreditRatings {
  String? key;
  String? value;

  CreditRatings({this.key, this.value});

  CreditRatings.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}
