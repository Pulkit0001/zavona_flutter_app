import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/domain/repositories/file_repository.dart';
import 'package:zavona_flutter_app/presentation/file_upload/bloc/file_uploader_state.dart';

class FileUploaderCubit extends Cubit<FileUploaderState> {
  final FileRepository _fileRepository = locator<FileRepository>();
  final Dio _dio = Dio();

  final String uploadPurpose;

  FileUploaderCubit({
    required double maxFileSize,
    required int maxFileCount,
    double minFileSize = 0,
    int minFileCount = 0,
    required this.uploadPurpose,
  }) : super(
         FileUploaderState.initial(
           maxFileSize: maxFileSize,
           maxFileCount: maxFileCount,
           minFileSize: minFileSize,
           minFileCount: minFileCount,
         ),
       );

  /// Add files to be uploaded
  void addFiles(List<UploadFileModel> newFiles) {
    if (state.maxFileCount == 1 && newFiles.isNotEmpty) {
      clearFiles();
      emit(state.copyWith(files: [newFiles.first]));
    }
    final currentFiles = List<UploadFileModel>.from(state.files);

    // Check if adding new files exceeds max count
    if (currentFiles.length + newFiles.length > state.maxFileCount) {
      final availableSlots = state.maxFileCount - currentFiles.length;
      if (availableSlots <= 0) return;

      newFiles = newFiles.take(availableSlots).toList();
    }

    // Validate file sizes
    final validatedFiles = newFiles.map((file) {
      final fileSizeKB = file.fileContent.length / 1024;

      if (fileSizeKB > state.maxFileSize) {
        return file.copyWith(
          status: UploadFileStatus.invalidFile,
          errorMsg: 'File size exceeds maximum limit of ${state.maxFileSize}KB',
        );
      }

      if (fileSizeKB < state.minFileSize) {
        return file.copyWith(
          status: UploadFileStatus.invalidFile,
          errorMsg:
              'File size is below minimum limit of ${state.minFileSize}KB',
        );
      }

      return file.copyWith(status: UploadFileStatus.readyToUpload);
    }).toList();

    currentFiles.addAll(validatedFiles);
    emit(state.copyWith(files: currentFiles));
  }

  /// Remove a file from the upload list
  void removeFile(int index) {
    if (index < 0 || index >= state.files.length) return;

    final updatedFiles = List<UploadFileModel>.from(state.files)
      ..removeAt(index);
    emit(state.copyWith(files: updatedFiles));
  }

  /// Clear all files
  void clearFiles() {
    emit(state.copyWith(files: []));
  }

  /// Upload all files that are ready to upload
  Future<void> uploadAllFiles() async {
    final filesToUpload = state.files
        .asMap()
        .entries
        .where((entry) => entry.value.status == UploadFileStatus.readyToUpload)
        .toList();

    if (filesToUpload.isEmpty) return;

    // Start uploading all files independently
    for (final entry in filesToUpload) {
      final index = entry.key;
      final file = entry.value;
      _uploadSingleFile(index, file);
    }
  }

  /// Upload a specific file by index
  Future<void> uploadFile(int index) async {
    if (index < 0 || index >= state.files.length) return;

    final file = state.files[index];
    if (file.status != UploadFileStatus.readyToUpload) return;

    await _uploadSingleFile(index, file);
  }

  /// Internal method to handle single file upload
  Future<void> _uploadSingleFile(int index, UploadFileModel file) async {
    try {
      // Update status to uploading
      _updateFileStatus(
        index,
        file.copyWith(status: UploadFileStatus.uploading, uploadingProgress: 0),
      );

      // Step 1: Generate upload URL
      final contentType = _getContentType(file.fileName, file.fileType);
      final fileType = _getFileTypeString(file.fileType);

      final uploadUrlResponse = await _fileRepository.generateUploadUrl(
        filename: file.fileName,
        filetype: uploadPurpose,
        contentType: contentType,
      );

      if (uploadUrlResponse.uploadUrl == null ||
          uploadUrlResponse.key == null) {
        throw Exception('Failed to generate upload URL');
      }

      // Step 2: Upload file to S3
      await _uploadToS3(
        uploadUrl: uploadUrlResponse.uploadUrl!,
        fileContent: file.fileContent,
        contentType: contentType,
        onProgress: (progress) {
          _updateFileStatus(
            index,
            file.copyWith(
              status: UploadFileStatus.uploading,
              uploadingProgress: progress,
            ),
          );
        },
      );

      // Step 3: Update file with upload success
      _updateFileStatus(
        index,
        file.copyWith(
          status: UploadFileStatus.uploaded,
          uploadedFileKey: uploadUrlResponse.key,
          uploadingProgress: 100,
        ),
      );
    } catch (e) {
      // Update file with error status
      _updateFileStatus(
        index,
        file.copyWith(
          status: UploadFileStatus.fileUploadFailed,
          errorMsg: e.toString(),
          uploadingProgress: null,
        ),
      );
    }
  }

  /// Upload file content to S3 using signed URL
  Future<void> _uploadToS3({
    required String uploadUrl,
    required Uint8List fileContent,
    required String contentType,
    required Function(int) onProgress,
  }) async {
    try {
      await _dio.put(
        uploadUrl,
        data: fileContent,
        options: Options(
          headers: {'Content-Type': contentType},
          validateStatus: (status) => status != null && status < 400,
        ),
        onSendProgress: (sent, total) {
          if (total > 0) {
            final progress = ((sent / total) * 100).round();
            onProgress(progress);
          }
        },
      );
    } catch (e) {
      throw Exception('Failed to upload file to S3: $e');
    }
  }

  /// Update a specific file's status
  void _updateFileStatus(int index, UploadFileModel updatedFile) {
    if (index < 0 || index >= state.files.length) return;

    final updatedFiles = List<UploadFileModel>.from(state.files);
    updatedFiles[index] = updatedFile;
    emit(state.copyWith(files: updatedFiles));
  }

  /// Get content type based on file name and type
  String _getContentType(String fileName, FileType fileType) {
    final mimeType = lookupMimeType(fileName);
    if (mimeType != null) return mimeType;

    // Fallback based on FileType
    switch (fileType) {
      case FileType.image:
        return 'image/jpeg';
      case FileType.pdf:
        return 'application/pdf';
      case FileType.video:
        return 'video/mp4';
      case FileType.audio:
        return 'audio/mpeg';
      case FileType.text:
        return 'text/plain';
    }
  }

  /// Convert FileType enum to string
  String _getFileTypeString(FileType fileType) {
    return fileType.name;
  }

  /// Get overall upload state
  EFileUploaderState get overallState {
    if (state.files.isEmpty) return EFileUploaderState.noFiles;

    final uploadingFiles = state.files.where(
      (f) => f.status == UploadFileStatus.uploading,
    );
    if (uploadingFiles.isNotEmpty) return EFileUploaderState.uploading;

    final uploadedFiles = state.files.where(
      (f) => f.status == UploadFileStatus.uploaded,
    );
    if (uploadedFiles.length == state.files.length)
      return EFileUploaderState.allFilesUploaded;

    final errorFiles = state.files.where(
      (f) =>
          f.status == UploadFileStatus.fileUploadFailed ||
          f.status == UploadFileStatus.invalidFile,
    );
    if (errorFiles.isNotEmpty) return EFileUploaderState.error;

    return EFileUploaderState.idle;
  }

  /// Get list of successfully uploaded file keys
  List<String> get uploadedFileKeys {
    return state.files
        .where(
          (file) =>
              file.status == UploadFileStatus.uploaded &&
              file.uploadedFileKey != null,
        )
        .map((file) => file.uploadedFileKey!)
        .toList();
  }

  /// Check if all files are uploaded successfully
  bool get areAllFilesUploaded {
    if (state.files.isEmpty) return false;
    return state.files.every(
      (file) => file.status == UploadFileStatus.uploaded,
    );
  }

  /// Check if minimum file count requirement is met
  bool get isMinFileCountMet {
    final uploadedCount = state.files
        .where((f) => f.status == UploadFileStatus.uploaded)
        .length;
    return uploadedCount >= state.minFileCount;
  }

  /// Retry failed uploads
  Future<void> retryFailedUploads() async {
    final failedFiles = state.files
        .asMap()
        .entries
        .where(
          (entry) => entry.value.status == UploadFileStatus.fileUploadFailed,
        )
        .toList();

    for (final entry in failedFiles) {
      final index = entry.key;
      final file = entry.value;

      // Reset file status to ready for upload
      _updateFileStatus(
        index,
        file.copyWith(
          status: UploadFileStatus.readyToUpload,
          errorMsg: null,
          uploadingProgress: null,
        ),
      );

      // Start upload
      await _uploadSingleFile(index, file);
    }
  }
}
