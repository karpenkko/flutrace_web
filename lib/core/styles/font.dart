import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle digits(BuildContext context) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 60,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.surface,
  );

  static TextStyle headingExtraLarge(BuildContext context) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.secondary,
  );

  static TextStyle headingLarge(BuildContext context) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.secondary,
  );

  static TextStyle headingMedium(BuildContext context) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.secondary,
  );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).colorScheme.secondary,
  );

  static TextStyle body(BuildContext context) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).colorScheme.secondary,
  );

  static TextStyle bodyLight(BuildContext context) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).primaryColorLight,
  );

  static TextStyle buttonText(BuildContext context) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).primaryColor,
  );

  static TextStyle smallButtonText(BuildContext context) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.secondary,
  );

  static TextStyle smallButtonTextLight(BuildContext context) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.tertiary,
  );

  static TextStyle smallButtonTextDark(BuildContext context) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).primaryColorLight,
  );

  static TextStyle errorHint(BuildContext context) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.error,
  );

  static TextStyle caption(BuildContext context) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.secondary,
  );

  static TextStyle searchField(BuildContext context) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.secondary,
  );
}
