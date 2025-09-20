import 'dart:typed_data';

class FileUploaderState {
  ///files that are selected to upload
  final List<UploadFileModel> files;

  /// Max File Size in KB
  /// Till now we support only one max file size accepted by all the files to
  /// be uploaded
  final double maxFileSize;

  /// Min File Size in KB
  /// Till now we support only one max file size accepted by all the files to
  /// be uploaded
  final double minFileSize;

  /// Maximum File counts
  final int maxFileCount;

  /// Minimum File counts
  final int minFileCount;

  FileUploaderState({
    required this.files,
    required this.maxFileSize,
    required this.minFileSize,
    required this.maxFileCount,
    required this.minFileCount,
  });

  factory FileUploaderState.initial({
    required double maxFileSize,
    required int maxFileCount,
    double minFileSize = 0,
    int minFileCount = 0,
  }) => FileUploaderState(
    files: [],
    maxFileSize: maxFileSize,
    minFileSize: minFileSize,
    maxFileCount: maxFileCount,
    minFileCount: minFileCount,
  );

  FileUploaderState copyWith({
    List<UploadFileModel>? files,
    double? maxFileSize,
    double? minFileSize,
    int? maxFileCount,
    int? minFileCount,
  }) => FileUploaderState(
    files: files ?? this.files,
    maxFileSize: maxFileSize ?? this.maxFileSize,
    minFileSize: minFileSize ?? this.minFileSize,
    maxFileCount: maxFileCount ?? this.maxFileCount,
    minFileCount: minFileCount ?? this.minFileCount,
  );
}

enum EFileUploaderState {
  noFiles,
  selectingFiles,
  idle,
  uploading,
  allFilesUploaded,
  error,
}

enum FileType { image, pdf, video, audio, text }

class UploadFileModel {
  final Uint8List fileContent;
  final UploadFileStatus status;
  final String? uploadedFileKey;
  final int? uploadingProgress;
  final String? errorMsg;
  final String fileName;
  final FileType fileType;
  final dynamic metadata;

  UploadFileModel({
    required this.fileContent,
    required this.status,
    this.uploadingProgress,
    this.errorMsg,
    required this.fileName,
    required this.fileType,
    this.uploadedFileKey,
    this.metadata,
  });

  UploadFileModel copyWith({
    Uint8List? fileContent,
    UploadFileStatus? status,
    String? uploadedFileKey,
    int? uploadingProgress,
    String? errorMsg,
    String? fileName,
    FileType? fileType,
    dynamic metadata,
  }) => UploadFileModel(
    fileContent: fileContent ?? this.fileContent,
    status: status ?? this.status,
    fileName: fileName ?? this.fileName,
    fileType: fileType ?? this.fileType,
    uploadedFileKey: uploadedFileKey ?? this.uploadedFileKey,
    uploadingProgress: uploadingProgress ?? this.uploadingProgress,
    errorMsg: errorMsg ?? this.errorMsg,
    metadata: metadata ?? this.metadata,
  );
}

enum UploadFileStatus {
  readyToUpload("Ready to Upload"),
  loadingOldFile("Loading Old Doc..."),
  loadingOldFileFailed("Error while loading old doc"),
  invalidFile("Invalid File"),
  uploading("Uploading..."),
  fileUploadFailed("Error while uploading"),
  uploaded("Uploaded");

  const UploadFileStatus(this.label);

  final String label;
}
