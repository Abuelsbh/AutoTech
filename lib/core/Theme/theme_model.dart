import 'package:flutter/material.dart';
import '../../Utilities/shared_preferences.dart';
import '../../Utilities/theme_helper.dart';


class ThemeModel extends ThemeExtension<ThemeModel>{

  static ThemeModel defaultTheme = ThemeClass.lightTheme();

  final bool isDark;
  final Color background;
  final Color primaryColor;
  final Color secondary;
  final Color state50;
  final Color state200;
  final Color state700;
  final Color strokeColor;
  final Color unreadBackground;
  final Color redBtnColor;
  final Color msgBlue;
  final Color msgTypeGreen;
  final Color msgTypeYellow;
  final Color msgRed;
  final Color msgIconColor;
  final Color greyBtnColor;
  final Color inputFieldColor;
  final Color textMainColor;
  final Color textSecondaryColor;
  final Color primaryBtnColor;
  final Color whiteColor;
  final Color shadowColor;
  final Color attachmentColor;
  final Color cardColor;
  final Color filterBgColor;
  final Color successColor;

  ThemeModel({
    this.isDark = false,
    required this.background,
    required this.state200,
    required this.primaryColor,
    required this.secondary,
    required this.state50,
    required this.state700,
    required this.strokeColor,
    required this.unreadBackground,
    required this.redBtnColor,
    required this.msgBlue,
    required this.msgTypeGreen,
    required this.msgTypeYellow,
    required this.msgRed,
    required this.msgIconColor,
    required this.greyBtnColor,
    required this.inputFieldColor,
    required this.textMainColor,
    required this.textSecondaryColor,
    required this.primaryBtnColor,
    required this.whiteColor,
    required this.shadowColor,
    required this.attachmentColor,
    required this.cardColor,
    required this.filterBgColor,
    required this.successColor,
  });

  @override
  ThemeModel copyWith({
    bool? isDark,
    Color? background,
    Color? state200,
    Color? primaryColor,
    Color? secondary,
    Color? strokeColor,
    Color? unreadBackground,
    Color? redBtnColor,
    Color? msgBlue,
    Color? msgTypeGreen,
    Color? msgTypeYellow,
    Color? msgRed,
    Color? msgIconColor,
    Color? greyBtnColor,
    Color? inputFieldColor,
    Color? textMainColor,
    Color? textSecondaryColor,
    Color? whiteColor,
    Color? shadowColor,
    Color? attachmentColor,
    Color? cardColor,
    Color? primaryBtnColor,
    Color? filterBgColor,
    Color? state50,
    Color? state700,
    Color? successColor,



  }) {
    return ThemeModel(
      isDark: isDark??this.isDark,
      background:background??this.background,
      primaryColor:primaryColor??this.primaryColor,
      secondary:secondary??this.secondary,
      state50:state50 ?? this.state50,
      state700:state700 ?? this.state700,
      state200:state200 ?? this.state200,
      strokeColor:strokeColor??this.strokeColor,
      unreadBackground:unreadBackground??this.unreadBackground,
      redBtnColor:redBtnColor??this.redBtnColor,
      msgBlue:msgBlue??this.msgBlue,
      msgTypeGreen:msgTypeGreen??this.msgTypeGreen,
      msgTypeYellow:msgTypeYellow??this.msgTypeYellow,
      msgRed:msgRed??this.msgRed,
      msgIconColor:msgIconColor??this.msgIconColor,
      greyBtnColor:greyBtnColor??this.greyBtnColor,
      inputFieldColor:inputFieldColor??this.inputFieldColor,
      textMainColor:textMainColor??this.textMainColor,
      textSecondaryColor:textSecondaryColor??this.textSecondaryColor,
      primaryBtnColor:primaryBtnColor??this.primaryBtnColor,
      attachmentColor:attachmentColor??this.attachmentColor,
      whiteColor:whiteColor??this.whiteColor,
      shadowColor:shadowColor??this.shadowColor,
      cardColor:cardColor??this.cardColor,
      filterBgColor:filterBgColor??this.filterBgColor,
      successColor:successColor??this.successColor,
    );
  }

  factory ThemeModel.fromJson(Map<String, dynamic> json) => ThemeModel(
    isDark: json["isDark"],
    state50: Color(json["state50"] ?? 0xffF9FBFD),
    state200: Color(json["state200"] ?? 0xffE2E8F0),
    state700: Color(json["state700"] ?? 0xff314158),
    background: Color(json["background"]),
    primaryColor: Color(json["primaryColor"]),
    secondary: Color(json["secondary"]),
    strokeColor: Color(json["strokeColor"]),
    unreadBackground: Color(json["unreadBackground"]),
    redBtnColor: Color(json["redBtnColor"]),
    msgBlue: Color(json["msgBlue"]),
    msgTypeGreen: Color(json["msgTypeGreen"]),
    msgTypeYellow: Color(json["msgTypeYellow"]),
    msgRed: Color(json["msgRed"]),
    msgIconColor: Color(json["msgIconColor"]),
    greyBtnColor: Color(json["greyBtnColor"]),
    inputFieldColor: Color(json["inputFieldColor"]),
    textMainColor: Color(json["textMainColor"]),
    textSecondaryColor: Color(json["textSecondaryColor"]),
    primaryBtnColor: Color(json["primaryBtnColor"]),
    whiteColor: Color(json["whiteColor"]),
    shadowColor: Color(json["shadowColor"]),
    cardColor: Color(json["cardColor"]),
    attachmentColor: Color(json["attachmentColor"]),
    filterBgColor: Color(json["filterBgColor"]),
    successColor: Color(json["successColor"] ?? 0xFF21C164),
  );

  Map<String, dynamic> toJson() => {
    "isDark": isDark,
    "background": background.value,
    "state200" : state200.value,
    "state700" : state700.value,
    "state50" : state50.value,
    "primaryColor": primaryColor.value,
    "secondary": secondary.value,
    "strokeColor": strokeColor.value,
    "unreadBackground": unreadBackground.value,
    "redBtnColor": redBtnColor.value,
    "msgBlue": msgBlue.value,
    "msgTypeGreen": msgTypeGreen.value,
    "msgTypeYellow": msgTypeYellow.value,
    "msgRed": msgRed.value,
    "msgIconColor": msgIconColor.value,
    "greyBtnColor": greyBtnColor.value,
    "inputFieldColor": inputFieldColor.value,
    "textMainColor": textMainColor.value,
    "textSecondaryColor": textSecondaryColor.value,
    "primaryBtnColor":primaryBtnColor.value,
    "whiteColor": whiteColor.value,
    "shadowColor": shadowColor.value,
    "attachmentColor":attachmentColor.value,
    "cardColor": cardColor.value,
    "filterBgColor": filterBgColor.value,
    "successColor": successColor.value,
  };


  @override
  ThemeModel lerp(ThemeExtension<ThemeModel>? other, double t) {
    if (other is! ThemeModel) {
      return this;
    }
    return SharedPref.getTheme()??defaultTheme;
  }
}