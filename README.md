# Cosmo clicker

Cosmo clicker é um jogo do tipo clicker feito em Flutter com tema cósmico, em que o jogador farma fragmentos estelares e abre tesouros estelares para se fortalecer e enfrentar bosses.

## Overview

O projeto segue os princípios do **Clean Architecture** com separação em camadas:
- Domain Layer: Contém *entities* e *use cases* para lógica de negócio;
- Data Layer: Implementa *repositories* com *local data sources* para persistência, utiliza SharedPreferences para armazenamento local (escolhido devido a baixa complexidade dos dados, sem necessidade de relacionamento entre entidades e queries complexas);
- Presentation Layer: Componentes, *controllers* e controle de estado.

O controle de estado usado na aplicação é o **ValueNotifier**. Ele foi escolhido para manter a aplicação altamente reativa, com alta taxa de atualização na interface, animações, partículas geradas ao clicar e adaptação nas estatísticas a cada upgrade, sendo utilizado de forma eficiente com o ListenableBuilder.

Utiliza o *GetIt* para **injeção de dependência**, gerenciando dependências de forma centralizada, promovendo baixo acoplamento entre os componentes e facilitando os testes.

Utiliza-se a biblioteca **AudioPlayers** para efeitos de som na compra de upgrades, ao dropar baús e nas batalhas contra bosses.

## Como gerar uma versão

Para gerar uma versão do jogo, rode o seguinte comando no terminal, na pasta do projeto:  
```bash
flutter build apk --release