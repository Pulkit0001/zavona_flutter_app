import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zavona_flutter_app/core/presentation/utils/message_utils.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/presentation/file_upload/bloc/file_uploader_cubit.dart';
import 'package:zavona_flutter_app/presentation/file_upload/bloc/file_uploader_state.dart';
import 'package:zavona_flutter_app/third_party_services/file_picker_service.dart';

/// TODO: Need to implement manual upload capability in future if required
class FileUploaderWidget extends StatelessWidget {
  const FileUploaderWidget._({
    super.key,
    required this.child,
    required this.allowMultiple,
    required this.maxFileSize,
    required this.maxFileCount,
    required this.minFileCount,
    required this.onFilesChanged,
    this.autoUpload = true,
  });

  final Widget child;
  final bool allowMultiple;
  final double maxFileSize;
  final int maxFileCount;
  final int minFileCount;
  final bool autoUpload;
  final void Function(List<UploadFileModel>) onFilesChanged;

  static Widget builder({
    Key? key,
    required String uploadPurpose,
    required Widget child,
    bool allowMultiple = false,
    double maxFileSize = 5 * 1024 * 1024, // 5 MB
    int maxFileCount = 1,
    int minFileCount = 1,
    void Function(List<UploadFileModel>)? onFilesChanged,
    bool autoUpload = true,
  }) {
    return BlocProvider<FileUploaderCubit>(
      create: (context) => FileUploaderCubit(
        maxFileSize: maxFileSize,
        uploadPurpose: uploadPurpose,
        maxFileCount: maxFileCount,
        minFileCount: minFileCount,
      ),
      child: FileUploaderWidget._(
        key: key,
        allowMultiple: allowMultiple,
        maxFileSize: maxFileSize,
        maxFileCount: maxFileCount,
        minFileCount: minFileCount,
        onFilesChanged: onFilesChanged ?? (files) {},
        autoUpload: autoUpload,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FileUploaderCubit, FileUploaderState>(
      listener: (context, state) {
        if (state.files.any(
          (file) => file.status == UploadFileStatus.fileUploadFailed,
        )) {
          MessageUtils.showErrorMessage(
            state.maxFileCount == 1
                ? "File upload failed. Please try again."
                : "Some files failed to upload.",
          );
        }
        if (state.files.any(
          (file) => file.status == UploadFileStatus.invalidFile,
        )) {
          MessageUtils.showErrorMessage(
            state.maxFileCount == 1
                ? "Please select a valid file."
                : "Some files are invalid.",
          );
        }
        if (state.files.any(
          (file) => file.status == UploadFileStatus.uploaded,
        )) {
          MessageUtils.showSuccessMessage(
            state.maxFileCount == 1
                ? "File uploaded successfully."
                : "Some files uploaded successfully.",
          );
        }
        onFilesChanged.call(state.files);
      },
      builder: (context, state) => state.maxFileCount == 1
          ? state.files.length == 1
                ? switch (state.files.single.status) {
                    UploadFileStatus.loadingOldFile ||
                    UploadFileStatus.uploading => SizedBox(
                      height: 24,
                      width: 24,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: context.onPrimaryColor,
                        ),
                      ),
                    ),
                    UploadFileStatus.loadingOldFileFailed ||
                    UploadFileStatus.invalidFile ||
                    UploadFileStatus.fileUploadFailed ||
                    UploadFileStatus.uploaded ||
                    UploadFileStatus.readyToUpload => InkWell(
                      onTap: () => _onPressed(context),
                      child: child,
                    ),
                  }
                : InkWell(onTap: () => _onPressed(context), child: child)
          : Text("Multiple file upload not supported yet"),
    );
  }

  FutureOr<void> _onPressed(BuildContext context) async {
    var uploaderCubit = context.read<FileUploaderCubit>();
    if (allowMultiple) {
      List<XFile>? files = await FilePickerService.pickMultipleImages(context);
      var fileList = <UploadFileModel>[];
      for (XFile file in files ?? []) {
        fileList.add(
          UploadFileModel(
            fileContent: await file.readAsBytes(),
            status: UploadFileStatus.readyToUpload,
            fileName: file.name,
            fileType: FileType.image,
          ),
        );
      }
      uploaderCubit.addFiles(fileList);
    } else {
      var file = await FilePickerService.pickSingleImage(context);
      if (file != null) {
        uploaderCubit.addFiles([
          UploadFileModel(
            fileContent: await file.readAsBytes(),
            status: UploadFileStatus.readyToUpload,
            fileName: file.name,
            fileType: FileType.image,
          ),
        ]);
      }
    }
    if (autoUpload) {
      uploaderCubit.uploadAllFiles();
    }
  }
}
