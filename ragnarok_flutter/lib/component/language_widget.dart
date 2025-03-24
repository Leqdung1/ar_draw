import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ragnarok_flutter/local_storage/ragnarok_local_storage.dart';
import 'package:ragnarok_flutter/theme/ragnarok_colors.dart';
import 'package:ragnarok_flutter/theme/ragnarok_text_style.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';
import 'package:ragnarok_flutter/utils/asset_paths.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({
    super.key,
    this.onLanguageChanged,
    this.adsWidget,
    this.backgroundColor,
    this.title,
    this.languageTextStyle,
    this.isBackButtonVisible = true,
    this.backButton,
    this.confirmButton,
    this.centerTitle = false,
    this.onConfirmButtonPressed,
  }) : assert(confirmButton == null || onConfirmButtonPressed != null);

  /// Callback when language is changed
  /// This will be called when user tap on language
  /// if [confirmButton] is not null, [confirmButton] must be handle the language change by calling [onConfirmButtonPressed]
  final Function(AppLanguage)? onLanguageChanged;
  final Widget? adsWidget;
  final Color? backgroundColor;
  final Widget? title;
  final TextStyle? languageTextStyle;
  final bool isBackButtonVisible;
  final Widget? backButton;
  final bool centerTitle;

  /// If [confirmButton] is not null, [onConfirmButtonPressed] must be handle the language change
  /// [confirmButton] should'nt have any onTap or onPressed, it should be a button that only call [onConfirmButtonPressed]
  final Widget? confirmButton;

  /// [onConfirmButtonPressed] must be call [RagnarokLocalStorage.appLanguage = language*] to save the language
  /// *language is the selected language
  final Function(AppLanguage)? onConfirmButtonPressed;

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late AppLanguage initLanguage;
  late List<AppLanguage> languages;
  @override
  void initState() {
    initLanguage = RagnarokLocalStorage.appLanguage;
    languages = defaultLanguages;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor ?? RagnarokColors.onPrimary,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: kToolbarHeight,
              child: Row(
                children: [
                  Flexible(
                      fit: widget.centerTitle ? FlexFit.tight : FlexFit.loose,
                      child: Align(
                        alignment: RagnarokLocalStorage.appLanguage.code == 'ar'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: widget.isBackButtonVisible
                            ? widget.backButton ??
                                IconButton(
                                  icon: SvgPicture.asset(
                                    AssetPaths.icArrowLeft,
                                    colorFilter: const ColorFilter.mode(
                                      RagnarokColors.neutralShade2,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                            : 16.horizontalSpace,
                      )),
                  widget.title ??
                      Text(
                        'Language',
                        style: RagnarokTextStyles.heading5SemiBold.copyWith(
                          color: RagnarokColors.neutralShade2,
                        ),
                      ),
                  Flexible(
                    fit: widget.centerTitle ? FlexFit.tight : FlexFit.loose,
                    child: Align(
                      alignment: RagnarokLocalStorage.appLanguage.code == 'ar'
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: IconButton(
                        icon: widget.confirmButton ?? const SizedBox.shrink(),
                        onPressed: () {
                          widget.onConfirmButtonPressed?.call(initLanguage);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: languages
                    .map((e) => _buildLanguage(
                          language: e,
                          appLanguage: initLanguage,
                        ))
                    .toList(),
              ),
            ),
            widget.adsWidget ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguage({
    required AppLanguage language,
    required AppLanguage appLanguage,
  }) {
    return ListTile(
      onTap: () {
        if (widget.confirmButton == null) {
          RagnarokLocalStorage.appLanguage = language;
        }
        widget.onLanguageChanged?.call(language);
        setState(() {
          initLanguage = language;
        });
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
      leading: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: appLanguage == language
                ? RagnarokColors.primaryDefault
                : RagnarokColors.neutralShade2,
            width: 2,
          ),
        ),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: appLanguage == language
                  ? RagnarokColors.primaryDefault
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
            ),
            child: appLanguage == language
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset(
                      AssetPaths.icCheck,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                : null),
      ),
      title: Text(
        language.name,
        style: widget.languageTextStyle ?? RagnarokTextStyles.bodyText14Regular,
      ),
      trailing: Text(
        language.flag,
        style: TextStyle(fontSize: 24.sp),
      ),
    );
  }
}
