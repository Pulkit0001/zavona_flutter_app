import 'package:zavona_flutter_app/core/domain/base_repository.dart';
import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/data/services/zavona_parking_app_service.dart';
import 'package:zavona_flutter_app/data/services/zavona_parking_app_service_models.dart';
import 'package:zavona_flutter_app/domain/models/files/generate_upload_url_response.dart';
import 'package:zavona_flutter_app/domain/models/files/get_file_url_response.dart';

class FileRepository extends BaseRepository {
  ZavonaParkingAppService apiService = locator<ZavonaParkingAppService>();

  Future<GenerateUploadUrlResponse> generateUploadUrl({
    required String filename,
    required String filetype,
    required String contentType,
  }) async {
    try {
      var res = await apiService.generateUploadUrl(
        requestParams: GenerateuploadurlRequestParams(
          filetype: filetype,
          filename: filename,
          contenttype: contentType,
        ),
      );
      return super.handleApiResponse(res, GenerateUploadUrlResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }

  Future<GetFileUrlResponse> getFileUrl({
    required String fileKey,
  }) async {
    try {
      var res = await apiService.getFileUrl(filekey: fileKey);
      return super.handleApiResponse(res, GetFileUrlResponse.fromJson);
    } catch (e, str) {
      throw super.handleException(e, str);
    }
  }
}
