policiaPosition : var #1

policia : var #6
  static policia + #0, #3075 ;       cardf
  static policia + #1, #4 ;       cardm
  static policia + #2, #3077 ;       cardb
  ;38  espacos para o proximo caractere
  static policia + #3, #3072 ;       carf
  static policia + #4, #2305 ;       carm
  static policia + #5, #3074 ;       carb

policiaGaps : var #6
  static policiaGaps + #0, #0
  static policiaGaps + #1, #0
  static policiaGaps + #2, #0
  static policiaGaps + #3, #37
  static policiaGaps + #4, #0
  static policiaGaps + #5, #0

printpolicia:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5
  push R6

  loadn R0, #policia
  loadn R1, #policiaGaps
  load R2, policiaPosition
  loadn R3, #6 ;tamanho policia
  loadn R4, #0 ;incremetador

  printpoliciaLoop:
    add R5,R0,R4
    loadi R5, R5

    add R6,R1,R4
    loadi R6, R6

    add R2, R2, R6

    outchar R5, R2

    inc R2
     inc R4
     cmp R3, R4
    jne printpoliciaLoop

  pop R6
  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts

apagarpolicia:
  push R0
  push R1
  push R2
  push R3
  push R4
  push R5

  loadn R0, #3967
  loadn R1, #policiaGaps
  load R2, policiaPosition
  loadn R3, #6 ;tamanho policia
  loadn R4, #0 ;incremetador

  apagarpoliciaLoop:
    add R5,R1,R4
    loadi R5, R5

    add R2,R2,R5
    outchar R0, R2

    inc R2
     inc R4
     cmp R3, R4
    jne apagarpoliciaLoop

  pop R5
  pop R4
  pop R3
  pop R2
  pop R1
  pop R0
  rts
