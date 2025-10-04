import 'package:auto_tech/Modules/Home/home_controller.dart';
import 'package:auto_tech/Widgets/student_item_widget.dart';
import 'package:auto_tech/core/Language/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:state_extended/state_extended.dart';

import '../../Utilities/strings.dart';
import '../../Utilities/theme_helper.dart';
import '../../Widgets/condition_widget.dart';
import '../../Widgets/empty_widget.dart';

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

    con.fetchStudentsByGuardianPhone("966562030903");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ThemeClass.of(context).background,
      body:CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          ConditionWidget(
            condition: con.students.isEmpty,
            conditionWidget: SliverToBoxAdapter(
              child: Center(
                child: EmptyWidget(massage: Strings.noData.tr),
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
    );
  }
}
