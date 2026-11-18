# NumBloom — Let Numbers Bloom.

Trabalho de **Engenharia Reversa** do aplicativo **Emplake** (prof. Walter
Carnielli), feito em **Flutter + Firebase**, com identidade visual própria
inspirada na atmosfera de jogos de fazenda (pixel art original).

> **Site publicado:** https://numbloom-game.netlify.app
> **Repositório:** [https://github.com/GabrielaTiba/numbloom.git](https://github.com/GabrielaTiba/numbloom.git)

**Grupo:** Gabriela Aya Tiba

## O jogo

Você recebe um número de 4 dígitos. Coloque operadores entre os dígitos (na
ordem) para que os dois lados do `=` deem o mesmo resultado. Cada acerto vale
pontos e faz crescer o seu **jardim**.

Quatro níveis, conforme o enunciado:

| Nível | Operadores |
|---|---|
| Fácil | `+ − × ÷ ( ) √ ∛ ! ** \|x\| ⌊x⌋ ⌈x⌉` (aceita divisão não inteira) |
| Intermediário | `+ − × ÷ ( ) √ ∛ ! ** \|x\|` |
| Avançado | `+ − × ÷ ( ) √ ! \|x\|` |
| Difícil | `+ − × ÷ ( ) \|x\|` |

## Onde cada requisito está implementado

| Requisito do enunciado | Onde |
|---|---|
| Operadores por nível; divisão não inteira só no Fácil | `lib/core/game/game_level.dart`, `expression_parser.dart`, `expression_evaluator.dart` (parser próprio, sem `eval`) |
| Renderização em LaTeX abaixo da fórmula | `lib/core/game/latex_builder.dart` + `lib/features/game/widgets/formula_preview.dart` (`flutter_math_fork`) |
| Interface única | `lib/core/theme/`, `lib/shared/widgets/` (pixel art desenhada em código) |
| Som opcional (começa desligado) | `lib/services/sound_service.dart`, `lib/providers/sound_provider.dart`, `lib/shared/widgets/sound_controls.dart` |
| Versão web | publicada no link acima (`flutter build web`) |
| Login com `firebase_ui_auth` (e-mail/senha e Google) | `lib/features/authentication/screens/auth_pages.dart` |
| Nomes do grupo na página de login | `lib/core/constants/app_constants.dart`, `lib/shared/widgets/credits_footer.dart` |
| Idioma na página de login, com bandeiras | `lib/core/localization/supported_languages.dart`, `lib/shared/widgets/language_flag_button.dart` |
| Todos os textos traduzidos (`flutter_localizations`) | `lib/l10n/app_pt.arb`, `app_en.arb` |
| Barra de navegação curva (`curved_navigation_bar`) | `lib/features/shell/app_shell.dart` |
| Configurações: claro/escuro, tamanho e tipo da fonte, cor semente | `lib/features/settings/screens/settings_screen.dart` |
| Voltar à página em que estava (`SharedPreferences`) | `lib/services/preferences_service.dart`, `lib/core/routing/app_router.dart`, `lib/models/game_session.dart` |
| `flutter_riverpod` | `lib/providers/` |
| `go_router` | `lib/core/routing/` |
| Animação (peças voltam aos botões) | `lib/shared/animations/tile_flight.dart` |
| Firestore com `FutureBuilder` e indicador de progresso diferente | `lib/services/firestore_service.dart`, `lib/features/game/screens/game_screen.dart`, `lib/features/progress/`, `lib/shared/widgets/bloom_loader.dart` (`loading_animation_widget`) |
| Guardar números resolvidos e só mostrar não resolvidos | `lib/services/challenge_service.dart`, `lib/providers/game_provider.dart` |
| Pular um número | botão "Pular" em `lib/features/game/widgets/game_board.dart` |
| Botão de ajuda com `showDialog` | `lib/features/help/widgets/help_dialog.dart` |
| Responsivo (celular, tablet, computador) | `LayoutBuilder`/`MediaQuery` em login, jogo, progresso e configurações |

## Decisões de projeto

- Os números resolvidos são guardados **por nível**: resolver um número no
  Fácil não o tira do Difícil.
- **Dígitos lado a lado formam um só número** (1 e 4 viram 14).
- Fora do nível Fácil, toda **divisão e raiz precisam ser exatas**; todos os
  valores intermediários são inteiros (limite de 10¹⁵).
- **Precedência** (igual ao aplicativo original): `×` e `÷` antes de `+` e `−`;
  `√`, `∛` e `!` valem só para o número ao lado (`√8!` é `(√8)!`); o `−` unário
  vale só para o que vem depois (`−2+2` é `(−2)+2`, `−−2` é `−(−2)`).
- É possível inserir um operador **entre quaisquer duas peças** (antes, entre e
  depois de cada uma) e arrastar as peças já colocadas. Sem limite baixo de
  operadores (aceita expressões compostas).
- A barra `|` é uma peça só: fecha o módulo quando vem depois de um número,
  `)` ou `!`; senão abre. Por isso os módulos podem ser aninhados.
- Ao **errar**, as peças continuam onde estavam; ao **acertar**, uma janela
  comemora e as peças voltam aos botões.
- Pontos por número: Fácil 10, Intermediário 20, Avançado 35, Difícil 60.
- Som, música e efeitos são **sintetizados em código** (sem arquivos de áudio).
- Os dados do jogador ficam em `users/{uid}` no Firestore (plano Spark); as
  regras (`firestore.rules`) só permitem que cada pessoa acesse os próprios.

## Como rodar

```bash
flutter pub get
flutter gen-l10n
flutter test
flutter run -d chrome --web-port=5000
```

O projeto usa o Firebase `numbloom-26916` (a configuração já está em
`lib/firebase_options.dart`).

## Estrutura

```
lib/
  core/game/        motor: parser, avaliador, níveis, LaTeX (sem Firebase)
  core/theme/       tema, paleta e sprites em pixel art
  core/routing/     go_router
  models/ services/ providers/    dados, Firestore, Riverpod
  features/         authentication, game, progress, settings, help, shell
  shared/           widgets e animações reutilizáveis
  l10n/             traduções (en, pt)
web/                ícones, manifesto e favicon
```