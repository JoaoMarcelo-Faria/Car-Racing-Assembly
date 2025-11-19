ladraoPPosition : var #1

ladraoP : var #1
  static ladraoP + #0, #2326 ;       leftcar

ladraoPGaps : var #1
  static ladraoPGaps + #0, #0

printladraoP:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6

  loadn R0, #ladraoP
  loadn R1, #ladraoPGaps
  load R2, ladraoPPosition
  loadn R3, #1 ;tamanho ladraoP
  loadn R4, #0 ;incremetador

  printladraoPLoop:
    add R5,R0,R4
    loadi R5, R5

    add R6,R1,R4
    loadi R6, R6

    add R2, R2, R6

    outchar R5, R2

    inc R2
     inc R4
     cmp R3, R4
    jne printladraoPLoop

  pop R6
  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts

apagarladraoP:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5

  loadn R0, #3967
  loadn R1, #ladraoPGaps
  load R2, ladraoPPosition
  loadn R3, #1 ;tamanho ladraoP
  loadn R4, #0 ;incremetador

  apagarladraoPLoop:
    add R5,R1,R4
    loadi R5, R5

    add R2,R2,R5
    outchar R0, R2

    inc R2
     inc R4
     cmp R3, R4
    jne apagarladraoPLoop

  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts
