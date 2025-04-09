import 'dart:convert';
import 'dart:developer';
import 'package:mymfbox2_0/Investor/Registration/PersonalInfo/Models/guardian_relation_response.dart';
import 'package:mymfbox2_0/Investor/Registration/PersonalInfo/Models/relationship_proof_response.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../Investor/Registration/JointHolder/Models/join_holder_detail_response.dart';
import '../../Investor/Registration/Models/country_code_model.dart';

class CommonOnBoardApi {
  static Future validateIfscCode({
    required int user_id,
    required String client_name,
    required String ifsc,
    required String bank_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/validateIfscCode?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&"
        "client_name=$client_name&ifsc=$ifsc&"
        "bank_name=$bank_name";

    print("validateIfscCode url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("validateIfscCode Response = $data");

    return data;
  }

  static Future checkPanKycStatus({
    required int user_id,
    required String client_name,
    required String pan,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/checkPanKycStatus?user_id=$user_id&client_name=$client_name&pan=$pan&key=${ApiConfig.apiKey}";

    print("checkPanKycStatus url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("checkPanKycStatus Response = $data");

    return data;
  }

  static Future getOnBoardingStatus({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getOnBoardingStatus?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    log("getOnBoardingStatus url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getOnBoardingStatus Response = $data");

    return data;
  }

  static Future getVendor({
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getVendor?key=${ApiConfig.apiKey}&client_name=$client_name";

    print("getVendor url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getVendor Response = $data");

    return data;
  }

  static Future saveInvestorInfo({
    required int user_id,
    required String client_name,
    required String broker_code,
    required String tax_status,
    required String tax_status_des,
    required String holding_nature,
    required String holding_nature_desc,
    required String pan,
    required String bse_client_code,
    required String inv_category,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/saveInvestorInfo?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&"
        "broker_code=$broker_code&tax_status=$tax_status&"
        "tax_status_des=$tax_status_des&"
        "holding_nature=$holding_nature&"
        "holding_nature_desc=$holding_nature_desc&"
        "pan=$pan&bse_client_code=$bse_client_code"
        "&inv_category=$inv_category&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("saveInvestorInfo url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("saveInvestorInfo Response = $data");

    return data;
  }

  static Future getArnCode({
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getArnCode?key=${ApiConfig.apiKey}&"
        "client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getArnCode url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getArnCode Response = $data");

    return data;
  }

  static Future getTaxStatus({
    required String client_name,
    required String bse_nse_mfu_flag,
    required String inv_category,
  }) async {
    String url = "${ApiConfig.apiUrl}/onboard/getTaxStatus?"
        "key=${ApiConfig.apiKey}&client_name=$client_name&"
        "bse_nse_mfu_flag=$bse_nse_mfu_flag&inv_category=$inv_category";

    print("getTaxStatus url =  $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("getTaxStatus Response = $data");

    return data;
  }

  static Future getHoldingNature({
    required String client_name,
    required String bse_nse_mfu_flag,
    required String tax_status_code,
    String inv_category = "",
  }) async {
    String url = "${ApiConfig.apiUrl}/onboard/getHoldingNature?"
        "key=${ApiConfig.apiKey}&client_name=$client_name&"
        "bse_nse_mfu_flag=$bse_nse_mfu_flag&tax_status=$tax_status_code&inv_category=$inv_category";

    print("getHoldingNature url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("getHoldingNature Response = $data");

    return data;
  }

  static Future getEmailOrMobileRelation({
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url = "${ApiConfig.apiUrl}/onboard/getEmailOrMobileRelation?"
        "key=${ApiConfig.apiKey}&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getEmailOrMobileRelation url = $url");

    http.Response response = await http.post(Uri.parse(url));

    Map data = jsonDecode(response.body);

    print("getEmailOrMobileRelation Response = $data");

    return data;
  }

  static Future<JointHolderDetailsResponse> getJointHolderDetails({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getJointHolderInfo?user_id=$user_id&client_name=$client_name&key=${ApiConfig.apiKey}";

    print("getJointHolderDetails url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    final res = JointHolderDetailsResponse.fromJson(jsonDecode(response.body));

    print("getCountryList Response = $data");

    return res;
  }

  static Future<CountryListResponse> getCountryList({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url = "${ApiConfig.apiUrl}/onboard/getCountryList?"
        "user_id=$user_id&client_name=$client_name&key=${ApiConfig.apiKey}&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getCountryList url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    final res = CountryListResponse.fromJson(jsonDecode(response.body));

    print("getCountryList Response = $data");

    return res;
  }

  static Future getAddressType({
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url = "${ApiConfig.apiUrl}/onboard/getAddressType?"
        "key=${ApiConfig.apiKey}&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getAddressType url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getAddressType Response = $data");

    return data;
  }

  static Future getEmploymentStatus({
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url = "${ApiConfig.apiUrl}/onboard/getEmploymentStatus?"
        "key=${ApiConfig.apiKey}&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getEmploymentStatus url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("getEmploymentStatus Response = $data");

    return data;
  }

  static Future getAnnualSalary({
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url = "${ApiConfig.apiUrl}/onboard/getAnnualSalary?"
        "key=${ApiConfig.apiKey}&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getAnnualSalary url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("getAnnualSalary Response = $data");

    return data;
  }

  static Future getSourceOfIncome({
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url = "${ApiConfig.apiUrl}/onboard/getSourceOfIncome?"
        "key=${ApiConfig.apiKey}&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getSourceOfIncome url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("getSourceOfIncome Response = $data");

    return data;
  }

  static Future getPoliticalRelationship({
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url = "${ApiConfig.apiUrl}/onboard/getPoliticalRelationship?"
        "key=${ApiConfig.apiKey}&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getPoliticalRelationship url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("getPoliticalRelationship Response = $data");

    return data;
  }

  static Future savePersonalInfo({
    required int user_id,
    required String client_name,
    required String name,
    String? dob,
    required String gender,
    required String email,
    required String email_relation,
    required String mobile,
    required String mobile_relation,
    required String alter_mobile,
    required String alter_email,
    required String phone_office,
    required String phone_residence,
    required String place_birth,
    required String country_birth,
    required String country_birth_code,
    required String occupation,
    required String occupation_code,
    required String occupation_other,
    required String income,
    required String income_code,
    required String source_wealth,
    required String source_wealth_code,
    required String source_wealth_other,
    required String political_status,
    required String political_status_code,
    required String guard_name,
    required String guard_pan,
    required String guard_dob,
    required String guard_relation,
    required String guard_account_relation,
    required String guard_relation_proof,
    required String father_name,
    required String address_type,
    required String address_type_desc,
    required String networth_dob,
    required String networth_amount,
    required String bse_nse_mfu_flag,
    required String mobile_isd_code,
    String? guardMobileNumber,
    String? guardEmail,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/savePersonalInfo?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&name=$name&"
        "dob=$dob&gender=$gender&email=$email&"
        "email_relation=$email_relation&mobile=$mobile&mobile_relation=$mobile_relation&"
        "alter_mobile=$alter_mobile&alter_email=$alter_email&"
        "phone_office=$phone_office&phone_residence=$phone_residence&"
        "place_birth=$place_birth&country_birth=$country_birth&"
        "country_birth_code=$country_birth_code&occupation=$occupation&"
        "occupation_code=$occupation_code&occupation_other=$occupation_other&"
        "income=$income&income_code=$income_code&source_wealth=$source_wealth&"
        "source_wealth_code=$source_wealth_code&source_wealth_other=$source_wealth_other&"
        "political_status=$political_status&political_status_code=$political_status_code&"
        "guard_name=$guard_name&guard_pan=$guard_pan&guard_dob=$guard_dob&"
        "guard_relation=$guard_relation&guard_relation_proof=$guard_relation_proof&guard_account_relation=$guard_account_relation&"
        "father_name=$father_name&address_type=$address_type&"
        "address_type_desc=$address_type_desc&networth_dob=$networth_dob&"
        "networth_amount=$networth_amount&bse_nse_mfu_flag=$bse_nse_mfu_flag&mobile_isd_code=$mobile_isd_code&guard_mobile=${guardMobileNumber ?? ''}&guard_email=${guardEmail ?? ''}";

    print("savePersonalInfo url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("savePersonalInfo Response = $data");

    return data;
  }

  static Future saveNriInfo({
    required int user_id,
    required String client_name,
    required String nri_address1,
    required String nri_address2,
    required String nri_address3,
    required String nri_city,
    required String nri_state,
    required String nri_pincode,
    required String nri_country,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/saveNriInfo?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&nri_address1=$nri_address1&nri_address2=$nri_address2&nri_address3=$nri_address3"
        "&nri_city=$nri_city&nri_state=$nri_state&nri_pincode=$nri_pincode&nri_country=$nri_country&bse_nse_mfu_flag=$bse_nse_mfu_flag";
    print("saveNriInfo url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("saveNriInfo response = $data");

    return data;
  }

  static Future getCityStateByPincode({
    required int user_id,
    required String client_name,
    required String pincode,
    String bse_nse_mfu_flag = "",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getCityStateByPincode?key=${ApiConfig.apiKey}&user_id=$user_id&bse_nse_mfu_flag=$bse_nse_mfu_flag"
        "&client_name=$client_name&pincode=$pincode";

    print("getCityStateByPincode url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getCityStateByPincode Response = $data");

    return data;
  }

  static Future saveContactInfo({
    required int user_id,
    required String client_name,
    required String pincode,
    required String city,
    required String state,
    required String state_code,
    required String address1,
    required String address2,
    required String address3,
    required String country,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/saveContactInfo?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&pincode=$pincode"
        "&city=$city&state=$state&state_code=$state_code&address1=$address1"
        "&address2=$address2&address3=$address3&country=$country&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("saveContactInfo url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("saveContactInfo Response = $data");

    return data;
  }

  static Future saveNomineeInfo(
      {required int user_id,
      required String client_name,
      required String bse_nse_mfu_flag,
      required int number_of_nominee,
      required int no_nominee_flag,
      required List nominee_details}) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/saveNomineeInfo?key=${ApiConfig.apiKey}&user_id=$user_id"
        "&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag&number_of_nominee=$number_of_nominee"
        "&nominee_details=$nominee_details&no_nominee_flag=$no_nominee_flag";

    print("saveNomineeInfo url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("saveNomineeInfo Response = $data");

    return data;
  }

  static Future getBankList({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getBankList?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&"
        "client_name=$client_name&"
        "bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getBankList url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getBankList Response = $data");

    return data;
  }

  static Future saveBankInfo({
    required int user_id,
    required String client_name,
    required String ifsc_code,
    required String micr_code,
    required String bank_name,
    required String bank_code,
    required String bank_mode,
    required String branch_name,
    required String bank_address,
    required String account_number,
    required String account_holder_name,
    required String account_type,
    required String bank_proof,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/saveBankInfo?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&"
        "ifsc_code=$ifsc_code&micr_code=$micr_code&"
        "bank_name=$bank_name&bank_code=$bank_code&"
        "bank_mode=$bank_mode&branch_name=$branch_name&"
        "bank_address=$bank_address&account_number=$account_number&"
        "account_holder_name=$account_holder_name&account_type=$account_type&"
        "bank_proof=$bank_proof&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("saveBankInfo url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("saveBankInfo Response = $data");

    return data;
  }

  static Future getBankAccountType({
    required String client_name,
    required String bse_nse_mfu_flag,
    required String tax_status,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getBankAccountType?key=${ApiConfig.apiKey}&"
        "client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag&tax_status=$tax_status";

    print("getBankAccountType url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getBankAccountType Response = $data");

    return data;
  }

  static Future getInvestorInfo({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getInvestorInfo?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getInvestorInfo url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getInvestorInfo Response = $data");

    return data;
  }

  static Future getBankInfo({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getBankInfo?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getBankInfo url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getBankInfo Response = $data");

    return data;
  }

  static Future getPersonalInfo({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getPersonalInfo?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    log("getPersonalInfo url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getPersonalInfo Response = $data");

    return data;
  }

  static Future getNriInfo({
    required int user_id,
    required String client_name,
  }) async {
    final String url =
        "${ApiConfig.apiUrl}/onboard/getNriInfo?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name";

    print("getNriInfo url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getNriInfo Response = $data");

    return data;
  }

  static Future getContactInfo({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    final String url =
        "${ApiConfig.apiUrl}/onboard/getContactInfo?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getContactInfo url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getContactInfo Response = $data");

    return data;
  }

  static Future onlineRegistration({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/v1/onlineRegistration?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("onlineRegistration url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("onlineRegistration Response = $data");

    return data;
  }

  static Future getUserRegStatus({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getUserRegStatus?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name";

    print("getUserRegStatus url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getUserRegStatus Response = $data");

    return data;
  }

  static Future getNomineeInfo({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getNomineeInfo?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&"
        "bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getNomineeInfo url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getNomineeInfo Response = $data");

    return data;
  }

  static Future getRelationship({
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "https://api.mymfbox.com/onboard/getRelationship?key=${ApiConfig.apiKey}&"
        "client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getRelationship url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getRelationship Response = $data");

    return data;
  }

  static Future uploadSignature({
    required String client_name,
    required int user_id,
    required String user_type,
    required String file_path,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/uploadSignature?key=${ApiConfig.apiKey}&"
        "client_name=$client_name&user_id=$user_id&user_type=$user_type";

    print("uploadSignature url = $url filePath = $file_path");

    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('file', file_path,
        contentType: MediaType('image', 'png')));

    http.StreamedResponse response = await request.send();

    String resString = await response.stream.bytesToString();

    Map data = jsonDecode(resString);
    print("uploadSignature response = $data");

    return data;
  }

  static Future saveSignatureImage({
    required int user_id,
    required String client_name,
    required String user_type,
    required String file_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/saveSignatureImage?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&user_type=$user_type&file_name=$file_name&client_name=$client_name";

    print("saveSignatureImage url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("saveSignatureImage Response = $data");

    return data;
  }

  static Future uploadCancelledCheque({
    required String client_name,
    required int user_id,
    required String file_path,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/uploadCancelledCheque?key=${ApiConfig.apiKey}&"
        "client_name=$client_name&user_id=$user_id";

    print("uploadCancelledCheque url = $url filePath = $file_path");

    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('file', file_path,
        contentType: MediaType('image', 'png')));

    http.StreamedResponse response = await request.send();

    String resString = await response.stream.bytesToString();

    Map data = jsonDecode(resString);
    print("uploadCancelledCheque response = $data");

    return data;
  }

  static Future saveChequeImage({
    required int user_id,
    required String client_name,
    required String file_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/saveChequeImage?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&file_name=$file_name&client_name=$client_name";

    print("saveSignatureImage url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("saveSignatureImage Response = $data");

    return data;
  }

  static Future getSignature({
    required String client_name,
    required int user_id,
    required String user_type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getSignature?key=${ApiConfig.apiKey}&"
        "client_name=$client_name&user_id=$user_id&user_type=$user_type";

    print("getSignature url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSignature Response = $data");

    return data;
  }

  static Future getNomineeAuthenticationLink({
    required int user_id,
    required String client_name,
    required String investor_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/v1/getNomineeAuthenticationLink?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&investor_code=$investor_code";

    print("getNomineeAuthenticationLink url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getNomineeAuthenticationLink Response = $data");

    return data;
  }

  static Future uploadBseAOF({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/uploadBseAOF?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&multiple_reg=0&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("uploadBseAOF url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("uploadBseAOF Response = $data");

    return data;
  }

  static Future<GuardianRelationResponse> getGuardianRelationship({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getGuardianRelationship?key=${ApiConfig.apiKey}&user_id=$user_id"
        "&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";
    print("getGuardianRelationship url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    final res = GuardianRelationResponse.fromJson(jsonDecode(response.body));
    print("getGuardianRelationship Response = $data");
    return res;
  }

  static Future getRelation({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getGuardianRelationship?key=${ApiConfig.apiKey}&user_id=$user_id"
        "&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";
    print("getGuardianRelationship url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getGuardianRelationship Response = $data");
    return data;
  }

  static Future getNomineeGuardRelationship({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getNomineeGuardRelationship?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";
    print("getGuardianRelationship url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getGuardianRelationship Response = $data");
    return data;
  }

  static Future getAccountRelationship({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getAccountRelationship?key=${ApiConfig.apiKey}&user_id=$user_id"
        "&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";
    print("getAccountRelationship url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAccountRelationship Response = $data");
    return data;
  }

  static Future getNriNreCountryList({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getNriNreCountryList?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";
    print("getNriNreCountryList url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getNriNreCountryList Response = $data");
    return data;
  }

  static Future<RelationshipProofResponse> getRelationshipProof({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/getRelationshipProof?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&bse_nse_mfu_flag=$bse_nse_mfu_flag";
    print("getRelationshipProof url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    final res = RelationshipProofResponse.fromJson(jsonDecode(response.body));
    print("getRelationshipProof response = $data");
    return res;
  }
}
