import 'package:auto_tech/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../../Utilities/text_style_helper.dart';
import '../../../../Utilities/theme_helper.dart';
import '../../../../generated/assets.dart';
import '../Utilities/strings.dart';

class EmptyWidget extends StatelessWidget {
  final String? massage;
  const EmptyWidget({super.key, this.massage});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          Assets.imagesLogo,
          height: 59.h,
          width: 50.167.w,
        ),
        Gap(26.75.h),
        Text(
         Strings.noData.tr,
          style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
            color: ThemeClass.of(context).textMainColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
