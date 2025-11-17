ladraoPosition : var #1

ladrao : var #7
  static ladrao + #0, #2307 ;  cardf
  static ladrao + #1, #2308 ;  cardm
  static ladrao + #2, #2309 ;  cardb
  ;38  espacos para o proximo caractere
  static ladrao + #3, #2304 ;  carf
  static ladrao + #4, #2305 ;  carm
  static ladrao + #5, #2306 ;  carb
  ;78  espacos para o proximo caractere
  static ladrao + #6, #6 ;  

ladraoGaps : var #7
  static ladraoGaps + #0, #0
  static ladraoGaps + #1, #0
  static ladraoGaps + #2, #0
  static ladraoGaps + #3, #37
  static ladraoGaps + #4, #0
  static ladraoGaps + #5, #0
  static ladraoGaps + #6, #77

printladrao:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6

  loadn R0, #ladrao
  loadn R1, #ladraoGaps
  load R2, ladraoPosition
  loadn R3, #7 ;tamanho ladrao
  loadn R4, #0 ;incremetador

  printladraoLoop:
    add R5,R0,R4
    loadi R5, R5

    add R6,R1,R4
    loadi R6, R6

    add R2, R2, R6

    outchar R5, R2

    inc R2
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

  loadn R0, #3967
  loadn R1, #ladraoGaps
  load R2, ladraoPosition
  loadn R3, #7 ;tamanho ladrao
  loadn R4, #0 ;incremetador

  apagarladraoLoop:
    add R5,R1,R4
    loadi R5, R5

    add R2,R2,R5
    outchar R0, R2

    inc R2
     inc R4
     cmp R3, R4
    jne apagarladraoLoop

  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts
