import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../Models/category_model.dart';
import '../Models/student_model.dart';
import '../Utilities/text_style_helper.dart';
import '../Utilities/theme_helper.dart';

class OtherOptionWidget extends StatelessWidget {
  final List<CategoryModel> options;
  final StudentModel? model;
  const OtherOptionWidget({super.key, required this.options,  this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: model?.sender == null?500.h:600.h,
      padding: EdgeInsets.symmetric( horizontal: 12.w),
      decoration: BoxDecoration(
          color: ThemeClass.of(context).background,
          borderRadius: BorderRadius.circular(30.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(14.h),
          Center(
            child: Container(
              height: 3,
              width: 50,
              color: ThemeClass.of(context).greyBtnColor,
            ),
          ),
          Gap(17.h),

          // Text(
          //   model?.subject??'',
          //   maxLines: 1,
          //   style: TextStyleHelper.of(context)
          //       .hm_18
          //       .copyWith(color: ThemeClass.of(context).primaryColor),
          // ),
    Expanded(
      child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            Gap(12.h),
            ...options.map((e) => InkWell(
              onTap: e.onTap ??()=> context.pushNamed( e.routName??''),
              child: Container(
                    height: 50.w,
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                        color: ThemeClass.of(context).cardColor,
                        border: Border.all(
                            color: ThemeClass.of(context).inputFieldColor),
                        borderRadius: BorderRadius.circular(8.r)),
                    child: Row(
                      children: [
                        Gap(16.w),
                        // Show either SVG icon or Flutter icon
                        e.icon != null 
                          ? SvgPicture.asset(e.icon!, color: ThemeClass.of(context).primaryColor, width: 20.w, height: 20.h)
                          : Icon(e.dataIcon, color: ThemeClass.of(context).primaryColor, size: 20.w),
                        Gap(8.w),
                        Text(
                          e.title ?? '',
                          style: TextStyleHelper.of(context).s14RegTextStyle.copyWith(
                              color: ThemeClass.of(context).textMainColor),
                        )
                      ],
                    ),
                  ),
            ))])),
    ),
          // Expanded(
          //   child: ListView.separated(
          //     itemBuilder: (context,index)=> OtherItemWidget(user: users[index]),
          //     separatorBuilder: (context,index)=>Gap(16.h),
          //     itemCount: users.length,
          //   ),
          // )
        ],
      ),
    );
  }
}
