import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Cores de "jogo" (madeira, pergaminho, grama...) que complementam o
/// ColorScheme gerado pela cor semente. Têm variantes clara e escura.
@immutable
class PixelTheme extends ThemeExtension<PixelTheme> {
  const PixelTheme({
    required this.background,
    required this.panelFill,
    required this.panelRing,
    required this.panelBorder,
    required this.ink,
    required this.tileFace,
    required this.operatorFace,
    required this.operatorInk,
    required this.reward,
    required this.action,
    required this.actionInk,
    required this.grassA,
    required this.grassB,
    required this.shadow,
  });

  final Color background;
  final Color panelFill; // área de leitura (pergaminho)
  final Color panelRing; // moldura de madeira
  final Color panelBorder; // contorno escuro
  final Color ink; // texto sobre o pergaminho
  final Color tileFace; // peça de dígito
  final Color operatorFace; // peça de operador
  final Color operatorInk;
  final Color reward; // amarelo-manteiga
  final Color action; // terracota
  final Color actionInk;
  final Color grassA;
  final Color grassB;
  final Color shadow;

  factory PixelTheme.light() => const PixelTheme(
        background: NumBloomColors.cream,
        panelFill: NumBloomColors.cream,
        panelRing: NumBloomColors.wood,
        panelBorder: NumBloomColors.woodDark,
        ink: NumBloomColors.ink,
        tileFace: Color(0xFFFFF9E8),
        operatorFace: NumBloomColors.wood,
        operatorInk: NumBloomColors.cream,
        reward: NumBloomColors.butter,
        action: NumBloomColors.terracotta,
        actionInk: NumBloomColors.cream,
        grassA: Color(0xFFA8C58A),
        grassB: Color(0xFF9DBB80),
        shadow: Color(0x33000000),
      );

  factory PixelTheme.dark() => const PixelTheme(
        background: Color(0xFF1F1B14),
        panelFill: Color(0xFF3A3326),
        panelRing: Color(0xFF6B4A2B),
        panelBorder: Color(0xFF150E08),
        ink: Color(0xFFF1E8D0),
        tileFace: Color(0xFF4A4232),
        operatorFace: Color(0xFF6B4A2B),
        operatorInk: Color(0xFFF1E8D0),
        reward: Color(0xFFE3C04F),
        action: Color(0xFFD2704A),
        actionInk: NumBloomColors.ink,
        grassA: Color(0xFF2F4A2A),
        grassB: Color(0xFF2A4326),
        shadow: Color(0x66000000),
      );

  @override
  PixelTheme copyWith({
    Color? background,
    Color? panelFill,
    Color? panelRing,
    Color? panelBorder,
    Color? ink,
    Color? tileFace,
    Color? operatorFace,
    Color? operatorInk,
    Color? reward,
    Color? action,
    Color? actionInk,
    Color? grassA,
    Color? grassB,
    Color? shadow,
  }) =>
      PixelTheme(
        background: background ?? this.background,
        panelFill: panelFill ?? this.panelFill,
        panelRing: panelRing ?? this.panelRing,
        panelBorder: panelBorder ?? this.panelBorder,
        ink: ink ?? this.ink,
        tileFace: tileFace ?? this.tileFace,
        operatorFace: operatorFace ?? this.operatorFace,
        operatorInk: operatorInk ?? this.operatorInk,
        reward: reward ?? this.reward,
        action: action ?? this.action,
        actionInk: actionInk ?? this.actionInk,
        grassA: grassA ?? this.grassA,
        grassB: grassB ?? this.grassB,
        shadow: shadow ?? this.shadow,
      );

  @override
  PixelTheme lerp(ThemeExtension<PixelTheme>? other, double t) {
    if (other is! PixelTheme) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return PixelTheme(
      background: l(background, other.background),
      panelFill: l(panelFill, other.panelFill),
      panelRing: l(panelRing, other.panelRing),
      panelBorder: l(panelBorder, other.panelBorder),
      ink: l(ink, other.ink),
      tileFace: l(tileFace, other.tileFace),
      operatorFace: l(operatorFace, other.operatorFace),
      operatorInk: l(operatorInk, other.operatorInk),
      reward: l(reward, other.reward),
      action: l(action, other.action),
      actionInk: l(actionInk, other.actionInk),
      grassA: l(grassA, other.grassA),
      grassB: l(grassB, other.grassB),
      shadow: l(shadow, other.shadow),
    );
  }
}

extension PixelThemeContext on BuildContext {
  PixelTheme get pixel => Theme.of(this).extension<PixelTheme>()!;
}