import 'dart:convert';

import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class EkycApi {
  static Future getOnBoardingStatus(
      {required int user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/getOnBoardingStatus?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";

    print("getOnBoardingStatus url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getOnBoardingStatus response = $data");
    return data;
  }

  static Future savePersonalIdentity({
    required int user_id,
    required String client_name,
    required String name,
    required String pan,
    required String ekyc_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/savePersonalIdentity?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&name=$name&pan=$pan&ekyc_id=$ekyc_id";

    print("savePersonalIdentity url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("savePersonalIdentity response = $data");
    return data;
  }

  static Future getDigiLockerPanUrl({
    required int user_id,
    required String client_name,
    required String ekyc_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/getDigiLockerPanUrl?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&user_id=$user_id&ekyc_id=$ekyc_id";

    print("getDigiLockerPanUrl url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getDigiLockerPanUrl response = $data");
    return data;
  }

  static Future getDigiLockerPanDetails(
      {required int user_id,
      required String client_name,
      required String ekyc_id}) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/getDigiLockerPanDetails?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&user_id=$user_id&ekyc_id=$ekyc_id";

    print("getDigiLockerPanDetails url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getDigiLockerPanDetails response = $data");
    return data;
  }

  static Future updatePan({
    required int user_id,
    required String client_name,
    required String pan,
    required String name,
    required String ekyc_id,
    required String father_name,
    required String dob,
  }) async {
    String url = "${ApiConfig.apiUrl}/ekyc/updatePan?key=${ApiConfig.apiKey}"
        "&client_name=$client_name"
        "&user_id=$user_id&pan=$pan&name=$name&ekyc_id=$ekyc_id&father_name=$father_name&dob=$dob";

    print("updatePan url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("updatePan response = $data");
    return data;
  }

  static Future getDigiLockerAadhaarUrl({
    required int user_id,
    required String client_name,
    required String ekyc_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/getDigiLockerAadhaarUrl?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&user_id=$user_id&ekyc_id=$ekyc_id";

    print("getDigiLockerAadhaarUrl url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getDigiLockerAadhaarUrl response = $data");
    return data;
  }

  static Future getDigiLockerAadhaarDetails({
    required int user_id,
    required String client_name,
    required String ekyc_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/getDigiLockerAadhaarDetails?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&ekyc_id=$ekyc_id";

    print("getDigiLockerAadhaarDetails url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getDigiLockerAadhaarDetails response = $data");
    return data;
  }

  static Future updateAadhaar({
    required int user_id,
    required String client_name,
    required String district,
    required String name,
    required String ekyc_id,
    required String father_name,
    required String dob,
    required String city,
    required String pincode,
    required String state,
    required String address,
    required String aadhaar,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/updateAadhaar?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&user_id=$user_id&district=$district"
        "&name=$name&ekyc_id=$ekyc_id&father_name=$father_name&dob=$dob"
        "&city=$city&pincode=$pincode&state=$state&address=$address&aadhaar=$aadhaar";

    print("updateAadhaar url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("updateAadhaar response = $data");
    return data;
  }

  static Future updateSameAddress({
    required int user_id,
    required String client_name,
    required String ekyc_id,
  })async{
    String url = "${ApiConfig.apiUrl}/ekyc/updateSameAddress?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&ekyc_id=$ekyc_id";

    print("updateSameAddress url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("updateSameAddress response = $data");
    return data;
  }

  static Future updatePersonalInfo({
    required int user_id,
    required String client_name,
    required String gender,
    required String marital,
    required String fatherSaln,
    required String fatherName,
    required String relation,
    required String pan,
    required String motherSaln,
    required String motherName,
    required String resStatus,
    required String occupationCode,
    required String occupation,
    required String mobile,
    required String aadhar,
    required String email,
    required String commAddressCode,
    required String commAddress,
    required String permAddressCode,
    required String permAddress,
    required String ekyc_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/updatePersonalInfo?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&user_id=$user_id&gender=$gender"
        "&marital=$marital&fatherSaln=$fatherSaln&fatherName=$fatherName&relation=$relation"
        "&pan=$pan&motherSaln=$motherSaln&motherName=$motherName&resStatus=$resStatus"
        "&occupationCode=$occupationCode&occupation=$occupation&mobile=$mobile&email=$email"
        "&commAddressCode=$commAddressCode&commAddress=$commAddress&permAddressCode=$permAddressCode"
        "&permAddress=$permAddress&ekyc_id=$ekyc_id&aadhar=$aadhar";

    print("updatePersonalInfo url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("updatePersonalInfo response = $data");
    return data;
  }

  static Future updateDeclarationWithProof({
    required int user_id,
    required String client_name,
    required String ekyc_id,
    required String pepPerson,
    required String rpepPerson,
    required String resOutside,
    required String relPerson,
   // required String countryCodeJurisdictionResidence,
  //  required String countryJurisdictionResidence,
  //  required String taxIdentificationNumber,
    required String placeOfBirth,
    required String countryCodeOfBirth,
    required String countryOfBirth,
    required String addressCity,
    required String addressDistrict,
    required String addressStateCode,
    required String addressState,
    required String addressCountryCode,
    required String addressCountry,
    required String addressPincode,
    required String address,
    required String addressType,
    required String relatedPersonType,
    required String relatedPersonName,
    required String relatedPersonKycNumberExists,
    required String relatedPersonKycNumber,
    required String relatedPersonTitle,
    required String relatedPersonIdentityProofType,
    required String proofType,
    required String proofName,
    required String proofDob,
    required String proofNumber,
    required String fatherName,
    required String proofDistrict,
    required String proofCity,
    required String proofPincode,
    required String proofState,
    required String proofAddress,
    required String issueDate,
    required String expiryDate,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/updateDeclarationWithProof?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&user_id=$user_id&ekyc_id=$ekyc_id"
        "&pepPerson=$pepPerson&rpepPerson=$rpepPerson&resOutside=$resOutside"
        "&relPerson=$relPerson&placeOfBirth=$placeOfBirth&countryCodeOfBirth=$countryCodeOfBirth&countryOfBirth=$countryOfBirth"
        "&addressCity=$addressCity&addressDistrict=$addressDistrict&addressStateCode=$addressStateCode"
        "&addressState=$addressState&addressCountryCode=$addressCountryCode&addressCountry=$addressCountry"
        "&addressPincode=$addressPincode&address=$address&addressType=$addressType&relatedPersonType=$relatedPersonType"
        "&relatedPersonName=$relatedPersonName&relatedPersonKycNumberExists=$relatedPersonKycNumberExists"
        "&relatedPersonKycNumber=$relatedPersonKycNumber&relatedPersonTitle=$relatedPersonTitle"
        "&relatedPersonIdentityProofType=$relatedPersonIdentityProofType&proofType=$proofType"
        "&proofName=$proofName&proofDob=$proofDob&proofNumber=$proofNumber&fatherName=$fatherName"
        "&proofDistrict=$proofDistrict&proofCity=$proofCity&proofPincode=$proofPincode&proofState=$proofState"
        "&proofAddress=$proofAddress&issueDate=$issueDate&expiryDate=$expiryDate";

    print("updateDeclarationWithProof url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("updateDeclarationWithProof response = $data");
    return data;
  }

  static Future getCountryList({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/getCountryList?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name";

    print("getCountryList url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getCountryList response = $data");
    return data;
  }

  static Future getStateList({
    required int user_id,
    required String client_name,
  }) async {
    String url = "${ApiConfig.apiUrl}/ekyc/getStateList?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name";

    print("getStateList url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getStateList response = $data");
    return data;
  }

  static Future uploadFileImage({
    required String client_name,
    required int user_id,
    required String image_type,
    required String file_path,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/uploadFileImage?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&image_type=$image_type";

    print("uploadFileImage url = $url filePath = $file_path");

    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('file', file_path,
        contentType: MediaType('image', 'png')));

    http.StreamedResponse response = await request.send();

    String resString = await response.stream.bytesToString();

    Map data = jsonDecode(resString);
    print("uploadFileImage response = $data");

    return data;
  }

  static Future uploadSignatureImage({
    required int user_id,
    required String client_name,
    required String ekyc_id,
    required String image_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/uploadSignatureImage?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&ekyc_id=$ekyc_id&image_name=$image_name";

    print("uploadSignatureImage url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("uploadSignatureImage response = $data");
    return data;
  }

  static Future uploadPhotoImage({
    required int user_id,
    required String client_name,
    required String ekyc_id,
    required String image_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/uploadPhotoImage?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&ekyc_id=$ekyc_id&image_name=$image_name";

    print("uploadPhotoImage url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("uploadPhotoImage response = $data");
    return data;
  }

  static Future getContractPreview({
    required int user_id,
    required String client_name,
    required String ekyc_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/getContractPreview?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&ekyc_id=$ekyc_id";

    print("getContractPreview url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getContractPreview response = $data");
    return data;
  }

  static Future step10Declaration({
    required int user_id,
    required String client_name,
    required String ekyc_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/ekyc/step10-declaration?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&ekyc_id=$ekyc_id";

    print("step10Declaration url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("step10Declaration response = $data");
    return data;
  }
}
