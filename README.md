# Yu-Gi-Oh! Card Explorer 🃏📱

Este projeto foi desenvolvido como trabalho prático para a disciplina de **Desenvolvimento de Aplicações Móveis**. Trata-se de um aplicativo construído utilizando o framework **Flutter** (Linguagem Dart) com o objetivo de demonstrar, na prática, o consumo de múltiplas APIs REST, gerenciamento de estado, cálculos em tempo de execução e a construção de interfaces reativas e imersivas.

## 🚀 Funcionalidades

O aplicativo explora o universo do TCG de Yu-Gi-Oh!, oferecendo os seguintes recursos:

* **Busca Ampla de Cartas (Fuzzy Search):** Permite ao usuário pesquisar cartas pelo nome (ex: "Dragão Branco"). A API retorna resultados aproximados, facilitando a busca.
* **Sorteio de Carta Aleatória:** Utilizando um botão de ação flutuante (FAB), o usuário pode descobrir novas cartas entre as milhares disponíveis na franquia.
* **Tradução Dinâmica via *Extensions*:** O tipo da carta (ex: "Spell Card", "Effect Monster") recebido em inglês da API é traduzido em tempo real para o Português através de uma extensão Dart (`CardTypeTranslator`).
* **Cálculo de Média de Mercado:** O aplicativo analisa dados de 5 mercados diferentes (Cardmarket, TCGPlayer, eBay, Amazon, CoolStuffInc) para compor o preço médio justo da carta.
* **Câmbio em Tempo Real (USD -> BRL):** Consome uma API financeira para capturar a cotação atual do dólar e converter instantaneamente o valor médio da carta para Reais (R$).
* **Interface Imersiva e Reativa:** 
  * Modo `immersiveSticky` ativado, escondendo as barras do sistema operacional para maior imersão.
  * Navegação por gestos (deslizar) com `PageView` quando a busca retorna múltiplos resultados.
  * Fundo estilizado com a textura clássica do verso da carta de Yu-Gi-Oh! e carregamentos interativos (`FutureBuilder`).

## 💻 Tecnologias Utilizadas

* **Flutter (SDK >=3.18.0)** - Framework de UI multiplataforma do Google.
* **Dart** - Linguagem de Programação orientada a objetos.
* **Pacote `http` (^0.13.5)** - Utilizado para realizar as requisições assíncronas às APIs externas.

## 📡 APIs Externas Integradas

A aplicação orquestra a comunicação entre dois serviços independentes:
1. **YGOProDeck API (`db.ygoprodeck.com`):** Fornece o acervo completo de cartas, imagens em alta qualidade e listagem de preços.
2. **AwesomeAPI Economia (`economia.awesomeapi.com.br`):** Consulta a taxa de câmbio cambial (USD-BRL) mais recente. Possui um mecanismo de fallback de segurança embutido no código caso a API fique indisponível, garantindo que o app não quebre.

## ⚙️ Como Executar o Projeto

**Pré-requisitos:** Você precisa ter o Flutter SDK devidamente configurado e um emulador (ou dispositivo físico) disponível.

1. Clone o repositório para a sua máquina local:
   ```bash
   git clone [URL_DO_SEU_REPOSITORIO]
   ```
2. Acesse a pasta do projeto:
   ```bash
   cd [NOME_DA_PASTA_DO_PROJETO]
   ```
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Rode a aplicação:
   ```bash
   flutter run
   ```
