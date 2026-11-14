import 'package:flutter/material.dart';

import '../../shared/widgets/pixel_sprite.dart';

/// Pixel art original do NumBloom (grades 10x10), sem assets externos.
/// Legenda: G/g verdes, B solo, D solo escuro, T tronco, R pétala/baga,
/// Y manteiga, W branco, C creme, O terracota, P rosa.
class Sprites {
  const Sprites._();

  static const Map<String, Color> _pal = {
    'G': Color(0xFF3E6B34),
    'g': Color(0xFF6FA24A),
    'B': Color(0xFF8A5A33),
    'D': Color(0xFF5A3A22),
    'T': Color(0xFF6B4423),
    'R': Color(0xFFD9544D),
    'Y': Color(0xFFF4D35E),
    'W': Color(0xFFFFF6E0),
    'C': Color(0xFFEADFC0),
    'O': Color(0xFFC4623A),
    'P': Color(0xFFF08CA8),
  };

  static const PixelSprite soil = PixelSprite([
    '..........',
    '..........',
    '..........',
    '..........',
    '..........',
    '..........',
    '..........',
    '..........',
    '..BBBBBB..',
    '.BBDBBDBB.',
  ], _pal);

  static const PixelSprite sprout = PixelSprite([
    '..........',
    '..........',
    '....g.g...',
    '...ggGgg..',
    '....gGg...',
    '.....G....',
    '.....G....',
    '.....G....',
    '..BBBBBB..',
    '.BBDBBDBB.',
  ], _pal);

  static const PixelSprite flower = PixelSprite([
    '...RRR....',
    '..RRYRR...',
    '...RRR....',
    '.....G....',
    '..gg.G.gg.',
    '...ggGgg..',
    '.....G....',
    '.....G....',
    '..BBBBBB..',
    '.BBDBBDBB.',
  ], _pal);

  static const PixelSprite mushroom = PixelSprite([
    '...RRRR...',
    '..RWRRWR..',
    '.RRRRRRRR.',
    '.RWRRRRWR.',
    '...CCCC...',
    '...CCCC...',
    '...CCCC...',
    '..CCCCCC..',
    '..BBBBBB..',
    '.BBDBBDBB.',
  ], _pal);

  static const PixelSprite bush = PixelSprite([
    '..........',
    '..........',
    '...gggg...',
    '..gggRgg..',
    '.gggggggg.',
    '.ggRgggRg.',
    '..gggggg..',
    '.....T....',
    '..BBBBBB..',
    '.BBDBBDBB.',
  ], _pal);

  static const PixelSprite tree = PixelSprite([
    '...gggg...',
    '..gggggg..',
    '.gggGgggg.',
    '.ggggggGg.',
    '..gGgggg..',
    '...gggg...',
    '.....T....',
    '.....T....',
    '..BBBBBB..',
    '.BBDBBDBB.',
  ], _pal);

  /// Botão: caule com um botão de flor colorido ('R' = cor do botão).
  static const PixelSprite bud = PixelSprite([
    '..........',
    '..........',
    '....RR....',
    '....RR....',
    '.....G....',
    '...g.G.g..',
    '....gGg...',
    '.....G....',
    '..BBBBBB..',
    '.BBDBBDBB.',
  ], _pal);

  static const PixelSprite daisy = PixelSprite([
    '....WW....',
    '..WWYYWW..',
    '..WWYYWW..',
    '....WW....',
    '.....G....',
    '..gg.G.gg.',
    '...ggGgg..',
    '.....G....',
    '..BBBBBB..',
    '.BBDBBDBB.',
  ], _pal);

  static const PixelSprite tulip = PixelSprite([
    '...R..R...',
    '...RRRR...',
    '...RRRR...',
    '....RR....',
    '.....G....',
    '..gg.G.gg.',
    '...ggGgg..',
    '.....G....',
    '..BBBBBB..',
    '.BBDBBDBB.',
  ], _pal);

  static const PixelSprite sunflower = PixelSprite([
    '..Y.YY.Y..',
    '.YYYYYYYY.',
    'YYYDDDDYYY',
    'YYYDDDDYYY',
    '.YYYYYYYY.',
    '.....G....',
    '..gg.G.gg.',
    '.....G....',
    '..BBBBBB..',
    '.BBDBBDBB.',
  ], _pal);

  static const PixelSprite appleTree = PixelSprite([
    '...gggg...',
    '..gggRgg..',
    '.gRgggggg.',
    '.gggggRgg.',
    '..gRgggg..',
    '...gggg...',
    '.....T....',
    '.....T....',
    '..BBBBBB..',
    '.BBDBBDBB.',
  ], _pal);

  /// Borboleta ('W' = asas, 'D' = corpo).
  static const PixelSprite butterfly = PixelSprite([
    'WW.....WW',
    'WWW.D.WWW',
    '.WWWDWWW.',
    '.WWWDWWW.',
    'WWW.D.WWW',
    'WW.....WW',
  ], _pal);

  /// Variantes de flor (troca de cor das pétalas / miolo).
  static final PixelSprite flowerRed = flower;
  static final PixelSprite flowerPink = flower.recolor({'R': _pal['P']!});
  static final PixelSprite flowerYellow =
      flower.recolor({'R': _pal['Y']!, 'Y': _pal['O']!});

  // ---- Cenário da tela inicial ----
  static String _row(int total, List<List<int>> segs, String ch) {
    final cells = List<String>.filled(total, '.');
    for (final s in segs) {
      for (var i = s[0]; i < s[0] + s[1] && i < total; i++) {
        cells[i] = ch;
      }
    }
    return cells.join();
  }

  static const Map<String, Color> _cloudPal = {
    'W': Color(0xFFFFFFFF),
    'b': Color(0xFFCFE6F7),
  };

  static final PixelSprite cloudA = PixelSprite([
    _row(30, [[7, 6], [17, 6]], 'W'),
    _row(30, [[5, 10], [15, 10]], 'W'),
    _row(30, [[3, 24]], 'W'),
    _row(30, [[1, 28]], 'W'),
    _row(30, [[0, 30]], 'W'),
    _row(30, [[2, 26]], 'b'),
  ], _cloudPal);

  static final PixelSprite cloudB = PixelSprite([
    _row(20, [[6, 6]], 'W'),
    _row(20, [[4, 10]], 'W'),
    _row(20, [[2, 16]], 'W'),
    _row(20, [[0, 20]], 'W'),
    _row(20, [[2, 16]], 'b'),
  ], _cloudPal);

  static const PixelSprite sparkle = PixelSprite([
    '..W..',
    '.WWW.',
    'WWWWW',
    '.WWW.',
    '..W..',
  ], {'W': Color(0xFFFFFFFF)});

  static const PixelSprite leaf = PixelSprite([
    '...ggg',
    '..gggg',
    '.gGggg',
    'gGggg.',
    '.ggg..',
    'g.....',
  ], _pal);

  // ---- Bandeiras (seletor de idioma) ----
  static const PixelSprite flagBr = PixelSprite([
    'gggggggggggggggg',
    'gggggggYYggggggg',
    'gggggYYYYYYggggg',
    'gggYYYYYYYYYYggg',
    'ggYYYYBBBBYYYYgg',
    'gYYYYBBBBBBYYYYg',
    'ggYYYYBBBBYYYYgg',
    'gggYYYYYYYYYYggg',
    'gggggYYYYYYggggg',
    'gggggggYYggggggg',
    'gggggggggggggggg',
  ], {
    'g': Color(0xFF2E8B3E),
    'Y': Color(0xFFF7D417),
    'B': Color(0xFF1F4E9C),
  });

  static const PixelSprite flagUs = PixelSprite([
    'BBBBBBBRRRRRRRRR',
    'BWBWBWBWWWWWWWWW',
    'BBBBBBBRRRRRRRRR',
    'BWBWBWBWWWWWWWWW',
    'BBBBBBBRRRRRRRRR',
    'BWBWBWBWWWWWWWWW',
    'RRRRRRRRRRRRRRRR',
    'WWWWWWWWWWWWWWWW',
    'RRRRRRRRRRRRRRRR',
    'WWWWWWWWWWWWWWWW',
    'RRRRRRRRRRRRRRRR',
  ], {
    'R': Color(0xFFC8372D),
    'W': Color(0xFFFFFFFF),
    'B': Color(0xFF2B3F8C),
  });

  static const PixelSprite googleG = PixelSprite([
    '..######..',
    '.##....##.',
    '##........',
    '##........',
    '##...####.',
    '##.....##.',
    '.##....##.',
    '..######..',
  ], {'#': Color(0xFF4285F4)});

  // ---- Ícones do topo (tema, som, voltar) ----
  static const PixelSprite sun = PixelSprite([
    '....OO....',
    '.O......O.',
    '...YYYY...',
    '..YYYYYY..',
    'OYYYYYYYYO',
    'OYYYYYYYYO',
    '..YYYYYY..',
    '...YYYY...',
    '.O......O.',
    '....OO....',
  ], {'Y': Color(0xFFF4D35E), 'O': Color(0xFFE08A3C)});

  static const PixelSprite moon = PixelSprite([
    '....YYYY..',
    '..YYYY....',
    '.YYYY.....',
    '.YYY......',
    'YYYY......',
    'YYYY......',
    '.YYY......',
    '.YYYY.....',
    '..YYYYYY..',
    '....YYYY..',
  ], {'Y': Color(0xFF3F55B0)});

  static const PixelSprite speakerOn = PixelSprite([
    '....#.....',
    '...##..#..',
    '#####...#.',
    '#####.#.#.',
    '#####.#.#.',
    '#####...#.',
    '...##..#..',
    '....#.....',
  ], {'#': Colors.black});

  static const PixelSprite speakerOff = PixelSprite([
    '....#.....',
    '...##.....',
    '#####.#.#.',
    '#####..#..',
    '#####..#..',
    '#####.#.#.',
    '...##.....',
    '....#.....',
  ], {'#': Colors.black});

  static const PixelSprite musicNote = PixelSprite([
    '......##..',
    '......#.##',
    '......#..#',
    '......#...',
    '......#...',
    '...####...',
    '..#####...',
    '..#####...',
    '...###....',
  ], {'#': Colors.black});

  /// Nota musical cortada por uma barra (música desligada).
  static const PixelSprite musicOff = PixelSprite([
    'XX....##..',
    '.XX...#.##',
    '..XX..#..#',
    '...XX.#...',
    '....XX#...',
    '...##XX...',
    '..####XX..',
    '..#####XX.',
    '...###..XX',
  ], {
    '#': Colors.black,
    'X': Color(0xFFC4623A),
  });

  static const PixelSprite arrowLeft = PixelSprite([
    '....#.....',
    '...##.....',
    '..###.....',
    '.########.',
    '.########.',
    '..###.....',
    '...##.....',
    '....#.....',
  ], {'#': Colors.black});

  // ---- Ícones monocromáticos (use `recolor({'#': cor})`) ----
  static const PixelSprite gear = PixelSprite([
    '....##....',
    '..#.##.#..',
    '...####...',
    '.###..###.',
    '###....###',
    '.###..###.',
    '...####...',
    '..#.##.#..',
    '....##....',
    '..........',
  ], {'#': Colors.black});

  static const PixelSprite question = PixelSprite([
    '..######..',
    '.##....##.',
    '.##....##.',
    '......##..',
    '....##....',
    '....##....',
    '..........',
    '....##....',
    '....##....',
    '..........',
  ], {'#': Colors.black});
}

class PlantVisual {
  const PlantVisual(this.sprite, this.scale, this.stage);
  final PixelSprite sprite;
  final double scale;

  /// 1 = botão, 2 = jovem, 3 = adulta.
  final int stage;
}

class _PlantType {
  const _PlantType(this.bud, this.young, this.adult);
  final Color bud; // cor do botão de flor (1ª fase)
  final PixelSprite young;
  final PixelSprite adult;
}

/// Regra do jardim: a k-ésima planta nasce no k-ésimo desafio resolvido e
/// cresce com a "idade" (desafios resolvidos desde então):
/// botão colorido -> jovem -> adulta. Há 12 espécies (flores de várias cores,
/// margarida, tulipa, girassol, cogumelos, arbustos e árvores), intercaladas
/// para o jardim ficar variado.
class PlantSprites {
  const PlantSprites._();

  static const Color _red = Color(0xFFD9544D);
  static const Color _pink = Color(0xFFF08CA8);
  static const Color _yellow = Color(0xFFF4D35E);
  static const Color _blue = Color(0xFF4F7CAC);
  static const Color _purple = Color(0xFF8E5A9B);
  static const Color _white = Color(0xFFFFF6E0);
  static const Color _orange = Color(0xFFE08A3C);

  static final PixelSprite _blueFlower =
      Sprites.flower.recolor({'R': _blue, 'Y': _white});
  static final PixelSprite _purpleFlower =
      Sprites.flower.recolor({'R': _purple});
  static final PixelSprite _orangeTulip = Sprites.tulip.recolor({'R': _orange});
  static final PixelSprite _purpleMushroom =
      Sprites.mushroom.recolor({'R': _purple});
  static final PixelSprite _cherryBush = Sprites.bush
      .recolor({'g': const Color(0xFFF2A6C0), 'R': _white});
  static final PixelSprite _cherryTree = Sprites.tree.recolor({
    'g': const Color(0xFFF2A6C0),
    'G': const Color(0xFFD97C9C),
  });

  static final List<_PlantType> _types = [
    _PlantType(_red, Sprites.flowerRed, Sprites.flowerRed),
    _PlantType(_yellow, Sprites.sunflower, Sprites.sunflower),
    _PlantType(_blue, _blueFlower, _blueFlower),
    _PlantType(_red, Sprites.mushroom, Sprites.mushroom),
    _PlantType(_pink, Sprites.flowerPink, Sprites.flowerPink),
    _PlantType(_white, Sprites.daisy, Sprites.daisy),
    _PlantType(_red, Sprites.bush, Sprites.appleTree),
    _PlantType(_purple, _purpleFlower, _purpleFlower),
    _PlantType(_orange, _orangeTulip, _orangeTulip),
    _PlantType(_yellow, Sprites.flowerYellow, Sprites.flowerYellow),
    _PlantType(_pink, _cherryBush, _cherryTree),
    _PlantType(_purple, _purpleMushroom, _purpleMushroom),
  ];

  static PlantVisual forPlot(int plotIndex, int age) {
    final type = _types[plotIndex % _types.length];
    final stage = age < 3 ? 1 : (age < 8 ? 2 : 3);
    if (stage == 1) {
      return PlantVisual(Sprites.bud.recolor({'R': type.bud}), 0.7, 1);
    }
    return stage == 2
        ? PlantVisual(type.young, 0.85, 2)
        : PlantVisual(type.adult, 1.0, 3);
  }
}