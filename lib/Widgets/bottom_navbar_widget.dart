import 'package:auto_tech/Modules/Home/home_screen.dart';
import 'package:auto_tech/Modules/Help/help_support_screen.dart';
import 'package:auto_tech/Modules/Profile/profile_screen.dart';
import 'package:auto_tech/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../Utilities/bottom_sheet_helper.dart';
import '../Utilities/router_config.dart';
import '../Utilities/strings.dart';
import '../Utilities/theme_helper.dart';
import '../generated/assets.dart';

class BottomNavBarWidget extends StatelessWidget {
  final SelectedBottomNavBar selected;
  
  const BottomNavBarWidget({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          height: 71.h,
          decoration: BoxDecoration(
            color: ThemeClass.of(context).background,

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, -2),
                blurRadius: 20.r,
                spreadRadius: 0,
              ),
            ],
            border: Border(
              top: BorderSide(
                color: ThemeClass.of(context).strokeColor.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BottomNavBarItemWidget(
                    model: _BottomNavBarItemModel.home,
                    currentItem: selected,
                  ),

                  _BottomNavBarItemWidget(
                    model: _BottomNavBarItemModel.help,
                    currentItem: selected,
                  ),

                  _BottomNavBarItemWidget(
                    model: _BottomNavBarItemModel.profile,
                    currentItem: selected,
                  ),
                ],
              ),
            ),
          ),
        );
  }
}

class _BottomNavBarItemWidget extends StatefulWidget {
  final _BottomNavBarItemModel model;
  final SelectedBottomNavBar currentItem;
  
  const _BottomNavBarItemWidget({
    required this.model,
    required this.currentItem,
  });

  bool get isSelected => model.type == currentItem;

  @override
  State<_BottomNavBarItemWidget> createState() => _BottomNavBarItemWidgetState();
}

class _BottomNavBarItemWidgetState extends State<_BottomNavBarItemWidget> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: widget.model.onTap ?? () {
            // Navigate to the selected route
            if (widget.model.routeName.isNotEmpty) {
              if (widget.model.routeName == HelpSupportScreen.routeName) {
                context.pushNamed('helpSupport');
              } else if (widget.model.routeName == HomeScreen.routeName) {
                context.pushNamed('home');
              } else if (widget.model.routeName == ProfileScreen.routeName) {
                context.pushNamed('profile');
              } else {
                context.pushNamed(widget.model.routeName);
              }
            }
          },
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Active Indicator
          if (widget.isSelected)
            Container(
              width: 50.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: ThemeClass.of(context).primaryColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          if (widget.isSelected) SizedBox(height: 4.h),

          SvgPicture.asset(
            widget.model.iconPath,
            width: 20.r,
            height: 20.r,
            colorFilter: ColorFilter.mode(
              widget.isSelected
                  ? ThemeClass.of(context).primaryColor
                  : ThemeClass.of(context).textSecondaryColor,
              BlendMode.srcIn,
            ),
          ),

          SizedBox(height: 4.h),

          // Title
          Text(
            widget.model.title,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
              color: widget.isSelected
                  ? ThemeClass.of(context).primaryColor
                  : ThemeClass.of(context).textSecondaryColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),

    );
  }
}

class _BottomNavBarItemModel {
  final String iconPath;
  final String title;
  final String routeName;
  final SelectedBottomNavBar type;
  final Function()? onTap;
  
  _BottomNavBarItemModel({
    this.onTap,
    required this.iconPath,
    required this.title,
    required this.type,
    this.routeName = '',
  });

  static _BottomNavBarItemModel home = _BottomNavBarItemModel(
    title: Strings.home.tr,
    iconPath: Assets.iconsHome,
    type: SelectedBottomNavBar.home,
    routeName: HomeScreen.routeName,
  );

  static _BottomNavBarItemModel help = _BottomNavBarItemModel(
    title: Strings.help.tr,
    iconPath: Assets.iconsHelp,
    type: SelectedBottomNavBar.help,
    routeName: HelpSupportScreen.routeName,
  );

  static _BottomNavBarItemModel profile = _BottomNavBarItemModel(
    title: Strings.profile.tr,
    iconPath: Assets.iconsProfile,
    type: SelectedBottomNavBar.profile,
    routeName: ProfileScreen.routeName,
  );

}

enum SelectedBottomNavBar { home, help, profile}
