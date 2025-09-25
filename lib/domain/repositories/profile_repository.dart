import 'package:zavona_flutter_app/core/domain/base_repository.dart';
import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/data/services/zavona_parking_app_service.dart';
import 'package:zavona_flutter_app/data/services/zavona_parking_app_service_models.dart';
import 'package:zavona_flutter_app/domain/models/auth/my_profile_response.dart';
import 'package:zavona_flutter_app/domain/models/common_api_response.dart';
import 'package:zavona_flutter_app/domain/models/files/generate_upload_url_response.dart';

class ProfileRepository extends BaseRepository {
  ZavonaParkingAppService apiService = locator<ZavonaParkingAppService>();

  Future<CommonApiResponse> updateProfile({
    required User user,
    required String name,
    required String email,
    required String mobile,
    required String role,
    required String profileImage,
    String? kycStatus,
    List<String>? kycDocs,
    String? kycRemarks,
  }) async {
    try {
      var res = await apiService.updateProfile(
        userid: user.id ?? "",
        requestParams: UpdateprofileRequestParams(
          name: name,
          email: email,
          mobile: mobile,
          userrole: role,
          profileimage: profileImage,
          emailverified: user.emailVerified ?? false,
          mobileverified: user.mobileVerified ?? false,
          isactive: user.isActive ?? true,
          isblocked: user.isBlocked ?? false,
          kycStatus: kycStatus,
          kycDocs: kycDocs,
          kycRemarks: kycRemarks,
        ),
      );
      return super.handleApiResponse(res, CommonApiResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }
}
