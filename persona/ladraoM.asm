ladraoMPosition : var #1

ladraoM : var #2
  static ladraoM + #0, #2327 ;       flcar
  static ladraoM + #1, #2328 ;       blcar

ladraoMGaps : var #2
  static ladraoMGaps + #0, #0
  static ladraoMGaps + #1, #0

printladraoM:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6

  loadn R0, #ladraoM
  loadn R1, #ladraoMGaps
  load R2, ladraoMPosition
  loadn R3, #2 ;tamanho ladraoM
  loadn R4, #0 ;incremetador

  printladraoMLoop:
    add R5,R0,R4
    loadi R5, R5

    add R6,R1,R4
    loadi R6, R6

    add R2, R2, R6

    outchar R5, R2

    inc R2
     inc R4
     cmp R3, R4
    jne printladraoMLoop

  pop R6
  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts

apagarladraoM:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5

  loadn R0, #3967
  loadn R1, #ladraoMGaps
  load R2, ladraoMPosition
  loadn R3, #2 ;tamanho ladraoM
  loadn R4, #0 ;incremetador

  apagarladraoMLoop:
    add R5,R1,R4
    loadi R5, R5

    add R2,R2,R5
    outchar R0, R2

    inc R2
     inc R4
     cmp R3, R4
    jne apagarladraoMLoop

  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts
