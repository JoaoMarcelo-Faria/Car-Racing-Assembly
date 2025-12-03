# Escape From Police 🚔🏃

> Jogo de perseguição e estratégia desenvolvido em Assembly para o Processador ICMC.

![Badge Concluído](http://img.shields.io/static/v1?label=STATUS&message=CONCLUIDO&color=GREEN&style=for-the-badge)
![Badge Assembly](http://img.shields.io/static/v1?label=LANGUAGE&message=ASSEMBLY&color=BLUE&style=for-the-badge)
![Badge ICMC](http://img.shields.io/static/v1?label=PLATAFORMA&message=PROCESSADOR-ICMC&color=ORANGE&style=for-the-badge)

## 📋 Descrição

Este projeto consiste no desenvolvimento de um jogo estilo *Maze/Chase* (semelhante ao Pac-Man ou GTA 2D clássico) utilizando a linguagem Assembly nativa do **Processador ICMC**. O projeto foi realizado como parte da disciplina de **Organização e Arquitetura de Computadores** no Instituto de Ciências Matemáticas e de Computação (ICMC - USP).

O jogador controla um ladrão que deve coletar moedas para abrir a saída do nível, enquanto foge de viaturas policiais que utilizam algoritmos de perseguição coordenados.

---

## 🚀 Funcionalidades Técnicas

O jogo vai além da movimentação básica, implementando lógicas avançadas de Assembly:

* **Inteligência Artificial de Equipe:** As viaturas não apenas seguem o jogador. Baseado no código, cada policial tem uma estratégia (inspirada nos fantasmas do Pac-Man):
    * *Carro 0:* Perseguição direta (Target = Posição do Jogador).
    * *Carro 1:* Interceptação (Target = Posição à frente do Jogador).
    * *Carro 2:* Espelhamento (Cerca o jogador pelo eixo X oposto).
    * *Carro 3:* Vetorial (Calcula alvo baseado na posição do Carro 0 e Carro 1).
* **Sistema de Níveis:** 4 mapas distintos (`level1` a `level4`) com dificuldade progressiva e aumento no número de policiais ativos.
* **Power-ups Complexos:** Implementação de itens que alteram o estado do jogo (congelamento de inimigos e teletransporte).
* **Colisão Pixel-Perfect:** Verificação de colisão baseada em tiles e bounding box para o sprite do carro (3x2 ou 2x3).
* **Persistência de Estado:** Buffer de vídeo na RAM para manipulação dinâmica do cenário sem perder o mapa original.

---

## 🎮 Como Jogar

### Objetivo
Colete o número mínimo de **Moedas** exigido pelo nível para destravar a saída. Evite as **Viaturas Policiais**. Você tem 3 vidas.

### Controles Básicos

| Tecla | Ação |
| :---: | :--- |
| **W** | Mover para Cima |
| **S** | Mover para Baixo |
| **A** | Mover para Esquerda |
| **D** | Mover para Direita |
| **X** | Cancelar ação / Passar diálogos |
| **Enter** | Iniciar Jogo / Sair quando liberado |

### Controles Especiais (Power-ups)

| Tecla | Contexto | Ação |
| :---: | :--- | :--- |
| **Espaço** | Ao pegar Teletransporte | Confirma o local do teletransporte |
| **1, 2, 3, 4** | Ao pegar Arma Congelante | Escolhe qual viatura eliminar do mapa |

### Itens do Jogo

| Item | Visual (ASCII) | Efeito |
| :--- | :---: | :--- |
| **Moeda** | `.` ou `*` | Ganha pontos e conta para abrir a saída. |
| **Diamante** | `♦` | Multiplica os pontos atuais (Bônus). |
| **Coração** | `♥` | Recupera 1 vida perdida. |
| **Arma** | `🔫` | Congela o jogo e permite eliminar uma viatura digitando seu número (1-4). |
| **Teleporte** | `🌀` | Permite mover o personagem "fantasma" e confirmar nova posição com ESPAÇO. |

---

## 💻 Como Executar

Para rodar este jogo, você precisará do **Simulador do Processador ICMC**.

1.  **Baixe o Repositório:**
    ```bash
    git clone [https://github.com/](https://github.com/)[SEU-USUARIO]/[NOME-DO-REPO].git
    ```
2.  **Abra o Simulador:**
    Execute o arquivo `Simulador.jar`.
3.  **Carregue o Código:**
    * Copie o conteúdo do arquivo `game.asm`.
    * Cole na aba de edição do simulador.
4.  **Montar e Rodar:**
    * Clique em **Montar** (Assemble).
    * Vá para a aba de simulação.
    * Clique em **Rodar** (Run).

> **Dica:** Se o jogo estiver muito rápido ou muito lento, ajuste o *delay* nas configurações do simulador ou diretamente na label `delay` do código.

---

## 📸 Screenshots

| Menu Inicial |
| :---: |
| ![Menu](visuals/screens/menu.png) |

| Tela de Vitória |
| :---: |
| ![Win](visuals/screens/WinScreen.png) |

---

## ✒️ Autores

* **[João Marcelo Geraldo Cintra Faria]** - [GitHub](https://github.com/JoaoMarcelo-Faria)
* **[Guilherme Oliveira]** - [GitHub](https://github.com/Guilherme-Oliveira18)
* **[Murilo Ortega Pereira]** - [GitHub]((https://github.com/muorts))

---

## 📄 Licença

Este projeto está sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.
