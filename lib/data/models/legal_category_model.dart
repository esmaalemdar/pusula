import 'package:flutter/material.dart';

class LegalCategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String imagePath;

  const LegalCategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.imagePath,
  });
}


