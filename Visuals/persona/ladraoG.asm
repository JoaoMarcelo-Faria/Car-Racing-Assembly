ladraoGPosition : var #1

ladraoG : var #6
  static ladraoG + #0, #2307 ;       cardf
  static ladraoG + #1, #2308 ;       cardm
  static ladraoG + #2, #2309 ;       cardb
  ;38  espacos para o proximo caractere
  static ladraoG + #3, #2304 ;       carf
  static ladraoG + #4, #2305 ;       carm
  static ladraoG + #5, #2306 ;       carb

ladraoGGaps : var #6
  static ladraoGGaps + #0, #0
  static ladraoGGaps + #1, #0
  static ladraoGGaps + #2, #0
  static ladraoGGaps + #3, #37
  static ladraoGGaps + #4, #0
  static ladraoGGaps + #5, #0

printladraoG:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6

  loadn R0, #ladraoG
  loadn R1, #ladraoGGaps
  load R2, ladraoGPosition
  loadn R3, #6 ;tamanho ladraoG
  loadn R4, #0 ;incremetador

  printladraoGLoop:
    add R5,R0,R4
    loadi R5, R5

    add R6,R1,R4
    loadi R6, R6

    add R2, R2, R6

    outchar R5, R2

    inc R2
     inc R4
     cmp R3, R4
    jne printladraoGLoop

  pop R6
  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts

apagarladraoG:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5

  loadn R0, #3967
  loadn R1, #ladraoGGaps
  load R2, ladraoGPosition
  loadn R3, #6 ;tamanho ladraoG
  loadn R4, #0 ;incremetador

  apagarladraoGLoop:
    add R5,R1,R4
    loadi R5, R5

    add R2,R2,R5
    outchar R0, R2

    inc R2
     inc R4
     cmp R3, R4
    jne apagarladraoGLoop

  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts
