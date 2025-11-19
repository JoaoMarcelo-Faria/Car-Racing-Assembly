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
    loadn r0, #level1
    call printCenario
    
    call AtualizaHUD
    
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
  

  
  loadn R0, #level1
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
; --- 4. CHECAGEM DE COLISÃO E LIMITES ---
    ; A nova posição está em r0.
    push r7
    ; Primeiro, checa os limites da tela (0 e 1200)
    loadn r2, #0
    cmp r0, r2
    jle FimCalculaPos      ; Se r0 < 0, PULA
    
    mov r4, r0
    loadn r2, #81 ; Maior offset (ladraoGaps + 5)
    add r4, r4, r2
    loadn r3, #1200
    cmp r4, r3
    jgr PopFimCalculaPos      ; Se (r0 + 42) >= 1200, PULA
    
    mov r2,r6
    ; Agora, checa a colisão com o cenário
    call CheckMoveValido    ; Esta função usa R0 (nova pos)
                            ; e retorna R7 (1=valido, 0=invalido)
    
    ; -- Verifica se o movimento padrão deu certo
    loadn r1, #1
    cmp r7, r1              
    jeq LimpaStackEMove ; Se válido, vai direto                        
    
    ; --- LÓGICA DE CORNERING (ASSISTÊNCIA DE CURVA) ---
    ; Se bateu, tentamos ajustar a posição em +/- 1 pixel para encaixar no buraco
    pop r3; R3 agora tem o antigo r7 (1 = curva e 0 = reto)
    ; Tenta Deslocar +1 (Direita/Baixo)
    loadn r2, #0
    cmp r3,r2
    jeq FimCalculaPos ; Não é curva, não faz assistência
    
    push r0 ; Salva pos original travada
    loadn r4, #1
    add r0, r0, r4 
    call CheckMoveValido ; Testa pos+1
    loadn r1, #1
    cmp r7, r1
    jeq CorneringSucesso ; Se funcionou, usa essa nova posição!
    pop r0 ; Restaura original se falhou

    ; Tenta Deslocar -1 (Esquerda/Cima)
    push r0
    loadn r4, #1
    sub r0, r0, r4
    call CheckMoveValido ; Testa pos-1
    loadn r1, #1
    cmp r7, r1
    jeq CorneringSucesso
    pop r0 ; Restaura original se falhou
    
    ; Se nada funcionou, é realmente uma parede
    jmp FimCalculaPos 
    
PopFimCalculaPos:
    pop r7 ; Limpa lixo da stack
    jmp FimCalculaPos
    
LimpaStackEMove:
    pop r4 ; Limpa a flag de curva da stack
    jmp MovimentoConfirmado
CorneringSucesso:
    ; Se chegamos aqui, o cornering achou um lugar válido.
    ; Precisamos limpar a stack do "push r0" que ficou pendente no sucesso
    ; (O pop r0 lá em cima só roda se falhar. Aqui precisamos descartar o valor antigo da stack)
    pop r4 ; Tira o valor velho da stack (joga em r4 lixo)
    
    
; -- Entrou aqui podemos verificar o que ocorreu
MovimentoConfirmado:  
    call CheckEatItems        ; <-- CHAMA A NOVA LÓGICA DE PONTOS
    
    ; --- 5. MOVIMENTAÇÃO VÁLIDA ---
    ; Se chegamos aqui, os limites e a colisão estão OK.
    ; AGORA SIM, NÓS "CONFIRMAMOS" AS MUDANÇAS
    store pos_ladrao, r0      ; Salva a nova posição
    store ladraoSprite, r5    ; Salva o novo ponteiro de sprite
    store ladraoGapsPtr, r6   ; Salva o novo ponteiro de gaps

    call apagarladrao       ; Apaga da posição antiga
    mov r0, r5                ; r0 = ladraoSprite (novo)
    mov r1, r6                ; r1 = ladraoGapsPtr (novo)
    load r2, pos_ladrao       ; r2 = pos_ladrao (nova)
    call printladrao        ; Desenha na nova posição
    


FimCalculaPos:
    ; 7. Limpa a 'tecla_atual' para que o delay não leia a mesma tecla para sempre
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


    loadn r1, #level1      ; Endereço base do cenário
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
    
    loadn r0, #2835
    cmp r5, r0
    jeq Walkable
    
    loadn r0, #1556
    cmp r5, r0
    jeq Walkable
    
    loadn r0, #789
    cmp r5, r0
    jeq Walkable

    
    
    ; ... adicione mais IDs de parede aqui se necessário ...
    
    ; Se o código chegou aqui, não é nenhuma das paredes listadas.
    ; O movimento é VÁLIDO, e R7 já está como 1.
    jmp Exit_Walkable
    
Walkable:
    loadn r7,#1
Exit_Walkable:
    pop r0
    rts
   

; ---------------------------------------------------------------------
; CheckEatItems
; Checa se o carrinho está sobre algum item coletável e o "come".
; Usa: pos_ladrao (novo), ladraoGapsPtr (novo)
; ---------------------------------------------------------------------
CheckEatItems:
    push r0 ; &level1
    push r1 ; &ladraoGapsPtr
    push r2 ; loop counter (i)
    push r3 ; max (6)
    push r4 ; pos_ladrao
    push r5 ; offset
    push r6 ; item_addr_na_tela
    push r7 ; item_ID_do_mapa
    ;r8 = variavel
    
    load r4, pos_ladrao      ; Posição ATUAL
    load r1, ladraoGapsPtr   ; Gaps ATUAIS
    loadn r0, #level1
    loadn r3, #6
    loadn r2, #0             ; i = 0
    
eat_loop:
    add r5, r1, r2           ; r5 = &gaps[i]
    loadi r5, r5             ; r5 = gaps[i]
    add r6, r4, r5           ; r6 = pos_ladrao + offset (POSIÇÃO NA TELA)    
    add r5, r0, r6           ; r8 = &level1[pos_na_tela]
    store r8, r5
    loadi r7, r5             ; r7 = ID do tile no mapa

    ; É um "piso" (45, 15, 31)? Se sim, ignore.
    loadn r5, #2835
    cmp r7, r5
    jeq Comer
    loadn r5, #1556
    cmp r7, r5
    jeq Comer
    loadn r5, #789
    cmp r7, r5
    jeq Comer
    
    jmp next_eat_check
    ; Se NÃO é piso E NÃO é parede (pois já passamos pela colisão),
    ; então é um COLETÁVEL! (como 789, 1556, 2835)
    
Comer:
    ; 1. "Coma" (apague do mapa 'level1')
    loadn r7, #31            ; Caractere de espaço vazio
    load r5, r8
    storei r5, r7
    
    
    
    ; 2. "Apague" da tela (desenhe o espaço vazio)
    outchar r7, r6
    
    ; 3. Incremente os pontos
    load r7, pontos
    inc r7
    store pontos, r7
    
    ; 4. Atualiza HUD e Checa Vitória
    call AtualizaHUD
    
    load r5, max_pontos
    cmp r7, r5
    jgr Vitoria
    
    jmp next_eat_check

Vitoria:
    ; Código de Vitória (pode chamar uma tela de fim)
    halt
    
next_eat_check:
    inc r2
    cmp r2, r3
    jne eat_loop
    
eat_loop_end:
    ;r8 = variavel
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
  
  loadn R0, #level1
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

; checa se a posicao r4 (em posObjeto) tem uma parede
Policia_checkCenario:
    push r0
    push r1
    push r2
    push r5
    push r6
    

    push r0                  ; Salva a nova_pos
    add r5, r2, r4           ; r5 = &ladraoGaps[i]
    loadi r5, r5             ; r5 = ladraoGaps[i] (ex: 0, 1, 2, 40, 41, 42)
    add r0, r0, r5           ; r0 = nova_pos + offset
    add r5, r1, r0           ; r5 = &initScre[nova_pos + offset]
    loadi r5, r5             ; r5 = ID DO TILE do cenário (ex: 31, 45, 106, etc)
    pop r0                   ; Restaura a nova_pos original


    loadn r1, #level1 ;Carrega o endereço do mapa
    add r6, r1, r4 ; R6 = Endereço base + Posição (R4)
    loadi r5,r6 ;R5 = O ID DO TILE 
    
    call IsTileWalkable ; Chama nossa função de colisão já existente
    
    ; IsTileWalkable retorna R7 (1=chão, 0=parede)
    ; Esta função precisa retornar 'ehParede' (0=chão, 1=parede)
    ; Então, apenas invertemos R7.
    
    loadn r2, #1
    cmp r7, r2
    jeq Policia_nao_parede
    
    ; É parede
    loadn r2, #1
    store ehParede, r2
    jmp Policia_check_sai
    
Policia_nao_parede:
    ; Não é parede
    loadn r2, #0
    store ehParede, r2

Policia_check_sai:
    pop r6
    pop r5
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