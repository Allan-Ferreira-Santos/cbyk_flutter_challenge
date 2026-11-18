# CBYK Flutter Challenge

Aplicativo Flutter multiplataforma (Android, iOS e Web) desenvolvido como desafio técnico para a vaga de **Flutter Developer** na CBYK.

A proposta visual recria a experiência de um app de seguros no estilo Tokio Resolve — login, área logada, cotação e navegação lateral — com foco em **organização de código**, **responsividade** e **boas práticas** de Flutter/Dart.

| | |
|--|--|
| **Demo web** | [cbyk-flutter-challenge.web.app](https://cbyk-flutter-challenge.web.app) |
| **Repositório** | [Allan-Ferreira-Santos/cbyk_flutter_challenge](https://github.com/Allan-Ferreira-Santos/cbyk_flutter_challenge) |

---

## Como rodar

Pré-requisitos: [Flutter](https://docs.flutter.dev/get-started/install) estável, Chrome e/ou emulador/device Android ou iOS (Xcode + CocoaPods no Mac).

```bash
git clone https://github.com/Allan-Ferreira-Santos/cbyk_flutter_challenge.git
cd cbyk_flutter_challenge
flutter pub get
flutter run -d chrome    # Web
flutter run              # Android / iOS
```

iOS (primeira vez no Mac):

```bash
cd ios && pod install && cd ..
flutter run
```

As configurações de cliente do Firebase já estão no repositório (`lib/firebase_options.dart`, `android/app/google-services.json` e `ios/Runner/GoogleService-Info.plist`). Não é necessário rodar `flutterfire configure`.

### Testar o fluxo principal

1. Abra a aba **Cadastrar**
2. Informe nome, um CPF válido e senha (mínimo 6 caracteres)
3. Confirme no botão circular → o app cria a conta no Firebase Auth, grava o perfil no Firestore e navega para a Home
4. Faça logout e entre novamente na aba **Entrar** com o mesmo CPF/senha

CPF válido para teste: `529.982.247-25`  
(E-mail interno no Auth: `52998224725@cbyk.challenge`)

### Qualidade

```bash
flutter test
flutter analyze
```

---

## Visão do produto

O app cobre o fluxo pedido no desafio:

- **Autenticação** com CPF, senha, “Lembrar sempre”, link de recuperação e login social (**Google** funcional; Facebook e Twitter apenas ilustrativos)
- **Home** com boas-vindas, área **Cotar e Contratar**, **Minha Família** e **Contratados**
- **Drawer** com avatar, nome do usuário e o menu completo de seguros
- **WebView** ao selecionar o produto **Automóvel**
- **Layout responsivo** compartilhado entre mobile e web
- **Backend** com Firebase Authentication e Cloud Firestore
- **Demo publicada** no Firebase Hosting

---

## Arquitetura

A base segue **Clean Architecture** com organização **feature-first**, separando UI, regras de negócio e dados.

```
Page  →  Cubit  →  UseCase  →  Repository  →  DataSource
              ↑
        GetX Module (DI)
```

### Por que essa escolha

| Camada | Papel |
|--------|--------|
| **Presentation** | Pages, widgets e Cubits — estado de tela, loading e feedback |
| **Domain** | Entities e Use Cases — regras independentes de framework |
| **Data** | Models, repositories e data sources — Firebase, prefs, etc. |
| **Core** | Tema, rotas, DI, componentes reutilizáveis e helpers |

- **GetX** cuida de **rotas e injeção de dependência** (`Bindings` por feature)
- **flutter_bloc (Cubit)** cuida do **estado de apresentação**
- Cada feature (`auth`, `register`, `home`, `splash`, `webview`) é autocontida e fácil de evoluir ou testar isoladamente

### Estrutura

```
lib/
├── main.dart
├── firebase_options.dart
├── core/                 # tema, rotas, DI, widgets, helpers
└── features/
    ├── splash/           # sessão inicial
    ├── auth/             # login
    ├── register/         # cadastro
    ├── home/             # dashboard + drawer
    └── webview/          # cotação Automóvel
```

---

## Stack

- Flutter / Dart 3
- GetX (rotas + DI)
- flutter_bloc / Cubit
- Firebase Auth + Cloud Firestore
- shared_preferences
- webview_flutter (mobile e web)
- Testes com `flutter_test`, `bloc_test`, `mocktail` e `fake_cloud_firestore`

---

## Funcionalidades

### Login e cadastro

- Campos de **CPF** (máscara + validação) e **senha**
- Alternância entre **Entrar** e **Cadastrar**
- Checkbox **Lembrar sempre** (persiste o CPF localmente)
- Link **Esqueceu a senha?** (feedback amigável na UI)
- Login social: botão **Google** funcional; Facebook e Twitter apenas ilustrativos (conforme o briefing)
- Autenticação real com **Firebase Auth**; perfil do usuário em **Firestore**

### Home

- Nome do usuário logado
- Carrossel **Cotar e Contratar** (Automóvel, Residência, Vida, Acidentes Pessoais e itens adicionais de UI)
- Toque em **Automóvel** abre a WebView (`jsonplaceholder.typicode.com`)
- Demais produtos exibem feedback de “em breve”, mantendo a navegação explorável
- Seção **Minha Família** com CTA para adicionar membros
- Seção **Contratados** com estado vazio e mensagem clara

### Menu lateral

Drawer com avatar, nome e os itens solicitados:

Home / Seguros · Minhas Contratações · Meus Sinistros · Minha Família · Meus Bens · Pagamentos · Coberturas · Validar Boleto · Telefones Importantes · Configurações

Itens sem fluxo de negócio dedicado abrem uma tela placeholder — a estrutura de navegação e o visual do menu estão prontos para evolução.

### Responsividade e entrega

- Mesmo codebase para **Android**, **iOS** e **Web**
- Breakpoints e componentes adaptativos
- Deploy em produção no **Firebase Hosting**

---

## Escopo e próximos passos naturais

O desafio pede um recorte de produto com UI completa e pontos de integração. Alguns caminhos foram deixados preparados para evolução sem inflar o escopo da entrega:

---

## Deploy web

Demo: https://cbyk-flutter-challenge.web.app

```bash
flutter build web --release
firebase deploy --only hosting --project cbyk-flutter-challenge
```
