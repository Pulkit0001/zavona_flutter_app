import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zavona_flutter_app/res/values/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.titleWidget,
    this.leadingIcon = FontAwesomeIcons.arrowLeftLong,
    this.centerTitle = true,
    this.showBackArrowIcon = true,
    this.onLeadingTap,
    this.bottomWidget,
  });

  final Widget? leading;
  final bool showBackArrowIcon;
  final String? title;
  final Widget? titleWidget;
  final bool centerTitle;
  final IconData leadingIcon;
  final VoidCallback? onLeadingTap;
  final PreferredSizeWidget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(35),
        bottomRight: Radius.circular(35),
        topLeft: Radius.circular(0),
        topRight: Radius.circular(0),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0, -5),
                  blurRadius: 20,
                ),
              ],
              color: Color.fromRGBO(255, 215, 0, 1),
            ),
          ),
          Positioned(
            left: -64,
            top: -56,
            child: Image.asset(
              'assets/vectors/yellow_top_left_app_bar_vactor.png',
              width: 326,
            ),
          ),
          SafeArea(
            child: Align(
              alignment: centerTitle ? Alignment.center : Alignment.centerLeft,
              child:
                  titleWidget ??
                  ((title ?? "").isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  title!,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.mulish(
                                    color: Color.fromRGBO(17, 24, 39, 1),
                                    fontSize: 25,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                            if (bottomWidget != null) ...[bottomWidget!],
                          ],
                        )
                      : Offstage()),
            ),
          ),
          showBackArrowIcon
              ? Positioned(
                  left: 0,
                  top: 6,
                  child: SafeArea(
                    child: InkWell(
                      onTap: onLeadingTap ?? () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: FaIcon(leadingIcon, color: AppColors.black),
                      ),
                    ),
                  ),
                )
              : Offstage(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size(double.infinity, 72 + (bottomWidget?.preferredSize.height ?? 0));
}
