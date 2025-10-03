import 'package:flutter/material.dart';
import 'dart:convert';

class SchoolLogoWidget extends StatelessWidget {
  final String logo;
  final double size;
  final String? fallbackText;
  final BoxShape shape;
  final Color? backgroundColor;
  final Color? textColor;

  const SchoolLogoWidget({
    super.key,
    required this.logo,
    this.size = 60.0,
    this.fallbackText,
    this.shape = BoxShape.circle,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: shape,
        color: backgroundColor ?? _getDefaultBackgroundColor(),
        borderRadius: shape == BoxShape.circle 
            ? null 
            : BorderRadius.circular(8),
      ),
      child: _buildLogoContent(),
    );
  }

  Widget _buildLogoContent() {
    // إذا كان الشعار فارغاً، اعرض النص البديل أو أيقونة
    if (logo.isEmpty) {
      return _buildFallbackContent();
    }

    // إذا كان الشعار URL
    if (logo.startsWith('http')) {
      return ClipRRect(
        borderRadius: _getBorderRadius(),
        child: Image.network(
          logo,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackContent();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
      );
    }

    // إذا كان الشعار Base64
    try {
      final bytes = base64Decode(logo);
      return ClipRRect(
        borderRadius: _getBorderRadius(),
        child: Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackContent();
          },
        ),
      );
    } catch (e) {
      // في حالة فشل فك تشفير Base64
      return _buildFallbackContent();
    }
  }

  Widget _buildFallbackContent() {
    return Center(
      child: fallbackText != null && fallbackText!.isNotEmpty
          ? Text(
              fallbackText![0].toUpperCase(),
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: size * 0.4,
              ),
            )
          : Icon(
              Icons.school_rounded,
              color: textColor ?? Colors.white,
              size: size * 0.5,
            ),
    );
  }

  BorderRadius _getBorderRadius() {
    return shape == BoxShape.circle
        ? BorderRadius.circular(size / 2)
        : BorderRadius.circular(8);
  }

  Color _getDefaultBackgroundColor() {
    return const Color(0xFF667eea);
  }
}

// Widget محسن للشعار مع تأثيرات بصرية
class EnhancedSchoolLogoWidget extends StatelessWidget {
  final String logo;
  final double size;
  final String? fallbackText;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? shadows;

  const EnhancedSchoolLogoWidget({
    super.key,
    required this.logo,
    this.size = 60.0,
    this.fallbackText,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2.0,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: borderColor ?? Colors.grey.shade300,
                width: borderWidth,
              )
            : null,
        boxShadow: shadows ??
            [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: SchoolLogoWidget(
        logo: logo,
        size: size,
        fallbackText: fallbackText,
        shape: BoxShape.circle,
      ),
    );
  }
}
