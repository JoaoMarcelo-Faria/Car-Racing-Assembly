; ------- TABELA DE CORES -------
; adicione ao caracter para Selecionar a cor correspondente

; 0 branco                          0000 0000
; 256 marrom                        0001 0000
; 512 verde                         0010 0000
; 768 oliva                         0011 0000
; 1024 azul marinho                 0100 0000
; 1280 roxo                         0101 0000
; 1536 teal                         0110 0000
; 1792 prata                        0111 0000
; 2048 cinza                        1000 0000
; 2304 vermelho                     1001 0000
; 2560 lima                         1010 0000
; 2816 amarelo                      1011 0000
; 3072 azul                         1100 0000
; 3328 rosa                         1101 0000
; 3584 aqua                         1110 0000
; 3840 branco                       1111 0000

jmp main
;meu persongaem inicial - ladrao 

; --- VARIÁVEIS DE JOGO ---
vidas: var #1
static vidas + #0, #3

; --- VARIÁVEIS DE PONTUAÇÃO ---
bonus: var #1
static bonus + #0, #50  ; Começa com 50 -> vira 250 ao pegar o diameante

steps: var #1
static steps + #0, #0  ; Contador de passos no nível

max_pontos: var #1
static max_pontos + #0, #5 ; Defina aqui quantos pontos existem no mapa para ganhar

; Strings para o HUD (Texto Estático)
; "PTS:"
str_pts: string "PTS:"
; "VIDAS:"
str_vidas: string "VIDAS:"


MsgVenceu: string "VOCE VENCEU!"
MsgSimas:  string "SIMAS ESTA ORGULHOSO"


r8: var #1
static r8 + #0, #0

; Variavel de morte
morte: var #1
static morte + #0, #0

; Variaveis relacionadas a teclas
comecou: var #1
static comecou + #0, #0
tecla_atual: var #1
static tecla_atual + #0, #255
tecla_ant: var #1
static tecla_ant + #0, #255

tecla_enter: var #1
static tecla_enter + #0, #255

; Variavel da funcao de calculo de uma posicao no cenario
posObjeto: var #1
posCenario: var #1

rand_ptr: var #1
static rand_ptr + #0, #0

;PONTUAÇÃO
; Variavel com a quantidade de pontos
pontos: var #1
static pontos + #0, #0

; Variavel para platinar o jogo
Zerou: var #1
static Zerou + #0, #0

; Buffer que guardará o estado ATUAL do nível rodando
; Todos os personagens devem ler/escrever AQUI, não no 'level1' ou 'level2'
MapBuffer: var #1200

; Mapa de calor para a polícia não voltar
; 0 = Frio (Ninguém passou), >0 = Quente (Recente)
HeatMap: var #1200
static HeatMap + #0, #0

;Variaveis de nivel
nivel_atual: var #1
static nivel_atual + #0, #1     ;começa no nivel 1


; --- CONTROLE DE SAÍDA E MOEDAS ---
saida_liberada: var #1     ; 0 = Bloqueada, 1 = Liberada (Pode passar de nível)
static saida_liberada + #0, #0

min_moedas: var #1         ; Mínimo necessário para liberar a saída
static min_moedas + #0, #0

; Defina aqui o MÍNIMO para passar de cada nível
min_moedas_lvl1: var #1
static min_moedas_lvl1 + #0, #3  ; Ex: Precisa de 3 das 12 para passar

min_moedas_lvl2: var #1
static min_moedas_lvl2 + #0, #5  ; Ex: Precisa de 5 das 13

min_moedas_lvl3: var #1
static min_moedas_lvl3 + #0, #9 ; Ex: Precisa de 9 das 18

min_moedas_lvl4: var #1
static min_moedas_lvl4 + #0, #11 ; Ex: Precisa de 13 das 22

; String para avisar que pode sair
str_saida: string "   PARA SAIR PRESSIONE ENTER   "

;Moedas por nivel
moedas_lvl1: var #1
static moedas_lvl1 + #0, #12    ;tem 12 moedas no nivel 1

moedas_lvl2: var #1
static moedas_lvl2 + #0, #17    ;tem 4 moedas no nivel 2

moedas_lvl3: var #1
static moedas_lvl3 + #0, #19      ;tem 6 moedas no nivel 3

moedas_lvl4: var #1
static moedas_lvl4 + #0, #27

;Variaveis para a funcao de dar um teletransporte
str_teleport: string " ESPACO P/ CONFIRMAR O TP      "
; Backup para cancelar o teletransporte
teleport_backup_pos: var #1
teleport_backup_sprite: var #1
teleport_backup_gap: var #1
teleport_backup_dir: var #1
teleport_backup_pos_ant: var #1
teleport_backup_sprite_ant: var #1
teleport_backup_gap_ant: var #1


;Variaveis para a funcao de matar policial
str_freeze_lvl1: string "DIGITE 1 PARA MATAR O POLICIAL"
str_freeze_lvl2: string "DIGITE 1-2 PARA MATAR UM POLICIAL"
str_freeze_lvl3: string "DIGITE 1-3 PARA MATAR UM POLICIAL"
str_freeze_lvl4: string "DIGITE 1-4 PARA MATAR UM POLICIAL"
str_clear: string "                                  "


itens_coletados: var #1
static itens_coletados + #0, #0

; --- Adicione junto com as outras variáveis ---
total_policiasatv: var #1
static total_policiasatv + #0, #0
; LADRAO O PERSONAGEM PRINCIPAL

; Variaveis de movimentacao Ladrao
;posicao incial declaração e atribuição  
;static ladraoPosition + #0, #490
dir_ladrao: var #1
static dir_ladrao + #0, #0
pos_ant_ladrao: var #1
static pos_ant_ladrao + #0, #490
pos_ladrao: var #1
static pos_ladrao + #0, #490

  
ladraoSprite: var #1
ladraoGapsPtr : var #1  ;
ladraoGapsPtr_ant : var #1



; POLICIAIS - INIMIGOS
; --- BANCO DE DADOS DA POLÍCIA (4 Unidades) ---
; Índices: 0, 1, 2, 3

morto_policia: var #4      ; Array de se deve printar o policial atual e utiliza-lo atuais
pos_policia: var #4      ; Array de posições atuais
pos_ant_policia: var #4  ; Array de posições anteriores
policia_dir: var #4      ; Array de direções
policia_sprite: var #4   ; Array de ponteiros de sprite
policia_gaps: var #4     ; Array de ponteiros de gaps atuais
policia_gaps_ant: var #4 ; Array de ponteiros de gaps anteriores
policia_est: var #4      ; Array de estados

; Variável de controle do loop
temp_indice: var #1
static temp_indice + #0, #0


; --- VARIAVEIS DE DIREÇÃO E ESTRATÉGIA DE LOCALIZAÇÃO DA POLICIA

dir_policiaant: var #1
pos_policiaant: var #1
est_policiaant: var #1
x_policiaant: var #1
y_policiaant: var #1
target_eh_xy: var #1
pos_target: var #1
x_target: var #1
y_target: var #1
target_carro1: var #1   ; Armazena o alvo do carro 1 para o carro 3 usar

dist_a: var #1
dist_s: var #1
dist_w: var #1
dist_d: var #1
dist_dir: var #1
ehParede: var #1

pos_policiaant_a: var #1
pos_policiaant_w: var #1
pos_policiaant_s: var #1
pos_policiaant_d: var #1



main:
    call loop_ini
    call inicializa_var
    
round_game:
    ; ---------------------------------------
    ; SELEÇÃO DE NÍVEL
    ; ---------------------------------------
    load r0, nivel_atual
    
    loadn r1, #1
    cmp r0, r1
    jne CarregaLevel2
    loadn r0, #level1
    jmp CarregaCenario
    
CarregaLevel2:
    loadn r1, #2
    cmp r0, r1
    jne CarregaLevel3
    loadn r0, #level2
    jmp CarregaCenario
    
CarregaLevel3:
    loadn r1, #3
    cmp r0, r1
    jne CarregaLevel4
    loadn r0, #level3
    jmp CarregaCenario
    
CarregaLevel4:
    loadn r0, #level4
    jmp CarregaCenario
    
CarregaCenario:

    ; 1. Copia o Mapa da ROM para a RAM (Buffer)
    call CarregaMapaParaBuffer
    
    ; 2. Desenha o Mapa usando o Buffer
    loadn r0, #MapBuffer
    call printCenario
    
    ; 3. Configurações do Nível
    call GetMoedasNivelAtual
    call AtualizaHUD

    call ResetPosicoesPorNivel ; <--- ISSO É OBRIGATÓRIO PARA RESETAR AS POSIÇÕES CORRETAMENTE DOS POLICIAIS E LADRÃO POR LEVEL!
    
    ; ---------------------------------------
    ; DESENHO INICIAL DOS PERSONAGENS
    ; ---------------------------------------
    
    ; Desenha Ladrão
    load r0, ladraoSprite
    load r1, ladraoGapsPtr
    load r2, pos_ladrao
    call printladrao
    
    ; Desenho Inicial Policiais
    ;call DesenhaTodasPolicias
    ; Desenha os 4 Policiais (Loop Inicial)
    loadn r3, #0 ; i = 0
    load r4, nivel_atual ; max
    loadn r5,#1

DrawInitPolice:
    cmp r3, r4
    jeq StartGameLoop
    
    ; Configura qual policial vamos desenhar
    store temp_indice, r3
    
    loadn r2, #morto_policia
    add r2, r2, r3
    loadi r2,r2
    cmp r5,r2
    jeq next_pollD
         
    ; Carrega Sprite
    loadn r0, #policia_sprite
    add r0, r0, r3
    loadi r0, r0
    
    ; Carrega Gaps
    loadn r1, #policia_gaps
    add r1, r1, r3
    loadi r1, r1
    
    ; Carrega Posição
    loadn r2, #pos_policia
    add r2, r2, r3
    loadi r2, r2
    
    call printladrao ; (Usa a mesma função de print)
    
    next_pollD:
        inc r3
    jmp DrawInitPolice

StartGameLoop:
    loadn r0, #0 ; Contador de Delay
    loadn r3, #0 ; Contador de Delay
    loadn r2, #0 ; Contador de Velocidade da Polícia

main_inicio:
        call delay
            inc r0
            inc r3
            loadn r1, #25
            mod r1, r0, r1
            jnz main_inicio
            loadn r1, #5
            mod r1, r3, r1
            jnz Skip_Decay
            call HeatMap_Decay
        Skip_Decay:
        ; quick input check to react faster to ENTER/SPACE when exit is liberated
        load r0, saida_liberada
        loadn r1, #1
        cmp r0, r1
        jne GameLoop_Move
        call WaitForEnter
        load r0, tecla_atual
        loadn r1, #13
        cmp r0, r1
        jeq VitoriaNivel
        load r0, max_pontos
        load r1,itens_coletados
        cmp r0,r1
        jeq VitoriaNivel
        
    GameLoop_Move:
        
    ; --- 2. MOVIMENTAÇÃO DO JOGADOR ---
    call CalculaPos
    
    ; Checa colisão logo após o jogador mover
    call CheckPlayerPoliceCollision

    ; --- 3. CONTROLE DE VELOCIDADE DA POLÍCIA ---
    ; A polícia move 1 vez a cada X movimentos do loop principal
    inc r2
    loadn r1, #5  ; A polícia move metade das vezes (ajuste para dificuldade)
    mod r1, r2, r1
    jnz SkipPoliceMove
    
    ; Move TODAS as Polícias (IA de Equipe)
    call UpdatePolicia
    ; Checa colisão logo após a polícia mover
    call CheckPlayerPoliceCollision 

SkipPoliceMove:
    
    jmp main_inicio ; Volta para o loop
        
    
printCenario:
  push r0
  push r1
  push r2
  push r3

  loadn r1, #0
  loadn r2, #1200

  printCenarioLoop:

    add r3,r0,r1
    loadi r3, r3
    outchar r3, r1
    inc r1
    cmp r1, r2

    jne printCenarioLoop

  pop r3
  pop r2
  pop r1
  pop r0
  rts 

; funcao de delay - principal
; alem de ser o delay, le a entrada do teclado
delay:
    push r0
    push r1
    push r2
    push r3
    push r4

    loadn r1, #8

; loops de delay
delay_loop1:
    loadn r2, #200
    
delay_loop2:
    ; leitura do caracter do teclado
    inchar r3               ; le o char do teclado
    loadn r4, #255          ; carrega 255 (nenhuma tecla pressionada)
    cmp r3, r4              ; compara a entrada com 255
    jeq delay_sai_entrada
    store tecla_atual, r3
    
    
delay_sai_entrada:
    dec r2
    jnz delay_loop2
    dec r1
    jnz delay_loop1
    
    ;load r3, tecla_atual
    ;store tecla_ant, r3
    
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
; ----------------------
; WaitForEnter (poll rapido)
; Retorna quando ENTER(13) ou SPACE(32) forem detectados, ou timeout
; Ao detectar, armazena tecla em tecla_atual
; ----------------------
WaitForEnter:
    push r0
    push r1
    push r2
    push r3
    loadn r1, #200    ; tentativas (ajustável)
WaitLoop:
    inchar r0
    loadn r2, #255
    cmp r0, r2
    jeq Wait_NoKey
    ; se achou tecla, verifica se é ENTER ou SPACE
    loadn r2, #13
    cmp r0, r2
    jeq Wait_Store
    loadn r2, #32
    cmp r0, r2
    jeq Wait_Store
    jmp Wait_NoKey
Wait_Store:
    store tecla_atual, r0
    jmp Wait_Done
Wait_NoKey:
    dec r1
    jnz WaitLoop
Wait_Done:
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
printladrao:
  push r0
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7

  loadn r3, #6 ;tamanho ladrao
  loadn r4, #0 ;incremetador

  printladraoLoop:
    add r5,r0,r4
    loadi r5, r5

    add r6,r1,r4
    loadi r6, r6

    add r7, r2, r6

    outchar r5, r7
    
    inc r4
    cmp r3, r4
    jne printladraoLoop

  pop r7
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0
  rts

apagarladrao:
  push r0
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6

  load r6, tecla_atual
  loadn r6, #255
  store tecla_atual, r6
  

  
  loadn r0, #MapBuffer
  load r1, ladraoGapsPtr_ant
  load r2, pos_ant_ladrao
  loadn r3, #6 ;tamanho ladrao
  loadn r4, #0 ;incremetador

  apagarladraoLoop:
    add r5,r1,r4
    loadi r5, r5
    
    push r2 
    
    add r2,r2,r5
    
    add r6,r0,r2
    loadi r6, r6
        
    outchar r6, r2

    pop r2
    
    inc r4
    cmp r3, r4
    jne apagarladraoLoop



  pop R6
  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts

just_wait:
    push r0
    push r1
    
    loadn r0, #63999
    loadn r1, #0
    lll:
        dec r0
        cmp r0, r1              
        jne lll
    
    pop r1
    pop r0
    rts
    
loop_ini:
    push r0
    push r1
    push r2
    loadn r0, #menu
    call printCenario
    loop_menu_wait:
        call delay 
        load r2, tecla_atual
        loadn r1, #'x'
        cmp r1, r2
        jne loop_menu_wait
    loadn r1, #255
    store tecla_atual, r1       ; limpa o teclado na memoria
    call WaitKeyRelease
    loadn r0, #PointsRules
    call printCenario
    loop_inil:
        call delay 
        load r2, tecla_atual
        loadn r1, #'x'
        cmp r1, r2              ; se digitou x, sai do loop
        jne loop_inil
    pop r2
    pop r1
    pop r0
    rts
    
    
; Funcao que calcula a posicao (VERSÃO SIMPLIFICADA E CORRIGIDA)
CalculaPos:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7

    ; 1. Salva a posição atual em 'pos_ant_ladrao' para poder apagar depois
    load r0, pos_ladrao
    store pos_ant_ladrao, r0
    
    load r4, ladraoGapsPtr
    store ladraoGapsPtr_ant, r4
    ; 2. Verifica se uma nova tecla foi pressionada
    load r1, tecla_atual
    loadn r2, #255          ; Valor de "nenhuma tecla"
    cmp r1, r2
    jeq MoveComDirAnterior ; Se nenhuma tecla nova, pule para mover com a direção antiga
    
    load r2, dir_ladrao
    cmp r1, r2
    jeq NaoEhCurva
    store tecla_ant, r2
    
    ; É UMA CURVA!  R7 é usado como "Flag de Curva" para o Assistente
    loadn r7, #1 
    jmp AtualizaDir
    
  NaoEhCurva:
    loadn r7, #0 ; Não é curva, desativa assistente    
    
  AtualizaDir:
    ; 3. Uma tecla FOI pressionada (w,a,s,d). Atualiza a 'dir_ladrao'
    store dir_ladrao, r1
    


MoveComDirAnterior:
    cmp r1, r2 ; Recalcula comparação (r1=tecla, r2=255)
    jeq ZeraFlagCurva
    
    jmp ProcessaMovimento
    
ZeraFlagCurva:
    loadn r7, #0    
    
ProcessaMovimento:
    ; ================================
    ; ESQUERDA ('a')
    ; ================================
    load r1, dir_ladrao
    
    loadn r2, #'a'
    cmp r1, r2
    jne ChecaCima
    
    ; Movimento Básico
    loadn r3, #1
    sub r0, r0, r3

    loadn r5, #ladrao_L
    loadn r6, #ladraoGaps_H
    jmp FazChecagem

    ; ================================
    ; CIMA ('w')
    ; ================================
ChecaCima: 
    loadn r2, #'w'
    cmp r1, r2
    jne ChecaBaixo
    
    
    loadn r3, #40
    sub r0, r0, r3
    loadn r5, #ladrao_U
    loadn r6, #ladraoGaps_V
    jmp FazChecagem

    ; ================================
    ; BAIXO ('s')
    ; ================================
ChecaBaixo: 
    loadn r2, #'s'
    cmp r1, r2
    jne ChecaDireita


    loadn r3, #40
    add r0, r0, r3
    loadn r5, #ladrao_D
    loadn r6, #ladraoGaps_V
    jmp FazChecagem

    ; ================================
    ; DIREITA ('d')
    ; ================================
ChecaDireita: 
    loadn r2, #'d'
    cmp r1, r2
    jne FimCalculaPos ; Se não for nada, sai

    ; Movimento Básico
    loadn r3, #1
    add r0, r0, r3
    
    loadn r5, #ladrao_R
    loadn r6, #ladraoGaps_H

    
FazChecagem:
    ; 1. Checagem de Limites da Tela (Central)
    loadn r2, #0
    cmp r0, r2
    jle Movimento_Invalido
    
    mov r4, r0
    loadn r2, #81 
    add r4, r4, r2
    loadn r3, #1190
    cmp r4, r3
    jgr Movimento_Invalido

    ; 2. Checagem de Colisão (R0=NovaPos, R6=GapShape)
    mov r2, r6              ; Passa Shape para R2 (CheckMoveValido usa R2)
    call CheckMoveValido    ; Retorna R7=1 (ok) ou 0 (parede)
    
    loadn r1, #1
    cmp r7, r1
    jeq Movimento_Valido   ; Se passou de primeira, ótimo!

    ; --- LÓGICA DE ASSISTÊNCIA DE CURVA (CORNERING) ---
    ; Se bateu, tenta deslocar +/- 1 no eixo contrário para encaixar
    
    ; Descobre se estamos movendo Vertical ou Horizontal
    load r1, dir_ladrao
    loadn r2, #'w'
    cmp r1, r2
    jeq Tenta_H
    loadn r2, #'s'
    cmp r1, r2
    jeq Tenta_H
    
    ; Se estamos indo A ou D, tenta ajustar Verticalmente (+/- 40)
Tenta_V:
    ; Tenta Cima (-40)
    push r0
    loadn r3, #40
    sub r0, r0, r3
    mov r2, r6             ; Garante shape certo
    call CheckMoveValido
    loadn r1, #1
    cmp r7, r1
    jeq Sucesso_Assistido
    pop r0                 ; Restaura
    
    ; Tenta Baixo (+40)
    push r0
    loadn r3, #40
    add r0, r0, r3
    mov r2, r6
    call CheckMoveValido
    loadn r1, #1
    cmp r7, r1
    jeq Sucesso_Assistido
    pop r0
    jmp Movimento_Invalido

Tenta_H:
    ; Tenta Esquerda (-1)
    push r0
    loadn r3, #1
    sub r0, r0, r3
    mov r2, r6
    call CheckMoveValido
    loadn r1, #1
    cmp r7, r1
    jeq Sucesso_Assistido
    pop r0
    
    ; Tenta Direita (+1)
    push r0
    loadn r3, #1
    add r0, r0, r3
    mov r2, r6
    call CheckMoveValido
    loadn r1, #1
    cmp r7, r1
    jeq Sucesso_Assistido
    pop r0
    jmp Movimento_Invalido

Sucesso_Assistido:
    ; r0 tem a posição ajustada que funcionou. 
    ; Removemos o valor antigo da pilha (o pop r0 que pulamos)
    pop r4 
    jmp Movimento_Valido

Movimento_Invalido:
    jmp FimCalculaPos

Movimento_Valido:
    ; 1) Apaga o ladrão usando POS_ANT e GAPS_ANT (apagar versão antiga)
    call apagarladrao

    ; 2) Atualiza posição e aparência para a nova posição
    store pos_ladrao, r0
    store ladraoSprite, r5
    store ladraoGapsPtr, r6

    ; 3) Atualiza steps
    load r4, steps
    inc r4
    store steps, r4
    
    ; 4) Desenha o ladrão na posição NOVA (usa os valores atualizados em memória)
    ; printladrao espera: R0 = sprite ptr, R1 = gaps ptr, R2 = pos
    load r0, ladraoSprite
    load r1, ladraoGapsPtr
    load r2, pos_ladrao
    call printladrao

    ; 5) Agora cheque itens na nova posição
    ; CheckEatItems pode chamar ExecutaTeletransporte internamente.
    ; Se ExecutaTeletransporte for chamado e confirmar teleporte (R7==1),
    ; ele já terá feito apagar/desenhar e possivelmente restaurado/alterado pos_ladrao.
    ; Portanto, se teleporte ocorreu, NÃO tentamos redesenhar nem apagar de novo.
    call CheckEatItems
FimCalculaPos:
    loadn r1, #255
    store tecla_atual, r1
    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts


;MUDANÇA 2 --------
;---------------------------------------------------------------------
; checkMoveValido
; Checa se a posição em R0 é válida para o carrinho 3x2.
; Ela checa todos os 6 blocos do carrinho contra o 'initScre'.
; Retorna: R7 = 1 (se o movimento for VÁLIDO)
;          R7 = 0 (se o movimento for BLOQUEADO)
; ---------------------------------------------------------------------
CheckMoveValido:
    push r0 ; Salva a nova_pos
    push r1
    push r2
    push r3
    push r4
    push r5 ; Usado para o ID do tile
    push r6


    loadn r1, #MapBuffer      ; Endereço base do cenário
    ;load r2, ladraoGapsPtr    ; Endereço base dos offsets do carrinho
    loadn r3, #6             ; Tamanho do loop (6 tiles)
    loadn r4, #0             ; Incrementador (i = 0)
    
    loadn r7, #1             ; Flag de retorno: assume 1 (VÁLIDO) por padrão
                             ; (será mudado para 0 se achar uma parede)
CheckLoop:
    ; Calcula o endereço do tile do cenário para checar
    push r0                  ; Salva a nova_pos
    add r5, r2, r4           ; r5 = &ladraoGaps[i]
    loadi r5, r5             ; r5 = ladraoGaps[i] (ex: 0, 1, 2, 40, 41, 42)
    add r0, r0, r5           ; r0 = nova_pos + offset
    add r5, r1, r0           ; r5 = &initScre[nova_pos + offset]


    
    ; 2. --- PROTEÇÃO DE TELA (A CORREÇÃO DO BUG) ---
    ; Se (PosAbsoluta < 0) OU (PosAbsoluta >= 1200), Bloqueia!
    loadn r6, #1199
    cmp r0, r6
    jgr Block_Found_Pop       ; Se > 1199, sai indicando erro
    
    loadn r6, #0
    cmp r0, r6
    jle Block_Found_Pop       ; Se <= 0, sai indicando erro (segurança extra)

    ; 3. Verifica Colisão com Cenário (Paredes)
    add r5, r1, r0            ; r5 = Endereço no Buffer (MapBuffer + Pos)
    loadi r5, r5              ; r5 = ID do tile no mapa
    pop r0                    ; Restaura r0 para a base original
    
    call IsTileWalkable     
    
    loadn r6, #0
    cmp r7, r6               ; A flag R7 foi para 0?
    jeq CheckLoopEnd        ; Se sim, encontramos uma parede. Pare de checar.
    
    inc r4
    cmp r4, r3
    jne CheckLoop
    loadn r7, #1  
    jmp CheckLoopEnd
    
Block_Found_Pop:
    pop r0                    ; Restaura pilha (do push r0 lá em cima)
    loadn r7, #0              ; Marca como INVÁLIDO
    
CheckLoopEnd:
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0 ; Restaura a nova_pos original (embora já tenhamos feito isso)
    rts


; Sub-rotina de 'checkMoveValido'.
; Checa se o TILE ID em R5 é "andável".
; Se NÃO for, ele seta R7 para 0.
IsTileWalkable:
; R5 tem o ID do Tile. R7 é a flag.
    push r0 ; Salva registrador temporário
    push r5 ; Salvamos R5 para não estragar o valor original fora da função

; --- REMOVE A COR ---
    call GetBaseID ; Agora R5 tem apenas o ID do caractere (0-255)

    ; MUDANÇA PRINCIPAL: Assumimos que o tile É VÁLIDO (R7 = 1)
    loadn r7, #0
    
    ; --- LISTA DE TUDO QUE FOR "Andável" (Whitelist) ---
    ; Se R5 for igual a qualquer um desses, pulamos para isWall
    loadn r0, #45
    cmp r5, r0
    jeq Walkable
    
    loadn r0, #15
    cmp r5, r0
    jeq Walkable
    
    loadn r0, #31
    cmp r5, r0
    jeq Walkable
    
    loadn r0, #19
    cmp r5, r0
    jeq Walkable
    
    loadn r0, #20
    cmp r5, r0
    jeq Walkable
    
    loadn r0, #21
    cmp r5, r0
    jeq Walkable
    
    loadn r0, #83
    cmp r5, r0
    jeq Walkable

    loadn r0, #45
    cmp r5, r0
    jeq Walkable
    
    loadn r0, #33
    cmp r5, r0
    jeq Walkable
    
    loadn r0, #43
    cmp r5, r0
    jeq Walkable
    
    loadn r0, #46
    cmp r5, r0
    jeq Walkable
    
    ; ... adicione mais IDs de parede aqui se necessário ...
    
    ; Se o código chegou aqui, não é nenhuma das paredes listadas.
    ; O movimento é VÁLIDO, e R7 já está como 1.
    jmp Exit_Walkable
    
Walkable:
    loadn r7,#1
Exit_Walkable:
    pop r5
    pop r0
    rts


 ; ---------------------------------------------------------------------
; CarregaMapaParaBuffer
; Copia o conteúdo de R0 (ponteiro do levelX) para o MapBuffer
; ---------------------------------------------------------------------
CarregaMapaParaBuffer:
    push r0 ; Endereço do level original (ROM)
    push r1 ; Endereço do Buffer (RAM)
    push r2 ; Contador
    push r3 ; Limite
    push r4 ; Valor

    loadn r1, #MapBuffer
    loadn r2, #0
    loadn r3, #1200
    
Cpy_loop:
    cmp r2, r3
    jeq Copy_end
    
    loadi r4, r0    ; Lê da ROM (LevelX)
    storei r1, r4   ; Grava na RAM (Buffer)
    
    inc r0
    inc r1
    inc r2
    jmp Cpy_loop
    
Copy_end:
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; ---------------------------------------------------------------------
; GetBaseID
; Remove a informação de cor do caractere em R5.
; Entrada: R5 (ID completo com cor)
; Saída: R5 (Apenas o ID do caractere 0-255)
; ---------------------------------------------------------------------
GetBaseID:
    push r1
    loadn r1, #256
    mod r5, r5, r1 ; Resto da divisão por 256 remove os bits de cor
    pop r1
    rts

GetMoedasNivelAtual:
    ; Carrega em max_pontos o número de moedas do nível atual
    push r0
    push r1

    load r0, nivel_atual
    
    loadn r1, #1
    cmp r0, r1
    jne GetMoedas_Level2
    load r1, moedas_lvl1
    store max_pontos, r1
    load  r1, min_moedas_lvl1
    store min_moedas, r1
    jmp GetMoedas_Fim
    
GetMoedas_Level2:
    loadn r1, #2
    cmp r0, r1
    jne GetMoedas_Level3
    load r1, moedas_lvl2
    store max_pontos, r1
    load  r1, min_moedas_lvl2
    store min_moedas, r1
    jmp GetMoedas_Fim
    
GetMoedas_Level3:
    loadn r1, #3
    cmp r0, r1
    jne GetMoedas_Level4
    load r1, moedas_lvl3
    store max_pontos, r1
    load  r1, min_moedas_lvl3
    store min_moedas, r1
    jmp GetMoedas_Fim
    
GetMoedas_Level4:
    load r1, moedas_lvl4
    store max_pontos, r1
    load  r1, min_moedas_lvl4
    store min_moedas, r1
    
    
GetMoedas_Fim:
    pop r1
    pop r0
    rts    

; ---------------------------------------------------------------------
; CheckEatItems
; Checa se o carrinho está sobre algum item coletável e o "come".
; Usa: pos_ladrao (novo), ladraoGapsPtr (novo)
;(SISTEMA DE BÔNUS E DIAMANTE)
; ---------------------------------------------------------------------
; ---------------------------------------------------------------------
; CheckEatItems (CORRIGIDA)
; ---------------------------------------------------------------------
CheckEatItems:
    push r0 ; &MapBuffer
    push r1 ; bonus / temp
    push r2 ; loop i
    push r3 ; max 6
    push r4 ; pos_ladrao / steps
    push r5 ; offset / acumulador
    push r6 ; posicao na tela
    push r7 ; ID do tile / pontos
    ; r8 é usado como variável estática, não precisa de push/pop
    
    load r4, pos_ladrao      
    load r1, ladraoGapsPtr   
    loadn r0, #MapBuffer
    loadn r3, #6
    loadn r2, #0             
    
eat_loop:
    add r5, r1, r2           
    loadi r5, r5             
    add r6, r4, r5           ; R6 = Posição na tela
    
    add r5, r0, r6           ; R5 = Endereço no MapBuffer
    store r8, r5             ; Salva endereço em R8
    loadi r7, r5             ; R7 = Conteúdo

    ; --- REMOVE A COR PARA CHECAGEM ---
    push r1
    loadn r1, #255
    and r7, r7, r1           ; R7 = ID Base
    pop r1
     
    push r0
    push r1
    push r2
    
    ; --- CHECAGEM DE ITENS ---
    ; Diamante 
    loadn r5, #20
    cmp r7, r5
    jeq Comer_Diamante

    ;Função da arma
    loadn r5, #21
    cmp r7, r5
    jeq Comer_Congelante

    ;Coração para acréscimo de vida
    loadn r5, #46
    cmp r7, r5
    jeq Comer_Coracao    
    
    ;Teletransporte
    loadn r5, #43
    cmp r7, r5
    jeq Comer_Teletransporte
    ; Moedas
    loadn r5, #19
    cmp r7, r5
    jeq Comer_Moeda
    loadn r5, #33
    cmp r7, r5
    jeq Comer_Moeda

    
    jmp next_eat_check

Comer_Teletransporte:
    ; Apenas chama a função de teletransporte.
    ; A função vai retornar em R7: 
    ; 1 = Confirmou (Moveu e gastou o item)
    ; 0 = Cancelou (Volta tudo e mantem o item)
    
    call ExecutaTeletransporte
    
    loadn r0, #1
    cmp r7, r0
    jne Pula_Apagar_Item_Tele ; Se R7 != 1 (Cancelou), não apaga o item
    
    ; --- SE CONFIRMOU (R7 == 1) ---
    ; Agora sim, apagamos o item da memória e da tela definitivamente
    load r5, r8        ; Endereço salvo no início do loop (MapBuffer)
    loadn r7, #31      ; Espaço vazio
    storei r5, r7      ; Apaga da RAM
    outchar r7, r6     ; Apaga da Tela (R6 é a posição na tela calculada no loop)
    
    ; Incrementa contador de itens se necessário
    load r5, itens_coletados 
    inc r5
    store itens_coletados, r5
    call AtualizaHUD
    
Pula_Apagar_Item_Tele:
    jmp next_eat_check
    
Comer_Coracao:
    ; 1. Incrementa a vida (Lógica de Jogo)
    load r1, vidas
    inc r1
    store vidas, r1
    
    call AtualizaHUD 

    ; 3. LÓGICA DE PERSISTÊNCIA: Apagar o item do mapa ORIGINAL (levelX)
    ; O registrador R6 contém o offset (posição linear) do item que acabamos de pegar
    push r0
    push r1
    push r2
    push r3

    load r1, nivel_atual
    
    ; Seleciona o endereço base do nível atual
    loadn r2, #1
    cmp r1, r2
    jeq Coracao_Level1
    
    loadn r2, #2
    cmp r1, r2
    jeq Coracao_Level2
    
    loadn r2, #3
    cmp r1, r2
    jeq Coracao_Level3
    
    loadn r2, #4
    cmp r1, r2
    jeq Coracao_Level4
    
    jmp Coracao_Fim_Persistencia ; Segurança caso nível inválido

Coracao_Level1:
    loadn r3, #level1
    jmp Apaga_Na_Fonte
Coracao_Level2:
    loadn r3, #level2 ; Certifique-se que a label level2 existe no seu código
    jmp Apaga_Na_Fonte
Coracao_Level3:
    loadn r3, #level3
    jmp Apaga_Na_Fonte
Coracao_Level4:
    loadn r3, #level4
    jmp Apaga_Na_Fonte

Apaga_Na_Fonte:
    ; R3 = Endereço Base do Nível Original
    ; R6 = Offset do item (já calculado em CheckEatItems)
    add r3, r3, r6      ; R3 agora aponta para o endereço exato na ROM/Var estática
    loadn r2, #31       ; Carrega código do Espaço em Branco (#31 ou o que usar para vazio)
    storei r3, r2       ; ESMAGA o coração no mapa original com um espaço vazio

Coracao_Fim_Persistencia:
    pop r3
    pop r2
    pop r1
    pop r0

    ; Pula para finalizar (apagar da tela e buffer atual)
    jmp Finaliza_Comer
    
Comer_Diamante:
    load r1, bonus
    loadn r5, #5       ; Valor do diamante
    mul r5, r5, r1     ; Pontos = Valor * Bonus
    load r7, pontos
    add r7, r7, r5
    store pontos, r7
    jmp Finaliza_Comer

Comer_Congelante:

    load r5, itens_coletados 
    inc r5
    store itens_coletados, r5
    
    load r5, r8        
    loadn r7, #31      ; Espaço vazio
    storei r5, r7      
    outchar r7, r6     
    ; SALVA REGISTRADORES CRÍTICOS
    push r0
    push r1
    push r2
    push r3
    push r4
    
    ; AGORA CHAMA A FUNÇÃO MÁGICA
    call CongelaJogo
    
    ; Restaura os REGISTRADORES
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0    
    jmp next_eat_check ; Continua checando outros itens ou sai
Comer_Moeda:
    ; SALVA O ESTADO DO LOOP ANTES DE IMPRIMIR

    
    loadn r1, #100
    load r7, pontos
    add r7, r7, r1     ; Pontos += Bonus
    store pontos, r7
    
    ; Atualiza Bonus
    load r4, steps
    loadn r5, #3
    mod r4, r4, r5 ; Aumento = nºde passsos % 3 (resto da divisão por 3)   
    loadn r2, #0
    cmp r2,r4
    jne continua_comer
    loadn r4,#50
    loadn r1,#1
    continua_comer:
        mul r4, r4, r1 ; Aumento = 100 * resto (0,1,2)   
        store bonus, r4    


Finaliza_Comer:
    ; Apaga do Buffer e Tela
    load r5, r8        ; Recupera endereço do MapBuffer
    loadn r7, #31      ; Espaço vazio
    storei r5, r7      ; Limpa RAM
    outchar r7, r6     ; Limpa Tela
    
    ; Contabiliza
    load r5, itens_coletados 
    inc r5
    store itens_coletados, r5
    
    call AtualizaHUD
    
    ; --- CHECA LIBERAÇÃO DA SAÍDA ---
    ; Primeiro, verifica se JÁ estava liberada para não spammar
    load r1, saida_liberada
    loadn r7, #1
    cmp r1, r7
    jeq next_eat_check ; Já liberou, segue a vida

    ; Se não liberou, verifica se atingiu a meta
    call GetMoedasNivelAtual
    load r1, min_moedas
    cmp r5, r1
    jle next_eat_check ; Se Coletados (r5) < Min (r1), continua (jle ou jlt dependendo da logica)
    

    ; Libera Saída
    loadn r1, #1
    store saida_liberada, r1
    
    ; Mostra mensagem (APENAS UMA VEZ)
    loadn r0, #str_saida
    loadn r1, #84
    loadn r2, #2816
    call ImprimeString


    ; Não fazemos call delay nem check de tecla aqui! Isso fica no main.
    
next_eat_check:
    pop r2
    pop r1
    pop r0
    inc r2
    cmp r2, r3
    jne eat_loop
    
eat_loop_end:
    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts


; ---------------------------------------------------------
; ExecutaTeletransporte (CORRIGIDA: FÍSICA + VISUAL)
; Retorna R7: 1 (Confirmou), 0 (Cancelou)
; ---------------------------------------------------------
ExecutaTeletransporte:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    ; R7 é retorno

    ; Avisa o jogador
    loadn r0, #str_teleport
    loadn r1, #42
    loadn r2, #2816 ; Amarelo
    call ImprimeString

    load r0, dir_ladrao
    store teleport_backup_dir, r0 
    ; --- 1. SALVA ESTADO INICIAL (BACKUP) ---
    load r0, pos_ladrao
    store teleport_backup_pos, r0
    
    load r0, ladraoSprite
    store teleport_backup_sprite, r0
    
    load r0, ladraoGapsPtr
    store teleport_backup_gap, r0
    
    ; --- 2. SINCRONIZAÇÃO INICIAL ---
    ; Garante que o apagarladrao vai funcionar na primeira iteração
    load r0, pos_ladrao
    store pos_ant_ladrao, r0
    load r0, ladraoGapsPtr
    store ladraoGapsPtr_ant, r0


Loop_Teleport:
    call delay_teleport

    load r1, tecla_atual
    loadn r2, #255
    cmp r1, r2
    jeq Loop_Teleport 

    ; --- CONFIRMAÇÃO (ESPAÇO) ---
    loadn r2, #32 
    cmp r1, r2
    jeq Teleport_Confirmado

    ; --- CANCELAMENTO (X) ---
    loadn r2, #'x'
    cmp r1, r2
    jeq Teleport_Cancelado

    ; --- MOVIMENTAÇÃO INTELIGENTE ---
    ; R0 = Pos Candidata, R3 = Sprite, R4 = Gaps, R5 = Nova Direção
    load r0, pos_ladrao       
    
    loadn r2, #'w'
    cmp r1, r2
    jeq Tenta_Mov_W
    loadn r2, #'a'
    cmp r1, r2
    jeq Tenta_Mov_A
    loadn r2, #'s'
    cmp r1, r2
    jeq Tenta_Mov_S
    loadn r2, #'d'
    cmp r1, r2
    jeq Tenta_Mov_D
    
    jmp Loop_Teleport

; --- CONFIGURAÇÃO DOS CANDIDATOS ---
Tenta_Mov_W:
    loadn r3, #ladrao_U       ; Sprite Cima
    loadn r4, #ladraoGaps_V   ; Gap Vertical
    loadn r5, #'w'            ; Nova Direção
    
    ; Tenta Direto
    loadn r2, #40
    sub r6, r0, r2            ; R6 = Candidato Principal
    call Valida_Tele_Move     ; R7=1 se ok
    loadn r2, #1
    cmp r7, r2
    jeq Aplica_Tele_Move
    
    ; Tenta Assistência (Esquerda -1)
    loadn r2, #1
    sub r6, r6, r2
    call Valida_Tele_Move
    loadn r2, #1
    cmp r7, r2
    jeq Aplica_Tele_Move
    
    ; Tenta Assistência (Direita +1 -> recupera e soma 2)
    loadn r2, #2
    add r6, r6, r2
    call Valida_Tele_Move
    loadn r2, #1
    cmp r7, r2
    jeq Aplica_Tele_Move
    jmp Loop_Teleport

Tenta_Mov_S:
    loadn r2, #ladrao_D       ; Sprite Baixo (Cuidado: verifique se ladrao_D é ponteiro ou valor direto no seu codigo)
    mov r3, r2
    loadn r4, #ladraoGaps_V   ; Gap Vertical
    loadn r5, #'s'
    
    ; Tenta Direto
    loadn r2, #40
    add r6, r0, r2
    call Valida_Tele_Move
    loadn r2, #1
    cmp r7, r2
    jeq Aplica_Tele_Move
    
    ; Assistencia Esq
    loadn r2, #1
    sub r6, r6, r2
    call Valida_Tele_Move
    loadn r2, #1
    cmp r7, r2
    jeq Aplica_Tele_Move
    
    ; Assistencia Dir
    loadn r2, #2
    add r6, r6, r2
    call Valida_Tele_Move
    loadn r2, #1
    cmp r7, r2
    jeq Aplica_Tele_Move
    jmp Loop_Teleport

Tenta_Mov_A:
    loadn r3, #ladrao_L
    loadn r4, #ladraoGaps_H
    loadn r5, #'a'
    
    ; Direto
    loadn r2, #1
    sub r6, r0, r2
    call Valida_Tele_Move
    loadn r2, #1
    cmp r7, r2
    jeq Aplica_Tele_Move
    
    ; Assistencia Cima (-40)
    loadn r2, #40
    sub r6, r6, r2
    call Valida_Tele_Move
    loadn r2, #1
    cmp r7, r2
    jeq Aplica_Tele_Move
    
    ; Assistencia Baixo (+80 -> recupera e soma 2*40)
    loadn r2, #80
    add r6, r6, r2
    call Valida_Tele_Move
    loadn r2, #1
    cmp r7, r2
    jeq Aplica_Tele_Move
    jmp Loop_Teleport

Tenta_Mov_D:
    loadn r3, #ladrao_R
    loadn r4, #ladraoGaps_H
    loadn r5, #'d'
    
    ; Direto
    loadn r2, #1
    add r6, r0, r2
    call Valida_Tele_Move
    loadn r2, #1
    cmp r7, r2
    jeq Aplica_Tele_Move
    
    ; Assistencia Cima
    loadn r2, #40
    sub r6, r6, r2
    call Valida_Tele_Move
    loadn r2, #1
    cmp r7, r2
    jeq Aplica_Tele_Move
    
    ; Assistencia Baixo
    loadn r2, #80
    add r6, r6, r2
    call Valida_Tele_Move
    loadn r2, #1
    cmp r7, r2
    jeq Aplica_Tele_Move
    jmp Loop_Teleport


; --- APLICAÇÃO DO MOVIMENTO ---
Aplica_Tele_Move:
    ; R6 = Nova Posição Confirmada
    ; R3 = Novo Sprite
    ; R4 = Novo Gap
    ; R5 = Nova Direção

    ; 1. Apaga Ladrão na Posição ANTIGA (usando as vars globais atuais)
    ; Como pos_ant_ladrao foi sincronizada no fim do ultimo loop, isso apaga corretamente.

    call apagarladrao
    
    ; 2. Atualiza Variáveis Globais
    store pos_ladrao, r6
    store ladraoSprite, r3
    store ladraoGapsPtr, r4
    store dir_ladrao, r5      ;
    
    ; 3. Desenha na NOVA posição
    mov r0, r3 ; Sprite
    mov r1, r4 ; Gap
    mov r2, r6 ; Pos
    call printladrao
    
    ; 4. Sincroniza _ant para o próximo ciclo
    ; Se o jogador apertar outra tecla, o apagarladrao vai usar estes valores
    store pos_ant_ladrao, r6
    store ladraoGapsPtr_ant, r4
    
    ; 5. Limpa Tecla e Repete
    loadn r1, #255
    store tecla_atual, r1
    jmp Loop_Teleport


Teleport_Confirmado:
    loadn r7, #1
    jmp Sai_Teleport

Teleport_Cancelado:
    ; Apaga o fantasma atual
    call apagarladrao
    
    ; Restaura Backup
    load r0, teleport_backup_pos
    store pos_ladrao, r0
    store pos_ant_ladrao, r0
    
    load r0, teleport_backup_sprite
    store ladraoSprite, r0
    
    load r0, teleport_backup_gap
    store ladraoGapsPtr, r0
    store ladraoGapsPtr_ant, r0
    
    ; Redesenha original
    load r0, ladraoSprite
    load r1, ladraoGapsPtr
    load r2, pos_ladrao
    call printladrao
    
    loadn r7, #0
    jmp Sai_Teleport

Sai_Teleport:
    ; Limpa HUD
    loadn r0, #str_clear
    loadn r1, #42
    loadn r2, #0
    call ImprimeString
    
    loadn r1, #255
    store tecla_atual, r1
    
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; --- SUBROTINA AUXILIAR: Valida Movimento ---
; Entrada: R6 (Pos Candidata), R4 (Gap Candidato)
; Saída: R7 (1=Ok, 0=Erro)
Valida_Tele_Move:
    push r0
    push r2
    
    ; 1. Limite Superior e Esquerdo (Safety Margin)
    loadn r2, #0
    cmp r6, r2
    jle VTM_Fail
    
    ; 2. Limite Inferior e Direito (CRÍTICO PARA O ERRO)
    ; O carro tem tamanho. Se pos > 1150, o corpo vai vazar para > 1200
    loadn r2, #1150   ; Margem de segurança (1200 - 1 linha - margem)
    cmp r6, r2
    jgr VTM_Fail

    ; Paredes (CheckMoveValido)
    ; CheckMoveValido espera: R0=Pos, R2=Gap
    mov r0, r6
    mov r2, r4
    call CheckMoveValido ; Retorna R7=1 se livre
    
    ; Se CheckMoveValido retornou 0, falhou
    loadn r2, #0
    cmp r7, r2
    jeq VTM_Fail
    
    ; (Opcional) Checa colisão com policia aqui se quiser evitar TP em cima
    
    loadn r7, #1
    jmp VTM_End
    
VTM_Fail:
    loadn r7, #0
VTM_End:
    pop r2
    pop r0
    rts
    
; Delay curto especifico para menus/teleporte
delay_teleport:
    push r0
    push r1
    loadn r0, #10
dt_loop1:
    loadn r1, #1000
dt_loop2:
    dec r1
    jnz dt_loop2
    dec r0
    jnz dt_loop1
    
    ; Leitura de tecla não bloqueante dentro do delay
    inchar r0
    loadn r1, #255
    cmp r0, r1
    jeq dt_fim
    store tecla_atual, r0
dt_fim:
    pop r1
    pop r0
    rts

;Funcao de congelar o jogo para matar o policial
CongelaJogo:
    push r0
    push r1
    push r2
    push r3
    push r4

    ; --- SELEÇÃO DA MENSAGEM ---
    load r3, nivel_atual    ; Carrega o nível atual para R3
    
    loadn r4, #1
    cmp r3, r4
    jeq Prep_Msg1           ; Se nivel == 1, carrega string 1
    
    loadn r4, #2
    cmp r3, r4
    jeq Prep_Msg2           ; Se nivel == 2, carrega string 2
    
    loadn r4, #3
    cmp r3, r4
    jeq Prep_Msg3           ; Se nivel == 3, carrega string 3
    
    ; Se chegou aqui, é nivel 4
    loadn r0, #str_freeze_lvl4
    jmp Imprime_Freeze

Prep_Msg1:
    loadn r0, #str_freeze_lvl1
    jmp Imprime_Freeze
Prep_Msg2:
    loadn r0, #str_freeze_lvl2
    jmp Imprime_Freeze
Prep_Msg3:
    loadn r0, #str_freeze_lvl3
    jmp Imprime_Freeze

Imprime_Freeze:
    loadn r1, #42       ; Posição na tela
    loadn r2, #2816     ; Cor Amarela
    call ImprimeString

    ; --- LOOP DE ESPERA E VALIDAÇÃO ---
LoopCongela:
    inchar r0
    loadn r1, #255
    cmp r0, r1
    jeq LoopCongela     ; Nenhuma tecla apertada

    ; --- VERIFICAÇÃO DAS TECLAS ---
    
    ; Tecla '1' (Sempre válida em todos os níveis)
    loadn r1, #'1'
    cmp r0, r1
    jeq MatarP0

    ; Tecla '2' (Só aceita se Nivel >= 2)
    loadn r1, #'2'
    cmp r0, r1
    jeq TentaMatarP1
    
    ; Tecla '3' (Só aceita se Nivel >= 3)
    loadn r1, #'3'
    cmp r0, r1
    jeq TentaMatarP2
    
    ; Tecla '4' (Só aceita se Nivel >= 4)
    loadn r1, #'4'
    cmp r0, r1
    jeq TentaMatarP3

    ; Tecla inválida, volta pro loop
    jmp LoopCongela

; --- VALIDAÇÕES DE NÍVEL ---
TentaMatarP1:
    load r3, nivel_atual
    loadn r4, #2
    cmp r3, r4
    jle LoopCongela     ; Se Nivel < 2, ignora tecla '2'
    jmp MatarP1

TentaMatarP2:
    load r3, nivel_atual
    loadn r4, #3
    cmp r3, r4
    jle LoopCongela     ; Se Nivel < 3, ignora tecla '3'
    jmp MatarP2

TentaMatarP3:
    load r3, nivel_atual
    loadn r4, #4
    cmp r3, r4
    jle LoopCongela     ; Se Nivel < 4, ignora tecla '4'
    jmp MatarP3

; --- EXECUÇÃO ---
MatarP0:
    loadn r0, #0
    jmp FinalizaCongelamento
MatarP1:
    loadn r0, #1
    jmp FinalizaCongelamento
MatarP2:
    loadn r0, #2
    jmp FinalizaCongelamento
MatarP3:
    loadn r0, #3
    jmp FinalizaCongelamento

FinalizaCongelamento:
    ; R0 já tem o índice correto vindo dos jumps anteriores
    call EliminaPolicialEspecifico
    

    loadn r0, #MapBuffer
    call printCenario   ; Redesenha o mapa limpo e correto
    
    call apagarladrao
    
    load r0, ladraoSprite
    load r1, ladraoGapsPtr
    load r2, pos_ladrao
    
    call printladrao

    ; Retorna o HUD normal
    call AtualizaHUD

    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

;EliminaPolicialEspecifico - mata o policial que o jogador escolheu
EliminaPolicialEspecifico:
    push r0
    push r1
    push r2
    
    store temp_indice, r0
    
    ; 1. Apaga o policial visualmente da posição atual
    call apagarpolicia
    
    ; 2. Joga ele para fora do mapa
    loadn r1, #1    ; diz que aquele policial está fora do jogo
    
    loadn r2, #morto_policia
    add r2, r2, r0
    storei r2, r1      
         
    
    pop r2
    pop r1
    pop r0
    rts


;Funcao de vitoria do nivel
VitoriaNivel:
    ;Passa para o próximo nível
    ; Incrementa o nível
    load r0, max_pontos
    load r1, itens_coletados
    jne continua
    load r0, pontos
    loadn r1, #3
    div r1,r0,r1
    add r0,r0,r1
    store pontos, r0
    load r0, Zerou
    inc r0
    store Zerou, r0
    
    continua:
    load r0, nivel_atual
    inc r0
    store nivel_atual, r0
    
    ; Verifica se completou todos os níveis
    loadn r1, #5  ; 4 níveis + 1
    cmp r0, r1
    jeq VitoriaFinal
    
    ; Reseta variáveis para o novo nível
    loadn r0, #0
    store itens_coletados, r0 
    store saida_liberada, r0
    
    ; Carrega as novas moedas necessárias
    call GetMoedasNivelAtual
    
    call just_wait
    ; Sai da função para recarregar o nível
    jmp ProximoNivel
    
VitoriaFinal:
    loadn r1, #255
    store tecla_atual, r1
    ; --- IMPRIME TELA DE VITÓRIA ---
    loadn R0, #WinScreen
    call printCenario
    
    ; --- IMPRIME O SCORE ---
    load r0, pontos
    loadn r1, #773 ; Posição ao lado de SCORE
    call ImprimeNumero
    
Wait_Win_Input:
    call delay
    load r0, tecla_atual

    ; Opção 1: ENTER -> HALT
    loadn r1, #13
    cmp r0, r1
    jeq Acabou
    
    ; Opção 2: X -> REINICIAR DO NIVEL 1 (SEM MENU/REGRAS)
    loadn r1, #'x'
    cmp r0, r1
    jeq Restart_Fast
    
    jmp Wait_Win_Input

Restart_Fast:
    ; Reinicializa variáveis
    call inicializa_var
    
    ; Força nível 1
    loadn r0, #1
    store nivel_atual, r0
    
    ; Pula direto para o carregamento do cenário, ignorando loop_ini
    jmp round_game
    
ProximoNivel:    
    
    jmp round_game  ; Volta para recarregar o cenário



; --- Tenta Mover Horizontal (Direto ou Desvio Vertical) ---
Policia_Tenta_H:
    push r0
    push r5

    ; 1. Direto
    loadn r5, #policiaGaps_H
    call Policia_checkCenario
    load r0, ehParede
    loadn r5, #0
    cmp r0, r5
    jeq PTH_Ok

    ; 2. Cima (-40)
    push r4
    loadn r5, #40
    sub r4, r4, r5
    loadn r5, #policiaGaps_H
    call Policia_checkCenario
    load r0, ehParede
    loadn r5, #0
    cmp r0, r5
    jeq PTH_Ok_Pop
    pop r4

    ; 3. Baixo (+40)
    push r4
    loadn r5, #40
    add r4, r4, r5
    loadn r5, #policiaGaps_H
    call Policia_checkCenario
    load r0, ehParede
    loadn r5, #0
    cmp r0, r5
    jeq PTH_Ok_Pop
    pop r4
    
    ; Bloqueado
    loadn r0, #1
    store ehParede, r0
    jmp PTH_Fim

PTH_Ok_Pop:
    pop r5 ; descarta velho
PTH_Ok:
    loadn r0, #0
    store ehParede, r0
PTH_Fim:
    pop r5
    pop r0
    rts

; --- Tenta Mover Vertical (Direto ou Desvio Horizontal) ---
Policia_Tenta_V:
    push r0
    push r5

    ; 1. Direto
    loadn r5, #policiaGaps_V
    call Policia_checkCenario
    load r0, ehParede
    loadn r5, #0
    cmp r0, r5
    jeq PTV_Ok

    ; 2. Esquerda (-1)
    push r4
    loadn r5, #1
    sub r4, r4, r5
    loadn r5, #policiaGaps_V
    call Policia_checkCenario
    load r0, ehParede
    loadn r5, #0
    cmp r0, r5
    jeq PTV_Ok_Pop
    pop r4

    ; 3. Direita (+1)
    push r4
    loadn r5, #1
    add r4, r4, r5
    loadn r5, #policiaGaps_V
    call Policia_checkCenario
    load r0, ehParede
    loadn r5, #0
    cmp r0, r5
    jeq PTV_Ok_Pop
    pop r4
    
    ; Bloqueado
    loadn r0, #1
    store ehParede, r0
    jmp PTV_Fim

PTV_Ok_Pop:
    pop r5
PTV_Ok:
    loadn r0, #0
    store ehParede, r0
PTV_Fim:
    pop r5
    pop r0
    rts
    
; ==========================================================
; IA DE EQUIPE (CÉREBRO)
; ==========================================================

CalculaPosPolicia:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7
    
    load r0, temp_indice
    
    ; Carrega e Salva Estado Anterior
    loadn r1, #pos_policia
    add r1, r1, r0
    loadi r6, r1
    store pos_policiaant, r6
    
    loadn r1, #policia_dir
    add r1, r1, r0
    loadi r2, r1
    store dir_policiaant, r2
    
    call SelectTarget
    
    loadn r5, #40 
    
    ; --- ESQUERDA ('a') ---
Policia_CalculaPos_a: 
    mov r4, r6
    dec r4
    
    ; Tenta mover Horizontalmente (com Cornering)
    call Policia_Tenta_H  ; Retorna R4 válido ou ehParede=1
    
    load r1, ehParede
    loadn r2, #0
    cmp r1, r2
    jne Bloqueia_A
    
    store pos_policiaant_a, r4 ; Guarda pos real
    
    ; Calcula Custo
    loadn r5, #40
    mod r0, r4, r5
    div r1, r4, r5
    call calculaDistToTarget
    load r7, dist_dir
    call Soma_Custo_HeatMap ; R7 = R7 + Heat(R4)
    store dist_a, r7
    jmp Check_W

Bloqueia_A:
    loadn r7, #30000
    store dist_a, r7
    
    ; --- CIMA ('w') ---
Check_W:
    loadn r5, #40
    mov r4, r6
    sub r4, r4, r5
    
    call Policia_Tenta_V ; Cornering Vertical
    
    load r1, ehParede
    loadn r2, #0
    cmp r1, r2
    jne Bloqueia_W
    
    store pos_policiaant_w, r4
    
    loadn r5, #40
    mod r0, r4, r5
    div r1, r4, r5
    call calculaDistToTarget
    load r7, dist_dir
    call Soma_Custo_HeatMap ; R7 = R7 + Heat(R4)
    store dist_w, r7
    jmp Check_S

Bloqueia_W:
    loadn r7, #30000
    store dist_w, r7

    ; --- BAIXO ('s') ---
Check_S:
    loadn r5, #40
    mov r4, r6
    add r4, r4, r5
    
    call Policia_Tenta_V
    
    load r1, ehParede
    loadn r2, #0
    cmp r1, r2
    jne Bloqueia_S
    
    store pos_policiaant_s, r4
    
    loadn r5, #40
    mod r0, r4, r5
    div r1, r4, r5
    call calculaDistToTarget
    load r7, dist_dir
    call Soma_Custo_HeatMap ; R7 = R7 + Heat(R4)
    store dist_s, r7
    jmp Check_D

Bloqueia_S:
    loadn r7, #30000
    store dist_s, r7

    ; --- DIREITA ('d') ---
Check_D:
    mov r4, r6
    inc r4
    
    call Policia_Tenta_H
    
    load r1, ehParede
    loadn r2, #0
    cmp r1, r2
    jne Bloqueia_D
    
    store pos_policiaant_d, r4
    
    loadn r5, #40
    mod r0, r4, r5
    div r1, r4, r5
    call calculaDistToTarget
    load r7, dist_dir
    call Soma_Custo_HeatMap ; R7 = R7 + Heat(R4)
    store dist_d, r7
    jmp Decide_Dir

Bloqueia_D:
    loadn r7, #30000
    store dist_d, r7
    
Decide_Dir:
    call Aplica_Penalidade_Re_E_Detecta_Beco
    
    ; Algoritmo Guloso: Escolhe a menor distância calculada
    loadn r0, #'a'
    store dir_policiaant, r0
    load r1, pos_policiaant_a
    store pos_policiaant, r1
    load r2, dist_a
    
    load r3, dist_w
    cmp r3, r2
    jgr Comp_S
    loadn r0, #'w'
    store dir_policiaant, r0
    load r1, pos_policiaant_w
    store pos_policiaant, r1
    mov r2, r3
    
Comp_S:
    load r3, dist_s
    cmp r3, r2
    jgr Comp_D
    loadn r0, #'s'
    store dir_policiaant, r0
    load r1, pos_policiaant_s
    store pos_policiaant, r1
    mov r2, r3
    
Comp_D:
    load r3, dist_d
    cmp r3, r2
    jgr Aplica_Movimento
    loadn r0, #'d'
    store dir_policiaant, r0
    load r1, pos_policiaant_d
    store pos_policiaant, r1
    
Aplica_Movimento:
    loadn r3, #30000
    cmp r2, r3
    jeq Fim_CalculaPosPolicia ; Preso, não move
    
    ; 1. Apaga na posição velha
    call apagarpolicia
    
    ; 2. Atualiza Vetores
    load r0, temp_indice
    load r1, pos_policiaant
    loadn r2, #pos_policia
    add r2, r2, r0
    storei r2, r1
    
    ; --- NOVO: MARCA NO HEATMAP ---
    ; R1 tem a nova posição linear do policial (pos_policia)
    
    loadn r2, #HeatMap
    add r2, r2, r1      ; Endereço no HeatMap correspondente à posição
    loadn r3, #50       
    storei r2, r3
    ; ------------------------------
    
    load r1, dir_policiaant
    loadn r2, #policia_dir
    add r2, r2, r0
    storei r2, r1
    
    ; 3. Define Sprite e Gaps
    loadn r3, #'a'
    cmp r1, r3
    jne Set_W
    loadn r5, #policia_L
    loadn r6, #policiaGaps_H
    jmp Store_Sprite
Set_W:
    loadn r3, #'w'
    cmp r1, r3
    jne Set_S
    loadn r5, #policia_U
    loadn r6, #policiaGaps_V
    jmp Store_Sprite
Set_S:
    loadn r3, #'s'
    cmp r1, r3
    jne Set_D
    loadn r5, #policia_D
    loadn r6, #policiaGaps_V
    jmp Store_Sprite
Set_D:
    loadn r5, #policia_R
    loadn r6, #policiaGaps_H

Store_Sprite:
    loadn r2, #policia_sprite
    add r2, r2, r0
    storei r2, r5
    
    loadn r2, #policia_gaps
    add r2, r2, r0
    storei r2, r6
    
    ; 4. Desenha na Nova Posição
    mov r0, r5 ; sprite
    mov r1, r6 ; gaps
    load r2, pos_policiaant ; pos
    call printladrao
    
Fim_CalculaPosPolicia:
    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts


; ==========================================================
; NOVAS FUNÇÕES AUXILIARES (HEATMAP & BECO)
; ==========================================================

; Soma o valor do HeatMap ao custo atual em R7
; Entrada: R4 (Posição), R7 (Custo atual)
; Saída: R7 (Custo atualizado)
Soma_Custo_HeatMap:
    push r0
    push r1
    
    loadn r0, #HeatMap
    add r0, r0, r4      ; Endereço
    loadi r0, r0        ; Valor do calor (0 a 255)
    
    ; Multiplica calor para ter peso (ex: * 10)
    loadn r1, #10
    mul r0, r0, r1
    
    add r7, r7, r0      ; Soma ao custo
    
    pop r1
    pop r0
    rts

; Aplica penalidade na direção oposta e detecta se é um beco
Aplica_Penalidade_Re_E_Detecta_Beco:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r7 ; Limite parede
    
    load r0, dir_policiaant ; Direção que eu vim
    loadn r1, #20000        ; Custo de Ré (Penalidade)
    loadn r7, #30000        ; Custo de Parede

    ; Verifica qual é a ré e aplica penalidade
    ; Se a ré for aplicada, verifica se AS OUTRAS 3 são parede.
    ; Se forem, estamos num beco.

    loadn r2, #'a'
    cmp r0, r2
    jne Pcd_W
    ; Vinha da Esquerda -> Ré é Direita ('d')
    load r3, dist_d
    cmp r3, r7
    jeq Pcd_Fim ; Se ré já é parede, nada a fazer
    store dist_d, r1 ; Aplica penalidade na ré
    ; Checa Beco: Se A, W, S são paredes e D é a única saida
    call Checa_Se_Beco
    jmp Pcd_Fim

Pcd_W:
    loadn r2, #'w'
    cmp r0, r2
    jne Pcd_S
    ; Vinha de Cima -> Ré é Baixo ('s')
    load r3, dist_s
    cmp r3, r7
    jeq Pcd_Fim
    store dist_s, r1
    call Checa_Se_Beco
    jmp Pcd_Fim

Pcd_S:
    loadn r2, #'s'
    cmp r0, r2
    jne Pcd_D
    ; Vinha de Baixo -> Ré é Cima ('w')
    load r3, dist_w
    cmp r3, r7
    jeq Pcd_Fim
    store dist_w, r1
    call Checa_Se_Beco
    jmp Pcd_Fim

Pcd_D:
    ; Vinha da Direita -> Ré é Esquerda ('a')
    load r3, dist_a
    cmp r3, r7
    jeq Pcd_Fim
    store dist_a, r1
    call Checa_Se_Beco

Pcd_Fim:
    pop r7
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; Verifica se 3 lados são parede (30000). Se sim, marca o chão atual como "FOGO"
Checa_Se_Beco:
    push r0
    push r1
    push r2
    push r3
    
    loadn r0, #0     ; Contador de Paredes
    loadn r1, #30000
    
    load r2, dist_a
    cmp r2, r1
    jne Count_W
    inc r0
Count_W:
    load r2, dist_w
    cmp r2, r1
    jne Count_S
    inc r0
Count_S:
    load r2, dist_s
    cmp r2, r1
    jne Count_D
    inc r0
Count_D:
    load r2, dist_d
    cmp r2, r1
    jne Check_Count
    inc r0
    
Check_Count:
    ; Se tiver 3 paredes, é um beco sem saída (Cul-de-sac)
    loadn r1, #3
    cmp r0, r1
    jne Not_Beco
    
    ; É BECO! Marca o chão atual com calor MÁXIMO para evitar voltar aqui
    load r0, pos_policiaant ; Posição atual (fundo do beco)
    loadn r1, #HeatMap
    add r1, r1, r0
    loadn r2, #255 ; Calor Máximo (Lava)
    storei r1, r2
    
Not_Beco:
    pop r3
    pop r2
    pop r1
    pop r0
    rts


; ------------------------------------------------
; SELEÇÃO DE ALVO (TÁTICAS DE EQUIPE)
; ------------------------------------------------
SelectTarget:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    
    load r0, temp_indice
    loadn r5, #40 ; Largura

    ; Switch Case para o Índice da Polícia
    loadn r1, #0
    cmp r0, r1
    jeq Target_Carro0
    
    loadn r1, #1
    cmp r0, r1
    jeq Target_Carro1
    
    loadn r1, #2
    cmp r0, r1
    jeq Target_Carro2
    
    loadn r1, #3
    cmp r0, r1
    jeq Target_Carro3
    
    jmp Target_Default ; Fallback

Target_Carro0:

    ; === CARRO 0 (BLINKY) ===
    ; Alvo: Posição Exata do Ladrão
    load r1, pos_ladrao
    
    ; Converte para X,Y para consistência
    mod r2, r1, r5 ; x
    div r3, r1, r5 ; y
    store x_target, r2
    store y_target, r3
    loadn r1, #1
    store target_eh_xy, r1
    jmp End_SelectTarget

Target_Carro1:

    ; === CARRO 1 (PINKY) ===
    ; Alvo: 2 Posições À FRENTE do Ladrão
    
    ; Pega X,Y do ladrão
    load r1, pos_ladrao
    mod r2, r1, r5 ; x
    div r3, r1, r5 ; y
    
    load r4, dir_ladrao
    
    ; Aplica Offset baseado na direção
    loadn r1, #'a'
    cmp r4, r1
    jne T1_TryW
    loadn r1, #2
    sub r2, r2, r1 ; x - 2
    jmp T1_Save
T1_TryW:
    loadn r1, #'w'
    cmp r4, r1
    jne T1_TryS
    loadn r1, #2
    sub r3, r3, r1 ; y - 2
    jmp T1_Save
T1_TryS:
    loadn r1, #'s'
    cmp r4, r1
    jne T1_TryD
    loadn r1, #2
    add r3, r3, r1 ; y + 2
    jmp T1_Save
T1_TryD:
    ; Default ou 'd'
    loadn r1, #2
    add r2, r2, r1 ; x + 2

T1_Save:
    store x_target, r2
    store y_target, r3
    loadn r1, #1
    store target_eh_xy, r1
    
    ; Salva este alvo para o Carro 3 usar!
    ; (Reconverte para linear só para guardar em target_carro1 se precisar, 
    ; mas vamos guardar X e Y em variaveis auxiliares se precisasse. 
    ; Aqui vamos recalcular no Carro 3 para garantir)
    ; Para simplificar a comunicação, vou salvar o alvo linear em target_carro1
    ; alvo = y*40 + x
    mul r1, r3, r5
    add r1, r1, r2
    store target_carro1, r1
    
    jmp End_SelectTarget

Target_Carro2:
    ; === CARRO 3 (INKY/BLUE) - ESTRATÉGIA: O ESPELHO ===
    ; Tática: Cercar o jogador indo para a coordenada X oposta.
    ; Isso força o jogador a mudar de linha ou ser encurralado.
    
    ; 1. Pega a posição do ladrão
    load r1, pos_ladrao
    
    ; 2. Converte para X e Y
    ; R5 já contém 40 (carregado no início da função SelectTarget)
    mod r2, r1, r5      ; r2 = X do Ladrão
    div r3, r1, r5      ; r3 = Y do Ladrão
    
    ; 3. Calcula o X Espelhado (Target X = 39 - Ladrao X)
    ; Como a tela tem largura 40 (0 a 39), isso inverte o lado.
    loadn r4, #39
    
    ; Verifica segurança para não subtrair se r2 > 39 (bug prevention)
    cmp r2, r4
    jgr T2_Failsafe     ; Se X > 39, usa fallback
    
    sub r0, r4, r2      ; r0 = 39 - X_Ladrao
    
    ; 4. Define os Alvos
    store x_target, r0  ; Alvo X invertido
    store y_target, r3  ; Alvo Y igual ao do ladrão
    
    ; 5. Ativa flag para a IA saber que estamos usando X,Y e não pos linear
    loadn r1, #1
    store target_eh_xy, r1
    
    jmp End_SelectTarget

T2_Failsafe:
    ; Se houver algum erro de cálculo, persegue o ladrão normalmente
    loadn r0, #0
    store target_eh_xy, r0
    store pos_target, r1 ; r1 ainda tem pos_ladrao
    jmp End_SelectTarget

Target_Carro3:
    
    ; === CARRO 3 (INKY/BLUE) ===
    ; Alvo: Vetor baseado no Carro 0 e Alvo do Carro 1
    ; Fórmula: Target = Pivot + 2 * (Ref - Pivot)
    ; Simplificado: Target = 2*Ref - Pivot
    ; Onde Ref = Alvo do Carro 1 (target_carro1)
    ; Onde Pivot = Posição do Carro 0 (Líder)
    
    ; Pega Posição Carro 0 (Pivot)
    loadn r1, #pos_policia
    loadn r2, #0
    add r1, r1, r2
    loadi r1, r1 ; pos linear carro 0
    
    mod r2, r1, r5 ; Px (Pivot X)
    div r3, r1, r5 ; Py (Pivot Y)
    
    ; Pega Alvo Carro 1 (Ref) - Calculado anteriormente ou recalculado
    ; Vamos usar a var target_carro1 que salvamos no T1
    load r4, target_carro1
    mod r0, r4, r5 ; Rx (Ref X)
    div r1, r4, r5 ; Ry (Ref Y)
    
    ; Tx = 2*Rx - Px
    add r0, r0, r0 ; 2*Rx
    sub r0, r0, r2 ; - Px
    store x_target, r0
    
    ; Ty = 2*Ry - Py
    add r1, r1, r1 ; 2*Ry
    sub r1, r1, r3 ; - Py
    store y_target, r1
    
    loadn r1, #1
    store target_eh_xy, r1
    jmp End_SelectTarget

Target_Default:
    ; Fallback: Persegue ladrão
    load r1, pos_ladrao
    store pos_target, r1
    loadn r1, #0
    store target_eh_xy, r1

End_SelectTarget:
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts


; Calcula Distância MANHATTAN: |x1 - x2| + |y1 - y2|
; Entrada: R0,R1 (Candidato) | R2,R3 (Alvo) (ou usa globais)
; Saída: dist_dir
; ----------------------------------------------------------
calcula_MANHATTAN:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    
    ; Lógica para definir Alvo (se usa vars globais ou params)
    load r6, target_eh_xy
    loadn r5, #1
    cmp r6, r5
    jeq Dist_Use_XY_Manhattan
    
    ; Se não for XY, converte pos_target linear
    load r4, pos_target
    loadn r5, #40
    mod r2, r4, r5 ; x target
    div r3, r4, r5 ; y target
    jmp Calc_Manhattan

Dist_Use_XY_Manhattan:
    load r2, x_target
    load r3, y_target

Calc_Manhattan:
    ; Distância X = Abs(x_candidato - x_alvo)
    sub r4, r0, r2      
    loadn r6, #0
    cmp r4, r6
    jgr Calc_Diff_Y
    sub r4, r6, r4      ; Inverte se negativo (0 - x)

Calc_Diff_Y:
    ; Distância Y = Abs(y_candidato - y_alvo)
    sub r5, r1, r3
    cmp r5, r6
    jgr Final_Sum
    sub r5, r6, r5

Final_Sum:
    add r4, r4, r5      ; Soma Total
    store dist_dir, r4  
    
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
; ------------------------------------------------
; Calcula Distância (Suporta Coordenadas Negativas)
; ------------------------------------------------
calculaDistToTarget:
    push r2
    push r3
    push r4
    push r5
    push r6
    
    ; R0 = x candidato, R1 = y candidato
    
    ; Se flag XY ativa, usa vars, senao converte pos_target
    load r6, target_eh_xy
    loadn r5, #1
    cmp r6, r5
    jeq Dist_Use_XY
    
    ; Converte pos_target linear
    load r4, pos_target
    loadn r5, #40
    mod r2, r4, r5 ; x target
    div r3, r4, r5 ; y target
    jmp Dist_Calc_Start

Dist_Use_XY:
    load r2, x_target
    load r3, y_target

Dist_Calc_Start:
    ; dx = (x - x_t)
    sub r4, r0, r2
    
    ; Quadrado (r4 * r4) elimina sinal negativo
    mul r4, r4, r4
    
    ; dy = (y - y_t)
    sub r5, r1, r3
    mul r5, r5, r5
    
    add r4, r4, r5 ; dist^2
    store dist_dir, r4
    
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    rts


; Função genérica para apagar a polícia
apagarpolicia:
  push r0
  push r1
  push r2
  push r3
  push r4
  push r5
  push r6
  push r7
  
  loadn r0, #MapBuffer
  load r7, temp_indice ; Qual policial?
  
  ; Carrega Gaps Antigos do Array
  loadn r1, #policia_gaps_ant
  add r1, r1, r7
  loadi r1, r1
  
  ; Carrega Posição Antiga do Array
  loadn r2, #pos_ant_policia
  add r2, r2, r7
  loadi r2, r2
  
  loadn r3, #6
  loadn r4, #0
  
  apagarpoliciaLoop:
    add r5,r1,r4
    loadi r5, r5
    push r2 
    add r2,r2,r5
    add r6,r0,r2
    loadi r6, r6
    outchar r6, r2
    pop r2
    inc r4
    cmp r4, r3
    jne apagarpoliciaLoop


  pop r7
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0
  rts



; ---------------------------------------------------------------------
; CheckPlayerPoliceCollision (CORRIGIDA E COMPLETA)
; Checa colisão de TODOS os tiles do Ladrão com TODOS os tiles das Polícias
; ---------------------------------------------------------------------
CheckPlayerPoliceCollision:
    push r0 ; Indice Policia / Contador Player Tile
    push r1 ; Limite Policias / Contador Policia Tile
    push r2 ; Pos Policia Base
    push r3 ; Gaps Policia Ptr
    push r4 ; Pos Ladrao Base
    push r5 ; Gaps Ladrao Ptr
    push r6 ; Temp / Limite 6
    push r7 ; Pos Absoluta Ladrao Tile

    load r4, pos_ladrao
    load r5, ladraoGapsPtr
    
    loadn r0, #0           ; Índice Policia = 0
    load r1, total_policiasatv   ; Limite = Nível Atual

Loop_Police_List:
    cmp r0, r1
    jeq End_Check         ; Se checou todos os policiais ativos, sai

    ; --- VERIFICA SE ESTÁ MORTO ---
    loadn r2, #morto_policia
    add r2, r2, r0
    loadi r2, r2           ; R2 = Status (0=Vivo, 1=Morto)
    
    loadn r3, #1
    cmp r2, r3             ; Compara Status com 1 (Morto)
    jeq Next_Police        ; Se for 1 (Morto), PULA a verificação (não mata)
    
    ; --- Carrega dados da Polícia[i] ---
    loadn r2, #pos_policia
    add r2, r2, r0
    loadi r2, r2           ; R2 = Posição Base da Polícia
    
    loadn r3, #policia_gaps
    add r3, r3, r0
    loadi r3, r3           ; R3 = Ponteiro de Gaps da Polícia

    ; --- OTIMIZAÇÃO (Bounding Box Simples) ---
    ; Se estiverem muito longe (>80), nem checa os tiles
    push r4
    push r6
    sub r6, r4, r2         ; Delta = Ladrao - Policia
    ; Abs(Delta)
    loadn r7, #0
    cmp r6, r7
    jgr pos_diff_ok
    loadn r7, #0
    add r6, r7, r6
pos_diff_ok:
    loadn r7, #85
    cmp r6, r7
    pop r6
    pop r4
    jgr Next_Police       ; Longe demais, próxima polícia

    ; --- COLISÃO FINA (6x6 Tiles) ---
    ; Salva contadores do loop externo na pilha para usar R0 e R1
    push r0 
    push r1
    
    loadn r0, #0           ; i = 0 (Tile do Ladrão)
    
    Loop_Player_Tiles:
        loadn r6, #6
        cmp r0, r6
        jeq End_Player_Tiles ; Acabou tiles do ladrão?
        
        ; Calcula Posição Absoluta do Tile do Ladrão -> R7
        add r7, r5, r0     ; &ladraoGaps[i]
        loadi r7, r7       ; offset
        add r7, r7, r4     ; R7 = Pos Absoluta Ladrão

        loadn r1, #0       ; j = 0 (Tile da Polícia)
        
        Loop_Police_Tiles:
            cmp r1, r6
            jeq Next_P_Tile ; Acabou tiles dessa polícia?
            
            ; Calcula Posição Absoluta do Tile da Polícia -> R6
            ; (Reusamos R6 momentaneamente)
            add r6, r3, r1   ; &policiaGaps[j]
            loadi r6, r6     ; offset
            add r6, r6, r2   ; R6 = Pos Absoluta Polícia
            
            cmp r7, r6       ; BATEU? (Tile Ladrão == Tile Polícia)
            jeq Collision_Found
            
            inc r1
            loadn r6, #6     ; Restaura constante 6
            jmp Loop_Police_Tiles
            
    Next_P_Tile:
        inc r0
        jmp Loop_Player_Tiles

    End_Player_Tiles:
        ; Restaura contadores do loop externo
        pop r1
        pop r0
        
Next_Police:
    inc r0
    jmp Loop_Police_List

Collision_Found:
    ; Limpa a sujeira da pilha (os contadores r1, r0 do loop interno)
    pop r1
    pop r0
    jmp PerdeuVida

End_Check:
    jmp Collision_end

PerdeuVida:
    ; 1. Decrementa Vidas
    load r0, vidas
    dec r0
    store vidas, r0
    
    ; 2. Atualiza o HUD -> no main loop
    ;call AtualizaHUD 
    
    ; 3. Verifica se acabou (Vidas == 0)
    loadn r1, #0
    cmp r0, r1
    jeq GameOverReal

    
    jmp ResetRound_perdeu 
    
    
GameOverReal:
    ; Limpa a pilha (pop nos registradores que estavam salvos em CheckPlayerPoliceCollision)
    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0

    ; --- IMPRIME TELA DE DERROTA ---
    loadn R0, #LoseScreen
    call printCenario
    
    ; --- IMPRIME O SCORE ---
    load r0, pontos
    loadn r1, #773
    call ImprimeNumero

Wait_Lose_Input:
    call delay ; Usa delay para ler teclado
    load r0, tecla_atual
    
    ; Opção 1: PRESS ENTER TO QUIT
    loadn r1, #13 ; Enter
    cmp r0, r1
    jeq Acabou
    
    ; Opção 2: PRESS X TO PLAY AGAIN
    loadn r1, #'x'
    cmp r0, r1
    jeq Restart_Game_Full
    
    jmp Wait_Lose_Input

Restart_Game_Full:
    ; Reinicia o jogo do zero (passando pelo menu novamente)
    call inicializa_var
    jmp round_game
    
ResetRound_perdeu:
    loadn r1, #0
    store saida_liberada, r1
    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    jmp round_game
    
Collision_end:
    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
Acabou:
halt
; ---------------------------------------------------------------------
; ResetRound
; Retorna os carros para a posição inicial sem resetar pontos/mapa
; ---------------------------------------------------------------------
ResetRound:
    push r0

    
    call ResetPosicoesPorNivel

    
    ; Pequeno delay para o jogador perceber que morreu
    call delay
    call delay
    
    ; PENALIDADE DE MORTE: Reseta o Bônus e os Passos
    loadn r0, #50
    store bonus, r0
    loadn r0, #0
    store steps, r0
    store saida_liberada, r0
    
    pop r0
    rts

; ---------------------------------------------------------------------
; Policia_checkCenario (CORRIGIDA)
; Verifica se a posição R4 é válida para a polícia atual.
Policia_checkCenario:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7
    
    ; 1. VERIFICA COLISÃO COM OUTROS CARROS (NOVO!)
    ;call Check_Colisao_Entre_Policiais
    ;loadn r1, #1
    ;cmp r0, r1
    ;jeq Eh_Parede_Force ; Se bater em outro carro, trata como parede
    
    ; Verifica Paredes
    load r0, pos_policiaant
    mov r1, r0
    inc r1
    cmp r4, r1
    jeq Use_H_Gaps
    mov r1, r4
    inc r1
    cmp r0, r1
    jeq Use_H_Gaps
    
    loadn r5, #policiaGaps_V
    jmp Do_Check_Tiles
Use_H_Gaps:
    loadn r5, #policiaGaps_H

Do_Check_Tiles:
    loadn r1, #MapBuffer
    loadn r2, #6
    loadn r3, #0
Loop_Wall_Check:
    add r6, r5, r3
    loadi r6, r6 ; offset
    add r6, r4, r6 ; pos real
    
    loadn r7, #0
    cmp r6, r7
    jle Eh_Parede_Force
    loadn r7, #1200
    cmp r6, r7
    jgr Eh_Parede_Force
    
    add r6, r1, r6
    loadi r7, r6
    
    push r5
    mov r5, r7
    call IsTileWalkable
    mov r7, r7
    pop r5
    
    loadn r0, #0
    cmp r7, r0
    jeq Eh_Parede_Force
    
    inc r3
    cmp r3, r2
    jne Loop_Wall_Check
    
    loadn r0, #0
    store ehParede, r0
    jmp Fim_Check_Cenario

Eh_Parede_Force:
    loadn r0, #1
    store ehParede, r0

Fim_Check_Cenario:
    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

;---------------------------------------------------------------------
; AtualizaHUD
; Desenha "PTS: 000  VIDAS: corações" na linha 0 (topo da tela)
; ---------------------------------------------------------------------
AtualizaHUD:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    ; 1. Imprime "PTS:" na posição 6
    loadn r0, #str_pts
    loadn r1, #6      ; Posição inicial
    loadn r2, #256    ; Cor (Marrom/Branco ou escolha outra da sua tabela)
    call ImprimeString

    ; 2. Imprime o valor dos Pontos (5 digitos) na posição 9
    load r0, pontos
    loadn r1, #9
    call ImprimeNumero

    ; 3. Imprime "VIDAS:" na posição 30
    loadn r0, #str_vidas
    loadn r1, #30
    loadn r2, #2304   ; Cor (Vermelho para vidas)
    call ImprimeString

; 4. Desenha os Corações (Visual)
    ; Vamos percorrer os 3 slots de vida. Se tiver vida, desenha ♥. Se não, desenha espaço.
    
    load r0, vidas       ; Quantas vidas o jogador tem agora (ex: 2)
    loadn r1, #35        ; Posição na tela para começar a desenhar (após "VIDAS:")
    loadn r2, #2350      ; O CORAÇÃO VERMELHO (46 + 2304)
    loadn r3, #3         ; Máximo de vidas (Total de slots para desenhar/apagar)
    loadn r4, #0         ; Contador (i)

DrawHeartsLoop:
    cmp r4, r3           ; Se contador == 3, terminou
    jeq EndDrawHearts

    cmp r4, r0           ; Compara contador com 'vidas' atuais
    jle DrawHeart       ; Se contador < vidas, desenha Coração
    
    ; Senão (contador >= vidas), desenha espaço vazio (para apagar vida perdida)
    loadn r5, #31        ; Caractere de Espaço/Preto (ajuste se seu fundo for outro)
    outchar r5, r1
    jmp NextHeart

DrawHeart:
    outchar r2, r1       ; Desenha o Coração (#2350)

NextHeart:
    inc r1               ; Avança cursor na tela
    inc r4               ; i++
    jmp DrawHeartsLoop

EndDrawHearts:
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
; ---------------------------------------------------------------------
; ImprimeNumero
; Converte um numero em R0 (até 999) para ASCII e imprime na pos R1
; ---------------------------------------------------------------------
ImprimeNumero:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5

    
    ; Dezena de milhar
    loadn r2, #10000
    div r3, r0, r2    ; r3 = digito dezenad de milhar
    loadn r4, #48     ; '0' em ASCII
    add r5, r3, r4    ; r5 = char
    outchar r5, r1    ; Imprime
    inc r1            ; Avança cursor
    
    ;Unidade de milhar
    mod r0, r0, r2    ; r0 = resto
    loadn r2, #1000
    div r3, r0, r2    ; r3 = digito centenas
    loadn r4, #48     ; '0' em ASCII
    add r5, r3, r4    ; r5 = char
    outchar r5, r1    ; Imprime
    inc r1            ; Avança cursor


    ; Centenas
    mod r0, r0, r2    ; r0 = resto
    loadn r2, #100
    div r3, r0, r2    ; r3 = digito centenas
    loadn r4, #48     ; '0' em ASCII
    add r5, r3, r4    ; r5 = char
    outchar r5, r1    ; Imprime
    inc r1            ; Avança cursor

    ; Dezenas (Resto da divisão anterior)
    mod r0, r0, r2    ; r0 = resto
    loadn r2, #10
    div r3, r0, r2    ; r3 = digito dezenas
    add r5, r3, r4
    outchar r5, r1
    inc r1

    ; Unidades
    mod r3, r0, r2    ; r3 = resto (unidades)
    add r5, r3, r4
    outchar r5, r1

    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; ---------------------------------------------------------------------
; ImprimeString
; R0 = Endereço da string, R1 = Posição inicial, R2 = Cor (Opcional)
; ---------------------------------------------------------------------
ImprimeString:
    push r0
    push r1
    push r2
    push r3
    push r4

    loadi r3, r0      ; Carrega char
    loadn r4, #0      ; Null terminator (\0)

PrintStrLoop:
    cmp r3, r4
    jeq PrintStrSai
    add r3, r3, r2    ; Adiciona cor
    outchar r3, r1
    inc r0
    inc r1
    loadi r3, r0
    jmp PrintStrLoop

PrintStrSai:
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts


; ---------------------------------------------------------------------
; ResetPosicoesPorNivel
; Define posições iniciais do ladrão e polícia baseado no nível
; ---------------------------------------------------------------------
ResetPosicoesPorNivel:
    push r0
    push r1
    push r7
    
    call HeatMap_Reset
    
    load r0, nivel_atual
    
    loadn r1, #1
    cmp r0, r1
    jne ResetPos_Level2
    ; --- LEVEL 1 ---
    loadn r1, #1          
    store total_policiasatv, r1
    

    ; Ladrão
    loadn r0, #530
    call SetLadraoPos
    
    ; Policiais (Indice, Posição)
    loadn r0, #0
    loadn r1, #1020
    loadn r7, #0
    call SetPoliciaInit
    

    
    jmp ResetPos_Fim
    
ResetPos_Level2:
    loadn r1, #2
    cmp r0, r1
    jne ResetPos_Level3
    
    ; --- LEVEL 2 ---
    loadn r1, #2          
    store total_policiasatv, r1
    
    loadn r0, #570
    call SetLadraoPos
    
    loadn r0, #0
    loadn r1, #1069
    loadn r7, #0
    call SetPoliciaInit
    
    loadn r0, #1
    loadn r1, #230
    loadn r7, #0
    call SetPoliciaInit
    
    jmp ResetPos_Fim
    
ResetPos_Level3:
    loadn r1, #3
    cmp r0, r1
    jne ResetPos_Level4
    
    ; --- LEVEL 3 ---
    
    loadn r1, #3          
    store total_policiasatv, r1
    
    loadn r0, #250
    call SetLadraoPos
    
    loadn r0, #0
    loadn r1, #1009
    loadn r7, #0
    call SetPoliciaInit
    
    loadn r0, #1
    loadn r1, #1020
    loadn r7, #0
    call SetPoliciaInit
    
    loadn r0, #2
    loadn r1, #1028
    loadn r7, #0
    call SetPoliciaInit
    
    
    jmp ResetPos_Fim
    
ResetPos_Level4:
    ; --- LEVEL 4 ---
    loadn r1, #4          
    store total_policiasatv, r1
    
    loadn r0, #230
    call SetLadraoPos
    
    loadn r0, #0
    loadn r1, #220
    loadn r7, #0
    call SetPoliciaInit
    
    loadn r0, #1
    loadn r1, #379
    loadn r7, #0
    call SetPoliciaInit
    
    loadn r0, #2
    loadn r1, #645
    loadn r7, #0
    call SetPoliciaInit
    
    loadn r0, #3
    loadn r1, #660
    loadn r7, #0
    call SetPoliciaInit
    
ResetPos_Fim:
    ; Zera itens coletados do nível
    loadn r0, #0
    store itens_coletados, r0

    pop r7
    pop r1
    pop r0
    rts

; Auxiliar local para setar ladrão
SetLadraoPos:
    store pos_ladrao, r0
    store pos_ant_ladrao, r0
    
    ; Reseta sprite ladrão para direita
    loadn r0, #0
    store dir_ladrao, r0
    loadn r0, #ladrao_R
    store ladraoSprite, r0
    loadn r0, #ladraoGaps_H
    store ladraoGapsPtr, r0
    store ladraoGapsPtr_ant, r0
    rts


    
; Função que inicializa as variaveis do programa
; para comecar um jogo
inicializa_var:
    push r0
    push r1
    push r2
    push r3
    push r4

    loadn r0, #255
    store tecla_atual, r0
    store tecla_ant, r0
    
    loadn r0, #3
    store vidas, r0
    
    
    loadn r0, #0
    store dir_ladrao, r0
    store morte, r0
    store Zerou, r1
    store comecou, r0
    store pontos, r0
    store steps, r0
    store saida_liberada, r0
    
    loadn r0, #1
    store nivel_atual, r0

    loadn r0, #490
    store pos_ladrao, r0
    store pos_ant_ladrao, r0
    
        ; Define o sprite inicial como o Horizontal
    loadn r0, #ladrao_U
    store ladraoSprite, r0
    
    loadn r0, #ladraoGaps_V
    store ladraoGapsPtr, r0 
    store ladraoGapsPtr_ant, r0
    
    call HeatMap_Reset
    
; --- INICIALIZAÇÃO DAS 4 POLÍCIAS ---    
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; R0 = Índice, R1 = Posição Inicial
SetPoliciaInit:
    push r2
    push r3
    
    ; Define Posição
    loadn r2, #pos_policia
    add r2, r2, r0
    storei r2, r1
    
    loadn r2, #morto_policia
    add r2, r2, r0
    storei r2, r7
    
    loadn r2, #pos_policiaant
    add r2, r2, r0
    storei r2, r1
    
    ; Define Direção (0)
    loadn r2, #policia_dir
    add r2, r2, r0
    loadn r3, #0
    storei r2, r3

    ; Define Sprite/Gaps Iniciais (Horizontal / Direita)
    loadn r2, #policia_sprite
    add r2, r2, r0
    loadn r3, #policia_R
    storei r2, r3
    
    loadn r2, #policia_gaps
    add r2, r2, r0
    loadn r3, #policiaGaps_H
    storei r2, r3
    
    loadn r2, #policia_gaps_ant
    add r2, r2, r0
    storei r2, r3
    
    pop r3
    pop r2
    rts

; ---------------------------------------------------------------------
; UpdatePolicia
; Loop que move cada um dos 4 policiais sequencialmente
; ---------------------------------------------------------------------
UpdatePolicia:
    push r0
    push r1
    push r2
    push r3
    push r4
    
    loadn r0, #0  ; i = 0
    load r1, total_policiasatv  ; limite
    loadn r4, #1

Loop_update:
    cmp r1, r0
    jeq Fim_update
    
    ; Define policial atual
    store temp_indice, r0
    
    loadn r2, #morto_policia
    add r2, r2, r0
    loadi r2,r2
    cmp r4,r2
    jeq next_poll     
    
    ; Salva estados antigos (ESSENCIAL!)
    loadn r2, #pos_policia
    add r2, r2, r0
    loadi r3, r2
    
    loadn r2, #pos_ant_policia
    add r2, r2, r0
    storei r2, r3            ; pos_policiaant[i] = pos_policia[i]
    
    store pos_policiaant, r3 ;
    
    loadn r2, #policia_gaps
    add r2, r2, r0
    loadi r3, r2
    
    loadn r2, #policia_gaps_ant
    add r2, r2, r0
    storei r2, r3            ; gaps_ant[i] = gaps[i]
    
    ; Backup Direção e Estado (Opcional, mas bom para consistência)
    loadn r2, #policia_dir
    add r2, r2, r0
    loadi r3, r2
    store dir_policiaant, r3  ; Usa var temporária para IA


    call CalculaPosPolicia
    
        ; pos
    load r2, pos_policiaant
    loadn r3, #pos_policia
    add r3, r3, r0
    storei r3, r2

    ; dir
    load r2, dir_policiaant
    loadn r3, #policia_dir
    add r3, r3, r0
    storei r3, r2

    ; est
    load r2, est_policiaant
    loadn r3, #policia_est
    add r3, r3, r0
    storei r3, r2
    
    
    next_poll:
        inc r0
    jmp Loop_update

Fim_update:
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

;Funçao que trava o processamento até que uma tecla seja solta
WaitKeyRelease:
    push r0
    push r1
    
    loadn r1, #255      ;caractere vazio
WaitKeyRelease_Loop:
    inchar r0
    cmp r0, r1
    jne WaitKeyRelease_Loop  ; Se r0 != 255 (tem tecla pressionada), continua no loop
    
    pop r1
    pop r0
    rts


HeatMap_Reset:
    push r0
    push r1
    push r2
    
    loadn r0, #HeatMap
    loadn r1, #1200
    loadn r2, #0
    
Heat_Clear_Loop:
    storei r0, r2
    inc r0
    dec r1
    jnz Heat_Clear_Loop
    
    pop r2
    pop r1
    pop r0
    rts
    
HeatMap_Decay:
    push r0
    push r1
    push r2
    push r3
    
    loadn r0, #HeatMap
    loadn r1, #1200
    loadn r3, #0
    
Decay_Loop:
    loadi r2, r0
    cmp r2, r3
    jeq Next_Decay ; Se já é 0, ignora
    
    dec r2         ; Diminui o calor
    storei r0, r2
    
Next_Decay:
    inc r0
    dec r1
    jnz Decay_Loop
    
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
level1 : var #1200
  ;Linha 0
  static level1 + #0, #3967
  static level1 + #1, #3967
  static level1 + #2, #3967
  static level1 + #3, #3967
  static level1 + #4, #3967
  static level1 + #5, #3967
  static level1 + #6, #3967
  static level1 + #7, #3967
  static level1 + #8, #3967
  static level1 + #9, #3967
  static level1 + #10, #3967
  static level1 + #11, #3967
  static level1 + #12, #3967
  static level1 + #13, #3967
  static level1 + #14, #3967
  static level1 + #15, #3967
  static level1 + #16, #3967
  static level1 + #17, #3967
  static level1 + #18, #3967
  static level1 + #19, #3967
  static level1 + #20, #3967
  static level1 + #21, #3967
  static level1 + #22, #3967
  static level1 + #23, #3967
  static level1 + #24, #3967
  static level1 + #25, #3967
  static level1 + #26, #3967
  static level1 + #27, #3967
  static level1 + #28, #3967
  static level1 + #29, #3967
  static level1 + #30, #3967
  static level1 + #31, #3967
  static level1 + #32, #3967
  static level1 + #33, #3967
  static level1 + #34, #3967
  static level1 + #35, #3967
  static level1 + #36, #3967
  static level1 + #37, #3967
  static level1 + #38, #3967
  static level1 + #39, #3967

  ;Linha 1
  static level1 + #40, #3967
  static level1 + #41, #3967
  static level1 + #42, #3967
  static level1 + #43, #3967
  static level1 + #44, #3967
  static level1 + #45, #3967
  static level1 + #46, #3967
  static level1 + #47, #3967
  static level1 + #48, #3967
  static level1 + #49, #3967
  static level1 + #50, #3967
  static level1 + #51, #3967
  static level1 + #52, #3967
  static level1 + #53, #3967
  static level1 + #54, #3967
  static level1 + #55, #3967
  static level1 + #56, #3967
  static level1 + #57, #3967
  static level1 + #58, #3967
  static level1 + #59, #3967
  static level1 + #60, #3967
  static level1 + #61, #3967
  static level1 + #62, #3967
  static level1 + #63, #3967
  static level1 + #64, #3967
  static level1 + #65, #3967
  static level1 + #66, #3967
  static level1 + #67, #3967
  static level1 + #68, #3967
  static level1 + #69, #3967
  static level1 + #70, #3967
  static level1 + #71, #3967
  static level1 + #72, #3967
  static level1 + #73, #3967
  static level1 + #74, #3967
  static level1 + #75, #3967
  static level1 + #76, #3967
  static level1 + #77, #3967
  static level1 + #78, #3967
  static level1 + #79, #3967

  ;Linha 2
  static level1 + #80, #3967
  static level1 + #81, #3967
  static level1 + #82, #3967
  static level1 + #83, #3967
  static level1 + #84, #3967
  static level1 + #85, #3967
  static level1 + #86, #3967
  static level1 + #87, #3967
  static level1 + #88, #3967
  static level1 + #89, #3967
  static level1 + #90, #3967
  static level1 + #91, #3967
  static level1 + #92, #3967
  static level1 + #93, #3967
  static level1 + #94, #3967
  static level1 + #95, #3967
  static level1 + #96, #3967
  static level1 + #97, #3967
  static level1 + #98, #3967
  static level1 + #99, #3967
  static level1 + #100, #3967
  static level1 + #101, #3967
  static level1 + #102, #3967
  static level1 + #103, #3967
  static level1 + #104, #3967
  static level1 + #105, #3967
  static level1 + #106, #3967
  static level1 + #107, #3967
  static level1 + #108, #3967
  static level1 + #109, #3967
  static level1 + #110, #3967
  static level1 + #111, #3967
  static level1 + #112, #3967
  static level1 + #113, #3967
  static level1 + #114, #3967
  static level1 + #115, #3967
  static level1 + #116, #3967
  static level1 + #117, #3967
  static level1 + #118, #3967
  static level1 + #119, #3967

  ;Linha 3
  static level1 + #120, #3967
  static level1 + #121, #3967
  static level1 + #122, #3967
  static level1 + #123, #3696
  static level1 + #124, #3690
  static level1 + #125, #3690
  static level1 + #126, #3690
  static level1 + #127, #3690
  static level1 + #128, #3690
  static level1 + #129, #3690
  static level1 + #130, #3690
  static level1 + #131, #3690
  static level1 + #132, #3690
  static level1 + #133, #3690
  static level1 + #134, #3690
  static level1 + #135, #3690
  static level1 + #136, #3690
  static level1 + #137, #3690
  static level1 + #138, #3690
  static level1 + #139, #3690
  static level1 + #140, #3690
  static level1 + #141, #3690
  static level1 + #142, #3690
  static level1 + #143, #3690
  static level1 + #144, #3690
  static level1 + #145, #3690
  static level1 + #146, #3690
  static level1 + #147, #3690
  static level1 + #148, #3690
  static level1 + #149, #3690
  static level1 + #150, #3690
  static level1 + #151, #3690
  static level1 + #152, #3690
  static level1 + #153, #3690
  static level1 + #154, #3693
  static level1 + #155, #3967
  static level1 + #156, #3967
  static level1 + #157, #3967
  static level1 + #158, #3967
  static level1 + #159, #3967

  ;Linha 4
  static level1 + #160, #3967
  static level1 + #161, #3967
  static level1 + #162, #3967
  static level1 + #163, #3692
  static level1 + #164, #45
  static level1 + #165, #45
  static level1 + #166, #45
  static level1 + #167, #45
  static level1 + #168, #45
  static level1 + #169, #45
  static level1 + #170, #45
  static level1 + #171, #45
  static level1 + #172, #45
  static level1 + #173, #45
  static level1 + #174, #45
  static level1 + #175, #45
  static level1 + #176, #45
  static level1 + #177, #45
  static level1 + #178, #45
  static level1 + #179, #45
  static level1 + #180, #45
  static level1 + #181, #45
  static level1 + #182, #45
  static level1 + #183, #45
  static level1 + #184, #45
  static level1 + #185, #1556
  static level1 + #186, #45
  static level1 + #187, #45
  static level1 + #188, #45
  static level1 + #189, #45
  static level1 + #190, #45
  static level1 + #191, #45
  static level1 + #192, #45
  static level1 + #193, #45
  static level1 + #194, #3691
  static level1 + #195, #3967
  static level1 + #196, #3967
  static level1 + #197, #3967
  static level1 + #198, #3967
  static level1 + #199, #3967

  ;Linha 5
  static level1 + #200, #3967
  static level1 + #201, #3967
  static level1 + #202, #3967
  static level1 + #203, #3692
  static level1 + #204, #45
  static level1 + #205, #45
  static level1 + #206, #45
  static level1 + #207, #45
  static level1 + #208, #45
  static level1 + #209, #45
  static level1 + #210, #45
  static level1 + #211, #45
  static level1 + #212, #45
  static level1 + #213, #45
  static level1 + #214, #45
  static level1 + #215, #45
  static level1 + #216, #45
  static level1 + #217, #45
  static level1 + #218, #45
  static level1 + #219, #45
  static level1 + #220, #45
  static level1 + #221, #45
  static level1 + #222, #45
  static level1 + #223, #45
  static level1 + #224, #45
  static level1 + #225, #45
  static level1 + #226, #45
  static level1 + #227, #45
  static level1 + #228, #45
  static level1 + #229, #45
  static level1 + #230, #45
  static level1 + #231, #45
  static level1 + #232, #45
  static level1 + #233, #45
  static level1 + #234, #3691
  static level1 + #235, #3967
  static level1 + #236, #3967
  static level1 + #237, #3967
  static level1 + #238, #3967
  static level1 + #239, #3967

  ;Linha 6
  static level1 + #240, #3967
  static level1 + #241, #3967
  static level1 + #242, #3967
  static level1 + #243, #3692
  static level1 + #244, #15
  static level1 + #245, #15
  static level1 + #246, #15
  static level1 + #247, #1373
  static level1 + #248, #1373
  static level1 + #249, #31
  static level1 + #250, #31
  static level1 + #251, #31
  static level1 + #252, #1373
  static level1 + #253, #1373
  static level1 + #254, #1373
  static level1 + #255, #15
  static level1 + #256, #15
  static level1 + #257, #15
  static level1 + #258, #31
  static level1 + #259, #605
  static level1 + #260, #605
  static level1 + #261, #605
  static level1 + #262, #2653
  static level1 + #263, #2653
  static level1 + #264, #31
  static level1 + #265, #31
  static level1 + #266, #31
  static level1 + #267, #1373
  static level1 + #268, #1373
  static level1 + #269, #1373
  static level1 + #270, #1373
  static level1 + #271, #15
  static level1 + #272, #15
  static level1 + #273, #15
  static level1 + #274, #3691
  static level1 + #275, #3967
  static level1 + #276, #3967
  static level1 + #277, #3967
  static level1 + #278, #3967
  static level1 + #279, #3967

  ;Linha 7
  static level1 + #280, #3967
  static level1 + #281, #3967
  static level1 + #282, #3967
  static level1 + #283, #3692
  static level1 + #284, #15
  static level1 + #285, #15
  static level1 + #286, #15
  static level1 + #287, #1373
  static level1 + #288, #1373
  static level1 + #289, #31
  static level1 + #290, #1556
  static level1 + #291, #31
  static level1 + #292, #1373
  static level1 + #293, #1373
  static level1 + #294, #1373
  static level1 + #295, #15
  static level1 + #296, #15
  static level1 + #297, #15
  static level1 + #298, #605
  static level1 + #299, #605
  static level1 + #300, #605
  static level1 + #301, #605
  static level1 + #302, #605
  static level1 + #303, #2653
  static level1 + #304, #31
  static level1 + #305, #31
  static level1 + #306, #31
  static level1 + #307, #1373
  static level1 + #308, #1373
  static level1 + #309, #1373
  static level1 + #310, #1373
  static level1 + #311, #15
  static level1 + #312, #15
  static level1 + #313, #15
  static level1 + #314, #3691
  static level1 + #315, #3967
  static level1 + #316, #3967
  static level1 + #317, #3967
  static level1 + #318, #3967
  static level1 + #319, #3967

  ;Linha 8
  static level1 + #320, #3967
  static level1 + #321, #3967
  static level1 + #322, #3967
  static level1 + #323, #3692
  static level1 + #324, #15
  static level1 + #325, #2835
  static level1 + #326, #15
  static level1 + #327, #1373
  static level1 + #328, #1373
  static level1 + #329, #31
  static level1 + #330, #31
  static level1 + #331, #31
  static level1 + #332, #31
  static level1 + #333, #2835
  static level1 + #334, #31
  static level1 + #335, #15
  static level1 + #336, #15
  static level1 + #337, #15
  static level1 + #338, #605
  static level1 + #339, #2653
  static level1 + #340, #605
  static level1 + #341, #605
  static level1 + #342, #605
  static level1 + #343, #605
  static level1 + #344, #31
  static level1 + #345, #31
  static level1 + #346, #1373
  static level1 + #347, #1373
  static level1 + #348, #1373
  static level1 + #349, #1373
  static level1 + #350, #1373
  static level1 + #351, #15
  static level1 + #352, #15
  static level1 + #353, #15
  static level1 + #354, #3691
  static level1 + #355, #3967
  static level1 + #356, #3967
  static level1 + #357, #3967
  static level1 + #358, #3967
  static level1 + #359, #3967

  ;Linha 9
  static level1 + #360, #3967
  static level1 + #361, #3967
  static level1 + #362, #3967
  static level1 + #363, #3692
  static level1 + #364, #15
  static level1 + #365, #15
  static level1 + #366, #15
  static level1 + #367, #1373
  static level1 + #368, #1373
  static level1 + #369, #31
  static level1 + #370, #31
  static level1 + #371, #31
  static level1 + #372, #31
  static level1 + #373, #31
  static level1 + #374, #31
  static level1 + #375, #15
  static level1 + #376, #15
  static level1 + #377, #15
  static level1 + #378, #605
  static level1 + #379, #2653
  static level1 + #380, #2653
  static level1 + #381, #605
  static level1 + #382, #605
  static level1 + #383, #605
  static level1 + #384, #31
  static level1 + #385, #31
  static level1 + #386, #1373
  static level1 + #387, #1373
  static level1 + #388, #1373
  static level1 + #389, #1373
  static level1 + #390, #1373
  static level1 + #391, #15
  static level1 + #392, #15
  static level1 + #393, #15
  static level1 + #394, #3691
  static level1 + #395, #3967
  static level1 + #396, #3967
  static level1 + #397, #3967
  static level1 + #398, #3967
  static level1 + #399, #3967

  ;Linha 10
  static level1 + #400, #3967
  static level1 + #401, #3967
  static level1 + #402, #3967
  static level1 + #403, #3692
  static level1 + #404, #15
  static level1 + #405, #15
  static level1 + #406, #15
  static level1 + #407, #31
  static level1 + #408, #31
  static level1 + #409, #31
  static level1 + #410, #31
  static level1 + #411, #31
  static level1 + #412, #1373
  static level1 + #413, #1373
  static level1 + #414, #1373
  static level1 + #415, #15
  static level1 + #416, #15
  static level1 + #417, #15
  static level1 + #418, #605
  static level1 + #419, #2653
  static level1 + #420, #2653
  static level1 + #421, #605
  static level1 + #422, #605
  static level1 + #423, #605
  static level1 + #424, #31
  static level1 + #425, #31
  static level1 + #426, #1373
  static level1 + #427, #1373
  static level1 + #428, #1373
  static level1 + #429, #1373
  static level1 + #430, #1373
  static level1 + #431, #15
  static level1 + #432, #15
  static level1 + #433, #15
  static level1 + #434, #3691
  static level1 + #435, #3967
  static level1 + #436, #3967
  static level1 + #437, #3967
  static level1 + #438, #3967
  static level1 + #439, #3967

  ;Linha 11
  static level1 + #440, #3967
  static level1 + #441, #3967
  static level1 + #442, #3967
  static level1 + #443, #3692
  static level1 + #444, #15
  static level1 + #445, #15
  static level1 + #446, #15
  static level1 + #447, #1373
  static level1 + #448, #1373
  static level1 + #449, #31
  static level1 + #450, #31
  static level1 + #451, #31
  static level1 + #452, #1373
  static level1 + #453, #1373
  static level1 + #454, #1373
  static level1 + #455, #15
  static level1 + #456, #15
  static level1 + #457, #15
  static level1 + #458, #605
  static level1 + #459, #2653
  static level1 + #460, #605
  static level1 + #461, #605
  static level1 + #462, #605
  static level1 + #463, #605
  static level1 + #464, #31
  static level1 + #465, #31
  static level1 + #466, #31
  static level1 + #467, #1373
  static level1 + #468, #1373
  static level1 + #469, #1373
  static level1 + #470, #1373
  static level1 + #471, #15
  static level1 + #472, #15
  static level1 + #473, #15
  static level1 + #474, #3691
  static level1 + #475, #3967
  static level1 + #476, #3967
  static level1 + #477, #3967
  static level1 + #478, #3967
  static level1 + #479, #3967

  ;Linha 12
  static level1 + #480, #3967
  static level1 + #481, #3967
  static level1 + #482, #3967
  static level1 + #483, #3692
  static level1 + #484, #15
  static level1 + #485, #15
  static level1 + #486, #15
  static level1 + #487, #1373
  static level1 + #488, #1373
  static level1 + #489, #31
  static level1 + #490, #31
  static level1 + #491, #31
  static level1 + #492, #31
  static level1 + #493, #31
  static level1 + #494, #31
  static level1 + #495, #15
  static level1 + #496, #15
  static level1 + #497, #15
  static level1 + #498, #31
  static level1 + #499, #605
  static level1 + #500, #605
  static level1 + #501, #605
  static level1 + #502, #605
  static level1 + #503, #605
  static level1 + #504, #31
  static level1 + #505, #31
  static level1 + #506, #31
  static level1 + #507, #1373
  static level1 + #508, #1373
  static level1 + #509, #1373
  static level1 + #510, #1373
  static level1 + #511, #15
  static level1 + #512, #15
  static level1 + #513, #15
  static level1 + #514, #3691
  static level1 + #515, #3967
  static level1 + #516, #3967
  static level1 + #517, #3967
  static level1 + #518, #3967
  static level1 + #519, #3967

  ;Linha 13
  static level1 + #520, #3967
  static level1 + #521, #3967
  static level1 + #522, #3967
  static level1 + #523, #3692
  static level1 + #524, #15
  static level1 + #525, #15
  static level1 + #526, #15
  static level1 + #527, #45
  static level1 + #528, #45
  static level1 + #529, #45
  static level1 + #530, #45
  static level1 + #531, #45
  static level1 + #532, #45
  static level1 + #533, #45
  static level1 + #534, #45
  static level1 + #535, #15
  static level1 + #536, #15
  static level1 + #537, #15
  static level1 + #538, #45
  static level1 + #539, #45
  static level1 + #540, #45
  static level1 + #541, #45
  static level1 + #542, #45
  static level1 + #543, #45
  static level1 + #544, #45
  static level1 + #545, #45
  static level1 + #546, #45
  static level1 + #547, #45
  static level1 + #548, #45
  static level1 + #549, #45
  static level1 + #550, #45
  static level1 + #551, #15
  static level1 + #552, #1556
  static level1 + #553, #15
  static level1 + #554, #3691
  static level1 + #555, #3967
  static level1 + #556, #3967
  static level1 + #557, #3967
  static level1 + #558, #3967
  static level1 + #559, #3967

  ;Linha 14
  static level1 + #560, #3967
  static level1 + #561, #3967
  static level1 + #562, #3967
  static level1 + #563, #3692
  static level1 + #564, #15
  static level1 + #565, #15
  static level1 + #566, #15
  static level1 + #567, #45
  static level1 + #568, #45
  static level1 + #569, #45
  static level1 + #570, #45
  static level1 + #571, #45
  static level1 + #572, #45
  static level1 + #573, #45
  static level1 + #574, #45
  static level1 + #575, #15
  static level1 + #576, #2835
  static level1 + #577, #15
  static level1 + #578, #45
  static level1 + #579, #45
  static level1 + #580, #45
  static level1 + #581, #45
  static level1 + #582, #45
  static level1 + #583, #45
  static level1 + #584, #45
  static level1 + #585, #45
  static level1 + #586, #45
  static level1 + #587, #45
  static level1 + #588, #45
  static level1 + #589, #45
  static level1 + #590, #45
  static level1 + #591, #15
  static level1 + #592, #15
  static level1 + #593, #15
  static level1 + #594, #3691
  static level1 + #595, #3967
  static level1 + #596, #3967
  static level1 + #597, #3967
  static level1 + #598, #3967
  static level1 + #599, #3967

  ;Linha 15
  static level1 + #600, #3967
  static level1 + #601, #3967
  static level1 + #602, #3967
  static level1 + #603, #3692
  static level1 + #604, #15
  static level1 + #605, #15
  static level1 + #606, #15
  static level1 + #607, #45
  static level1 + #608, #45
  static level1 + #609, #45
  static level1 + #610, #45
  static level1 + #611, #45
  static level1 + #612, #45
  static level1 + #613, #45
  static level1 + #614, #45
  static level1 + #615, #15
  static level1 + #616, #15
  static level1 + #617, #15
  static level1 + #618, #45
  static level1 + #619, #45
  static level1 + #620, #45
  static level1 + #621, #45
  static level1 + #622, #45
  static level1 + #623, #45
  static level1 + #624, #45
  static level1 + #625, #45
  static level1 + #626, #45
  static level1 + #627, #45
  static level1 + #628, #45
  static level1 + #629, #45
  static level1 + #630, #45
  static level1 + #631, #15
  static level1 + #632, #15
  static level1 + #633, #15
  static level1 + #634, #3691
  static level1 + #635, #3967
  static level1 + #636, #3967
  static level1 + #637, #3967
  static level1 + #638, #3967
  static level1 + #639, #3967

  ;Linha 16
  static level1 + #640, #3967
  static level1 + #641, #3967
  static level1 + #642, #3967
  static level1 + #643, #3692
  static level1 + #644, #15
  static level1 + #645, #15
  static level1 + #646, #15
  static level1 + #647, #1373
  static level1 + #648, #1373
  static level1 + #649, #2835
  static level1 + #650, #31
  static level1 + #651, #31
  static level1 + #652, #31
  static level1 + #653, #1373
  static level1 + #654, #1373
  static level1 + #655, #15
  static level1 + #656, #15
  static level1 + #657, #15
  static level1 + #658, #1373
  static level1 + #659, #1373
  static level1 + #660, #1373
  static level1 + #661, #1373
  static level1 + #662, #31
  static level1 + #663, #31
  static level1 + #664, #31
  static level1 + #665, #31
  static level1 + #666, #1373
  static level1 + #667, #1373
  static level1 + #668, #1373
  static level1 + #669, #1373
  static level1 + #670, #1373
  static level1 + #671, #15
  static level1 + #672, #15
  static level1 + #673, #15
  static level1 + #674, #3691
  static level1 + #675, #3967
  static level1 + #676, #3967
  static level1 + #677, #3967
  static level1 + #678, #3967
  static level1 + #679, #3967

  ;Linha 17
  static level1 + #680, #3967
  static level1 + #681, #3967
  static level1 + #682, #3967
  static level1 + #683, #3692
  static level1 + #684, #15
  static level1 + #685, #15
  static level1 + #686, #15
  static level1 + #687, #1373
  static level1 + #688, #1373
  static level1 + #689, #31
  static level1 + #690, #31
  static level1 + #691, #31
  static level1 + #692, #31
  static level1 + #693, #1373
  static level1 + #694, #1373
  static level1 + #695, #15
  static level1 + #696, #15
  static level1 + #697, #15
  static level1 + #698, #1373
  static level1 + #699, #1373
  static level1 + #700, #1373
  static level1 + #701, #1373
  static level1 + #702, #31
  static level1 + #703, #2835
  static level1 + #704, #31
  static level1 + #705, #31
  static level1 + #706, #1373
  static level1 + #707, #1373
  static level1 + #708, #1373
  static level1 + #709, #1373
  static level1 + #710, #1373
  static level1 + #711, #15
  static level1 + #712, #15
  static level1 + #713, #15
  static level1 + #714, #3691
  static level1 + #715, #3967
  static level1 + #716, #3967
  static level1 + #717, #3967
  static level1 + #718, #3967
  static level1 + #719, #3967

  ;Linha 18
  static level1 + #720, #3967
  static level1 + #721, #3967
  static level1 + #722, #3967
  static level1 + #723, #3692
  static level1 + #724, #15
  static level1 + #725, #15
  static level1 + #726, #15
  static level1 + #727, #31
  static level1 + #728, #31
  static level1 + #729, #31
  static level1 + #730, #31
  static level1 + #731, #31
  static level1 + #732, #31
  static level1 + #733, #31
  static level1 + #734, #31
  static level1 + #735, #15
  static level1 + #736, #15
  static level1 + #737, #15
  static level1 + #738, #1373
  static level1 + #739, #1373
  static level1 + #740, #1373
  static level1 + #741, #1373
  static level1 + #742, #31
  static level1 + #743, #31
  static level1 + #744, #31
  static level1 + #745, #31
  static level1 + #746, #1373
  static level1 + #747, #1373
  static level1 + #748, #1373
  static level1 + #749, #1373
  static level1 + #750, #1373
  static level1 + #751, #15
  static level1 + #752, #15
  static level1 + #753, #15
  static level1 + #754, #3691
  static level1 + #755, #3967
  static level1 + #756, #3967
  static level1 + #757, #3967
  static level1 + #758, #3967
  static level1 + #759, #3967

  ;Linha 19
  static level1 + #760, #3967
  static level1 + #761, #3967
  static level1 + #762, #3967
  static level1 + #763, #3692
  static level1 + #764, #15
  static level1 + #765, #15
  static level1 + #766, #15
  static level1 + #767, #31
  static level1 + #768, #31
  static level1 + #769, #31
  static level1 + #770, #31
  static level1 + #771, #31
  static level1 + #772, #31
  static level1 + #773, #31
  static level1 + #774, #31
  static level1 + #775, #15
  static level1 + #776, #15
  static level1 + #777, #15
  static level1 + #778, #31
  static level1 + #779, #31
  static level1 + #780, #31
  static level1 + #781, #31
  static level1 + #782, #31
  static level1 + #783, #31
  static level1 + #784, #31
  static level1 + #785, #31
  static level1 + #786, #31
  static level1 + #787, #31
  static level1 + #788, #31
  static level1 + #789, #31
  static level1 + #790, #31
  static level1 + #791, #15
  static level1 + #792, #15
  static level1 + #793, #15
  static level1 + #794, #3691
  static level1 + #795, #3967
  static level1 + #796, #3967
  static level1 + #797, #3967
  static level1 + #798, #3967
  static level1 + #799, #3967

  ;Linha 20
  static level1 + #800, #3967
  static level1 + #801, #3967
  static level1 + #802, #3967
  static level1 + #803, #3692
  static level1 + #804, #15
  static level1 + #805, #15
  static level1 + #806, #15
  static level1 + #807, #1373
  static level1 + #808, #1373
  static level1 + #809, #1373
  static level1 + #810, #1373
  static level1 + #811, #31
  static level1 + #812, #2835
  static level1 + #813, #1373
  static level1 + #814, #1373
  static level1 + #815, #15
  static level1 + #816, #15
  static level1 + #817, #15
  static level1 + #818, #31
  static level1 + #819, #31
  static level1 + #820, #31
  static level1 + #821, #31
  static level1 + #822, #31
  static level1 + #823, #31
  static level1 + #824, #31
  static level1 + #825, #31
  static level1 + #826, #31
  static level1 + #827, #31
  static level1 + #828, #31
  static level1 + #829, #31
  static level1 + #830, #31
  static level1 + #831, #15
  static level1 + #832, #15
  static level1 + #833, #15
  static level1 + #834, #3691
  static level1 + #835, #3967
  static level1 + #836, #3967
  static level1 + #837, #3967
  static level1 + #838, #3967
  static level1 + #839, #3967

  ;Linha 21
  static level1 + #840, #3967
  static level1 + #841, #3967
  static level1 + #842, #3967
  static level1 + #843, #3692
  static level1 + #844, #15
  static level1 + #845, #15
  static level1 + #846, #15
  static level1 + #847, #1373
  static level1 + #848, #1373
  static level1 + #849, #1373
  static level1 + #850, #1373
  static level1 + #851, #31
  static level1 + #852, #31
  static level1 + #853, #1373
  static level1 + #854, #1373
  static level1 + #855, #15
  static level1 + #856, #15
  static level1 + #857, #15
  static level1 + #858, #31
  static level1 + #859, #31
  static level1 + #860, #1373
  static level1 + #861, #1373
  static level1 + #862, #31
  static level1 + #863, #31
  static level1 + #864, #31
  static level1 + #865, #31
  static level1 + #866, #1373
  static level1 + #867, #1373
  static level1 + #868, #31
  static level1 + #869, #31
  static level1 + #870, #31
  static level1 + #871, #15
  static level1 + #872, #15
  static level1 + #873, #15
  static level1 + #874, #3691
  static level1 + #875, #3967
  static level1 + #876, #3967
  static level1 + #877, #3967
  static level1 + #878, #3967
  static level1 + #879, #3967

  ;Linha 22
  static level1 + #880, #3967
  static level1 + #881, #3967
  static level1 + #882, #3967
  static level1 + #883, #3692
  static level1 + #884, #15
  static level1 + #885, #15
  static level1 + #886, #15
  static level1 + #887, #1373
  static level1 + #888, #1373
  static level1 + #889, #31
  static level1 + #890, #31
  static level1 + #891, #31
  static level1 + #892, #31
  static level1 + #893, #31
  static level1 + #894, #31
  static level1 + #895, #15
  static level1 + #896, #15
  static level1 + #897, #15
  static level1 + #898, #31
  static level1 + #899, #31
  static level1 + #900, #1373
  static level1 + #901, #1373
  static level1 + #902, #1373
  static level1 + #903, #1373
  static level1 + #904, #1373
  static level1 + #905, #1373
  static level1 + #906, #1373
  static level1 + #907, #1373
  static level1 + #908, #31
  static level1 + #909, #2835
  static level1 + #910, #31
  static level1 + #911, #15
  static level1 + #912, #15
  static level1 + #913, #15
  static level1 + #914, #3691
  static level1 + #915, #3967
  static level1 + #916, #3967
  static level1 + #917, #3967
  static level1 + #918, #3967
  static level1 + #919, #3967

  ;Linha 23
  static level1 + #920, #3967
  static level1 + #921, #3967
  static level1 + #922, #3967
  static level1 + #923, #3692
  static level1 + #924, #15
  static level1 + #925, #15
  static level1 + #926, #15
  static level1 + #927, #1373
  static level1 + #928, #1373
  static level1 + #929, #31
  static level1 + #930, #31
  static level1 + #931, #31
  static level1 + #932, #31
  static level1 + #933, #31
  static level1 + #934, #31
  static level1 + #935, #15
  static level1 + #936, #15
  static level1 + #937, #15
  static level1 + #938, #31
  static level1 + #939, #31
  static level1 + #940, #1373
  static level1 + #941, #1373
  static level1 + #942, #1373
  static level1 + #943, #1373
  static level1 + #944, #1373
  static level1 + #945, #1373
  static level1 + #946, #1373
  static level1 + #947, #1373
  static level1 + #948, #31
  static level1 + #949, #31
  static level1 + #950, #31
  static level1 + #951, #15
  static level1 + #952, #15
  static level1 + #953, #15
  static level1 + #954, #3691
  static level1 + #955, #3967
  static level1 + #956, #3967
  static level1 + #957, #3967
  static level1 + #958, #3967
  static level1 + #959, #3967

  ;Linha 24
  static level1 + #960, #3967
  static level1 + #961, #3967
  static level1 + #962, #3967
  static level1 + #963, #3692
  static level1 + #964, #15
  static level1 + #965, #15
  static level1 + #966, #15
  static level1 + #967, #1373
  static level1 + #968, #1373
  static level1 + #969, #1373
  static level1 + #970, #1373
  static level1 + #971, #31
  static level1 + #972, #31
  static level1 + #973, #1373
  static level1 + #974, #1373
  static level1 + #975, #15
  static level1 + #976, #15
  static level1 + #977, #15
  static level1 + #978, #31
  static level1 + #979, #31
  static level1 + #980, #1373
  static level1 + #981, #1373
  static level1 + #982, #1373
  static level1 + #983, #1373
  static level1 + #984, #1373
  static level1 + #985, #1373
  static level1 + #986, #1373
  static level1 + #987, #1373
  static level1 + #988, #31
  static level1 + #989, #31
  static level1 + #990, #31
  static level1 + #991, #15
  static level1 + #992, #15
  static level1 + #993, #15
  static level1 + #994, #3691
  static level1 + #995, #3967
  static level1 + #996, #3967
  static level1 + #997, #3967
  static level1 + #998, #3967
  static level1 + #999, #3967

  ;Linha 25
  static level1 + #1000, #3967
  static level1 + #1001, #3967
  static level1 + #1002, #3967
  static level1 + #1003, #3692
  static level1 + #1004, #15
  static level1 + #1005, #15
  static level1 + #1006, #15
  static level1 + #1007, #1373
  static level1 + #1008, #1373
  static level1 + #1009, #1373
  static level1 + #1010, #1373
  static level1 + #1011, #31
  static level1 + #1012, #31
  static level1 + #1013, #1373
  static level1 + #1014, #1373
  static level1 + #1015, #15
  static level1 + #1016, #15
  static level1 + #1017, #15
  static level1 + #1018, #31
  static level1 + #1019, #31
  static level1 + #1020, #31
  static level1 + #1021, #31
  static level1 + #1022, #31
  static level1 + #1023, #1556
  static level1 + #1024, #31
  static level1 + #1025, #31
  static level1 + #1026, #31
  static level1 + #1027, #31
  static level1 + #1028, #31
  static level1 + #1029, #31
  static level1 + #1030, #31
  static level1 + #1031, #15
  static level1 + #1032, #15
  static level1 + #1033, #15
  static level1 + #1034, #3691
  static level1 + #1035, #3967
  static level1 + #1036, #3967
  static level1 + #1037, #3967
  static level1 + #1038, #3967
  static level1 + #1039, #3967

  ;Linha 26
  static level1 + #1040, #3967
  static level1 + #1041, #3967
  static level1 + #1042, #3967
  static level1 + #1043, #3692
  static level1 + #1044, #45
  static level1 + #1045, #45
  static level1 + #1046, #45
  static level1 + #1047, #45
  static level1 + #1048, #45
  static level1 + #1049, #45
  static level1 + #1050, #45
  static level1 + #1051, #45
  static level1 + #1052, #45
  static level1 + #1053, #45
  static level1 + #1054, #45
  static level1 + #1055, #45
  static level1 + #1056, #45
  static level1 + #1057, #45
  static level1 + #1058, #45
  static level1 + #1059, #45
  static level1 + #1060, #45
  static level1 + #1061, #45
  static level1 + #1062, #45
  static level1 + #1063, #45
  static level1 + #1064, #45
  static level1 + #1065, #45
  static level1 + #1066, #45
  static level1 + #1067, #45
  static level1 + #1068, #45
  static level1 + #1069, #45
  static level1 + #1070, #45
  static level1 + #1071, #45
  static level1 + #1072, #45
  static level1 + #1073, #45
  static level1 + #1074, #3691
  static level1 + #1075, #3967
  static level1 + #1076, #3967
  static level1 + #1077, #3967
  static level1 + #1078, #3967
  static level1 + #1079, #3967

  ;Linha 27
  static level1 + #1080, #3967
  static level1 + #1081, #3967
  static level1 + #1082, #3967
  static level1 + #1083, #3692
  static level1 + #1084, #45
  static level1 + #1085, #45
  static level1 + #1086, #45
  static level1 + #1087, #45
  static level1 + #1088, #45
  static level1 + #1089, #45
  static level1 + #1090, #45
  static level1 + #1091, #45
  static level1 + #1092, #45
  static level1 + #1093, #45
  static level1 + #1094, #45
  static level1 + #1095, #45
  static level1 + #1096, #45
  static level1 + #1097, #2859
  static level1 + #1098, #45
  static level1 + #1099, #45
  static level1 + #1100, #45
  static level1 + #1101, #45
  static level1 + #1102, #45
  static level1 + #1103, #45
  static level1 + #1104, #45
  static level1 + #1105, #45
  static level1 + #1106, #45
  static level1 + #1107, #45
  static level1 + #1108, #45
  static level1 + #1109, #45
  static level1 + #1110, #45
  static level1 + #1111, #45
  static level1 + #1112, #45
  static level1 + #1113, #45
  static level1 + #1114, #3691
  static level1 + #1115, #3967
  static level1 + #1116, #3967
  static level1 + #1117, #3967
  static level1 + #1118, #3967
  static level1 + #1119, #3967

  ;Linha 28
  static level1 + #1120, #3967
  static level1 + #1121, #3967
  static level1 + #1122, #3967
  static level1 + #1123, #3695
  static level1 + #1124, #3689
  static level1 + #1125, #3689
  static level1 + #1126, #3689
  static level1 + #1127, #3689
  static level1 + #1128, #3689
  static level1 + #1129, #3689
  static level1 + #1130, #3689
  static level1 + #1131, #3689
  static level1 + #1132, #3689
  static level1 + #1133, #3689
  static level1 + #1134, #3689
  static level1 + #1135, #3689
  static level1 + #1136, #3689
  static level1 + #1137, #3689
  static level1 + #1138, #3689
  static level1 + #1139, #3689
  static level1 + #1140, #3689
  static level1 + #1141, #3689
  static level1 + #1142, #3689
  static level1 + #1143, #3689
  static level1 + #1144, #3689
  static level1 + #1145, #3689
  static level1 + #1146, #3689
  static level1 + #1147, #3689
  static level1 + #1148, #3689
  static level1 + #1149, #3689
  static level1 + #1150, #3689
  static level1 + #1151, #3689
  static level1 + #1152, #3689
  static level1 + #1153, #3689
  static level1 + #1154, #3694
  static level1 + #1155, #3967
  static level1 + #1156, #3967
  static level1 + #1157, #3967
  static level1 + #1158, #3967
  static level1 + #1159, #3967

  ;Linha 29
  static level1 + #1160, #3967
  static level1 + #1161, #3967
  static level1 + #1162, #3967
  static level1 + #1163, #3967
  static level1 + #1164, #3967
  static level1 + #1165, #3967
  static level1 + #1166, #3967
  static level1 + #1167, #3967
  static level1 + #1168, #3967
  static level1 + #1169, #3967
  static level1 + #1170, #3967
  static level1 + #1171, #3967
  static level1 + #1172, #3967
  static level1 + #1173, #3967
  static level1 + #1174, #3967
  static level1 + #1175, #3967
  static level1 + #1176, #3967
  static level1 + #1177, #3967
  static level1 + #1178, #3967
  static level1 + #1179, #3967
  static level1 + #1180, #3967
  static level1 + #1181, #3967
  static level1 + #1182, #3967
  static level1 + #1183, #3967
  static level1 + #1184, #3967
  static level1 + #1185, #3967
  static level1 + #1186, #3967
  static level1 + #1187, #3967
  static level1 + #1188, #3967
  static level1 + #1189, #3967
  static level1 + #1190, #3967
  static level1 + #1191, #3967
  static level1 + #1192, #3967
  static level1 + #1193, #3967
  static level1 + #1194, #3967
  static level1 + #1195, #3967
  static level1 + #1196, #3967
  static level1 + #1197, #3967
  static level1 + #1198, #3967
  static level1 + #1199, #3967


level2 : var #1200
  ;Linha 0
  static level2 + #0, #3967
  static level2 + #1, #3967
  static level2 + #2, #3967
  static level2 + #3, #3967
  static level2 + #4, #3967
  static level2 + #5, #3967
  static level2 + #6, #3967
  static level2 + #7, #3967
  static level2 + #8, #3967
  static level2 + #9, #3967
  static level2 + #10, #3967
  static level2 + #11, #3967
  static level2 + #12, #3967
  static level2 + #13, #3967
  static level2 + #14, #3967
  static level2 + #15, #3967
  static level2 + #16, #3967
  static level2 + #17, #3967
  static level2 + #18, #3967
  static level2 + #19, #3967
  static level2 + #20, #3967
  static level2 + #21, #3967
  static level2 + #22, #3967
  static level2 + #23, #3967
  static level2 + #24, #3967
  static level2 + #25, #3967
  static level2 + #26, #3967
  static level2 + #27, #3967
  static level2 + #28, #3967
  static level2 + #29, #3967
  static level2 + #30, #3967
  static level2 + #31, #3967
  static level2 + #32, #3967
  static level2 + #33, #3967
  static level2 + #34, #3967
  static level2 + #35, #3967
  static level2 + #36, #3967
  static level2 + #37, #3967
  static level2 + #38, #3967
  static level2 + #39, #3967

  ;Linha 1
  static level2 + #40, #3967
  static level2 + #41, #3967
  static level2 + #42, #3967
  static level2 + #43, #3967
  static level2 + #44, #3967
  static level2 + #45, #3967
  static level2 + #46, #3967
  static level2 + #47, #3967
  static level2 + #48, #3967
  static level2 + #49, #3967
  static level2 + #50, #3967
  static level2 + #51, #3967
  static level2 + #52, #3967
  static level2 + #53, #3967
  static level2 + #54, #3967
  static level2 + #55, #3967
  static level2 + #56, #3967
  static level2 + #57, #3967
  static level2 + #58, #3967
  static level2 + #59, #3967
  static level2 + #60, #3967
  static level2 + #61, #3967
  static level2 + #62, #3967
  static level2 + #63, #3967
  static level2 + #64, #3967
  static level2 + #65, #3967
  static level2 + #66, #3967
  static level2 + #67, #3967
  static level2 + #68, #3967
  static level2 + #69, #3967
  static level2 + #70, #3967
  static level2 + #71, #3967
  static level2 + #72, #3967
  static level2 + #73, #3967
  static level2 + #74, #3967
  static level2 + #75, #3967
  static level2 + #76, #3967
  static level2 + #77, #3967
  static level2 + #78, #3967
  static level2 + #79, #3967

  ;Linha 2
  static level2 + #80, #3967
  static level2 + #81, #3967
  static level2 + #82, #3967
  static level2 + #83, #3967
  static level2 + #84, #3967
  static level2 + #85, #3967
  static level2 + #86, #3967
  static level2 + #87, #3967
  static level2 + #88, #3967
  static level2 + #89, #3967
  static level2 + #90, #3967
  static level2 + #91, #3967
  static level2 + #92, #3967
  static level2 + #93, #3967
  static level2 + #94, #3967
  static level2 + #95, #3967
  static level2 + #96, #3967
  static level2 + #97, #3967
  static level2 + #98, #3967
  static level2 + #99, #3967
  static level2 + #100, #3967
  static level2 + #101, #3967
  static level2 + #102, #3967
  static level2 + #103, #3967
  static level2 + #104, #3967
  static level2 + #105, #3967
  static level2 + #106, #3967
  static level2 + #107, #3967
  static level2 + #108, #3967
  static level2 + #109, #3967
  static level2 + #110, #3967
  static level2 + #111, #3967
  static level2 + #112, #3967
  static level2 + #113, #3967
  static level2 + #114, #3967
  static level2 + #115, #3967
  static level2 + #116, #3967
  static level2 + #117, #3967
  static level2 + #118, #3967
  static level2 + #119, #3967

  ;Linha 3
  static level2 + #120, #3967
  static level2 + #121, #3967
  static level2 + #122, #3967
  static level2 + #123, #3967
  static level2 + #124, #3967
  static level2 + #125, #3967
  static level2 + #126, #3967
  static level2 + #127, #3967
  static level2 + #128, #3967
  static level2 + #129, #3967
  static level2 + #130, #3967
  static level2 + #131, #3967
  static level2 + #132, #3967
  static level2 + #133, #3967
  static level2 + #134, #3967
  static level2 + #135, #3967
  static level2 + #136, #3967
  static level2 + #137, #3967
  static level2 + #138, #3967
  static level2 + #139, #3967
  static level2 + #140, #3967
  static level2 + #141, #3967
  static level2 + #142, #3967
  static level2 + #143, #3967
  static level2 + #144, #3967
  static level2 + #145, #3967
  static level2 + #146, #3967
  static level2 + #147, #3967
  static level2 + #148, #3967
  static level2 + #149, #3967
  static level2 + #150, #3967
  static level2 + #151, #3967
  static level2 + #152, #3967
  static level2 + #153, #3967
  static level2 + #154, #3967
  static level2 + #155, #3967
  static level2 + #156, #3967
  static level2 + #157, #3967
  static level2 + #158, #3967
  static level2 + #159, #3967

  ;Linha 4
  static level2 + #160, #3967
  static level2 + #161, #3967
  static level2 + #162, #3967
  static level2 + #163, #3967
  static level2 + #164, #3696
  static level2 + #165, #3690
  static level2 + #166, #3690
  static level2 + #167, #3690
  static level2 + #168, #3690
  static level2 + #169, #3690
  static level2 + #170, #3690
  static level2 + #171, #3690
  static level2 + #172, #3690
  static level2 + #173, #3690
  static level2 + #174, #3690
  static level2 + #175, #3690
  static level2 + #176, #3690
  static level2 + #177, #3690
  static level2 + #178, #3690
  static level2 + #179, #3690
  static level2 + #180, #3690
  static level2 + #181, #3690
  static level2 + #182, #3690
  static level2 + #183, #3690
  static level2 + #184, #3690
  static level2 + #185, #3690
  static level2 + #186, #3690
  static level2 + #187, #3690
  static level2 + #188, #3690
  static level2 + #189, #3690
  static level2 + #190, #3690
  static level2 + #191, #3690
  static level2 + #192, #3690
  static level2 + #193, #3690
  static level2 + #194, #3693
  static level2 + #195, #3967
  static level2 + #196, #3967
  static level2 + #197, #3967
  static level2 + #198, #3967
  static level2 + #199, #3967

  ;Linha 5
  static level2 + #200, #3967
  static level2 + #201, #3967
  static level2 + #202, #3967
  static level2 + #203, #3967
  static level2 + #204, #3692
  static level2 + #205, #15
  static level2 + #206, #15
  static level2 + #207, #15
  static level2 + #208, #15
  static level2 + #209, #45
  static level2 + #210, #45
  static level2 + #211, #45
  static level2 + #212, #45
  static level2 + #213, #45
  static level2 + #214, #45
  static level2 + #215, #45
  static level2 + #216, #45
  static level2 + #217, #15
  static level2 + #218, #15
  static level2 + #219, #15
  static level2 + #220, #15
  static level2 + #221, #15
  static level2 + #222, #45
  static level2 + #223, #45
  static level2 + #224, #45
  static level2 + #225, #45
  static level2 + #226, #45
  static level2 + #227, #45
  static level2 + #228, #45
  static level2 + #229, #45
  static level2 + #230, #15
  static level2 + #231, #15
  static level2 + #232, #15
  static level2 + #233, #2835
  static level2 + #234, #3691
  static level2 + #235, #3967
  static level2 + #236, #3967
  static level2 + #237, #3967
  static level2 + #238, #3967
  static level2 + #239, #3967

  ;Linha 6
  static level2 + #240, #3967
  static level2 + #241, #3967
  static level2 + #242, #3967
  static level2 + #243, #3967
  static level2 + #244, #3692
  static level2 + #245, #15
  static level2 + #246, #2835
  static level2 + #247, #15
  static level2 + #248, #15
  static level2 + #249, #45
  static level2 + #250, #45
  static level2 + #251, #45
  static level2 + #252, #45
  static level2 + #253, #45
  static level2 + #254, #45
  static level2 + #255, #45
  static level2 + #256, #45
  static level2 + #257, #15
  static level2 + #258, #15
  static level2 + #259, #15
  static level2 + #260, #15
  static level2 + #261, #15
  static level2 + #262, #45
  static level2 + #263, #45
  static level2 + #264, #45
  static level2 + #265, #45
  static level2 + #266, #45
  static level2 + #267, #45
  static level2 + #268, #45
  static level2 + #269, #45
  static level2 + #270, #15
  static level2 + #271, #15
  static level2 + #272, #15
  static level2 + #273, #15
  static level2 + #274, #3691
  static level2 + #275, #3967
  static level2 + #276, #3967
  static level2 + #277, #3967
  static level2 + #278, #3967
  static level2 + #279, #3967

  ;Linha 7
  static level2 + #280, #3967
  static level2 + #281, #3967
  static level2 + #282, #3967
  static level2 + #283, #3967
  static level2 + #284, #3692
  static level2 + #285, #15
  static level2 + #286, #15
  static level2 + #287, #15
  static level2 + #288, #15
  static level2 + #289, #2909
  static level2 + #290, #3421
  static level2 + #291, #3421
  static level2 + #292, #1556
  static level2 + #293, #31
  static level2 + #294, #2909
  static level2 + #295, #3421
  static level2 + #296, #2909
  static level2 + #297, #15
  static level2 + #298, #15
  static level2 + #299, #15
  static level2 + #300, #15
  static level2 + #301, #2835
  static level2 + #302, #3421
  static level2 + #303, #2909
  static level2 + #304, #3421
  static level2 + #305, #15
  static level2 + #306, #15
  static level2 + #307, #15
  static level2 + #308, #3421
  static level2 + #309, #3421
  static level2 + #310, #15
  static level2 + #311, #15
  static level2 + #312, #15
  static level2 + #313, #15
  static level2 + #314, #3691
  static level2 + #315, #3967
  static level2 + #316, #3967
  static level2 + #317, #3967
  static level2 + #318, #3967
  static level2 + #319, #3967

  ;Linha 8
  static level2 + #320, #3967
  static level2 + #321, #3967
  static level2 + #322, #3967
  static level2 + #323, #3967
  static level2 + #324, #3692
  static level2 + #325, #15
  static level2 + #326, #15
  static level2 + #327, #15
  static level2 + #328, #15
  static level2 + #329, #3421
  static level2 + #330, #2909
  static level2 + #331, #3421
  static level2 + #332, #31
  static level2 + #333, #31
  static level2 + #334, #3421
  static level2 + #335, #3421
  static level2 + #336, #3421
  static level2 + #337, #15
  static level2 + #338, #15
  static level2 + #339, #15
  static level2 + #340, #15
  static level2 + #341, #15
  static level2 + #342, #3421
  static level2 + #343, #3421
  static level2 + #344, #3421
  static level2 + #345, #15
  static level2 + #346, #15
  static level2 + #347, #15
  static level2 + #348, #2909
  static level2 + #349, #3421
  static level2 + #350, #15
  static level2 + #351, #15
  static level2 + #352, #15
  static level2 + #353, #15
  static level2 + #354, #3691
  static level2 + #355, #3967
  static level2 + #356, #3967
  static level2 + #357, #3967
  static level2 + #358, #3967
  static level2 + #359, #3967

  ;Linha 9
  static level2 + #360, #3967
  static level2 + #361, #3967
  static level2 + #362, #3967
  static level2 + #363, #3967
  static level2 + #364, #3692
  static level2 + #365, #15
  static level2 + #366, #15
  static level2 + #367, #15
  static level2 + #368, #15
  static level2 + #369, #31
  static level2 + #370, #31
  static level2 + #371, #31
  static level2 + #372, #31
  static level2 + #373, #31
  static level2 + #374, #31
  static level2 + #375, #31
  static level2 + #376, #31
  static level2 + #377, #15
  static level2 + #378, #15
  static level2 + #379, #15
  static level2 + #380, #15
  static level2 + #381, #15
  static level2 + #382, #45
  static level2 + #383, #45
  static level2 + #384, #45
  static level2 + #385, #45
  static level2 + #386, #45
  static level2 + #387, #45
  static level2 + #388, #3421
  static level2 + #389, #3421
  static level2 + #390, #15
  static level2 + #391, #15
  static level2 + #392, #15
  static level2 + #393, #15
  static level2 + #394, #3691
  static level2 + #395, #3967
  static level2 + #396, #3967
  static level2 + #397, #3967
  static level2 + #398, #3967
  static level2 + #399, #3967

  ;Linha 10
  static level2 + #400, #3967
  static level2 + #401, #3967
  static level2 + #402, #3967
  static level2 + #403, #3967
  static level2 + #404, #3692
  static level2 + #405, #15
  static level2 + #406, #15
  static level2 + #407, #15
  static level2 + #408, #15
  static level2 + #409, #31
  static level2 + #410, #31
  static level2 + #411, #31
  static level2 + #412, #31
  static level2 + #413, #31
  static level2 + #414, #3421
  static level2 + #415, #3421
  static level2 + #416, #3421
  static level2 + #417, #15
  static level2 + #418, #15
  static level2 + #419, #15
  static level2 + #420, #15
  static level2 + #421, #15
  static level2 + #422, #45
  static level2 + #423, #45
  static level2 + #424, #45
  static level2 + #425, #45
  static level2 + #426, #2849
  static level2 + #427, #45
  static level2 + #428, #3421
  static level2 + #429, #2909
  static level2 + #430, #15
  static level2 + #431, #15
  static level2 + #432, #1556
  static level2 + #433, #15
  static level2 + #434, #3691
  static level2 + #435, #3967
  static level2 + #436, #3967
  static level2 + #437, #3967
  static level2 + #438, #3967
  static level2 + #439, #3967

  ;Linha 11
  static level2 + #440, #3967
  static level2 + #441, #3967
  static level2 + #442, #3967
  static level2 + #443, #3967
  static level2 + #444, #3692
  static level2 + #445, #15
  static level2 + #446, #15
  static level2 + #447, #15
  static level2 + #448, #15
  static level2 + #449, #3421
  static level2 + #450, #3421
  static level2 + #451, #2909
  static level2 + #452, #31
  static level2 + #453, #31
  static level2 + #454, #3421
  static level2 + #455, #2909
  static level2 + #456, #3421
  static level2 + #457, #15
  static level2 + #458, #15
  static level2 + #459, #15
  static level2 + #460, #15
  static level2 + #461, #15
  static level2 + #462, #45
  static level2 + #463, #45
  static level2 + #464, #45
  static level2 + #465, #45
  static level2 + #466, #45
  static level2 + #467, #45
  static level2 + #468, #3421
  static level2 + #469, #3421
  static level2 + #470, #15
  static level2 + #471, #15
  static level2 + #472, #15
  static level2 + #473, #15
  static level2 + #474, #3691
  static level2 + #475, #3967
  static level2 + #476, #3967
  static level2 + #477, #3967
  static level2 + #478, #3967
  static level2 + #479, #3967

  ;Linha 12
  static level2 + #480, #3967
  static level2 + #481, #3967
  static level2 + #482, #3967
  static level2 + #483, #3967
  static level2 + #484, #3692
  static level2 + #485, #15
  static level2 + #486, #15
  static level2 + #487, #15
  static level2 + #488, #15
  static level2 + #489, #2909
  static level2 + #490, #3421
  static level2 + #491, #3421
  static level2 + #492, #31
  static level2 + #493, #31
  static level2 + #494, #31
  static level2 + #495, #31
  static level2 + #496, #31
  static level2 + #497, #15
  static level2 + #498, #15
  static level2 + #499, #15
  static level2 + #500, #15
  static level2 + #501, #15
  static level2 + #502, #2909
  static level2 + #503, #3421
  static level2 + #504, #2909
  static level2 + #505, #15
  static level2 + #506, #15
  static level2 + #507, #15
  static level2 + #508, #2909
  static level2 + #509, #3421
  static level2 + #510, #15
  static level2 + #511, #15
  static level2 + #512, #15
  static level2 + #513, #15
  static level2 + #514, #3691
  static level2 + #515, #3967
  static level2 + #516, #3967
  static level2 + #517, #3967
  static level2 + #518, #3967
  static level2 + #519, #3967

  ;Linha 13
  static level2 + #520, #3967
  static level2 + #521, #3967
  static level2 + #522, #3967
  static level2 + #523, #3967
  static level2 + #524, #3692
  static level2 + #525, #15
  static level2 + #526, #15
  static level2 + #527, #15
  static level2 + #528, #15
  static level2 + #529, #3421
  static level2 + #530, #2909
  static level2 + #531, #3421
  static level2 + #532, #31
  static level2 + #533, #31
  static level2 + #534, #3421
  static level2 + #535, #3421
  static level2 + #536, #3421
  static level2 + #537, #15
  static level2 + #538, #2831
  static level2 + #539, #2831
  static level2 + #540, #2831
  static level2 + #541, #15
  static level2 + #542, #3421
  static level2 + #543, #3421
  static level2 + #544, #3421
  static level2 + #545, #15
  static level2 + #546, #15
  static level2 + #547, #15
  static level2 + #548, #3421
  static level2 + #549, #3421
  static level2 + #550, #15
  static level2 + #551, #15
  static level2 + #552, #15
  static level2 + #553, #15
  static level2 + #554, #3691
  static level2 + #555, #3967
  static level2 + #556, #3967
  static level2 + #557, #3967
  static level2 + #558, #3967
  static level2 + #559, #3967

  ;Linha 14
  static level2 + #560, #3967
  static level2 + #561, #3967
  static level2 + #562, #3967
  static level2 + #563, #3967
  static level2 + #564, #3692
  static level2 + #565, #3421
  static level2 + #566, #3421
  static level2 + #567, #15
  static level2 + #568, #15
  static level2 + #569, #45
  static level2 + #570, #45
  static level2 + #571, #45
  static level2 + #572, #45
  static level2 + #573, #45
  static level2 + #574, #45
  static level2 + #575, #45
  static level2 + #576, #45
  static level2 + #577, #15
  static level2 + #578, #2831
  static level2 + #579, #2859
  static level2 + #580, #2831
  static level2 + #581, #15
  static level2 + #582, #45
  static level2 + #583, #45
  static level2 + #584, #45
  static level2 + #585, #45
  static level2 + #586, #45
  static level2 + #587, #45
  static level2 + #588, #45
  static level2 + #589, #45
  static level2 + #590, #15
  static level2 + #591, #15
  static level2 + #592, #15
  static level2 + #593, #15
  static level2 + #594, #3691
  static level2 + #595, #3967
  static level2 + #596, #3967
  static level2 + #597, #3967
  static level2 + #598, #3967
  static level2 + #599, #3967

  ;Linha 15
  static level2 + #600, #3967
  static level2 + #601, #3967
  static level2 + #602, #3967
  static level2 + #603, #3967
  static level2 + #604, #3692
  static level2 + #605, #15
  static level2 + #606, #15
  static level2 + #607, #15
  static level2 + #608, #15
  static level2 + #609, #45
  static level2 + #610, #45
  static level2 + #611, #45
  static level2 + #612, #45
  static level2 + #613, #45
  static level2 + #614, #45
  static level2 + #615, #45
  static level2 + #616, #45
  static level2 + #617, #15
  static level2 + #618, #2831
  static level2 + #619, #2831
  static level2 + #620, #2831
  static level2 + #621, #15
  static level2 + #622, #45
  static level2 + #623, #45
  static level2 + #624, #45
  static level2 + #625, #45
  static level2 + #626, #2835
  static level2 + #627, #45
  static level2 + #628, #45
  static level2 + #629, #45
  static level2 + #630, #15
  static level2 + #631, #15
  static level2 + #632, #15
  static level2 + #633, #15
  static level2 + #634, #3691
  static level2 + #635, #3967
  static level2 + #636, #3967
  static level2 + #637, #3967
  static level2 + #638, #3967
  static level2 + #639, #3967

  ;Linha 16
  static level2 + #640, #3967
  static level2 + #641, #3967
  static level2 + #642, #3967
  static level2 + #643, #3967
  static level2 + #644, #3692
  static level2 + #645, #15
  static level2 + #646, #2835
  static level2 + #647, #15
  static level2 + #648, #15
  static level2 + #649, #3421
  static level2 + #650, #3421
  static level2 + #651, #31
  static level2 + #652, #3421
  static level2 + #653, #3421
  static level2 + #654, #3421
  static level2 + #655, #31
  static level2 + #656, #3421
  static level2 + #657, #15
  static level2 + #658, #15
  static level2 + #659, #15
  static level2 + #660, #15
  static level2 + #661, #15
  static level2 + #662, #3421
  static level2 + #663, #2909
  static level2 + #664, #31
  static level2 + #665, #31
  static level2 + #666, #31
  static level2 + #667, #3421
  static level2 + #668, #3421
  static level2 + #669, #3421
  static level2 + #670, #15
  static level2 + #671, #15
  static level2 + #672, #15
  static level2 + #673, #15
  static level2 + #674, #3691
  static level2 + #675, #3967
  static level2 + #676, #3967
  static level2 + #677, #3967
  static level2 + #678, #3967
  static level2 + #679, #3967

  ;Linha 17
  static level2 + #680, #3967
  static level2 + #681, #3967
  static level2 + #682, #3967
  static level2 + #683, #3967
  static level2 + #684, #3692
  static level2 + #685, #15
  static level2 + #686, #15
  static level2 + #687, #15
  static level2 + #688, #15
  static level2 + #689, #3421
  static level2 + #690, #3421
  static level2 + #691, #31
  static level2 + #692, #3421
  static level2 + #693, #31
  static level2 + #694, #3421
  static level2 + #695, #31
  static level2 + #696, #3421
  static level2 + #697, #15
  static level2 + #698, #15
  static level2 + #699, #15
  static level2 + #700, #15
  static level2 + #701, #15
  static level2 + #702, #3421
  static level2 + #703, #3421
  static level2 + #704, #31
  static level2 + #705, #31
  static level2 + #706, #31
  static level2 + #707, #31
  static level2 + #708, #2909
  static level2 + #709, #3421
  static level2 + #710, #15
  static level2 + #711, #15
  static level2 + #712, #15
  static level2 + #713, #15
  static level2 + #714, #3691
  static level2 + #715, #3967
  static level2 + #716, #3967
  static level2 + #717, #3967
  static level2 + #718, #3967
  static level2 + #719, #3967

  ;Linha 18
  static level2 + #720, #3967
  static level2 + #721, #3967
  static level2 + #722, #3967
  static level2 + #723, #3967
  static level2 + #724, #3692
  static level2 + #725, #15
  static level2 + #726, #15
  static level2 + #727, #15
  static level2 + #728, #15
  static level2 + #729, #45
  static level2 + #730, #45
  static level2 + #731, #45
  static level2 + #732, #1301
  static level2 + #733, #45
  static level2 + #734, #45
  static level2 + #735, #45
  static level2 + #736, #45
  static level2 + #737, #15
  static level2 + #738, #15
  static level2 + #739, #15
  static level2 + #740, #15
  static level2 + #741, #15
  static level2 + #742, #2909
  static level2 + #743, #3421
  static level2 + #744, #3421
  static level2 + #745, #31
  static level2 + #746, #31
  static level2 + #747, #31
  static level2 + #748, #3421
  static level2 + #749, #2909
  static level2 + #750, #15
  static level2 + #751, #15
  static level2 + #752, #15
  static level2 + #753, #2835
  static level2 + #754, #3691
  static level2 + #755, #3967
  static level2 + #756, #3967
  static level2 + #757, #3967
  static level2 + #758, #3967
  static level2 + #759, #3967

  ;Linha 19
  static level2 + #760, #3967
  static level2 + #761, #3967
  static level2 + #762, #3967
  static level2 + #763, #3967
  static level2 + #764, #3692
  static level2 + #765, #15
  static level2 + #766, #15
  static level2 + #767, #15
  static level2 + #768, #15
  static level2 + #769, #45
  static level2 + #770, #45
  static level2 + #771, #45
  static level2 + #772, #45
  static level2 + #773, #45
  static level2 + #774, #45
  static level2 + #775, #45
  static level2 + #776, #45
  static level2 + #777, #15
  static level2 + #778, #15
  static level2 + #779, #15
  static level2 + #780, #15
  static level2 + #781, #15
  static level2 + #782, #3421
  static level2 + #783, #3421
  static level2 + #784, #2909
  static level2 + #785, #2909
  static level2 + #786, #31
  static level2 + #787, #31
  static level2 + #788, #2909
  static level2 + #789, #3421
  static level2 + #790, #15
  static level2 + #791, #15
  static level2 + #792, #15
  static level2 + #793, #15
  static level2 + #794, #3691
  static level2 + #795, #3967
  static level2 + #796, #3967
  static level2 + #797, #3967
  static level2 + #798, #3967
  static level2 + #799, #3967

  ;Linha 20
  static level2 + #800, #3967
  static level2 + #801, #3967
  static level2 + #802, #3967
  static level2 + #803, #3967
  static level2 + #804, #3692
  static level2 + #805, #15
  static level2 + #806, #15
  static level2 + #807, #15
  static level2 + #808, #15
  static level2 + #809, #3421
  static level2 + #810, #3421
  static level2 + #811, #31
  static level2 + #812, #31
  static level2 + #813, #3421
  static level2 + #814, #31
  static level2 + #815, #3421
  static level2 + #816, #3421
  static level2 + #817, #15
  static level2 + #818, #15
  static level2 + #819, #15
  static level2 + #820, #15
  static level2 + #821, #15
  static level2 + #822, #2653
  static level2 + #823, #2653
  static level2 + #824, #2653
  static level2 + #825, #3421
  static level2 + #826, #31
  static level2 + #827, #1556
  static level2 + #828, #3421
  static level2 + #829, #2909
  static level2 + #830, #3421
  static level2 + #831, #3421
  static level2 + #832, #15
  static level2 + #833, #15
  static level2 + #834, #3691
  static level2 + #835, #3967
  static level2 + #836, #3967
  static level2 + #837, #3967
  static level2 + #838, #3967
  static level2 + #839, #3967

  ;Linha 21
  static level2 + #840, #3967
  static level2 + #841, #3967
  static level2 + #842, #3967
  static level2 + #843, #3967
  static level2 + #844, #3692
  static level2 + #845, #15
  static level2 + #846, #15
  static level2 + #847, #15
  static level2 + #848, #15
  static level2 + #849, #3421
  static level2 + #850, #31
  static level2 + #851, #31
  static level2 + #852, #2835
  static level2 + #853, #3421
  static level2 + #854, #31
  static level2 + #855, #3421
  static level2 + #856, #3421
  static level2 + #857, #15
  static level2 + #858, #15
  static level2 + #859, #15
  static level2 + #860, #15
  static level2 + #861, #15
  static level2 + #862, #861
  static level2 + #863, #2653
  static level2 + #864, #2653
  static level2 + #865, #2653
  static level2 + #866, #2653
  static level2 + #867, #2653
  static level2 + #868, #2909
  static level2 + #869, #2909
  static level2 + #870, #15
  static level2 + #871, #15
  static level2 + #872, #15
  static level2 + #873, #15
  static level2 + #874, #3691
  static level2 + #875, #3967
  static level2 + #876, #3967
  static level2 + #877, #3967
  static level2 + #878, #3967
  static level2 + #879, #3967

  ;Linha 22
  static level2 + #880, #3967
  static level2 + #881, #3967
  static level2 + #882, #3967
  static level2 + #883, #3967
  static level2 + #884, #3692
  static level2 + #885, #15
  static level2 + #886, #15
  static level2 + #887, #15
  static level2 + #888, #15
  static level2 + #889, #45
  static level2 + #890, #45
  static level2 + #891, #45
  static level2 + #892, #45
  static level2 + #893, #45
  static level2 + #894, #45
  static level2 + #895, #45
  static level2 + #896, #45
  static level2 + #897, #15
  static level2 + #898, #15
  static level2 + #899, #15
  static level2 + #900, #15
  static level2 + #901, #15
  static level2 + #902, #861
  static level2 + #903, #861
  static level2 + #904, #2653
  static level2 + #905, #2653
  static level2 + #906, #861
  static level2 + #907, #861
  static level2 + #908, #3421
  static level2 + #909, #3421
  static level2 + #910, #15
  static level2 + #911, #15
  static level2 + #912, #15
  static level2 + #913, #15
  static level2 + #914, #3691
  static level2 + #915, #3967
  static level2 + #916, #3967
  static level2 + #917, #3967
  static level2 + #918, #3967
  static level2 + #919, #3967

  ;Linha 23
  static level2 + #920, #3967
  static level2 + #921, #3967
  static level2 + #922, #3967
  static level2 + #923, #3967
  static level2 + #924, #3692
  static level2 + #925, #15
  static level2 + #926, #15
  static level2 + #927, #15
  static level2 + #928, #15
  static level2 + #929, #45
  static level2 + #930, #45
  static level2 + #931, #45
  static level2 + #932, #45
  static level2 + #933, #45
  static level2 + #934, #45
  static level2 + #935, #45
  static level2 + #936, #45
  static level2 + #937, #15
  static level2 + #938, #15
  static level2 + #939, #2835
  static level2 + #940, #15
  static level2 + #941, #15
  static level2 + #942, #861
  static level2 + #943, #861
  static level2 + #944, #2653
  static level2 + #945, #2653
  static level2 + #946, #861
  static level2 + #947, #861
  static level2 + #948, #2653
  static level2 + #949, #2653
  static level2 + #950, #15
  static level2 + #951, #15
  static level2 + #952, #15
  static level2 + #953, #15
  static level2 + #954, #3691
  static level2 + #955, #3967
  static level2 + #956, #3967
  static level2 + #957, #3967
  static level2 + #958, #3967
  static level2 + #959, #3967

  ;Linha 24
  static level2 + #960, #3967
  static level2 + #961, #3967
  static level2 + #962, #3967
  static level2 + #963, #3967
  static level2 + #964, #3692
  static level2 + #965, #15
  static level2 + #966, #15
  static level2 + #967, #15
  static level2 + #968, #15
  static level2 + #969, #3421
  static level2 + #970, #31
  static level2 + #971, #3421
  static level2 + #972, #31
  static level2 + #973, #3421
  static level2 + #974, #31
  static level2 + #975, #3421
  static level2 + #976, #31
  static level2 + #977, #15
  static level2 + #978, #15
  static level2 + #979, #15
  static level2 + #980, #15
  static level2 + #981, #15
  static level2 + #982, #861
  static level2 + #983, #2653
  static level2 + #984, #2653
  static level2 + #985, #2653
  static level2 + #986, #2653
  static level2 + #987, #2653
  static level2 + #988, #2653
  static level2 + #989, #861
  static level2 + #990, #15
  static level2 + #991, #15
  static level2 + #992, #15
  static level2 + #993, #15
  static level2 + #994, #3691
  static level2 + #995, #3967
  static level2 + #996, #3967
  static level2 + #997, #3967
  static level2 + #998, #3967
  static level2 + #999, #3967

  ;Linha 25
  static level2 + #1000, #3967
  static level2 + #1001, #3967
  static level2 + #1002, #3967
  static level2 + #1003, #3967
  static level2 + #1004, #3692
  static level2 + #1005, #15
  static level2 + #1006, #15
  static level2 + #1007, #15
  static level2 + #1008, #15
  static level2 + #1009, #3421
  static level2 + #1010, #31
  static level2 + #1011, #3421
  static level2 + #1012, #31
  static level2 + #1013, #3421
  static level2 + #1014, #31
  static level2 + #1015, #3421
  static level2 + #1016, #31
  static level2 + #1017, #15
  static level2 + #1018, #15
  static level2 + #1019, #15
  static level2 + #1020, #15
  static level2 + #1021, #15
  static level2 + #1022, #2653
  static level2 + #1023, #2653
  static level2 + #1024, #2653
  static level2 + #1025, #2653
  static level2 + #1026, #2653
  static level2 + #1027, #2653
  static level2 + #1028, #861
  static level2 + #1029, #861
  static level2 + #1030, #15
  static level2 + #1031, #15
  static level2 + #1032, #3421
  static level2 + #1033, #3421
  static level2 + #1034, #3691
  static level2 + #1035, #3967
  static level2 + #1036, #3967
  static level2 + #1037, #3967
  static level2 + #1038, #3967
  static level2 + #1039, #3967

  ;Linha 26
  static level2 + #1040, #3967
  static level2 + #1041, #3967
  static level2 + #1042, #3967
  static level2 + #1043, #3967
  static level2 + #1044, #3692
  static level2 + #1045, #15
  static level2 + #1046, #1556
  static level2 + #1047, #15
  static level2 + #1048, #15
  static level2 + #1049, #45
  static level2 + #1050, #45
  static level2 + #1051, #45
  static level2 + #1052, #45
  static level2 + #1053, #45
  static level2 + #1054, #45
  static level2 + #1055, #45
  static level2 + #1056, #45
  static level2 + #1057, #15
  static level2 + #1058, #15
  static level2 + #1059, #15
  static level2 + #1060, #15
  static level2 + #1061, #15
  static level2 + #1062, #45
  static level2 + #1063, #45
  static level2 + #1064, #45
  static level2 + #1065, #45
  static level2 + #1066, #45
  static level2 + #1067, #45
  static level2 + #1068, #45
  static level2 + #1069, #45
  static level2 + #1070, #15
  static level2 + #1071, #15
  static level2 + #1072, #2835
  static level2 + #1073, #15
  static level2 + #1074, #3691
  static level2 + #1075, #3967
  static level2 + #1076, #3967
  static level2 + #1077, #3967
  static level2 + #1078, #3967
  static level2 + #1079, #3967

  ;Linha 27
  static level2 + #1080, #3967
  static level2 + #1081, #3967
  static level2 + #1082, #3967
  static level2 + #1083, #3967
  static level2 + #1084, #3692
  static level2 + #1085, #15
  static level2 + #1086, #15
  static level2 + #1087, #15
  static level2 + #1088, #15
  static level2 + #1089, #45
  static level2 + #1090, #45
  static level2 + #1091, #45
  static level2 + #1092, #45
  static level2 + #1093, #45
  static level2 + #1094, #45
  static level2 + #1095, #1556
  static level2 + #1096, #45
  static level2 + #1097, #15
  static level2 + #1098, #15
  static level2 + #1099, #15
  static level2 + #1100, #15
  static level2 + #1101, #15
  static level2 + #1102, #45
  static level2 + #1103, #45
  static level2 + #1104, #45
  static level2 + #1105, #45
  static level2 + #1106, #45
  static level2 + #1107, #45
  static level2 + #1108, #45
  static level2 + #1109, #45
  static level2 + #1110, #15
  static level2 + #1111, #15
  static level2 + #1112, #15
  static level2 + #1113, #15
  static level2 + #1114, #3691
  static level2 + #1115, #3967
  static level2 + #1116, #3967
  static level2 + #1117, #3967
  static level2 + #1118, #3967
  static level2 + #1119, #3967

  ;Linha 28
  static level2 + #1120, #3967
  static level2 + #1121, #3967
  static level2 + #1122, #3967
  static level2 + #1123, #3967
  static level2 + #1124, #3695
  static level2 + #1125, #3689
  static level2 + #1126, #3689
  static level2 + #1127, #3689
  static level2 + #1128, #3689
  static level2 + #1129, #3689
  static level2 + #1130, #3689
  static level2 + #1131, #3689
  static level2 + #1132, #3689
  static level2 + #1133, #3689
  static level2 + #1134, #3689
  static level2 + #1135, #3689
  static level2 + #1136, #3689
  static level2 + #1137, #3689
  static level2 + #1138, #3689
  static level2 + #1139, #3689
  static level2 + #1140, #3689
  static level2 + #1141, #3689
  static level2 + #1142, #3689
  static level2 + #1143, #3689
  static level2 + #1144, #3689
  static level2 + #1145, #3689
  static level2 + #1146, #3689
  static level2 + #1147, #3689
  static level2 + #1148, #3689
  static level2 + #1149, #3689
  static level2 + #1150, #3689
  static level2 + #1151, #3689
  static level2 + #1152, #3689
  static level2 + #1153, #3689
  static level2 + #1154, #3694
  static level2 + #1155, #3967
  static level2 + #1156, #3967
  static level2 + #1157, #3967
  static level2 + #1158, #3967
  static level2 + #1159, #3967

  ;Linha 29
  static level2 + #1160, #3967
  static level2 + #1161, #3967
  static level2 + #1162, #3967
  static level2 + #1163, #3967
  static level2 + #1164, #3967
  static level2 + #1165, #3967
  static level2 + #1166, #3967
  static level2 + #1167, #3967
  static level2 + #1168, #3967
  static level2 + #1169, #3967
  static level2 + #1170, #3967
  static level2 + #1171, #3967
  static level2 + #1172, #3967
  static level2 + #1173, #3967
  static level2 + #1174, #3967
  static level2 + #1175, #3967
  static level2 + #1176, #3967
  static level2 + #1177, #3967
  static level2 + #1178, #3967
  static level2 + #1179, #3967
  static level2 + #1180, #3967
  static level2 + #1181, #3967
  static level2 + #1182, #3967
  static level2 + #1183, #3967
  static level2 + #1184, #3967
  static level2 + #1185, #3967
  static level2 + #1186, #3967
  static level2 + #1187, #3967
  static level2 + #1188, #3967
  static level2 + #1189, #3967
  static level2 + #1190, #3967
  static level2 + #1191, #3967
  static level2 + #1192, #3967
  static level2 + #1193, #3967
  static level2 + #1194, #3967
  static level2 + #1195, #3967
  static level2 + #1196, #3967
  static level2 + #1197, #3967
  static level2 + #1198, #3967
  static level2 + #1199, #3967




level3 : var #1200
  ;Linha 0
  static level3 + #0, #3967
  static level3 + #1, #3967
  static level3 + #2, #3967
  static level3 + #3, #3967
  static level3 + #4, #3967
  static level3 + #5, #3967
  static level3 + #6, #3967
  static level3 + #7, #3967
  static level3 + #8, #3967
  static level3 + #9, #3967
  static level3 + #10, #3967
  static level3 + #11, #3967
  static level3 + #12, #3967
  static level3 + #13, #3967
  static level3 + #14, #3967
  static level3 + #15, #3967
  static level3 + #16, #3967
  static level3 + #17, #3967
  static level3 + #18, #3967
  static level3 + #19, #3967
  static level3 + #20, #3967
  static level3 + #21, #3967
  static level3 + #22, #3967
  static level3 + #23, #3967
  static level3 + #24, #3967
  static level3 + #25, #3967
  static level3 + #26, #3967
  static level3 + #27, #3967
  static level3 + #28, #3967
  static level3 + #29, #3967
  static level3 + #30, #3967
  static level3 + #31, #3967
  static level3 + #32, #3967
  static level3 + #33, #3967
  static level3 + #34, #3967
  static level3 + #35, #3967
  static level3 + #36, #3967
  static level3 + #37, #3967
  static level3 + #38, #3967
  static level3 + #39, #3967

  ;Linha 1
  static level3 + #40, #3967
  static level3 + #41, #3967
  static level3 + #42, #3967
  static level3 + #43, #3967
  static level3 + #44, #3967
  static level3 + #45, #3967
  static level3 + #46, #3967
  static level3 + #47, #3967
  static level3 + #48, #3967
  static level3 + #49, #3967
  static level3 + #50, #3967
  static level3 + #51, #3967
  static level3 + #52, #3967
  static level3 + #53, #3967
  static level3 + #54, #3967
  static level3 + #55, #3967
  static level3 + #56, #3967
  static level3 + #57, #3967
  static level3 + #58, #3967
  static level3 + #59, #3967
  static level3 + #60, #3967
  static level3 + #61, #3967
  static level3 + #62, #3967
  static level3 + #63, #3967
  static level3 + #64, #3967
  static level3 + #65, #3967
  static level3 + #66, #3967
  static level3 + #67, #3967
  static level3 + #68, #3967
  static level3 + #69, #3967
  static level3 + #70, #3967
  static level3 + #71, #3967
  static level3 + #72, #3967
  static level3 + #73, #3967
  static level3 + #74, #3967
  static level3 + #75, #3967
  static level3 + #76, #3967
  static level3 + #77, #3967
  static level3 + #78, #3967
  static level3 + #79, #3967

  ;Linha 2
  static level3 + #80, #3967
  static level3 + #81, #3967
  static level3 + #82, #3967
  static level3 + #83, #3967
  static level3 + #84, #3967
  static level3 + #85, #3967
  static level3 + #86, #3967
  static level3 + #87, #3967
  static level3 + #88, #3967
  static level3 + #89, #3967
  static level3 + #90, #3967
  static level3 + #91, #3967
  static level3 + #92, #3967
  static level3 + #93, #3967
  static level3 + #94, #3967
  static level3 + #95, #3967
  static level3 + #96, #3967
  static level3 + #97, #3967
  static level3 + #98, #3967
  static level3 + #99, #3967
  static level3 + #100, #3967
  static level3 + #101, #3967
  static level3 + #102, #3967
  static level3 + #103, #3967
  static level3 + #104, #3967
  static level3 + #105, #3967
  static level3 + #106, #3967
  static level3 + #107, #3967
  static level3 + #108, #3967
  static level3 + #109, #3967
  static level3 + #110, #3967
  static level3 + #111, #3967
  static level3 + #112, #3967
  static level3 + #113, #3967
  static level3 + #114, #3967
  static level3 + #115, #3967
  static level3 + #116, #3967
  static level3 + #117, #3967
  static level3 + #118, #3967
  static level3 + #119, #3967

  ;Linha 3
  static level3 + #120, #3967
  static level3 + #121, #3967
  static level3 + #122, #3967
  static level3 + #123, #3967
  static level3 + #124, #3967
  static level3 + #125, #3967
  static level3 + #126, #3967
  static level3 + #127, #3967
  static level3 + #128, #3967
  static level3 + #129, #3967
  static level3 + #130, #3967
  static level3 + #131, #3967
  static level3 + #132, #3967
  static level3 + #133, #3967
  static level3 + #134, #3967
  static level3 + #135, #3967
  static level3 + #136, #3967
  static level3 + #137, #3967
  static level3 + #138, #3967
  static level3 + #139, #3967
  static level3 + #140, #3967
  static level3 + #141, #3967
  static level3 + #142, #3967
  static level3 + #143, #3967
  static level3 + #144, #3967
  static level3 + #145, #3967
  static level3 + #146, #3967
  static level3 + #147, #3967
  static level3 + #148, #3967
  static level3 + #149, #3967
  static level3 + #150, #3967
  static level3 + #151, #3967
  static level3 + #152, #3967
  static level3 + #153, #3967
  static level3 + #154, #3967
  static level3 + #155, #3967
  static level3 + #156, #3967
  static level3 + #157, #3967
  static level3 + #158, #3967
  static level3 + #159, #3967

  ;Linha 4
  static level3 + #160, #3967
  static level3 + #161, #3967
  static level3 + #162, #3967
  static level3 + #163, #3696
  static level3 + #164, #3690
  static level3 + #165, #3690
  static level3 + #166, #3690
  static level3 + #167, #3690
  static level3 + #168, #3690
  static level3 + #169, #3690
  static level3 + #170, #3690
  static level3 + #171, #3690
  static level3 + #172, #3690
  static level3 + #173, #3690
  static level3 + #174, #3690
  static level3 + #175, #3690
  static level3 + #176, #3690
  static level3 + #177, #3690
  static level3 + #178, #3690
  static level3 + #179, #3690
  static level3 + #180, #3690
  static level3 + #181, #3690
  static level3 + #182, #3690
  static level3 + #183, #3690
  static level3 + #184, #3690
  static level3 + #185, #3690
  static level3 + #186, #3690
  static level3 + #187, #3690
  static level3 + #188, #3690
  static level3 + #189, #3690
  static level3 + #190, #3690
  static level3 + #191, #3690
  static level3 + #192, #3690
  static level3 + #193, #3690
  static level3 + #194, #3690
  static level3 + #195, #3690
  static level3 + #196, #3693
  static level3 + #197, #3967
  static level3 + #198, #3967
  static level3 + #199, #3967

  ;Linha 5
  static level3 + #200, #3967
  static level3 + #201, #3967
  static level3 + #202, #3967
  static level3 + #203, #3692
  static level3 + #204, #45
  static level3 + #205, #45
  static level3 + #206, #45
  static level3 + #207, #45
  static level3 + #208, #45
  static level3 + #209, #45
  static level3 + #210, #45
  static level3 + #211, #45
  static level3 + #212, #45
  static level3 + #213, #45
  static level3 + #214, #45
  static level3 + #215, #45
  static level3 + #216, #45
  static level3 + #217, #45
  static level3 + #218, #45
  static level3 + #219, #2835
  static level3 + #220, #45
  static level3 + #221, #45
  static level3 + #222, #45
  static level3 + #223, #45
  static level3 + #224, #45
  static level3 + #225, #45
  static level3 + #226, #45
  static level3 + #227, #45
  static level3 + #228, #45
  static level3 + #229, #45
  static level3 + #230, #45
  static level3 + #231, #45
  static level3 + #232, #45
  static level3 + #233, #2835
  static level3 + #234, #45
  static level3 + #235, #45
  static level3 + #236, #3691
  static level3 + #237, #3967
  static level3 + #238, #3967
  static level3 + #239, #3967

  ;Linha 6
  static level3 + #240, #3967
  static level3 + #241, #3967
  static level3 + #242, #3967
  static level3 + #243, #3692
  static level3 + #244, #45
  static level3 + #245, #2835
  static level3 + #246, #45
  static level3 + #247, #45
  static level3 + #248, #45
  static level3 + #249, #45
  static level3 + #250, #45
  static level3 + #251, #45
  static level3 + #252, #45
  static level3 + #253, #45
  static level3 + #254, #45
  static level3 + #255, #45
  static level3 + #256, #45
  static level3 + #257, #45
  static level3 + #258, #45
  static level3 + #259, #45
  static level3 + #260, #45
  static level3 + #261, #45
  static level3 + #262, #45
  static level3 + #263, #45
  static level3 + #264, #45
  static level3 + #265, #45
  static level3 + #266, #45
  static level3 + #267, #45
  static level3 + #268, #45
  static level3 + #269, #45
  static level3 + #270, #45
  static level3 + #271, #45
  static level3 + #272, #45
  static level3 + #273, #45
  static level3 + #274, #45
  static level3 + #275, #45
  static level3 + #276, #3691
  static level3 + #277, #3967
  static level3 + #278, #3967
  static level3 + #279, #3967

  ;Linha 7
  static level3 + #280, #3967
  static level3 + #281, #3967
  static level3 + #282, #3967
  static level3 + #283, #3692
  static level3 + #284, #45
  static level3 + #285, #45
  static level3 + #286, #45
  static level3 + #287, #45
  static level3 + #288, #1117
  static level3 + #289, #1117
  static level3 + #290, #1117
  static level3 + #291, #45
  static level3 + #292, #45
  static level3 + #293, #45
  static level3 + #294, #45
  static level3 + #295, #45
  static level3 + #296, #45
  static level3 + #297, #45
  static level3 + #298, #45
  static level3 + #299, #45
  static level3 + #300, #45
  static level3 + #301, #45
  static level3 + #302, #45
  static level3 + #303, #45
  static level3 + #304, #45
  static level3 + #305, #45
  static level3 + #306, #45
  static level3 + #307, #45
  static level3 + #308, #45
  static level3 + #309, #45
  static level3 + #310, #45
  static level3 + #311, #45
  static level3 + #312, #45
  static level3 + #313, #45
  static level3 + #314, #45
  static level3 + #315, #45
  static level3 + #316, #3691
  static level3 + #317, #3967
  static level3 + #318, #3967
  static level3 + #319, #3967

  ;Linha 8
  static level3 + #320, #3967
  static level3 + #321, #3967
  static level3 + #322, #3967
  static level3 + #323, #3692
  static level3 + #324, #15
  static level3 + #325, #15
  static level3 + #326, #1117
  static level3 + #327, #1117
  static level3 + #328, #1117
  static level3 + #329, #1055
  static level3 + #330, #1117
  static level3 + #331, #1117
  static level3 + #332, #31
  static level3 + #333, #31
  static level3 + #334, #1117
  static level3 + #335, #31
  static level3 + #336, #31
  static level3 + #337, #1117
  static level3 + #338, #1117
  static level3 + #339, #15
  static level3 + #340, #15
  static level3 + #341, #2653
  static level3 + #342, #2653
  static level3 + #343, #861
  static level3 + #344, #861
  static level3 + #345, #861
  static level3 + #346, #2653
  static level3 + #347, #2653
  static level3 + #348, #2653
  static level3 + #349, #31
  static level3 + #350, #31
  static level3 + #351, #1117
  static level3 + #352, #1117
  static level3 + #353, #31
  static level3 + #354, #15
  static level3 + #355, #1556
  static level3 + #356, #3691
  static level3 + #357, #3967
  static level3 + #358, #3967
  static level3 + #359, #3967

  ;Linha 9
  static level3 + #360, #3967
  static level3 + #361, #3967
  static level3 + #362, #3967
  static level3 + #363, #3692
  static level3 + #364, #15
  static level3 + #365, #15
  static level3 + #366, #1117
  static level3 + #367, #1117
  static level3 + #368, #31
  static level3 + #369, #1117
  static level3 + #370, #1117
  static level3 + #371, #1117
  static level3 + #372, #31
  static level3 + #373, #31
  static level3 + #374, #1117
  static level3 + #375, #1117
  static level3 + #376, #1117
  static level3 + #377, #1117
  static level3 + #378, #1117
  static level3 + #379, #15
  static level3 + #380, #15
  static level3 + #381, #2653
  static level3 + #382, #2653
  static level3 + #383, #2653
  static level3 + #384, #2653
  static level3 + #385, #2653
  static level3 + #386, #2653
  static level3 + #387, #2653
  static level3 + #388, #861
  static level3 + #389, #31
  static level3 + #390, #31
  static level3 + #391, #31
  static level3 + #392, #1117
  static level3 + #393, #31
  static level3 + #394, #15
  static level3 + #395, #15
  static level3 + #396, #3691
  static level3 + #397, #3967
  static level3 + #398, #3967
  static level3 + #399, #3967

  ;Linha 10
  static level3 + #400, #3967
  static level3 + #401, #3967
  static level3 + #402, #3967
  static level3 + #403, #3692
  static level3 + #404, #15
  static level3 + #405, #15
  static level3 + #406, #31
  static level3 + #407, #31
  static level3 + #408, #31
  static level3 + #409, #31
  static level3 + #410, #31
  static level3 + #411, #2835
  static level3 + #412, #31
  static level3 + #413, #31
  static level3 + #414, #31
  static level3 + #415, #31
  static level3 + #416, #31
  static level3 + #417, #1117
  static level3 + #418, #1117
  static level3 + #419, #15
  static level3 + #420, #15
  static level3 + #421, #2653
  static level3 + #422, #2653
  static level3 + #423, #2653
  static level3 + #424, #861
  static level3 + #425, #2653
  static level3 + #426, #2653
  static level3 + #427, #2653
  static level3 + #428, #861
  static level3 + #429, #31
  static level3 + #430, #31
  static level3 + #431, #31
  static level3 + #432, #2835
  static level3 + #433, #31
  static level3 + #434, #15
  static level3 + #435, #15
  static level3 + #436, #3691
  static level3 + #437, #3967
  static level3 + #438, #3967
  static level3 + #439, #3967

  ;Linha 11
  static level3 + #440, #3967
  static level3 + #441, #3967
  static level3 + #442, #3967
  static level3 + #443, #3692
  static level3 + #444, #15
  static level3 + #445, #15
  static level3 + #446, #31
  static level3 + #447, #31
  static level3 + #448, #31
  static level3 + #449, #31
  static level3 + #450, #31
  static level3 + #451, #31
  static level3 + #452, #31
  static level3 + #453, #31
  static level3 + #454, #31
  static level3 + #455, #31
  static level3 + #456, #3967
  static level3 + #457, #31
  static level3 + #458, #31
  static level3 + #459, #15
  static level3 + #460, #15
  static level3 + #461, #2653
  static level3 + #462, #2653
  static level3 + #463, #861
  static level3 + #464, #861
  static level3 + #465, #861
  static level3 + #466, #2653
  static level3 + #467, #2653
  static level3 + #468, #2653
  static level3 + #469, #31
  static level3 + #470, #31
  static level3 + #471, #31
  static level3 + #472, #31
  static level3 + #473, #31
  static level3 + #474, #15
  static level3 + #475, #15
  static level3 + #476, #3691
  static level3 + #477, #3967
  static level3 + #478, #3967
  static level3 + #479, #3967

  ;Linha 12
  static level3 + #480, #3967
  static level3 + #481, #3967
  static level3 + #482, #3967
  static level3 + #483, #3692
  static level3 + #484, #15
  static level3 + #485, #15
  static level3 + #486, #1117
  static level3 + #487, #1117
  static level3 + #488, #1117
  static level3 + #489, #31
  static level3 + #490, #31
  static level3 + #491, #31
  static level3 + #492, #1117
  static level3 + #493, #1117
  static level3 + #494, #31
  static level3 + #495, #31
  static level3 + #496, #31
  static level3 + #497, #31
  static level3 + #498, #31
  static level3 + #499, #15
  static level3 + #500, #15
  static level3 + #501, #861
  static level3 + #502, #2653
  static level3 + #503, #2653
  static level3 + #504, #861
  static level3 + #505, #2653
  static level3 + #506, #2653
  static level3 + #507, #2653
  static level3 + #508, #2653
  static level3 + #509, #31
  static level3 + #510, #31
  static level3 + #511, #1117
  static level3 + #512, #31
  static level3 + #513, #31
  static level3 + #514, #15
  static level3 + #515, #15
  static level3 + #516, #3691
  static level3 + #517, #3967
  static level3 + #518, #3967
  static level3 + #519, #3967

  ;Linha 13
  static level3 + #520, #3967
  static level3 + #521, #3967
  static level3 + #522, #3967
  static level3 + #523, #3692
  static level3 + #524, #15
  static level3 + #525, #15
  static level3 + #526, #31
  static level3 + #527, #31
  static level3 + #528, #31
  static level3 + #529, #31
  static level3 + #530, #31
  static level3 + #531, #31
  static level3 + #532, #1117
  static level3 + #533, #1117
  static level3 + #534, #31
  static level3 + #535, #31
  static level3 + #536, #31
  static level3 + #537, #31
  static level3 + #538, #31
  static level3 + #539, #15
  static level3 + #540, #15
  static level3 + #541, #861
  static level3 + #542, #2653
  static level3 + #543, #2653
  static level3 + #544, #2653
  static level3 + #545, #2653
  static level3 + #546, #2653
  static level3 + #547, #861
  static level3 + #548, #861
  static level3 + #549, #31
  static level3 + #550, #31
  static level3 + #551, #31
  static level3 + #552, #31
  static level3 + #553, #1117
  static level3 + #554, #15
  static level3 + #555, #15
  static level3 + #556, #3691
  static level3 + #557, #3967
  static level3 + #558, #3967
  static level3 + #559, #3967

  ;Linha 14
  static level3 + #560, #3967
  static level3 + #561, #3967
  static level3 + #562, #3967
  static level3 + #563, #3692
  static level3 + #564, #15
  static level3 + #565, #15
  static level3 + #566, #31
  static level3 + #567, #31
  static level3 + #568, #31
  static level3 + #569, #31
  static level3 + #570, #31
  static level3 + #571, #31
  static level3 + #572, #31
  static level3 + #573, #31
  static level3 + #574, #31
  static level3 + #575, #1556
  static level3 + #576, #31
  static level3 + #577, #31
  static level3 + #578, #31
  static level3 + #579, #15
  static level3 + #580, #15
  static level3 + #581, #2653
  static level3 + #582, #2653
  static level3 + #583, #2653
  static level3 + #584, #2653
  static level3 + #585, #2653
  static level3 + #586, #2653
  static level3 + #587, #861
  static level3 + #588, #861
  static level3 + #589, #31
  static level3 + #590, #1117
  static level3 + #591, #1117
  static level3 + #592, #1117
  static level3 + #593, #1117
  static level3 + #594, #15
  static level3 + #595, #15
  static level3 + #596, #3691
  static level3 + #597, #3967
  static level3 + #598, #3967
  static level3 + #599, #3967

  ;Linha 15
  static level3 + #600, #3967
  static level3 + #601, #3967
  static level3 + #602, #3967
  static level3 + #603, #3692
  static level3 + #604, #15
  static level3 + #605, #15
  static level3 + #606, #1117
  static level3 + #607, #1117
  static level3 + #608, #31
  static level3 + #609, #31
  static level3 + #610, #1117
  static level3 + #611, #1117
  static level3 + #612, #31
  static level3 + #613, #31
  static level3 + #614, #31
  static level3 + #615, #31
  static level3 + #616, #31
  static level3 + #617, #31
  static level3 + #618, #31
  static level3 + #619, #15
  static level3 + #620, #15
  static level3 + #621, #31
  static level3 + #622, #2835
  static level3 + #623, #31
  static level3 + #624, #31
  static level3 + #625, #31
  static level3 + #626, #31
  static level3 + #627, #31
  static level3 + #628, #31
  static level3 + #629, #1117
  static level3 + #630, #31
  static level3 + #631, #31
  static level3 + #632, #1301
  static level3 + #633, #1117
  static level3 + #634, #15
  static level3 + #635, #15
  static level3 + #636, #3691
  static level3 + #637, #3967
  static level3 + #638, #3967
  static level3 + #639, #3967

  ;Linha 16
  static level3 + #640, #3967
  static level3 + #641, #3967
  static level3 + #642, #3967
  static level3 + #643, #3692
  static level3 + #644, #15
  static level3 + #645, #15
  static level3 + #646, #1117
  static level3 + #647, #1117
  static level3 + #648, #31
  static level3 + #649, #31
  static level3 + #650, #1117
  static level3 + #651, #93
  static level3 + #652, #31
  static level3 + #653, #31
  static level3 + #654, #31
  static level3 + #655, #31
  static level3 + #656, #31
  static level3 + #657, #31
  static level3 + #658, #31
  static level3 + #659, #15
  static level3 + #660, #15
  static level3 + #661, #45
  static level3 + #662, #45
  static level3 + #663, #45
  static level3 + #664, #45
  static level3 + #665, #45
  static level3 + #666, #45
  static level3 + #667, #45
  static level3 + #668, #45
  static level3 + #669, #31
  static level3 + #670, #31
  static level3 + #671, #31
  static level3 + #672, #31
  static level3 + #673, #1117
  static level3 + #674, #15
  static level3 + #675, #15
  static level3 + #676, #3691
  static level3 + #677, #3967
  static level3 + #678, #3967
  static level3 + #679, #3967

  ;Linha 17
  static level3 + #680, #3967
  static level3 + #681, #3967
  static level3 + #682, #3967
  static level3 + #683, #3692
  static level3 + #684, #2835
  static level3 + #685, #15
  static level3 + #686, #1117
  static level3 + #687, #31
  static level3 + #688, #1301
  static level3 + #689, #31
  static level3 + #690, #31
  static level3 + #691, #31
  static level3 + #692, #31
  static level3 + #693, #31
  static level3 + #694, #31
  static level3 + #695, #31
  static level3 + #696, #31
  static level3 + #697, #31
  static level3 + #698, #31
  static level3 + #699, #15
  static level3 + #700, #15
  static level3 + #701, #45
  static level3 + #702, #45
  static level3 + #703, #45
  static level3 + #704, #1117
  static level3 + #705, #1117
  static level3 + #706, #45
  static level3 + #707, #1556
  static level3 + #708, #45
  static level3 + #709, #31
  static level3 + #710, #31
  static level3 + #711, #31
  static level3 + #712, #1117
  static level3 + #713, #1117
  static level3 + #714, #15
  static level3 + #715, #15
  static level3 + #716, #3691
  static level3 + #717, #3967
  static level3 + #718, #3967
  static level3 + #719, #3967

  ;Linha 18
  static level3 + #720, #3967
  static level3 + #721, #3967
  static level3 + #722, #3967
  static level3 + #723, #3692
  static level3 + #724, #15
  static level3 + #725, #15
  static level3 + #726, #1117
  static level3 + #727, #1117
  static level3 + #728, #31
  static level3 + #729, #31
  static level3 + #730, #31
  static level3 + #731, #31
  static level3 + #732, #31
  static level3 + #733, #31
  static level3 + #734, #1117
  static level3 + #735, #31
  static level3 + #736, #1117
  static level3 + #737, #31
  static level3 + #738, #1117
  static level3 + #739, #15
  static level3 + #740, #15
  static level3 + #741, #45
  static level3 + #742, #45
  static level3 + #743, #45
  static level3 + #744, #45
  static level3 + #745, #1117
  static level3 + #746, #1117
  static level3 + #747, #1117
  static level3 + #748, #1117
  static level3 + #749, #1117
  static level3 + #750, #1117
  static level3 + #751, #1117
  static level3 + #752, #1117
  static level3 + #753, #1117
  static level3 + #754, #15
  static level3 + #755, #15
  static level3 + #756, #3691
  static level3 + #757, #3967
  static level3 + #758, #3967
  static level3 + #759, #3967

  ;Linha 19
  static level3 + #760, #3967
  static level3 + #761, #3967
  static level3 + #762, #3967
  static level3 + #763, #3692
  static level3 + #764, #15
  static level3 + #765, #15
  static level3 + #766, #1117
  static level3 + #767, #1117
  static level3 + #768, #31
  static level3 + #769, #31
  static level3 + #770, #1117
  static level3 + #771, #1117
  static level3 + #772, #31
  static level3 + #773, #31
  static level3 + #774, #31
  static level3 + #775, #1117
  static level3 + #776, #1117
  static level3 + #777, #1117
  static level3 + #778, #1117
  static level3 + #779, #15
  static level3 + #780, #15
  static level3 + #781, #31
  static level3 + #782, #1055
  static level3 + #783, #31
  static level3 + #784, #31
  static level3 + #785, #31
  static level3 + #786, #31
  static level3 + #787, #1117
  static level3 + #788, #1117
  static level3 + #789, #1055
  static level3 + #790, #1055
  static level3 + #791, #1117
  static level3 + #792, #2350
  static level3 + #793, #31
  static level3 + #794, #15
  static level3 + #795, #15
  static level3 + #796, #3691
  static level3 + #797, #3967
  static level3 + #798, #3967
  static level3 + #799, #3967

  ;Linha 20
  static level3 + #800, #3967
  static level3 + #801, #3967
  static level3 + #802, #3967
  static level3 + #803, #3692
  static level3 + #804, #15
  static level3 + #805, #15
  static level3 + #806, #31
  static level3 + #807, #31
  static level3 + #808, #31
  static level3 + #809, #31
  static level3 + #810, #31
  static level3 + #811, #1117
  static level3 + #812, #31
  static level3 + #813, #2835
  static level3 + #814, #31
  static level3 + #815, #1117
  static level3 + #816, #1117
  static level3 + #817, #1117
  static level3 + #818, #31
  static level3 + #819, #15
  static level3 + #820, #15
  static level3 + #821, #1117
  static level3 + #822, #31
  static level3 + #823, #31
  static level3 + #824, #31
  static level3 + #825, #31
  static level3 + #826, #31
  static level3 + #827, #1556
  static level3 + #828, #31
  static level3 + #829, #1117
  static level3 + #830, #1117
  static level3 + #831, #1117
  static level3 + #832, #31
  static level3 + #833, #31
  static level3 + #834, #15
  static level3 + #835, #15
  static level3 + #836, #3691
  static level3 + #837, #3967
  static level3 + #838, #3967
  static level3 + #839, #3967

  ;Linha 21
  static level3 + #840, #3967
  static level3 + #841, #3967
  static level3 + #842, #3967
  static level3 + #843, #3692
  static level3 + #844, #15
  static level3 + #845, #15
  static level3 + #846, #31
  static level3 + #847, #31
  static level3 + #848, #31
  static level3 + #849, #31
  static level3 + #850, #555
  static level3 + #851, #31
  static level3 + #852, #31
  static level3 + #853, #31
  static level3 + #854, #31
  static level3 + #855, #31
  static level3 + #856, #31
  static level3 + #857, #31
  static level3 + #858, #31
  static level3 + #859, #15
  static level3 + #860, #15
  static level3 + #861, #1117
  static level3 + #862, #1117
  static level3 + #863, #1117
  static level3 + #864, #31
  static level3 + #865, #31
  static level3 + #866, #31
  static level3 + #867, #31
  static level3 + #868, #31
  static level3 + #869, #31
  static level3 + #870, #1117
  static level3 + #871, #1117
  static level3 + #872, #1117
  static level3 + #873, #1117
  static level3 + #874, #15
  static level3 + #875, #15
  static level3 + #876, #3691
  static level3 + #877, #3967
  static level3 + #878, #3967
  static level3 + #879, #3967

  ;Linha 22
  static level3 + #880, #3967
  static level3 + #881, #3967
  static level3 + #882, #3967
  static level3 + #883, #3692
  static level3 + #884, #15
  static level3 + #885, #15
  static level3 + #886, #1117
  static level3 + #887, #1117
  static level3 + #888, #1117
  static level3 + #889, #31
  static level3 + #890, #31
  static level3 + #891, #31
  static level3 + #892, #31
  static level3 + #893, #31
  static level3 + #894, #31
  static level3 + #895, #1117
  static level3 + #896, #1117
  static level3 + #897, #1117
  static level3 + #898, #31
  static level3 + #899, #15
  static level3 + #900, #15
  static level3 + #901, #1117
  static level3 + #902, #1055
  static level3 + #903, #1117
  static level3 + #904, #31
  static level3 + #905, #1117
  static level3 + #906, #1117
  static level3 + #907, #31
  static level3 + #908, #31
  static level3 + #909, #31
  static level3 + #910, #1117
  static level3 + #911, #1055
  static level3 + #912, #1055
  static level3 + #913, #1117
  static level3 + #914, #15
  static level3 + #915, #15
  static level3 + #916, #3691
  static level3 + #917, #3967
  static level3 + #918, #3967
  static level3 + #919, #3967

  ;Linha 23
  static level3 + #920, #3967
  static level3 + #921, #3967
  static level3 + #922, #3967
  static level3 + #923, #3692
  static level3 + #924, #15
  static level3 + #925, #15
  static level3 + #926, #1117
  static level3 + #927, #1117
  static level3 + #928, #1117
  static level3 + #929, #1117
  static level3 + #930, #1117
  static level3 + #931, #31
  static level3 + #932, #31
  static level3 + #933, #1117
  static level3 + #934, #31
  static level3 + #935, #1117
  static level3 + #936, #1117
  static level3 + #937, #1117
  static level3 + #938, #1117
  static level3 + #939, #15
  static level3 + #940, #15
  static level3 + #941, #1117
  static level3 + #942, #1117
  static level3 + #943, #1117
  static level3 + #944, #31
  static level3 + #945, #1117
  static level3 + #946, #1055
  static level3 + #947, #1117
  static level3 + #948, #31
  static level3 + #949, #31
  static level3 + #950, #1117
  static level3 + #951, #1117
  static level3 + #952, #1117
  static level3 + #953, #1117
  static level3 + #954, #15
  static level3 + #955, #15
  static level3 + #956, #3691
  static level3 + #957, #3967
  static level3 + #958, #3967
  static level3 + #959, #3967

  ;Linha 24
  static level3 + #960, #3967
  static level3 + #961, #3967
  static level3 + #962, #3967
  static level3 + #963, #3692
  static level3 + #964, #15
  static level3 + #965, #15
  static level3 + #966, #1117
  static level3 + #967, #31
  static level3 + #968, #1117
  static level3 + #969, #31
  static level3 + #970, #1117
  static level3 + #971, #31
  static level3 + #972, #31
  static level3 + #973, #31
  static level3 + #974, #31
  static level3 + #975, #31
  static level3 + #976, #1117
  static level3 + #977, #31
  static level3 + #978, #1117
  static level3 + #979, #31
  static level3 + #980, #31
  static level3 + #981, #31
  static level3 + #982, #1117
  static level3 + #983, #1055
  static level3 + #984, #31
  static level3 + #985, #1117
  static level3 + #986, #1117
  static level3 + #987, #1117
  static level3 + #988, #31
  static level3 + #989, #31
  static level3 + #990, #31
  static level3 + #991, #31
  static level3 + #992, #31
  static level3 + #993, #31
  static level3 + #994, #15
  static level3 + #995, #15
  static level3 + #996, #3691
  static level3 + #997, #3967
  static level3 + #998, #3967
  static level3 + #999, #3967

  ;Linha 25
  static level3 + #1000, #3967
  static level3 + #1001, #3967
  static level3 + #1002, #3967
  static level3 + #1003, #3692
  static level3 + #1004, #45
  static level3 + #1005, #45
  static level3 + #1006, #45
  static level3 + #1007, #45
  static level3 + #1008, #45
  static level3 + #1009, #45
  static level3 + #1010, #45
  static level3 + #1011, #45
  static level3 + #1012, #45
  static level3 + #1013, #45
  static level3 + #1014, #45
  static level3 + #1015, #45
  static level3 + #1016, #2835
  static level3 + #1017, #45
  static level3 + #1018, #45
  static level3 + #1019, #45
  static level3 + #1020, #45
  static level3 + #1021, #45
  static level3 + #1022, #45
  static level3 + #1023, #45
  static level3 + #1024, #45
  static level3 + #1025, #45
  static level3 + #1026, #45
  static level3 + #1027, #45
  static level3 + #1028, #45
  static level3 + #1029, #45
  static level3 + #1030, #45
  static level3 + #1031, #2835
  static level3 + #1032, #45
  static level3 + #1033, #45
  static level3 + #1034, #45
  static level3 + #1035, #45
  static level3 + #1036, #3691
  static level3 + #1037, #3967
  static level3 + #1038, #3967
  static level3 + #1039, #3967

  ;Linha 26
  static level3 + #1040, #3967
  static level3 + #1041, #3967
  static level3 + #1042, #3967
  static level3 + #1043, #3692
  static level3 + #1044, #45
  static level3 + #1045, #45
  static level3 + #1046, #2835
  static level3 + #1047, #45
  static level3 + #1048, #45
  static level3 + #1049, #45
  static level3 + #1050, #45
  static level3 + #1051, #45
  static level3 + #1052, #45
  static level3 + #1053, #45
  static level3 + #1054, #45
  static level3 + #1055, #45
  static level3 + #1056, #45
  static level3 + #1057, #45
  static level3 + #1058, #45
  static level3 + #1059, #45
  static level3 + #1060, #45
  static level3 + #1061, #45
  static level3 + #1062, #45
  static level3 + #1063, #45
  static level3 + #1064, #45
  static level3 + #1065, #45
  static level3 + #1066, #45
  static level3 + #1067, #45
  static level3 + #1068, #45
  static level3 + #1069, #45
  static level3 + #1070, #45
  static level3 + #1071, #45
  static level3 + #1072, #45
  static level3 + #1073, #45
  static level3 + #1074, #45
  static level3 + #1075, #45
  static level3 + #1076, #3691
  static level3 + #1077, #3967
  static level3 + #1078, #3967
  static level3 + #1079, #3967

  ;Linha 27
  static level3 + #1080, #3967
  static level3 + #1081, #3967
  static level3 + #1082, #3967
  static level3 + #1083, #3695
  static level3 + #1084, #3689
  static level3 + #1085, #3689
  static level3 + #1086, #3689
  static level3 + #1087, #3689
  static level3 + #1088, #3689
  static level3 + #1089, #3689
  static level3 + #1090, #3689
  static level3 + #1091, #3689
  static level3 + #1092, #3689
  static level3 + #1093, #3689
  static level3 + #1094, #3689
  static level3 + #1095, #3689
  static level3 + #1096, #3689
  static level3 + #1097, #3689
  static level3 + #1098, #3689
  static level3 + #1099, #3689
  static level3 + #1100, #3689
  static level3 + #1101, #3689
  static level3 + #1102, #3689
  static level3 + #1103, #3689
  static level3 + #1104, #3689
  static level3 + #1105, #3689
  static level3 + #1106, #3689
  static level3 + #1107, #3689
  static level3 + #1108, #3689
  static level3 + #1109, #3689
  static level3 + #1110, #3689
  static level3 + #1111, #3689
  static level3 + #1112, #3689
  static level3 + #1113, #3689
  static level3 + #1114, #3689
  static level3 + #1115, #3689
  static level3 + #1116, #3694
  static level3 + #1117, #3967
  static level3 + #1118, #3967
  static level3 + #1119, #3967

  ;Linha 28
  static level3 + #1120, #3967
  static level3 + #1121, #3967
  static level3 + #1122, #3967
  static level3 + #1123, #3967
  static level3 + #1124, #3967
  static level3 + #1125, #3967
  static level3 + #1126, #3967
  static level3 + #1127, #3967
  static level3 + #1128, #3967
  static level3 + #1129, #3967
  static level3 + #1130, #3967
  static level3 + #1131, #3967
  static level3 + #1132, #3967
  static level3 + #1133, #3967
  static level3 + #1134, #3967
  static level3 + #1135, #3967
  static level3 + #1136, #3967
  static level3 + #1137, #3967
  static level3 + #1138, #3967
  static level3 + #1139, #3967
  static level3 + #1140, #3967
  static level3 + #1141, #3967
  static level3 + #1142, #3967
  static level3 + #1143, #3967
  static level3 + #1144, #3967
  static level3 + #1145, #3967
  static level3 + #1146, #3967
  static level3 + #1147, #3967
  static level3 + #1148, #3967
  static level3 + #1149, #3967
  static level3 + #1150, #3967
  static level3 + #1151, #3967
  static level3 + #1152, #3967
  static level3 + #1153, #3967
  static level3 + #1154, #3967
  static level3 + #1155, #3967
  static level3 + #1156, #3967
  static level3 + #1157, #3967
  static level3 + #1158, #3967
  static level3 + #1159, #3967

  ;Linha 29
  static level3 + #1160, #3967
  static level3 + #1161, #3967
  static level3 + #1162, #3967
  static level3 + #1163, #3967
  static level3 + #1164, #3967
  static level3 + #1165, #3967
  static level3 + #1166, #3967
  static level3 + #1167, #3967
  static level3 + #1168, #3967
  static level3 + #1169, #3967
  static level3 + #1170, #3967
  static level3 + #1171, #3967
  static level3 + #1172, #3967
  static level3 + #1173, #3967
  static level3 + #1174, #3967
  static level3 + #1175, #3967
  static level3 + #1176, #3967
  static level3 + #1177, #3967
  static level3 + #1178, #3967
  static level3 + #1179, #3967
  static level3 + #1180, #3967
  static level3 + #1181, #3967
  static level3 + #1182, #3967
  static level3 + #1183, #3967
  static level3 + #1184, #3967
  static level3 + #1185, #3967
  static level3 + #1186, #3967
  static level3 + #1187, #3967
  static level3 + #1188, #3967
  static level3 + #1189, #3967
  static level3 + #1190, #3967
  static level3 + #1191, #3967
  static level3 + #1192, #3967
  static level3 + #1193, #3967
  static level3 + #1194, #3967
  static level3 + #1195, #3967
  static level3 + #1196, #3967
  static level3 + #1197, #3967
  static level3 + #1198, #3967
  static level3 + #1199, #3967

level4 : var #1200
  ;Linha 0
  static level4 + #0, #3967
  static level4 + #1, #3967
  static level4 + #2, #3967
  static level4 + #3, #3967
  static level4 + #4, #3967
  static level4 + #5, #3967
  static level4 + #6, #3967
  static level4 + #7, #3967
  static level4 + #8, #3967
  static level4 + #9, #3967
  static level4 + #10, #3967
  static level4 + #11, #3967
  static level4 + #12, #3967
  static level4 + #13, #3967
  static level4 + #14, #3967
  static level4 + #15, #3967
  static level4 + #16, #3967
  static level4 + #17, #3967
  static level4 + #18, #3967
  static level4 + #19, #3967
  static level4 + #20, #3967
  static level4 + #21, #3967
  static level4 + #22, #3967
  static level4 + #23, #3967
  static level4 + #24, #3967
  static level4 + #25, #3967
  static level4 + #26, #3967
  static level4 + #27, #3967
  static level4 + #28, #3967
  static level4 + #29, #3967
  static level4 + #30, #3967
  static level4 + #31, #3967
  static level4 + #32, #3967
  static level4 + #33, #3967
  static level4 + #34, #3967
  static level4 + #35, #3967
  static level4 + #36, #3967
  static level4 + #37, #3967
  static level4 + #38, #3967
  static level4 + #39, #3967

  ;Linha 1
  static level4 + #40, #3967
  static level4 + #41, #3967
  static level4 + #42, #3967
  static level4 + #43, #3967
  static level4 + #44, #3967
  static level4 + #45, #3967
  static level4 + #46, #3967
  static level4 + #47, #3967
  static level4 + #48, #3967
  static level4 + #49, #3967
  static level4 + #50, #3967
  static level4 + #51, #3967
  static level4 + #52, #3967
  static level4 + #53, #3967
  static level4 + #54, #3967
  static level4 + #55, #3967
  static level4 + #56, #3967
  static level4 + #57, #3967
  static level4 + #58, #3967
  static level4 + #59, #3967
  static level4 + #60, #3967
  static level4 + #61, #3967
  static level4 + #62, #3967
  static level4 + #63, #3967
  static level4 + #64, #3967
  static level4 + #65, #3967
  static level4 + #66, #3967
  static level4 + #67, #3967
  static level4 + #68, #3967
  static level4 + #69, #3967
  static level4 + #70, #3967
  static level4 + #71, #3967
  static level4 + #72, #3967
  static level4 + #73, #3967
  static level4 + #74, #3967
  static level4 + #75, #3967
  static level4 + #76, #3967
  static level4 + #77, #3967
  static level4 + #78, #3967
  static level4 + #79, #3967

  ;Linha 2
  static level4 + #80, #3967
  static level4 + #81, #3967
  static level4 + #82, #3967
  static level4 + #83, #3967
  static level4 + #84, #3967
  static level4 + #85, #3967
  static level4 + #86, #3967
  static level4 + #87, #3967
  static level4 + #88, #3967
  static level4 + #89, #3967
  static level4 + #90, #3967
  static level4 + #91, #3967
  static level4 + #92, #3967
  static level4 + #93, #3967
  static level4 + #94, #3967
  static level4 + #95, #3967
  static level4 + #96, #3967
  static level4 + #97, #3967
  static level4 + #98, #3967
  static level4 + #99, #3967
  static level4 + #100, #3967
  static level4 + #101, #3967
  static level4 + #102, #3967
  static level4 + #103, #3967
  static level4 + #104, #3967
  static level4 + #105, #3967
  static level4 + #106, #3967
  static level4 + #107, #3967
  static level4 + #108, #3967
  static level4 + #109, #3967
  static level4 + #110, #3967
  static level4 + #111, #3967
  static level4 + #112, #3967
  static level4 + #113, #3967
  static level4 + #114, #3967
  static level4 + #115, #3967
  static level4 + #116, #3967
  static level4 + #117, #3967
  static level4 + #118, #3967
  static level4 + #119, #3967

  ;Linha 3
  static level4 + #120, #3967
  static level4 + #121, #3967
  static level4 + #122, #3967
  static level4 + #123, #3967
  static level4 + #124, #3967
  static level4 + #125, #3967
  static level4 + #126, #3967
  static level4 + #127, #3967
  static level4 + #128, #3967
  static level4 + #129, #3967
  static level4 + #130, #3967
  static level4 + #131, #3967
  static level4 + #132, #3967
  static level4 + #133, #3967
  static level4 + #134, #3967
  static level4 + #135, #3967
  static level4 + #136, #3967
  static level4 + #137, #3967
  static level4 + #138, #3967
  static level4 + #139, #3967
  static level4 + #140, #3967
  static level4 + #141, #3967
  static level4 + #142, #3967
  static level4 + #143, #3967
  static level4 + #144, #3967
  static level4 + #145, #3967
  static level4 + #146, #3967
  static level4 + #147, #3967
  static level4 + #148, #3967
  static level4 + #149, #3967
  static level4 + #150, #3967
  static level4 + #151, #3967
  static level4 + #152, #3967
  static level4 + #153, #3967
  static level4 + #154, #3967
  static level4 + #155, #3967
  static level4 + #156, #3967
  static level4 + #157, #3967
  static level4 + #158, #3967
  static level4 + #159, #3967

  ;Linha 4
  static level4 + #160, #3967
  static level4 + #161, #3967
  static level4 + #162, #3696
  static level4 + #163, #3690
  static level4 + #164, #3690
  static level4 + #165, #3690
  static level4 + #166, #3690
  static level4 + #167, #3690
  static level4 + #168, #3690
  static level4 + #169, #3690
  static level4 + #170, #3690
  static level4 + #171, #3690
  static level4 + #172, #3690
  static level4 + #173, #3690
  static level4 + #174, #3690
  static level4 + #175, #3690
  static level4 + #176, #3690
  static level4 + #177, #3690
  static level4 + #178, #3690
  static level4 + #179, #3690
  static level4 + #180, #3690
  static level4 + #181, #3690
  static level4 + #182, #3690
  static level4 + #183, #3690
  static level4 + #184, #3690
  static level4 + #185, #3690
  static level4 + #186, #3690
  static level4 + #187, #3690
  static level4 + #188, #3690
  static level4 + #189, #3690
  static level4 + #190, #3690
  static level4 + #191, #3690
  static level4 + #192, #3690
  static level4 + #193, #3690
  static level4 + #194, #3690
  static level4 + #195, #3690
  static level4 + #196, #3690
  static level4 + #197, #3693
  static level4 + #198, #3967
  static level4 + #199, #3967

  ;Linha 5
  static level4 + #200, #3967
  static level4 + #201, #3967
  static level4 + #202, #3692
  static level4 + #203, #2835
  static level4 + #204, #45
  static level4 + #205, #45
  static level4 + #206, #45
  static level4 + #207, #45
  static level4 + #208, #2859
  static level4 + #209, #45
  static level4 + #210, #45
  static level4 + #211, #45
  static level4 + #212, #2835
  static level4 + #213, #45
  static level4 + #214, #45
  static level4 + #215, #45
  static level4 + #216, #45
  static level4 + #217, #45
  static level4 + #218, #45
  static level4 + #219, #45
  static level4 + #220, #45
  static level4 + #221, #45
  static level4 + #222, #45
  static level4 + #223, #45
  static level4 + #224, #2835
  static level4 + #225, #45
  static level4 + #226, #45
  static level4 + #227, #45
  static level4 + #228, #45
  static level4 + #229, #45
  static level4 + #230, #45
  static level4 + #231, #45
  static level4 + #232, #15
  static level4 + #233, #15
  static level4 + #234, #15
  static level4 + #235, #349
  static level4 + #236, #349
  static level4 + #237, #3691
  static level4 + #238, #3967
  static level4 + #239, #3967

  ;Linha 6
  static level4 + #240, #3967
  static level4 + #241, #3967
  static level4 + #242, #3692
  static level4 + #243, #45
  static level4 + #244, #45
  static level4 + #245, #45
  static level4 + #246, #45
  static level4 + #247, #45
  static level4 + #248, #45
  static level4 + #249, #45
  static level4 + #250, #45
  static level4 + #251, #45
  static level4 + #252, #45
  static level4 + #253, #45
  static level4 + #254, #45
  static level4 + #255, #45
  static level4 + #256, #45
  static level4 + #257, #45
  static level4 + #258, #45
  static level4 + #259, #45
  static level4 + #260, #45
  static level4 + #261, #45
  static level4 + #262, #45
  static level4 + #263, #45
  static level4 + #264, #45
  static level4 + #265, #45
  static level4 + #266, #45
  static level4 + #267, #45
  static level4 + #268, #45
  static level4 + #269, #45
  static level4 + #270, #45
  static level4 + #271, #45
  static level4 + #272, #15
  static level4 + #273, #1556
  static level4 + #274, #15
  static level4 + #275, #349
  static level4 + #276, #349
  static level4 + #277, #3691
  static level4 + #278, #3967
  static level4 + #279, #3967

  ;Linha 7
  static level4 + #280, #3967
  static level4 + #281, #3967
  static level4 + #282, #3692
  static level4 + #283, #15
  static level4 + #284, #15
  static level4 + #285, #15
  static level4 + #286, #349
  static level4 + #287, #15
  static level4 + #288, #15
  static level4 + #289, #349
  static level4 + #290, #349
  static level4 + #291, #349
  static level4 + #292, #349
  static level4 + #293, #31
  static level4 + #294, #349
  static level4 + #295, #349
  static level4 + #296, #31
  static level4 + #297, #349
  static level4 + #298, #31
  static level4 + #299, #349
  static level4 + #300, #31
  static level4 + #301, #349
  static level4 + #302, #349
  static level4 + #303, #31
  static level4 + #304, #349
  static level4 + #305, #31
  static level4 + #306, #349
  static level4 + #307, #31
  static level4 + #308, #349
  static level4 + #309, #31
  static level4 + #310, #31
  static level4 + #311, #349
  static level4 + #312, #15
  static level4 + #313, #15
  static level4 + #314, #15
  static level4 + #315, #349
  static level4 + #316, #349
  static level4 + #317, #3691
  static level4 + #318, #3967
  static level4 + #319, #3967

  ;Linha 8
  static level4 + #320, #3967
  static level4 + #321, #3967
  static level4 + #322, #3692
  static level4 + #323, #2835
  static level4 + #324, #15
  static level4 + #325, #15
  static level4 + #326, #349
  static level4 + #327, #15
  static level4 + #328, #15
  static level4 + #329, #349
  static level4 + #330, #349
  static level4 + #331, #349
  static level4 + #332, #349
  static level4 + #333, #31
  static level4 + #334, #349
  static level4 + #335, #349
  static level4 + #336, #31
  static level4 + #337, #349
  static level4 + #338, #349
  static level4 + #339, #349
  static level4 + #340, #1301
  static level4 + #341, #31
  static level4 + #342, #31
  static level4 + #343, #31
  static level4 + #344, #349
  static level4 + #345, #31
  static level4 + #346, #349
  static level4 + #347, #31
  static level4 + #348, #349
  static level4 + #349, #31
  static level4 + #350, #31
  static level4 + #351, #349
  static level4 + #352, #15
  static level4 + #353, #15
  static level4 + #354, #15
  static level4 + #355, #349
  static level4 + #356, #349
  static level4 + #357, #3691
  static level4 + #358, #3967
  static level4 + #359, #3967

  ;Linha 9
  static level4 + #360, #3967
  static level4 + #361, #3967
  static level4 + #362, #3692
  static level4 + #363, #45
  static level4 + #364, #45
  static level4 + #365, #45
  static level4 + #366, #45
  static level4 + #367, #45
  static level4 + #368, #45
  static level4 + #369, #45
  static level4 + #370, #31
  static level4 + #371, #349
  static level4 + #372, #349
  static level4 + #373, #45
  static level4 + #374, #45
  static level4 + #375, #45
  static level4 + #376, #1556
  static level4 + #377, #45
  static level4 + #378, #45
  static level4 + #379, #45
  static level4 + #380, #45
  static level4 + #381, #45
  static level4 + #382, #45
  static level4 + #383, #45
  static level4 + #384, #45
  static level4 + #385, #45
  static level4 + #386, #45
  static level4 + #387, #45
  static level4 + #388, #2835
  static level4 + #389, #45
  static level4 + #390, #45
  static level4 + #391, #45
  static level4 + #392, #15
  static level4 + #393, #15
  static level4 + #394, #15
  static level4 + #395, #349
  static level4 + #396, #349
  static level4 + #397, #3691
  static level4 + #398, #3967
  static level4 + #399, #3967

  ;Linha 10
  static level4 + #400, #3967
  static level4 + #401, #3967
  static level4 + #402, #3692
  static level4 + #403, #45
  static level4 + #404, #45
  static level4 + #405, #45
  static level4 + #406, #45
  static level4 + #407, #45
  static level4 + #408, #45
  static level4 + #409, #45
  static level4 + #410, #31
  static level4 + #411, #349
  static level4 + #412, #349
  static level4 + #413, #45
  static level4 + #414, #45
  static level4 + #415, #45
  static level4 + #416, #45
  static level4 + #417, #45
  static level4 + #418, #45
  static level4 + #419, #45
  static level4 + #420, #45
  static level4 + #421, #45
  static level4 + #422, #45
  static level4 + #423, #45
  static level4 + #424, #45
  static level4 + #425, #45
  static level4 + #426, #45
  static level4 + #427, #45
  static level4 + #428, #45
  static level4 + #429, #45
  static level4 + #430, #45
  static level4 + #431, #45
  static level4 + #432, #15
  static level4 + #433, #15
  static level4 + #434, #15
  static level4 + #435, #2835
  static level4 + #436, #31
  static level4 + #437, #3691
  static level4 + #438, #3967
  static level4 + #439, #3967

  ;Linha 11
  static level4 + #440, #3967
  static level4 + #441, #3967
  static level4 + #442, #3692
  static level4 + #443, #15
  static level4 + #444, #15
  static level4 + #445, #15
  static level4 + #446, #349
  static level4 + #447, #349
  static level4 + #448, #349
  static level4 + #449, #31
  static level4 + #450, #31
  static level4 + #451, #31
  static level4 + #452, #31
  static level4 + #453, #31
  static level4 + #454, #31
  static level4 + #455, #349
  static level4 + #456, #31
  static level4 + #457, #31
  static level4 + #458, #31
  static level4 + #459, #349
  static level4 + #460, #15
  static level4 + #461, #15
  static level4 + #462, #15
  static level4 + #463, #605
  static level4 + #464, #861
  static level4 + #465, #605
  static level4 + #466, #605
  static level4 + #467, #605
  static level4 + #468, #861
  static level4 + #469, #861
  static level4 + #470, #861
  static level4 + #471, #15
  static level4 + #472, #15
  static level4 + #473, #15
  static level4 + #474, #31
  static level4 + #475, #31
  static level4 + #476, #1301
  static level4 + #477, #3691
  static level4 + #478, #3967
  static level4 + #479, #3967

  ;Linha 12
  static level4 + #480, #3967
  static level4 + #481, #3967
  static level4 + #482, #3692
  static level4 + #483, #15
  static level4 + #484, #15
  static level4 + #485, #15
  static level4 + #486, #31
  static level4 + #487, #349
  static level4 + #488, #349
  static level4 + #489, #2835
  static level4 + #490, #31
  static level4 + #491, #31
  static level4 + #492, #31
  static level4 + #493, #1556
  static level4 + #494, #31
  static level4 + #495, #31
  static level4 + #496, #31
  static level4 + #497, #31
  static level4 + #498, #31
  static level4 + #499, #31
  static level4 + #500, #15
  static level4 + #501, #15
  static level4 + #502, #15
  static level4 + #503, #861
  static level4 + #504, #861
  static level4 + #505, #861
  static level4 + #506, #605
  static level4 + #507, #605
  static level4 + #508, #605
  static level4 + #509, #861
  static level4 + #510, #861
  static level4 + #511, #15
  static level4 + #512, #2835
  static level4 + #513, #15
  static level4 + #514, #349
  static level4 + #515, #349
  static level4 + #516, #349
  static level4 + #517, #3691
  static level4 + #518, #3967
  static level4 + #519, #3967

  ;Linha 13
  static level4 + #520, #3967
  static level4 + #521, #3967
  static level4 + #522, #3692
  static level4 + #523, #15
  static level4 + #524, #15
  static level4 + #525, #15
  static level4 + #526, #349
  static level4 + #527, #349
  static level4 + #528, #349
  static level4 + #529, #31
  static level4 + #530, #31
  static level4 + #531, #349
  static level4 + #532, #349
  static level4 + #533, #31
  static level4 + #534, #349
  static level4 + #535, #349
  static level4 + #536, #349
  static level4 + #537, #31
  static level4 + #538, #2835
  static level4 + #539, #31
  static level4 + #540, #15
  static level4 + #541, #15
  static level4 + #542, #15
  static level4 + #543, #605
  static level4 + #544, #861
  static level4 + #545, #2653
  static level4 + #546, #605
  static level4 + #547, #605
  static level4 + #548, #605
  static level4 + #549, #605
  static level4 + #550, #605
  static level4 + #551, #15
  static level4 + #552, #15
  static level4 + #553, #15
  static level4 + #554, #349
  static level4 + #555, #349
  static level4 + #556, #349
  static level4 + #557, #3691
  static level4 + #558, #3967
  static level4 + #559, #3967

  ;Linha 14
  static level4 + #560, #3967
  static level4 + #561, #3967
  static level4 + #562, #3692
  static level4 + #563, #1556
  static level4 + #564, #15
  static level4 + #565, #15
  static level4 + #566, #31
  static level4 + #567, #349
  static level4 + #568, #349
  static level4 + #569, #31
  static level4 + #570, #31
  static level4 + #571, #349
  static level4 + #572, #349
  static level4 + #573, #349
  static level4 + #574, #349
  static level4 + #575, #349
  static level4 + #576, #31
  static level4 + #577, #31
  static level4 + #578, #349
  static level4 + #579, #31
  static level4 + #580, #15
  static level4 + #581, #15
  static level4 + #582, #15
  static level4 + #583, #605
  static level4 + #584, #605
  static level4 + #585, #2653
  static level4 + #586, #2653
  static level4 + #587, #605
  static level4 + #588, #605
  static level4 + #589, #2653
  static level4 + #590, #2653
  static level4 + #591, #15
  static level4 + #592, #15
  static level4 + #593, #15
  static level4 + #594, #349
  static level4 + #595, #349
  static level4 + #596, #349
  static level4 + #597, #3691
  static level4 + #598, #3967
  static level4 + #599, #3967

  ;Linha 15
  static level4 + #600, #3967
  static level4 + #601, #3967
  static level4 + #602, #3692
  static level4 + #603, #15
  static level4 + #604, #15
  static level4 + #605, #15
  static level4 + #606, #349
  static level4 + #607, #349
  static level4 + #608, #349
  static level4 + #609, #31
  static level4 + #610, #31
  static level4 + #611, #349
  static level4 + #612, #349
  static level4 + #613, #31
  static level4 + #614, #349
  static level4 + #615, #349
  static level4 + #616, #31
  static level4 + #617, #31
  static level4 + #618, #31
  static level4 + #619, #349
  static level4 + #620, #15
  static level4 + #621, #15
  static level4 + #622, #15
  static level4 + #623, #605
  static level4 + #624, #2653
  static level4 + #625, #605
  static level4 + #626, #605
  static level4 + #627, #605
  static level4 + #628, #2653
  static level4 + #629, #2653
  static level4 + #630, #605
  static level4 + #631, #15
  static level4 + #632, #15
  static level4 + #633, #15
  static level4 + #634, #349
  static level4 + #635, #349
  static level4 + #636, #349
  static level4 + #637, #3691
  static level4 + #638, #3967
  static level4 + #639, #3967

  ;Linha 16
  static level4 + #640, #3967
  static level4 + #641, #3967
  static level4 + #642, #3692
  static level4 + #643, #15
  static level4 + #644, #15
  static level4 + #645, #45
  static level4 + #646, #45
  static level4 + #647, #45
  static level4 + #648, #45
  static level4 + #649, #45
  static level4 + #650, #45
  static level4 + #651, #45
  static level4 + #652, #45
  static level4 + #653, #45
  static level4 + #654, #45
  static level4 + #655, #45
  static level4 + #656, #45
  static level4 + #657, #45
  static level4 + #658, #45
  static level4 + #659, #45
  static level4 + #660, #45
  static level4 + #661, #45
  static level4 + #662, #45
  static level4 + #663, #45
  static level4 + #664, #45
  static level4 + #665, #45
  static level4 + #666, #45
  static level4 + #667, #45
  static level4 + #668, #45
  static level4 + #669, #45
  static level4 + #670, #45
  static level4 + #671, #45
  static level4 + #672, #45
  static level4 + #673, #45
  static level4 + #674, #349
  static level4 + #675, #349
  static level4 + #676, #349
  static level4 + #677, #3691
  static level4 + #678, #3967
  static level4 + #679, #3967

  ;Linha 17
  static level4 + #680, #3967
  static level4 + #681, #3967
  static level4 + #682, #3692
  static level4 + #683, #15
  static level4 + #684, #15
  static level4 + #685, #45
  static level4 + #686, #45
  static level4 + #687, #45
  static level4 + #688, #45
  static level4 + #689, #2835
  static level4 + #690, #45
  static level4 + #691, #45
  static level4 + #692, #45
  static level4 + #693, #45
  static level4 + #694, #45
  static level4 + #695, #45
  static level4 + #696, #45
  static level4 + #697, #45
  static level4 + #698, #45
  static level4 + #699, #45
  static level4 + #700, #45
  static level4 + #701, #2835
  static level4 + #702, #45
  static level4 + #703, #45
  static level4 + #704, #45
  static level4 + #705, #45
  static level4 + #706, #45
  static level4 + #707, #45
  static level4 + #708, #45
  static level4 + #709, #45
  static level4 + #710, #45
  static level4 + #711, #45
  static level4 + #712, #45
  static level4 + #713, #45
  static level4 + #714, #349
  static level4 + #715, #349
  static level4 + #716, #349
  static level4 + #717, #3691
  static level4 + #718, #3967
  static level4 + #719, #3967

  ;Linha 18
  static level4 + #720, #3967
  static level4 + #721, #3967
  static level4 + #722, #3692
  static level4 + #723, #15
  static level4 + #724, #15
  static level4 + #725, #45
  static level4 + #726, #45
  static level4 + #727, #45
  static level4 + #728, #45
  static level4 + #729, #45
  static level4 + #730, #45
  static level4 + #731, #45
  static level4 + #732, #45
  static level4 + #733, #45
  static level4 + #734, #45
  static level4 + #735, #45
  static level4 + #736, #45
  static level4 + #737, #45
  static level4 + #738, #45
  static level4 + #739, #45
  static level4 + #740, #45
  static level4 + #741, #45
  static level4 + #742, #45
  static level4 + #743, #45
  static level4 + #744, #45
  static level4 + #745, #45
  static level4 + #746, #45
  static level4 + #747, #45
  static level4 + #748, #45
  static level4 + #749, #45
  static level4 + #750, #45
  static level4 + #751, #2835
  static level4 + #752, #45
  static level4 + #753, #45
  static level4 + #754, #349
  static level4 + #755, #349
  static level4 + #756, #349
  static level4 + #757, #3691
  static level4 + #758, #3967
  static level4 + #759, #3967

  ;Linha 19
  static level4 + #760, #3967
  static level4 + #761, #3967
  static level4 + #762, #3692
  static level4 + #763, #15
  static level4 + #764, #15
  static level4 + #765, #349
  static level4 + #766, #349
  static level4 + #767, #31
  static level4 + #768, #349
  static level4 + #769, #349
  static level4 + #770, #349
  static level4 + #771, #31
  static level4 + #772, #349
  static level4 + #773, #349
  static level4 + #774, #3967
  static level4 + #775, #349
  static level4 + #776, #349
  static level4 + #777, #349
  static level4 + #778, #15
  static level4 + #779, #15
  static level4 + #780, #15
  static level4 + #781, #349
  static level4 + #782, #31
  static level4 + #783, #2350
  static level4 + #784, #349
  static level4 + #785, #15
  static level4 + #786, #15
  static level4 + #787, #15
  static level4 + #788, #349
  static level4 + #789, #349
  static level4 + #790, #349
  static level4 + #791, #15
  static level4 + #792, #15
  static level4 + #793, #15
  static level4 + #794, #349
  static level4 + #795, #349
  static level4 + #796, #349
  static level4 + #797, #3691
  static level4 + #798, #3967
  static level4 + #799, #3967

  ;Linha 20
  static level4 + #800, #3967
  static level4 + #801, #3967
  static level4 + #802, #3692
  static level4 + #803, #2835
  static level4 + #804, #15
  static level4 + #805, #349
  static level4 + #806, #349
  static level4 + #807, #31
  static level4 + #808, #349
  static level4 + #809, #349
  static level4 + #810, #349
  static level4 + #811, #31
  static level4 + #812, #349
  static level4 + #813, #15
  static level4 + #814, #15
  static level4 + #815, #15
  static level4 + #816, #45
  static level4 + #817, #45
  static level4 + #818, #15
  static level4 + #819, #15
  static level4 + #820, #15
  static level4 + #821, #349
  static level4 + #822, #349
  static level4 + #823, #349
  static level4 + #824, #349
  static level4 + #825, #15
  static level4 + #826, #15
  static level4 + #827, #15
  static level4 + #828, #349
  static level4 + #829, #349
  static level4 + #830, #349
  static level4 + #831, #15
  static level4 + #832, #15
  static level4 + #833, #15
  static level4 + #834, #349
  static level4 + #835, #349
  static level4 + #836, #349
  static level4 + #837, #3691
  static level4 + #838, #3967
  static level4 + #839, #3967

  ;Linha 21
  static level4 + #840, #3967
  static level4 + #841, #3967
  static level4 + #842, #3692
  static level4 + #843, #15
  static level4 + #844, #15
  static level4 + #845, #1301
  static level4 + #846, #31
  static level4 + #847, #31
  static level4 + #848, #349
  static level4 + #849, #31
  static level4 + #850, #349
  static level4 + #851, #31
  static level4 + #852, #31
  static level4 + #853, #15
  static level4 + #854, #15
  static level4 + #855, #15
  static level4 + #856, #45
  static level4 + #857, #45
  static level4 + #858, #15
  static level4 + #859, #2835
  static level4 + #860, #15
  static level4 + #861, #349
  static level4 + #862, #349
  static level4 + #863, #349
  static level4 + #864, #349
  static level4 + #865, #15
  static level4 + #866, #15
  static level4 + #867, #15
  static level4 + #868, #45
  static level4 + #869, #45
  static level4 + #870, #45
  static level4 + #871, #15
  static level4 + #872, #15
  static level4 + #873, #15
  static level4 + #874, #349
  static level4 + #875, #349
  static level4 + #876, #349
  static level4 + #877, #3691
  static level4 + #878, #3967
  static level4 + #879, #3967

  ;Linha 22
  static level4 + #880, #3967
  static level4 + #881, #3967
  static level4 + #882, #3692
  static level4 + #883, #15
  static level4 + #884, #15
  static level4 + #885, #31
  static level4 + #886, #31
  static level4 + #887, #31
  static level4 + #888, #31
  static level4 + #889, #1556
  static level4 + #890, #31
  static level4 + #891, #31
  static level4 + #892, #31
  static level4 + #893, #15
  static level4 + #894, #15
  static level4 + #895, #15
  static level4 + #896, #45
  static level4 + #897, #45
  static level4 + #898, #15
  static level4 + #899, #15
  static level4 + #900, #15
  static level4 + #901, #31
  static level4 + #902, #31
  static level4 + #903, #349
  static level4 + #904, #31
  static level4 + #905, #15
  static level4 + #906, #15
  static level4 + #907, #15
  static level4 + #908, #45
  static level4 + #909, #1556
  static level4 + #910, #45
  static level4 + #911, #15
  static level4 + #912, #15
  static level4 + #913, #15
  static level4 + #914, #349
  static level4 + #915, #349
  static level4 + #916, #349
  static level4 + #917, #3691
  static level4 + #918, #3967
  static level4 + #919, #3967

  ;Linha 23
  static level4 + #920, #3967
  static level4 + #921, #3967
  static level4 + #922, #3692
  static level4 + #923, #15
  static level4 + #924, #15
  static level4 + #925, #31
  static level4 + #926, #31
  static level4 + #927, #31
  static level4 + #928, #31
  static level4 + #929, #31
  static level4 + #930, #31
  static level4 + #931, #31
  static level4 + #932, #31
  static level4 + #933, #15
  static level4 + #934, #15
  static level4 + #935, #15
  static level4 + #936, #349
  static level4 + #937, #349
  static level4 + #938, #15
  static level4 + #939, #15
  static level4 + #940, #15
  static level4 + #941, #31
  static level4 + #942, #31
  static level4 + #943, #31
  static level4 + #944, #31
  static level4 + #945, #15
  static level4 + #946, #15
  static level4 + #947, #15
  static level4 + #948, #45
  static level4 + #949, #45
  static level4 + #950, #45
  static level4 + #951, #15
  static level4 + #952, #15
  static level4 + #953, #15
  static level4 + #954, #349
  static level4 + #955, #349
  static level4 + #956, #349
  static level4 + #957, #3691
  static level4 + #958, #3967
  static level4 + #959, #3967

  ;Linha 24
  static level4 + #960, #3967
  static level4 + #961, #3967
  static level4 + #962, #3692
  static level4 + #963, #15
  static level4 + #964, #15
  static level4 + #965, #349
  static level4 + #966, #349
  static level4 + #967, #31
  static level4 + #968, #349
  static level4 + #969, #349
  static level4 + #970, #31
  static level4 + #971, #349
  static level4 + #972, #349
  static level4 + #973, #15
  static level4 + #974, #15
  static level4 + #975, #15
  static level4 + #976, #349
  static level4 + #977, #349
  static level4 + #978, #15
  static level4 + #979, #15
  static level4 + #980, #15
  static level4 + #981, #349
  static level4 + #982, #31
  static level4 + #983, #31
  static level4 + #984, #31
  static level4 + #985, #31
  static level4 + #986, #349
  static level4 + #987, #349
  static level4 + #988, #349
  static level4 + #989, #31
  static level4 + #990, #349
  static level4 + #991, #349
  static level4 + #992, #349
  static level4 + #993, #31
  static level4 + #994, #349
  static level4 + #995, #349
  static level4 + #996, #349
  static level4 + #997, #3691
  static level4 + #998, #3967
  static level4 + #999, #3967

  ;Linha 25
  static level4 + #1000, #3967
  static level4 + #1001, #3967
  static level4 + #1002, #3692
  static level4 + #1003, #15
  static level4 + #1004, #15
  static level4 + #1005, #349
  static level4 + #1006, #349
  static level4 + #1007, #31
  static level4 + #1008, #349
  static level4 + #1009, #349
  static level4 + #1010, #31
  static level4 + #1011, #349
  static level4 + #1012, #349
  static level4 + #1013, #45
  static level4 + #1014, #1556
  static level4 + #1015, #45
  static level4 + #1016, #45
  static level4 + #1017, #45
  static level4 + #1018, #45
  static level4 + #1019, #45
  static level4 + #1020, #45
  static level4 + #1021, #349
  static level4 + #1022, #31
  static level4 + #1023, #31
  static level4 + #1024, #31
  static level4 + #1025, #31
  static level4 + #1026, #349
  static level4 + #1027, #349
  static level4 + #1028, #349
  static level4 + #1029, #31
  static level4 + #1030, #349
  static level4 + #1031, #349
  static level4 + #1032, #349
  static level4 + #1033, #31
  static level4 + #1034, #349
  static level4 + #1035, #349
  static level4 + #1036, #349
  static level4 + #1037, #3691
  static level4 + #1038, #3967
  static level4 + #1039, #3967

  ;Linha 26
  static level4 + #1040, #3967
  static level4 + #1041, #3967
  static level4 + #1042, #3692
  static level4 + #1043, #2859
  static level4 + #1044, #15
  static level4 + #1045, #349
  static level4 + #1046, #349
  static level4 + #1047, #31
  static level4 + #1048, #349
  static level4 + #1049, #349
  static level4 + #1050, #31
  static level4 + #1051, #349
  static level4 + #1052, #349
  static level4 + #1053, #45
  static level4 + #1054, #45
  static level4 + #1055, #45
  static level4 + #1056, #45
  static level4 + #1057, #45
  static level4 + #1058, #45
  static level4 + #1059, #45
  static level4 + #1060, #45
  static level4 + #1061, #349
  static level4 + #1062, #2350
  static level4 + #1063, #31
  static level4 + #1064, #349
  static level4 + #1065, #31
  static level4 + #1066, #349
  static level4 + #1067, #349
  static level4 + #1068, #349
  static level4 + #1069, #31
  static level4 + #1070, #349
  static level4 + #1071, #349
  static level4 + #1072, #349
  static level4 + #1073, #31
  static level4 + #1074, #349
  static level4 + #1075, #349
  static level4 + #1076, #349
  static level4 + #1077, #3691
  static level4 + #1078, #3967
  static level4 + #1079, #3967

  ;Linha 27
  static level4 + #1080, #3967
  static level4 + #1081, #3967
  static level4 + #1082, #3695
  static level4 + #1083, #3689
  static level4 + #1084, #3689
  static level4 + #1085, #3689
  static level4 + #1086, #3689
  static level4 + #1087, #3689
  static level4 + #1088, #3689
  static level4 + #1089, #3689
  static level4 + #1090, #3689
  static level4 + #1091, #3689
  static level4 + #1092, #3689
  static level4 + #1093, #3689
  static level4 + #1094, #3689
  static level4 + #1095, #3689
  static level4 + #1096, #3689
  static level4 + #1097, #3689
  static level4 + #1098, #3689
  static level4 + #1099, #3689
  static level4 + #1100, #3689
  static level4 + #1101, #3689
  static level4 + #1102, #3689
  static level4 + #1103, #3689
  static level4 + #1104, #3689
  static level4 + #1105, #3689
  static level4 + #1106, #3689
  static level4 + #1107, #3689
  static level4 + #1108, #3689
  static level4 + #1109, #3689
  static level4 + #1110, #3689
  static level4 + #1111, #3689
  static level4 + #1112, #3689
  static level4 + #1113, #3689
  static level4 + #1114, #3689
  static level4 + #1115, #3689
  static level4 + #1116, #3689
  static level4 + #1117, #3694
  static level4 + #1118, #3967
  static level4 + #1119, #3967

  ;Linha 28
  static level4 + #1120, #3967
  static level4 + #1121, #3967
  static level4 + #1122, #3967
  static level4 + #1123, #3967
  static level4 + #1124, #3967
  static level4 + #1125, #3967
  static level4 + #1126, #3967
  static level4 + #1127, #3967
  static level4 + #1128, #3967
  static level4 + #1129, #3967
  static level4 + #1130, #3967
  static level4 + #1131, #3967
  static level4 + #1132, #3967
  static level4 + #1133, #3967
  static level4 + #1134, #3967
  static level4 + #1135, #3967
  static level4 + #1136, #3967
  static level4 + #1137, #3967
  static level4 + #1138, #3967
  static level4 + #1139, #3967
  static level4 + #1140, #3967
  static level4 + #1141, #3967
  static level4 + #1142, #3967
  static level4 + #1143, #3967
  static level4 + #1144, #3967
  static level4 + #1145, #3967
  static level4 + #1146, #3967
  static level4 + #1147, #3967
  static level4 + #1148, #3967
  static level4 + #1149, #3967
  static level4 + #1150, #3967
  static level4 + #1151, #3967
  static level4 + #1152, #3967
  static level4 + #1153, #3967
  static level4 + #1154, #3967
  static level4 + #1155, #3967
  static level4 + #1156, #3967
  static level4 + #1157, #3967
  static level4 + #1158, #3967
  static level4 + #1159, #3967

  ;Linha 29
  static level4 + #1160, #3967
  static level4 + #1161, #3967
  static level4 + #1162, #3967
  static level4 + #1163, #3967
  static level4 + #1164, #3967
  static level4 + #1165, #3967
  static level4 + #1166, #3967
  static level4 + #1167, #3967
  static level4 + #1168, #3967
  static level4 + #1169, #3967
  static level4 + #1170, #3967
  static level4 + #1171, #3967
  static level4 + #1172, #3967
  static level4 + #1173, #3967
  static level4 + #1174, #3967
  static level4 + #1175, #3967
  static level4 + #1176, #3967
  static level4 + #1177, #3967
  static level4 + #1178, #3967
  static level4 + #1179, #3967
  static level4 + #1180, #3967
  static level4 + #1181, #3967
  static level4 + #1182, #3967
  static level4 + #1183, #3967
  static level4 + #1184, #3967
  static level4 + #1185, #3967
  static level4 + #1186, #3967
  static level4 + #1187, #3967
  static level4 + #1188, #3967
  static level4 + #1189, #3967
  static level4 + #1190, #3967
  static level4 + #1191, #3967
  static level4 + #1192, #3967
  static level4 + #1193, #3967
  static level4 + #1194, #3967
  static level4 + #1195, #3967
  static level4 + #1196, #3967
  static level4 + #1197, #3967
  static level4 + #1198, #3967
  static level4 + #1199, #3967

PointsRules : var #1200
  ;Linha 0
  static PointsRules + #0, #3967
  static PointsRules + #1, #3967
  static PointsRules + #2, #3967
  static PointsRules + #3, #3967
  static PointsRules + #4, #3967
  static PointsRules + #5, #3967
  static PointsRules + #6, #3967
  static PointsRules + #7, #3967
  static PointsRules + #8, #3967
  static PointsRules + #9, #3967
  static PointsRules + #10, #3967
  static PointsRules + #11, #3967
  static PointsRules + #12, #3967
  static PointsRules + #13, #3967
  static PointsRules + #14, #3967
  static PointsRules + #15, #3967
  static PointsRules + #16, #3967
  static PointsRules + #17, #3967
  static PointsRules + #18, #3967
  static PointsRules + #19, #3967
  static PointsRules + #20, #3967
  static PointsRules + #21, #3967
  static PointsRules + #22, #3967
  static PointsRules + #23, #3967
  static PointsRules + #24, #3967
  static PointsRules + #25, #3967
  static PointsRules + #26, #3967
  static PointsRules + #27, #3967
  static PointsRules + #28, #3967
  static PointsRules + #29, #3967
  static PointsRules + #30, #3967
  static PointsRules + #31, #3967
  static PointsRules + #32, #3967
  static PointsRules + #33, #3967
  static PointsRules + #34, #3967
  static PointsRules + #35, #3967
  static PointsRules + #36, #3967
  static PointsRules + #37, #3967
  static PointsRules + #38, #3967
  static PointsRules + #39, #3967

  ;Linha 1
  static PointsRules + #40, #3967
  static PointsRules + #41, #3967
  static PointsRules + #42, #3967
  static PointsRules + #43, #3967
  static PointsRules + #44, #3967
  static PointsRules + #45, #3967
  static PointsRules + #46, #3967
  static PointsRules + #47, #3967
  static PointsRules + #48, #3967
  static PointsRules + #49, #3967
  static PointsRules + #50, #3967
  static PointsRules + #51, #3967
  static PointsRules + #52, #3967
  static PointsRules + #53, #3967
  static PointsRules + #54, #3967
  static PointsRules + #55, #3967
  static PointsRules + #56, #3967
  static PointsRules + #57, #3967
  static PointsRules + #58, #3967
  static PointsRules + #59, #3967
  static PointsRules + #60, #3967
  static PointsRules + #61, #3967
  static PointsRules + #62, #3967
  static PointsRules + #63, #3967
  static PointsRules + #64, #3967
  static PointsRules + #65, #3967
  static PointsRules + #66, #3967
  static PointsRules + #67, #3967
  static PointsRules + #68, #3967
  static PointsRules + #69, #3967
  static PointsRules + #70, #3967
  static PointsRules + #71, #3967
  static PointsRules + #72, #3967
  static PointsRules + #73, #3967
  static PointsRules + #74, #3967
  static PointsRules + #75, #3967
  static PointsRules + #76, #3967
  static PointsRules + #77, #3967
  static PointsRules + #78, #3967
  static PointsRules + #79, #3967

  ;Linha 2
  static PointsRules + #80, #3967
  static PointsRules + #81, #3967
  static PointsRules + #82, #3967
  static PointsRules + #83, #3967
  static PointsRules + #84, #3967
  static PointsRules + #85, #3967
  static PointsRules + #86, #3967
  static PointsRules + #87, #3967
  static PointsRules + #88, #3967
  static PointsRules + #89, #3967
  static PointsRules + #90, #82
  static PointsRules + #91, #69
  static PointsRules + #92, #71
  static PointsRules + #93, #82
  static PointsRules + #94, #65
  static PointsRules + #95, #83
  static PointsRules + #96, #3967
  static PointsRules + #97, #68
  static PointsRules + #98, #69
  static PointsRules + #99, #3967
  static PointsRules + #100, #80
  static PointsRules + #101, #79
  static PointsRules + #102, #78
  static PointsRules + #103, #84
  static PointsRules + #104, #85
  static PointsRules + #105, #65
  static PointsRules + #106, #67
  static PointsRules + #107, #65
  static PointsRules + #108, #79
  static PointsRules + #109, #3967
  static PointsRules + #110, #3967
  static PointsRules + #111, #3967
  static PointsRules + #112, #3967
  static PointsRules + #113, #3967
  static PointsRules + #114, #3967
  static PointsRules + #115, #3967
  static PointsRules + #116, #3967
  static PointsRules + #117, #3967
  static PointsRules + #118, #3967
  static PointsRules + #119, #3967

  ;Linha 3
  static PointsRules + #120, #3967
  static PointsRules + #121, #3967
  static PointsRules + #122, #3967
  static PointsRules + #123, #3967
  static PointsRules + #124, #3967
  static PointsRules + #125, #3967
  static PointsRules + #126, #3967
  static PointsRules + #127, #3967
  static PointsRules + #128, #3967
  static PointsRules + #129, #3967
  static PointsRules + #130, #3967
  static PointsRules + #131, #3967
  static PointsRules + #132, #3967
  static PointsRules + #133, #3967
  static PointsRules + #134, #3967
  static PointsRules + #135, #3967
  static PointsRules + #136, #3967
  static PointsRules + #137, #3967
  static PointsRules + #138, #3967
  static PointsRules + #139, #3967
  static PointsRules + #140, #3967
  static PointsRules + #141, #3967
  static PointsRules + #142, #3967
  static PointsRules + #143, #3967
  static PointsRules + #144, #3967
  static PointsRules + #145, #3967
  static PointsRules + #146, #3967
  static PointsRules + #147, #3967
  static PointsRules + #148, #3967
  static PointsRules + #149, #3967
  static PointsRules + #150, #3967
  static PointsRules + #151, #3967
  static PointsRules + #152, #3967
  static PointsRules + #153, #3967
  static PointsRules + #154, #3967
  static PointsRules + #155, #3967
  static PointsRules + #156, #3967
  static PointsRules + #157, #3967
  static PointsRules + #158, #3967
  static PointsRules + #159, #3967

  ;Linha 4
  static PointsRules + #160, #3967
  static PointsRules + #161, #3967
  static PointsRules + #162, #3967
  static PointsRules + #163, #3967
  static PointsRules + #164, #3967
  static PointsRules + #165, #3967
  static PointsRules + #166, #3967
  static PointsRules + #167, #3967
  static PointsRules + #168, #3967
  static PointsRules + #169, #3967
  static PointsRules + #170, #3967
  static PointsRules + #171, #3967
  static PointsRules + #172, #3967
  static PointsRules + #173, #3967
  static PointsRules + #174, #3967
  static PointsRules + #175, #3967
  static PointsRules + #176, #3967
  static PointsRules + #177, #3967
  static PointsRules + #178, #3967
  static PointsRules + #179, #3967
  static PointsRules + #180, #3967
  static PointsRules + #181, #3967
  static PointsRules + #182, #3967
  static PointsRules + #183, #3967
  static PointsRules + #184, #3967
  static PointsRules + #185, #3967
  static PointsRules + #186, #3967
  static PointsRules + #187, #3967
  static PointsRules + #188, #3967
  static PointsRules + #189, #3967
  static PointsRules + #190, #3967
  static PointsRules + #191, #3967
  static PointsRules + #192, #3967
  static PointsRules + #193, #3967
  static PointsRules + #194, #3967
  static PointsRules + #195, #3967
  static PointsRules + #196, #3967
  static PointsRules + #197, #3967
  static PointsRules + #198, #3967
  static PointsRules + #199, #3967

  ;Linha 5
  static PointsRules + #200, #3967
  static PointsRules + #201, #3967
  static PointsRules + #202, #3967
  static PointsRules + #203, #3967
  static PointsRules + #204, #3967
  static PointsRules + #205, #3967
  static PointsRules + #206, #3967
  static PointsRules + #207, #3967
  static PointsRules + #208, #3967
  static PointsRules + #209, #3967
  static PointsRules + #210, #3967
  static PointsRules + #211, #3967
  static PointsRules + #212, #3967
  static PointsRules + #213, #3967
  static PointsRules + #214, #3967
  static PointsRules + #215, #3967
  static PointsRules + #216, #3967
  static PointsRules + #217, #3967
  static PointsRules + #218, #3967
  static PointsRules + #219, #3967
  static PointsRules + #220, #3967
  static PointsRules + #221, #3967
  static PointsRules + #222, #3967
  static PointsRules + #223, #3967
  static PointsRules + #224, #3967
  static PointsRules + #225, #3967
  static PointsRules + #226, #3967
  static PointsRules + #227, #3967
  static PointsRules + #228, #3967
  static PointsRules + #229, #3967
  static PointsRules + #230, #3967
  static PointsRules + #231, #3967
  static PointsRules + #232, #3967
  static PointsRules + #233, #3967
  static PointsRules + #234, #3967
  static PointsRules + #235, #3967
  static PointsRules + #236, #3967
  static PointsRules + #237, #3967
  static PointsRules + #238, #3967
  static PointsRules + #239, #3967

  ;Linha 6
  static PointsRules + #240, #3967
  static PointsRules + #241, #3967
  static PointsRules + #242, #3967
  static PointsRules + #243, #3967
  static PointsRules + #244, #2909
  static PointsRules + #245, #2909
  static PointsRules + #246, #2909
  static PointsRules + #247, #2909
  static PointsRules + #248, #3967
  static PointsRules + #249, #3967
  static PointsRules + #250, #3967
  static PointsRules + #251, #3967
  static PointsRules + #252, #3967
  static PointsRules + #253, #3967
  static PointsRules + #254, #3967
  static PointsRules + #255, #3967
  static PointsRules + #256, #3967
  static PointsRules + #257, #3967
  static PointsRules + #258, #3967
  static PointsRules + #259, #3967
  static PointsRules + #260, #3967
  static PointsRules + #261, #3967
  static PointsRules + #262, #3967
  static PointsRules + #263, #3967
  static PointsRules + #264, #3967
  static PointsRules + #265, #3967
  static PointsRules + #266, #3967
  static PointsRules + #267, #3967
  static PointsRules + #268, #3967
  static PointsRules + #269, #3967
  static PointsRules + #270, #3967
  static PointsRules + #271, #3967
  static PointsRules + #272, #3967
  static PointsRules + #273, #3967
  static PointsRules + #274, #3967
  static PointsRules + #275, #3967
  static PointsRules + #276, #3967
  static PointsRules + #277, #3967
  static PointsRules + #278, #3967
  static PointsRules + #279, #3967

  ;Linha 7
  static PointsRules + #280, #3967
  static PointsRules + #281, #3967
  static PointsRules + #282, #3967
  static PointsRules + #283, #2909
  static PointsRules + #284, #2909
  static PointsRules + #285, #3967
  static PointsRules + #286, #2909
  static PointsRules + #287, #2909
  static PointsRules + #288, #2909
  static PointsRules + #289, #3967
  static PointsRules + #290, #3967
  static PointsRules + #291, #77
  static PointsRules + #292, #79
  static PointsRules + #293, #69
  static PointsRules + #294, #68
  static PointsRules + #295, #65
  static PointsRules + #296, #83
  static PointsRules + #297, #3967
  static PointsRules + #298, #71
  static PointsRules + #299, #65
  static PointsRules + #300, #82
  static PointsRules + #301, #65
  static PointsRules + #302, #78
  static PointsRules + #303, #84
  static PointsRules + #304, #69
  static PointsRules + #305, #77
  static PointsRules + #306, #3967
  static PointsRules + #307, #3967
  static PointsRules + #308, #3967
  static PointsRules + #309, #3967
  static PointsRules + #310, #3967
  static PointsRules + #311, #3967
  static PointsRules + #312, #3967
  static PointsRules + #313, #3967
  static PointsRules + #314, #3967
  static PointsRules + #315, #3967
  static PointsRules + #316, #3967
  static PointsRules + #317, #3967
  static PointsRules + #318, #3967
  static PointsRules + #319, #3967

  ;Linha 8
  static PointsRules + #320, #3967
  static PointsRules + #321, #3967
  static PointsRules + #322, #3967
  static PointsRules + #323, #2909
  static PointsRules + #324, #3967
  static PointsRules + #325, #3967
  static PointsRules + #326, #3967
  static PointsRules + #327, #2909
  static PointsRules + #328, #2909
  static PointsRules + #329, #3967
  static PointsRules + #330, #3967
  static PointsRules + #331, #3967
  static PointsRules + #332, #3967
  static PointsRules + #333, #3967
  static PointsRules + #334, #3967
  static PointsRules + #335, #3967
  static PointsRules + #336, #3967
  static PointsRules + #337, #3967
  static PointsRules + #338, #3967
  static PointsRules + #339, #3967
  static PointsRules + #340, #3967
  static PointsRules + #341, #3967
  static PointsRules + #342, #3967
  static PointsRules + #343, #3967
  static PointsRules + #344, #3967
  static PointsRules + #345, #3967
  static PointsRules + #346, #3967
  static PointsRules + #347, #3967
  static PointsRules + #348, #3967
  static PointsRules + #349, #3967
  static PointsRules + #350, #3967
  static PointsRules + #351, #3967
  static PointsRules + #352, #3967
  static PointsRules + #353, #3967
  static PointsRules + #354, #3967
  static PointsRules + #355, #3967
  static PointsRules + #356, #3967
  static PointsRules + #357, #3967
  static PointsRules + #358, #3967
  static PointsRules + #359, #3967

  ;Linha 9
  static PointsRules + #360, #3967
  static PointsRules + #361, #3967
  static PointsRules + #362, #3967
  static PointsRules + #363, #2909
  static PointsRules + #364, #2909
  static PointsRules + #365, #3967
  static PointsRules + #366, #2909
  static PointsRules + #367, #2909
  static PointsRules + #368, #2909
  static PointsRules + #369, #3967
  static PointsRules + #370, #3967
  static PointsRules + #371, #49
  static PointsRules + #372, #48
  static PointsRules + #373, #48
  static PointsRules + #374, #3967
  static PointsRules + #375, #80
  static PointsRules + #376, #79
  static PointsRules + #377, #78
  static PointsRules + #378, #84
  static PointsRules + #379, #79
  static PointsRules + #380, #83
  static PointsRules + #381, #3967
  static PointsRules + #382, #3967
  static PointsRules + #383, #3967
  static PointsRules + #384, #3967
  static PointsRules + #385, #3967
  static PointsRules + #386, #3967
  static PointsRules + #387, #3967
  static PointsRules + #388, #3967
  static PointsRules + #389, #3967
  static PointsRules + #390, #3967
  static PointsRules + #391, #3967
  static PointsRules + #392, #3967
  static PointsRules + #393, #3967
  static PointsRules + #394, #3967
  static PointsRules + #395, #3967
  static PointsRules + #396, #3967
  static PointsRules + #397, #3967
  static PointsRules + #398, #3967
  static PointsRules + #399, #3967

  ;Linha 10
  static PointsRules + #400, #3967
  static PointsRules + #401, #3967
  static PointsRules + #402, #3967
  static PointsRules + #403, #2909
  static PointsRules + #404, #2909
  static PointsRules + #405, #2909
  static PointsRules + #406, #2909
  static PointsRules + #407, #2909
  static PointsRules + #408, #2909
  static PointsRules + #409, #3967
  static PointsRules + #410, #3967
  static PointsRules + #411, #3967
  static PointsRules + #412, #3967
  static PointsRules + #413, #3967
  static PointsRules + #414, #3967
  static PointsRules + #415, #3967
  static PointsRules + #416, #3967
  static PointsRules + #417, #3967
  static PointsRules + #418, #3967
  static PointsRules + #419, #3967
  static PointsRules + #420, #3967
  static PointsRules + #421, #3967
  static PointsRules + #422, #3967
  static PointsRules + #423, #3967
  static PointsRules + #424, #3967
  static PointsRules + #425, #3967
  static PointsRules + #426, #3967
  static PointsRules + #427, #3967
  static PointsRules + #428, #3967
  static PointsRules + #429, #3967
  static PointsRules + #430, #3967
  static PointsRules + #431, #3967
  static PointsRules + #432, #3967
  static PointsRules + #433, #3967
  static PointsRules + #434, #3967
  static PointsRules + #435, #3967
  static PointsRules + #436, #3967
  static PointsRules + #437, #3967
  static PointsRules + #438, #3967
  static PointsRules + #439, #3967

  ;Linha 11
  static PointsRules + #440, #3967
  static PointsRules + #441, #3967
  static PointsRules + #442, #3967
  static PointsRules + #443, #3967
  static PointsRules + #444, #2909
  static PointsRules + #445, #2909
  static PointsRules + #446, #2909
  static PointsRules + #447, #2909
  static PointsRules + #448, #3967
  static PointsRules + #449, #3967
  static PointsRules + #450, #3967
  static PointsRules + #451, #3967
  static PointsRules + #452, #3967
  static PointsRules + #453, #3967
  static PointsRules + #454, #3967
  static PointsRules + #455, #3967
  static PointsRules + #456, #3967
  static PointsRules + #457, #3967
  static PointsRules + #458, #3967
  static PointsRules + #459, #3967
  static PointsRules + #460, #3967
  static PointsRules + #461, #3967
  static PointsRules + #462, #3967
  static PointsRules + #463, #3967
  static PointsRules + #464, #3967
  static PointsRules + #465, #3967
  static PointsRules + #466, #3967
  static PointsRules + #467, #3967
  static PointsRules + #468, #3967
  static PointsRules + #469, #3967
  static PointsRules + #470, #3967
  static PointsRules + #471, #3967
  static PointsRules + #472, #3967
  static PointsRules + #473, #3967
  static PointsRules + #474, #3967
  static PointsRules + #475, #3967
  static PointsRules + #476, #3967
  static PointsRules + #477, #3967
  static PointsRules + #478, #3967
  static PointsRules + #479, #3967

  ;Linha 12
  static PointsRules + #480, #3967
  static PointsRules + #481, #3967
  static PointsRules + #482, #3967
  static PointsRules + #483, #3967
  static PointsRules + #484, #3967
  static PointsRules + #485, #3967
  static PointsRules + #486, #3967
  static PointsRules + #487, #3967
  static PointsRules + #488, #3967
  static PointsRules + #489, #3967
  static PointsRules + #490, #3967
  static PointsRules + #491, #3967
  static PointsRules + #492, #3967
  static PointsRules + #493, #3967
  static PointsRules + #494, #3967
  static PointsRules + #495, #3967
  static PointsRules + #496, #3967
  static PointsRules + #497, #3967
  static PointsRules + #498, #3967
  static PointsRules + #499, #3967
  static PointsRules + #500, #3967
  static PointsRules + #501, #3967
  static PointsRules + #502, #3967
  static PointsRules + #503, #3967
  static PointsRules + #504, #3967
  static PointsRules + #505, #3967
  static PointsRules + #506, #3967
  static PointsRules + #507, #3967
  static PointsRules + #508, #3967
  static PointsRules + #509, #3967
  static PointsRules + #510, #3967
  static PointsRules + #511, #3967
  static PointsRules + #512, #3967
  static PointsRules + #513, #3967
  static PointsRules + #514, #3967
  static PointsRules + #515, #3967
  static PointsRules + #516, #3967
  static PointsRules + #517, #3967
  static PointsRules + #518, #3967
  static PointsRules + #519, #3967

  ;Linha 13
  static PointsRules + #520, #3967
  static PointsRules + #521, #3967
  static PointsRules + #522, #3967
  static PointsRules + #523, #3967
  static PointsRules + #524, #3967
  static PointsRules + #525, #3967
  static PointsRules + #526, #3967
  static PointsRules + #527, #3967
  static PointsRules + #528, #3967
  static PointsRules + #529, #3967
  static PointsRules + #530, #3967
  static PointsRules + #531, #3967
  static PointsRules + #532, #3967
  static PointsRules + #533, #3967
  static PointsRules + #534, #3967
  static PointsRules + #535, #3967
  static PointsRules + #536, #3967
  static PointsRules + #537, #3967
  static PointsRules + #538, #3967
  static PointsRules + #539, #3967
  static PointsRules + #540, #3967
  static PointsRules + #541, #3967
  static PointsRules + #542, #3967
  static PointsRules + #543, #3967
  static PointsRules + #544, #3967
  static PointsRules + #545, #3967
  static PointsRules + #546, #3967
  static PointsRules + #547, #3967
  static PointsRules + #548, #3967
  static PointsRules + #549, #3967
  static PointsRules + #550, #3967
  static PointsRules + #551, #3967
  static PointsRules + #552, #3967
  static PointsRules + #553, #3967
  static PointsRules + #554, #3967
  static PointsRules + #555, #3967
  static PointsRules + #556, #3967
  static PointsRules + #557, #3967
  static PointsRules + #558, #3967
  static PointsRules + #559, #3967

  ;Linha 14
  static PointsRules + #560, #3967
  static PointsRules + #561, #3967
  static PointsRules + #562, #3967
  static PointsRules + #563, #1629
  static PointsRules + #564, #1629
  static PointsRules + #565, #1629
  static PointsRules + #566, #1629
  static PointsRules + #567, #1629
  static PointsRules + #568, #1629
  static PointsRules + #569, #3967
  static PointsRules + #570, #3967
  static PointsRules + #571, #3967
  static PointsRules + #572, #3967
  static PointsRules + #573, #3967
  static PointsRules + #574, #3967
  static PointsRules + #575, #3967
  static PointsRules + #576, #3967
  static PointsRules + #577, #3967
  static PointsRules + #578, #3967
  static PointsRules + #579, #3967
  static PointsRules + #580, #3967
  static PointsRules + #581, #3967
  static PointsRules + #582, #3967
  static PointsRules + #583, #3967
  static PointsRules + #584, #3967
  static PointsRules + #585, #3967
  static PointsRules + #586, #3967
  static PointsRules + #587, #3967
  static PointsRules + #588, #3967
  static PointsRules + #589, #3967
  static PointsRules + #590, #3967
  static PointsRules + #591, #3967
  static PointsRules + #592, #3967
  static PointsRules + #593, #3967
  static PointsRules + #594, #3967
  static PointsRules + #595, #3967
  static PointsRules + #596, #3967
  static PointsRules + #597, #3967
  static PointsRules + #598, #3967
  static PointsRules + #599, #3967

  ;Linha 15
  static PointsRules + #600, #3967
  static PointsRules + #601, #3967
  static PointsRules + #602, #1629
  static PointsRules + #603, #3967
  static PointsRules + #604, #3967
  static PointsRules + #605, #1629
  static PointsRules + #606, #1629
  static PointsRules + #607, #1629
  static PointsRules + #608, #1629
  static PointsRules + #609, #1629
  static PointsRules + #610, #3967
  static PointsRules + #611, #3967
  static PointsRules + #612, #68
  static PointsRules + #613, #73
  static PointsRules + #614, #65
  static PointsRules + #615, #77
  static PointsRules + #616, #65
  static PointsRules + #617, #78
  static PointsRules + #618, #84
  static PointsRules + #619, #69
  static PointsRules + #620, #83
  static PointsRules + #621, #3967
  static PointsRules + #622, #71
  static PointsRules + #623, #65
  static PointsRules + #624, #82
  static PointsRules + #625, #65
  static PointsRules + #626, #78
  static PointsRules + #627, #84
  static PointsRules + #628, #69
  static PointsRules + #629, #77
  static PointsRules + #630, #3967
  static PointsRules + #631, #3967
  static PointsRules + #632, #3967
  static PointsRules + #633, #3967
  static PointsRules + #634, #3967
  static PointsRules + #635, #3967
  static PointsRules + #636, #3967
  static PointsRules + #637, #3967
  static PointsRules + #638, #3967
  static PointsRules + #639, #3967

  ;Linha 16
  static PointsRules + #640, #3967
  static PointsRules + #641, #1629
  static PointsRules + #642, #3967
  static PointsRules + #643, #3967
  static PointsRules + #644, #1629
  static PointsRules + #645, #1629
  static PointsRules + #646, #1629
  static PointsRules + #647, #1629
  static PointsRules + #648, #1629
  static PointsRules + #649, #1629
  static PointsRules + #650, #1629
  static PointsRules + #651, #3967
  static PointsRules + #652, #3967
  static PointsRules + #653, #3967
  static PointsRules + #654, #3967
  static PointsRules + #655, #3967
  static PointsRules + #656, #3967
  static PointsRules + #657, #3967
  static PointsRules + #658, #3967
  static PointsRules + #659, #3967
  static PointsRules + #660, #3967
  static PointsRules + #661, #3967
  static PointsRules + #662, #3967
  static PointsRules + #663, #3967
  static PointsRules + #664, #3967
  static PointsRules + #665, #3967
  static PointsRules + #666, #3967
  static PointsRules + #667, #3967
  static PointsRules + #668, #3967
  static PointsRules + #669, #3967
  static PointsRules + #670, #3967
  static PointsRules + #671, #3967
  static PointsRules + #672, #3967
  static PointsRules + #673, #3967
  static PointsRules + #674, #3967
  static PointsRules + #675, #3967
  static PointsRules + #676, #3967
  static PointsRules + #677, #3967
  static PointsRules + #678, #3967
  static PointsRules + #679, #3967

  ;Linha 17
  static PointsRules + #680, #3967
  static PointsRules + #681, #3967
  static PointsRules + #682, #1629
  static PointsRules + #683, #1629
  static PointsRules + #684, #1629
  static PointsRules + #685, #1629
  static PointsRules + #686, #1629
  static PointsRules + #687, #1629
  static PointsRules + #688, #1629
  static PointsRules + #689, #1629
  static PointsRules + #690, #3967
  static PointsRules + #691, #3967
  static PointsRules + #692, #50
  static PointsRules + #693, #53
  static PointsRules + #694, #48
  static PointsRules + #695, #3967
  static PointsRules + #696, #53
  static PointsRules + #697, #48
  static PointsRules + #698, #48
  static PointsRules + #699, #3967
  static PointsRules + #700, #79
  static PointsRules + #701, #85
  static PointsRules + #702, #3967
  static PointsRules + #703, #49
  static PointsRules + #704, #48
  static PointsRules + #705, #48
  static PointsRules + #706, #48
  static PointsRules + #707, #3967
  static PointsRules + #708, #80
  static PointsRules + #709, #79
  static PointsRules + #710, #78
  static PointsRules + #711, #84
  static PointsRules + #712, #79
  static PointsRules + #713, #83
  static PointsRules + #714, #3967
  static PointsRules + #715, #3967
  static PointsRules + #716, #3967
  static PointsRules + #717, #3967
  static PointsRules + #718, #3967
  static PointsRules + #719, #3967

  ;Linha 18
  static PointsRules + #720, #3967
  static PointsRules + #721, #3967
  static PointsRules + #722, #3967
  static PointsRules + #723, #1629
  static PointsRules + #724, #1629
  static PointsRules + #725, #1629
  static PointsRules + #726, #1629
  static PointsRules + #727, #1629
  static PointsRules + #728, #1629
  static PointsRules + #729, #3967
  static PointsRules + #730, #3967
  static PointsRules + #731, #3967
  static PointsRules + #732, #3967
  static PointsRules + #733, #3967
  static PointsRules + #734, #3967
  static PointsRules + #735, #3967
  static PointsRules + #736, #3967
  static PointsRules + #737, #3967
  static PointsRules + #738, #3967
  static PointsRules + #739, #3967
  static PointsRules + #740, #3967
  static PointsRules + #741, #3967
  static PointsRules + #742, #3967
  static PointsRules + #743, #3967
  static PointsRules + #744, #3967
  static PointsRules + #745, #3967
  static PointsRules + #746, #3967
  static PointsRules + #747, #3967
  static PointsRules + #748, #3967
  static PointsRules + #749, #3967
  static PointsRules + #750, #3967
  static PointsRules + #751, #3967
  static PointsRules + #752, #3967
  static PointsRules + #753, #3967
  static PointsRules + #754, #3967
  static PointsRules + #755, #3967
  static PointsRules + #756, #3967
  static PointsRules + #757, #3967
  static PointsRules + #758, #3967
  static PointsRules + #759, #3967

  ;Linha 19
  static PointsRules + #760, #3967
  static PointsRules + #761, #3967
  static PointsRules + #762, #3967
  static PointsRules + #763, #3967
  static PointsRules + #764, #1629
  static PointsRules + #765, #1629
  static PointsRules + #766, #1629
  static PointsRules + #767, #1629
  static PointsRules + #768, #3967
  static PointsRules + #769, #3967
  static PointsRules + #770, #3967
  static PointsRules + #771, #3967
  static PointsRules + #772, #65
  static PointsRules + #773, #76
  static PointsRules + #774, #69
  static PointsRules + #775, #65
  static PointsRules + #776, #84
  static PointsRules + #777, #79
  static PointsRules + #778, #82
  static PointsRules + #779, #73
  static PointsRules + #780, #65
  static PointsRules + #781, #77
  static PointsRules + #782, #69
  static PointsRules + #783, #78
  static PointsRules + #784, #84
  static PointsRules + #785, #69
  static PointsRules + #786, #3967
  static PointsRules + #787, #3967
  static PointsRules + #788, #3967
  static PointsRules + #789, #3967
  static PointsRules + #790, #3967
  static PointsRules + #791, #3967
  static PointsRules + #792, #3967
  static PointsRules + #793, #3967
  static PointsRules + #794, #3967
  static PointsRules + #795, #3967
  static PointsRules + #796, #3967
  static PointsRules + #797, #3967
  static PointsRules + #798, #3967
  static PointsRules + #799, #3967

  ;Linha 20
  static PointsRules + #800, #3967
  static PointsRules + #801, #3967
  static PointsRules + #802, #3967
  static PointsRules + #803, #3967
  static PointsRules + #804, #3967
  static PointsRules + #805, #1629
  static PointsRules + #806, #1629
  static PointsRules + #807, #3967
  static PointsRules + #808, #3967
  static PointsRules + #809, #3967
  static PointsRules + #810, #3967
  static PointsRules + #811, #3967
  static PointsRules + #812, #3967
  static PointsRules + #813, #3967
  static PointsRules + #814, #3967
  static PointsRules + #815, #3967
  static PointsRules + #816, #3967
  static PointsRules + #817, #3967
  static PointsRules + #818, #3967
  static PointsRules + #819, #3967
  static PointsRules + #820, #3967
  static PointsRules + #821, #3967
  static PointsRules + #822, #3967
  static PointsRules + #823, #3967
  static PointsRules + #824, #3967
  static PointsRules + #825, #3967
  static PointsRules + #826, #3967
  static PointsRules + #827, #3967
  static PointsRules + #828, #3967
  static PointsRules + #829, #3967
  static PointsRules + #830, #3967
  static PointsRules + #831, #3967
  static PointsRules + #832, #3967
  static PointsRules + #833, #3967
  static PointsRules + #834, #3967
  static PointsRules + #835, #3967
  static PointsRules + #836, #3967
  static PointsRules + #837, #3967
  static PointsRules + #838, #3967
  static PointsRules + #839, #3967

  ;Linha 21
  static PointsRules + #840, #3967
  static PointsRules + #841, #3967
  static PointsRules + #842, #3967
  static PointsRules + #843, #3967
  static PointsRules + #844, #3967
  static PointsRules + #845, #3967
  static PointsRules + #846, #3967
  static PointsRules + #847, #3967
  static PointsRules + #848, #3967
  static PointsRules + #849, #3967
  static PointsRules + #850, #3967
  static PointsRules + #851, #3967
  static PointsRules + #852, #3967
  static PointsRules + #853, #3967
  static PointsRules + #854, #3967
  static PointsRules + #855, #3967
  static PointsRules + #856, #3967
  static PointsRules + #857, #3967
  static PointsRules + #858, #3967
  static PointsRules + #859, #3967
  static PointsRules + #860, #3967
  static PointsRules + #861, #3967
  static PointsRules + #862, #3967
  static PointsRules + #863, #3967
  static PointsRules + #864, #3967
  static PointsRules + #865, #3967
  static PointsRules + #866, #3967
  static PointsRules + #867, #3967
  static PointsRules + #868, #3967
  static PointsRules + #869, #3967
  static PointsRules + #870, #3967
  static PointsRules + #871, #3967
  static PointsRules + #872, #3967
  static PointsRules + #873, #3967
  static PointsRules + #874, #3967
  static PointsRules + #875, #3967
  static PointsRules + #876, #3967
  static PointsRules + #877, #3967
  static PointsRules + #878, #3967
  static PointsRules + #879, #3967

  ;Linha 22
  static PointsRules + #880, #3967
  static PointsRules + #881, #3967
  static PointsRules + #882, #3967
  static PointsRules + #883, #3967
  static PointsRules + #884, #3967
  static PointsRules + #885, #3967
  static PointsRules + #886, #3967
  static PointsRules + #887, #3967
  static PointsRules + #888, #3967
  static PointsRules + #889, #3967
  static PointsRules + #890, #3967
  static PointsRules + #891, #3967
  static PointsRules + #892, #3967
  static PointsRules + #893, #3967
  static PointsRules + #894, #3967
  static PointsRules + #895, #3967
  static PointsRules + #896, #3967
  static PointsRules + #897, #3967
  static PointsRules + #898, #3967
  static PointsRules + #899, #3967
  static PointsRules + #900, #3967
  static PointsRules + #901, #3967
  static PointsRules + #902, #3967
  static PointsRules + #903, #3967
  static PointsRules + #904, #3967
  static PointsRules + #905, #3967
  static PointsRules + #906, #3967
  static PointsRules + #907, #3967
  static PointsRules + #908, #3967
  static PointsRules + #909, #3967
  static PointsRules + #910, #3967
  static PointsRules + #911, #3967
  static PointsRules + #912, #3967
  static PointsRules + #913, #3967
  static PointsRules + #914, #3967
  static PointsRules + #915, #3967
  static PointsRules + #916, #3967
  static PointsRules + #917, #3967
  static PointsRules + #918, #3967
  static PointsRules + #919, #3967

  ;Linha 23
  static PointsRules + #920, #3967
  static PointsRules + #921, #3967
  static PointsRules + #922, #3967
  static PointsRules + #923, #3967
  static PointsRules + #924, #3967
  static PointsRules + #925, #3967
  static PointsRules + #926, #3967
  static PointsRules + #927, #3967
  static PointsRules + #928, #3967
  static PointsRules + #929, #3967
  static PointsRules + #930, #3967
  static PointsRules + #931, #3967
  static PointsRules + #932, #3967
  static PointsRules + #933, #3967
  static PointsRules + #934, #3967
  static PointsRules + #935, #3967
  static PointsRules + #936, #3967
  static PointsRules + #937, #3967
  static PointsRules + #938, #3967
  static PointsRules + #939, #3967
  static PointsRules + #940, #3967
  static PointsRules + #941, #3967
  static PointsRules + #942, #3967
  static PointsRules + #943, #3967
  static PointsRules + #944, #3967
  static PointsRules + #945, #3967
  static PointsRules + #946, #3967
  static PointsRules + #947, #3967
  static PointsRules + #948, #3967
  static PointsRules + #949, #3967
  static PointsRules + #950, #3967
  static PointsRules + #951, #3967
  static PointsRules + #952, #3967
  static PointsRules + #953, #3967
  static PointsRules + #954, #3967
  static PointsRules + #955, #3967
  static PointsRules + #956, #3967
  static PointsRules + #957, #3967
  static PointsRules + #958, #3967
  static PointsRules + #959, #3967

  ;Linha 24
  static PointsRules + #960, #3967
  static PointsRules + #961, #3967
  static PointsRules + #962, #3967
  static PointsRules + #963, #3967
  static PointsRules + #964, #3967
  static PointsRules + #965, #3967
  static PointsRules + #966, #3967
  static PointsRules + #967, #3967
  static PointsRules + #968, #3967
  static PointsRules + #969, #3967
  static PointsRules + #970, #3967
  static PointsRules + #971, #3967
  static PointsRules + #972, #3967
  static PointsRules + #973, #3967
  static PointsRules + #974, #3967
  static PointsRules + #975, #3967
  static PointsRules + #976, #3967
  static PointsRules + #977, #3967
  static PointsRules + #978, #3967
  static PointsRules + #979, #3967
  static PointsRules + #980, #3967
  static PointsRules + #981, #3967
  static PointsRules + #982, #3967
  static PointsRules + #983, #3967
  static PointsRules + #984, #3967
  static PointsRules + #985, #3967
  static PointsRules + #986, #3967
  static PointsRules + #987, #3967
  static PointsRules + #988, #3967
  static PointsRules + #989, #3967
  static PointsRules + #990, #3967
  static PointsRules + #991, #3967
  static PointsRules + #992, #3967
  static PointsRules + #993, #3967
  static PointsRules + #994, #3967
  static PointsRules + #995, #3967
  static PointsRules + #996, #3967
  static PointsRules + #997, #3967
  static PointsRules + #998, #3967
  static PointsRules + #999, #3967

  ;Linha 25
  static PointsRules + #1000, #3967
  static PointsRules + #1001, #3967
  static PointsRules + #1002, #3967
  static PointsRules + #1003, #3967
  static PointsRules + #1004, #3967
  static PointsRules + #1005, #3967
  static PointsRules + #1006, #3967
  static PointsRules + #1007, #3967
  static PointsRules + #1008, #3967
  static PointsRules + #1009, #80
  static PointsRules + #1010, #82
  static PointsRules + #1011, #69
  static PointsRules + #1012, #83
  static PointsRules + #1013, #83
  static PointsRules + #1014, #3967
  static PointsRules + #1015, #88
  static PointsRules + #1016, #3967
  static PointsRules + #1017, #84
  static PointsRules + #1018, #79
  static PointsRules + #1019, #3967
  static PointsRules + #1020, #67
  static PointsRules + #1021, #79
  static PointsRules + #1022, #78
  static PointsRules + #1023, #84
  static PointsRules + #1024, #73
  static PointsRules + #1025, #78
  static PointsRules + #1026, #85
  static PointsRules + #1027, #69
  static PointsRules + #1028, #3967
  static PointsRules + #1029, #3967
  static PointsRules + #1030, #3967
  static PointsRules + #1031, #3967
  static PointsRules + #1032, #3967
  static PointsRules + #1033, #3967
  static PointsRules + #1034, #3967
  static PointsRules + #1035, #3967
  static PointsRules + #1036, #3967
  static PointsRules + #1037, #3967
  static PointsRules + #1038, #3967
  static PointsRules + #1039, #3967

  ;Linha 26
  static PointsRules + #1040, #3967
  static PointsRules + #1041, #3967
  static PointsRules + #1042, #3967
  static PointsRules + #1043, #3967
  static PointsRules + #1044, #3967
  static PointsRules + #1045, #3967
  static PointsRules + #1046, #3967
  static PointsRules + #1047, #3967
  static PointsRules + #1048, #3967
  static PointsRules + #1049, #3967
  static PointsRules + #1050, #3967
  static PointsRules + #1051, #3967
  static PointsRules + #1052, #3967
  static PointsRules + #1053, #3967
  static PointsRules + #1054, #3967
  static PointsRules + #1055, #3967
  static PointsRules + #1056, #3967
  static PointsRules + #1057, #3967
  static PointsRules + #1058, #3967
  static PointsRules + #1059, #3967
  static PointsRules + #1060, #3967
  static PointsRules + #1061, #3967
  static PointsRules + #1062, #3967
  static PointsRules + #1063, #3967
  static PointsRules + #1064, #3967
  static PointsRules + #1065, #3967
  static PointsRules + #1066, #3967
  static PointsRules + #1067, #3967
  static PointsRules + #1068, #3967
  static PointsRules + #1069, #3967
  static PointsRules + #1070, #3967
  static PointsRules + #1071, #3967
  static PointsRules + #1072, #3967
  static PointsRules + #1073, #3967
  static PointsRules + #1074, #3967
  static PointsRules + #1075, #3967
  static PointsRules + #1076, #3967
  static PointsRules + #1077, #3967
  static PointsRules + #1078, #3967
  static PointsRules + #1079, #3967

  ;Linha 27
  static PointsRules + #1080, #3967
  static PointsRules + #1081, #3967
  static PointsRules + #1082, #3967
  static PointsRules + #1083, #3967
  static PointsRules + #1084, #3967
  static PointsRules + #1085, #3967
  static PointsRules + #1086, #3967
  static PointsRules + #1087, #3967
  static PointsRules + #1088, #3967
  static PointsRules + #1089, #3967
  static PointsRules + #1090, #3967
  static PointsRules + #1091, #3967
  static PointsRules + #1092, #3967
  static PointsRules + #1093, #3967
  static PointsRules + #1094, #3967
  static PointsRules + #1095, #3967
  static PointsRules + #1096, #3967
  static PointsRules + #1097, #3967
  static PointsRules + #1098, #3967
  static PointsRules + #1099, #3967
  static PointsRules + #1100, #3967
  static PointsRules + #1101, #3967
  static PointsRules + #1102, #3967
  static PointsRules + #1103, #3967
  static PointsRules + #1104, #3967
  static PointsRules + #1105, #3967
  static PointsRules + #1106, #3967
  static PointsRules + #1107, #3967
  static PointsRules + #1108, #3967
  static PointsRules + #1109, #3967
  static PointsRules + #1110, #3967
  static PointsRules + #1111, #3967
  static PointsRules + #1112, #3967
  static PointsRules + #1113, #3967
  static PointsRules + #1114, #3967
  static PointsRules + #1115, #3967
  static PointsRules + #1116, #3967
  static PointsRules + #1117, #3967
  static PointsRules + #1118, #3967
  static PointsRules + #1119, #3967

  ;Linha 28
  static PointsRules + #1120, #3967
  static PointsRules + #1121, #3967
  static PointsRules + #1122, #3967
  static PointsRules + #1123, #3967
  static PointsRules + #1124, #3967
  static PointsRules + #1125, #3967
  static PointsRules + #1126, #3967
  static PointsRules + #1127, #3967
  static PointsRules + #1128, #3967
  static PointsRules + #1129, #3967
  static PointsRules + #1130, #3967
  static PointsRules + #1131, #3967
  static PointsRules + #1132, #3967
  static PointsRules + #1133, #3967
  static PointsRules + #1134, #3967
  static PointsRules + #1135, #3967
  static PointsRules + #1136, #3967
  static PointsRules + #1137, #3967
  static PointsRules + #1138, #3967
  static PointsRules + #1139, #3967
  static PointsRules + #1140, #3967
  static PointsRules + #1141, #3967
  static PointsRules + #1142, #3967
  static PointsRules + #1143, #3967
  static PointsRules + #1144, #3967
  static PointsRules + #1145, #3967
  static PointsRules + #1146, #3967
  static PointsRules + #1147, #3967
  static PointsRules + #1148, #3967
  static PointsRules + #1149, #3967
  static PointsRules + #1150, #3967
  static PointsRules + #1151, #3967
  static PointsRules + #1152, #3967
  static PointsRules + #1153, #3967
  static PointsRules + #1154, #3967
  static PointsRules + #1155, #3967
  static PointsRules + #1156, #3967
  static PointsRules + #1157, #3967
  static PointsRules + #1158, #3967
  static PointsRules + #1159, #3967

  ;Linha 29
  static PointsRules + #1160, #3967
  static PointsRules + #1161, #3967
  static PointsRules + #1162, #3967
  static PointsRules + #1163, #3967
  static PointsRules + #1164, #3967
  static PointsRules + #1165, #3967
  static PointsRules + #1166, #3967
  static PointsRules + #1167, #3967
  static PointsRules + #1168, #3967
  static PointsRules + #1169, #3967
  static PointsRules + #1170, #3967
  static PointsRules + #1171, #3967
  static PointsRules + #1172, #3967
  static PointsRules + #1173, #3967
  static PointsRules + #1174, #3967
  static PointsRules + #1175, #3967
  static PointsRules + #1176, #3967
  static PointsRules + #1177, #3967
  static PointsRules + #1178, #3967
  static PointsRules + #1179, #3967
  static PointsRules + #1180, #3967
  static PointsRules + #1181, #3967
  static PointsRules + #1182, #3967
  static PointsRules + #1183, #3967
  static PointsRules + #1184, #3967
  static PointsRules + #1185, #3967
  static PointsRules + #1186, #3967
  static PointsRules + #1187, #3967
  static PointsRules + #1188, #3967
  static PointsRules + #1189, #3967
  static PointsRules + #1190, #3967
  static PointsRules + #1191, #3967
  static PointsRules + #1192, #3967
  static PointsRules + #1193, #3967
  static PointsRules + #1194, #3967
  static PointsRules + #1195, #3967
  static PointsRules + #1196, #3967
  static PointsRules + #1197, #3967
  static PointsRules + #1198, #3967
  static PointsRules + #1199, #3967

WinScreen : var #1200
  ;Linha 0
  static WinScreen + #0, #3967
  static WinScreen + #1, #3967
  static WinScreen + #2, #3967
  static WinScreen + #3, #3967
  static WinScreen + #4, #3967
  static WinScreen + #5, #3967
  static WinScreen + #6, #3967
  static WinScreen + #7, #3967
  static WinScreen + #8, #3967
  static WinScreen + #9, #3967
  static WinScreen + #10, #3967
  static WinScreen + #11, #3967
  static WinScreen + #12, #3967
  static WinScreen + #13, #3967
  static WinScreen + #14, #3967
  static WinScreen + #15, #3967
  static WinScreen + #16, #3967
  static WinScreen + #17, #3967
  static WinScreen + #18, #3967
  static WinScreen + #19, #3967
  static WinScreen + #20, #3967
  static WinScreen + #21, #3967
  static WinScreen + #22, #3967
  static WinScreen + #23, #3967
  static WinScreen + #24, #3967
  static WinScreen + #25, #3967
  static WinScreen + #26, #3967
  static WinScreen + #27, #3967
  static WinScreen + #28, #3967
  static WinScreen + #29, #3967
  static WinScreen + #30, #3967
  static WinScreen + #31, #3967
  static WinScreen + #32, #3967
  static WinScreen + #33, #3967
  static WinScreen + #34, #3967
  static WinScreen + #35, #3967
  static WinScreen + #36, #3967
  static WinScreen + #37, #3967
  static WinScreen + #38, #3967
  static WinScreen + #39, #3967

  ;Linha 1
  static WinScreen + #40, #3967
  static WinScreen + #41, #3967
  static WinScreen + #42, #3967
  static WinScreen + #43, #3967
  static WinScreen + #44, #3967
  static WinScreen + #45, #3967
  static WinScreen + #46, #3967
  static WinScreen + #47, #3967
  static WinScreen + #48, #3967
  static WinScreen + #49, #3967
  static WinScreen + #50, #3967
  static WinScreen + #51, #3967
  static WinScreen + #52, #3967
  static WinScreen + #53, #3967
  static WinScreen + #54, #3967
  static WinScreen + #55, #3967
  static WinScreen + #56, #3967
  static WinScreen + #57, #3967
  static WinScreen + #58, #3967
  static WinScreen + #59, #3967
  static WinScreen + #60, #3967
  static WinScreen + #61, #3967
  static WinScreen + #62, #3967
  static WinScreen + #63, #3967
  static WinScreen + #64, #3967
  static WinScreen + #65, #3967
  static WinScreen + #66, #3967
  static WinScreen + #67, #3967
  static WinScreen + #68, #3967
  static WinScreen + #69, #3967
  static WinScreen + #70, #3967
  static WinScreen + #71, #3967
  static WinScreen + #72, #3967
  static WinScreen + #73, #3967
  static WinScreen + #74, #3967
  static WinScreen + #75, #3967
  static WinScreen + #76, #3967
  static WinScreen + #77, #3967
  static WinScreen + #78, #3967
  static WinScreen + #79, #3967

  ;Linha 2
  static WinScreen + #80, #3967
  static WinScreen + #81, #3967
  static WinScreen + #82, #3967
  static WinScreen + #83, #3967
  static WinScreen + #84, #3967
  static WinScreen + #85, #3967
  static WinScreen + #86, #3967
  static WinScreen + #87, #3967
  static WinScreen + #88, #3967
  static WinScreen + #89, #3967
  static WinScreen + #90, #3967
  static WinScreen + #91, #3967
  static WinScreen + #92, #3967
  static WinScreen + #93, #3967
  static WinScreen + #94, #3967
  static WinScreen + #95, #3967
  static WinScreen + #96, #3967
  static WinScreen + #97, #3967
  static WinScreen + #98, #3967
  static WinScreen + #99, #3967
  static WinScreen + #100, #3967
  static WinScreen + #101, #3967
  static WinScreen + #102, #3967
  static WinScreen + #103, #3967
  static WinScreen + #104, #3967
  static WinScreen + #105, #3967
  static WinScreen + #106, #3967
  static WinScreen + #107, #3967
  static WinScreen + #108, #3967
  static WinScreen + #109, #3967
  static WinScreen + #110, #3967
  static WinScreen + #111, #3967
  static WinScreen + #112, #3967
  static WinScreen + #113, #3967
  static WinScreen + #114, #3967
  static WinScreen + #115, #3967
  static WinScreen + #116, #3967
  static WinScreen + #117, #3967
  static WinScreen + #118, #3967
  static WinScreen + #119, #3967

  ;Linha 3
  static WinScreen + #120, #3967
  static WinScreen + #121, #3967
  static WinScreen + #122, #3967
  static WinScreen + #123, #3967
  static WinScreen + #124, #3967
  static WinScreen + #125, #3967
  static WinScreen + #126, #93
  static WinScreen + #127, #3967
  static WinScreen + #128, #93
  static WinScreen + #129, #3967
  static WinScreen + #130, #3967
  static WinScreen + #131, #93
  static WinScreen + #132, #93
  static WinScreen + #133, #3967
  static WinScreen + #134, #3967
  static WinScreen + #135, #3967
  static WinScreen + #136, #93
  static WinScreen + #137, #93
  static WinScreen + #138, #93
  static WinScreen + #139, #3967
  static WinScreen + #140, #3967
  static WinScreen + #141, #93
  static WinScreen + #142, #93
  static WinScreen + #143, #93
  static WinScreen + #144, #3967
  static WinScreen + #145, #3967
  static WinScreen + #146, #3967
  static WinScreen + #147, #3967
  static WinScreen + #148, #3967
  static WinScreen + #149, #3967
  static WinScreen + #150, #3967
  static WinScreen + #151, #3967
  static WinScreen + #152, #3967
  static WinScreen + #153, #3967
  static WinScreen + #154, #3967
  static WinScreen + #155, #3967
  static WinScreen + #156, #3967
  static WinScreen + #157, #3967
  static WinScreen + #158, #3967
  static WinScreen + #159, #3967

  ;Linha 4
  static WinScreen + #160, #3967
  static WinScreen + #161, #3967
  static WinScreen + #162, #3967
  static WinScreen + #163, #3967
  static WinScreen + #164, #3967
  static WinScreen + #165, #3967
  static WinScreen + #166, #93
  static WinScreen + #167, #3967
  static WinScreen + #168, #93
  static WinScreen + #169, #3967
  static WinScreen + #170, #93
  static WinScreen + #171, #3967
  static WinScreen + #172, #3967
  static WinScreen + #173, #93
  static WinScreen + #174, #3967
  static WinScreen + #175, #93
  static WinScreen + #176, #3967
  static WinScreen + #177, #3967
  static WinScreen + #178, #3967
  static WinScreen + #179, #3967
  static WinScreen + #180, #93
  static WinScreen + #181, #3967
  static WinScreen + #182, #3967
  static WinScreen + #183, #3967
  static WinScreen + #184, #3967
  static WinScreen + #185, #3967
  static WinScreen + #186, #3967
  static WinScreen + #187, #3967
  static WinScreen + #188, #3967
  static WinScreen + #189, #3967
  static WinScreen + #190, #3967
  static WinScreen + #191, #3967
  static WinScreen + #192, #3967
  static WinScreen + #193, #3967
  static WinScreen + #194, #3967
  static WinScreen + #195, #3967
  static WinScreen + #196, #3967
  static WinScreen + #197, #3967
  static WinScreen + #198, #3967
  static WinScreen + #199, #3967

  ;Linha 5
  static WinScreen + #200, #3967
  static WinScreen + #201, #3967
  static WinScreen + #202, #3967
  static WinScreen + #203, #3967
  static WinScreen + #204, #3967
  static WinScreen + #205, #3967
  static WinScreen + #206, #93
  static WinScreen + #207, #3967
  static WinScreen + #208, #93
  static WinScreen + #209, #3967
  static WinScreen + #210, #93
  static WinScreen + #211, #3967
  static WinScreen + #212, #3967
  static WinScreen + #213, #93
  static WinScreen + #214, #3967
  static WinScreen + #215, #93
  static WinScreen + #216, #3967
  static WinScreen + #217, #3967
  static WinScreen + #218, #3967
  static WinScreen + #219, #3967
  static WinScreen + #220, #93
  static WinScreen + #221, #93
  static WinScreen + #222, #93
  static WinScreen + #223, #3967
  static WinScreen + #224, #3967
  static WinScreen + #225, #3967
  static WinScreen + #226, #3967
  static WinScreen + #227, #3967
  static WinScreen + #228, #3967
  static WinScreen + #229, #3967
  static WinScreen + #230, #3967
  static WinScreen + #231, #3967
  static WinScreen + #232, #3967
  static WinScreen + #233, #3967
  static WinScreen + #234, #3967
  static WinScreen + #235, #3967
  static WinScreen + #236, #3967
  static WinScreen + #237, #3967
  static WinScreen + #238, #3967
  static WinScreen + #239, #3967

  ;Linha 6
  static WinScreen + #240, #3967
  static WinScreen + #241, #3967
  static WinScreen + #242, #3967
  static WinScreen + #243, #3967
  static WinScreen + #244, #3967
  static WinScreen + #245, #3967
  static WinScreen + #246, #93
  static WinScreen + #247, #3967
  static WinScreen + #248, #93
  static WinScreen + #249, #3967
  static WinScreen + #250, #93
  static WinScreen + #251, #3967
  static WinScreen + #252, #3967
  static WinScreen + #253, #93
  static WinScreen + #254, #3967
  static WinScreen + #255, #93
  static WinScreen + #256, #3967
  static WinScreen + #257, #3967
  static WinScreen + #258, #3967
  static WinScreen + #259, #3967
  static WinScreen + #260, #93
  static WinScreen + #261, #3967
  static WinScreen + #262, #3967
  static WinScreen + #263, #3967
  static WinScreen + #264, #3967
  static WinScreen + #265, #3967
  static WinScreen + #266, #3967
  static WinScreen + #267, #3967
  static WinScreen + #268, #3967
  static WinScreen + #269, #3967
  static WinScreen + #270, #3967
  static WinScreen + #271, #3967
  static WinScreen + #272, #3967
  static WinScreen + #273, #3967
  static WinScreen + #274, #3967
  static WinScreen + #275, #3967
  static WinScreen + #276, #3967
  static WinScreen + #277, #3967
  static WinScreen + #278, #3967
  static WinScreen + #279, #3967

  ;Linha 7
  static WinScreen + #280, #3967
  static WinScreen + #281, #3967
  static WinScreen + #282, #3967
  static WinScreen + #283, #3967
  static WinScreen + #284, #3967
  static WinScreen + #285, #3967
  static WinScreen + #286, #3967
  static WinScreen + #287, #93
  static WinScreen + #288, #3967
  static WinScreen + #289, #3967
  static WinScreen + #290, #3967
  static WinScreen + #291, #93
  static WinScreen + #292, #93
  static WinScreen + #293, #3967
  static WinScreen + #294, #3967
  static WinScreen + #295, #3967
  static WinScreen + #296, #93
  static WinScreen + #297, #93
  static WinScreen + #298, #93
  static WinScreen + #299, #3967
  static WinScreen + #300, #3967
  static WinScreen + #301, #93
  static WinScreen + #302, #93
  static WinScreen + #303, #93
  static WinScreen + #304, #3967
  static WinScreen + #305, #3967
  static WinScreen + #306, #3967
  static WinScreen + #307, #3967
  static WinScreen + #308, #3967
  static WinScreen + #309, #3967
  static WinScreen + #310, #3967
  static WinScreen + #311, #3967
  static WinScreen + #312, #3967
  static WinScreen + #313, #3967
  static WinScreen + #314, #3967
  static WinScreen + #315, #3967
  static WinScreen + #316, #3967
  static WinScreen + #317, #3967
  static WinScreen + #318, #3967
  static WinScreen + #319, #3967

  ;Linha 8
  static WinScreen + #320, #3967
  static WinScreen + #321, #3967
  static WinScreen + #322, #3967
  static WinScreen + #323, #3967
  static WinScreen + #324, #3967
  static WinScreen + #325, #3967
  static WinScreen + #326, #3967
  static WinScreen + #327, #3967
  static WinScreen + #328, #3967
  static WinScreen + #329, #3967
  static WinScreen + #330, #3967
  static WinScreen + #331, #3967
  static WinScreen + #332, #3967
  static WinScreen + #333, #3967
  static WinScreen + #334, #3967
  static WinScreen + #335, #3967
  static WinScreen + #336, #3967
  static WinScreen + #337, #3967
  static WinScreen + #338, #3967
  static WinScreen + #339, #3967
  static WinScreen + #340, #3967
  static WinScreen + #341, #3967
  static WinScreen + #342, #3967
  static WinScreen + #343, #3967
  static WinScreen + #344, #3967
  static WinScreen + #345, #3967
  static WinScreen + #346, #3967
  static WinScreen + #347, #3967
  static WinScreen + #348, #3967
  static WinScreen + #349, #3967
  static WinScreen + #350, #3967
  static WinScreen + #351, #3967
  static WinScreen + #352, #3967
  static WinScreen + #353, #3967
  static WinScreen + #354, #3967
  static WinScreen + #355, #3967
  static WinScreen + #356, #3967
  static WinScreen + #357, #3967
  static WinScreen + #358, #3967
  static WinScreen + #359, #3967

  ;Linha 9
  static WinScreen + #360, #3967
  static WinScreen + #361, #3967
  static WinScreen + #362, #3967
  static WinScreen + #363, #3967
  static WinScreen + #364, #3967
  static WinScreen + #365, #3967
  static WinScreen + #366, #3967
  static WinScreen + #367, #3967
  static WinScreen + #368, #3967
  static WinScreen + #369, #3967
  static WinScreen + #370, #3967
  static WinScreen + #371, #3967
  static WinScreen + #372, #3967
  static WinScreen + #373, #3967
  static WinScreen + #374, #3967
  static WinScreen + #375, #3967
  static WinScreen + #376, #3967
  static WinScreen + #377, #3967
  static WinScreen + #378, #3967
  static WinScreen + #379, #3967
  static WinScreen + #380, #3967
  static WinScreen + #381, #3967
  static WinScreen + #382, #3967
  static WinScreen + #383, #3967
  static WinScreen + #384, #3967
  static WinScreen + #385, #3967
  static WinScreen + #386, #3967
  static WinScreen + #387, #3967
  static WinScreen + #388, #3967
  static WinScreen + #389, #3967
  static WinScreen + #390, #3967
  static WinScreen + #391, #3967
  static WinScreen + #392, #3967
  static WinScreen + #393, #3967
  static WinScreen + #394, #3967
  static WinScreen + #395, #3967
  static WinScreen + #396, #3967
  static WinScreen + #397, #3967
  static WinScreen + #398, #3967
  static WinScreen + #399, #3967

  ;Linha 10
  static WinScreen + #400, #3967
  static WinScreen + #401, #3967
  static WinScreen + #402, #3967
  static WinScreen + #403, #3967
  static WinScreen + #404, #3967
  static WinScreen + #405, #3967
  static WinScreen + #406, #3967
  static WinScreen + #407, #3967
  static WinScreen + #408, #3967
  static WinScreen + #409, #3967
  static WinScreen + #410, #3967
  static WinScreen + #411, #3967
  static WinScreen + #412, #3967
  static WinScreen + #413, #3967
  static WinScreen + #414, #3967
  static WinScreen + #415, #3967
  static WinScreen + #416, #3967
  static WinScreen + #417, #3967
  static WinScreen + #418, #3967
  static WinScreen + #419, #3967
  static WinScreen + #420, #3967
  static WinScreen + #421, #3967
  static WinScreen + #422, #3967
  static WinScreen + #423, #3967
  static WinScreen + #424, #3967
  static WinScreen + #425, #3967
  static WinScreen + #426, #3967
  static WinScreen + #427, #3967
  static WinScreen + #428, #3967
  static WinScreen + #429, #3967
  static WinScreen + #430, #3967
  static WinScreen + #431, #3967
  static WinScreen + #432, #3967
  static WinScreen + #433, #3967
  static WinScreen + #434, #3967
  static WinScreen + #435, #3967
  static WinScreen + #436, #3967
  static WinScreen + #437, #3967
  static WinScreen + #438, #3967
  static WinScreen + #439, #3967

  ;Linha 11
  static WinScreen + #440, #3967
  static WinScreen + #441, #3967
  static WinScreen + #442, #3967
  static WinScreen + #443, #3967
  static WinScreen + #444, #3967
  static WinScreen + #445, #3967
  static WinScreen + #446, #93
  static WinScreen + #447, #3967
  static WinScreen + #448, #93
  static WinScreen + #449, #3967
  static WinScreen + #450, #3967
  static WinScreen + #451, #2397
  static WinScreen + #452, #2397
  static WinScreen + #453, #2397
  static WinScreen + #454, #3967
  static WinScreen + #455, #93
  static WinScreen + #456, #3967
  static WinScreen + #457, #3967
  static WinScreen + #458, #3967
  static WinScreen + #459, #93
  static WinScreen + #460, #3967
  static WinScreen + #461, #3967
  static WinScreen + #462, #3165
  static WinScreen + #463, #3165
  static WinScreen + #464, #3165
  static WinScreen + #465, #3967
  static WinScreen + #466, #3967
  static WinScreen + #467, #93
  static WinScreen + #468, #93
  static WinScreen + #469, #93
  static WinScreen + #470, #3967
  static WinScreen + #471, #2397
  static WinScreen + #472, #3967
  static WinScreen + #473, #3967
  static WinScreen + #474, #2397
  static WinScreen + #475, #3967
  static WinScreen + #476, #3967
  static WinScreen + #477, #3967
  static WinScreen + #478, #3967
  static WinScreen + #479, #3967

  ;Linha 12
  static WinScreen + #480, #3967
  static WinScreen + #481, #3967
  static WinScreen + #482, #3967
  static WinScreen + #483, #3967
  static WinScreen + #484, #3967
  static WinScreen + #485, #3967
  static WinScreen + #486, #93
  static WinScreen + #487, #3967
  static WinScreen + #488, #93
  static WinScreen + #489, #3967
  static WinScreen + #490, #2397
  static WinScreen + #491, #3967
  static WinScreen + #492, #3967
  static WinScreen + #493, #3967
  static WinScreen + #494, #3967
  static WinScreen + #495, #93
  static WinScreen + #496, #93
  static WinScreen + #497, #3967
  static WinScreen + #498, #3967
  static WinScreen + #499, #93
  static WinScreen + #500, #3967
  static WinScreen + #501, #3165
  static WinScreen + #502, #3967
  static WinScreen + #503, #3967
  static WinScreen + #504, #3967
  static WinScreen + #505, #3967
  static WinScreen + #506, #93
  static WinScreen + #507, #3967
  static WinScreen + #508, #3967
  static WinScreen + #509, #3967
  static WinScreen + #510, #3967
  static WinScreen + #511, #2397
  static WinScreen + #512, #3967
  static WinScreen + #513, #3967
  static WinScreen + #514, #2397
  static WinScreen + #515, #3967
  static WinScreen + #516, #3967
  static WinScreen + #517, #3967
  static WinScreen + #518, #3967
  static WinScreen + #519, #3967

  ;Linha 13
  static WinScreen + #520, #3967
  static WinScreen + #521, #3967
  static WinScreen + #522, #3967
  static WinScreen + #523, #3967
  static WinScreen + #524, #3967
  static WinScreen + #525, #3967
  static WinScreen + #526, #93
  static WinScreen + #527, #3967
  static WinScreen + #528, #93
  static WinScreen + #529, #3967
  static WinScreen + #530, #2397
  static WinScreen + #531, #2397
  static WinScreen + #532, #2397
  static WinScreen + #533, #3967
  static WinScreen + #534, #3967
  static WinScreen + #535, #93
  static WinScreen + #536, #3967
  static WinScreen + #537, #93
  static WinScreen + #538, #3967
  static WinScreen + #539, #93
  static WinScreen + #540, #3967
  static WinScreen + #541, #3165
  static WinScreen + #542, #3967
  static WinScreen + #543, #3967
  static WinScreen + #544, #3967
  static WinScreen + #545, #3967
  static WinScreen + #546, #93
  static WinScreen + #547, #93
  static WinScreen + #548, #93
  static WinScreen + #549, #3967
  static WinScreen + #550, #3967
  static WinScreen + #551, #2397
  static WinScreen + #552, #3967
  static WinScreen + #553, #3967
  static WinScreen + #554, #2397
  static WinScreen + #555, #3967
  static WinScreen + #556, #3967
  static WinScreen + #557, #3967
  static WinScreen + #558, #3967
  static WinScreen + #559, #3967

  ;Linha 14
  static WinScreen + #560, #3967
  static WinScreen + #561, #3967
  static WinScreen + #562, #3967
  static WinScreen + #563, #3967
  static WinScreen + #564, #3967
  static WinScreen + #565, #3967
  static WinScreen + #566, #93
  static WinScreen + #567, #3967
  static WinScreen + #568, #93
  static WinScreen + #569, #3967
  static WinScreen + #570, #2397
  static WinScreen + #571, #3967
  static WinScreen + #572, #3967
  static WinScreen + #573, #3967
  static WinScreen + #574, #3967
  static WinScreen + #575, #93
  static WinScreen + #576, #3967
  static WinScreen + #577, #3967
  static WinScreen + #578, #93
  static WinScreen + #579, #93
  static WinScreen + #580, #3967
  static WinScreen + #581, #3165
  static WinScreen + #582, #3967
  static WinScreen + #583, #3967
  static WinScreen + #584, #3967
  static WinScreen + #585, #3967
  static WinScreen + #586, #93
  static WinScreen + #587, #3967
  static WinScreen + #588, #3967
  static WinScreen + #589, #3967
  static WinScreen + #590, #3967
  static WinScreen + #591, #2397
  static WinScreen + #592, #3967
  static WinScreen + #593, #3967
  static WinScreen + #594, #2397
  static WinScreen + #595, #3967
  static WinScreen + #596, #3967
  static WinScreen + #597, #3967
  static WinScreen + #598, #3967
  static WinScreen + #599, #3967

  ;Linha 15
  static WinScreen + #600, #3967
  static WinScreen + #601, #3967
  static WinScreen + #602, #3967
  static WinScreen + #603, #3967
  static WinScreen + #604, #3967
  static WinScreen + #605, #3967
  static WinScreen + #606, #3967
  static WinScreen + #607, #93
  static WinScreen + #608, #3967
  static WinScreen + #609, #3967
  static WinScreen + #610, #3967
  static WinScreen + #611, #2397
  static WinScreen + #612, #2397
  static WinScreen + #613, #2397
  static WinScreen + #614, #3967
  static WinScreen + #615, #93
  static WinScreen + #616, #3967
  static WinScreen + #617, #3967
  static WinScreen + #618, #3967
  static WinScreen + #619, #93
  static WinScreen + #620, #3967
  static WinScreen + #621, #3967
  static WinScreen + #622, #3165
  static WinScreen + #623, #3165
  static WinScreen + #624, #3165
  static WinScreen + #625, #3967
  static WinScreen + #626, #3967
  static WinScreen + #627, #93
  static WinScreen + #628, #93
  static WinScreen + #629, #93
  static WinScreen + #630, #3967
  static WinScreen + #631, #3967
  static WinScreen + #632, #2397
  static WinScreen + #633, #2397
  static WinScreen + #634, #3967
  static WinScreen + #635, #3967
  static WinScreen + #636, #3967
  static WinScreen + #637, #3967
  static WinScreen + #638, #3967
  static WinScreen + #639, #3967

  ;Linha 16
  static WinScreen + #640, #3967
  static WinScreen + #641, #3967
  static WinScreen + #642, #3967
  static WinScreen + #643, #3967
  static WinScreen + #644, #3967
  static WinScreen + #645, #3967
  static WinScreen + #646, #3967
  static WinScreen + #647, #3967
  static WinScreen + #648, #3967
  static WinScreen + #649, #3967
  static WinScreen + #650, #3967
  static WinScreen + #651, #3967
  static WinScreen + #652, #3967
  static WinScreen + #653, #3967
  static WinScreen + #654, #3967
  static WinScreen + #655, #3967
  static WinScreen + #656, #3967
  static WinScreen + #657, #3967
  static WinScreen + #658, #3967
  static WinScreen + #659, #3967
  static WinScreen + #660, #3967
  static WinScreen + #661, #3967
  static WinScreen + #662, #3967
  static WinScreen + #663, #3967
  static WinScreen + #664, #3967
  static WinScreen + #665, #3967
  static WinScreen + #666, #3967
  static WinScreen + #667, #3967
  static WinScreen + #668, #3967
  static WinScreen + #669, #3967
  static WinScreen + #670, #3967
  static WinScreen + #671, #3967
  static WinScreen + #672, #3967
  static WinScreen + #673, #3967
  static WinScreen + #674, #3967
  static WinScreen + #675, #3967
  static WinScreen + #676, #3967
  static WinScreen + #677, #3967
  static WinScreen + #678, #3967
  static WinScreen + #679, #3967

  ;Linha 17
  static WinScreen + #680, #3967
  static WinScreen + #681, #3967
  static WinScreen + #682, #3967
  static WinScreen + #683, #3967
  static WinScreen + #684, #3967
  static WinScreen + #685, #3967
  static WinScreen + #686, #3967
  static WinScreen + #687, #3967
  static WinScreen + #688, #3967
  static WinScreen + #689, #3967
  static WinScreen + #690, #3967
  static WinScreen + #691, #3967
  static WinScreen + #692, #3967
  static WinScreen + #693, #3967
  static WinScreen + #694, #3967
  static WinScreen + #695, #3967
  static WinScreen + #696, #3967
  static WinScreen + #697, #3967
  static WinScreen + #698, #3967
  static WinScreen + #699, #3967
  static WinScreen + #700, #3967
  static WinScreen + #701, #3967
  static WinScreen + #702, #3967
  static WinScreen + #703, #3967
  static WinScreen + #704, #3967
  static WinScreen + #705, #3967
  static WinScreen + #706, #3967
  static WinScreen + #707, #3967
  static WinScreen + #708, #3967
  static WinScreen + #709, #3967
  static WinScreen + #710, #3967
  static WinScreen + #711, #3967
  static WinScreen + #712, #3967
  static WinScreen + #713, #3967
  static WinScreen + #714, #3967
  static WinScreen + #715, #3967
  static WinScreen + #716, #3967
  static WinScreen + #717, #3967
  static WinScreen + #718, #3967
  static WinScreen + #719, #3967

  ;Linha 18
  static WinScreen + #720, #3967
  static WinScreen + #721, #3967
  static WinScreen + #722, #3967
  static WinScreen + #723, #3967
  static WinScreen + #724, #3967
  static WinScreen + #725, #3967
  static WinScreen + #726, #3967
  static WinScreen + #727, #3967
  static WinScreen + #728, #3967
  static WinScreen + #729, #3967
  static WinScreen + #730, #3967
  static WinScreen + #731, #3967
  static WinScreen + #732, #3967
  static WinScreen + #733, #3967
  static WinScreen + #734, #3967
  static WinScreen + #735, #3967
  static WinScreen + #736, #3967
  static WinScreen + #737, #3967
  static WinScreen + #738, #3967
  static WinScreen + #739, #3967
  static WinScreen + #740, #3967
  static WinScreen + #741, #3967
  static WinScreen + #742, #3967
  static WinScreen + #743, #3967
  static WinScreen + #744, #3967
  static WinScreen + #745, #3967
  static WinScreen + #746, #3967
  static WinScreen + #747, #3967
  static WinScreen + #748, #3967
  static WinScreen + #749, #3967
  static WinScreen + #750, #3967
  static WinScreen + #751, #3967
  static WinScreen + #752, #3967
  static WinScreen + #753, #3967
  static WinScreen + #754, #3967
  static WinScreen + #755, #3967
  static WinScreen + #756, #3967
  static WinScreen + #757, #3967
  static WinScreen + #758, #3967
  static WinScreen + #759, #3967

  ;Linha 19
  static WinScreen + #760, #3967
  static WinScreen + #761, #3967
  static WinScreen + #762, #3967
  static WinScreen + #763, #3967
  static WinScreen + #764, #3967
  static WinScreen + #765, #3967
  static WinScreen + #766, #83
  static WinScreen + #767, #67
  static WinScreen + #768, #79
  static WinScreen + #769, #82
  static WinScreen + #770, #69
  static WinScreen + #771, #3967
  static WinScreen + #772, #3967
  static WinScreen + #773, #3967
  static WinScreen + #774, #3967
  static WinScreen + #775, #3967
  static WinScreen + #776, #3967
  static WinScreen + #777, #3967
  static WinScreen + #778, #3967
  static WinScreen + #779, #3967
  static WinScreen + #780, #3967
  static WinScreen + #781, #3967
  static WinScreen + #782, #3967
  static WinScreen + #783, #3967
  static WinScreen + #784, #3967
  static WinScreen + #785, #3967
  static WinScreen + #786, #3967
  static WinScreen + #787, #3967
  static WinScreen + #788, #3967
  static WinScreen + #789, #3967
  static WinScreen + #790, #3967
  static WinScreen + #791, #3967
  static WinScreen + #792, #3967
  static WinScreen + #793, #3967
  static WinScreen + #794, #3967
  static WinScreen + #795, #3967
  static WinScreen + #796, #3967
  static WinScreen + #797, #3967
  static WinScreen + #798, #3967
  static WinScreen + #799, #3967

  ;Linha 20
  static WinScreen + #800, #3967
  static WinScreen + #801, #3967
  static WinScreen + #802, #3967
  static WinScreen + #803, #3967
  static WinScreen + #804, #3967
  static WinScreen + #805, #3967
  static WinScreen + #806, #3967
  static WinScreen + #807, #3967
  static WinScreen + #808, #3967
  static WinScreen + #809, #3967
  static WinScreen + #810, #3967
  static WinScreen + #811, #3967
  static WinScreen + #812, #3967
  static WinScreen + #813, #3967
  static WinScreen + #814, #3967
  static WinScreen + #815, #3967
  static WinScreen + #816, #3967
  static WinScreen + #817, #3967
  static WinScreen + #818, #3967
  static WinScreen + #819, #3967
  static WinScreen + #820, #3967
  static WinScreen + #821, #3967
  static WinScreen + #822, #3967
  static WinScreen + #823, #3967
  static WinScreen + #824, #3967
  static WinScreen + #825, #3967
  static WinScreen + #826, #3967
  static WinScreen + #827, #3967
  static WinScreen + #828, #3967
  static WinScreen + #829, #3967
  static WinScreen + #830, #3967
  static WinScreen + #831, #3967
  static WinScreen + #832, #3967
  static WinScreen + #833, #3967
  static WinScreen + #834, #3967
  static WinScreen + #835, #3967
  static WinScreen + #836, #3967
  static WinScreen + #837, #3967
  static WinScreen + #838, #3967
  static WinScreen + #839, #3967

  ;Linha 21
  static WinScreen + #840, #3967
  static WinScreen + #841, #3967
  static WinScreen + #842, #3967
  static WinScreen + #843, #3967
  static WinScreen + #844, #3967
  static WinScreen + #845, #3967
  static WinScreen + #846, #3967
  static WinScreen + #847, #3967
  static WinScreen + #848, #3967
  static WinScreen + #849, #3967
  static WinScreen + #850, #3967
  static WinScreen + #851, #3967
  static WinScreen + #852, #3967
  static WinScreen + #853, #3967
  static WinScreen + #854, #3967
  static WinScreen + #855, #3967
  static WinScreen + #856, #3967
  static WinScreen + #857, #3967
  static WinScreen + #858, #3967
  static WinScreen + #859, #3967
  static WinScreen + #860, #3967
  static WinScreen + #861, #3967
  static WinScreen + #862, #3967
  static WinScreen + #863, #3967
  static WinScreen + #864, #3967
  static WinScreen + #865, #3967
  static WinScreen + #866, #3967
  static WinScreen + #867, #3967
  static WinScreen + #868, #3967
  static WinScreen + #869, #3967
  static WinScreen + #870, #3967
  static WinScreen + #871, #3967
  static WinScreen + #872, #3967
  static WinScreen + #873, #3967
  static WinScreen + #874, #3967
  static WinScreen + #875, #3967
  static WinScreen + #876, #3967
  static WinScreen + #877, #3967
  static WinScreen + #878, #3967
  static WinScreen + #879, #3967

  ;Linha 22
  static WinScreen + #880, #3967
  static WinScreen + #881, #3967
  static WinScreen + #882, #3967
  static WinScreen + #883, #3967
  static WinScreen + #884, #3967
  static WinScreen + #885, #3967
  static WinScreen + #886, #80
  static WinScreen + #887, #82
  static WinScreen + #888, #69
  static WinScreen + #889, #83
  static WinScreen + #890, #83
  static WinScreen + #891, #3967
  static WinScreen + #892, #88
  static WinScreen + #893, #3967
  static WinScreen + #894, #84
  static WinScreen + #895, #79
  static WinScreen + #896, #3967
  static WinScreen + #897, #80
  static WinScreen + #898, #76
  static WinScreen + #899, #65
  static WinScreen + #900, #89
  static WinScreen + #901, #3967
  static WinScreen + #902, #65
  static WinScreen + #903, #71
  static WinScreen + #904, #65
  static WinScreen + #905, #73
  static WinScreen + #906, #78
  static WinScreen + #907, #3967
  static WinScreen + #908, #3967
  static WinScreen + #909, #3967
  static WinScreen + #910, #3967
  static WinScreen + #911, #3967
  static WinScreen + #912, #3967
  static WinScreen + #913, #3967
  static WinScreen + #914, #3967
  static WinScreen + #915, #3967
  static WinScreen + #916, #3967
  static WinScreen + #917, #3967
  static WinScreen + #918, #3967
  static WinScreen + #919, #3967

  ;Linha 23
  static WinScreen + #920, #3967
  static WinScreen + #921, #3967
  static WinScreen + #922, #3967
  static WinScreen + #923, #3967
  static WinScreen + #924, #3967
  static WinScreen + #925, #3967
  static WinScreen + #926, #3967
  static WinScreen + #927, #3967
  static WinScreen + #928, #3967
  static WinScreen + #929, #3967
  static WinScreen + #930, #3967
  static WinScreen + #931, #3967
  static WinScreen + #932, #3967
  static WinScreen + #933, #3967
  static WinScreen + #934, #3967
  static WinScreen + #935, #3967
  static WinScreen + #936, #3967
  static WinScreen + #937, #3967
  static WinScreen + #938, #3967
  static WinScreen + #939, #3967
  static WinScreen + #940, #3967
  static WinScreen + #941, #3967
  static WinScreen + #942, #3967
  static WinScreen + #943, #3967
  static WinScreen + #944, #3967
  static WinScreen + #945, #3967
  static WinScreen + #946, #3967
  static WinScreen + #947, #3967
  static WinScreen + #948, #3967
  static WinScreen + #949, #3967
  static WinScreen + #950, #3967
  static WinScreen + #951, #3967
  static WinScreen + #952, #3967
  static WinScreen + #953, #3967
  static WinScreen + #954, #3967
  static WinScreen + #955, #3967
  static WinScreen + #956, #3967
  static WinScreen + #957, #3967
  static WinScreen + #958, #3967
  static WinScreen + #959, #3967

  ;Linha 24
  static WinScreen + #960, #3967
  static WinScreen + #961, #3967
  static WinScreen + #962, #3967
  static WinScreen + #963, #3967
  static WinScreen + #964, #3967
  static WinScreen + #965, #3967
  static WinScreen + #966, #80
  static WinScreen + #967, #82
  static WinScreen + #968, #69
  static WinScreen + #969, #83
  static WinScreen + #970, #83
  static WinScreen + #971, #3967
  static WinScreen + #972, #69
  static WinScreen + #973, #78
  static WinScreen + #974, #84
  static WinScreen + #975, #69
  static WinScreen + #976, #82
  static WinScreen + #977, #3967
  static WinScreen + #978, #84
  static WinScreen + #979, #79
  static WinScreen + #980, #3967
  static WinScreen + #981, #81
  static WinScreen + #982, #85
  static WinScreen + #983, #73
  static WinScreen + #984, #84
  static WinScreen + #985, #3967
  static WinScreen + #986, #71
  static WinScreen + #987, #65
  static WinScreen + #988, #77
  static WinScreen + #989, #69
  static WinScreen + #990, #3967
  static WinScreen + #991, #3967
  static WinScreen + #992, #3967
  static WinScreen + #993, #3967
  static WinScreen + #994, #3967
  static WinScreen + #995, #3967
  static WinScreen + #996, #3967
  static WinScreen + #997, #3967
  static WinScreen + #998, #3967
  static WinScreen + #999, #3967

  ;Linha 25
  static WinScreen + #1000, #3967
  static WinScreen + #1001, #3967
  static WinScreen + #1002, #3967
  static WinScreen + #1003, #3967
  static WinScreen + #1004, #3967
  static WinScreen + #1005, #3967
  static WinScreen + #1006, #3967
  static WinScreen + #1007, #3967
  static WinScreen + #1008, #3967
  static WinScreen + #1009, #3967
  static WinScreen + #1010, #3967
  static WinScreen + #1011, #3967
  static WinScreen + #1012, #3967
  static WinScreen + #1013, #3967
  static WinScreen + #1014, #3967
  static WinScreen + #1015, #3967
  static WinScreen + #1016, #3967
  static WinScreen + #1017, #3967
  static WinScreen + #1018, #3967
  static WinScreen + #1019, #3967
  static WinScreen + #1020, #3967
  static WinScreen + #1021, #3967
  static WinScreen + #1022, #3967
  static WinScreen + #1023, #3967
  static WinScreen + #1024, #3967
  static WinScreen + #1025, #3967
  static WinScreen + #1026, #3967
  static WinScreen + #1027, #3967
  static WinScreen + #1028, #3967
  static WinScreen + #1029, #3967
  static WinScreen + #1030, #3967
  static WinScreen + #1031, #3967
  static WinScreen + #1032, #3967
  static WinScreen + #1033, #3967
  static WinScreen + #1034, #3967
  static WinScreen + #1035, #3967
  static WinScreen + #1036, #3967
  static WinScreen + #1037, #3967
  static WinScreen + #1038, #3967
  static WinScreen + #1039, #3967

  ;Linha 26
  static WinScreen + #1040, #3967
  static WinScreen + #1041, #3967
  static WinScreen + #1042, #3967
  static WinScreen + #1043, #3967
  static WinScreen + #1044, #3967
  static WinScreen + #1045, #3967
  static WinScreen + #1046, #3967
  static WinScreen + #1047, #3967
  static WinScreen + #1048, #3967
  static WinScreen + #1049, #3967
  static WinScreen + #1050, #3967
  static WinScreen + #1051, #3967
  static WinScreen + #1052, #3967
  static WinScreen + #1053, #3967
  static WinScreen + #1054, #3967
  static WinScreen + #1055, #3967
  static WinScreen + #1056, #3967
  static WinScreen + #1057, #3967
  static WinScreen + #1058, #3967
  static WinScreen + #1059, #3967
  static WinScreen + #1060, #3967
  static WinScreen + #1061, #3967
  static WinScreen + #1062, #3967
  static WinScreen + #1063, #3967
  static WinScreen + #1064, #3967
  static WinScreen + #1065, #3967
  static WinScreen + #1066, #3967
  static WinScreen + #1067, #3967
  static WinScreen + #1068, #3967
  static WinScreen + #1069, #3967
  static WinScreen + #1070, #3967
  static WinScreen + #1071, #3967
  static WinScreen + #1072, #3967
  static WinScreen + #1073, #3967
  static WinScreen + #1074, #3967
  static WinScreen + #1075, #3967
  static WinScreen + #1076, #3967
  static WinScreen + #1077, #3967
  static WinScreen + #1078, #3967
  static WinScreen + #1079, #3967

  ;Linha 27
  static WinScreen + #1080, #3967
  static WinScreen + #1081, #3967
  static WinScreen + #1082, #3967
  static WinScreen + #1083, #3967
  static WinScreen + #1084, #3967
  static WinScreen + #1085, #3967
  static WinScreen + #1086, #3967
  static WinScreen + #1087, #3967
  static WinScreen + #1088, #3967
  static WinScreen + #1089, #3967
  static WinScreen + #1090, #3967
  static WinScreen + #1091, #3967
  static WinScreen + #1092, #3967
  static WinScreen + #1093, #3967
  static WinScreen + #1094, #3967
  static WinScreen + #1095, #3967
  static WinScreen + #1096, #3967
  static WinScreen + #1097, #3967
  static WinScreen + #1098, #3967
  static WinScreen + #1099, #3967
  static WinScreen + #1100, #3967
  static WinScreen + #1101, #3967
  static WinScreen + #1102, #3967
  static WinScreen + #1103, #3967
  static WinScreen + #1104, #3967
  static WinScreen + #1105, #3967
  static WinScreen + #1106, #3967
  static WinScreen + #1107, #3967
  static WinScreen + #1108, #3967
  static WinScreen + #1109, #3967
  static WinScreen + #1110, #3967
  static WinScreen + #1111, #3967
  static WinScreen + #1112, #3967
  static WinScreen + #1113, #3967
  static WinScreen + #1114, #3967
  static WinScreen + #1115, #3967
  static WinScreen + #1116, #3967
  static WinScreen + #1117, #3967
  static WinScreen + #1118, #3967
  static WinScreen + #1119, #3967

  ;Linha 28
  static WinScreen + #1120, #3967
  static WinScreen + #1121, #3967
  static WinScreen + #1122, #3967
  static WinScreen + #1123, #3967
  static WinScreen + #1124, #3967
  static WinScreen + #1125, #3967
  static WinScreen + #1126, #3967
  static WinScreen + #1127, #3967
  static WinScreen + #1128, #3967
  static WinScreen + #1129, #3967
  static WinScreen + #1130, #3967
  static WinScreen + #1131, #3967
  static WinScreen + #1132, #3967
  static WinScreen + #1133, #3967
  static WinScreen + #1134, #3967
  static WinScreen + #1135, #3967
  static WinScreen + #1136, #3967
  static WinScreen + #1137, #3967
  static WinScreen + #1138, #3967
  static WinScreen + #1139, #3967
  static WinScreen + #1140, #3967
  static WinScreen + #1141, #3967
  static WinScreen + #1142, #3967
  static WinScreen + #1143, #3967
  static WinScreen + #1144, #3967
  static WinScreen + #1145, #3967
  static WinScreen + #1146, #3967
  static WinScreen + #1147, #3967
  static WinScreen + #1148, #3967
  static WinScreen + #1149, #3967
  static WinScreen + #1150, #3967
  static WinScreen + #1151, #3967
  static WinScreen + #1152, #3967
  static WinScreen + #1153, #3967
  static WinScreen + #1154, #3967
  static WinScreen + #1155, #3967
  static WinScreen + #1156, #3967
  static WinScreen + #1157, #3967
  static WinScreen + #1158, #3967
  static WinScreen + #1159, #3967

  ;Linha 29
  static WinScreen + #1160, #3967
  static WinScreen + #1161, #3967
  static WinScreen + #1162, #3967
  static WinScreen + #1163, #3967
  static WinScreen + #1164, #3967
  static WinScreen + #1165, #3967
  static WinScreen + #1166, #3967
  static WinScreen + #1167, #3967
  static WinScreen + #1168, #3967
  static WinScreen + #1169, #3967
  static WinScreen + #1170, #3967
  static WinScreen + #1171, #3967
  static WinScreen + #1172, #3967
  static WinScreen + #1173, #3967
  static WinScreen + #1174, #3967
  static WinScreen + #1175, #3967
  static WinScreen + #1176, #3967
  static WinScreen + #1177, #3967
  static WinScreen + #1178, #3967
  static WinScreen + #1179, #3967
  static WinScreen + #1180, #3967
  static WinScreen + #1181, #3967
  static WinScreen + #1182, #3967
  static WinScreen + #1183, #3967
  static WinScreen + #1184, #3967
  static WinScreen + #1185, #3967
  static WinScreen + #1186, #3967
  static WinScreen + #1187, #3967
  static WinScreen + #1188, #3967
  static WinScreen + #1189, #3967
  static WinScreen + #1190, #3967
  static WinScreen + #1191, #3967
  static WinScreen + #1192, #3967
  static WinScreen + #1193, #3967
  static WinScreen + #1194, #3967
  static WinScreen + #1195, #3967
  static WinScreen + #1196, #3967
  static WinScreen + #1197, #3967
  static WinScreen + #1198, #3967
  static WinScreen + #1199, #3967

LoseScreen : var #1200
  ;Linha 0
  static LoseScreen + #0, #3967
  static LoseScreen + #1, #3967
  static LoseScreen + #2, #3967
  static LoseScreen + #3, #3967
  static LoseScreen + #4, #3967
  static LoseScreen + #5, #3967
  static LoseScreen + #6, #3967
  static LoseScreen + #7, #3967
  static LoseScreen + #8, #3967
  static LoseScreen + #9, #3967
  static LoseScreen + #10, #3967
  static LoseScreen + #11, #3967
  static LoseScreen + #12, #3967
  static LoseScreen + #13, #3967
  static LoseScreen + #14, #3967
  static LoseScreen + #15, #3967
  static LoseScreen + #16, #3967
  static LoseScreen + #17, #3967
  static LoseScreen + #18, #3967
  static LoseScreen + #19, #3967
  static LoseScreen + #20, #3967
  static LoseScreen + #21, #3967
  static LoseScreen + #22, #3967
  static LoseScreen + #23, #3967
  static LoseScreen + #24, #3967
  static LoseScreen + #25, #3967
  static LoseScreen + #26, #3967
  static LoseScreen + #27, #3967
  static LoseScreen + #28, #3967
  static LoseScreen + #29, #3967
  static LoseScreen + #30, #3967
  static LoseScreen + #31, #3967
  static LoseScreen + #32, #3967
  static LoseScreen + #33, #3967
  static LoseScreen + #34, #3967
  static LoseScreen + #35, #3967
  static LoseScreen + #36, #3967
  static LoseScreen + #37, #3967
  static LoseScreen + #38, #3967
  static LoseScreen + #39, #3967

  ;Linha 1
  static LoseScreen + #40, #3967
  static LoseScreen + #41, #3967
  static LoseScreen + #42, #3967
  static LoseScreen + #43, #3967
  static LoseScreen + #44, #3967
  static LoseScreen + #45, #3967
  static LoseScreen + #46, #3967
  static LoseScreen + #47, #3967
  static LoseScreen + #48, #3967
  static LoseScreen + #49, #3967
  static LoseScreen + #50, #3967
  static LoseScreen + #51, #3967
  static LoseScreen + #52, #3967
  static LoseScreen + #53, #3967
  static LoseScreen + #54, #3967
  static LoseScreen + #55, #3967
  static LoseScreen + #56, #3967
  static LoseScreen + #57, #3967
  static LoseScreen + #58, #3967
  static LoseScreen + #59, #3967
  static LoseScreen + #60, #3967
  static LoseScreen + #61, #3967
  static LoseScreen + #62, #3967
  static LoseScreen + #63, #3967
  static LoseScreen + #64, #3967
  static LoseScreen + #65, #3967
  static LoseScreen + #66, #3967
  static LoseScreen + #67, #3967
  static LoseScreen + #68, #3967
  static LoseScreen + #69, #3967
  static LoseScreen + #70, #3967
  static LoseScreen + #71, #3967
  static LoseScreen + #72, #3967
  static LoseScreen + #73, #3967
  static LoseScreen + #74, #3967
  static LoseScreen + #75, #3967
  static LoseScreen + #76, #3967
  static LoseScreen + #77, #3967
  static LoseScreen + #78, #3967
  static LoseScreen + #79, #3967

  ;Linha 2
  static LoseScreen + #80, #3967
  static LoseScreen + #81, #3967
  static LoseScreen + #82, #3967
  static LoseScreen + #83, #3967
  static LoseScreen + #84, #3967
  static LoseScreen + #85, #3967
  static LoseScreen + #86, #3967
  static LoseScreen + #87, #3967
  static LoseScreen + #88, #3967
  static LoseScreen + #89, #3967
  static LoseScreen + #90, #3967
  static LoseScreen + #91, #3967
  static LoseScreen + #92, #3967
  static LoseScreen + #93, #3967
  static LoseScreen + #94, #3967
  static LoseScreen + #95, #3967
  static LoseScreen + #96, #3967
  static LoseScreen + #97, #3967
  static LoseScreen + #98, #3967
  static LoseScreen + #99, #3967
  static LoseScreen + #100, #3967
  static LoseScreen + #101, #3967
  static LoseScreen + #102, #3967
  static LoseScreen + #103, #3967
  static LoseScreen + #104, #3967
  static LoseScreen + #105, #3967
  static LoseScreen + #106, #3967
  static LoseScreen + #107, #3967
  static LoseScreen + #108, #3967
  static LoseScreen + #109, #3967
  static LoseScreen + #110, #3967
  static LoseScreen + #111, #3967
  static LoseScreen + #112, #3967
  static LoseScreen + #113, #3967
  static LoseScreen + #114, #3967
  static LoseScreen + #115, #3967
  static LoseScreen + #116, #3967
  static LoseScreen + #117, #3967
  static LoseScreen + #118, #3967
  static LoseScreen + #119, #3967

  ;Linha 3
  static LoseScreen + #120, #3967
  static LoseScreen + #121, #3967
  static LoseScreen + #122, #3967
  static LoseScreen + #123, #3967
  static LoseScreen + #124, #3967
  static LoseScreen + #125, #3967
  static LoseScreen + #126, #93
  static LoseScreen + #127, #3967
  static LoseScreen + #128, #93
  static LoseScreen + #129, #3967
  static LoseScreen + #130, #3967
  static LoseScreen + #131, #93
  static LoseScreen + #132, #93
  static LoseScreen + #133, #3967
  static LoseScreen + #134, #3967
  static LoseScreen + #135, #3967
  static LoseScreen + #136, #93
  static LoseScreen + #137, #93
  static LoseScreen + #138, #93
  static LoseScreen + #139, #3967
  static LoseScreen + #140, #3967
  static LoseScreen + #141, #93
  static LoseScreen + #142, #93
  static LoseScreen + #143, #93
  static LoseScreen + #144, #3967
  static LoseScreen + #145, #3967
  static LoseScreen + #146, #3967
  static LoseScreen + #147, #3967
  static LoseScreen + #148, #3967
  static LoseScreen + #149, #3967
  static LoseScreen + #150, #3967
  static LoseScreen + #151, #3967
  static LoseScreen + #152, #3967
  static LoseScreen + #153, #3967
  static LoseScreen + #154, #3967
  static LoseScreen + #155, #3967
  static LoseScreen + #156, #3967
  static LoseScreen + #157, #3967
  static LoseScreen + #158, #3967
  static LoseScreen + #159, #3967

  ;Linha 4
  static LoseScreen + #160, #3967
  static LoseScreen + #161, #3967
  static LoseScreen + #162, #3967
  static LoseScreen + #163, #3967
  static LoseScreen + #164, #3967
  static LoseScreen + #165, #3967
  static LoseScreen + #166, #93
  static LoseScreen + #167, #3967
  static LoseScreen + #168, #93
  static LoseScreen + #169, #3967
  static LoseScreen + #170, #93
  static LoseScreen + #171, #3967
  static LoseScreen + #172, #3967
  static LoseScreen + #173, #93
  static LoseScreen + #174, #3967
  static LoseScreen + #175, #93
  static LoseScreen + #176, #3967
  static LoseScreen + #177, #3967
  static LoseScreen + #178, #3967
  static LoseScreen + #179, #3967
  static LoseScreen + #180, #93
  static LoseScreen + #181, #3967
  static LoseScreen + #182, #3967
  static LoseScreen + #183, #3967
  static LoseScreen + #184, #3967
  static LoseScreen + #185, #3967
  static LoseScreen + #186, #3967
  static LoseScreen + #187, #3967
  static LoseScreen + #188, #3967
  static LoseScreen + #189, #3967
  static LoseScreen + #190, #3967
  static LoseScreen + #191, #3967
  static LoseScreen + #192, #3967
  static LoseScreen + #193, #3967
  static LoseScreen + #194, #3967
  static LoseScreen + #195, #3967
  static LoseScreen + #196, #3967
  static LoseScreen + #197, #3967
  static LoseScreen + #198, #3967
  static LoseScreen + #199, #3967

  ;Linha 5
  static LoseScreen + #200, #3967
  static LoseScreen + #201, #3967
  static LoseScreen + #202, #3967
  static LoseScreen + #203, #3967
  static LoseScreen + #204, #3967
  static LoseScreen + #205, #3967
  static LoseScreen + #206, #93
  static LoseScreen + #207, #3967
  static LoseScreen + #208, #93
  static LoseScreen + #209, #3967
  static LoseScreen + #210, #93
  static LoseScreen + #211, #3967
  static LoseScreen + #212, #3967
  static LoseScreen + #213, #93
  static LoseScreen + #214, #3967
  static LoseScreen + #215, #93
  static LoseScreen + #216, #3967
  static LoseScreen + #217, #3967
  static LoseScreen + #218, #3967
  static LoseScreen + #219, #3967
  static LoseScreen + #220, #93
  static LoseScreen + #221, #93
  static LoseScreen + #222, #93
  static LoseScreen + #223, #3967
  static LoseScreen + #224, #3967
  static LoseScreen + #225, #3967
  static LoseScreen + #226, #3967
  static LoseScreen + #227, #3967
  static LoseScreen + #228, #3967
  static LoseScreen + #229, #3967
  static LoseScreen + #230, #3967
  static LoseScreen + #231, #3967
  static LoseScreen + #232, #3967
  static LoseScreen + #233, #3967
  static LoseScreen + #234, #3967
  static LoseScreen + #235, #3967
  static LoseScreen + #236, #3967
  static LoseScreen + #237, #3967
  static LoseScreen + #238, #3967
  static LoseScreen + #239, #3967

  ;Linha 6
  static LoseScreen + #240, #3967
  static LoseScreen + #241, #3967
  static LoseScreen + #242, #3967
  static LoseScreen + #243, #3967
  static LoseScreen + #244, #3967
  static LoseScreen + #245, #3967
  static LoseScreen + #246, #93
  static LoseScreen + #247, #3967
  static LoseScreen + #248, #93
  static LoseScreen + #249, #3967
  static LoseScreen + #250, #93
  static LoseScreen + #251, #3967
  static LoseScreen + #252, #3967
  static LoseScreen + #253, #93
  static LoseScreen + #254, #3967
  static LoseScreen + #255, #93
  static LoseScreen + #256, #3967
  static LoseScreen + #257, #3967
  static LoseScreen + #258, #3967
  static LoseScreen + #259, #3967
  static LoseScreen + #260, #93
  static LoseScreen + #261, #3967
  static LoseScreen + #262, #3967
  static LoseScreen + #263, #3967
  static LoseScreen + #264, #3967
  static LoseScreen + #265, #3967
  static LoseScreen + #266, #3967
  static LoseScreen + #267, #3967
  static LoseScreen + #268, #3967
  static LoseScreen + #269, #3967
  static LoseScreen + #270, #3967
  static LoseScreen + #271, #3967
  static LoseScreen + #272, #3967
  static LoseScreen + #273, #3967
  static LoseScreen + #274, #3967
  static LoseScreen + #275, #3967
  static LoseScreen + #276, #3967
  static LoseScreen + #277, #3967
  static LoseScreen + #278, #3967
  static LoseScreen + #279, #3967

  ;Linha 7
  static LoseScreen + #280, #3967
  static LoseScreen + #281, #3967
  static LoseScreen + #282, #3967
  static LoseScreen + #283, #3967
  static LoseScreen + #284, #3967
  static LoseScreen + #285, #3967
  static LoseScreen + #286, #3967
  static LoseScreen + #287, #93
  static LoseScreen + #288, #3967
  static LoseScreen + #289, #3967
  static LoseScreen + #290, #3967
  static LoseScreen + #291, #93
  static LoseScreen + #292, #93
  static LoseScreen + #293, #3967
  static LoseScreen + #294, #3967
  static LoseScreen + #295, #3967
  static LoseScreen + #296, #93
  static LoseScreen + #297, #93
  static LoseScreen + #298, #93
  static LoseScreen + #299, #3967
  static LoseScreen + #300, #3967
  static LoseScreen + #301, #93
  static LoseScreen + #302, #93
  static LoseScreen + #303, #93
  static LoseScreen + #304, #3967
  static LoseScreen + #305, #3967
  static LoseScreen + #306, #3967
  static LoseScreen + #307, #3967
  static LoseScreen + #308, #3967
  static LoseScreen + #309, #3967
  static LoseScreen + #310, #3967
  static LoseScreen + #311, #3967
  static LoseScreen + #312, #3967
  static LoseScreen + #313, #3967
  static LoseScreen + #314, #3967
  static LoseScreen + #315, #3967
  static LoseScreen + #316, #3967
  static LoseScreen + #317, #3967
  static LoseScreen + #318, #3967
  static LoseScreen + #319, #3967

  ;Linha 8
  static LoseScreen + #320, #3967
  static LoseScreen + #321, #3967
  static LoseScreen + #322, #3967
  static LoseScreen + #323, #3967
  static LoseScreen + #324, #3967
  static LoseScreen + #325, #3967
  static LoseScreen + #326, #3967
  static LoseScreen + #327, #3967
  static LoseScreen + #328, #3967
  static LoseScreen + #329, #3967
  static LoseScreen + #330, #3967
  static LoseScreen + #331, #3967
  static LoseScreen + #332, #3967
  static LoseScreen + #333, #3967
  static LoseScreen + #334, #3967
  static LoseScreen + #335, #3967
  static LoseScreen + #336, #3967
  static LoseScreen + #337, #3967
  static LoseScreen + #338, #3967
  static LoseScreen + #339, #3967
  static LoseScreen + #340, #3967
  static LoseScreen + #341, #3967
  static LoseScreen + #342, #3967
  static LoseScreen + #343, #3967
  static LoseScreen + #344, #3967
  static LoseScreen + #345, #3967
  static LoseScreen + #346, #3967
  static LoseScreen + #347, #3967
  static LoseScreen + #348, #3967
  static LoseScreen + #349, #3967
  static LoseScreen + #350, #3967
  static LoseScreen + #351, #3967
  static LoseScreen + #352, #3967
  static LoseScreen + #353, #3967
  static LoseScreen + #354, #3967
  static LoseScreen + #355, #3967
  static LoseScreen + #356, #3967
  static LoseScreen + #357, #3967
  static LoseScreen + #358, #3967
  static LoseScreen + #359, #3967

  ;Linha 9
  static LoseScreen + #360, #3967
  static LoseScreen + #361, #3967
  static LoseScreen + #362, #3967
  static LoseScreen + #363, #3967
  static LoseScreen + #364, #3967
  static LoseScreen + #365, #3967
  static LoseScreen + #366, #3967
  static LoseScreen + #367, #3967
  static LoseScreen + #368, #3967
  static LoseScreen + #369, #3967
  static LoseScreen + #370, #3967
  static LoseScreen + #371, #3967
  static LoseScreen + #372, #3967
  static LoseScreen + #373, #3967
  static LoseScreen + #374, #3967
  static LoseScreen + #375, #3967
  static LoseScreen + #376, #3967
  static LoseScreen + #377, #3967
  static LoseScreen + #378, #3967
  static LoseScreen + #379, #3967
  static LoseScreen + #380, #3967
  static LoseScreen + #381, #3967
  static LoseScreen + #382, #3967
  static LoseScreen + #383, #3967
  static LoseScreen + #384, #3967
  static LoseScreen + #385, #3967
  static LoseScreen + #386, #3967
  static LoseScreen + #387, #3967
  static LoseScreen + #388, #3967
  static LoseScreen + #389, #3967
  static LoseScreen + #390, #3967
  static LoseScreen + #391, #3967
  static LoseScreen + #392, #3967
  static LoseScreen + #393, #3967
  static LoseScreen + #394, #3967
  static LoseScreen + #395, #3967
  static LoseScreen + #396, #3967
  static LoseScreen + #397, #3967
  static LoseScreen + #398, #3967
  static LoseScreen + #399, #3967

  ;Linha 10
  static LoseScreen + #400, #3967
  static LoseScreen + #401, #3967
  static LoseScreen + #402, #3967
  static LoseScreen + #403, #3967
  static LoseScreen + #404, #3967
  static LoseScreen + #405, #3967
  static LoseScreen + #406, #3967
  static LoseScreen + #407, #3967
  static LoseScreen + #408, #3967
  static LoseScreen + #409, #3967
  static LoseScreen + #410, #3967
  static LoseScreen + #411, #3967
  static LoseScreen + #412, #3967
  static LoseScreen + #413, #3967
  static LoseScreen + #414, #3967
  static LoseScreen + #415, #3967
  static LoseScreen + #416, #3967
  static LoseScreen + #417, #3967
  static LoseScreen + #418, #3967
  static LoseScreen + #419, #3967
  static LoseScreen + #420, #3967
  static LoseScreen + #421, #3967
  static LoseScreen + #422, #3967
  static LoseScreen + #423, #3967
  static LoseScreen + #424, #3967
  static LoseScreen + #425, #3967
  static LoseScreen + #426, #3967
  static LoseScreen + #427, #3967
  static LoseScreen + #428, #3967
  static LoseScreen + #429, #3967
  static LoseScreen + #430, #3967
  static LoseScreen + #431, #3967
  static LoseScreen + #432, #3967
  static LoseScreen + #433, #3967
  static LoseScreen + #434, #3967
  static LoseScreen + #435, #3967
  static LoseScreen + #436, #3967
  static LoseScreen + #437, #3967
  static LoseScreen + #438, #3967
  static LoseScreen + #439, #3967

  ;Linha 11
  static LoseScreen + #440, #3967
  static LoseScreen + #441, #3967
  static LoseScreen + #442, #3967
  static LoseScreen + #443, #3967
  static LoseScreen + #444, #3967
  static LoseScreen + #445, #3967
  static LoseScreen + #446, #3967
  static LoseScreen + #447, #93
  static LoseScreen + #448, #93
  static LoseScreen + #449, #3967
  static LoseScreen + #450, #3967
  static LoseScreen + #451, #3967
  static LoseScreen + #452, #2397
  static LoseScreen + #453, #2397
  static LoseScreen + #454, #2397
  static LoseScreen + #455, #3967
  static LoseScreen + #456, #3967
  static LoseScreen + #457, #93
  static LoseScreen + #458, #93
  static LoseScreen + #459, #3967
  static LoseScreen + #460, #3967
  static LoseScreen + #461, #3165
  static LoseScreen + #462, #3165
  static LoseScreen + #463, #3967
  static LoseScreen + #464, #3967
  static LoseScreen + #465, #3967
  static LoseScreen + #466, #93
  static LoseScreen + #467, #93
  static LoseScreen + #468, #93
  static LoseScreen + #469, #3967
  static LoseScreen + #470, #2397
  static LoseScreen + #471, #3967
  static LoseScreen + #472, #3967
  static LoseScreen + #473, #2397
  static LoseScreen + #474, #3967
  static LoseScreen + #475, #3967
  static LoseScreen + #476, #3967
  static LoseScreen + #477, #3967
  static LoseScreen + #478, #3967
  static LoseScreen + #479, #3967

  ;Linha 12
  static LoseScreen + #480, #3967
  static LoseScreen + #481, #3967
  static LoseScreen + #482, #3967
  static LoseScreen + #483, #3967
  static LoseScreen + #484, #3967
  static LoseScreen + #485, #3967
  static LoseScreen + #486, #93
  static LoseScreen + #487, #3967
  static LoseScreen + #488, #3967
  static LoseScreen + #489, #93
  static LoseScreen + #490, #3967
  static LoseScreen + #491, #2397
  static LoseScreen + #492, #3967
  static LoseScreen + #493, #3967
  static LoseScreen + #494, #3967
  static LoseScreen + #495, #3967
  static LoseScreen + #496, #93
  static LoseScreen + #497, #3967
  static LoseScreen + #498, #3967
  static LoseScreen + #499, #93
  static LoseScreen + #500, #3967
  static LoseScreen + #501, #3165
  static LoseScreen + #502, #3967
  static LoseScreen + #503, #3165
  static LoseScreen + #504, #3967
  static LoseScreen + #505, #93
  static LoseScreen + #506, #3967
  static LoseScreen + #507, #3967
  static LoseScreen + #508, #3967
  static LoseScreen + #509, #3967
  static LoseScreen + #510, #2397
  static LoseScreen + #511, #3967
  static LoseScreen + #512, #3967
  static LoseScreen + #513, #2397
  static LoseScreen + #514, #3967
  static LoseScreen + #515, #3967
  static LoseScreen + #516, #3967
  static LoseScreen + #517, #3967
  static LoseScreen + #518, #3967
  static LoseScreen + #519, #3967

  ;Linha 13
  static LoseScreen + #520, #3967
  static LoseScreen + #521, #3967
  static LoseScreen + #522, #3967
  static LoseScreen + #523, #3967
  static LoseScreen + #524, #3967
  static LoseScreen + #525, #3967
  static LoseScreen + #526, #93
  static LoseScreen + #527, #93
  static LoseScreen + #528, #93
  static LoseScreen + #529, #3967
  static LoseScreen + #530, #3967
  static LoseScreen + #531, #2397
  static LoseScreen + #532, #2397
  static LoseScreen + #533, #2397
  static LoseScreen + #534, #3967
  static LoseScreen + #535, #3967
  static LoseScreen + #536, #93
  static LoseScreen + #537, #3967
  static LoseScreen + #538, #3967
  static LoseScreen + #539, #93
  static LoseScreen + #540, #3967
  static LoseScreen + #541, #3165
  static LoseScreen + #542, #3967
  static LoseScreen + #543, #3165
  static LoseScreen + #544, #3967
  static LoseScreen + #545, #93
  static LoseScreen + #546, #93
  static LoseScreen + #547, #93
  static LoseScreen + #548, #3967
  static LoseScreen + #549, #3967
  static LoseScreen + #550, #2397
  static LoseScreen + #551, #3967
  static LoseScreen + #552, #3967
  static LoseScreen + #553, #2397
  static LoseScreen + #554, #3967
  static LoseScreen + #555, #3967
  static LoseScreen + #556, #3967
  static LoseScreen + #557, #3967
  static LoseScreen + #558, #3967
  static LoseScreen + #559, #3967

  ;Linha 14
  static LoseScreen + #560, #3967
  static LoseScreen + #561, #3967
  static LoseScreen + #562, #3967
  static LoseScreen + #563, #3967
  static LoseScreen + #564, #3967
  static LoseScreen + #565, #3967
  static LoseScreen + #566, #93
  static LoseScreen + #567, #3967
  static LoseScreen + #568, #3967
  static LoseScreen + #569, #3967
  static LoseScreen + #570, #3967
  static LoseScreen + #571, #2397
  static LoseScreen + #572, #3967
  static LoseScreen + #573, #3967
  static LoseScreen + #574, #3967
  static LoseScreen + #575, #3967
  static LoseScreen + #576, #93
  static LoseScreen + #577, #93
  static LoseScreen + #578, #93
  static LoseScreen + #579, #3967
  static LoseScreen + #580, #3967
  static LoseScreen + #581, #3165
  static LoseScreen + #582, #3967
  static LoseScreen + #583, #3165
  static LoseScreen + #584, #3967
  static LoseScreen + #585, #93
  static LoseScreen + #586, #3967
  static LoseScreen + #587, #3967
  static LoseScreen + #588, #3967
  static LoseScreen + #589, #3967
  static LoseScreen + #590, #2397
  static LoseScreen + #591, #3967
  static LoseScreen + #592, #3967
  static LoseScreen + #593, #2397
  static LoseScreen + #594, #3967
  static LoseScreen + #595, #3967
  static LoseScreen + #596, #3967
  static LoseScreen + #597, #3967
  static LoseScreen + #598, #3967
  static LoseScreen + #599, #3967

  ;Linha 15
  static LoseScreen + #600, #3967
  static LoseScreen + #601, #3967
  static LoseScreen + #602, #3967
  static LoseScreen + #603, #3967
  static LoseScreen + #604, #3967
  static LoseScreen + #605, #3967
  static LoseScreen + #606, #93
  static LoseScreen + #607, #3967
  static LoseScreen + #608, #3967
  static LoseScreen + #609, #3967
  static LoseScreen + #610, #3967
  static LoseScreen + #611, #3967
  static LoseScreen + #612, #2397
  static LoseScreen + #613, #2397
  static LoseScreen + #614, #2397
  static LoseScreen + #615, #3967
  static LoseScreen + #616, #93
  static LoseScreen + #617, #3967
  static LoseScreen + #618, #3967
  static LoseScreen + #619, #93
  static LoseScreen + #620, #3967
  static LoseScreen + #621, #3165
  static LoseScreen + #622, #3165
  static LoseScreen + #623, #3967
  static LoseScreen + #624, #3967
  static LoseScreen + #625, #3967
  static LoseScreen + #626, #93
  static LoseScreen + #627, #93
  static LoseScreen + #628, #93
  static LoseScreen + #629, #3967
  static LoseScreen + #630, #3967
  static LoseScreen + #631, #2397
  static LoseScreen + #632, #2397
  static LoseScreen + #633, #3967
  static LoseScreen + #634, #3967
  static LoseScreen + #635, #3967
  static LoseScreen + #636, #3967
  static LoseScreen + #637, #3967
  static LoseScreen + #638, #3967
  static LoseScreen + #639, #3967

  ;Linha 16
  static LoseScreen + #640, #3967
  static LoseScreen + #641, #3967
  static LoseScreen + #642, #3967
  static LoseScreen + #643, #3967
  static LoseScreen + #644, #3967
  static LoseScreen + #645, #3967
  static LoseScreen + #646, #3967
  static LoseScreen + #647, #3967
  static LoseScreen + #648, #3967
  static LoseScreen + #649, #3967
  static LoseScreen + #650, #3967
  static LoseScreen + #651, #3967
  static LoseScreen + #652, #3967
  static LoseScreen + #653, #3967
  static LoseScreen + #654, #3967
  static LoseScreen + #655, #3967
  static LoseScreen + #656, #3967
  static LoseScreen + #657, #3967
  static LoseScreen + #658, #3967
  static LoseScreen + #659, #3967
  static LoseScreen + #660, #3967
  static LoseScreen + #661, #3967
  static LoseScreen + #662, #3967
  static LoseScreen + #663, #3967
  static LoseScreen + #664, #3967
  static LoseScreen + #665, #3967
  static LoseScreen + #666, #3967
  static LoseScreen + #667, #3967
  static LoseScreen + #668, #3967
  static LoseScreen + #669, #3967
  static LoseScreen + #670, #3967
  static LoseScreen + #671, #3967
  static LoseScreen + #672, #3967
  static LoseScreen + #673, #3967
  static LoseScreen + #674, #3967
  static LoseScreen + #675, #3967
  static LoseScreen + #676, #3967
  static LoseScreen + #677, #3967
  static LoseScreen + #678, #3967
  static LoseScreen + #679, #3967

  ;Linha 17
  static LoseScreen + #680, #3967
  static LoseScreen + #681, #3967
  static LoseScreen + #682, #3967
  static LoseScreen + #683, #3967
  static LoseScreen + #684, #3967
  static LoseScreen + #685, #3967
  static LoseScreen + #686, #3967
  static LoseScreen + #687, #3967
  static LoseScreen + #688, #3967
  static LoseScreen + #689, #3967
  static LoseScreen + #690, #3967
  static LoseScreen + #691, #3967
  static LoseScreen + #692, #3967
  static LoseScreen + #693, #3967
  static LoseScreen + #694, #3967
  static LoseScreen + #695, #3967
  static LoseScreen + #696, #3967
  static LoseScreen + #697, #3967
  static LoseScreen + #698, #3967
  static LoseScreen + #699, #3967
  static LoseScreen + #700, #3967
  static LoseScreen + #701, #3967
  static LoseScreen + #702, #3967
  static LoseScreen + #703, #3967
  static LoseScreen + #704, #3967
  static LoseScreen + #705, #3967
  static LoseScreen + #706, #3967
  static LoseScreen + #707, #3967
  static LoseScreen + #708, #3967
  static LoseScreen + #709, #3967
  static LoseScreen + #710, #3967
  static LoseScreen + #711, #3967
  static LoseScreen + #712, #3967
  static LoseScreen + #713, #3967
  static LoseScreen + #714, #3967
  static LoseScreen + #715, #3967
  static LoseScreen + #716, #3967
  static LoseScreen + #717, #3967
  static LoseScreen + #718, #3967
  static LoseScreen + #719, #3967

  ;Linha 18
  static LoseScreen + #720, #3967
  static LoseScreen + #721, #3967
  static LoseScreen + #722, #3967
  static LoseScreen + #723, #3967
  static LoseScreen + #724, #3967
  static LoseScreen + #725, #3967
  static LoseScreen + #726, #3967
  static LoseScreen + #727, #3967
  static LoseScreen + #728, #3967
  static LoseScreen + #729, #3967
  static LoseScreen + #730, #3967
  static LoseScreen + #731, #3967
  static LoseScreen + #732, #3967
  static LoseScreen + #733, #3967
  static LoseScreen + #734, #3967
  static LoseScreen + #735, #3967
  static LoseScreen + #736, #3967
  static LoseScreen + #737, #3967
  static LoseScreen + #738, #3967
  static LoseScreen + #739, #3967
  static LoseScreen + #740, #3967
  static LoseScreen + #741, #3967
  static LoseScreen + #742, #3967
  static LoseScreen + #743, #3967
  static LoseScreen + #744, #3967
  static LoseScreen + #745, #3967
  static LoseScreen + #746, #3967
  static LoseScreen + #747, #3967
  static LoseScreen + #748, #3967
  static LoseScreen + #749, #3967
  static LoseScreen + #750, #3967
  static LoseScreen + #751, #3967
  static LoseScreen + #752, #3967
  static LoseScreen + #753, #3967
  static LoseScreen + #754, #3967
  static LoseScreen + #755, #3967
  static LoseScreen + #756, #3967
  static LoseScreen + #757, #3967
  static LoseScreen + #758, #3967
  static LoseScreen + #759, #3967

  ;Linha 19
  static LoseScreen + #760, #3967
  static LoseScreen + #761, #3967
  static LoseScreen + #762, #3967
  static LoseScreen + #763, #3967
  static LoseScreen + #764, #3967
  static LoseScreen + #765, #3967
  static LoseScreen + #766, #83
  static LoseScreen + #767, #67
  static LoseScreen + #768, #79
  static LoseScreen + #769, #82
  static LoseScreen + #770, #69
  static LoseScreen + #771, #3967
  static LoseScreen + #772, #3967
  static LoseScreen + #773, #3967
  static LoseScreen + #774, #3967
  static LoseScreen + #775, #3967
  static LoseScreen + #776, #3967
  static LoseScreen + #777, #3967
  static LoseScreen + #778, #3967
  static LoseScreen + #779, #3967
  static LoseScreen + #780, #3967
  static LoseScreen + #781, #3967
  static LoseScreen + #782, #3967
  static LoseScreen + #783, #3967
  static LoseScreen + #784, #3967
  static LoseScreen + #785, #3967
  static LoseScreen + #786, #3967
  static LoseScreen + #787, #3967
  static LoseScreen + #788, #3967
  static LoseScreen + #789, #3967
  static LoseScreen + #790, #3967
  static LoseScreen + #791, #3967
  static LoseScreen + #792, #3967
  static LoseScreen + #793, #3967
  static LoseScreen + #794, #3967
  static LoseScreen + #795, #3967
  static LoseScreen + #796, #3967
  static LoseScreen + #797, #3967
  static LoseScreen + #798, #3967
  static LoseScreen + #799, #3967

  ;Linha 20
  static LoseScreen + #800, #3967
  static LoseScreen + #801, #3967
  static LoseScreen + #802, #3967
  static LoseScreen + #803, #3967
  static LoseScreen + #804, #3967
  static LoseScreen + #805, #3967
  static LoseScreen + #806, #3967
  static LoseScreen + #807, #3967
  static LoseScreen + #808, #3967
  static LoseScreen + #809, #3967
  static LoseScreen + #810, #3967
  static LoseScreen + #811, #3967
  static LoseScreen + #812, #3967
  static LoseScreen + #813, #3967
  static LoseScreen + #814, #3967
  static LoseScreen + #815, #3967
  static LoseScreen + #816, #3967
  static LoseScreen + #817, #3967
  static LoseScreen + #818, #3967
  static LoseScreen + #819, #3967
  static LoseScreen + #820, #3967
  static LoseScreen + #821, #3967
  static LoseScreen + #822, #3967
  static LoseScreen + #823, #3967
  static LoseScreen + #824, #3967
  static LoseScreen + #825, #3967
  static LoseScreen + #826, #3967
  static LoseScreen + #827, #3967
  static LoseScreen + #828, #3967
  static LoseScreen + #829, #3967
  static LoseScreen + #830, #3967
  static LoseScreen + #831, #3967
  static LoseScreen + #832, #3967
  static LoseScreen + #833, #3967
  static LoseScreen + #834, #3967
  static LoseScreen + #835, #3967
  static LoseScreen + #836, #3967
  static LoseScreen + #837, #3967
  static LoseScreen + #838, #3967
  static LoseScreen + #839, #3967

  ;Linha 21
  static LoseScreen + #840, #3967
  static LoseScreen + #841, #3967
  static LoseScreen + #842, #3967
  static LoseScreen + #843, #3967
  static LoseScreen + #844, #3967
  static LoseScreen + #845, #3967
  static LoseScreen + #846, #3967
  static LoseScreen + #847, #3967
  static LoseScreen + #848, #3967
  static LoseScreen + #849, #3967
  static LoseScreen + #850, #3967
  static LoseScreen + #851, #3967
  static LoseScreen + #852, #3967
  static LoseScreen + #853, #3967
  static LoseScreen + #854, #3967
  static LoseScreen + #855, #3967
  static LoseScreen + #856, #3967
  static LoseScreen + #857, #3967
  static LoseScreen + #858, #3967
  static LoseScreen + #859, #3967
  static LoseScreen + #860, #3967
  static LoseScreen + #861, #3967
  static LoseScreen + #862, #3967
  static LoseScreen + #863, #3967
  static LoseScreen + #864, #3967
  static LoseScreen + #865, #3967
  static LoseScreen + #866, #3967
  static LoseScreen + #867, #3967
  static LoseScreen + #868, #3967
  static LoseScreen + #869, #3967
  static LoseScreen + #870, #3967
  static LoseScreen + #871, #3967
  static LoseScreen + #872, #3967
  static LoseScreen + #873, #3967
  static LoseScreen + #874, #3967
  static LoseScreen + #875, #3967
  static LoseScreen + #876, #3967
  static LoseScreen + #877, #3967
  static LoseScreen + #878, #3967
  static LoseScreen + #879, #3967

  ;Linha 22
  static LoseScreen + #880, #3967
  static LoseScreen + #881, #3967
  static LoseScreen + #882, #3967
  static LoseScreen + #883, #3967
  static LoseScreen + #884, #3967
  static LoseScreen + #885, #3967
  static LoseScreen + #886, #80
  static LoseScreen + #887, #82
  static LoseScreen + #888, #69
  static LoseScreen + #889, #83
  static LoseScreen + #890, #83
  static LoseScreen + #891, #3967
  static LoseScreen + #892, #88
  static LoseScreen + #893, #3967
  static LoseScreen + #894, #84
  static LoseScreen + #895, #79
  static LoseScreen + #896, #3967
  static LoseScreen + #897, #80
  static LoseScreen + #898, #76
  static LoseScreen + #899, #65
  static LoseScreen + #900, #89
  static LoseScreen + #901, #3967
  static LoseScreen + #902, #65
  static LoseScreen + #903, #71
  static LoseScreen + #904, #65
  static LoseScreen + #905, #73
  static LoseScreen + #906, #78
  static LoseScreen + #907, #3967
  static LoseScreen + #908, #3967
  static LoseScreen + #909, #3967
  static LoseScreen + #910, #3967
  static LoseScreen + #911, #3967
  static LoseScreen + #912, #3967
  static LoseScreen + #913, #3967
  static LoseScreen + #914, #3967
  static LoseScreen + #915, #3967
  static LoseScreen + #916, #3967
  static LoseScreen + #917, #3967
  static LoseScreen + #918, #3967
  static LoseScreen + #919, #3967

  ;Linha 23
  static LoseScreen + #920, #3967
  static LoseScreen + #921, #3967
  static LoseScreen + #922, #3967
  static LoseScreen + #923, #3967
  static LoseScreen + #924, #3967
  static LoseScreen + #925, #3967
  static LoseScreen + #926, #3967
  static LoseScreen + #927, #3967
  static LoseScreen + #928, #3967
  static LoseScreen + #929, #3967
  static LoseScreen + #930, #3967
  static LoseScreen + #931, #3967
  static LoseScreen + #932, #3967
  static LoseScreen + #933, #3967
  static LoseScreen + #934, #3967
  static LoseScreen + #935, #3967
  static LoseScreen + #936, #3967
  static LoseScreen + #937, #3967
  static LoseScreen + #938, #3967
  static LoseScreen + #939, #3967
  static LoseScreen + #940, #3967
  static LoseScreen + #941, #3967
  static LoseScreen + #942, #3967
  static LoseScreen + #943, #3967
  static LoseScreen + #944, #3967
  static LoseScreen + #945, #3967
  static LoseScreen + #946, #3967
  static LoseScreen + #947, #3967
  static LoseScreen + #948, #3967
  static LoseScreen + #949, #3967
  static LoseScreen + #950, #3967
  static LoseScreen + #951, #3967
  static LoseScreen + #952, #3967
  static LoseScreen + #953, #3967
  static LoseScreen + #954, #3967
  static LoseScreen + #955, #3967
  static LoseScreen + #956, #3967
  static LoseScreen + #957, #3967
  static LoseScreen + #958, #3967
  static LoseScreen + #959, #3967

  ;Linha 24
  static LoseScreen + #960, #3967
  static LoseScreen + #961, #3967
  static LoseScreen + #962, #3967
  static LoseScreen + #963, #3967
  static LoseScreen + #964, #3967
  static LoseScreen + #965, #3967
  static LoseScreen + #966, #80
  static LoseScreen + #967, #82
  static LoseScreen + #968, #69
  static LoseScreen + #969, #83
  static LoseScreen + #970, #83
  static LoseScreen + #971, #3967
  static LoseScreen + #972, #69
  static LoseScreen + #973, #78
  static LoseScreen + #974, #84
  static LoseScreen + #975, #69
  static LoseScreen + #976, #82
  static LoseScreen + #977, #3967
  static LoseScreen + #978, #84
  static LoseScreen + #979, #79
  static LoseScreen + #980, #3967
  static LoseScreen + #981, #81
  static LoseScreen + #982, #85
  static LoseScreen + #983, #73
  static LoseScreen + #984, #84
  static LoseScreen + #985, #3967
  static LoseScreen + #986, #71
  static LoseScreen + #987, #65
  static LoseScreen + #988, #77
  static LoseScreen + #989, #69
  static LoseScreen + #990, #3967
  static LoseScreen + #991, #3967
  static LoseScreen + #992, #3967
  static LoseScreen + #993, #3967
  static LoseScreen + #994, #3967
  static LoseScreen + #995, #3967
  static LoseScreen + #996, #3967
  static LoseScreen + #997, #3967
  static LoseScreen + #998, #3967
  static LoseScreen + #999, #3967

  ;Linha 25
  static LoseScreen + #1000, #3967
  static LoseScreen + #1001, #3967
  static LoseScreen + #1002, #3967
  static LoseScreen + #1003, #3967
  static LoseScreen + #1004, #3967
  static LoseScreen + #1005, #3967
  static LoseScreen + #1006, #3967
  static LoseScreen + #1007, #3967
  static LoseScreen + #1008, #3967
  static LoseScreen + #1009, #3967
  static LoseScreen + #1010, #3967
  static LoseScreen + #1011, #3967
  static LoseScreen + #1012, #3967
  static LoseScreen + #1013, #3967
  static LoseScreen + #1014, #3967
  static LoseScreen + #1015, #3967
  static LoseScreen + #1016, #3967
  static LoseScreen + #1017, #3967
  static LoseScreen + #1018, #3967
  static LoseScreen + #1019, #3967
  static LoseScreen + #1020, #3967
  static LoseScreen + #1021, #3967
  static LoseScreen + #1022, #3967
  static LoseScreen + #1023, #3967
  static LoseScreen + #1024, #3967
  static LoseScreen + #1025, #3967
  static LoseScreen + #1026, #3967
  static LoseScreen + #1027, #3967
  static LoseScreen + #1028, #3967
  static LoseScreen + #1029, #3967
  static LoseScreen + #1030, #3967
  static LoseScreen + #1031, #3967
  static LoseScreen + #1032, #3967
  static LoseScreen + #1033, #3967
  static LoseScreen + #1034, #3967
  static LoseScreen + #1035, #3967
  static LoseScreen + #1036, #3967
  static LoseScreen + #1037, #3967
  static LoseScreen + #1038, #3967
  static LoseScreen + #1039, #3967

  ;Linha 26
  static LoseScreen + #1040, #3967
  static LoseScreen + #1041, #3967
  static LoseScreen + #1042, #3967
  static LoseScreen + #1043, #3967
  static LoseScreen + #1044, #3967
  static LoseScreen + #1045, #3967
  static LoseScreen + #1046, #3967
  static LoseScreen + #1047, #3967
  static LoseScreen + #1048, #3967
  static LoseScreen + #1049, #3967
  static LoseScreen + #1050, #3967
  static LoseScreen + #1051, #3967
  static LoseScreen + #1052, #3967
  static LoseScreen + #1053, #3967
  static LoseScreen + #1054, #3967
  static LoseScreen + #1055, #3967
  static LoseScreen + #1056, #3967
  static LoseScreen + #1057, #3967
  static LoseScreen + #1058, #3967
  static LoseScreen + #1059, #3967
  static LoseScreen + #1060, #3967
  static LoseScreen + #1061, #3967
  static LoseScreen + #1062, #3967
  static LoseScreen + #1063, #3967
  static LoseScreen + #1064, #3967
  static LoseScreen + #1065, #3967
  static LoseScreen + #1066, #3967
  static LoseScreen + #1067, #3967
  static LoseScreen + #1068, #3967
  static LoseScreen + #1069, #3967
  static LoseScreen + #1070, #3967
  static LoseScreen + #1071, #3967
  static LoseScreen + #1072, #3967
  static LoseScreen + #1073, #3967
  static LoseScreen + #1074, #3967
  static LoseScreen + #1075, #3967
  static LoseScreen + #1076, #3967
  static LoseScreen + #1077, #3967
  static LoseScreen + #1078, #3967
  static LoseScreen + #1079, #3967

  ;Linha 27
  static LoseScreen + #1080, #3967
  static LoseScreen + #1081, #3967
  static LoseScreen + #1082, #3967
  static LoseScreen + #1083, #3967
  static LoseScreen + #1084, #3967
  static LoseScreen + #1085, #3967
  static LoseScreen + #1086, #3967
  static LoseScreen + #1087, #3967
  static LoseScreen + #1088, #3967
  static LoseScreen + #1089, #3967
  static LoseScreen + #1090, #3967
  static LoseScreen + #1091, #3967
  static LoseScreen + #1092, #3967
  static LoseScreen + #1093, #3967
  static LoseScreen + #1094, #3967
  static LoseScreen + #1095, #3967
  static LoseScreen + #1096, #3967
  static LoseScreen + #1097, #3967
  static LoseScreen + #1098, #3967
  static LoseScreen + #1099, #3967
  static LoseScreen + #1100, #3967
  static LoseScreen + #1101, #3967
  static LoseScreen + #1102, #3967
  static LoseScreen + #1103, #3967
  static LoseScreen + #1104, #3967
  static LoseScreen + #1105, #3967
  static LoseScreen + #1106, #3967
  static LoseScreen + #1107, #3967
  static LoseScreen + #1108, #3967
  static LoseScreen + #1109, #3967
  static LoseScreen + #1110, #3967
  static LoseScreen + #1111, #3967
  static LoseScreen + #1112, #3967
  static LoseScreen + #1113, #3967
  static LoseScreen + #1114, #3967
  static LoseScreen + #1115, #3967
  static LoseScreen + #1116, #3967
  static LoseScreen + #1117, #3967
  static LoseScreen + #1118, #3967
  static LoseScreen + #1119, #3967

  ;Linha 28
  static LoseScreen + #1120, #3967
  static LoseScreen + #1121, #3967
  static LoseScreen + #1122, #3967
  static LoseScreen + #1123, #3967
  static LoseScreen + #1124, #3967
  static LoseScreen + #1125, #3967
  static LoseScreen + #1126, #3967
  static LoseScreen + #1127, #3967
  static LoseScreen + #1128, #3967
  static LoseScreen + #1129, #3967
  static LoseScreen + #1130, #3967
  static LoseScreen + #1131, #3967
  static LoseScreen + #1132, #3967
  static LoseScreen + #1133, #3967
  static LoseScreen + #1134, #3967
  static LoseScreen + #1135, #3967
  static LoseScreen + #1136, #3967
  static LoseScreen + #1137, #3967
  static LoseScreen + #1138, #3967
  static LoseScreen + #1139, #3967
  static LoseScreen + #1140, #3967
  static LoseScreen + #1141, #3967
  static LoseScreen + #1142, #3967
  static LoseScreen + #1143, #3967
  static LoseScreen + #1144, #3967
  static LoseScreen + #1145, #3967
  static LoseScreen + #1146, #3967
  static LoseScreen + #1147, #3967
  static LoseScreen + #1148, #3967
  static LoseScreen + #1149, #3967
  static LoseScreen + #1150, #3967
  static LoseScreen + #1151, #3967
  static LoseScreen + #1152, #3967
  static LoseScreen + #1153, #3967
  static LoseScreen + #1154, #3967
  static LoseScreen + #1155, #3967
  static LoseScreen + #1156, #3967
  static LoseScreen + #1157, #3967
  static LoseScreen + #1158, #3967
  static LoseScreen + #1159, #3967

  ;Linha 29
  static LoseScreen + #1160, #3967
  static LoseScreen + #1161, #3967
  static LoseScreen + #1162, #3967
  static LoseScreen + #1163, #3967
  static LoseScreen + #1164, #3967
  static LoseScreen + #1165, #3967
  static LoseScreen + #1166, #3967
  static LoseScreen + #1167, #3967
  static LoseScreen + #1168, #3967
  static LoseScreen + #1169, #3967
  static LoseScreen + #1170, #3967
  static LoseScreen + #1171, #3967
  static LoseScreen + #1172, #3967
  static LoseScreen + #1173, #3967
  static LoseScreen + #1174, #3967
  static LoseScreen + #1175, #3967
  static LoseScreen + #1176, #3967
  static LoseScreen + #1177, #3967
  static LoseScreen + #1178, #3967
  static LoseScreen + #1179, #3967
  static LoseScreen + #1180, #3967
  static LoseScreen + #1181, #3967
  static LoseScreen + #1182, #3967
  static LoseScreen + #1183, #3967
  static LoseScreen + #1184, #3967
  static LoseScreen + #1185, #3967
  static LoseScreen + #1186, #3967
  static LoseScreen + #1187, #3967
  static LoseScreen + #1188, #3967
  static LoseScreen + #1189, #3967
  static LoseScreen + #1190, #3967
  static LoseScreen + #1191, #3967
  static LoseScreen + #1192, #3967
  static LoseScreen + #1193, #3967
  static LoseScreen + #1194, #3967
  static LoseScreen + #1195, #3967
  static LoseScreen + #1196, #3967
  static LoseScreen + #1197, #3967
  static LoseScreen + #1198, #3967
  static LoseScreen + #1199, #3967


menu : var #1200
  ;Linha 0
  static menu + #0, #3967
  static menu + #1, #3967
  static menu + #2, #3967
  static menu + #3, #3967
  static menu + #4, #3967
  static menu + #5, #3967
  static menu + #6, #3967
  static menu + #7, #3967
  static menu + #8, #3967
  static menu + #9, #3967
  static menu + #10, #3967
  static menu + #11, #3967
  static menu + #12, #3967
  static menu + #13, #3967
  static menu + #14, #3967
  static menu + #15, #3967
  static menu + #16, #3967
  static menu + #17, #3967
  static menu + #18, #3967
  static menu + #19, #3967
  static menu + #20, #3967
  static menu + #21, #3967
  static menu + #22, #3967
  static menu + #23, #3967
  static menu + #24, #3967
  static menu + #25, #3967
  static menu + #26, #3967
  static menu + #27, #3967
  static menu + #28, #3967
  static menu + #29, #3967
  static menu + #30, #3967
  static menu + #31, #3967
  static menu + #32, #3967
  static menu + #33, #3967
  static menu + #34, #3967
  static menu + #35, #3967
  static menu + #36, #3967
  static menu + #37, #3967
  static menu + #38, #3967
  static menu + #39, #3967

  ;Linha 1
  static menu + #40, #3967
  static menu + #41, #3967
  static menu + #42, #3967
  static menu + #43, #3967
  static menu + #44, #3967
  static menu + #45, #3967
  static menu + #46, #3967
  static menu + #47, #3967
  static menu + #48, #3967
  static menu + #49, #3967
  static menu + #50, #3967
  static menu + #51, #3967
  static menu + #52, #3967
  static menu + #53, #3967
  static menu + #54, #3967
  static menu + #55, #3967
  static menu + #56, #3967
  static menu + #57, #3967
  static menu + #58, #3967
  static menu + #59, #3967
  static menu + #60, #3967
  static menu + #61, #3967
  static menu + #62, #3967
  static menu + #63, #3967
  static menu + #64, #3967
  static menu + #65, #3967
  static menu + #66, #3967
  static menu + #67, #3967
  static menu + #68, #3967
  static menu + #69, #3967
  static menu + #70, #3967
  static menu + #71, #3967
  static menu + #72, #3967
  static menu + #73, #3967
  static menu + #74, #3967
  static menu + #75, #3967
  static menu + #76, #3967
  static menu + #77, #3967
  static menu + #78, #3967
  static menu + #79, #3967

  ;Linha 2
  static menu + #80, #3967
  static menu + #81, #3967
  static menu + #82, #3967
  static menu + #83, #3967
  static menu + #84, #93
  static menu + #85, #93
  static menu + #86, #93
  static menu + #87, #3967
  static menu + #88, #3967
  static menu + #89, #93
  static menu + #90, #93
  static menu + #91, #93
  static menu + #92, #3967
  static menu + #93, #3967
  static menu + #94, #93
  static menu + #95, #93
  static menu + #96, #93
  static menu + #97, #3967
  static menu + #98, #3967
  static menu + #99, #93
  static menu + #100, #93
  static menu + #101, #3967
  static menu + #102, #3967
  static menu + #103, #3967
  static menu + #104, #93
  static menu + #105, #93
  static menu + #106, #3967
  static menu + #107, #3967
  static menu + #108, #3967
  static menu + #109, #93
  static menu + #110, #93
  static menu + #111, #93
  static menu + #112, #3967
  static menu + #113, #3967
  static menu + #114, #3967
  static menu + #115, #3967
  static menu + #116, #3967
  static menu + #117, #3967
  static menu + #118, #3967
  static menu + #119, #3967

  ;Linha 3
  static menu + #120, #3967
  static menu + #121, #3967
  static menu + #122, #3967
  static menu + #123, #93
  static menu + #124, #3967
  static menu + #125, #3967
  static menu + #126, #3967
  static menu + #127, #3967
  static menu + #128, #93
  static menu + #129, #3967
  static menu + #130, #3967
  static menu + #131, #3967
  static menu + #132, #3967
  static menu + #133, #93
  static menu + #134, #3967
  static menu + #135, #3967
  static menu + #136, #3967
  static menu + #137, #3967
  static menu + #138, #93
  static menu + #139, #3967
  static menu + #140, #3967
  static menu + #141, #93
  static menu + #142, #3967
  static menu + #143, #93
  static menu + #144, #3967
  static menu + #145, #3967
  static menu + #146, #93
  static menu + #147, #3967
  static menu + #148, #93
  static menu + #149, #3967
  static menu + #150, #3967
  static menu + #151, #3967
  static menu + #152, #3967
  static menu + #153, #3967
  static menu + #154, #3967
  static menu + #155, #3967
  static menu + #156, #3967
  static menu + #157, #3967
  static menu + #158, #3967
  static menu + #159, #3967

  ;Linha 4
  static menu + #160, #3967
  static menu + #161, #3967
  static menu + #162, #3967
  static menu + #163, #93
  static menu + #164, #93
  static menu + #165, #93
  static menu + #166, #3967
  static menu + #167, #3967
  static menu + #168, #3967
  static menu + #169, #93
  static menu + #170, #93
  static menu + #171, #3967
  static menu + #172, #3967
  static menu + #173, #93
  static menu + #174, #3967
  static menu + #175, #3967
  static menu + #176, #3967
  static menu + #177, #3967
  static menu + #178, #93
  static menu + #179, #93
  static menu + #180, #93
  static menu + #181, #93
  static menu + #182, #3967
  static menu + #183, #93
  static menu + #184, #93
  static menu + #185, #93
  static menu + #186, #3967
  static menu + #187, #3967
  static menu + #188, #93
  static menu + #189, #93
  static menu + #190, #93
  static menu + #191, #3967
  static menu + #192, #3967
  static menu + #193, #3967
  static menu + #194, #3967
  static menu + #195, #3967
  static menu + #196, #3967
  static menu + #197, #3967
  static menu + #198, #3967
  static menu + #199, #3967

  ;Linha 5
  static menu + #200, #3967
  static menu + #201, #3967
  static menu + #202, #3967
  static menu + #203, #93
  static menu + #204, #3967
  static menu + #205, #3967
  static menu + #206, #3967
  static menu + #207, #3967
  static menu + #208, #3967
  static menu + #209, #3967
  static menu + #210, #3967
  static menu + #211, #93
  static menu + #212, #3967
  static menu + #213, #93
  static menu + #214, #3967
  static menu + #215, #3967
  static menu + #216, #3967
  static menu + #217, #3967
  static menu + #218, #93
  static menu + #219, #3967
  static menu + #220, #3967
  static menu + #221, #93
  static menu + #222, #3967
  static menu + #223, #93
  static menu + #224, #3967
  static menu + #225, #3967
  static menu + #226, #3967
  static menu + #227, #3967
  static menu + #228, #93
  static menu + #229, #3967
  static menu + #230, #3967
  static menu + #231, #3967
  static menu + #232, #3967
  static menu + #233, #3967
  static menu + #234, #3967
  static menu + #235, #3967
  static menu + #236, #3967
  static menu + #237, #3967
  static menu + #238, #3967
  static menu + #239, #3967

  ;Linha 6
  static menu + #240, #3967
  static menu + #241, #3967
  static menu + #242, #3967
  static menu + #243, #3967
  static menu + #244, #93
  static menu + #245, #93
  static menu + #246, #93
  static menu + #247, #3967
  static menu + #248, #93
  static menu + #249, #93
  static menu + #250, #93
  static menu + #251, #3967
  static menu + #252, #3967
  static menu + #253, #3967
  static menu + #254, #93
  static menu + #255, #93
  static menu + #256, #93
  static menu + #257, #3967
  static menu + #258, #93
  static menu + #259, #3967
  static menu + #260, #3967
  static menu + #261, #93
  static menu + #262, #3967
  static menu + #263, #93
  static menu + #264, #3967
  static menu + #265, #3967
  static menu + #266, #3967
  static menu + #267, #3967
  static menu + #268, #3967
  static menu + #269, #93
  static menu + #270, #93
  static menu + #271, #93
  static menu + #272, #3967
  static menu + #273, #3967
  static menu + #274, #3967
  static menu + #275, #3967
  static menu + #276, #3967
  static menu + #277, #3967
  static menu + #278, #3967
  static menu + #279, #3967

  ;Linha 7
  static menu + #280, #3967
  static menu + #281, #3967
  static menu + #282, #3967
  static menu + #283, #3967
  static menu + #284, #3967
  static menu + #285, #3967
  static menu + #286, #3967
  static menu + #287, #3967
  static menu + #288, #3967
  static menu + #289, #3967
  static menu + #290, #3967
  static menu + #291, #3967
  static menu + #292, #3967
  static menu + #293, #3967
  static menu + #294, #3967
  static menu + #295, #3967
  static menu + #296, #3967
  static menu + #297, #3967
  static menu + #298, #3967
  static menu + #299, #3967
  static menu + #300, #3967
  static menu + #301, #3967
  static menu + #302, #3967
  static menu + #303, #3967
  static menu + #304, #3967
  static menu + #305, #3967
  static menu + #306, #3967
  static menu + #307, #3967
  static menu + #308, #3967
  static menu + #309, #3967
  static menu + #310, #3967
  static menu + #311, #3967
  static menu + #312, #3967
  static menu + #313, #3967
  static menu + #314, #3967
  static menu + #315, #3967
  static menu + #316, #3967
  static menu + #317, #3967
  static menu + #318, #3967
  static menu + #319, #3967

  ;Linha 8
  static menu + #320, #3967
  static menu + #321, #3967
  static menu + #322, #3967
  static menu + #323, #3967
  static menu + #324, #3967
  static menu + #325, #93
  static menu + #326, #93
  static menu + #327, #3967
  static menu + #328, #3967
  static menu + #329, #93
  static menu + #330, #93
  static menu + #331, #3967
  static menu + #332, #3967
  static menu + #333, #3967
  static menu + #334, #93
  static menu + #335, #93
  static menu + #336, #3967
  static menu + #337, #3967
  static menu + #338, #3967
  static menu + #339, #93
  static menu + #340, #3967
  static menu + #341, #93
  static menu + #342, #3967
  static menu + #343, #3967
  static menu + #344, #3967
  static menu + #345, #3967
  static menu + #346, #3967
  static menu + #347, #3967
  static menu + #348, #3967
  static menu + #349, #3967
  static menu + #350, #3967
  static menu + #351, #3967
  static menu + #352, #3967
  static menu + #353, #3967
  static menu + #354, #3967
  static menu + #355, #3967
  static menu + #356, #3967
  static menu + #357, #3967
  static menu + #358, #3967
  static menu + #359, #3967

  ;Linha 9
  static menu + #360, #3967
  static menu + #361, #3967
  static menu + #362, #3967
  static menu + #363, #3967
  static menu + #364, #93
  static menu + #365, #3967
  static menu + #366, #3967
  static menu + #367, #3967
  static menu + #368, #93
  static menu + #369, #3967
  static menu + #370, #3967
  static menu + #371, #93
  static menu + #372, #3967
  static menu + #373, #93
  static menu + #374, #3967
  static menu + #375, #3967
  static menu + #376, #93
  static menu + #377, #3967
  static menu + #378, #93
  static menu + #379, #3967
  static menu + #380, #93
  static menu + #381, #3967
  static menu + #382, #93
  static menu + #383, #3967
  static menu + #384, #3967
  static menu + #385, #3967
  static menu + #386, #3967
  static menu + #387, #3967
  static menu + #388, #3967
  static menu + #389, #3967
  static menu + #390, #3967
  static menu + #391, #3967
  static menu + #392, #3967
  static menu + #393, #3967
  static menu + #394, #3967
  static menu + #395, #3967
  static menu + #396, #3967
  static menu + #397, #3967
  static menu + #398, #3967
  static menu + #399, #3967

  ;Linha 10
  static menu + #400, #3967
  static menu + #401, #3967
  static menu + #402, #3967
  static menu + #403, #3967
  static menu + #404, #93
  static menu + #405, #93
  static menu + #406, #3967
  static menu + #407, #3967
  static menu + #408, #93
  static menu + #409, #93
  static menu + #410, #93
  static menu + #411, #3967
  static menu + #412, #3967
  static menu + #413, #93
  static menu + #414, #3967
  static menu + #415, #3967
  static menu + #416, #93
  static menu + #417, #3967
  static menu + #418, #93
  static menu + #419, #3967
  static menu + #420, #93
  static menu + #421, #3967
  static menu + #422, #93
  static menu + #423, #3967
  static menu + #424, #3967
  static menu + #425, #3967
  static menu + #426, #3967
  static menu + #427, #3967
  static menu + #428, #3967
  static menu + #429, #3967
  static menu + #430, #3967
  static menu + #431, #3967
  static menu + #432, #3967
  static menu + #433, #3967
  static menu + #434, #3967
  static menu + #435, #3967
  static menu + #436, #3967
  static menu + #437, #3967
  static menu + #438, #3967
  static menu + #439, #3967

  ;Linha 11
  static menu + #440, #3967
  static menu + #441, #3967
  static menu + #442, #3967
  static menu + #443, #3967
  static menu + #444, #93
  static menu + #445, #3967
  static menu + #446, #3967
  static menu + #447, #3967
  static menu + #448, #93
  static menu + #449, #3967
  static menu + #450, #3967
  static menu + #451, #93
  static menu + #452, #3967
  static menu + #453, #3967
  static menu + #454, #93
  static menu + #455, #93
  static menu + #456, #3967
  static menu + #457, #3967
  static menu + #458, #93
  static menu + #459, #3967
  static menu + #460, #3967
  static menu + #461, #3967
  static menu + #462, #93
  static menu + #463, #3967
  static menu + #464, #3967
  static menu + #465, #3967
  static menu + #466, #3967
  static menu + #467, #3967
  static menu + #468, #3967
  static menu + #469, #3967
  static menu + #470, #3967
  static menu + #471, #3967
  static menu + #472, #3967
  static menu + #473, #3967
  static menu + #474, #3967
  static menu + #475, #3967
  static menu + #476, #3967
  static menu + #477, #3967
  static menu + #478, #3967
  static menu + #479, #3967

  ;Linha 12
  static menu + #480, #3967
  static menu + #481, #3967
  static menu + #482, #3967
  static menu + #483, #3967
  static menu + #484, #3967
  static menu + #485, #3967
  static menu + #486, #3967
  static menu + #487, #3967
  static menu + #488, #3967
  static menu + #489, #3967
  static menu + #490, #3967
  static menu + #491, #3967
  static menu + #492, #3967
  static menu + #493, #3967
  static menu + #494, #3967
  static menu + #495, #3967
  static menu + #496, #3967
  static menu + #497, #3967
  static menu + #498, #3967
  static menu + #499, #3967
  static menu + #500, #3967
  static menu + #501, #3967
  static menu + #502, #3967
  static menu + #503, #3967
  static menu + #504, #3967
  static menu + #505, #3967
  static menu + #506, #3967
  static menu + #507, #3967
  static menu + #508, #3967
  static menu + #509, #3967
  static menu + #510, #3967
  static menu + #511, #3967
  static menu + #512, #3967
  static menu + #513, #3967
  static menu + #514, #3967
  static menu + #515, #3967
  static menu + #516, #3967
  static menu + #517, #3967
  static menu + #518, #3967
  static menu + #519, #3967

  ;Linha 13
  static menu + #520, #3967
  static menu + #521, #3967
  static menu + #522, #3967
  static menu + #523, #3967
  static menu + #524, #93
  static menu + #525, #93
  static menu + #526, #3967
  static menu + #527, #3967
  static menu + #528, #3967
  static menu + #529, #2397
  static menu + #530, #2397
  static menu + #531, #3967
  static menu + #532, #3967
  static menu + #533, #93
  static menu + #534, #3967
  static menu + #535, #3967
  static menu + #536, #3967
  static menu + #537, #3165
  static menu + #538, #3967
  static menu + #539, #3967
  static menu + #540, #93
  static menu + #541, #93
  static menu + #542, #93
  static menu + #543, #3967
  static menu + #544, #3967
  static menu + #545, #2397
  static menu + #546, #2397
  static menu + #547, #2397
  static menu + #548, #3967
  static menu + #549, #3967
  static menu + #550, #3967
  static menu + #551, #3967
  static menu + #552, #3967
  static menu + #553, #3967
  static menu + #554, #3967
  static menu + #555, #3967
  static menu + #556, #3967
  static menu + #557, #3967
  static menu + #558, #3967
  static menu + #559, #3967

  ;Linha 14
  static menu + #560, #3967
  static menu + #561, #3967
  static menu + #562, #3967
  static menu + #563, #93
  static menu + #564, #3967
  static menu + #565, #3967
  static menu + #566, #93
  static menu + #567, #3967
  static menu + #568, #2397
  static menu + #569, #3967
  static menu + #570, #3967
  static menu + #571, #2397
  static menu + #572, #3967
  static menu + #573, #93
  static menu + #574, #3967
  static menu + #575, #3967
  static menu + #576, #3967
  static menu + #577, #3967
  static menu + #578, #3967
  static menu + #579, #93
  static menu + #580, #3967
  static menu + #581, #3967
  static menu + #582, #3967
  static menu + #583, #3967
  static menu + #584, #2397
  static menu + #585, #3967
  static menu + #586, #3967
  static menu + #587, #3967
  static menu + #588, #3967
  static menu + #589, #3967
  static menu + #590, #3967
  static menu + #591, #3967
  static menu + #592, #3967
  static menu + #593, #3967
  static menu + #594, #3967
  static menu + #595, #3967
  static menu + #596, #3967
  static menu + #597, #3967
  static menu + #598, #3967
  static menu + #599, #3967

  ;Linha 15
  static menu + #600, #3967
  static menu + #601, #3967
  static menu + #602, #3967
  static menu + #603, #93
  static menu + #604, #93
  static menu + #605, #93
  static menu + #606, #3967
  static menu + #607, #3967
  static menu + #608, #2397
  static menu + #609, #3967
  static menu + #610, #3967
  static menu + #611, #2397
  static menu + #612, #3967
  static menu + #613, #93
  static menu + #614, #3967
  static menu + #615, #3967
  static menu + #616, #3967
  static menu + #617, #3165
  static menu + #618, #3967
  static menu + #619, #93
  static menu + #620, #3967
  static menu + #621, #3967
  static menu + #622, #3967
  static menu + #623, #3967
  static menu + #624, #2397
  static menu + #625, #2397
  static menu + #626, #2397
  static menu + #627, #3967
  static menu + #628, #3967
  static menu + #629, #3967
  static menu + #630, #3967
  static menu + #631, #3967
  static menu + #632, #3967
  static menu + #633, #3967
  static menu + #634, #3967
  static menu + #635, #3967
  static menu + #636, #3967
  static menu + #637, #3967
  static menu + #638, #3967
  static menu + #639, #3967

  ;Linha 16
  static menu + #640, #3967
  static menu + #641, #3967
  static menu + #642, #3967
  static menu + #643, #93
  static menu + #644, #3967
  static menu + #645, #3967
  static menu + #646, #3967
  static menu + #647, #3967
  static menu + #648, #2397
  static menu + #649, #3967
  static menu + #650, #3967
  static menu + #651, #2397
  static menu + #652, #3967
  static menu + #653, #93
  static menu + #654, #3967
  static menu + #655, #3967
  static menu + #656, #3967
  static menu + #657, #3165
  static menu + #658, #3967
  static menu + #659, #93
  static menu + #660, #3967
  static menu + #661, #3967
  static menu + #662, #3967
  static menu + #663, #3967
  static menu + #664, #2397
  static menu + #665, #3967
  static menu + #666, #3967
  static menu + #667, #3967
  static menu + #668, #3967
  static menu + #669, #3967
  static menu + #670, #3967
  static menu + #671, #3967
  static menu + #672, #3967
  static menu + #673, #3967
  static menu + #674, #3967
  static menu + #675, #3967
  static menu + #676, #3967
  static menu + #677, #3967
  static menu + #678, #3967
  static menu + #679, #3967

  ;Linha 17
  static menu + #680, #3967
  static menu + #681, #3967
  static menu + #682, #3967
  static menu + #683, #93
  static menu + #684, #3967
  static menu + #685, #3967
  static menu + #686, #3967
  static menu + #687, #3967
  static menu + #688, #3967
  static menu + #689, #2397
  static menu + #690, #2397
  static menu + #691, #3967
  static menu + #692, #3967
  static menu + #693, #3967
  static menu + #694, #93
  static menu + #695, #93
  static menu + #696, #3967
  static menu + #697, #3165
  static menu + #698, #3967
  static menu + #699, #3967
  static menu + #700, #93
  static menu + #701, #93
  static menu + #702, #93
  static menu + #703, #3967
  static menu + #704, #3967
  static menu + #705, #2397
  static menu + #706, #2397
  static menu + #707, #2397
  static menu + #708, #3967
  static menu + #709, #3967
  static menu + #710, #3967
  static menu + #711, #3967
  static menu + #712, #3967
  static menu + #713, #3967
  static menu + #714, #3967
  static menu + #715, #3967
  static menu + #716, #3967
  static menu + #717, #3967
  static menu + #718, #3967
  static menu + #719, #3967

  ;Linha 18
  static menu + #720, #3967
  static menu + #721, #3967
  static menu + #722, #3967
  static menu + #723, #3967
  static menu + #724, #3967
  static menu + #725, #3967
  static menu + #726, #3967
  static menu + #727, #3967
  static menu + #728, #3967
  static menu + #729, #3967
  static menu + #730, #3967
  static menu + #731, #3967
  static menu + #732, #3967
  static menu + #733, #3967
  static menu + #734, #3967
  static menu + #735, #3967
  static menu + #736, #3967
  static menu + #737, #3967
  static menu + #738, #3967
  static menu + #739, #3967
  static menu + #740, #3967
  static menu + #741, #3967
  static menu + #742, #3967
  static menu + #743, #3967
  static menu + #744, #3967
  static menu + #745, #3967
  static menu + #746, #3967
  static menu + #747, #3967
  static menu + #748, #3967
  static menu + #749, #3967
  static menu + #750, #3967
  static menu + #751, #3967
  static menu + #752, #3967
  static menu + #753, #3967
  static menu + #754, #3967
  static menu + #755, #3967
  static menu + #756, #3967
  static menu + #757, #3967
  static menu + #758, #3967
  static menu + #759, #3967

  ;Linha 19
  static menu + #760, #3967
  static menu + #761, #3967
  static menu + #762, #3967
  static menu + #763, #3967
  static menu + #764, #3967
  static menu + #765, #3967
  static menu + #766, #3967
  static menu + #767, #3967
  static menu + #768, #3967
  static menu + #769, #3967
  static menu + #770, #3967
  static menu + #771, #3967
  static menu + #772, #3967
  static menu + #773, #3967
  static menu + #774, #3967
  static menu + #775, #3967
  static menu + #776, #3967
  static menu + #777, #3967
  static menu + #778, #3967
  static menu + #779, #3967
  static menu + #780, #3967
  static menu + #781, #3967
  static menu + #782, #3967
  static menu + #783, #3967
  static menu + #784, #3967
  static menu + #785, #3967
  static menu + #786, #3967
  static menu + #787, #3967
  static menu + #788, #3967
  static menu + #789, #3967
  static menu + #790, #3967
  static menu + #791, #3967
  static menu + #792, #3967
  static menu + #793, #3967
  static menu + #794, #3967
  static menu + #795, #3967
  static menu + #796, #3967
  static menu + #797, #3967
  static menu + #798, #3967
  static menu + #799, #3967

  ;Linha 20
  static menu + #800, #3967
  static menu + #801, #3967
  static menu + #802, #3967
  static menu + #803, #3967
  static menu + #804, #3967
  static menu + #805, #3967
  static menu + #806, #3967
  static menu + #807, #3967
  static menu + #808, #3967
  static menu + #809, #3967
  static menu + #810, #3967
  static menu + #811, #3967
  static menu + #812, #3967
  static menu + #813, #3967
  static menu + #814, #3967
  static menu + #815, #3967
  static menu + #816, #3967
  static menu + #817, #3967
  static menu + #818, #3967
  static menu + #819, #3967
  static menu + #820, #3967
  static menu + #821, #3967
  static menu + #822, #3967
  static menu + #823, #3967
  static menu + #824, #3967
  static menu + #825, #3967
  static menu + #826, #3967
  static menu + #827, #3967
  static menu + #828, #3967
  static menu + #829, #3967
  static menu + #830, #3967
  static menu + #831, #3967
  static menu + #832, #3967
  static menu + #833, #3967
  static menu + #834, #3967
  static menu + #835, #3967
  static menu + #836, #3967
  static menu + #837, #3967
  static menu + #838, #3967
  static menu + #839, #3967

  ;Linha 21
  static menu + #840, #3967
  static menu + #841, #3967
  static menu + #842, #3967
  static menu + #843, #3967
  static menu + #844, #3967
  static menu + #845, #3967
  static menu + #846, #3967
  static menu + #847, #3967
  static menu + #848, #3967
  static menu + #849, #3967
  static menu + #850, #3967
  static menu + #851, #3967
  static menu + #852, #3967
  static menu + #853, #3967
  static menu + #854, #3967
  static menu + #855, #3967
  static menu + #856, #3967
  static menu + #857, #3967
  static menu + #858, #3967
  static menu + #859, #3967
  static menu + #860, #3967
  static menu + #861, #3967
  static menu + #862, #3967
  static menu + #863, #3967
  static menu + #864, #3967
  static menu + #865, #3967
  static menu + #866, #3967
  static menu + #867, #3967
  static menu + #868, #3967
  static menu + #869, #3967
  static menu + #870, #3967
  static menu + #871, #3967
  static menu + #872, #3967
  static menu + #873, #3967
  static menu + #874, #3967
  static menu + #875, #3967
  static menu + #876, #3967
  static menu + #877, #3967
  static menu + #878, #3967
  static menu + #879, #3967

  ;Linha 22
  static menu + #880, #3967
  static menu + #881, #3967
  static menu + #882, #3967
  static menu + #883, #3967
  static menu + #884, #3967
  static menu + #885, #3967
  static menu + #886, #3967
  static menu + #887, #3967
  static menu + #888, #3967
  static menu + #889, #3967
  static menu + #890, #3967
  static menu + #891, #3967
  static menu + #892, #3967
  static menu + #893, #3967
  static menu + #894, #3967
  static menu + #895, #3967
  static menu + #896, #3967
  static menu + #897, #3967
  static menu + #898, #3967
  static menu + #899, #3967
  static menu + #900, #3967
  static menu + #901, #3967
  static menu + #902, #3967
  static menu + #903, #3967
  static menu + #904, #3967
  static menu + #905, #3967
  static menu + #906, #3967
  static menu + #907, #3967
  static menu + #908, #3967
  static menu + #909, #3967
  static menu + #910, #3967
  static menu + #911, #3967
  static menu + #912, #3967
  static menu + #913, #3967
  static menu + #914, #3967
  static menu + #915, #3967
  static menu + #916, #3967
  static menu + #917, #3967
  static menu + #918, #3967
  static menu + #919, #3967

  ;Linha 23
  static menu + #920, #3967
  static menu + #921, #3967
  static menu + #922, #3967
  static menu + #923, #3967
  static menu + #924, #3967
  static menu + #925, #3967
  static menu + #926, #3967
  static menu + #927, #3967
  static menu + #928, #3967
  static menu + #929, #3967
  static menu + #930, #3967
  static menu + #931, #80
  static menu + #932, #82
  static menu + #933, #69
  static menu + #934, #83
  static menu + #935, #83
  static menu + #936, #3967
  static menu + #937, #88
  static menu + #938, #3967
  static menu + #939, #84
  static menu + #940, #79
  static menu + #941, #3967
  static menu + #942, #83
  static menu + #943, #84
  static menu + #944, #65
  static menu + #945, #82
  static menu + #946, #84
  static menu + #947, #3967
  static menu + #948, #3967
  static menu + #949, #3967
  static menu + #950, #3967
  static menu + #951, #3967
  static menu + #952, #3967
  static menu + #953, #3967
  static menu + #954, #3967
  static menu + #955, #3967
  static menu + #956, #3967
  static menu + #957, #3967
  static menu + #958, #3967
  static menu + #959, #3967

  ;Linha 24
  static menu + #960, #3967
  static menu + #961, #3967
  static menu + #962, #3967
  static menu + #963, #3967
  static menu + #964, #3967
  static menu + #965, #3967
  static menu + #966, #3967
  static menu + #967, #3967
  static menu + #968, #3967
  static menu + #969, #3967
  static menu + #970, #3967
  static menu + #971, #3967
  static menu + #972, #3967
  static menu + #973, #3967
  static menu + #974, #3967
  static menu + #975, #3967
  static menu + #976, #3967
  static menu + #977, #3967
  static menu + #978, #3967
  static menu + #979, #3967
  static menu + #980, #3967
  static menu + #981, #3967
  static menu + #982, #3967
  static menu + #983, #3967
  static menu + #984, #3967
  static menu + #985, #3967
  static menu + #986, #3967
  static menu + #987, #3967
  static menu + #988, #3967
  static menu + #989, #3967
  static menu + #990, #3967
  static menu + #991, #3967
  static menu + #992, #3967
  static menu + #993, #3967
  static menu + #994, #3967
  static menu + #995, #3967
  static menu + #996, #3967
  static menu + #997, #3967
  static menu + #998, #3967
  static menu + #999, #3967

  ;Linha 25
  static menu + #1000, #3967
  static menu + #1001, #3967
  static menu + #1002, #3967
  static menu + #1003, #3967
  static menu + #1004, #3967
  static menu + #1005, #3967
  static menu + #1006, #3967
  static menu + #1007, #3967
  static menu + #1008, #3967
  static menu + #1009, #3967
  static menu + #1010, #3967
  static menu + #1011, #3967
  static menu + #1012, #3967
  static menu + #1013, #3967
  static menu + #1014, #3967
  static menu + #1015, #3967
  static menu + #1016, #3967
  static menu + #1017, #3967
  static menu + #1018, #3967
  static menu + #1019, #3967
  static menu + #1020, #3967
  static menu + #1021, #3967
  static menu + #1022, #3967
  static menu + #1023, #3967
  static menu + #1024, #3967
  static menu + #1025, #3967
  static menu + #1026, #3967
  static menu + #1027, #3967
  static menu + #1028, #3967
  static menu + #1029, #3967
  static menu + #1030, #3967
  static menu + #1031, #3967
  static menu + #1032, #3967
  static menu + #1033, #3967
  static menu + #1034, #3967
  static menu + #1035, #3967
  static menu + #1036, #3967
  static menu + #1037, #3967
  static menu + #1038, #3967
  static menu + #1039, #3967

  ;Linha 26
  static menu + #1040, #3967
  static menu + #1041, #3967
  static menu + #1042, #3967
  static menu + #1043, #3967
  static menu + #1044, #3967
  static menu + #1045, #3967
  static menu + #1046, #3967
  static menu + #1047, #3967
  static menu + #1048, #3967
  static menu + #1049, #3967
  static menu + #1050, #3967
  static menu + #1051, #3967
  static menu + #1052, #3967
  static menu + #1053, #3967
  static menu + #1054, #3967
  static menu + #1055, #3967
  static menu + #1056, #3967
  static menu + #1057, #3967
  static menu + #1058, #3967
  static menu + #1059, #3967
  static menu + #1060, #3967
  static menu + #1061, #3967
  static menu + #1062, #3967
  static menu + #1063, #3967
  static menu + #1064, #3967
  static menu + #1065, #3967
  static menu + #1066, #3967
  static menu + #1067, #3967
  static menu + #1068, #3967
  static menu + #1069, #3967
  static menu + #1070, #3967
  static menu + #1071, #3967
  static menu + #1072, #3967
  static menu + #1073, #3967
  static menu + #1074, #3967
  static menu + #1075, #3967
  static menu + #1076, #3967
  static menu + #1077, #3967
  static menu + #1078, #3967
  static menu + #1079, #3967

  ;Linha 27
  static menu + #1080, #3967
  static menu + #1081, #3967
  static menu + #1082, #3967
  static menu + #1083, #3967
  static menu + #1084, #3967
  static menu + #1085, #3967
  static menu + #1086, #3967
  static menu + #1087, #3967
  static menu + #1088, #3967
  static menu + #1089, #3967
  static menu + #1090, #3967
  static menu + #1091, #3967
  static menu + #1092, #3967
  static menu + #1093, #3967
  static menu + #1094, #3967
  static menu + #1095, #3967
  static menu + #1096, #3967
  static menu + #1097, #3967
  static menu + #1098, #3967
  static menu + #1099, #3967
  static menu + #1100, #3967
  static menu + #1101, #3967
  static menu + #1102, #3967
  static menu + #1103, #3967
  static menu + #1104, #3967
  static menu + #1105, #3967
  static menu + #1106, #3967
  static menu + #1107, #3967
  static menu + #1108, #3967
  static menu + #1109, #3967
  static menu + #1110, #3967
  static menu + #1111, #3967
  static menu + #1112, #3967
  static menu + #1113, #3967
  static menu + #1114, #3967
  static menu + #1115, #3967
  static menu + #1116, #3967
  static menu + #1117, #3967
  static menu + #1118, #3967
  static menu + #1119, #3967

  ;Linha 28
  static menu + #1120, #3967
  static menu + #1121, #3967
  static menu + #1122, #3967
  static menu + #1123, #3967
  static menu + #1124, #3967
  static menu + #1125, #3967
  static menu + #1126, #3967
  static menu + #1127, #3967
  static menu + #1128, #3967
  static menu + #1129, #3967
  static menu + #1130, #3967
  static menu + #1131, #3967
  static menu + #1132, #3967
  static menu + #1133, #3967
  static menu + #1134, #3967
  static menu + #1135, #3967
  static menu + #1136, #3967
  static menu + #1137, #3967
  static menu + #1138, #3967
  static menu + #1139, #3967
  static menu + #1140, #3967
  static menu + #1141, #3967
  static menu + #1142, #3967
  static menu + #1143, #3967
  static menu + #1144, #3967
  static menu + #1145, #3967
  static menu + #1146, #3967
  static menu + #1147, #3967
  static menu + #1148, #3967
  static menu + #1149, #3967
  static menu + #1150, #3967
  static menu + #1151, #3967
  static menu + #1152, #3967
  static menu + #1153, #3967
  static menu + #1154, #3967
  static menu + #1155, #3967
  static menu + #1156, #3967
  static menu + #1157, #3967
  static menu + #1158, #3967
  static menu + #1159, #3967

  ;Linha 29
  static menu + #1160, #3967
  static menu + #1161, #3967
  static menu + #1162, #3967
  static menu + #1163, #3967
  static menu + #1164, #3967
  static menu + #1165, #3967
  static menu + #1166, #3967
  static menu + #1167, #3967
  static menu + #1168, #3967
  static menu + #1169, #3967
  static menu + #1170, #3967
  static menu + #1171, #3967
  static menu + #1172, #3967
  static menu + #1173, #3967
  static menu + #1174, #3967
  static menu + #1175, #3967
  static menu + #1176, #3967
  static menu + #1177, #3967
  static menu + #1178, #3967
  static menu + #1179, #3967
  static menu + #1180, #3967
  static menu + #1181, #3967
  static menu + #1182, #3967
  static menu + #1183, #3967
  static menu + #1184, #3967
  static menu + #1185, #3967
  static menu + #1186, #3967
  static menu + #1187, #3967
  static menu + #1188, #3967
  static menu + #1189, #3967
  static menu + #1190, #3967
  static menu + #1191, #3967
  static menu + #1192, #3967
  static menu + #1193, #3967
  static menu + #1194, #3967
  static menu + #1195, #3967
  static menu + #1196, #3967
  static menu + #1197, #3967
  static menu + #1198, #3967
  static menu + #1199, #3967

; numeros aleatorios
rand: var #31
static rand + #0, #783
static rand + #1, #42
static rand + #2, #1178
static rand + #3, #356
static rand + #4, #962
static rand + #5, #109
static rand + #6, #704
static rand + #7, #220
static rand + #8, #117
static rand + #9, #892
static rand + #10, #531
static rand + #11, #1034
static rand + #12, #648
static rand + #13, #299
static rand + #14, #1150
static rand + #15, #71
static rand + #16, #814
static rand + #17, #384
static rand + #18, #1012
static rand + #19, #165
static rand + #20, #945
static rand + #21, #502
static rand + #22, #214
static rand + #23, #1111
static rand + #24, #321
static rand + #25, #769
static rand + #26, #87
static rand + #27, #638
static rand + #28, #1140
static rand + #29, #455
static rand + #30, #596

policia_U : var #6
  static policia_U + #0, #3078 ; atrasdireita
  static policia_U + #1, #2311    ; meiodireita
  static policia_U + #2, #3080 ; frentedireita
  static policia_U + #3, #3088 ; atrasesquerda
  static policia_U + #4, #2321 ; meioesquerda
  static policia_U + #5, #3090 ; frenteesquerda
  
policia_D : var #6 ; (Vou inverter a lógica de Cima)
  static policia_D + #0, #3114 ; "atras" (agora frente)
  static policia_D + #1, #2345
  static policia_D + #2, #3112
  static policia_D + #3, #3132
  static policia_D + #4, #2363
  static policia_D + #5, #3130

policia_L : var #6 ; (Vou usar o H)
  static policia_L + #0, #3075 ; cardf (Frente-Topo)
  static policia_L + #1, #4    ; cardm (Meio-Topo)
  static policia_L + #2, #3077 ; cardb (Trás-Topo)
  static policia_L + #3, #3072 ; carf  (Frente-Baixo)
  static policia_L + #4, #2305 ; carm  (Meio-Baixo)
  static policia_L + #5, #3074 ; carb  (Trás-Baixo)

policia_R : var #6 ; (Vou inverter o H)
  static policia_R + #0, #3086 ; "trás" (agora frente)
  static policia_R + #1, #2317
  static policia_R + #2, #3084
  static policia_R + #3, #3083
  static policia_R + #4, #2314
  static policia_R + #5, #3081
  
; Gaps para o sprite Horizontal 3x2
policiaGaps_H : var #6
  static policiaGaps_H + #0, #0  ; Topo-Esquerda
  static policiaGaps_H + #1, #1  ; Topo-Meio
  static policiaGaps_H + #2, #2  ; Topo-Direita
  static policiaGaps_H + #3, #40 ; Baixo-Esquerda
  static policiaGaps_H + #4, #41 ; Baixo-Meio
  static policiaGaps_H + #5, #42 ; Baixo-Direita
  
; Gaps para o sprite Vertical 2x3 (para bater com a sua ladrao_V)
policiaGaps_V : var #6
  static policiaGaps_V + #0, #81  ; atrasdireita (Linha 0, Col 1)
  static policiaGaps_V + #1, #41 ; meiodireita  (Linha 1, Col 1)
  static policiaGaps_V + #2, #1 ; frentedireita(Linha 2, Col 1)
  static policiaGaps_V + #3, #80  ; atrasesquerda (Linha 0, Col 0)
  static policiaGaps_V + #4, #40 ; meioesquerda  (Linha 1, Col 0)
  static policiaGaps_V + #5, #0 ; frenteesquerda(Linha 2, Col 0)


; --- SPRITES DO LADRÃO (4 DIREÇÕES) ---

; Sprite para CIMA (era ladrao_V)
ladrao_U : var #6
  static ladrao_U + #0, #2310 ; atrasdireita
  static ladrao_U + #1, #2311 ; meiodireita
  static ladrao_U + #2, #2312 ; frentedireita
  static ladrao_U + #3, #2320 ; atrasesquerda
  static ladrao_U + #4, #2321 ; meioesquerda
  static ladrao_U + #5, #2322 ; frenteesquerda

; Sprite para BAIXO (IDs do seu comentário, +2304 para cor)
ladrao_D : var #6
  static ladrao_D + #0, #2346  ; 58 + 2304 (traseira esquerda p/ baixo)
  static ladrao_D + #1, #2345  ; 59 + 2304 (meio esquerda p/ baixo)
  static ladrao_D + #2, #2344  ; 60 + 2304 (frente esquerda p/ baixo)
  static ladrao_D + #3, #2364 ; 40 + 2304 (traseira direita p/ baixo)
  static ladrao_D + #4, #2363 ; 41 + 2304 (meio direita p/ baixo)
  static ladrao_D + #5, #2362 ; 42 + 2304 (frente direita p/ baixo)

; Sprite para ESQUERDA (era ladrao_H)
ladrao_L : var #6
  static ladrao_L + #0, #2307 ; cardf (Frente-Topo)
  static ladrao_L + #1, #2308 ; cardm (Meio-Topo)
  static ladrao_L + #2, #2309 ; cardb (Trás-Topo)
  static ladrao_L + #3, #2304 ; carf  (Frente-Baixo)
  static ladrao_L + #4, #2305 ; carm  (Meio-Baixo)
  static ladrao_L + #5, #2306 ; carb  (Trás-Baixo)

; Sprite para DIREITA (IDs do seu comentário, +2304 para cor)
ladrao_R : var #6
  static ladrao_R + #0, #2318  ; 11 + 2304 (traseira direita p/ direita)
  static ladrao_R + #1, #2317 ; 10 + 2304 (meio direita p/ direita)
  static ladrao_R + #2, #2316  ; 9  + 2304 (frente direita p/ direita)
  static ladrao_R + #3, #2315  ; 12 + 2304 (traseira esquerda p/ direita)
  static ladrao_R + #4, #2314 ; 13 + 2304 (meio esquerda p/ direita)
  static ladrao_R + #5, #2313 ; 14 + 2304 (frente esquerda p/ direita)

; --- GAPS DO LADRÃO (2 FORMAS) ---
; (As suas arrays de Gaps H e V estão perfeitas!)
ladraoGaps_H : var #6 ; Forma 3x2
  static ladraoGaps_H + #0, #0
  static ladraoGaps_H + #1, #1
  static ladraoGaps_H + #2, #2
  static ladraoGaps_H + #3, #40
  static ladraoGaps_H + #4, #41
  static ladraoGaps_H + #5, #42
  
ladraoGaps_V : var #6 ; Forma 2x3
  static ladraoGaps_V + #0, #81 
  static ladraoGaps_V + #1, #41
  static ladraoGaps_V + #2, #1 
  static ladraoGaps_V + #3, #80 
  static ladraoGaps_V + #4, #40
  static ladraoGaps_V + #5, #0
halt
