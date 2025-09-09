import 'package:zavona_flutter_app/core/domain/base_repository.dart';
import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/data/services/zavona_parking_app_service.dart';
import 'package:zavona_flutter_app/data/services/zavona_parking_app_service_models.dart';
import 'package:zavona_flutter_app/domain/models/auth/my_profile_response.dart';
import 'package:zavona_flutter_app/domain/models/auth/request_auth_otp_response.dart';
import 'package:zavona_flutter_app/domain/models/auth/social_login_response.dart';
import 'package:zavona_flutter_app/domain/models/auth/verify_otp_response.dart';
import 'package:zavona_flutter_app/domain/models/common_api_response.dart';

class AuthRepository extends BaseRepository {
  ZavonaParkingAppService apiService = locator<ZavonaParkingAppService>();

  Future<RequestAuthOtpResponse> requestOtp({
    required String identifier,
    required String identifierType,
    required String purpose,
  }) async {
    try {
      var res = await apiService.requestLoginregisterOtp(
        requestParams: RequestloginregisterotpRequestParams(
          identifier: identifier,
          identifiertype: identifierType,
          purpose: purpose,
        ),
      );
      return super.handleApiResponse(res, RequestAuthOtpResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }

  Future<VerifyOtpResponse> verifyOtp({
    required String identifier,
    required String otpcode,
    required String purpose,
  }) async {
    try {
      var res = await apiService.verifyOtp(
        requestParams: VerifyotpRequestParams(
          identifier: identifier,
          otpcode: otpcode,
          purpose: purpose,
        ),
      );
      return super.handleApiResponse(res, VerifyOtpResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }

  Future<CommonApiResponse> signOut({required String sessionId}) async {
    try {
      var res = await apiService.logout(
        requestParams: LogoutRequestParams(sessionid: sessionId),
      );
      return super.handleApiResponse(res, CommonApiResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }

  Future<SocialLoginResponse> socialLogin({
    required String provider,
    required String accessToken,
    required String idToken,
    required String socialDataEmail,
    required String socialDataName,
    required String socialDataPicture,
  }) async {
    try {
      var res = await apiService.socialLogin(
        requestParams: SocialloginRequestParams(
          provider: provider,
          socialtoken: accessToken,
          socialdataId: idToken,
          socialdataEmail: socialDataEmail,
          socialdataName: socialDataName,
          socialdataPicture: socialDataPicture,
        ),
      );
      return super.handleApiResponse(res, SocialLoginResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }

  Future<MyProfileResponse> getMyProfile() async {
    try {
      var res = await apiService.myProfile();
      return super.handleApiResponse(res, MyProfileResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }

  Future<MyProfileResponse> updateProfile({
    required String userId,
    required String name,
    required String email,
    required String mobile,
    required String profilePic,
    required String userRole,
    required bool emailVerified,
    required bool mobileVerified,
  }) async {
    try {
      var res = await apiService.updateProfile(
        userid: userId,
        requestParams: UpdateprofileRequestParams(
          name: name,
          email: email,
          mobile: mobile,
          profileimage: profilePic,
          userrole: userRole,
          emailverified: emailVerified,
          mobileverified: mobileVerified,
          isactive: true,
          isblocked: true,
        ),
      );
      return super.handleApiResponse(res, MyProfileResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }
}
