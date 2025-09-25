import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/presentation/utils/size_utils.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';
import 'package:zavona_flutter_app/presentation/file_upload/bloc/file_uploader_state.dart';
import 'package:zavona_flutter_app/presentation/file_upload/widget/file_uploader_widget.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_form/parking_docs_section.dart';
import 'package:zavona_flutter_app/res/values/network_constants.dart';

class ImagePickerButton extends StatelessWidget {
  const ImagePickerButton({
    super.key,

    required this.uploadPurpose,
    required this.imageFileKey,
    required this.onFileUploaded,
  });

  final String uploadPurpose;
  final String imageFileKey;
  final void Function(String fileKey) onFileUploaded;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: context.screenHeight * 0.15,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xfffffff8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.primaryColor, width: 1),
          ),
          child: FileUploaderWidget.builder(
            onFilesChanged: (files) async {
              if (files.isNotEmpty &&
                  files.first.status == UploadFileStatus.uploaded &&
                  (files.first.uploadedFileKey?.isNotEmpty ?? false)) {
                log(
                  "New $uploadPurpose uploaded: ${files.first.uploadedFileKey}",
                );
                onFileUploaded(files.first.uploadedFileKey!);
              }
            },
            uploadPurpose: uploadPurpose,
            child: imageFileKey.isNotEmpty
                ? (uploadPurpose != "verificationDocument"
                      ? CachedNetworkImage(
                          imageUrl:
                              "${NetworkConstants.bucketBaseUrl}/$imageFileKey",
                          errorWidget: (context, url, error) => Center(
                            child: Icon(
                              Icons.broken_image,
                              color: context.onSurfaceColor,
                            ),
                          ),
                          progressIndicatorBuilder:
                              (_, child, loadingProgress) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: context.onPrimaryColor,
                                  ),
                                );
                              },
                        )
                      : ViewImageWidget(imageKey: imageFileKey))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.primaryColor,
                        ),
                        child: CustomIcons.cameraIcon(20, 20),
                      ),
                      Text(
                        "Upload",
                        style: GoogleFonts.workSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: context.onSurfaceColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (imageFileKey.isNotEmpty)
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                ViewImageWidget.showAsBottomSheet(
                  context,
                  imageKey: imageFileKey,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.25),
                  border: Border.all(color: context.primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.all(6),
                child: FaIcon(
                  FontAwesomeIcons.upRightAndDownLeftFromCenter,
                  color: context.primaryColor,
                  size: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
