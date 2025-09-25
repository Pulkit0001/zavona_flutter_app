import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/core/locator.dart';
import 'package:zavona_flutter_app/core/presentation/blocs/e_states.dart';
import 'package:zavona_flutter_app/core/presentation/utils/size_utils.dart';
import 'package:zavona_flutter_app/core/presentation/utils/theme_utils.dart';
import 'package:zavona_flutter_app/domain/repositories/file_repository.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/image_upload_button.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_cubit.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_state.dart';

class ParkingDocsSection extends StatelessWidget {
  const ParkingDocsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingFormCubit, ParkingFormState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Parking Thumbnail",
            style: GoogleFonts.workSans(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.3,
              color: context.onSurfaceColor,
            ),
          ),
          Text(
            "Upload a clear image of your parking space.",
            style: GoogleFonts.workSans(
              fontSize: 13,
              height: 1.3,
              fontWeight: FontWeight.w400,
              color: context.onSurfaceColor,
            ),
          ),
          SizedBox(height: 12),
          ImagePickerButton(
            onFileUploaded: (String fileKey) {
              context.read<ParkingFormCubit>().updateThumbnailImageKey(fileKey);
            },
            uploadPurpose: "parkingThumbnail",
            imageFileKey: state.parkingThumbnailKey ?? "",
          ),
          SizedBox(height: 24),
          Text(
            "Address Proof",
            style: GoogleFonts.workSans(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.3,
              color: context.onSurfaceColor,
            ),
          ),
          Text(
            "Upload a clear image of your address proof.",
            style: GoogleFonts.workSans(
              fontSize: 13,
              height: 1.3,
              fontWeight: FontWeight.w400,
              color: context.onSurfaceColor,
            ),
          ),
          SizedBox(height: 12),
          ImagePickerButton(
            onFileUploaded: (fileKey) {
              context.read<ParkingFormCubit>().addParkingDocKey(fileKey);
            },
            imageFileKey: state.parkingDocKeys.firstOrNull ?? "",
            uploadPurpose: "verificationDocument",
          ),
        ],
      ),
    );
  }
}

class ViewImageWidget extends StatelessWidget {
  const ViewImageWidget({super.key, required this.imageKey});

  final String imageKey;

  static FutureOr<dynamic> showAsBottomSheet(
    BuildContext context, {
    required String imageKey,
  }) => showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    clipBehavior: Clip.hardEdge,
    context: context,
    builder: (context) => Wrap(
      children: [
        Container(
          color: Colors.black,
          height: context.screenHeight * 0.75,
          width: double.infinity,
          child: Stack(
            children: [
              Center(child: ViewImageWidget(imageKey: imageKey)),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16, top: 16),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.xmark,
                      color: context.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReadFileCubit>(
      create: (_) => ReadFileCubit()..readFile(imageKey),
      child: BlocBuilder<ReadFileCubit, ReadFileState>(
        builder: (context, state) => (state.imageUrl?.isNotEmpty ?? false)
            ? CachedNetworkImage(
                imageUrl: state.imageUrl!,
                progressIndicatorBuilder: (_, child, loadingProgress) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: context.primaryColor,
                    ),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(color: context.primaryColor),
              ),
      ),
    );
  }
}

class ReadFileCubit extends Cubit<ReadFileState> {
  FileRepository fileRepository = locator<FileRepository>();
  ReadFileCubit()
    : super(
        ReadFileState(
          eViewState: EViewState.initial,
          error: null,
          imageUrl: null,
        ),
      );

  Future<void> readFile(String fileKey) async {
    emit(
      ReadFileState(
        eViewState: EViewState.loading,
        error: null,
        imageUrl: null,
      ),
    );
    try {
      var res = await fileRepository.getFileUrl(fileKey: fileKey);
      emit(
        ReadFileState(
          eViewState: EViewState.loaded,
          error: null,
          imageUrl: res.url,
        ),
      );
    } catch (e) {
      emit(
        ReadFileState(
          eViewState: EViewState.error,
          error: e.toString(),
          imageUrl: null,
        ),
      );
    }
  }
}

class ReadFileState {
  final EViewState eViewState;
  final String? error;
  final String? imageUrl;

  ReadFileState({required this.eViewState, this.error, this.imageUrl});

  // copy with
  ReadFileState copyWith({
    EViewState? eViewState,
    String? error,
    String? imageUrl,
  }) {
    return ReadFileState(
      eViewState: eViewState ?? this.eViewState,
      error: error ?? this.error,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
