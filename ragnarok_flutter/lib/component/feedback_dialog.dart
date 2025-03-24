import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ragnarok_flutter/theme/ragnarok_colors.dart';
import 'package:ragnarok_flutter/theme/ragnarok_text_style.dart';
import 'package:ragnarok_flutter/utils/asset_paths.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';
import 'package:ragnarok_flutter/utils/app_enum.dart';
import 'package:ragnarok_flutter/utils/extensions/string_ext.dart';
import 'package:ragnarok_flutter/widget/svg_util.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({
    super.key,
    this.feedbackTitle,
    this.feedbackTitleSecond,
    this.feedbackDescription,
    this.starsDisable,
    this.hintText,
    this.borderTextFiledColor,
    this.hintColor,
    this.backgroundRightButtonColor,
    this.backgroundLeftButtonColor,
    this.textButtonColor,
    this.onFeedbackSuccess,
    this.onFeedbackFailed,
    this.padding,
    this.onChangeAskAgain,
    this.insetBorderRadius,
    this.urlRateAndroid,
    this.urlRateIOS,
    this.imgFeedback,
    this.askAgainContent,
    this.starsEnable,
    this.sendFeedback,
    this.rateUs,
    this.close,
    this.rateError,
  });

  final String? hintText;
  final Color? borderTextFiledColor;
  final Color? hintColor;
  final Color? backgroundRightButtonColor;
  final Color? backgroundLeftButtonColor;
  final Color? textButtonColor;
  final Widget? feedbackTitle;
  final Widget? feedbackTitleSecond;
  final Widget? feedbackDescription;
  final Widget? starsDisable;
  final Widget? starsEnable;
  final Function()? onFeedbackSuccess;
  final Function()? onFeedbackFailed;
  final Function(bool)? onChangeAskAgain;
  final double? padding;
  final String? urlRateAndroid;
  final String? urlRateIOS;
  final double? insetBorderRadius;
  final Widget? imgFeedback;
  final Widget? askAgainContent;
  final String? sendFeedback;
  final String? rateUs;
  final String? close;
  final String? rateError;

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _textEditingController = TextEditingController();
  int currentRating = 0;
  LoadingStatus loadingStatus = LoadingStatus.initial;
  bool hasAskAgain = false;
  bool hasRated = false;

  Future<void> sendFeedback() async {
    try {
      unawaited(EasyLoading.show());
      final CollectionReference feedback =
          FirebaseFirestore.instance.collection('feedback');
      await feedback.add({
        'content': _textEditingController.text,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'rate': currentRating,
      }).timeout(const Duration(seconds: 10));
      unawaited(EasyLoading.dismiss());
      widget.onFeedbackSuccess?.call();
    } catch (e) {
      unawaited(EasyLoading.dismiss());
      widget.onFeedbackFailed?.call();
      setState(() {
        loadingStatus = LoadingStatus.failure;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 80.h),
      children: [
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(widget.insetBorderRadius ?? 8.r),
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          insetPadding:
              EdgeInsets.symmetric(horizontal: useMobileLayout ? 16.w : 128.w),
          child: GestureDetector(
            onTap: () {
              final currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SvgUtil(
                            AssetPaths.icClose,
                            width: 24.sp,
                            height: 24.sp,
                            colorFilter: const ColorFilter.mode(
                              RagnarokColors.neutralShade4,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      widget.imgFeedback ??
                          Image.asset(
                            AssetPaths.imgFeedback,
                            width: 150.w,
                            height: 150.w,
                          ),
                      const SizedBox(height: 16),
                      hasRated
                          ? widget.feedbackTitle ??
                              Text(
                                'Help us improve our app',
                                style: RagnarokTextStyles.heading5SemiBold
                                    .copyWith(
                                        color: RagnarokColors.neutralShade2),
                              )
                          : widget.feedbackTitleSecond ??
                              Text(
                                'Have you enjoy App?',
                                style: RagnarokTextStyles.heading5SemiBold
                                    .copyWith(
                                        color: RagnarokColors.neutralShade2),
                              ),
                      hasRated
                          ? const SizedBox.shrink()
                          : const SizedBox(height: 16),
                      hasRated
                          ? const SizedBox.shrink()
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: widget.feedbackDescription ??
                                  Text(
                                    "Tap a star to rate us Or give us a feedback if you want us improve anything.",
                                    style: RagnarokTextStyles.bodyText14Regular
                                        .copyWith(
                                            color:
                                                RagnarokColors.neutralShade3),
                                    textAlign: TextAlign.center,
                                  ),
                            ),
                      hasRated
                          ? const SizedBox.shrink()
                          : const SizedBox(height: 16),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          hasRated
                              ? const SizedBox.shrink()
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: loadingStatus ==
                                                LoadingStatus.updateFailed
                                            ? Colors.red
                                            : Colors.transparent),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      _buildStar(1),
                                      _buildStar(2),
                                      _buildStar(3),
                                      _buildStar(4),
                                      _buildStar(5),
                                    ],
                                  ),
                                ),
                          const SizedBox(height: 8),
                          if (loadingStatus == LoadingStatus.updateFailed)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.rateError ??
                                        'Please rate before send feedback',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      hasRated
                          ? TextField(
                              controller: _textEditingController,
                              maxLines: 4,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    widget.hintText ?? "Share your thought",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: widget.borderTextFiledColor ??
                                        RagnarokColors.neutralShade7,
                                  ),
                                ),
                                hintStyle: const TextStyle(
                                  color: RagnarokColors.neutralShade5,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                contentPadding: const EdgeInsets.all(8),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: RagnarokColors.neutralShade3,
                                  ),
                                ),
                              ),
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: hasAskAgain,
                                  checkColor: RagnarokColors.onPrimary,
                                  activeColor: RagnarokColors.primaryDefault,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  side: const BorderSide(
                                    width: 2,
                                    color: RagnarokColors.neutralShade4,
                                  ),
                                  onChanged: (value) {
                                    widget.onChangeAskAgain
                                        ?.call(value ?? false);
                                    setState(() {
                                      hasAskAgain = value ?? false;
                                    });
                                  },
                                ),
                                widget.askAgainContent ??
                                    Text(
                                      "Don't ask me again",
                                      style: RagnarokTextStyles
                                          .bodyText14Regular
                                          .copyWith(
                                        color: RagnarokColors.neutralShade4,
                                      ),
                                    ),
                              ],
                            ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: RagnarokColors.neutralShade7,
                  margin: const EdgeInsets.only(bottom: 16),
                ),
                InkWell(
                  onTap: () {
                    hasRated
                        ? sendFeedback()
                        : setState(() {
                            if (currentRating == 0) {
                              loadingStatus = LoadingStatus.updateFailed;
                            } else {
                              hasRated = true;
                            }
                          });
                  },
                  child: Center(
                    child: Text(
                      hasRated
                          ? widget.sendFeedback ?? "Send Feedback"
                          : widget.rateUs ?? "Rate us",
                      style: RagnarokTextStyles.bodyText16Medium.copyWith(
                        color: RagnarokColors.primaryDefault,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: RagnarokColors.neutralShade7,
                  margin: const EdgeInsets.only(bottom: 16),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Text(
                      widget.close ?? "Close",
                      style: RagnarokTextStyles.bodyText16Medium.copyWith(
                        color: RagnarokColors.primaryDefault,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStar(int index) {
    return GestureDetector(
        onTap: () async {
          currentRating = index;
          if (index == 5) {
            Navigator.of(context).pop();
            String url = '';
            if (Platform.isIOS) {
              url = widget.urlRateIOS ?? '';
            } else {
              url = widget.urlRateAndroid ?? '';
            }
            final Uri url0 = Uri.parse(url.valueOr(
                'https://play.google.com/store/apps/dev?id=7274700016482359155&hl=vi'));
            if (!await launchUrl(url0)) {
              throw Exception('Could not launch $url0');
            }
          } else {
            setState(() {
              loadingStatus = LoadingStatus.initial;
            });
          }
        },
        child: currentRating < index
            ? widget.starsDisable ??
                SvgPicture.asset(
                  AssetPaths.icStart,
                  width: 32.w,
                  height: 32.w,
                )
            : widget.starsEnable ??
                SvgPicture.asset(
                  AssetPaths.icStartEnabled,
                  width: 32.w,
                  height: 32.w,
                ));
  }
}
