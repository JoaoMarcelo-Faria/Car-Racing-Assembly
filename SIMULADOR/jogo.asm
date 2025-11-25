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
static bonus + #0, #1  ; Começa com 1

steps: var #1
static steps + #0, #0  ; Contador de passos no nível

max_pontos: var #1
static max_pontos + #0, #5 ; Defina aqui quantos pontos existem no mapa para ganhar

; Strings para o HUD (Texto Estático)
; "PTS:"
str_pts: string "PTS:"
; "VIDAS:"
str_vidas: string "VIDAS:"

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

; Variavel da funcao de calculo de uma posicao no cenario
posObjeto: var #1
posCenario: var #1

rand_ptr: var #1
static rand_ptr + #0, #0

;PONTUAÇÃO
; Variavel com a quantidade de pontos
pontos: var #1
static pontos + #0, #0
fant_comidos: var #1
static fant_comidos + #0, #0


; Buffer que guardará o estado ATUAL do nível rodando
; Todos os personagens devem ler/escrever AQUI, não no 'level1' ou 'level2'
MapBuffer: var #1200

;Variaveis de nivel
nivel_atual: var #1
static nivel_atual + #0, #1     ;começa no nivel 1

;Moedas por nivel
moedas_lvl1: var #1
static moedas_lvl1 + #0, #3     ;tem 5 moedas no nivel 1

moedas_lvl2: var #1
static moedas_lvl2 + #0, #5     ;tem 4 moedas no nivel 2

moedas_lvl3: var #1
static moedas_lvl3 + #0, #7       ;tem 6 moedas no nivel 3

moedas_lvl4: var #1
static moedas_lvl4 + #0, #9


itens_coletados: var #1
static itens_coletados + #0, #0


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
;direção inicial da policia
dir_policia: var #1
static dir_ladrao + #0, #0
;posições da policia ao inicializar
pos_ant_policia: var #1
static pos_ant_policia + #0, #490
pos_policia: var #1
static pos_policia + #0, #490

;GAPS para printar a policia
policiaSprite: var #1
policiaGapsPtr : var #1  
policiaGapsPtr_ant : var #1
est_policia: var #1 ; Estado (0=Chase, 1=Frightened, 2=Eaten)

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
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7
    call inicializa_var
    
    round_game:
    ; Carrega o cenário correto baseado no nível atual
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
    loadn r0, #level2  ; <-- Você precisa ter este label
    jmp CarregaCenario
    
CarregaLevel3:
    loadn r1, #3
    cmp r0, r1
    jne CarregaLevel4
    loadn r0, #level3  ; <-- A ser criado
    jmp CarregaCenario
    
CarregaLevel4:
    loadn r1, #4  ; <-- A ser criado
    cmp r0, r1
    loadn r0, #level4  ; <-- A ser criado
    jmp CarregaCenario
    
CarregaCenario:
    ; R0 tem o endereço do level correto. Copia para a RAM!
    call CarregaMapaParaBuffer
    loadn r0,#MapBuffer
    call printCenario
    
    ; Atualiza max_pontos para o nível atual
    call GetMoedasNivelAtual
    
    call AtualizaHUD
    
    ; Reseta posições do ladrão e polícia para o novo nível
    call ResetPosicoesPorNivel
    
    ; Desenha os personagens
    load r0, ladraoSprite
    load r1, ladraoGapsPtr
    load r2, pos_ladrao
    call printladrao
    
    load r0, policiaSprite
    load r1, policiaGapsPtr
    load r2, pos_policia
    call printladrao
    
    loadn r0,#0
    loadn r2,#0

    main_inicio:    
          call delay
          inc r0
          loadn r1, #15
          mod r1, r0, r1
        jnz main_inicio
        
        
        ; Simplesmente chame CalculaPos. 
        ; Ele vai cuidar de mover E desenhar o personagem.
        call CalculaPos
        call CheckPlayerPoliceCollision
        skip_player:
          inc r2
          loadn r1, #5
          mod r1, r2, r1
        jnz skip_police
        
        
        ; Move a Polícia
      call CalculaPosPolicia
      
      ; 3. Checa se eles colidiram
      call CheckPlayerPoliceCollision ; 
      skip_police:
        jmp main_inicio
        
            
    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    halt
    ;jmp main;
    
printCenario:
  push R0
  push R1
  push R2
  push R3

  loadn R1, #0
  loadn R2, #1200

  printCenarioLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printCenarioLoop

  pop R3
  pop R2
  pop R1
  pop R0
  rts 

; funcao de delay
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
    
printladrao:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6


  loadn R3, #6 ;tamanho ladrao
  loadn R4, #0 ;incremetador

  printladraoLoop:
    add R5,R0,R4
    loadi R5, R5

    push R2
    
    add R6,R1,R4
    loadi R6, R6

    add R2, R2, R6

    outchar R5, R2

    pop R2
    
    inc R4
    cmp R3, R4
    jne printladraoLoop

  pop R6
  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts

apagarladrao:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6

  load R6, tecla_atual
  loadn R6, #255
  store tecla_atual, R6
  

  
  loadn R0, #MapBuffer
  load R1, ladraoGapsPtr_ant
  load R2, pos_ant_ladrao
  loadn R3, #6 ;tamanho ladrao
  loadn R4, #0 ;incremetador

  apagarladraoLoop:
    add R5,R1,R4
    loadi R5, R5
    
    push R2 
    
    add R2,R2,R5
    
    add R6,R0,R2
    loadi R6, R6
        
    outchar R6, R2

    pop R2
    
    inc R4
    cmp R3, R4
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
    push R0
    push R1
    ;push R2
    loadn R0, #63999
    loadn R1, #0
    lll:
        dec R0
        cmp R0, R1              
        jne lll
    ;pop R2
    pop R1
    pop R0
    rts
    
loop_ini:
    push R0
    push R1
    push R2
    loadn R0, #menu
    call printCenario
    loop_inil:
        call delay 
        load R2, tecla_atual
        loadn R1, #'x'
        cmp R1, R2              ; se digitou x, sai do loop
        jne loop_inil
    pop R2
    pop R1
    pop R0
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
    loadn r3, #1200
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
    ; Salva tudo
    store pos_ladrao, r0      
    store ladraoSprite, r5    
    store ladraoGapsPtr, r6   
    
    load r4, steps
    inc r4
    store steps, r4
    
    call CheckEatItems
    call apagarladrao
    
    mov r0, r5                
    mov r1, r6                
    load r2, pos_ladrao       
    call printladrao
    
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
    loadi r5, r5             ; r5 = ID DO TILE do cenário (ex: 31, 45, 106, etc)
    pop r0                   ; Restaura a nova_pos original
    
    ; Agora R5 tem o ID do tile que precisamos checar
    ; Chamamos uma sub-rotina para ver se ele é "andável"
    ; R7 é a flag que .isTileWalkable pode alterar
    call IsTileWalkable     
    
    loadn r6, #0
    cmp r7, r6               ; A flag R7 foi para 0?
    jeq CheckLoopEnd        ; Se sim, encontramos uma parede. Pare de checar.
    
    inc r4
    cmp r4, r3
    jne CheckLoop
    
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
    jmp GetMoedas_Fim
    
GetMoedas_Level2:
    loadn r1, #2
    cmp r0, r1
    jne GetMoedas_Level3
    load r1, moedas_lvl2
    store max_pontos, r1
    jmp GetMoedas_Fim
    
GetMoedas_Level3:
    loadn r1, #3
    cmp r0, r1
    jne GetMoedas_Level4
    load r1, moedas_lvl3
    store max_pontos, r1
    jmp GetMoedas_Fim
    
GetMoedas_Level4:
    load r1, moedas_lvl4
    store max_pontos, r1
    
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
CheckEatItems:
    push r0 ; &MapBuffer
    push r1 ; bonus / temp
    push r2 ; loop i
    push r3 ; max 6
    push r4 ; pos_ladrao / steps
    push r5 ; offset / acumulador
    push r6 ; posicao na tela
    push r7 ; ID do tile / pontos
    
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
    store r8, r5               ; Salva endereço em R8
    loadi r7, r5             ; R7 = Conteúdo (com cor)

    ; --- REMOVE A COR PARA CHECAGEM ---
    push r1
    loadn r1, #255
    and r7, r7, r1           ; R7 = ID Base
    pop r1

    ; --- CHECAGEM DE ITENS ---
    
    ; 1. DIAMANTE ('D' = 68 no ASCII/Charmap)
    loadn r5, #20
    cmp r7, r5
    jeq Comer_Diamante

    ; 2. MOEDAS
    loadn r5, #19   ; Amarelo
    cmp r7, r5
    jeq Comer_Moeda
    loadn r5, #21   ; Verde
    cmp r7, r5
    jeq Comer_Moeda
    loadn r5, #33   ; Oliva
    cmp r7, r5
    jeq Comer_Moeda
    loadn r5, #43   ; 'S'
    cmp r7, r5
    jeq Comer_Moeda
    loadn r5, #46   ; 'S'
    cmp r7, r5
    jeq Comer_Moeda
    
    jmp next_eat_check

; --- LÓGICA DO DIAMANTE ---
Comer_Diamante:
    ; Pontos = 100 * Bonus
    load r1, bonus
    loadn r5, #10
    mul r5, r5, r1    ; R5 = 10 * Bonus
    
    load r7, pontos
    add r7, r7, r5
    store pontos, r7
    
    ; Apaga o Diamante
    jmp Finaliza_Comer

; --- LÓGICA DA MOEDA ---
Comer_Moeda:
    ; 1. Pontos = 1 * Bonus
    load r1, bonus    ; R1 = Bonus Atual
    load r7, pontos
    add r7, r7, r1    ; Pontos += Bonus
    store pontos, r7
    
    ; 2. Atualiza o Bônus
    ; Fórmula: Bonus = Bonus + (Bonus * (Steps % 100))
    
    load r4, steps    ; Carrega passos
    loadn r5, #15
    mod r4, r4, r5    ; R4 = (Steps % 15)
    
    mul r4, r4, r1    ; R4 = (Steps % 15) * Bonus
    add r1, r1, r4    ; R1 = Bonus + R4
    
    store bonus, r1   ; Salva novo bônus
    
    ; (Cai para Finaliza_Comer)

Finaliza_Comer:
    ; Apaga do Buffer e da Tela
    loadn r7, #31     ; Espaço vazio
    load r5, r8
    storei r5, r7     ; Limpa RAM
    
    
    call AtualizaHUD
    
    ; Checa Vitória (Moedas do Nível)
    ; Nota: Se o diamante contar para passar de fase, mantenha isso.
    ; Se não, você pode querer separar contadores. 
    ; Assumindo que tudo conta para o limite do nível:
    ; (Cuidado: Se 'pontos' cresce muito rápido, a comparação de "moedas coletadas"
    ; deve ser feita com outra variável, não 'pontos'.
    ; Vou assumir que você quer checar se pegou todas as moedas físicas).
    
    ; *** ATENÇÃO ***: Seu sistema original comparava 'pontos' com 'max_pontos'.
    ; Como agora os pontos escalam, essa comparação vai quebrar (você ganha o jogo na primeira moeda).
    ; Vamos usar uma nova variável 'coletados_nivel' para contar QUANTOS itens pegou.
    
    load r5, itens_coletados ; <--- PRECISARÁ CRIAR ISSO
    inc r5
    store itens_coletados, r5
    
    call GetMoedasNivelAtual
    load r7, max_pontos ; (Que na verdade é max_itens)
    cmp r5, r7
    jeq VitoriaNivel
    
next_eat_check:
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
    
;Funcao de vitoria do nivel
VitoriaNivel:
    ;Passa para o próximo nível
    ; Incrementa o nível
    load r0, nivel_atual
    inc r0
    store nivel_atual, r0
    
    ; Verifica se completou todos os níveis
    loadn r1, #5  ; 4 níveis + 1
    cmp r0, r1
    jeq VitoriaFinal
    
    ; Reseta variáveis para o novo nível
    loadn r0, #0
    store pontos, r0  ; Zera pontos (ou mantenha se quiser acumular)
    
    ; Carrega as novas moedas necessárias
    call GetMoedasNivelAtual
    
    ; Sai da função para recarregar o nível
    jmp ProximoNivel
    
VitoriaFinal:
    halt  ; apenas para
    
ProximoNivel:
    ; Esta label será usada no main
    ; A execução volta para round_game
    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    jmp round_game  ; Volta para recarregar o cenário


; ---------------------------------------------------------------------
; --- SEÇÃO DE lógica  DA POLÍCIA 
; ---------------------------------------------------------------------

; "Cérebro" da Polícia. Decide o que fazer.
CalculaPosPolicia:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7
    
    ; 1. Salva estados antigos
    load r0, pos_policia
    store pos_ant_policia, r0
    load r0, policiaGapsPtr
    store policiaGapsPtr_ant, r0
    
    ; 2. Define o Target (o jogador)
    load r0, pos_ladrao
    store pos_target, r0

    ; 3. Carrega estado atual da polícia nas vars da IA
    load r0, dir_policia
    store dir_policiaant, r0
    load r0, pos_policia
    store pos_policiaant, r0
    load r0, est_policia
    store est_policiaant, r0
    
    ; 4. Chama a IA principal
    call Policia_CalculaPos

    ; 5. Recupera os resultados da IA
    load r0, est_policiaant
    store est_policia, r0
    load r1, pos_policiaant       ; r1 = nova posição
    store pos_policia, r1
    load r2, dir_policiaant       ; r2 = nova direção ('w','a','s','d')
    store dir_policia, r2

   ; 6. Seleciona opolicia Sprites/Gaps corretos para a nova direção
    loadn r3, #'a'
    cmp r2, r3
    jne Policia_checa_w
    loadn r5, #policia_L
    loadn r6, #policiaGaps_H
    jmp Policia_desenha
    
 Policia_checa_w:
    loadn r3, #'w'
    cmp r2, r3
    jne Policia_checa_s
    
    loadn r5, #policia_U
    loadn r6, #policiaGaps_V
    jmp Policia_desenha
    
Policia_checa_s:
    
    loadn r3, #'s'
    cmp r2, r3
    jne Policia_checa_d
    
    loadn r5, #policia_D
    loadn r6, #ladraoGaps_V
    jmp Policia_desenha
    
Policia_checa_d:
    loadn r5, #policia_R
    loadn r6, #policiaGaps_H
    

Policia_desenha:
    store policiaSprite, r5
    store policiaGapsPtr, r6
    
    ; 7. Chama funções de apagar/desenhar
    call apagarpolicia
    
    mov r0, r5 ; Arg 0: &policiaSprite
    mov r2, r1 ; Arg 2: pos_policia (sim, r1 = pos_fant, então r1=r2)
    mov r1, r6 ; Arg 1: &policiaGapsPtr
     
    call printladrao
    
    pop r7
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; Função genérica para apagar a polícia
apagarpolicia:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6
  
  loadn R0, #MapBuffer
  load R1, policiaGapsPtr_ant
  load R2, pos_ant_policia
  loadn R3, #6 ;tamanho
  loadn R4, #0 ;i
  
  apagarpoliciaLoop:
    add R5,R1,R4
    loadi R5, R5
    push R2 
    add R2,R2,R5
    add R6,R0,R2
    loadi R6, R6
    outchar R6, R2
    pop R2
    inc R4
    cmp R3, R4
    jne apagarpoliciaLoop

  pop R6
  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts


; ---------------------------------------------------------------------
; CheckPlayerPoliceCollision
; Checa se o ladrão colidiu com a polícia
; ---------------------------------------------------------------------
CheckPlayerPoliceCollision:
    push r0 ; pos_ladrao
    push r1 ; &ladraoGapsPtr
    push r2 ; pos_policia
    push r3 ; loop counter
    push r4 ; max loop (6)
    push r5 ; offset
    push r6 ; pos_tile_ladrao

    loadn r4, #6
    
    ; --- PARTE 1: Checa 6 tiles do LADRÃO vs. Origem da POLÍCIA ---
    load r0, pos_ladrao
    load r1, ladraoGapsPtr
    load r2, pos_policia
    loadn r3, #0 ; i = 0

Ladrao_check_loop:
    add r5, r1, r3  ; r5 = &gaps[i]
    loadi r5, r5    ; r5 = gaps[i] (offset)
    add r6, r0, r5  ; r6 = pos_ladrao + offset
    
    cmp r6, r2      ; Compara pos_tile_ladrao com pos_policia
    jeq PerdeuVida
    
    inc r3
    cmp r3, r4
    jne Ladrao_check_loop

    ; --- PARTE 2: Checa 6 tiles da POLÍCIA vs. Origem do LADRÃO ---
    load r0, pos_policia
    load r1, policiaGapsPtr
    load r2, pos_ladrao
    loadn r3, #0 ; i = 0
    
Policia_check_loop:
    add r5, r1, r3  ; r5 = &gaps[i]
    loadi r5, r5    ; r5 = gaps[i] (offset)
    add r6, r0, r5  ; r6 = pos_policia + offset
    
    cmp r6, r2      ; Compara pos_tile_policia com pos_ladrao
    jeq PerdeuVida
    
    inc r3
    cmp r3, r4
    jne Policia_check_loop

    ; Se não colidiu
    jmp Collision_end

PerdeuVida:
    ; 1. Decrementa Vidas
    load r0, vidas
    dec r0
    store vidas, r0
    
    ; 2. Atualiza o HUD para mostrar a vida perdida
    call AtualizaHUD 
    
    ; 3. Verifica se acabou (Vidas == 0)
    loadn r1, #0
    cmp r0, r1
    jeq GameOverReal

    ; 4. Se ainda tem vidas, Reinicia o Round
    call inicializa_var
    call round_game
    jmp Collision_end
    
GameOverReal:
    halt ; Para o jogo, como você pediu
    
Collision_end:
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; ---------------------------------------------------------------------
; ResetRound
; Retorna os carros para a posição inicial sem resetar pontos/mapa
; ---------------------------------------------------------------------
ResetRound:
    push r0
    push r1
    push r2
    push r3

    ; Apaga os carros das posições atuais (onde bateram)
    call apagarladrao
    call apagarpolicia

    ; Restaura Ladrão para o Início
    loadn r0, #490
    store pos_ladrao, r0
    store pos_ant_ladrao, r0
    loadn r0, #ladraoGaps_H
    store ladraoGapsPtr, r0
    store ladraoGapsPtr_ant, r0
    loadn r0, #0
    store dir_ladrao, r0
    loadn r0, #ladrao_R
    store ladraoSprite, r0

    ; Restaura Polícia para o Início
    loadn r0, #1020
    store pos_policia, r0
    store pos_ant_policia, r0
    loadn r0, #policiaGaps_H
    store policiaGapsPtr, r0
    store policiaGapsPtr_ant, r0
    loadn r0, #0
    store dir_policia, r0
    loadn r0, #policia_R
    store policiaSprite, r0

    ; Pequeno delay para o jogador perceber que morreu
    call delay
    call delay
    
    ; PENALIDADE DE MORTE: Reseta o Bônus e os Passos
    loadn r0, #1
    store bonus, r0
    loadn r0, #0
    store steps, r0
    
    ; Redesenha nas posições iniciais
    load r0, ladraoSprite
    load r1, ladraoGapsPtr
    load r2, pos_ladrao
    call printladrao
    
    load r0, policiaSprite
    load r1, policiaGapsPtr
    load r2, pos_policia
    call printladrao

    pop r3
    pop r2
    pop r1
    pop r0
    rts

; Funcao que dada a posicao, a direcao de movimentacao
; e o target de um poicial calcula sua proxima posicao
Policia_CalculaPos:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7

    loadn r5, #40 ; Largura da tela

    ; Converte Target para (x, y)
    ; r2 e r3: x e y do target
    load r4, pos_target
    
convzerte_target:
    mod r2, r4, r5
    div r3, r4, r5

converte_target_sai:
    loadn r1, #0
    store target_eh_xy, r1

    load r6, pos_policiaant ; Posição atual do fantasma

    ; --- Checa direção 'a' (Esquerda) ---
Policia_CalculaPos_a: 
    mov r4, r6
    dec r4
    store pos_policiaant_a, r4

    call Policia_checkCenario ; Checa se r4 é parede
    load r0, ehParede
    loadn r1, #0
    cmp r0, r1
    jne Eh_parede_a
    
    ; Não é parede, calcula distância
    mod r0, r4, r5
    div r1, r4, r5
    call calculaDist
    load r7, dist_dir
    store dist_a, r7
    jmp Policia_CalculaPos_w
    
Eh_parede_a:
    loadn r0, #30000
    store dist_a, r0
    
    ; --- Checa direção 'w' (Cima) ---
Policia_CalculaPos_w:
    mov r4, r6
    sub r4, r4, r5
    store pos_policiaant_w, r4

    call Policia_checkCenario
    load r0, ehParede
    loadn r1, #0
    cmp r0, r1
    jne Eh_parede_w

    mod r0, r4, r5
    div r1, r4, r5
    call calculaDist
    load r7, dist_dir
    store dist_w, r7
    jmp Policia_CalculaPos_s
    
Eh_parede_w:
    loadn r0, #30000
    store dist_w, r0
    
    ; --- Checa direção 's' (Baixo) ---
Policia_CalculaPos_s:
    mov r4, r6
    add r4, r4, r5
    store pos_policiaant_s, r4

    call Policia_checkCenario
    load r0, ehParede
    loadn r1, #0
    cmp r0, r1
    jne Eh_padrede_s

    mod r0, r4, r5
    div r1, r4, r5
    call calculaDist
    load r7, dist_dir
    store dist_s, r7
    jmp Policia_CalculaPos_d
Eh_padrede_s:
    loadn r0, #30000
    store dist_s, r0

    ; --- Checa direção 'd' (Direita) ---
Policia_CalculaPos_d:
    mov r4, r6
    inc r4
    store pos_policiaant_d, r4

    call Policia_checkCenario
    load r0, ehParede
    loadn r1, #0
    cmp r0, r1
    jne Eh_padrede_d
    
    mod r0, r4, r5
    div r1, r4, r5
    call calculaDist
    load r7, dist_dir
    store dist_d, r7
    jmp Policia_checkDir
Eh_padrede_d:
    loadn r0, #30000
    store dist_d, r0

Policia_checkDir:
    ; O fantasma nao pode inverter a direcao de movimento
    load r0, dir_policiaant
    loadn r1, #30000

    loadn r2, #'a'
    cmp r0, r2
    jne Policia_checkDir_w
    store dist_d, r1
    jmp Policia_decideDir

Policia_checkDir_w:
    loadn r2, #'w'
    cmp r0, r2
    jne  Policia_checkDir_s
    store dist_s, r1
    jmp Policia_decideDir

Policia_checkDir_s:
    loadn r2, #'s'
    cmp r0, r2
  jne Policia_checkDir_d
    store dist_w, r1
    jmp Policia_decideDir

Policia_checkDir_d:
    loadn r2, #'d'
    cmp r0, r2
    jne Policia_decideDir
    store dist_a, r1

Policia_decideDir:
    ; Decide qual é a menor distância
    loadn r0, #'a'
    store dir_policiaant, r0
    load r1, pos_policiaant_a
    store pos_policiaant, r1
    load r2, dist_a

    load r3, dist_w
    cmp r3, r2
    jgr Policia_decideDir_S
    loadn r0, #'w'
    store dir_policiaant, r0
    load r1, pos_policiaant_w
    store pos_policiaant, r1
    mov r2,r3
    
Policia_decideDir_S:
    load r3, dist_s
    cmp r3, r2
  jgr Policia_decideDir_D
    loadn r0, #'s'
    store dir_policiaant, r0
    load r1, pos_policiaant_s
    store pos_policiaant, r1
    mov r2,r3
    
Policia_decideDir_D:
    load r3, dist_d
    cmp r3, r2
  jgr PoliciaCalculaPos_sai
    loadn r0, #'d'
    store dir_policiaant, r0
    load r1, pos_policiaant_d
    store pos_policiaant,r1

PoliciaCalculaPos_sai:
    pop r7
    pop r6
  pop r5
    pop r4
    pop r3
  pop r2
    pop r1
    pop r0
  rts

; Funcao  auxiliar, calcula a distancia (quadrática) entre (r0, r1) e (r2, r3)
calculaDist:
    push r4
  push r5
    
    cmp r0, r2
    jle calculaDist_x1
    
    sub r4, r0, r2
    jmp calculaDist_x2
    
calculaDist_x1:
    sub r4, r2, r0
calculaDist_x2:
    mul r4, r4, r4
    cmp r1, r3
    jle calculaDist_y1
    
    sub r5, r1, r3
    jmp calculaDist_y2
    
calculaDist_y1:
    sub r5, r3, r1
    
calculaDist_y2:
    mul r5, r5, r5

    add r4, r4, r5
    store dist_dir, r4

    pop r5
    pop r4
    rts

; ---------------------------------------------------------------------
; Policia_checkCenario (CORRIGIDA - SEM NÚMEROS NEGATIVOS)
; Verifica se a posição R4 é válida para a polícia.
; Detecta automaticamente se o movimento é Horizontal ou Vertical.
; ---------------------------------------------------------------------
Policia_checkCenario:
    push r0
    push r1
    push r2
    push r3 ; Contador loop
    push r4 ; Posição candidata (preservar)
    push r5 ; Gap pointer
    push r6 ; Offset gap
    push r7 ; Resultado IsTileWalkable / Temp

    ; 1. Descobre a direção comparando Nova (R4) vs Atual (pos_fant)
    ; OBS: Usamos 'pos_fant' porque é a variável que a IA usa enquanto pensa.
    load r0, pos_ant_policia 
    
    ; --- LÓGICA CORRIGIDA PARA NUMEROS POSITIVOS ---
    
    ; Teste 1: Movimento para DIREITA? (Nova == Atual + 1)
    mov r1, r0
    inc r1          ; r1 = Atual + 1
    cmp r4, r1      ; Nova == (Atual + 1)?
    jeq Check_Horizontal

    ; Teste 2: Movimento para ESQUERDA? (Atual == Nova + 1)
    ; (Isso é o mesmo que Nova = Atual - 1, mas sem dar underflow!)
    mov r1, r4
    inc r1          ; r1 = Nova + 1
    cmp r0, r1      ; Atual == (Nova + 1)?
    jeq Check_Horizontal
    
    ; Se não é +1 nem -1, assumimos que é Vertical (+/- 40)
    jmp Check_Vertical

Check_Horizontal:
    loadn r5, #policiaGaps_H
    jmp Start_Check_Loop

Check_Vertical:
    loadn r5, #policiaGaps_V

Start_Check_Loop:
    loadn r1, #MapBuffer ; Lê do Buffer!
    loadn r2, #6         ; 6 partes do carro
    loadn r3, #0         ; i = 0

Loop_Check_Body:
    ; Calcula endereço do gap[i]
    add r6, r5, r3       ; &gaps[i]
    loadi r6, r6         ; offset
    
    ; Calcula posição real da parte do carro: Candidata(R4) + Offset(R6)
    add r6, r4, r6       
    
    ; Verifica limites da tela (0-1199)
    loadn r7, #0
    cmp r6, r7
    jle Eh_Parede       ; < 0
    loadn r7, #1200
    cmp r6, r7
    jgr Eh_Parede       ; >= 1200
    
    ; Pega o tile do mapa
    add r6, r1, r6       ; Endereço no MapBuffer
    loadi r7, r6         ; ID do Tile
    
    ; Chama IsTileWalkable (espera tile em R5, retorna R7)
    push r5              ; Salva o ponteiro de gaps
    mov r5, r7           ; Move ID para R5
    call IsTileWalkable
    mov r7, r7           ; (R7 já tem a resposta 0 ou 1)
    pop r5               ; Recupera ponteiro de gaps
    
    loadn r0, #0
    cmp r7, r0
    jeq Eh_Parede       ; Se um pedaço bateu, tudo bateu!
    
    inc r3
    cmp r3, r2
    jne Loop_Check_Body
    
    ; Se passou por tudo, é livre!
    loadn r0, #0
    store ehParede, r0
    jmp Fim_Check

Eh_Parede:
    loadn r0, #1
    store ehParede, r0

Fim_Check:
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
; Desenha "PTS: 000  VIDAS: 003" na linha 0 (topo da tela)
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

    ; 2. Imprime o valor dos Pontos (3 digitos) na posição 5
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

    ; Centenas
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
    
    load r0, nivel_atual
    
    loadn r1, #1
    cmp r0, r1
    jne ResetPos_Level2
    ; Level 1
    loadn r0, #490
    store pos_ladrao, r0
    store pos_ant_ladrao, r0
    loadn r0, #1020
    store pos_policia, r0
    store pos_ant_policia, r0
    jmp ResetPos_Fim
    
ResetPos_Level2:
    loadn r1, #2
    cmp r0, r1
    jne ResetPos_Level3
    ; Level 2 - Ajuste estas posições conforme seu level2
    loadn r0, #209  ; Exemplo: posição inicial no level2
    store pos_ladrao, r0
    store pos_ant_ladrao, r0
    loadn r0, #1069  ; Exemplo: posição da polícia
    store pos_policia, r0
    store pos_ant_policia, r0
    jmp ResetPos_Fim
    
ResetPos_Level3:
    loadn r1, #3
    cmp r0, r1
    jne ResetPos_Level4
    ; Level 3
    loadn r0, #250  ; Ajustar depois
    store pos_ladrao, r0
    store pos_ant_ladrao, r0
    loadn r0, #950
    store pos_policia, r0
    store pos_ant_policia, r0
    jmp ResetPos_Fim
    
ResetPos_Level4:
    ; Level 4
    loadn r0, #230
    store pos_ladrao, r0
    store pos_ant_ladrao, r0
    loadn r0, #900
    store pos_policia, r0
    store pos_ant_policia, r0
    
ResetPos_Fim:
    ; Reseta direções
    loadn r0, #0
    store dir_ladrao, r0
    store dir_policia, r0
    
    ; Reseta sprites para direita
    loadn r0, #ladrao_R
    store ladraoSprite, r0
    loadn r0, #ladraoGaps_H
    store ladraoGapsPtr, r0
    store ladraoGapsPtr_ant, r0
    
    loadn r0, #policia_R
    store policiaSprite, r0
    loadn r0, #policiaGaps_H
    store policiaGapsPtr, r0
    store policiaGapsPtr_ant, r0
    
    loadn r0, #0
    store itens_coletados, r0

    pop r1
    pop r0
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

    loadn r0, #0
    store dir_ladrao, r0
    store morte, r0
    store comecou, r0
    store pontos, r0
    store steps, r0
    
    loadn r0, #1
    store bonus, r0

    loadn r0, #490
    store pos_ladrao, r0
    store pos_ant_ladrao, r0
    
        ; Define o sprite inicial como o Horizontal
    loadn r0, #ladrao_R
    store ladraoSprite, r0
    
    loadn r0, #ladraoGaps_H
    store ladraoGapsPtr, r0 
    store ladraoGapsPtr_ant, r0
    
    
    loadn r0, #1020
    store pos_policia, r0
    store pos_ant_policia, r0
    
        ; Define o sprite inicial como o Horizontal
    loadn r0, #policia_R
    store policiaSprite, r0
    
    loadn r0, #policiaGaps_H
    store policiaGapsPtr, r0 
    store policiaGapsPtr_ant, r0

    
    pop r4
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
  static level1 + #325, #789
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
  static level1 + #372, #1373
  static level1 + #373, #1373
  static level1 + #374, #1373
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
  static level1 + #576, #789
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
  static level1 + #1060, #789
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
  static level1 + #1097, #45
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
  static level2 + #233, #15
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
  static level2 + #369, #3421
  static level2 + #370, #3421
  static level2 + #371, #3421
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
  static level2 + #409, #3967
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
  static level2 + #565, #15
  static level2 + #566, #15
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
  static level2 + #665, #3421
  static level2 + #666, #3421
  static level2 + #667, #31
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
  static level2 + #705, #2909
  static level2 + #706, #3421
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
  static level2 + #744, #31
  static level2 + #745, #3421
  static level2 + #746, #2909
  static level2 + #747, #31
  static level2 + #748, #3421
  static level2 + #749, #2909
  static level2 + #750, #15
  static level2 + #751, #15
  static level2 + #752, #15
  static level2 + #753, #15
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
  static level2 + #784, #31
  static level2 + #785, #2909
  static level2 + #786, #3421
  static level2 + #787, #3967
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
  static level2 + #811, #3421
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
  static level2 + #826, #3421
  static level2 + #827, #31
  static level2 + #828, #3421
  static level2 + #829, #2909
  static level2 + #830, #15
  static level2 + #831, #15
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
  static level2 + #852, #31
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
  static level2 + #1032, #15
  static level2 + #1033, #15
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
  static level3 + #329, #1117
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
  static level3 + #351, #1129
  static level3 + #352, #1129
  static level3 + #353, #1137
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
  static level3 + #391, #1130
  static level3 + #392, #1130
  static level3 + #393, #1138
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
  static level3 + #431, #30
  static level3 + #432, #2849
  static level3 + #433, #1117
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
  static level3 + #452, #2591
  static level3 + #453, #3967
  static level3 + #454, #3967
  static level3 + #455, #3967
  static level3 + #456, #3967
  static level3 + #457, #2591
  static level3 + #458, #2591
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
  static level3 + #469, #1055
  static level3 + #470, #1117
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
  static level3 + #489, #2847
  static level3 + #490, #2847
  static level3 + #491, #1140
  static level3 + #492, #1129
  static level3 + #493, #1137
  static level3 + #494, #2591
  static level3 + #495, #2591
  static level3 + #496, #2591
  static level3 + #497, #3967
  static level3 + #498, #3967
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
  static level3 + #510, #1117
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
  static level3 + #531, #1139
  static level3 + #532, #1130
  static level3 + #533, #1138
  static level3 + #534, #1055
  static level3 + #535, #1055
  static level3 + #536, #1055
  static level3 + #537, #1055
  static level3 + #538, #1055
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
  static level3 + #567, #2847
  static level3 + #568, #31
  static level3 + #569, #31
  static level3 + #570, #1055
  static level3 + #571, #3967
  static level3 + #572, #3967
  static level3 + #573, #3967
  static level3 + #574, #1055
  static level3 + #575, #1556
  static level3 + #576, #1055
  static level3 + #577, #1055
  static level3 + #578, #1055
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
  static level3 + #608, #1117
  static level3 + #609, #31
  static level3 + #610, #1140
  static level3 + #611, #1137
  static level3 + #612, #1055
  static level3 + #613, #1055
  static level3 + #614, #1055
  static level3 + #615, #1055
  static level3 + #616, #1055
  static level3 + #617, #1055
  static level3 + #618, #1055
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
  static level3 + #630, #1117
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
  static level3 + #650, #1131
  static level3 + #651, #1132
  static level3 + #652, #1055
  static level3 + #653, #1055
  static level3 + #654, #1055
  static level3 + #655, #3967
  static level3 + #656, #3967
  static level3 + #657, #3967
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
  static level3 + #689, #2847
  static level3 + #690, #1139
  static level3 + #691, #1138
  static level3 + #692, #3967
  static level3 + #693, #3967
  static level3 + #694, #3967
  static level3 + #695, #3967
  static level3 + #696, #3967
  static level3 + #697, #3967
  static level3 + #698, #3967
  static level3 + #699, #15
  static level3 + #700, #15
  static level3 + #701, #45
  static level3 + #702, #45
  static level3 + #703, #45
  static level3 + #704, #45
  static level3 + #705, #45
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
  static level3 + #731, #1117
  static level3 + #732, #31
  static level3 + #733, #31
  static level3 + #734, #1117
  static level3 + #735, #1055
  static level3 + #736, #1117
  static level3 + #737, #3967
  static level3 + #738, #1117
  static level3 + #739, #15
  static level3 + #740, #15
  static level3 + #741, #45
  static level3 + #742, #45
  static level3 + #743, #45
  static level3 + #744, #45
  static level3 + #745, #45
  static level3 + #746, #45
  static level3 + #747, #45
  static level3 + #748, #45
  static level3 + #749, #31
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
  static level3 + #770, #31
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
  static level3 + #782, #31
  static level3 + #783, #31
  static level3 + #784, #31
  static level3 + #785, #31
  static level3 + #786, #31
  static level3 + #787, #31
  static level3 + #788, #31
  static level3 + #789, #1117
  static level3 + #790, #1117
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
  static level3 + #810, #1117
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
  static level3 + #823, #1117
  static level3 + #824, #31
  static level3 + #825, #1117
  static level3 + #826, #31
  static level3 + #827, #1117
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
  static level3 + #850, #2593
  static level3 + #851, #2847
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
  static level3 + #865, #1117
  static level3 + #866, #1117
  static level3 + #867, #1117
  static level3 + #868, #31
  static level3 + #869, #1117
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
  static level3 + #889, #1117
  static level3 + #890, #31
  static level3 + #891, #31
  static level3 + #892, #2847
  static level3 + #893, #1117
  static level3 + #894, #31
  static level3 + #895, #1117
  static level3 + #896, #1117
  static level3 + #897, #1117
  static level3 + #898, #31
  static level3 + #899, #15
  static level3 + #900, #15
  static level3 + #901, #1117
  static level3 + #902, #1117
  static level3 + #903, #1117
  static level3 + #904, #31
  static level3 + #905, #1117
  static level3 + #906, #1117
  static level3 + #907, #1117
  static level3 + #908, #31
  static level3 + #909, #1117
  static level3 + #910, #1117
  static level3 + #911, #1117
  static level3 + #912, #1117
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
  static level3 + #930, #31
  static level3 + #931, #31
  static level3 + #932, #1117
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
  static level3 + #946, #1117
  static level3 + #947, #1117
  static level3 + #948, #31
  static level3 + #949, #1117
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
  static level3 + #964, #45
  static level3 + #965, #45
  static level3 + #966, #45
  static level3 + #967, #45
  static level3 + #968, #45
  static level3 + #969, #45
  static level3 + #970, #45
  static level3 + #971, #45
  static level3 + #972, #45
  static level3 + #973, #45
  static level3 + #974, #45
  static level3 + #975, #45
  static level3 + #976, #45
  static level3 + #977, #45
  static level3 + #978, #45
  static level3 + #979, #45
  static level3 + #980, #45
  static level3 + #981, #45
  static level3 + #982, #45
  static level3 + #983, #45
  static level3 + #984, #45
  static level3 + #985, #45
  static level3 + #986, #45
  static level3 + #987, #45
  static level3 + #988, #45
  static level3 + #989, #45
  static level3 + #990, #45
  static level3 + #991, #45
  static level3 + #992, #45
  static level3 + #993, #45
  static level3 + #994, #45
  static level3 + #995, #45
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
  static level4 + #208, #45
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
  static level4 + #289, #15
  static level4 + #290, #349
  static level4 + #291, #349
  static level4 + #292, #349
  static level4 + #293, #31
  static level4 + #294, #349
  static level4 + #295, #349
  static level4 + #296, #31
  static level4 + #297, #349
  static level4 + #298, #3967
  static level4 + #299, #349
  static level4 + #300, #31
  static level4 + #301, #349
  static level4 + #302, #349
  static level4 + #303, #31
  static level4 + #304, #349
  static level4 + #305, #3967
  static level4 + #306, #349
  static level4 + #307, #3967
  static level4 + #308, #349
  static level4 + #309, #3967
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
  static level4 + #329, #15
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
  static level4 + #340, #31
  static level4 + #341, #31
  static level4 + #342, #31
  static level4 + #343, #31
  static level4 + #344, #349
  static level4 + #345, #3967
  static level4 + #346, #349
  static level4 + #347, #3967
  static level4 + #348, #349
  static level4 + #349, #3967
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
  static level4 + #370, #349
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
  static level4 + #456, #349
  static level4 + #457, #31
  static level4 + #458, #349
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
  static level4 + #476, #31
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
  static level4 + #486, #3967
  static level4 + #487, #349
  static level4 + #488, #349
  static level4 + #489, #2835
  static level4 + #490, #31
  static level4 + #491, #31
  static level4 + #492, #31
  static level4 + #493, #3348
  static level4 + #494, #31
  static level4 + #495, #3967
  static level4 + #496, #31
  static level4 + #497, #31
  static level4 + #498, #31
  static level4 + #499, #349
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
  static level4 + #563, #15
  static level4 + #564, #15
  static level4 + #565, #15
  static level4 + #566, #3967
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
  static level4 + #783, #31
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
  static level4 + #845, #31
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
  static level4 + #885, #349
  static level4 + #886, #349
  static level4 + #887, #31
  static level4 + #888, #31
  static level4 + #889, #3348
  static level4 + #890, #31
  static level4 + #891, #3967
  static level4 + #892, #31
  static level4 + #893, #15
  static level4 + #894, #15
  static level4 + #895, #15
  static level4 + #896, #45
  static level4 + #897, #45
  static level4 + #898, #15
  static level4 + #899, #15
  static level4 + #900, #15
  static level4 + #901, #349
  static level4 + #902, #349
  static level4 + #903, #349
  static level4 + #904, #349
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
  static level4 + #928, #3967
  static level4 + #929, #3967
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
  static level4 + #982, #349
  static level4 + #983, #349
  static level4 + #984, #349
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
  static level4 + #1022, #349
  static level4 + #1023, #349
  static level4 + #1024, #349
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
  static level4 + #1043, #15
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
  static level4 + #1062, #349
  static level4 + #1063, #349
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
