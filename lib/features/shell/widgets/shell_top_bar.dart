import 'package:flutter/material.dart';

import '../../../shared/widgets/brand_logo.dart';
import '../../authentication/widgets/connected_controls.dart';

/// Faixa superior de TODAS as telas logadas: logotipo + tema, música e
/// efeitos sonoros (sempre à mão).
class ShellTopBar extends StatelessWidget {
  const ShellTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: BrandLogo(compact: true),
              ),
            ),
          ),
          SizedBox(width: 8),
          ConnectedControls(showLanguage: false, buttonSize: 44),
        ],
      ),
    );
  }
}