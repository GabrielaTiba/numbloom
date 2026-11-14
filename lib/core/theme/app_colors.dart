import 'package:flutter/material.dart';

/// Paleta base do NumBloom.
class NumBloomColors {
  const NumBloomColors._();

  static const moss = Color(0xFF4E6E3B); // verde-musgo
  static const sage = Color(0xFFA7BFA0); // verde-sálvia
  static const cream = Color(0xFFF7F0DC);
  static const beige = Color(0xFFE9DDBF);
  static const wood = Color(0xFF8A5A33); // marrom madeira
  static const woodDark = Color(0xFF4D311D);
  static const butter = Color(0xFFF4D35E); // amarelo-manteiga
  static const terracotta = Color(0xFFB5532D);
  static const ink = Color(0xFF2E2418);

  /// Cores semente oferecidas nas configurações (além do seletor livre).
  static const List<Color> seedPresets = [
    moss,
    terracotta,
    Color(0xFF4F7CAC), // azul-lago
    Color(0xFF8E5A9B), // ameixa
    Color(0xFFB8860B), // mel
    Color(0xFF2F7F79), // musgo-água
  ];
}