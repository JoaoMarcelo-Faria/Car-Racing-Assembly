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


;PONTUAÇÃO
; Variavel com a quantidade de pontos
pontos: var #1
static pontos + #0, #0
fant_comidos: var #1
static fant_comidos + #0, #0

; LADRAO O PERSONAGEM PRINCIPAL

; Variaveis de movimentacao Ladrao
dir_ladrao: var #1
static dir_ladrao + #0, #0
pos_ant_ladrao: var #1
static pos_ant_ladrao + #0, #490
pos_ladrao: var #1
static pos_ladrao + #0, #490

;posicao incial declaração e atribuição  
;ladraoPosition : var #1
;static ladraoPosition + #0, #490

; Sprite Horizontal (Esquerda/Direita)
; (Esta é a sua array 'ladrao' original)
ladrao_H : var #6
  static ladrao_H + #0, #2307 ; cardf (Frente-Topo)
  static ladrao_H + #1, #2308 ; cardm (Meio-Topo)
  static ladrao_H + #2, #2309 ; cardb (Trás-Topo)
  static ladrao_H + #3, #2304 ; carf  (Frente-Baixo)
  static ladrao_H + #4, #2305 ; carm  (Meio-Baixo)
  static ladrao_H + #5, #2306 ; carb  (Trás-Baixo)

; Sprite Vertical (Cima/Baixo)
; (Reorganiza os 6 mesmos IDs para parecer vertical)
ladrao_V : var #6
  static ladrao_V + #0, #2310 ; atrasdireita
  static ladrao_V + #1, #2311 ; meiodireita
  static ladrao_V + #2, #2312 ; frentedireita
  static ladrao_V + #3, #2320 ; atrasesquerda
  static ladrao_V + #4, #2321 ; meioesquerda
  static ladrao_V + #5, #2322 ; frenteesquerda
  
; Gaps para o sprite Horizontal 3x2
ladraoGaps_H : var #6
  static ladraoGaps_H + #0, #0  ; Topo-Esquerda
  static ladraoGaps_H + #1, #1  ; Topo-Meio
  static ladraoGaps_H + #2, #2  ; Topo-Direita
  static ladraoGaps_H + #3, #40 ; Baixo-Esquerda
  static ladraoGaps_H + #4, #41 ; Baixo-Meio
  static ladraoGaps_H + #5, #42 ; Baixo-Direita
  
; Gaps para o sprite Vertical 2x3 (para bater com a sua ladrao_V)
ladraoGaps_V : var #6
  static ladraoGaps_V + #0, #81  ; atrasdireita (Linha 0, Col 1)
  static ladraoGaps_V + #1, #41 ; meiodireita  (Linha 1, Col 1)
  static ladraoGaps_V + #2, #1 ; frentedireita(Linha 2, Col 1)
  static ladraoGaps_V + #3, #80  ; atrasesquerda (Linha 0, Col 0)
  static ladraoGaps_V + #4, #40 ; meioesquerda  (Linha 1, Col 0)
  static ladraoGaps_V + #5, #0 ; frenteesquerda(Linha 2, Col 0)
  
ladraoSprite: var #1
ladraoGapsPtr : var #1  ;
ladraoGapsPtr_ant : var #1

 ;declaração de todas as 1200 posições da tela incial 
initScre : var #1200
  ;Linha 0
  static initScre + #0, #21
  static initScre + #1, #21
  static initScre + #2, #21
  static initScre + #3, #21
  static initScre + #4, #21
  static initScre + #5, #21
  static initScre + #6, #21
  static initScre + #7, #21
  static initScre + #8, #21
  static initScre + #9, #21
  static initScre + #10, #21
  static initScre + #11, #21
  static initScre + #12, #21
  static initScre + #13, #21
  static initScre + #14, #21
  static initScre + #15, #21
  static initScre + #16, #21
  static initScre + #17, #21
  static initScre + #18, #21
  static initScre + #19, #21
  static initScre + #20, #21
  static initScre + #21, #21
  static initScre + #22, #21
  static initScre + #23, #21
  static initScre + #24, #21
  static initScre + #25, #21
  static initScre + #26, #21
  static initScre + #27, #21
  static initScre + #28, #21
  static initScre + #29, #21
  static initScre + #30, #21
  static initScre + #31, #21
  static initScre + #32, #21
  static initScre + #33, #21
  static initScre + #34, #21
  static initScre + #35, #21
  static initScre + #36, #21
  static initScre + #37, #21
  static initScre + #38, #21
  static initScre + #39, #21

  ;Linha 1
  static initScre + #40, #21
  static initScre + #41, #21
  static initScre + #42, #31
  static initScre + #43, #31
  static initScre + #44, #31
  static initScre + #45, #31
  static initScre + #46, #31
  static initScre + #47, #31
  static initScre + #48, #31
  static initScre + #49, #31
  static initScre + #50, #31
  static initScre + #51, #31
  static initScre + #52, #31
  static initScre + #53, #31
  static initScre + #54, #31
  static initScre + #55, #31
  static initScre + #56, #31
  static initScre + #57, #31
  static initScre + #58, #31
  static initScre + #59, #31
  static initScre + #60, #31
  static initScre + #61, #31
  static initScre + #62, #31
  static initScre + #63, #31
  static initScre + #64, #31
  static initScre + #65, #31
  static initScre + #66, #31
  static initScre + #67, #31
  static initScre + #68, #31
  static initScre + #69, #31
  static initScre + #70, #31
  static initScre + #71, #21
  static initScre + #72, #21
  static initScre + #73, #21
  static initScre + #74, #21
  static initScre + #75, #21
  static initScre + #76, #21
  static initScre + #77, #31
  static initScre + #78, #21
  static initScre + #79, #21

  ;Linha 2
  static initScre + #80, #2351
  static initScre + #81, #2348
  static initScre + #82, #112
  static initScre + #83, #106
  static initScre + #84, #106
  static initScre + #85, #106
  static initScre + #86, #106
  static initScre + #87, #106
  static initScre + #88, #106
  static initScre + #89, #106
  static initScre + #90, #106
  static initScre + #91, #106
  static initScre + #92, #106
  static initScre + #93, #106
  static initScre + #94, #106
  static initScre + #95, #106
  static initScre + #96, #106
  static initScre + #97, #106
  static initScre + #98, #106
  static initScre + #99, #106
  static initScre + #100, #106
  static initScre + #101, #106
  static initScre + #102, #106
  static initScre + #103, #106
  static initScre + #104, #106
  static initScre + #105, #106
  static initScre + #106, #106
  static initScre + #107, #106
  static initScre + #108, #106
  static initScre + #109, #106
  static initScre + #110, #106
  static initScre + #111, #106
  static initScre + #112, #106
  static initScre + #113, #106
  static initScre + #114, #106
  static initScre + #115, #106
  static initScre + #116, #106
  static initScre + #117, #109
  static initScre + #118, #2351
  static initScre + #119, #2348

  ;Linha 3
  static initScre + #120, #31
  static initScre + #121, #31
  static initScre + #122, #108
  static initScre + #123, #31
  static initScre + #124, #31
  static initScre + #125, #104
  static initScre + #126, #97
  static initScre + #127, #97
  static initScre + #128, #101
  static initScre + #129, #31
  static initScre + #130, #31
  static initScre + #131, #31
  static initScre + #132, #31
  static initScre + #133, #31
  static initScre + #134, #31
  static initScre + #135, #15
  static initScre + #136, #31
  static initScre + #137, #31
  static initScre + #138, #31
  static initScre + #139, #31
  static initScre + #140, #31
  static initScre + #141, #31
  static initScre + #142, #31
  static initScre + #143, #31
  static initScre + #144, #31
  static initScre + #145, #31
  static initScre + #146, #31
  static initScre + #147, #31
  static initScre + #148, #31
  static initScre + #149, #31
  static initScre + #150, #31
  static initScre + #151, #15
  static initScre + #152, #31
  static initScre + #153, #31
  static initScre + #154, #31
  static initScre + #155, #31
  static initScre + #156, #31
  static initScre + #157, #107
  static initScre + #158, #21
  static initScre + #159, #21

  ;Linha 4
  static initScre + #160, #31
  static initScre + #161, #31
  static initScre + #162, #108
  static initScre + #163, #31
  static initScre + #164, #31
  static initScre + #165, #103
  static initScre + #166, #98
  static initScre + #167, #98
  static initScre + #168, #102
  static initScre + #169, #31
  static initScre + #170, #31
  static initScre + #171, #31
  static initScre + #172, #31
  static initScre + #173, #31
  static initScre + #174, #31
  static initScre + #175, #15
  static initScre + #176, #31
  static initScre + #177, #31
  static initScre + #178, #31
  static initScre + #179, #31
  static initScre + #180, #31
  static initScre + #181, #31
  static initScre + #182, #31
  static initScre + #183, #31
  static initScre + #184, #31
  static initScre + #185, #31
  static initScre + #186, #31
  static initScre + #187, #31
  static initScre + #188, #31
  static initScre + #189, #31
  static initScre + #190, #31
  static initScre + #191, #15
  static initScre + #192, #31
  static initScre + #193, #31
  static initScre + #194, #31
  static initScre + #195, #31
  static initScre + #196, #31
  static initScre + #197, #107
  static initScre + #198, #31
  static initScre + #199, #31

  ;Linha 5
  static initScre + #200, #31
  static initScre + #201, #31
  static initScre + #202, #108
  static initScre + #203, #31
  static initScre + #204, #31
  static initScre + #205, #31
  static initScre + #206, #31
  static initScre + #207, #31
  static initScre + #208, #31
  static initScre + #209, #31
  static initScre + #210, #31
  static initScre + #211, #31
  static initScre + #212, #31
  static initScre + #213, #31
  static initScre + #214, #31
  static initScre + #215, #15
  static initScre + #216, #31
  static initScre + #217, #31
  static initScre + #218, #31
  static initScre + #219, #31
  static initScre + #220, #31
  static initScre + #221, #31
  static initScre + #222, #31
  static initScre + #223, #31
  static initScre + #224, #31
  static initScre + #225, #31
  static initScre + #226, #31
  static initScre + #227, #31
  static initScre + #228, #31
  static initScre + #229, #31
  static initScre + #230, #31
  static initScre + #231, #15
  static initScre + #232, #31
  static initScre + #233, #31
  static initScre + #234, #31
  static initScre + #235, #31
  static initScre + #236, #31
  static initScre + #237, #107
  static initScre + #238, #21
  static initScre + #239, #31

  ;Linha 6
  static initScre + #240, #31
  static initScre + #241, #31
  static initScre + #242, #108
  static initScre + #243, #45
  static initScre + #244, #45
  static initScre + #245, #45
  static initScre + #246, #45
  static initScre + #247, #45
  static initScre + #248, #45
  static initScre + #249, #45
  static initScre + #250, #45
  static initScre + #251, #45
  static initScre + #252, #45
  static initScre + #253, #45
  static initScre + #254, #45
  static initScre + #255, #15
  static initScre + #256, #45
  static initScre + #257, #45
  static initScre + #258, #45
  static initScre + #259, #45
  static initScre + #260, #45
  static initScre + #261, #45
  static initScre + #262, #45
  static initScre + #263, #45
  static initScre + #264, #45
  static initScre + #265, #45
  static initScre + #266, #45
  static initScre + #267, #45
  static initScre + #268, #45
  static initScre + #269, #45
  static initScre + #270, #45
  static initScre + #271, #15
  static initScre + #272, #45
  static initScre + #273, #45
  static initScre + #274, #45
  static initScre + #275, #45
  static initScre + #276, #45
  static initScre + #277, #107
  static initScre + #278, #21
  static initScre + #279, #31

  ;Linha 7
  static initScre + #280, #31
  static initScre + #281, #31
  static initScre + #282, #108
  static initScre + #283, #22
  static initScre + #284, #22
  static initScre + #285, #22
  static initScre + #286, #116
  static initScre + #287, #105
  static initScre + #288, #105
  static initScre + #289, #105
  static initScre + #290, #113
  static initScre + #291, #31
  static initScre + #292, #31
  static initScre + #293, #31
  static initScre + #294, #31
  static initScre + #295, #15
  static initScre + #296, #31
  static initScre + #297, #31
  static initScre + #298, #31
  static initScre + #299, #31
  static initScre + #300, #31
  static initScre + #301, #116
  static initScre + #302, #105
  static initScre + #303, #105
  static initScre + #304, #105
  static initScre + #305, #105
  static initScre + #306, #105
  static initScre + #307, #105
  static initScre + #308, #113
  static initScre + #309, #31
  static initScre + #310, #31
  static initScre + #311, #15
  static initScre + #312, #31
  static initScre + #313, #31
  static initScre + #314, #31
  static initScre + #315, #31
  static initScre + #316, #31
  static initScre + #317, #107
  static initScre + #318, #21
  static initScre + #319, #31

  ;Linha 8
  static initScre + #320, #31
  static initScre + #321, #31
  static initScre + #322, #108
  static initScre + #323, #31
  static initScre + #324, #31
  static initScre + #325, #31
  static initScre + #326, #107
  static initScre + #327, #31
  static initScre + #328, #31
  static initScre + #329, #31
  static initScre + #330, #108
  static initScre + #331, #31
  static initScre + #332, #31
  static initScre + #333, #31
  static initScre + #334, #31
  static initScre + #335, #15
  static initScre + #336, #31
  static initScre + #337, #31
  static initScre + #338, #31
  static initScre + #339, #31
  static initScre + #340, #31
  static initScre + #341, #107
  static initScre + #342, #31
  static initScre + #343, #31
  static initScre + #344, #31
  static initScre + #345, #31
  static initScre + #346, #31
  static initScre + #347, #31
  static initScre + #348, #108
  static initScre + #349, #31
  static initScre + #350, #31
  static initScre + #351, #15
  static initScre + #352, #31
  static initScre + #353, #31
  static initScre + #354, #31
  static initScre + #355, #31
  static initScre + #356, #31
  static initScre + #357, #107
  static initScre + #358, #21
  static initScre + #359, #31

  ;Linha 9
  static initScre + #360, #31
  static initScre + #361, #31
  static initScre + #362, #108
  static initScre + #363, #31
  static initScre + #364, #31
  static initScre + #365, #31
  static initScre + #366, #115
  static initScre + #367, #106
  static initScre + #368, #106
  static initScre + #369, #106
  static initScre + #370, #114
  static initScre + #371, #31
  static initScre + #372, #31
  static initScre + #373, #31
  static initScre + #374, #31
  static initScre + #375, #15
  static initScre + #376, #31
  static initScre + #377, #31
  static initScre + #378, #31
  static initScre + #379, #31
  static initScre + #380, #31
  static initScre + #381, #107
  static initScre + #382, #31
  static initScre + #383, #31
  static initScre + #384, #31
  static initScre + #385, #31
  static initScre + #386, #31
  static initScre + #387, #31
  static initScre + #388, #108
  static initScre + #389, #31
  static initScre + #390, #31
  static initScre + #391, #15
  static initScre + #392, #31
  static initScre + #393, #31
  static initScre + #394, #31
  static initScre + #395, #31
  static initScre + #396, #31
  static initScre + #397, #107
  static initScre + #398, #21
  static initScre + #399, #31

  ;Linha 10
  static initScre + #400, #31
  static initScre + #401, #21
  static initScre + #402, #31
  static initScre + #403, #31
  static initScre + #404, #31
  static initScre + #405, #31
  static initScre + #406, #31
  static initScre + #407, #31
  static initScre + #408, #31
  static initScre + #409, #31
  static initScre + #410, #31
  static initScre + #411, #31
  static initScre + #412, #31
  static initScre + #413, #31
  static initScre + #414, #31
  static initScre + #415, #15
  static initScre + #416, #31
  static initScre + #417, #31
  static initScre + #418, #31
  static initScre + #419, #31
  static initScre + #420, #31
  static initScre + #421, #107
  static initScre + #422, #31
  static initScre + #423, #31
  static initScre + #424, #31
  static initScre + #425, #31
  static initScre + #426, #31
  static initScre + #427, #31
  static initScre + #428, #108
  static initScre + #429, #31
  static initScre + #430, #31
  static initScre + #431, #15
  static initScre + #432, #31
  static initScre + #433, #31
  static initScre + #434, #31
  static initScre + #435, #31
  static initScre + #436, #31
  static initScre + #437, #107
  static initScre + #438, #21
  static initScre + #439, #31

  ;Linha 11
  static initScre + #440, #31
  static initScre + #441, #21
  static initScre + #442, #31
  static initScre + #443, #31
  static initScre + #444, #31
  static initScre + #445, #31
  static initScre + #446, #31
  static initScre + #447, #31
  static initScre + #448, #31
  static initScre + #449, #31
  static initScre + #450, #31
  static initScre + #451, #31
  static initScre + #452, #31
  static initScre + #453, #31
  static initScre + #454, #31
  static initScre + #455, #15
  static initScre + #456, #31
  static initScre + #457, #31
  static initScre + #458, #31
  static initScre + #459, #31
  static initScre + #460, #31
  static initScre + #461, #107
  static initScre + #462, #31
  static initScre + #463, #31
  static initScre + #464, #31
  static initScre + #465, #31
  static initScre + #466, #31
  static initScre + #467, #31
  static initScre + #468, #108
  static initScre + #469, #31
  static initScre + #470, #31
  static initScre + #471, #15
  static initScre + #472, #31
  static initScre + #473, #31
  static initScre + #474, #31
  static initScre + #475, #31
  static initScre + #476, #31
  static initScre + #477, #31
  static initScre + #478, #21
  static initScre + #479, #31

  ;Linha 12
  static initScre + #480, #31
  static initScre + #481, #21
  static initScre + #482, #31
  static initScre + #483, #31
  static initScre + #484, #31
  static initScre + #485, #31
  static initScre + #486, #31
  static initScre + #487, #31
  static initScre + #488, #31
  static initScre + #489, #31
  static initScre + #490, #31
  static initScre + #491, #31
  static initScre + #492, #31
  static initScre + #493, #31
  static initScre + #494, #31
  static initScre + #495, #15
  static initScre + #496, #31
  static initScre + #497, #31
  static initScre + #498, #31
  static initScre + #499, #31
  static initScre + #500, #31
  static initScre + #501, #107
  static initScre + #502, #31
  static initScre + #503, #31
  static initScre + #504, #31
  static initScre + #505, #31
  static initScre + #506, #31
  static initScre + #507, #31
  static initScre + #508, #108
  static initScre + #509, #31
  static initScre + #510, #31
  static initScre + #511, #15
  static initScre + #512, #31
  static initScre + #513, #31
  static initScre + #514, #31
  static initScre + #515, #31
  static initScre + #516, #31
  static initScre + #517, #31
  static initScre + #518, #31
  static initScre + #519, #31

  ;Linha 13
  static initScre + #520, #31
  static initScre + #521, #21
  static initScre + #522, #108
  static initScre + #523, #31
  static initScre + #524, #31
  static initScre + #525, #31
  static initScre + #526, #31
  static initScre + #527, #31
  static initScre + #528, #31
  static initScre + #529, #31
  static initScre + #530, #31
  static initScre + #531, #31
  static initScre + #532, #31
  static initScre + #533, #31
  static initScre + #534, #31
  static initScre + #535, #15
  static initScre + #536, #31
  static initScre + #537, #31
  static initScre + #538, #31
  static initScre + #539, #31
  static initScre + #540, #31
  static initScre + #541, #115
  static initScre + #542, #106
  static initScre + #543, #106
  static initScre + #544, #106
  static initScre + #545, #106
  static initScre + #546, #106
  static initScre + #547, #106
  static initScre + #548, #114
  static initScre + #549, #31
  static initScre + #550, #31
  static initScre + #551, #15
  static initScre + #552, #31
  static initScre + #553, #31
  static initScre + #554, #31
  static initScre + #555, #31
  static initScre + #556, #31
  static initScre + #557, #31
  static initScre + #558, #31
  static initScre + #559, #31

  ;Linha 14
  static initScre + #560, #31
  static initScre + #561, #21
  static initScre + #562, #108
  static initScre + #563, #31
  static initScre + #564, #31
  static initScre + #565, #31
  static initScre + #566, #31
  static initScre + #567, #31
  static initScre + #568, #31
  static initScre + #569, #31
  static initScre + #570, #31
  static initScre + #571, #31
  static initScre + #572, #31
  static initScre + #573, #31
  static initScre + #574, #31
  static initScre + #575, #15
  static initScre + #576, #31
  static initScre + #577, #31
  static initScre + #578, #31
  static initScre + #579, #31
  static initScre + #580, #31
  static initScre + #581, #31
  static initScre + #582, #31
  static initScre + #583, #31
  static initScre + #584, #31
  static initScre + #585, #31
  static initScre + #586, #31
  static initScre + #587, #31
  static initScre + #588, #31
  static initScre + #589, #31
  static initScre + #590, #31
  static initScre + #591, #15
  static initScre + #592, #31
  static initScre + #593, #31
  static initScre + #594, #31
  static initScre + #595, #31
  static initScre + #596, #31
  static initScre + #597, #107
  static initScre + #598, #31
  static initScre + #599, #31

  ;Linha 15
  static initScre + #600, #31
  static initScre + #601, #21
  static initScre + #602, #108
  static initScre + #603, #45
  static initScre + #604, #45
  static initScre + #605, #45
  static initScre + #606, #45
  static initScre + #607, #45
  static initScre + #608, #45
  static initScre + #609, #45
  static initScre + #610, #45
  static initScre + #611, #45
  static initScre + #612, #45
  static initScre + #613, #45
  static initScre + #614, #45
  static initScre + #615, #15
  static initScre + #616, #45
  static initScre + #617, #45
  static initScre + #618, #45
  static initScre + #619, #45
  static initScre + #620, #45
  static initScre + #621, #45
  static initScre + #622, #45
  static initScre + #623, #45
  static initScre + #624, #45
  static initScre + #625, #45
  static initScre + #626, #45
  static initScre + #627, #45
  static initScre + #628, #45
  static initScre + #629, #45
  static initScre + #630, #45
  static initScre + #631, #15
  static initScre + #632, #45
  static initScre + #633, #45
  static initScre + #634, #45
  static initScre + #635, #45
  static initScre + #636, #45
  static initScre + #637, #107
  static initScre + #638, #21
  static initScre + #639, #31

  ;Linha 16
  static initScre + #640, #31
  static initScre + #641, #21
  static initScre + #642, #108
  static initScre + #643, #31
  static initScre + #644, #31
  static initScre + #645, #31
  static initScre + #646, #31
  static initScre + #647, #31
  static initScre + #648, #31
  static initScre + #649, #31
  static initScre + #650, #31
  static initScre + #651, #31
  static initScre + #652, #31
  static initScre + #653, #31
  static initScre + #654, #31
  static initScre + #655, #15
  static initScre + #656, #31
  static initScre + #657, #31
  static initScre + #658, #31
  static initScre + #659, #116
  static initScre + #660, #105
  static initScre + #661, #105
  static initScre + #662, #105
  static initScre + #663, #105
  static initScre + #664, #113
  static initScre + #665, #31
  static initScre + #666, #31
  static initScre + #667, #31
  static initScre + #668, #31
  static initScre + #669, #31
  static initScre + #670, #31
  static initScre + #671, #15
  static initScre + #672, #31
  static initScre + #673, #31
  static initScre + #674, #31
  static initScre + #675, #31
  static initScre + #676, #31
  static initScre + #677, #107
  static initScre + #678, #21
  static initScre + #679, #31

  ;Linha 17
  static initScre + #680, #31
  static initScre + #681, #21
  static initScre + #682, #108
  static initScre + #683, #31
  static initScre + #684, #31
  static initScre + #685, #116
  static initScre + #686, #105
  static initScre + #687, #105
  static initScre + #688, #105
  static initScre + #689, #113
  static initScre + #690, #31
  static initScre + #691, #31
  static initScre + #692, #31
  static initScre + #693, #31
  static initScre + #694, #31
  static initScre + #695, #15
  static initScre + #696, #31
  static initScre + #697, #31
  static initScre + #698, #31
  static initScre + #699, #107
  static initScre + #700, #31
  static initScre + #701, #31
  static initScre + #702, #31
  static initScre + #703, #31
  static initScre + #704, #108
  static initScre + #705, #31
  static initScre + #706, #31
  static initScre + #707, #31
  static initScre + #708, #31
  static initScre + #709, #31
  static initScre + #710, #31
  static initScre + #711, #15
  static initScre + #712, #31
  static initScre + #713, #31
  static initScre + #714, #31
  static initScre + #715, #31
  static initScre + #716, #31
  static initScre + #717, #107
  static initScre + #718, #21
  static initScre + #719, #31

  ;Linha 18
  static initScre + #720, #31
  static initScre + #721, #21
  static initScre + #722, #108
  static initScre + #723, #31
  static initScre + #724, #31
  static initScre + #725, #107
  static initScre + #726, #31
  static initScre + #727, #31
  static initScre + #728, #31
  static initScre + #729, #108
  static initScre + #730, #31
  static initScre + #731, #31
  static initScre + #732, #31
  static initScre + #733, #31
  static initScre + #734, #31
  static initScre + #735, #15
  static initScre + #736, #31
  static initScre + #737, #31
  static initScre + #738, #31
  static initScre + #739, #107
  static initScre + #740, #31
  static initScre + #741, #31
  static initScre + #742, #31
  static initScre + #743, #31
  static initScre + #744, #108
  static initScre + #745, #31
  static initScre + #746, #31
  static initScre + #747, #31
  static initScre + #748, #31
  static initScre + #749, #31
  static initScre + #750, #31
  static initScre + #751, #15
  static initScre + #752, #31
  static initScre + #753, #31
  static initScre + #754, #31
  static initScre + #755, #31
  static initScre + #756, #31
  static initScre + #757, #107
  static initScre + #758, #21
  static initScre + #759, #31

  ;Linha 19
  static initScre + #760, #31
  static initScre + #761, #21
  static initScre + #762, #108
  static initScre + #763, #31
  static initScre + #764, #31
  static initScre + #765, #107
  static initScre + #766, #31
  static initScre + #767, #31
  static initScre + #768, #31
  static initScre + #769, #108
  static initScre + #770, #31
  static initScre + #771, #31
  static initScre + #772, #31
  static initScre + #773, #31
  static initScre + #774, #31
  static initScre + #775, #15
  static initScre + #776, #31
  static initScre + #777, #31
  static initScre + #778, #31
  static initScre + #779, #107
  static initScre + #780, #31
  static initScre + #781, #31
  static initScre + #782, #31
  static initScre + #783, #31
  static initScre + #784, #108
  static initScre + #785, #31
  static initScre + #786, #31
  static initScre + #787, #31
  static initScre + #788, #31
  static initScre + #789, #31
  static initScre + #790, #31
  static initScre + #791, #15
  static initScre + #792, #31
  static initScre + #793, #31
  static initScre + #794, #31
  static initScre + #795, #31
  static initScre + #796, #31
  static initScre + #797, #107
  static initScre + #798, #21
  static initScre + #799, #31

  ;Linha 20
  static initScre + #800, #31
  static initScre + #801, #21
  static initScre + #802, #108
  static initScre + #803, #31
  static initScre + #804, #31
  static initScre + #805, #107
  static initScre + #806, #31
  static initScre + #807, #31
  static initScre + #808, #31
  static initScre + #809, #108
  static initScre + #810, #31
  static initScre + #811, #31
  static initScre + #812, #31
  static initScre + #813, #31
  static initScre + #814, #31
  static initScre + #815, #15
  static initScre + #816, #31
  static initScre + #817, #31
  static initScre + #818, #31
  static initScre + #819, #107
  static initScre + #820, #31
  static initScre + #821, #31
  static initScre + #822, #31
  static initScre + #823, #31
  static initScre + #824, #108
  static initScre + #825, #31
  static initScre + #826, #31
  static initScre + #827, #31
  static initScre + #828, #31
  static initScre + #829, #31
  static initScre + #830, #31
  static initScre + #831, #15
  static initScre + #832, #31
  static initScre + #833, #31
  static initScre + #834, #31
  static initScre + #835, #31
  static initScre + #836, #31
  static initScre + #837, #107
  static initScre + #838, #21
  static initScre + #839, #31

  ;Linha 21
  static initScre + #840, #31
  static initScre + #841, #21
  static initScre + #842, #108
  static initScre + #843, #31
  static initScre + #844, #31
  static initScre + #845, #107
  static initScre + #846, #31
  static initScre + #847, #31
  static initScre + #848, #31
  static initScre + #849, #108
  static initScre + #850, #31
  static initScre + #851, #31
  static initScre + #852, #31
  static initScre + #853, #31
  static initScre + #854, #31
  static initScre + #855, #15
  static initScre + #856, #31
  static initScre + #857, #31
  static initScre + #858, #31
  static initScre + #859, #107
  static initScre + #860, #31
  static initScre + #861, #31
  static initScre + #862, #31
  static initScre + #863, #31
  static initScre + #864, #108
  static initScre + #865, #31
  static initScre + #866, #31
  static initScre + #867, #31
  static initScre + #868, #31
  static initScre + #869, #31
  static initScre + #870, #31
  static initScre + #871, #15
  static initScre + #872, #31
  static initScre + #873, #31
  static initScre + #874, #31
  static initScre + #875, #31
  static initScre + #876, #31
  static initScre + #877, #107
  static initScre + #878, #21
  static initScre + #879, #31

  ;Linha 22
  static initScre + #880, #31
  static initScre + #881, #21
  static initScre + #882, #108
  static initScre + #883, #31
  static initScre + #884, #31
  static initScre + #885, #115
  static initScre + #886, #106
  static initScre + #887, #106
  static initScre + #888, #106
  static initScre + #889, #114
  static initScre + #890, #31
  static initScre + #891, #31
  static initScre + #892, #31
  static initScre + #893, #31
  static initScre + #894, #31
  static initScre + #895, #15
  static initScre + #896, #31
  static initScre + #897, #31
  static initScre + #898, #31
  static initScre + #899, #115
  static initScre + #900, #106
  static initScre + #901, #106
  static initScre + #902, #106
  static initScre + #903, #106
  static initScre + #904, #114
  static initScre + #905, #31
  static initScre + #906, #31
  static initScre + #907, #31
  static initScre + #908, #31
  static initScre + #909, #31
  static initScre + #910, #31
  static initScre + #911, #15
  static initScre + #912, #31
  static initScre + #913, #31
  static initScre + #914, #31
  static initScre + #915, #31
  static initScre + #916, #31
  static initScre + #917, #107
  static initScre + #918, #21
  static initScre + #919, #31

  ;Linha 23
  static initScre + #920, #31
  static initScre + #921, #21
  static initScre + #922, #108
  static initScre + #923, #45
  static initScre + #924, #45
  static initScre + #925, #45
  static initScre + #926, #45
  static initScre + #927, #45
  static initScre + #928, #45
  static initScre + #929, #45
  static initScre + #930, #45
  static initScre + #931, #45
  static initScre + #932, #45
  static initScre + #933, #45
  static initScre + #934, #45
  static initScre + #935, #15
  static initScre + #936, #45
  static initScre + #937, #45
  static initScre + #938, #45
  static initScre + #939, #45
  static initScre + #940, #45
  static initScre + #941, #45
  static initScre + #942, #45
  static initScre + #943, #45
  static initScre + #944, #45
  static initScre + #945, #45
  static initScre + #946, #45
  static initScre + #947, #45
  static initScre + #948, #45
  static initScre + #949, #45
  static initScre + #950, #45
  static initScre + #951, #15
  static initScre + #952, #45
  static initScre + #953, #45
  static initScre + #954, #45
  static initScre + #955, #45
  static initScre + #956, #45
  static initScre + #957, #107
  static initScre + #958, #21
  static initScre + #959, #31

  ;Linha 24
  static initScre + #960, #31
  static initScre + #961, #31
  static initScre + #962, #108
  static initScre + #963, #31
  static initScre + #964, #31
  static initScre + #965, #31
  static initScre + #966, #31
  static initScre + #967, #31
  static initScre + #968, #31
  static initScre + #969, #31
  static initScre + #970, #31
  static initScre + #971, #31
  static initScre + #972, #31
  static initScre + #973, #31
  static initScre + #974, #31
  static initScre + #975, #15
  static initScre + #976, #31
  static initScre + #977, #31
  static initScre + #978, #31
  static initScre + #979, #31
  static initScre + #980, #31
  static initScre + #981, #31
  static initScre + #982, #31
  static initScre + #983, #31
  static initScre + #984, #31
  static initScre + #985, #31
  static initScre + #986, #31
  static initScre + #987, #31
  static initScre + #988, #31
  static initScre + #989, #31
  static initScre + #990, #31
  static initScre + #991, #15
  static initScre + #992, #31
  static initScre + #993, #31
  static initScre + #994, #31
  static initScre + #995, #31
  static initScre + #996, #31
  static initScre + #997, #107
  static initScre + #998, #21
  static initScre + #999, #31

  ;Linha 25
  static initScre + #1000, #31
  static initScre + #1001, #31
  static initScre + #1002, #108
  static initScre + #1003, #31
  static initScre + #1004, #31
  static initScre + #1005, #31
  static initScre + #1006, #31
  static initScre + #1007, #31
  static initScre + #1008, #31
  static initScre + #1009, #31
  static initScre + #1010, #31
  static initScre + #1011, #31
  static initScre + #1012, #31
  static initScre + #1013, #31
  static initScre + #1014, #31
  static initScre + #1015, #15
  static initScre + #1016, #31
  static initScre + #1017, #31
  static initScre + #1018, #31
  static initScre + #1019, #31
  static initScre + #1020, #31
  static initScre + #1021, #31
  static initScre + #1022, #31
  static initScre + #1023, #31
  static initScre + #1024, #31
  static initScre + #1025, #31
  static initScre + #1026, #31
  static initScre + #1027, #31
  static initScre + #1028, #31
  static initScre + #1029, #31
  static initScre + #1030, #31
  static initScre + #1031, #15
  static initScre + #1032, #31
  static initScre + #1033, #31
  static initScre + #1034, #31
  static initScre + #1035, #31
  static initScre + #1036, #31
  static initScre + #1037, #107
  static initScre + #1038, #21
  static initScre + #1039, #31

  ;Linha 26
  static initScre + #1040, #31
  static initScre + #1041, #21
  static initScre + #1042, #108
  static initScre + #1043, #31
  static initScre + #1044, #31
  static initScre + #1045, #31
  static initScre + #1046, #31
  static initScre + #1047, #31
  static initScre + #1048, #31
  static initScre + #1049, #31
  static initScre + #1050, #31
  static initScre + #1051, #31
  static initScre + #1052, #31
  static initScre + #1053, #31
  static initScre + #1054, #31
  static initScre + #1055, #15
  static initScre + #1056, #31
  static initScre + #1057, #31
  static initScre + #1058, #31
  static initScre + #1059, #31
  static initScre + #1060, #31
  static initScre + #1061, #31
  static initScre + #1062, #31
  static initScre + #1063, #31
  static initScre + #1064, #31
  static initScre + #1065, #31
  static initScre + #1066, #31
  static initScre + #1067, #31
  static initScre + #1068, #31
  static initScre + #1069, #31
  static initScre + #1070, #31
  static initScre + #1071, #15
  static initScre + #1072, #31
  static initScre + #1073, #31
  static initScre + #1074, #31
  static initScre + #1075, #31
  static initScre + #1076, #31
  static initScre + #1077, #107
  static initScre + #1078, #21
  static initScre + #1079, #31

  ;Linha 27
  static initScre + #1080, #31
  static initScre + #1081, #31
  static initScre + #1082, #111
  static initScre + #1083, #105
  static initScre + #1084, #105
  static initScre + #1085, #105
  static initScre + #1086, #105
  static initScre + #1087, #105
  static initScre + #1088, #105
  static initScre + #1089, #105
  static initScre + #1090, #105
  static initScre + #1091, #105
  static initScre + #1092, #105
  static initScre + #1093, #105
  static initScre + #1094, #105
  static initScre + #1095, #105
  static initScre + #1096, #105
  static initScre + #1097, #105
  static initScre + #1098, #105
  static initScre + #1099, #105
  static initScre + #1100, #105
  static initScre + #1101, #105
  static initScre + #1102, #105
  static initScre + #1103, #105
  static initScre + #1104, #105
  static initScre + #1105, #105
  static initScre + #1106, #105
  static initScre + #1107, #105
  static initScre + #1108, #105
  static initScre + #1109, #105
  static initScre + #1110, #105
  static initScre + #1111, #105
  static initScre + #1112, #105
  static initScre + #1113, #105
  static initScre + #1114, #105
  static initScre + #1115, #105
  static initScre + #1116, #105
  static initScre + #1117, #110
  static initScre + #1118, #21
  static initScre + #1119, #31

  ;Linha 28
  static initScre + #1120, #31
  static initScre + #1121, #31
  static initScre + #1122, #21
  static initScre + #1123, #21
  static initScre + #1124, #31
  static initScre + #1125, #31
  static initScre + #1126, #31
  static initScre + #1127, #31
  static initScre + #1128, #31
  static initScre + #1129, #21
  static initScre + #1130, #21
  static initScre + #1131, #21
  static initScre + #1132, #21
  static initScre + #1133, #21
  static initScre + #1134, #21
  static initScre + #1135, #21
  static initScre + #1136, #21
  static initScre + #1137, #21
  static initScre + #1138, #21
  static initScre + #1139, #21
  static initScre + #1140, #21
  static initScre + #1141, #21
  static initScre + #1142, #21
  static initScre + #1143, #21
  static initScre + #1144, #21
  static initScre + #1145, #21
  static initScre + #1146, #21
  static initScre + #1147, #21
  static initScre + #1148, #21
  static initScre + #1149, #21
  static initScre + #1150, #31
  static initScre + #1151, #31
  static initScre + #1152, #31
  static initScre + #1153, #31
  static initScre + #1154, #21
  static initScre + #1155, #21
  static initScre + #1156, #21
  static initScre + #1157, #31
  static initScre + #1158, #31
  static initScre + #1159, #31

  ;Linha 29
  static initScre + #1160, #31
  static initScre + #1161, #31
  static initScre + #1162, #31
  static initScre + #1163, #31
  static initScre + #1164, #31
  static initScre + #1165, #31
  static initScre + #1166, #31
  static initScre + #1167, #31
  static initScre + #1168, #21
  static initScre + #1169, #21
  static initScre + #1170, #21
  static initScre + #1171, #21
  static initScre + #1172, #21
  static initScre + #1173, #21
  static initScre + #1174, #21
  static initScre + #1175, #21
  static initScre + #1176, #21
  static initScre + #1177, #21
  static initScre + #1178, #21
  static initScre + #1179, #21
  static initScre + #1180, #21
  static initScre + #1181, #21
  static initScre + #1182, #21
  static initScre + #1183, #21
  static initScre + #1184, #21
  static initScre + #1185, #21
  static initScre + #1186, #31
  static initScre + #1187, #31
  static initScre + #1188, #31
  static initScre + #1189, #31
  static initScre + #1190, #31
  static initScre + #1191, #31
  static initScre + #1192, #31
  static initScre + #1193, #31
  static initScre + #1194, #31
  static initScre + #1195, #31
  static initScre + #1196, #31
  static initScre + #1197, #31
  static initScre + #1198, #31
  static initScre + #1199, #21
  
  
printinitScreScreen:
  push R0
  push R1
  push R2
  push R3

  loadn R0, #initScre
  loadn R1, #0
  loadn R2, #1200

  printinitScreScreenLoop:

    add R3,R0,R1
    loadi R3, R3
    outchar R3, R1
    inc R1
    cmp R1, R2

    jne printinitScreScreenLoop

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

  load R0, ladraoSprite
  load R1, ladraoGapsPtr
  load R2, pos_ladrao
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
  

  
  loadn R0, #initScre
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
        cmp R0, R1              ; se digitou espaco, sai do loop
        jne lll
    ;pop R2
    pop R1
    pop R0
    rts
    
loop_ini:
    push R0
    push R1
    ;push R2
    loop_inil:
        call delay 
        load R0, tecla_atual
        loadn R1, #' '
        cmp R0, R1              ; se digitou espaco, sai do loop
        jne loop_inil
    ;pop R2
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

    ; 3. Uma tecla FOI pressionada (w,a,s,d). Atualiza a 'dir_ladrao'
    store dir_ladrao, r1
    
MoveComDirAnterior:
    ; 4. Carrega a 'dir_ladrao' (a última direção válida que o jogador apertou)
    load r1, dir_ladrao
    
    ; Checa Esquerda ('a')
    loadn r2, #'a'
    cmp r1, r2
    jne ChecaCima
    loadn r3, #1
    sub r0, r0, r3          ; pos_ladrao = pos_ladrao - 1 (CORRIGIDO)
    loadn r5, #ladrao_H ;att ponteiro do sprite
    ;store  ladraoSprite, r2
    loadn r6, #ladraoGaps_H  
    ;store ladraoGapsPtr, r2  
    jmp FazChecagem
    
ChecaCima: 
    ; Checa Cima ('w')
    loadn r2, #'w'
    cmp r1, r2
    jne ChecaBaixo
    loadn r3, #40           ; Largura da tela (CORRIGIDO)
    sub r0, r0, r3          ; pos_ladrao = pos_ladrao - 40
    loadn r5, #ladrao_V      ; <--- ATUALIZA PONTEIRO DO SPRITE
    ;store ladraoSprite, r2
    loadn r6, #ladraoGaps_V  
    ;store ladraoGapsPtr, r2  
    jmp FazChecagem

ChecaBaixo: 
    ; Checa Baixo ('s')
    loadn r2, #'s'
    cmp r1, r2
    jne ChecaDireita
    loadn r3, #40           ; Largura da tela (CORRIGIDO)
    add r0, r0, r3          ; pos_ladrao = pos_ladrao + 40
    loadn r5, #ladrao_V      ; <--- ATUALIZA PONTEIRO DO SPRITE
    ;store ladraoSprite, r2
    loadn r6, #ladraoGaps_V  
    ;store ladraoGapsPtr, r2  
    jmp FazChecagem

ChecaDireita: 
    ; Checa Direita ('d')
    loadn r2, #'d'
    cmp r1, r2
    jne FimCalculaPos      ; Nenhuma tecla de movimento válida, não faz nada
    loadn r3, #1
    add r0, r0, r3          ; pos_ladrao = pos_ladrao + 1 (JÁ ESTAVA CORRETO)
    loadn r5, #ladrao_H      ; <--- ATUALIZA PONTEIRO DO SPRITE
    ;store ladraoSprite, r2
    loadn r6, #ladraoGaps_H  
    ;store ladraoGapsPtr, r2  
    
FazChecagem:
; --- 4. CHECAGEM DE COLISÃO E LIMITES ---
    ; A nova posição está em r0.
    
    ; Primeiro, checa os limites da tela (0 e 1200)
    loadn r2, #0
    cmp r0, r2
    jle FimCalculaPos      ; Se r0 < 0, PULA
    
    mov r4, r0
    loadn r2, #81 ; Maior offset (ladraoGaps + 5)
    add r4, r4, r2
    loadn r3, #1200
    cmp r4, r3
    jgr FimCalculaPos      ; Se (r0 + 42) >= 1200, PULA
    mov r2,r6
    ; Agora, checa a colisão com o cenário
    call CheckMoveValido    ; Esta função usa R0 (nova pos)
                            ; e retorna R7 (1=valido, 0=invalido)
    
    loadn r1, #1
    cmp r7, r1              ; O movimento (R7) é válido?
    jne FimCalculaPos      ; Se R7 != 1, PULA
    
    ; --- 5. MOVIMENTAÇÃO VÁLIDA ---
    ; Se chegamos aqui, os limites e a colisão estão OK.
    ; AGORA SIM, NÓS "CONFIRMAMOS" AS MUDANÇAS
    store pos_ladrao, r0      ; Salva a nova posição
    store ladraoSprite, r5    ; Salva o novo ponteiro de sprite
    store ladraoGapsPtr, r6   ; Salva o novo ponteiro de gaps

    call apagarladrao       ; Apaga da posição antiga
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


    loadn r1, #initScre      ; Endereço base do cenário
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
    loadn r7, #1
    
    ; --- LISTA DE TUDO QUE FOR "PAREDE" (Blacklist) ---
    ; Se R5 for igual a qualquer um desses, pulamos para isWall
    loadn r0, #58           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #59           ; Canto
    cmp r5, r0
    jeq isWall

    loadn r0, #60           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #61           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #62           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #63           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #97
    cmp r5, r0
    jeq isWall

    loadn r0, #98
    cmp r5, r0
    jeq isWall

    loadn r0, #101
    cmp r5, r0
    jeq isWall

    loadn r0, #102
    cmp r5, r0
    jeq isWall

    loadn r0, #103
    cmp r5, r0
    jeq isWall
    
    loadn r0, #104
    cmp r5, r0
    jeq isWall

    loadn r0, #105           ; Parede
    cmp r5, r0
    jeq isWall

    loadn r0, #106           ; Parede
    cmp r5, r0
    jeq isWall

    loadn r0, #107           ; Canto
    cmp r5, r0
    jeq isWall

    loadn r0, #108           ; Parede
    cmp r5, r0
    jeq isWall

    loadn r0, #109           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #110           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #111           ; Canto
    cmp r5, r0
    jeq isWall

    loadn r0, #112           ; Canto
    cmp r5, r0
    jeq isWall

    loadn r0, #113           ; Canto
    cmp r5, r0
    jeq isWall

    loadn r0, #114           ; Canto
    cmp r5, r0
    jeq isWall

    loadn r0, #115           ; Canto
    cmp r5, r0
    jeq isWall

    loadn r0, #116           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #117           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #118           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #119           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #120           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #121           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #122           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #123           ; Canto
    cmp r5, r0
    jeq isWall
    
    
    loadn r0, #124           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #125           ; Canto
    cmp r5, r0
    jeq isWall
    
    loadn r0, #126           ; Canto
    cmp r5, r0
    jeq isWall
    
    ; ... adicione mais IDs de parede aqui se necessário ...
    
    ; Se o código chegou aqui, não é nenhuma das paredes listadas.
    ; O movimento é VÁLIDO, e R7 já está como 1.
    jmp Walkable
    
isWall:
    loadn r7,#0
Walkable:
    pop r0
    rts
    
    


main:

    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    push r7
    call inicializa_var
    call printinitScreScreen
    call printladrao
    loadn r0,#0
    main_inicio:    
        call delay

        inc r0
        loadn r1, #60
        mod r1, r0, r1
        jnz main_inicio
        
        ; Simplesmente chame CalculaPos. 
        ; Ele vai cuidar de mover E desenhar o personagem.
        call CalculaPos
        
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
    loadn r0, #ladrao_H
    store ladraoSprite, r0
    
    loadn r0, #ladraoGaps_H
    store ladraoGapsPtr, r0 
    store ladraoGapsPtr_ant, r0
    
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
