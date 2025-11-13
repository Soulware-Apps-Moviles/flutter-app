import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff9f3c00),
      surfaceTint: Color(0xffa33e00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffc35215),
      onPrimaryContainer: Color(0xfffffbff),
      secondary: Color(0xff895036),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfffdb292),
      onSecondaryContainer: Color(0xff78422a),
      tertiary: Color(0xff695f00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbbad2f),
      onTertiaryContainer: Color(0xff474000),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff241914),
      onSurfaceVariant: Color(0xff574239),
      outline: Color(0xff8b7267),
      outlineVariant: Color(0xffdfc0b4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3b2e28),
      inversePrimary: Color(0xffffb596),
      primaryFixed: Color(0xffffdbcd),
      onPrimaryFixed: Color(0xff360f00),
      primaryFixedDim: Color(0xffffb596),
      onPrimaryFixedVariant: Color(0xff7d2d00),
      secondaryFixed: Color(0xffffdbcd),
      onSecondaryFixed: Color(0xff360f00),
      secondaryFixedDim: Color(0xffffb596),
      onSecondaryFixedVariant: Color(0xff6d3921),
      tertiaryFixed: Color(0xfff5e562),
      onTertiaryFixed: Color(0xff1f1c00),
      tertiaryFixedDim: Color(0xffd8c949),
      onTertiaryFixedVariant: Color(0xff4f4800),
      surfaceDim: Color(0xffebd6cd),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1ec),
      surfaceContainer: Color(0xffffe9e2),
      surfaceContainerHigh: Color(0xfffae4db),
      surfaceContainerHighest: Color(0xfff4ded6),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff612200),
      surfaceTint: Color(0xffa33e00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb94b0d),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff582912),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff9a5e43),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3d3700),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff796e00),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff190f0a),
      onSurfaceVariant: Color(0xff463229),
      outline: Color(0xff644d44),
      outlineVariant: Color(0xff80685e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3b2e28),
      inversePrimary: Color(0xffffb596),
      primaryFixed: Color(0xffb94b0d),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff943700),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff9a5e43),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff7d462d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff796e00),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5e5600),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd7c2ba),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1ec),
      surfaceContainer: Color(0xfffae4db),
      surfaceContainerHigh: Color(0xffeed8d0),
      surfaceContainerHighest: Color(0xffe3cdc5),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff511b00),
      surfaceTint: Color(0xffa33e00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff812f00),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4c1f09),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6f3b23),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff322d00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff514a00),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f6),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff3b2820),
      outlineVariant: Color(0xff5a443b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3b2e28),
      inversePrimary: Color(0xffffb596),
      primaryFixed: Color(0xff812f00),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff5c1f00),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6f3b23),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff54250f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff514a00),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff393300),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc9b5ad),
      surfaceBright: Color(0xfffff8f6),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffffede7),
      surfaceContainer: Color(0xfff4ded6),
      surfaceContainerHigh: Color(0xffe6d0c8),
      surfaceContainerHighest: Color(0xffd7c2ba),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb596),
      surfaceTint: Color(0xffffb596),
      onPrimary: Color(0xff581e00),
      primaryContainer: Color(0xffe76d30),
      onPrimaryContainer: Color(0xff401300),
      secondary: Color(0xffffb596),
      onSecondary: Color(0xff51230d),
      secondaryContainer: Color(0xff6d3921),
      onSecondaryContainer: Color(0xffeda485),
      tertiary: Color(0xffd8c949),
      onTertiary: Color(0xff363100),
      tertiaryContainer: Color(0xffbbad2f),
      onTertiaryContainer: Color(0xff474000),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1b110c),
      onSurface: Color(0xfff4ded6),
      onSurfaceVariant: Color(0xffdfc0b4),
      outline: Color(0xffa68b80),
      outlineVariant: Color(0xff574239),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff4ded6),
      inversePrimary: Color(0xffa33e00),
      primaryFixed: Color(0xffffdbcd),
      onPrimaryFixed: Color(0xff360f00),
      primaryFixedDim: Color(0xffffb596),
      onPrimaryFixedVariant: Color(0xff7d2d00),
      secondaryFixed: Color(0xffffdbcd),
      onSecondaryFixed: Color(0xff360f00),
      secondaryFixedDim: Color(0xffffb596),
      onSecondaryFixedVariant: Color(0xff6d3921),
      tertiaryFixed: Color(0xfff5e562),
      onTertiaryFixed: Color(0xff1f1c00),
      tertiaryFixedDim: Color(0xffd8c949),
      onTertiaryFixedVariant: Color(0xff4f4800),
      surfaceDim: Color(0xff1b110c),
      surfaceBright: Color(0xff443631),
      surfaceContainerLowest: Color(0xff160c08),
      surfaceContainerLow: Color(0xff241914),
      surfaceContainer: Color(0xff291d18),
      surfaceContainerHigh: Color(0xff342722),
      surfaceContainerHighest: Color(0xff3f322c),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd3c1),
      surfaceTint: Color(0xffffb596),
      onPrimary: Color(0xff461600),
      primaryContainer: Color(0xffe76d30),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffd3c1),
      onSecondary: Color(0xff431904),
      secondaryContainer: Color(0xffc38064),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffeedf5d),
      onTertiary: Color(0xff2a2600),
      tertiaryContainer: Color(0xffbbad2f),
      onTertiaryContainer: Color(0xff252100),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1b110c),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff6d6c9),
      outline: Color(0xffc9aca0),
      outlineVariant: Color(0xffa68b80),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff4ded6),
      inversePrimary: Color(0xff7f2e00),
      primaryFixed: Color(0xffffdbcd),
      onPrimaryFixed: Color(0xff250800),
      primaryFixedDim: Color(0xffffb596),
      onPrimaryFixedVariant: Color(0xff612200),
      secondaryFixed: Color(0xffffdbcd),
      onSecondaryFixed: Color(0xff250800),
      secondaryFixedDim: Color(0xffffb596),
      onSecondaryFixedVariant: Color(0xff582912),
      tertiaryFixed: Color(0xfff5e562),
      onTertiaryFixed: Color(0xff141100),
      tertiaryFixedDim: Color(0xffd8c949),
      onTertiaryFixedVariant: Color(0xff3d3700),
      surfaceDim: Color(0xff1b110c),
      surfaceBright: Color(0xff50413c),
      surfaceContainerLowest: Color(0xff0e0603),
      surfaceContainerLow: Color(0xff271b16),
      surfaceContainer: Color(0xff322520),
      surfaceContainerHigh: Color(0xff3d302a),
      surfaceContainerHighest: Color(0xff493b35),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffece5),
      surfaceTint: Color(0xffffb596),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffb08e),
      onPrimaryContainer: Color(0xff1b0500),
      secondary: Color(0xffffece5),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xfffcb191),
      onSecondaryContainer: Color(0xff1b0500),
      tertiary: Color(0xfffff293),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffd4c545),
      onTertiaryContainer: Color(0xff0e0b00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff1b110c),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffece5),
      outlineVariant: Color(0xffdbbcb0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff4ded6),
      inversePrimary: Color(0xff7f2e00),
      primaryFixed: Color(0xffffdbcd),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb596),
      onPrimaryFixedVariant: Color(0xff250800),
      secondaryFixed: Color(0xffffdbcd),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffffb596),
      onSecondaryFixedVariant: Color(0xff250800),
      tertiaryFixed: Color(0xfff5e562),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffd8c949),
      onTertiaryFixedVariant: Color(0xff141100),
      surfaceDim: Color(0xff1b110c),
      surfaceBright: Color(0xff5c4d47),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff291d18),
      surfaceContainer: Color(0xff3b2e28),
      surfaceContainerHigh: Color(0xff463833),
      surfaceContainerHighest: Color(0xff52443e),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: Color(0xffFFFFFF),
     canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
