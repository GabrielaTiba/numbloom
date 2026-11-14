// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'NumBloom';

  @override
  String get slogan => 'Let Numbers Bloom.';

  @override
  String get levelEasy => 'Fácil';

  @override
  String get levelIntermediate => 'Intermediário';

  @override
  String get levelAdvanced => 'Avançado';

  @override
  String get levelHard => 'Difícil';

  @override
  String get resultCorrect => 'Correto! Seu jardim cresceu.';

  @override
  String resultWrong(String left, String right) {
    return 'Quase: $left ≠ $right';
  }

  @override
  String get errEmpty => 'Monte uma expressão primeiro.';

  @override
  String get errMissingEquals => 'A expressão precisa do sinal de igual (=).';

  @override
  String get errMultipleEquals => 'Use apenas um sinal de igual (=).';

  @override
  String get errUnexpectedToken => 'Há algo fora do lugar na expressão.';

  @override
  String get errUnexpectedEnd => 'A expressão está incompleta.';

  @override
  String get errUnbalanced => 'Parênteses ou delimitadores desbalanceados.';

  @override
  String get errOperatorNotAllowed =>
      'Esse operador não está disponível neste nível.';

  @override
  String get errDivisionByZero => 'Divisão por zero não é permitida.';

  @override
  String get errNonIntegerDivision =>
      'Neste nível só são permitidas divisões exatas (inteiras).';

  @override
  String get errNegativeSqrt => 'Raiz quadrada de número negativo.';

  @override
  String get errNonIntegerRoot => 'As raízes precisam ser exatas neste nível.';

  @override
  String get errInvalidFactorial => 'O fatorial exige um inteiro não negativo.';

  @override
  String get errNonIntegerResult =>
      'Resultados intermediários devem ser inteiros neste nível.';

  @override
  String get errOverflow => 'O número ficou grande demais.';

  @override
  String get errInvalidPower => 'Potência inválida.';

  @override
  String get titleSignIn => 'Entrar';

  @override
  String get titleSignUp => 'Cadastrar';

  @override
  String get titleGoogle => 'Google';

  @override
  String groupCredits(String members) {
    return 'Feito por $members';
  }

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageEnglish => 'Inglês';

  @override
  String get chooseLanguage => 'Escolher idioma';

  @override
  String get navGame => 'Jogar';

  @override
  String get navProgress => 'Progresso';

  @override
  String get navSettings => 'Configurações';

  @override
  String get navHelp => 'Ajuda';

  @override
  String get comingSoon => 'Chega na próxima etapa.';

  @override
  String get back => 'Voltar';

  @override
  String get close => 'Fechar';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Dispositivo';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get settingsFontSize => 'Tamanho da fonte';

  @override
  String get settingsFontPreview => 'Um jardim cresce a cada conta: 2 + 3 = 5.';

  @override
  String get settingsFontFamily => 'Fonte';

  @override
  String get settingsSeedColor => 'Cor do tema';

  @override
  String get settingsCustomColor => 'Cor personalizada';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsSound => 'Som';

  @override
  String get settingsAccount => 'Conta';

  @override
  String settingsSignedInAs(String email) {
    return 'Conectado como $email';
  }

  @override
  String get settingsSignOut => 'Sair';

  @override
  String get helpTitle => 'Como jogar';

  @override
  String get helpGoalTitle => 'Objetivo';

  @override
  String get helpHowTitle => 'Jogando';

  @override
  String get helpLevelsTitle => 'Níveis e operadores';

  @override
  String get helpRulesTitle => 'Regras';

  @override
  String get helpGardenTitle => 'Seu jardim';

  @override
  String get helpGardenBody =>
      'Cada número resolvido planta algo novo no seu jardim, e as plantas crescem conforme você continua resolvendo. Números pulados não contam.';

  @override
  String get themeSwitchToDark => 'Ativar modo escuro';

  @override
  String get themeSwitchToLight => 'Ativar modo claro';

  @override
  String get soundTurnOn => 'Ligar os efeitos sonoros';

  @override
  String get soundTurnOff => 'Desligar os efeitos sonoros';

  @override
  String get loading => 'Carregando…';

  @override
  String get loadError => 'Não foi possível carregar seus dados.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get gameNumberLabel => 'Número';

  @override
  String get gameLevelLabel => 'Nível';

  @override
  String get gameScore => 'Pontos';

  @override
  String get gameFormulaTitle => 'Sua fórmula';

  @override
  String get gameFormulaEmpty =>
      'Coloque operadores entre os dígitos para montar sua fórmula.';

  @override
  String get gameOperators => 'Operadores';

  @override
  String get gameCheck => 'Verificar';

  @override
  String get gameClear => 'Limpar';

  @override
  String get gameUndo => 'Remover último';

  @override
  String get gameSkip => 'Pular';

  @override
  String get gameNext => 'Próximo número';

  @override
  String gameSlotLabel(int index) {
    return 'Espaço $index';
  }

  @override
  String get gameTapGapHint =>
      'Agora toque em um espaço do número, ou arraste a peça até ele.';

  @override
  String gameCorrectPoints(int points) {
    return '+$points pontos';
  }

  @override
  String get gameSaving => 'Salvando seu progresso…';

  @override
  String get gameSaveError =>
      'Não foi possível salvar seu progresso. Verifique a conexão.';

  @override
  String get gameAllSolved =>
      'Você resolveu todos os números deste nível! Tente outro nível.';

  @override
  String get progressSolved => 'Resolvidos';

  @override
  String get progressCompletion => 'Conclusão';

  @override
  String get progressByLevel => 'Por nível';

  @override
  String get progressGardenTitle => 'Seu jardim';

  @override
  String progressGardenLabel(int count) {
    return 'Jardim com $count plantas';
  }

  @override
  String get progressRecent => 'Soluções recentes';

  @override
  String get progressNoSolutions =>
      'Resolva seu primeiro número para plantar a primeira semente!';

  @override
  String progressLevelCount(int solved, int total) {
    return '$solved de $total';
  }

  @override
  String get musicTurnOn => 'Ligar a música';

  @override
  String get musicTurnOff => 'Desligar a música';

  @override
  String get settingsMusic => 'Música';

  @override
  String get settingsMusicSubtitle =>
      'Música de fundo suave. Desligada por padrão.';

  @override
  String get settingsEffects => 'Efeitos sonoros';

  @override
  String get settingsEffectsSubtitle =>
      'Cliques e sons das respostas. Desligados por padrão.';

  @override
  String get helpGoalBody =>
      'Você recebe um número de quatro dígitos. Coloque operadores entre os dígitos, na ordem, para que os dois lados do sinal de igual deem o mesmo resultado.';

  @override
  String get helpExample => 'Exemplo';

  @override
  String get helpExampleCaption =>
      'O número 8131 vira √(8+1) = 3**1, porque 3 = 3.';

  @override
  String get helpStep1 =>
      'Escolha um nível. Níveis difíceis têm menos operadores e dão mais pontos.';

  @override
  String get helpStep2 =>
      'Toque em um operador e depois em um espaço do número. Também dá para segurar e arrastar até lá.';

  @override
  String get helpStep3 =>
      'Toque em uma peça colocada para removê-la. “Remover último” e “Limpar” também ajudam.';

  @override
  String get helpStep4 =>
      'Aperte Verificar. As peças voam de volta aos botões e sua resposta é testada.';

  @override
  String get helpStep5 =>
      'Respostas certas dão pontos e fazem seu jardim crescer. Travou? Aperte Pular.';

  @override
  String get helpRule1 =>
      'Dígitos lado a lado formam um só número: 1 e 4 viram 14.';

  @override
  String get helpRule2 =>
      'Use exatamente um sinal de igual. Ele começa entre o 2º e o 3º dígito e pode ser movido.';

  @override
  String get helpRule3 =>
      'Só o Fácil aceita resultados não inteiros, como 5/2. Nos outros níveis toda divisão e toda raiz precisam ser exatas.';

  @override
  String get helpRule4 =>
      'O fatorial (!) exige um número inteiro maior ou igual a zero.';

  @override
  String helpLevelPoints(int points) {
    return '$points pontos por número';
  }

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Senha';

  @override
  String get authConfirmPassword => 'Confirmar senha';

  @override
  String get authForgotPassword => 'Esqueceu a senha?';

  @override
  String get authGoogleButton => 'Entrar com o Google';

  @override
  String get authResetTitle => 'Redefinir senha';

  @override
  String get authResetSend => 'Enviar link de redefinição';

  @override
  String get opTipAdd => 'Soma: 2 + 3 = 5';

  @override
  String get opTipSubtract => 'Subtração: 5 − 2 = 3';

  @override
  String get opTipMultiply => 'Multiplicação: 2 × 3 = 6';

  @override
  String get opTipDivide => 'Divisão: 6 ÷ 3 = 2';

  @override
  String get opTipParenOpen => 'Abre parênteses: agrupa o que vem depois';

  @override
  String get opTipParenClose => 'Fecha parênteses: termina o grupo';

  @override
  String get opTipSqrt => 'Raiz quadrada: √9 = 3';

  @override
  String get opTipCbrt => 'Raiz cúbica: ∛8 = 2';

  @override
  String get opTipFactorial => 'Fatorial: 4! = 4 × 3 × 2 × 1 = 24';

  @override
  String get opTipPower => 'Potência (expoente): 2 ** 3 = 8';

  @override
  String get opTipAbs =>
      'Módulo (valor absoluto): |−5| = 5. Uma barra abre, a seguinte fecha';

  @override
  String get opTipFloorOpen =>
      'Piso, abertura: ⌊x⌋ é o maior inteiro que não passa de x';

  @override
  String get opTipFloorClose => 'Piso, fechamento';

  @override
  String get opTipCeilOpen =>
      'Teto, abertura: ⌈x⌉ é o menor inteiro que não é menor que x';

  @override
  String get opTipCeilClose => 'Teto, fechamento';

  @override
  String get opTipEquals =>
      'Sinal de igual: os dois lados precisam dar o mesmo resultado';

  @override
  String get gameTileHint => 'Arraste para mover · toque para remover';

  @override
  String get firebaseInitError =>
      'Não foi possível conectar ao Firebase. Confira a configuração do projeto (flutterfire configure) e a sua conexão com a internet.';
}
