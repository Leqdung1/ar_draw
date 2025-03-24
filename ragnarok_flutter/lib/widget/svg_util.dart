import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ragnarok_flutter/local_storage/ragnarok_local_storage.dart';

class SvgUtil extends SvgPicture {
  SvgUtil(
    super.assetName, {
    super.key,
    super.colorFilter,
    super.width,
    super.height,
    this.isFlip = false,
  }) : super.asset();

  final bool isFlip;

  @override
  Widget build(BuildContext context) {
    return Transform.flip(
      flipX: isFlip ? RagnarokLocalStorage.appLanguage.code == 'ar' : false,
      child: super.build(context),
    );
  }
}
