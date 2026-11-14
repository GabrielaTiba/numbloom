import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pixel_theme.dart';

/// Monta o ThemeData a partir de: cor semente, brilho e fonte de texto.
/// O tamanho da fonte é aplicado no app via MediaQuery (TextScaler).
class AppTheme {
  const AppTheme._();

  /// Fontes de texto oferecidas nas configurações (nomes do Google Fonts).
  /// "Arimo" é métrica-compatível com Helvetica/Arial.
  static const List<String> bodyFonts = [
    'Roboto',
    'EB Garamond',
    'Arimo',
    'Nunito',
    'Merriweather',
  ];

  /// Fonte pixelada, usada só em títulos e elementos decorativos.
  static const String pixelFont = 'Pixelify Sans';

  /// Fonte com cobertura de símbolos matemáticos (√ ∛ ⌊ ⌈ ...).
  static const String mathFont = 'Noto Sans Math';

  /// Aplica uma fonte do Google Fonts a um TextStyle (sem passar TextTheme
  /// pelo pacote, o que evita conflito de tipos entre versões).
  static TextStyle? _font(String family, TextStyle? style) =>
      style == null ? null : GoogleFonts.getFont(family, textStyle: style);

  static TextTheme _buildTextTheme(
      TextTheme base, String bodyFont, ColorScheme scheme) {
    final colored = base.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
    TextStyle? body(TextStyle? s) => _font(bodyFont, s);
    TextStyle? pixel(TextStyle? s) => _font(pixelFont, s);

    return colored.copyWith(
      // Títulos e elementos decorativos: fonte pixelada.
      displayLarge: pixel(colored.displayLarge),
      displayMedium: pixel(colored.displayMedium),
      displaySmall: pixel(colored.displaySmall),
      headlineLarge: pixel(colored.headlineLarge),
      headlineMedium: pixel(colored.headlineMedium),
      headlineSmall: pixel(colored.headlineSmall),
      titleLarge: pixel(colored.titleLarge),
      titleMedium:
          pixel(colored.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      // Texto corrido e instruções: fonte escolhida pelo usuário.
      titleSmall: body(colored.titleSmall),
      bodyLarge: body(colored.bodyLarge),
      bodyMedium: body(colored.bodyMedium),
      bodySmall: body(colored.bodySmall),
      labelLarge: body(colored.labelLarge),
      labelMedium: body(colored.labelMedium),
      labelSmall: body(colored.labelSmall),
    );
  }

  static ThemeData build({
    required Color seed,
    required Brightness brightness,
    String bodyFont = 'Roboto',
  }) {
    final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
    final pixel =
        brightness == Brightness.dark ? PixelTheme.dark() : PixelTheme.light();

    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    final text = _buildTextTheme(base.textTheme, bodyFont, scheme);

    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: pixel.panelRing, width: 2),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: text,
      scaffoldBackgroundColor: pixel.background,
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 350),
        showDuration: const Duration(seconds: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: pixel.panelBorder,
          border: Border.all(color: pixel.panelRing, width: 2),
        ),
        textStyle:
            text.bodyMedium?.copyWith(color: pixel.operatorInk, fontSize: 13),
      ),
      extensions: [pixel],
      appBarTheme: AppBarTheme(
        backgroundColor: pixel.panelRing,
        foregroundColor: pixel.operatorInk,
        titleTextStyle: text.titleLarge?.copyWith(color: pixel.operatorInk),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: pixel.tileFace,
        border: fieldBorder,
        enabledBorder: fieldBorder,
        focusedBorder: fieldBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 3),
        ),
      ),
      // Botões do firebase_ui_auth e de qualquer widget padrão herdam
      // o visual "de jogo" (quadrado, contorno escuro, terracota).
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pixel.action,
          foregroundColor: pixel.actionInk,
          minimumSize: const Size(48, 48),
          textStyle: text.titleMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: pixel.panelBorder, width: 2),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: pixel.action,
          foregroundColor: pixel.actionInk,
          minimumSize: const Size(48, 48),
          textStyle: text.titleMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: pixel.panelBorder, width: 2),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: pixel.ink,
          minimumSize: const Size(48, 48),
          side: BorderSide(color: pixel.panelRing, width: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: pixel.action,
          minimumSize: const Size(48, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: pixel.panelBorder,
        contentTextStyle: text.bodyMedium?.copyWith(color: pixel.operatorInk),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}