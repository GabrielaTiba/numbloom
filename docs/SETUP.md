# Guia de configuração: Firebase, execução e publicação

Projeto Firebase: `numbloom-26916`.

---

## 1. Preparar o projeto

```bash
flutter create --platforms=web,android .      # só se ainda não existir
flutter pub get
flutter pub upgrade --major-versions          # depois fixe as versões no pubspec
flutter gen-l10n                              # gera lib/l10n/generated/
flutter test                                  # motor matemático + regras + sessão
```

Copie para o projeto: a pasta `lib/`, `test/`, `pubspec.yaml`, `l10n.yaml`,
`firestore.rules`, `firebase.json`, `.firebaserc` e a pasta `web/icons/` +
`web/favicon.png` + `web/manifest.json` (substituem os padrões do Flutter).

## 2. Firebase (plano Spark, gratuito)

### 2.1 Criar o projeto
1. https://console.firebase.google.com → **Adicionar projeto** → nome `numbloom`.
2. Pode desativar o Google Analytics (não é usado).
3. Não ative nada que peça cartão: tudo aqui é do plano **Spark**.

### 2.2 Authentication
1. **Build → Authentication → Começar**.
2. Aba **Sign-in method**:
   - **E-mail/senha** → Ativar → Salvar.
   - **Google** → Ativar → escolha o e-mail de suporte → Salvar.
3. Ainda em *Google*, abra **Web SDK configuration** e copie o **Web client ID**
   (termina em `.apps.googleusercontent.com`).
4. Cole em `lib/core/constants/app_constants.dart` → `googleClientId`.
5. (Opcional, mais seguro) em `web/index.html`, dentro do `<head>`:
   ```html
   <meta name="google-signin-client_id" content="SEU_CLIENT_ID.apps.googleusercontent.com">
   ```

### 2.3 Firestore
1. **Build → Firestore Database → Criar banco de dados**.
2. Modo **produção**; escolha uma região perto (ex.: `southamerica-east1`).
3. Aba **Regras** → cole o conteúdo de `firestore.rules` → **Publicar**
   (ou use `firebase deploy`, que já envia as regras — veja a seção 4).

### 2.4 Ligar o app ao projeto
```bash
dart pub global activate flutterfire_cli
npm install -g firebase-tools
firebase login
flutterfire configure        # escolha o projeto e a plataforma Web (e Android)
```
Isso **sobrescreve** `lib/firebase_options.dart` com as chaves reais.

### 2.5 Trocar os dados do grupo
`lib/core/constants/app_constants.dart` → `groupMembers` (aparece na entrada).

### 2.6 Testar localmente
```bash
flutter run -d chrome
```
Roteiro: criar conta → jogar e acertar → ver o Firestore
(**Firestore → Dados → users → seu uid**: `score` e `solved`) → sair → entrar
com Google → conferir que os dados continuam.

## 3. Voltar de onde parou

O app guarda no aparelho (SharedPreferences), **por usuário**:
- a **aba** em que você estava (Jogar, Progresso ou Configurações);
- o **nível** escolhido;
- a **partida em andamento**: o número sorteado e os operadores já colocados.

Ao reabrir, volta para a mesma aba e a mesma partida. Se o número da partida
salva já tiver sido resolvido, sorteia um novo. Os pontos e os números
resolvidos ficam no Firestore (valem em qualquer aparelho).

## 4. Publicar na web

Edite `.firebaserc` e troque `numbloom-26916` pelo ID do projeto
(aparece em *Configurações do projeto*).

### Opção A — Firebase Hosting
```bash
flutter build web --release
firebase deploy            # publica o site E as regras do Firestore
```
O endereço fica `https://SEU-PROJETO.web.app` e já é um domínio autorizado
para o login. Só enviar o site: `firebase deploy --only hosting`.

### Opção B — Netlify (a usada na entrega)
```bash
flutter build web --release
```
Arraste a pasta `build/web` em https://app.netlify.com/drop.
**Depois**: Firebase → Authentication → **Settings → Authorized domains** →
**Add domain** → `seu-site.netlify.app` (senão o login falha).

### Opção C — Vercel
```bash
flutter build web --release
npm i -g vercel
vercel build/web --prod
```
Depois autorize o domínio `*.vercel.app` do mesmo jeito.

### Opção D — GitHub Pages
```bash
flutter build web --release --base-href "/NOME-DO-REPOSITORIO/"
```
Publique o conteúdo de `build/web` e autorize `SEU-USUARIO.github.io`.

> As rotas usam `#` na URL, então não é preciso configurar redirecionamentos.

## 5. Problemas comuns

| Sintoma | Causa provável | Solução |
|---|---|---|
| Tela só com "Não foi possível conectar ao Firebase" | `flutterfire configure` não foi rodado / sem internet | rodar o comando e recompilar |
| `auth/unauthorized-domain` | domínio do site não autorizado | Authentication → Settings → Authorized domains |
| Login com Google falha na web | Client ID ausente/errado | conferir o passo 2.2 |
| `permission-denied` / "Missing or insufficient permissions" | regras do Firestore não publicadas | `firebase deploy --only firestore:rules` |
| Pop-up do Google bloqueado | bloqueador de pop-ups do navegador | permitir pop-ups do site |
| Música não toca ao reabrir | navegadores bloqueiam áudio automático | ela começa no primeiro toque na tela |
| Fontes sem carregar | sem internet (Google Fonts) | conectar; as fontes vêm do Google |

## 6. Antes de entregar no AVA

- [ ] Nomes do grupo em `app_constants.dart`.
- [ ] Remover os arquivos de demonstração: `lib/main_gallery.dart`,
      `lib/main_title.dart`, `lib/main_preview.dart`.
- [ ] `flutter analyze` sem erros e `flutter test` passando.
- [ ] Testar: cadastro, login (e-mail e Google), jogar, pular, sair/entrar,
      fechar e reabrir (mesma aba e mesma partida), tema/fonte/cor/idioma,
      música e efeitos.
- [ ] Informar a URL publicada.
- [ ] Conferir com o professor se `pubspec.yaml`, `l10n.yaml` e os `.arb`
      (traduções) podem seguir junto com os `.dart`.

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