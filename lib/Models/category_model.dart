import 'dart:ui';
import 'package:flutter/cupertino.dart';

class CategoryModel{
  late int id;
  final String? title;

  final String? subTitle;
  final String? icon;
  final IconData? dataIcon;
  final String? routName;
  final String? page;
  final num? percent;
  final Color? color;
  final String? image;
  final Function()? onTap;

  CategoryModel( {this.subTitle, this.percent,this.image, this.dataIcon, this.page, this.color,this.id = 0,this.title, this.icon,this.onTap,this.routName});
}