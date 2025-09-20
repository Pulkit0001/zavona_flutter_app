import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zavona_flutter_app/presentation/common/widgets/custom_icons.dart';

class ImageSourceSelector extends StatelessWidget {
  const ImageSourceSelector._();

  factory ImageSourceSelector.builder(BuildContext context) {
    return const ImageSourceSelector._();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Wrap(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // SLit
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 3,
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Select Image Source",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.workSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  "Choose your preferred way to pick an image.",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.workSans(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(ImageSource.camera);
                      },
                      child: Column(
                        children: [
                          CustomIcons.cameraSelectorIcon(),
                          SizedBox(height: 4),
                          Text(
                            "Camera",
                            style: GoogleFonts.mulish(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(ImageSource.gallery);
                      },
                      child: Column(
                        children: [
                          CustomIcons.gallerySelectorIcon(),
                          SizedBox(height: 4),
                          Text(
                            "Gallery",
                            style: GoogleFonts.mulish(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
