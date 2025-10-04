import 'package:auto_tech/Modules/Home/home_controller.dart';
import 'package:auto_tech/Utilities/text_style_helper.dart';
import 'package:auto_tech/Widgets/student_item_widget.dart';
import 'package:auto_tech/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:state_extended/state_extended.dart';

import '../../Utilities/strings.dart';
import '../../Utilities/theme_helper.dart';
import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/condition_widget.dart';
import '../../Widgets/custom_app_bar_widget.dart';
import '../../Widgets/empty_widget.dart';
import '../../generated/assets.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends StateX<HomeScreen> {

  _HomeScreenState() : super(controller: HomeController()) {
    con = HomeController();
  }
  late HomeController con;

  @override
  void initState() {

    con.setUser();
    con.fetchStudentsByGuardianPhone();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: const BottomNavBarWidget(selected: SelectedBottomNavBar.home),
      backgroundColor: ThemeClass.of(context).background,
      appBar: CustomAppBarWidget(
        name: 'Mohammed',
        //profileImage: con., // or network URL
        hasNotification: false,
        onNotificationTap: () {
          // Handle notification tap
        },
        onProfileTap: () {
          // Handle profile tap
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: con.refreshStudents,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              ConditionWidget(
                condition: con.students.isEmpty,
                conditionWidget: SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Gap(100.h),
                        SvgPicture.asset(Assets.iconsNoStudent),
                        Gap(70.h),
                        Text(Strings.noData.tr, style: TextStyleHelper.of(context).s16SemiBoldTextStyle,)
                      ],
                    ),
                  ),
                ),
                child: SliverList.separated(
                  itemBuilder: (context, index) {
                    return StudentItemWidget(
                      items: con.optionSetting(context, con.students[index]),
                      studentModel: con.students[index],
                    );
                  },
                  separatorBuilder: (_, __) => Gap(0.h),
                  itemCount: con.students.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
