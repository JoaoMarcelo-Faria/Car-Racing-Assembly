call menu
jmp main

; Variáveis

Point: var #1 			; Pontos
vidas: var #1 			; Vidas

posZen1: var #1		   ; primeira parte
posZen2: var #1 	   ; segunda parte
flshotZen: var #1      ; flag para quando Zenyatta atirou
posshotZen: var #1     ; Posição shot Zen (armazena a coordenada da esqueda, na hora de imprimir é somado 1 para imprimir o da direita)

posEnemy1: var #1 		; primeira parte
posEnemy2: var #1 		; segunda parte
flshotEnemy: var #1     ; flag para o tiro do inimigo
posshotEnemy: var #1 	; Posição shot Zen (armazena a coordenada da esqueda, na hora de imprimir é somado 1 para imprimir o da direita)

IncRand: var #1			; Incremento para circular na Tabela de nr. Randomicos
Rand : var #50			; Tabela de nr. Randomicos entre 0 - 1. Para movimentação do Enemy (0 == esq && 1 == dir).
	static Rand + #0, #1
	static Rand + #1, #1
	static Rand + #2, #0
	static Rand + #3, #1
	static Rand + #4, #1
	static Rand + #5, #1
	static Rand + #6, #0
	static Rand + #7, #1
	static Rand + #8, #0
	static Rand + #9, #0
	static Rand + #10, #1
	static Rand + #11, #0
	static Rand + #12, #0
	static Rand + #13, #1
	static Rand + #14, #0
	static Rand + #15, #0
	static Rand + #16, #1
	static Rand + #17, #0
	static Rand + #18, #0
	static Rand + #19, #1
	static Rand + #20, #1
	static Rand + #20, #1
	static Rand + #21, #0
	static Rand + #22, #1
	static Rand + #23, #1
	static Rand + #24, #0
	static Rand + #25, #0
	static Rand + #26, #1
	static Rand + #27, #0
	static Rand + #28, #0
	static Rand + #29, #1
	static Rand + #30, #0
	static Rand + #31, #0
	static Rand + #32, #0
	static Rand + #33, #1
	static Rand + #34, #0
	static Rand + #35, #1
	static Rand + #36, #1
	static Rand + #37, #1
	static Rand + #38, #0
	static Rand + #39, #0
	static Rand + #40, #1
	static Rand + #41, #0
	static Rand + #42, #0
	static Rand + #43, #0
	static Rand + #44, #1
	static Rand + #45, #1
	static Rand + #46, #0
	static Rand + #47, #1
	static Rand + #48, #1
	static Rand + #49, #0

menu:
	push r1
	push r2

	loadn r1, #tela0Linha0 ; Endereco onde comeca a primeira linha da tela
	loadn r2, #0  		   ; Cor branca
	call printTela
	
	loadn r2, #13  		   ; r2 = 13 = ENTER
	; Enquanto enter não for pressionado le a tecla
	lerTecla:
	inchar r1
	cmp r1, r2
	jne lerTecla 			; if (r1 != ENTER) lerTecla

	call clearTela  		; clear a tela e volta pra main

	pop r2
	pop r1

	rts



main:
 	call clearTela   		; Limpa a tela

	loadn r0, #3 			
	store vidas, r0 		; Quantidade de vidas

	loadn r0, #0
	store Point, r0 		; Zera os pontos 

	loadn r0, #1059			; Posição Zen1
	store posZen1, r0
	loadn r0, #1099			; Posição Zen2
	store posZen2, r0
	loadn r0, #0
	store flshotZen, r0 	; Zera fl de shot da Zen

	loadn r0, #19 			; Posição Enemy1
	store posEnemy1, r0
	loadn r0, #59
	store posEnemy2, r0 	; Posição Enemy2
	loadn r0, #0
	store flshotEnemy, r0   ; Zera fl de shot do Enemy
	
	loadn r0, #0 			; Contador para os mods = 0
	loadn r2, #0 			; Para verificar se r0 % x == 0

	call printHud 		    ; printa as palavras Point: e VIDAS: 

	jmp loop 				; vai para o loop



loop:
	; Os mods servem para executar as ações somente nos ciclos em que o contador é múltiplo de algum número.
	; Se r0 % 7 == 0
	; movimentação da Zen
	loadn r1, #7
	mod r1, r0, r1
	cmp r1, r2
	ceq Zen
	
	; Se r0 % 2 == 0
	; shot da Zen
	loadn r1, #2
	mod r1, r0, r1
	cmp r1, r2
	ceq shotZen

	; Se r0 % 25 == 0
	; movimentação do Enemy
	loadn r1, #25
	mod r1, r0, r1
	cmp r1, r2
	ceq Enemy

	; Se r0 % 250 == 0
	; frequência de shot do Enemy 
	loadn r1, #250
	mod r1, r0, r1
	cmp r1, r2
	ceq Enemyshot

	; Se r0 % 3 == 0
	; shot do Enemy
	loadn r1, #3
	mod r1, r0, r1
	cmp r1, r2
	ceq shotEnemy

	call comparaPosicaoshotZen		; compara a posição do shot da Zen com o Enemy

	call printValoresHud 			; print os valores dos pontos e das vidas

	push r0 			; protege r0
	push r1 			; protege r1
	loadn r0, #0
	load r1, vidas
	cmp r0, r1
	jeq endscreen 		; if (vidas == 0) chama a funcao de imprimir o fim de jogo
	pop r1 				; protege r1
	pop r0 				; protege r0
	
	call Delay 				; Delay
	inc r0					; Incrementa contador dos mods - r0++
	jmp loop


; IMPRIMIR O HUD DO JOGO (Point E VIDA)
printHud:
	push r0
	push r1

	loadn r0, #1160  	 	; posição para começar imprimir
	loadn r1, #StringHud 	; endereço da String
	call printString 		    ; print

	pop r1
	pop r0

	rts

; printa OS VALORES DE Point E VIDA
printValoresHud:
	push r0
	push r1
	push r2
	push r3
	push r4

	; printa as vidas
	load r0, vidas 	 	; r0 = vidas
	loadn r1, #48 		
	add r0, r0, r1 		; conversao pra ascii
	loadn r1, #1198  	; lugar da tela para imprimir
	outchar r0, r1 		; print

	; printa os pontos
	loadn r1, #1168
	load r0, Point
	loadn r2, #100
	div r3, r0, r2
	loadn r4, #48
	add r3, r3, r4
	outchar r3, r1
	sub r3, r3, r4                ;rotina para impressao dos pontos, posicao que ficarão e as operacoes
	mul r3, r3, r2
	sub r0, r0, r3

	inc r1
	loadn r2, #10
	div r3, r0, r2
	loadn r4, #48     ; conversao pra ascii
	add r3, r3, r4
	outchar r3, r1
	sub r3, r3, r4
	mul r3, r3, r2
	sub r0, r0, r3

	inc r1
	add r0, r0, r4
	outchar r0, r1

	pop r4
	pop r3
	pop r2
	pop r1
	pop r0

	rts

; COLISAO shot/Enemy
comparaPosicaoshotZen:
	push r0 
	push r1 
	
	load r0, posshotZen	    ; pos shot 1 (esquerda)
	load r1, posEnemy1		; pos Enemy 1 (esquerda)
	cmp r0, r1 				; compara shot 1 com Enemy 1
	ceq somaPonto
	
	inc r1 					; pos Enemy 2 (direita)
	
	cmp r0, r1 				; compara shot 1 com Enemy 2
	ceq somaPonto
	
	inc r0					; pos shot 2 (direita)
	
	cmp r0, r1 				; compara shot2 com Enemy 2
	ceq somaPonto
	
	dec r1					; pos Enemy 1 (esquerda)
	
	cmp r0, r1 				; compara shot2 com Enemy 1
	ceq somaPonto
	
	pop r1 
	pop r0
	
	rts
	
somaPonto:
	push r0 
	push r1 
	
	load r0, Point			; pega o valor da Point na memória
	
	inc r0 					; incrementa 1
	store Point, r0 		; armazena de volta na memória
	
	loadn r0, #0			; reseta a posição do shot da Zen
	store posshotZen, r0 	; evita que fique somando infinitamente
	
	pop r1 
	pop r0 
	
	rts

; DECREMENTA VIDA
decVidas:
	push r0

	load r0, vidas 		; seta r0 como vidas
	dec r0 				; decrementa o valor da vida caso a Zen receba "dano"
	store vidas, r0 	; armazena vidas

	pop r0

	rts

; FUNCAO Zen (desenha, clear, compara, etc)
Zen:
	call ZenDesenhar
	call ZenMover
	
	rts

ZenDesenhar:
	; Zen #$
	;     %&

	push r0
	push r1

	loadn r0, #'#'  	; r0 = caractere Zen superior esquerda (#)
	load r1, posZen1	; r1 = posição Zen superior esquerda
	outchar r0, r1		; desenha parte superior esquerda da Zen

	inc r0              ; incrementa o char do r0 ($)
	inc r1				; incrementa r1 para ir para a segunda parte de cima da Zen e desenha-la
	outchar r0, r1		; desenha parte superior direita da Zen

	inc r0   	        ; incrementa o char do r0 (%)
	load r1, posZen2	; incrementa r1 e vai para a parte de baixo da Zen
	outchar r0, r1		; desenha parte inferior esquerda da Zen

	inc r0              ; incrementa o char do r0 (&)
	inc r1				; incrementa r1
	outchar r0, r1		; desenha parte inferior direita da Zen

	pop r1
	pop r0

	rts

Zenclear:
	push r0
	push r1
	push r2
	
	loadn r0, #' '			; r0 = ' '
	load r1, posZen1		; r1 = posição Zen1
	load r2, posZen2		; r2 = posição Zen2

	outchar r0, r1			; print ' ' na primeira parte do zen
	outchar r0, r2			; print ' ' na segunda parte do zen

	inc r1					; r1++ (posição Zen3)
	inc r2					; r2++ (posição Zen4)

	outchar r0, r1			; print ' ' na terceira parte do zen
	outchar r0, r2			; print ' ' na quarta parte do zen

	pop r2
	pop r1
	pop r0

	rts

ZenMover:
	push r0
	push r1
	push r2
	push r3

	inchar r0			; Le a tecla digitada
	
	loadn r1, #'a'		; Se a tecla digitada for a, move pra esquerda (NAO PODE SER EM CAPS!!!!)
	cmp r0, r1
	ceq	ZenMoveEsq

	loadn r1, #'d' 		; Se a tecla digitada for d, move pra direita (NAO PODE SER EM CAPS!!!!)
	cmp r0, r1
	ceq ZenMoveDir

	loadn r1, #' '
	load r2, flshotZen
	loadn r3, #1
	cmp r2, r3
	jeq Zenshot_Stop 	    ; Se a fl de shot já está em 1 pula
	cmp r0, r1 				; Se SPACE foi pressionado e a fl de shot está em 0, chama Zenshot
	ceq Zenshot
	Zenshot_Stop:

	pop r3
	pop r2
	pop r1
	pop r0

	rts

ZenMoveEsq:
	push r0
	push r1

	; Caso em que a Zen está na borda
	load r0, posZen1
	loadn r1, #1041
	cmp r0, r1
	jle ZenMoveEsq_Stop	; if (posZen1 < 1041) não move

	call Zenclear			; clear a Zen

	; Decrementa a posição da Zen
	load r0, posZen1
	load r1, posZen2
	dec r0
	dec r1
	store posZen1, r0
	store posZen2, r1

	call ZenDesenhar		; Desenha a Zen na nova coordenada

	ZenMoveEsq_Stop:		; Label para não mover a Zen

	pop r1
	pop r0

	rts

ZenMoveDir:
	push r0
	push r1

	; Caso em que a Zen está na borda
	load r0, posZen1
	loadn r1, #1077
	cmp r0, r1
	jgr ZenMoveDir_Stop 	; if (posZen1 > 1077) não move

	call Zenclear			; clear a Zen

	; Incrementa a posição da Zen
	load r0, posZen1
	load r1, posZen2
	inc r0
	inc r1
	store posZen1, r0
	store posZen2, r1

	call ZenDesenhar		; Desenha a Zen na nova coordenada

	ZenMoveDir_Stop:		; Label para não mover a Zen

	pop r1
	pop r0

	rts

; FUNCAO DE shot PARA o Zen
Zenshot:
	push r0

	loadn r0, #1
	store flshotZen, r0		; flshotZen = 1
	load r0, posZen1
	store posshotZen, r0       ; posshotZen = posZen1

	pop r0
	
	rts
	
shotZen:
	push r0
	push r1

	loadn r0, #1
	load r1, flshotZen
	cmp r0, r1
	ceq shotZenMover 			; Se flshotZen == 1 chama shotZenMover

	pop r1
	pop r0

	rts

shotZenMover:
	push r0
	push r1
	push r2

	load r0, posshotZen		; r0 = posshotZen
	call shotZenclear 		; clear shot
	loadn r2, #40 				; move a posição do shot uma linha pra cima
	sub r0, r0, r2

	loadn r1, #40
	cmp r0, r1
	cle shotZenPassouPrimeiraLinha ; if (posshot < 40) passouPrimeiraLinha


	store posshotZen, r0  			; armazena nova posição na variavel
	call shotZenDesenhar 			; desenha o shot

	pop r2
	pop r1
	pop r0

	rts

shotZenPassouPrimeiraLinha:
	push r0

	; flshotZen = 0
	loadn r0, #0
	store flshotZen, r0

	pop r0

	rts

shotZenDesenhar:
	push r1 
	push r2 
	
	load r1, flshotZen
	loadn r2, #0
	cmp r1, r2
	jeq shotZenDesenhar_Stop 	; se (flshot == 0) ele Stopa

	load r1, posshotZen
	loadn r2, #'('
	outchar r2, r1 				; Desenha '(' na posicao do shot da Zen (esquerda)
	
	inc r1
	loadn r2, #')'					
	outchar r2, r1 				; Desenha ')' na posicao mais 1 no caso direita
	
	shotZenDesenhar_Stop:
	pop r2
	pop r1 
	
	rts

shotZenclear:
	push r0
	push r1
	push r2

	loadn r0, #' '
	load r1, posshotZen

	; if (posshot == posZen) Stop  
	load r2, posZen1
	cmp r1, r2
	jeq shotZenclear_Stop

	outchar r0, r1  		; Desenha ' ' na posshotZen
	inc r1
	outchar r0, r1 			; Desenha ' ' na posshotZen + 1

	shotZenclear_Stop:

	pop r2
	pop r1
	pop r0

	rts

; ENEMY
Enemy:
	call EnemyDesenhar
	call EnemyMover

	rts

EnemyDesenhar:

	push r0
	push r1

	loadn r0, #0
	load r1, posEnemy1
	outchar	r0, r1

	inc r0
	inc r1
	outchar r0, r1

	inc r0
	load r1, posEnemy2
	outchar r0, r1

	inc r0
	inc r1
	outchar r0, r1

	pop r1
	pop r0

	rts

Enemyclear:
	push r0
	push r1

	loadn r0, #' '
	load r1, posEnemy1
	outchar r0, r1

	inc r1
	outchar r0, r1

	load r1, posEnemy2
	outchar r0, r1

	inc r1
	outchar r0, r1

	pop r1
	pop r0

	rts

EnemyMover:
	push r0
	push r1
	push r2

	loadn r0, #Rand 		; ponteiro para a tabela Rand (movimento do enemy!)
	load r1, IncRand 		; incremento da tabela Rand
	add r0, r0, r1 			; soma incremento no ponteiro

	loadi r2, r0 			; r2 = rand[r0]

	inc r1 					

	loadn r0, #50
	cmp r1, r0
	jne EnemyMover_StopResetRand ; if (r1 != 50) não reseta a tabela
	loadn r1, #0 				   ; else reseta -> r1 = 0
	EnemyMover_StopResetRand:
	store IncRand, r1 			   ; armazena novo IncRand

	loadn r0, #0 				   ; if (r2 == 0) --> enemy go to esquerda	
	cmp r0, r2
	ceq EnemyMoverEsq

	loadn r0, #1 				   ; if (r2 == 1) --> enemy go to direita
	cmp r0, r2
	ceq EnemyMoverDir

	pop r2
	pop r1
	pop r0

	rts

EnemyMoverEsq:
	push r0
	push r1

	load r0, posEnemy1
	loadn r1, #1
	cmp r0, r1
	jle EnemyMoverEsq_Stop  ; impede de mover caso esteja no limite esquerdo

	call Enemyclear 		; clear o Enemy

	; Decrementa pos
	load r0, posEnemy1
	load r1, posEnemy2
	dec r0
	dec r1
	store posEnemy1, r0
	store posEnemy2, r1

	call EnemyDesenhar

	EnemyMoverEsq_Stop:

	pop r1
	pop r0

	rts

EnemyMoverDir:
	push r0
	push r1

	load r0, posEnemy1 		; impede de mover alem da borda
	loadn r1, #37
	cmp r0, r1
	jgr EnemyMoverDir_Stop

	call Enemyclear 		; clear o Enemy

	; Incrementa pos
	load r0, posEnemy1
	load r1, posEnemy2
	inc r0
	inc r1
	store posEnemy1, r0
	store posEnemy2, r1

	call EnemyDesenhar

	EnemyMoverDir_Stop:

	pop r1
	pop r0

	rts

;shot Enemy
Enemyshot:
	push r0
	push r1

	loadn r0, #1
	load r1, flshotEnemy
	cmp r0, r1
	jeq Enemyshot_Stop  		; se flshotEnemy já está em 1, pula, para não resetar indevidamente posshotEnemy

	loadn r0, #1
	store flshotEnemy, r0		; flshotEnemy = 1
	load r0, posEnemy2
	store posshotEnemy, r0       ; posshotEnemy = posEnemy2

	Enemyshot_Stop:

	pop r1
	pop r0
	
	rts
	
shotEnemy:
	push r0
	push r1

	loadn r0, #1
	load r1, flshotEnemy
	cmp r0, r1
	ceq shotEnemyMove 			; Se flshotEnemy == 1 chama shotEnemyMove

	pop r1
	pop r0

	rts

shotEnemyMove:
	push r0
	push r1
	push r2

	load r0, posshotEnemy		; r0 = posshotEnemy
	call shotEnemyclear 		; clear shot
	loadn r2, #40 				; move a posição do shot uma linha pra baixo
	add r0, r0, r2

	loadn r1, #1080
	cmp r0, r1
	cgr shotEnemyFim ; if (posshot > 1080) Fim

	load r1, posZen1
	cmp r0, r1
	ceq decVidas
	inc r1
	cmp r0, r1
	ceq decVidas
	dec r1
	dec r1
	cmp r0, r1
	ceq decVidas

	store posshotEnemy, r0  			; armazena nova posição na variavel
	call shotEnemyDesenhar 			 	; desenha o shot

	pop r2
	pop r1
	pop r0

	rts

shotEnemyFim:
	push r0

	; flshotEnemy = 0
	loadn r0, #0
	store flshotEnemy, r0

	pop r0

	rts

shotEnemyDesenhar:
	push r1 
	push r2 
	
	load r1, flshotEnemy
	loadn r2, #0
	cmp r1, r2
	jeq shotEnemyDesenhar_Stop 	; if (flshotEnemy == 0) sai

	load r1, posshotEnemy
	loadn r2, #4
	outchar r2, r1 				; printa a primeira parte do tira em posshotEnemy
	
	inc r2
	inc r1 						
	outchar r2, r1 				; printa a segunda parte do tira em posshotEnemy +1
	
	shotEnemyDesenhar_Stop:
	pop r2
	pop r1 
	
	rts

shotEnemyclear:
	push r0
	push r1
	push r2

	loadn r0, #' '
	load r1, posshotEnemy

	; if (posshotAlein == posEnemy2) reinicia o ciclo flag = 0 
	load r2, posEnemy2
	cmp r1, r2
	jeq shotEnemyclear_Stop

	outchar r0, r1  		; coloca ' ' na posshotEnemy
	inc r1
	outchar r0, r1 			; coloca ' ' na posshotEnemy + 1

	shotEnemyclear_Stop:

	pop r2
	pop r1
	pop r0

	rts

endscreen:
	loadn r0, #0 					; Posição do começo da tela
	loadn r1, #endscreenLinha0 		; Endereço da tela na memória
	call printTela 				    ; chama print tela

	;centena
	loadn r1, #582  		; Posição para imprimir os pontos
	load r0, Point 	        ; r0 = Point
	loadn r2, #100 			; r2 = 100
	div r3, r0, r2 			; r3 = r0 / r2    ->   pega o dígito da centena
	loadn r4, #48 			; r4 = 48
	add r3, r3, r4 			; r3 += r4  ->  converssao para ascii (numero -> ascii)
	outchar r3, r1 			; print a centena
	sub r3, r3, r4 			; r3 -= r2  ->  ascii -> numero
	mul r3, r3, r2 			; r3 *= r2  ->  multiplica o dígita da centena por 100
	sub r0, r0, r3 			; r0 -= r3  ->  remove as centenas

	; DEZENA 
	inc r1
	loadn r2, #10 
	div r3, r0, r2 
	loadn r4, #48
	add r3, r3, r4
	outchar r3, r1
	sub r3, r3, r4
	mul r3, r3, r2
	sub r0, r0, r3

	; 
	inc r1
	add r0, r0, r4
	outchar r0, r1

	endscreenLerCaractere:
	inchar r0 			; le tecla

	loadn r1, #13 		; r1 = 13 = ENTER
	cmp r0,r1
	jeq main 			; se ENTER foi pressionado, quer jogar denovo, então pula pra main
	
	loadn r1, #' ' 		; r1 = SPACE
	cmp r0, r1
	jeq fim  			; se SPACE foi pressionado, quer sair, então pula pro fim

	jmp endscreenLerCaractere  ; se nenhuma das teclas de interesse foi pressionada, volta pro endscreenLerCaractere


;print TELA

printTela: 	
	;  r1 = endereco da primeira linha
	;  r2 = cor desejada ao cenario
	;protecao de registradores na stack
	push r0	
	push r1	
	push r2	
	push r3
	push r4	
	push r5	
	
	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Maximo da tela
	
   printTela_Loop:
		call printString
		add r0, r0, r3  	; incrementa posicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!)
		cmp r0, r5			; Compara r0 com 1200
		jne printTela_Loop	; while r0 < 1200

	pop r5	
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts			

;Impressao de String

printString:	
	;r0 = Posicao da tela que o primeiro caractere da mensagem sera impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.
	;protecao de registradores no stack
	push r0	
	push r1	
	push r2	
	push r3	
	push r4	
	
	loadn r3, #'\0'	; condicao de saida

   printString_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (character == \0) ele sai
		jeq printString_Sai
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; print o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp printString_Loop
	
   printString_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;Screen clear

clearTela:
	push r0
	push r1
	
	loadn r0, #1200		; faz com que todas as coisa na tela sejam preenchidas com "espaço"
	loadn r1, #' '		
	
	   clearTela_Loop:	
		dec r0
		outchar r1, r0
		jnz clearTela_Loop
 
	pop r1
	pop r0
	rts	

;DELAY		

Delay:
						;protecao dos registtradores da main
	Push R0
	Push R1
	
	Loadn R1, #50  
   Delay_back2:				;dois loops de decremento
	Loadn R0, #3000	
   Delay_back: 
	Dec R0					
	JNZ Delay_back
	Dec R1
	JNZ Delay_back2
	
	Pop R1
	Pop R0
	
	RTS							;return


; SCREENS
;	Menu
tela0Linha0  : String "                                        "
tela0Linha1  : String "                                        "
tela0Linha2  : String "                                        "
tela0Linha3  : String "          _____    _             _      "
tela0Linha4  : String "         / ___ {  | |           | |     "
tela0Linha5  : String "        / /   { {  | |   ___   | |      "
tela0Linha6  : String "       | |     | | | |  / _ {  | |      "
tela0Linha7  : String "       | |     | |  | || | | || |       "
tela0Linha8  : String "       | |     | |  | || | | || |       "
tela0Linha9  : String "        { {___/ /   | || | | || |       "
tela0Linha10 : String "         {_____/     |__|   |__|        "
tela0Linha11 : String "                                        "
tela0Linha12 : String "         OverWatch Space Edition        "
tela0Linha13 : String "                                        "
tela0Linha14 : String "                                        "
tela0Linha15 : String "                                        "
tela0Linha16 : String "                                        "
tela0Linha17 : String "         By: Guto, Tanus e Pablo        "
tela0Linha18 : String "                                        "
tela0Linha19 : String "                 BSI 022                "
tela0Linha20 : String "                                        "
tela0Linha21 : String "                                        "
tela0Linha22 : String "                                        "
tela0Linha23 : String "                                        "
tela0Linha24 : String "                                        "
tela0Linha25 : String "                                        "
tela0Linha26 : String "   Aperte (ENTER) para comecar o jogo   "
tela0Linha27 : String "                                        "
tela0Linha28 : String "                                        "
tela0Linha29 : String "                                        "

; FIM DE JOGO
endscreenLinha0  : String "                                        "
endscreenLinha1  : String "                                        "
endscreenLinha2  : String "                                        "
endscreenLinha3  : String "                                        "
endscreenLinha4  : String "                                        "
endscreenLinha5  : String "                                        "
endscreenLinha6  : String "                                        "
endscreenLinha7  : String "                                        "
endscreenLinha8  : String "          F I M  D E  J O G O           "
endscreenLinha9  : String "                                        "
endscreenLinha10 : String "   O Bastion infelizmente ganhou ;-;    "
endscreenLinha11 : String "                                        "
endscreenLinha12 : String "                                        "
endscreenLinha13 : String "                                        "
endscreenLinha14 : String "            SEU Point:                  "
endscreenLinha15 : String "                                        "
endscreenLinha16 : String "                                        "
endscreenLinha17 : String "                                        "
endscreenLinha18 : String "                                        "
endscreenLinha19 : String "     Deseja jogar novamente? (ENTER)    "
endscreenLinha20 : String "                                        "
endscreenLinha21 : String "        Tecle (SPACE) para sair         "
endscreenLinha22 : String "                                        "
endscreenLinha23 : String "                                        "
endscreenLinha24 : String "                                        "
endscreenLinha25 : String "                                        "
endscreenLinha26 : String "                                        "
endscreenLinha27 : String "                                        "
endscreenLinha28 : String "                                        "
endscreenLinha29 : String "                                        "

; HUD
StringHud : String " Point:                         VIDAS:   "

fim: