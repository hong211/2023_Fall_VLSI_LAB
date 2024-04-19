****  Final Project: Two stage pipeline Two mode 6-bit MAC  ***

*************************************************************
*************************************************************
***************Don't touch settings below********************
*************************************************************
*************************************************************
.lib "../../umc018.l" L18U18V_TT
.vec 'MAC6.vec'

.temp 25
.op
.options brief post

***************** parameter ****************************
.global  VDD  GND
.param supply = 1.8v
.param load = 10f
.param tr = 0.1n

***************** voltage source ****************************
Vclk CLK GND pulse(0 supply 0 0.1ns 0.1ns "1*period/2-tr" "period*1")
Vd1 VDD GND supply

***************** top-circuit ****************************
XMAC6 CLK 
+ A[5] A[4] A[3] A[2] A[1] A[0]
+ B[5] B[4] B[3] B[2] B[1] B[0] 
+ MODE
+ ACC[11] ACC[10] ACC[9]  ACC[8] ACC[7] ACC[6] ACC[5] ACC[4] ACC[3] ACC[2] ACC[1] ACC[0]
+ OUT[12] OUT[11] OUT[10] OUT[9] OUT[8] OUT[7] OUT[6] OUT[5] OUT[4] OUT[3] OUT[2] OUT[1] OUT[0] MAC6
     
CLOAD01 OUT[0] GND load
CLOAD02 OUT[1] GND load 
CLOAD03 OUT[2] GND load 
CLOAD04 OUT[3] GND load 
CLOAD05 OUT[4] GND load 
CLOAD06 OUT[5] GND load 
CLOAD07 OUT[6] GND load 
CLOAD08 OUT[7] GND load 
CLOAD09 OUT[8] GND load 
CLOAD10 OUT[9] GND load 
CLOAD11 OUT[10] GND load 
CLOAD12 OUT[11] GND load 
CLOAD13 OUT[12] GND load 

***************** Average Power ****************************
.meas tran Iavg avg I(Vd1) from=0ns to='515*period'
.meas Pavg param='abs(Iavg)*supply'

.tran 0.1n '515*period'

*************************************************************
*************************************************************
***************Don't touch settings above********************
*************************************************************
*************************************************************

***** you can modify clock cycle here, remember synchronize with clock cycle in MAC6.vec ****
.param period = 1.19n

***** Define your sub-circuit and self-defined parameter here , and only need to submmit this part ****

.param wp_NOR= 0.66u
.param wn_NOR= 0.48u
.param wp_XOR= 0.66u
.param wn_XOR= 0.48u
.param wp_inv= 0.66u
.param wn_inv= 0.48u
.param wp_FA =0.66u
.param wn_FA =0.48u
.param wp= 0.66u
.param wn= 0.48u
.param wp_pseudo = 0.44u
.param wn_pseudo = 0.48u

.subckt MAC6 CLK 
+ A[5] A[4] A[3] A[2] A[1] A[0]
+ B[5] B[4] B[3] B[2] B[1] B[0] 
+ MODE
+ ACC[11] ACC[10] ACC[9]  ACC[8] ACC[7] ACC[6] ACC[5] ACC[4] ACC[3] ACC[2] ACC[1] ACC[0]
+ OUT[12] OUT[11] OUT[10] OUT[9] OUT[8] OUT[7] OUT[6] OUT[5] OUT[4] OUT[3] OUT[2] OUT[1] OUT[0]

XI0 ACC0 ACC1 ACC2 ACC3 ACC4 ACC5 ACC6 ACC7 ACC8 ACC9 ACC10 ACC11 ACC[0] 
+ ACC[1] ACC[2] ACC[3] ACC[4] ACC[5] ACC[6] ACC[7] ACC[8] ACC[9] ACC[10] 
+ ACC[11] MODE / XOR_BLOCK
XI1 A[0] A[1] A[2] A[3] A[4] A[5] B[0] B[1] B[2] B[3] B[4] B[5] PP0[0] PP0[1] 
+ PP0[2] PP0[3] PP0[4] PP0[5] PP0[6] PP1[0] PP1[1] PP1[2] PP1[3] PP1[4] PP1[5] 
+ PP1[6] PP2[0] PP2[1] PP2[2] PP2[3] PP2[4] PP2[5] PP2[6] / BOOTH_BLOCK
XI2 ACC0 ACC0_ ACC1 ACC1_ ACC2 ACC2_ ACC3 ACC3_ ACC4 ACC4_ ACC5 ACC5_ ACC6 
+ ACC6_ ACC7 ACC7_ ACC8 ACC8_ ACC9 ACC9_ ACC10 ACC10_ ACC11 ACC11_ B1 B3 B5 
+ B[1] B[3] B[5] CLK MODE MODE0 PP00 PP0[0] PP0[1] PP0[2] PP0[3] PP0[4] PP0[5] 
+ PP0[6] PP01 PP1[0] PP1[1] PP1[2] PP1[3] PP1[4] PP1[5] PP1[6] PP02 PP2[0] 
+ PP2[1] PP2[2] PP2[3] PP2[4] PP2[5] PP2[6] PP03 PP04 PP05 PP06 PP10 PP11 PP12 
+ PP13 PP14 PP15 PP16 PP20 PP21 PP22 PP23 PP24 PP25 PP26 / DFF_stage1
XI3 ACC1_ ACC3_ B1 B3 C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 PP00 PP01 PP02 
+ PP03 PP04 PP05 PP06 PP10 PP11 PP12 PP13 PP14 PP15 PP16 PP20 PP21 PP22 PP23 
+ PP24 PP25 PP26 S0 S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 S11 S12 / CSA1
XI4 ACC0_ ACC2_ B5 C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C13 C14 C15 C16 C17 
+ C18 C19 C20 C21 C22 C23 C24 C25 MODE0 S0 S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 S11 
+ S12 S13 S14 S15 S16 S17 S18 S19 S20 S21 S22 S23 S24 S25 / CSA2
XI7 ACC4_ ACC5_ ACC6_ ACC7_ ACC8_ ACC9_ ACC10_ ACC11_ C13 C14 C15 C16 C17 C18 
+ C19 C20 C21 C22 C23 C24 C26 C27 C28 C29 C30 C31 C32 C33 C34 C35 C36 C37 S14 
+ S15 S16 S17 S18 S19 S20 S21 S22 S23 S24 S25 S26 S27 S28 S29 S30 S31 S32 S33 
+ S34 S35 S36 S37 / CSA3
XI9 S27 S28 S29 S30 C26 C27 C28 C29 GND CARRY SUM2 SUM3 SUM4 SUM5 / RCA4
XI10 C30 C30_ C31 C31_ C32 C32_ C33 C33_ C34 C34_ C35 C35_ C36 C36_ CARRY 
+ CARRY_ CLK OUT0 OUT1 OUT2 OUT3 OUT4 OUT5 S13 S26 S31 S31_ S32 S32_ S33 S33_ 
+ S34 S34_ S35 S35_ S36 S36_ S37 S37_ SUM2 SUM3 SUM4 SUM5 / DFF_stage2
XI11 S31_ S32_ S33_ S34_ S35_ S36_ S37_ C30_ C31_ C32_ C33_ C34_ C35_ C36_ 
+ CARRY_ COUT_BAR OUT6 OUT7 OUT8 OUT9 OUT10 OUT11 OUT12 / RCA7
XI14 CLK OUT0 OUT1 OUT2 OUT3 OUT4 OUT5 OUT6 OUT7 OUT8 OUT9 OUT10 OUT11 OUT12 
+ OUT[0] OUT[1] OUT[2] OUT[3] OUT[4] OUT[5] OUT[6] OUT[7] OUT[8] OUT[9] 
+ OUT[10] OUT[11] OUT[12] / DFF_stage3
.ends
************************************************************************
* Library Name: FP
* Cell Name:    XOR
* View Name:    schematic
************************************************************************

.SUBCKT XOR A B OUT
*.PININFO A:I B:I OUT:O
MM4 net1 B VDD VDD P_18_G2 W=wp_XOR L=180n
MM2 OUT B A VDD P_18_G2 W=wp_XOR L=180n
MM0 OUT A B VDD P_18_G2 W=wp_XOR L=180n
MM5 net1 B GND GND N_18_G2 W=wn_XOR L=180n
MM3 OUT net1 A GND N_18_G2 W=wn_XOR L=180n
MM1 OUT A net1 GND N_18_G2 W=wn_XOR L=180n
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    XOR_BLOCK
* View Name:    schematic
************************************************************************

.SUBCKT XOR_BLOCK ACC0 ACC1 ACC2 ACC3 ACC4 ACC5 ACC6 ACC7 ACC8 ACC9 ACC10 
+ ACC11 ACC[0] ACC[1] ACC[2] ACC[3] ACC[4] ACC[5] ACC[6] ACC[7] ACC[8] ACC[9] 
+ ACC[10] ACC[11] MODE
*.PININFO ACC[0]:I ACC[1]:I ACC[2]:I ACC[3]:I ACC[4]:I ACC[5]:I ACC[6]:I 
*.PININFO ACC[7]:I ACC[8]:I ACC[9]:I ACC[10]:I ACC[11]:I MODE:I ACC0:O ACC1:O 
*.PININFO ACC2:O ACC3:O ACC4:O ACC5:O ACC6:O ACC7:O ACC8:O ACC9:O ACC10:O 
*.PININFO ACC11:O
XI35 ACC[5] MODE ACC5 / XOR
XI36 ACC[4] MODE ACC4 / XOR
XI32 ACC[8] MODE ACC8 / XOR
XI33 ACC[7] MODE ACC7 / XOR
XI29 ACC[11] MODE ACC11 / XOR
XI31 ACC[9] MODE ACC9 / XOR
XI30 ACC[10] MODE ACC10 / XOR
XI34 ACC[6] MODE ACC6 / XOR
XI39 ACC[1] MODE ACC1 / XOR
XI37 ACC[3] MODE ACC3 / XOR
XI38 ACC[2] MODE ACC2 / XOR
XI40 ACC[0] MODE ACC0 / XOR
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    INV
* View Name:    schematic
************************************************************************

.SUBCKT INV in out
*.PININFO in:I out:O
MM0 out in GND GND N_18_G2 W=wn_inv L=180n
MM1 out in VDD VDD P_18_G2 W=wp_inv L=180n
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    XNOR
* View Name:    schematic
************************************************************************

.SUBCKT XNOR A B OUT
*.PININFO A:I B:I OUT:O
XI0 A B net1 / XOR
XI1 net1 OUT / INV
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    NOR
* View Name:    schematic
************************************************************************

.SUBCKT NOR A B OUT
*.PININFO A:I B:I OUT:O
MM1 OUT B net1 VDD P_18_G2 W=wp_NOR L=180n
MM0 net1 A VDD VDD P_18_G2 W=wp_NOR L=180n
MM3 OUT B GND GND N_18_G2 W=wn_NOR L=180n
MM2 OUT A GND GND N_18_G2 W=wn_NOR L=180n
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    BE
* View Name:    schematic
************************************************************************

.SUBCKT BE B_2i B_2i+1 B_2i-1 X2i Xi
*.PININFO B_2i:I B_2i-1:I X2i:O Xi:O B_2i+1:B
XI0 B_2i-1 B_2i Xi / XOR
XI1 B_2i B_2i+1 net1 / XNOR
XI2 Xi net1 X2i / NOR
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    NAND
* View Name:    schematic
************************************************************************

.SUBCKT NAND A B OUT
*.PININFO A:I B:I OUT:O
MM6 OUT B VDD VDD P_18_G2 W=wp L=180n
MM3 OUT A VDD VDD P_18_G2 W=wp L=180n
MM8 net1 B GND GND N_18_G2 W=wn L=180n
MM7 OUT A net1 GND N_18_G2 W=wn L=180n
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    BS
* View Name:    schematic
************************************************************************

.SUBCKT BS A_i-1 Ai Mi PPi X2i Xi
*.PININFO A_i-1:I Ai:I Mi:I X2i:I Xi:I PPi:O
XI2 net1 net2 net3 / NAND
XI1 Ai Xi net2 / NAND
XI0 A_i-1 X2i net1 / NAND
XI3 Mi net3 PPi / XOR
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    BOOTH_BLOCK
* View Name:    schematic
************************************************************************

.SUBCKT BOOTH_BLOCK A[0] A[1] A[2] A[3] A[4] A[5] B[0] B[1] B[2] B[3] B[4] 
+ B[5] PP0[0] PP0[1] PP0[2] PP0[3] PP0[4] PP0[5] PP0[6] PP1[0] PP1[1] PP1[2] 
+ PP1[3] PP1[4] PP1[5] PP1[6] PP2[0] PP2[1] PP2[2] PP2[3] PP2[4] PP2[5] PP2[6]
*.PININFO A[0]:I A[1]:I A[2]:I A[3]:I A[4]:I A[5]:I B[0]:I B[1]:I B[2]:I 
*.PININFO B[3]:I B[4]:I B[5]:I PP0[0]:O PP0[1]:O PP0[2]:O PP0[3]:O PP0[4]:O 
*.PININFO PP0[5]:O PP0[6]:O PP1[0]:O PP1[1]:O PP1[2]:O PP1[3]:O PP1[4]:O 
*.PININFO PP1[5]:O PP1[6]:O PP2[0]:O PP2[1]:O PP2[2]:O PP2[3]:O PP2[4]:O 
*.PININFO PP2[5]:O PP2[6]:O
XI45 B[4] B[5] B[3] X2i[2] Xi[2] / BE
XI37 B[2] B[3] B[1] X2i[1] Xi[1] / BE
XI0 B[0] B[1] GND X2i[0] Xi[0] / BE
XI59 A[2] A[3] B[5] PP2[3] X2i[2] Xi[2] / BS
XI58 A[3] A[4] B[5] PP2[4] X2i[2] Xi[2] / BS
XI46 A[2] A[3] B[3] PP1[3] X2i[1] Xi[1] / BS
XI57 A[5] A[5] B[5] PP2[6] X2i[2] Xi[2] / BS
XI56 A[4] A[5] B[5] PP2[5] X2i[2] Xi[2] / BS
XI55 GND A[0] B[5] PP2[0] X2i[2] Xi[2] / BS
XI28 A[4] A[5] B[1] PP0[5] X2i[0] Xi[0] / BS
XI54 A[1] A[2] B[5] PP2[2] X2i[2] Xi[2] / BS
XI53 A[0] A[1] B[5] PP2[1] X2i[2] Xi[2] / BS
XI52 A[0] A[1] B[3] PP1[1] X2i[1] Xi[1] / BS
XI51 A[1] A[2] B[3] PP1[2] X2i[1] Xi[1] / BS
XI50 GND A[0] B[3] PP1[0] X2i[1] Xi[1] / BS
XI49 A[4] A[5] B[3] PP1[5] X2i[1] Xi[1] / BS
XI29 A[5] A[5] B[1] PP0[6] X2i[0] Xi[0] / BS
XI27 A[3] A[4] B[1] PP0[4] X2i[0] Xi[0] / BS
XI15 GND A[0] B[1] PP0[0] X2i[0] Xi[0] / BS
XI16 A[0] A[1] B[1] PP0[1] X2i[0] Xi[0] / BS
XI26 A[2] A[3] B[1] PP0[3] X2i[0] Xi[0] / BS
XI25 A[1] A[2] B[1] PP0[2] X2i[0] Xi[0] / BS
XI48 A[5] A[5] B[3] PP1[6] X2i[1] Xi[1] / BS
XI47 A[3] A[4] B[3] PP1[4] X2i[1] Xi[1] / BS
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    DFF
* View Name:    schematic
************************************************************************

.SUBCKT DFF CLK D Q
*.PININFO CLK:I D:I Q:O
MM10 Q net4 GND GND N_18_G2 W=wn L=180n
MM9 net4 CLK net5 GND N_18_G2 W=wn L=180n
MM5 net2 D GND GND N_18_G2 W=wn L=180n
MM8 net5 net3 GND GND N_18_G2 W=wn L=180n
MM7 net1 CLK GND GND N_18_G2 W=wn L=180n
MM6 net3 net2 net1 GND N_18_G2 W=wn L=180n
MM12 net6 D VDD VDD P_18_G2 W=wp L=180n
MM1 net2 CLK net6 VDD P_18_G2 W=wp L=180n
MM2 net3 CLK VDD VDD P_18_G2 W=wp L=180n
MM4 Q net4 VDD VDD P_18_G2 W=wp L=180n
MM3 net4 net3 VDD VDD P_18_G2 W=wp L=180n
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    DFF_stage1
* View Name:    schematic
************************************************************************

.SUBCKT DFF_stage1 ACC0 ACC0_ ACC1 ACC1_ ACC2 ACC2_ ACC3 ACC3_ ACC4 ACC4_ ACC5 
+ ACC5_ ACC6 ACC6_ ACC7 ACC7_ ACC8 ACC8_ ACC9 ACC9_ ACC10 ACC10_ ACC11 ACC11_ 
+ B1 B3 B5 B[1] B[3] B[5] CLK MODE MODE0 PP00 PP0[0] PP0[1] PP0[2] PP0[3] 
+ PP0[4] PP0[5] PP0[6] PP01 PP1[0] PP1[1] PP1[2] PP1[3] PP1[4] PP1[5] PP1[6] 
+ PP02 PP2[0] PP2[1] PP2[2] PP2[3] PP2[4] PP2[5] PP2[6] PP03 PP04 PP05 PP06 
+ PP10 PP11 PP12 PP13 PP14 PP15 PP16 PP20 PP21 PP22 PP23 PP24 PP25 PP26
*.PININFO ACC0:I ACC1:I ACC2:I ACC3:I ACC4:I ACC5:I ACC6:I ACC7:I ACC8:I 
*.PININFO ACC9:I ACC10:I ACC11:I B[1]:I B[3]:I B[5]:I MODE:I PP0[0]:I PP0[1]:I 
*.PININFO PP0[2]:I PP0[3]:I PP0[4]:I PP0[5]:I PP0[6]:I PP1[0]:I PP1[1]:I 
*.PININFO PP1[2]:I PP1[3]:I PP1[4]:I PP1[5]:I PP1[6]:I PP2[0]:I PP2[1]:I 
*.PININFO PP2[2]:I PP2[3]:I PP2[4]:I PP2[5]:I PP2[6]:I ACC0_:O ACC1_:O ACC2_:O 
*.PININFO ACC3_:O ACC4_:O ACC5_:O ACC6_:O ACC7_:O ACC8_:O ACC9_:O ACC10_:O 
*.PININFO ACC11_:O B1:O B3:O B5:O MODE0:O PP00:O PP01:O PP02:O PP03:O PP04:O 
*.PININFO PP05:O PP06:O PP10:O PP11:O PP12:O PP13:O PP14:O PP15:O PP16:O 
*.PININFO PP20:O PP21:O PP22:O PP23:O PP24:O PP25:O PP26:O CLK:B
XI36 CLK ACC10 ACC10_ / DFF
XI35 CLK ACC11 ACC11_ / DFF
XI34 CLK ACC3 ACC3_ / DFF
XI33 CLK ACC7 ACC7_ / DFF
XI32 CLK ACC9 ACC9_ / DFF
XI31 CLK ACC8 ACC8_ / DFF
XI30 CLK ACC5 ACC5_ / DFF
XI29 CLK ACC6 ACC6_ / DFF
XI28 CLK ACC4 ACC4_ / DFF
XI27 CLK B[1] B1 / DFF
XI26 CLK ACC0 ACC0_ / DFF
XI25 CLK ACC2 ACC2_ / DFF
XI24 CLK ACC1 ACC1_ / DFF
XI23 CLK B[5] B5 / DFF
XI22 CLK MODE MODE0 / DFF
XI21 CLK B[3] B3 / DFF
XI37 CLK PP2[0] PP20 / DFF
XI19 CLK PP2[4] PP24 / DFF
XI18 CLK PP2[6] PP26 / DFF
XI17 CLK PP2[5] PP25 / DFF
XI16 CLK PP2[2] PP22 / DFF
XI15 CLK PP2[3] PP23 / DFF
XI14 CLK PP2[1] PP21 / DFF
XI13 CLK PP1[0] PP10 / DFF
XI12 CLK PP1[4] PP14 / DFF
XI11 CLK PP1[6] PP16 / DFF
XI10 CLK PP1[5] PP15 / DFF
XI9 CLK PP1[2] PP12 / DFF
XI8 CLK PP1[3] PP13 / DFF
XI7 CLK PP1[1] PP11 / DFF
XI6 CLK PP0[4] PP04 / DFF
XI5 CLK PP0[6] PP06 / DFF
XI4 CLK PP0[5] PP05 / DFF
XI3 CLK PP0[2] PP02 / DFF
XI2 CLK PP0[3] PP03 / DFF
XI1 CLK PP0[1] PP01 / DFF
XI0 CLK PP0[0] PP00 / DFF
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    AND
* View Name:    schematic
************************************************************************

.SUBCKT AND A B OUT
*.PININFO A:I B:I OUT:O
MM5 net1 B VDD VDD P_18_G2 W=wp L=180n
MM3 OUT net1 VDD VDD P_18_G2 W=wp L=180n
MM0 net1 A VDD VDD P_18_G2 W=wp L=180n
MM4 OUT net1 GND GND N_18_G2 W=wn L=180n
MM2 net2 B GND GND N_18_G2 W=wn L=180n
MM1 net1 A net2 GND N_18_G2 W=wn L=180n
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    HA
* View Name:    schematic
************************************************************************

.SUBCKT HA A B COUT SUM
*.PININFO A:I B:I COUT:O SUM:O
XI0 A B COUT / AND
XI1 A B SUM / XOR
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    FA
* View Name:    schematic
************************************************************************

.SUBCKT FA A B CIN COUT SUM
*.PININFO A:I B:I CIN:I COUT:O SUM:O
MM9 SUM_BAR COUT_BAR net10 GND N_18_G2 W=wn L=180n
MM3 COUT_BAR CIN net70 GND N_18_G2 W=wn L=180n
MM1 COUT_BAR B net67 GND N_18_G2 W=wn L=180n
MM11 SUM_BAR CIN net62 GND N_18_G2 W=wn L=180n
MM10 net62 B net63 GND N_18_G2 W=wn L=180n
MM8 net10 B GND GND N_18_G2 W=wn L=180n
MM7 net10 A GND GND N_18_G2 W=wn L=180n
MM6 net10 CIN GND GND N_18_G2 W=wn L=180n
MM5 net70 B GND GND N_18_G2 W=wn L=180n
MM4 net70 A GND GND N_18_G2 W=wn L=180n
MM2 net67 A GND GND N_18_G2 W=wn L=180n
MM12 net63 A GND GND N_18_G2 W=wn L=180n
XI1 COUT_BAR COUT / INV
XI0 SUM_BAR SUM / INV
MM23 net65 A VDD VDD P_18_G2 W=wp L=180n
MM22 net64 B net65 VDD P_18_G2 W=wp L=180n
MM13 net68 A VDD VDD P_18_G2 W=wp L=180n
MM19 net1 B VDD VDD P_18_G2 W=wp L=180n
MM18 net1 A VDD VDD P_18_G2 W=wp L=180n
MM17 net1 CIN VDD VDD P_18_G2 W=wp L=180n
MM16 net71 B VDD VDD P_18_G2 W=wp L=180n
MM15 net71 A VDD VDD P_18_G2 W=wp L=180n
MM21 SUM_BAR CIN net64 VDD P_18_G2 W=wp L=180n
MM20 SUM_BAR COUT_BAR net1 VDD P_18_G2 W=wp L=180n
MM0 COUT_BAR B net68 VDD P_18_G2 W=wp L=180n
MM14 COUT_BAR CIN net71 VDD P_18_G2 W=wp L=180n
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    CSA1
* View Name:    schematic
************************************************************************

.SUBCKT CSA1 ACC1_ ACC3_ B1 B3 C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 PP00 
+ PP01 PP02 PP03 PP04 PP05 PP06 PP10 PP11 PP12 PP13 PP14 PP15 PP16 PP20 PP21 
+ PP22 PP23 PP24 PP25 PP26 S0 S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 S11 S12
*.PININFO ACC1_:I ACC3_:I B1:I B3:I PP00:I PP01:I PP02:I PP03:I PP04:I PP05:I 
*.PININFO PP06:I PP10:I PP11:I PP12:I PP13:I PP14:I PP15:I PP16:I PP20:I 
*.PININFO PP21:I PP22:I PP23:I PP24:I PP25:I PP26:I C0:O C1:O C2:O C3:O C4:O 
*.PININFO C5:O C6:O C7:O C8:O C9:O C10:O C11:O C12:O S0:O S1:O S2:O S3:O S4:O 
*.PININFO S5:O S6:O S7:O S8:O S9:O S10:O S11:O S12:O
XI1 PP01 ACC1_ C1 S1 / HA
XI0 PP00 B1 C0 S0 / HA
XI13 PP06 PP16 PP26 C12 S12 / FA
XI12 PP06 PP16 PP26 C11 S11 / FA
XI11 PP06 PP16 PP26 C10 S10 / FA
XI10 PP06 PP16 PP25 C9 S9 / FA
XI9 PP06 PP16 PP24 C8 S8 / FA
XI8 PP06 PP15 PP23 C7 S7 / FA
XI7 PP06 PP14 PP22 C6 S6 / FA
XI6 PP05 PP13 PP21 C5 S5 / FA
XI5 PP04 PP12 PP20 C4 S4 / FA
XI4 PP03 PP11 ACC3_ C3 S3 / FA
XI2 PP02 PP10 B3 C2 S2 / FA
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    CSA2
* View Name:    schematic
************************************************************************

.SUBCKT CSA2 ACC0_ ACC2_ B5 C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C13 C14 C15 
+ C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 MODE0 S0 S1 S2 S3 S4 S5 S6 S7 S8 S9 
+ S10 S11 S12 S13 S14 S15 S16 S17 S18 S19 S20 S21 S22 S23 S24 S25
*.PININFO ACC0_:I ACC2_:I B5:I C0:I C1:I C2:I C3:I C4:I C5:I C6:I C7:I C8:I 
*.PININFO C9:I C10:I C11:I MODE0:I S0:I S1:I S2:I S3:I S4:I S5:I S6:I S7:I 
*.PININFO S8:I S9:I S10:I S11:I S12:I C13:O C14:O C15:O C16:O C17:O C18:O 
*.PININFO C19:O C20:O C21:O C22:O C23:O C24:O C25:O S13:O S14:O S15:O S16:O 
*.PININFO S17:O S18:O S19:O S20:O S21:O S22:O S23:O S24:O S25:O
XI5 S4 C3 B5 C17 S17 / FA
XI3 S2 C1 ACC2_ C15 S15 / FA
XI0 S0 ACC0_ MODE0 C13 S13 / FA
XI13 S12 C11 C25 S25 / HA
XI12 S11 C10 C24 S24 / HA
XI11 S10 C9 C23 S23 / HA
XI10 S9 C8 C22 S22 / HA
XI9 S8 C7 C21 S21 / HA
XI8 S7 C6 C20 S20 / HA
XI7 S6 C5 C19 S19 / HA
XI6 S5 C4 C18 S18 / HA
XI4 S3 C2 C16 S16 / HA
XI1 S1 C0 C14 S14 / HA
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    CSA3
* View Name:    schematic
************************************************************************

.SUBCKT CSA3 ACC4_ ACC5_ ACC6_ ACC7_ ACC8_ ACC9_ ACC10_ ACC11_ C13 C14 C15 C16 
+ C17 C18 C19 C20 C21 C22 C23 C24 C26 C27 C28 C29 C30 C31 C32 C33 C34 C35 C36 
+ C37 S14 S15 S16 S17 S18 S19 S20 S21 S22 S23 S24 S25 S26 S27 S28 S29 S30 S31 
+ S32 S33 S34 S35 S36 S37
*.PININFO ACC4_:I ACC5_:I ACC6_:I ACC7_:I ACC8_:I ACC9_:I ACC10_:I ACC11_:I 
*.PININFO C13:I C14:I C15:I C16:I C17:I C18:I C19:I C20:I C21:I C22:I C23:I 
*.PININFO C24:I S14:I S15:I S16:I S17:I S18:I S19:I S20:I S21:I S22:I S23:I 
*.PININFO S24:I S25:I C26:O C27:O C28:O C29:O C30:O C31:O C32:O C33:O C34:O 
*.PININFO C35:O C36:O C37:O S26:O S27:O S28:O S29:O S30:O S31:O S32:O S33:O 
*.PININFO S34:O S35:O S36:O S37:O
XI11 S25 C24 ACC11_ C37 S37 / FA
XI10 S24 C23 ACC11_ C36 S36 / FA
XI9 S23 C22 ACC10_ C35 S35 / FA
XI8 S22 C21 ACC9_ C34 S34 / FA
XI7 S21 C20 ACC8_ C33 S33 / FA
XI6 S20 C19 ACC7_ C32 S32 / FA
XI5 S19 C18 ACC6_ C31 S31 / FA
XI4 S18 C17 ACC5_ C30 S30 / FA
XI0 S17 C16 ACC4_ C29 S29 / FA
XI2 S15 C14 C27 S27 / HA
XI3 S16 C15 C28 S28 / HA
XI1 S14 C13 C26 S26 / HA
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    PSEUDO_FA_BAR
* View Name:    schematic
************************************************************************

.SUBCKT PSEUDO_FA_BAR A B CIN COUT_BAR SUM_BAR
*.PININFO A:I B:I CIN:I COUT_BAR:O SUM_BAR:O
MM24 net1 CIN GND GND N_18_G2 W=wn_pseudo L=180n
MM25 net78 B GND GND N_18_G2 W=wn_pseudo L=180n
MM1 COUT_BAR B net76 GND N_18_G2 W=wn_pseudo L=180n
MM23 net73 A GND GND N_18_G2 W=wn_pseudo L=180n
MM22 net72 B net73 GND N_18_G2 W=wn_pseudo L=180n
MM19 net1 A GND GND N_18_G2 W=wn_pseudo L=180n
MM18 SUM_BAR CIN net72 GND N_18_G2 W=wn_pseudo L=180n
MM17 SUM_BAR COUT_BAR net1 GND N_18_G2 W=wn_pseudo L=180n
MM16 net78 A GND GND N_18_G2 W=wn_pseudo L=180n
MM15 net76 A GND GND N_18_G2 W=wn_pseudo L=180n
MM14 COUT_BAR CIN net78 GND N_18_G2 W=wn_pseudo L=180n
MM21 net1 B GND GND N_18_G2 W=wn_pseudo L=180n
MM0 SUM_BAR GND VDD VDD P_18_G2 W=wp_pseudo L=180n
MM20 COUT_BAR GND VDD VDD P_18_G2 W=wp_pseudo L=180n
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    RCA4
* View Name:    schematic
************************************************************************

.SUBCKT RCA4 A0 A1 A2 A3 B0 B1 B2 B3 CIN COUT SUM0 SUM1 SUM2 SUM3
*.PININFO A0:I A1:I A2:I A3:I B0:I B1:I B2:I B3:I CIN:I COUT:O SUM0:O SUM1:O 
*.PININFO SUM2:O SUM3:O
XI10 A0 B0 CIN net1 SUM0 / PSEUDO_FA_BAR
XI11 A1_BAR B1_BAR net1 net2 SUM1 / PSEUDO_FA_BAR
XI12 A2 B2 net2 net3 SUM2 / PSEUDO_FA_BAR
XI13 A3_BAR B3_BAR net3 COUT SUM3 / PSEUDO_FA_BAR
XI7 B3 B3_BAR / INV
XI6 A3 A3_BAR / INV
XI5 B1 B1_BAR / INV
XI4 A1 A1_BAR / INV
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    DFF_inverting
* View Name:    schematic
************************************************************************

.SUBCKT DFF_inverting CLK D Q
*.PININFO CLK:I D:I Q:O
MM9 Q CLK net26 GND N_18_G2 W=wn L=180n
MM6 net11 net1 net24 GND N_18_G2 W=wn L=180n
MM5 net1 D GND GND N_18_G2 W=wn L=180n
MM8 net26 net11 GND GND N_18_G2 W=wn L=180n
MM7 net24 CLK GND GND N_18_G2 W=wn L=180n
MM12 net4 D VDD VDD P_18_G2 W=wp L=180n
MM2 net11 CLK VDD VDD P_18_G2 W=wp L=180n
MM3 Q net11 VDD VDD P_18_G2 W=wp L=180n
MM1 net1 CLK net4 VDD P_18_G2 W=wp L=180n
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    DFF_stage2
* View Name:    schematic
************************************************************************

.SUBCKT DFF_stage2 C30 C30_ C31 C31_ C32 C32_ C33 C33_ C34 C34_ C35 C35_ C36 
+ C36_ CARRY CARRY_ CLK OUT0 OUT1 OUT2 OUT3 OUT4 OUT5 S13 S26 S31 S31_ S32 
+ S32_ S33 S33_ S34 S34_ S35 S35_ S36 S36_ S37 S37_ SUM2 SUM3 SUM4 SUM5
*.PININFO C30:I C31:I C32:I C33:I C34:I C35:I C36:I CARRY:I S13:I S26:I S31:I 
*.PININFO S32:I S33:I S34:I S35:I S36:I S37:I SUM2:I SUM3:I SUM4:I SUM5:I 
*.PININFO C30_:O C31_:O C32_:O C33_:O C34_:O C35_:O C36_:O CARRY_:O OUT0:O 
*.PININFO OUT1:O OUT2:O OUT3:O OUT4:O OUT5:O S31_:O S32_:O S33_:O S34_:O 
*.PININFO S35_:O S36_:O S37_:O CLK:B
XI18 CLK SUM5 OUT5 / DFF
XI17 CLK SUM3 OUT3 / DFF
XI16 CLK CARRY CARRY_ / DFF
XI14 CLK S37 S37_ / DFF
XI11 CLK S35 S35_ / DFF
XI10 CLK S33 S33_ / DFF
XI9 CLK S31 S31_ / DFF
XI7 CLK C36 C36_ / DFF
XI5 CLK C34 C34_ / DFF
XI4 CLK C32 C32_ / DFF
XI3 CLK C30 C30_ / DFF
XI1 CLK S26 OUT1 / DFF
XI0 CLK S13 OUT0 / DFF
XI26 CLK S34 S34_ / DFF_inverting
XI21 CLK SUM4 OUT4 / DFF_inverting
XI22 CLK SUM2 OUT2 / DFF_inverting
XI24 CLK C31 C31_ / DFF_inverting
XI27 CLK C35 C35_ / DFF_inverting
XI28 CLK S36 S36_ / DFF_inverting
XI23 CLK S32 S32_ / DFF_inverting
XI25 CLK C33 C33_ / DFF_inverting
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    FA_BAR
* View Name:    schematic
************************************************************************

.SUBCKT FA_BAR A B CIN COUT_BAR SUM_BAR
*.PININFO A:I B:I CIN:I COUT_BAR:O SUM_BAR:O
MM6 net10 A GND GND N_18_G2 W=wn_FA L=180n
MM15 COUT_BAR B net67 GND N_18_G2 W=wn_FA L=180n
MM13 net70 A GND GND N_18_G2 W=wn_FA L=180n
MM11 SUM_BAR CIN net62 GND N_18_G2 W=wn_FA L=180n
MM10 net10 CIN GND GND N_18_G2 W=wn_FA L=180n
MM8 net62 B net63 GND N_18_G2 W=wn_FA L=180n
MM7 net10 B GND GND N_18_G2 W=wn_FA L=180n
MM0 SUM_BAR COUT_BAR net10 GND N_18_G2 W=wn_FA L=180n
MM16 COUT_BAR CIN net70 GND N_18_G2 W=wn_FA L=180n
MM12 net70 B GND GND N_18_G2 W=wn_FA L=180n
MM14 net67 A GND GND N_18_G2 W=wn_FA L=180n
MM9 net63 A GND GND N_18_G2 W=wn_FA L=180n
MM23 net65 A VDD VDD P_18_G2 W=wp_FA L=180n
MM22 SUM_BAR CIN net64 VDD P_18_G2 W=wp_FA L=180n
MM24 net1 B VDD VDD P_18_G2 W=wp_FA L=180n
MM32 COUT_BAR CIN net71 VDD P_18_G2 W=wp_FA L=180n
MM31 COUT_BAR B net4 VDD P_18_G2 W=wp_FA L=180n
MM30 net4 A VDD VDD P_18_G2 W=wp_FA L=180n
MM28 net71 B VDD VDD P_18_G2 W=wp_FA L=180n
MM27 net1 CIN VDD VDD P_18_G2 W=wp_FA L=180n
MM21 net64 B net65 VDD P_18_G2 W=wp_FA L=180n
MM29 net71 A VDD VDD P_18_G2 W=wp_FA L=180n
MM25 SUM_BAR COUT_BAR net1 VDD P_18_G2 W=wp_FA L=180n
MM26 net1 A VDD VDD P_18_G2 W=wp_FA L=180n
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    RCA7
* View Name:    schematic
************************************************************************

.SUBCKT RCA7 A0 A1 A2 A3 A4 A5 A6 B0 B1 B2 B3 B4 B5 B6 CIN COUT_BAR SUM0 SUM1 
+ SUM2 SUM3 SUM4 SUM5 SUM6
*.PININFO A0:I A1:I A2:I A3:I A4:I A5:I A6:I B0:I B1:I B2:I B3:I B4:I B5:I 
*.PININFO B6:I CIN:I COUT_BAR:O SUM0:O SUM1:O SUM2:O SUM3:O SUM4:O SUM5:O 
*.PININFO SUM6:O
XI34 A0 B0 CIN net1 SUM0 / FA_BAR
XI32 A6 B6 net6 COUT_BAR SUM6 / FA_BAR
XI31 A5 B5 net5 net6 SUM5 / FA_BAR
XI30 A4 B4 net4 net5 SUM4 / FA_BAR
XI29 A3 B3 net3 net4 SUM3 / FA_BAR
XI28 A2 B2 net2 net3 SUM2 / FA_BAR
XI27 A1 B1 net1 net2 SUM1 / FA_BAR
.ENDS

************************************************************************
* Library Name: FP
* Cell Name:    DFF_stage3
* View Name:    schematic
************************************************************************

.SUBCKT DFF_stage3 CLK OUT0 OUT1 OUT2 OUT3 OUT4 OUT5 OUT6 OUT7 OUT8 OUT9 OUT10 
+ OUT11 OUT12 OUT[0] OUT[1] OUT[2] OUT[3] OUT[4] OUT[5] OUT[6] OUT[7] OUT[8] 
+ OUT[9] OUT[10] OUT[11] OUT[12]
*.PININFO OUT0:I OUT1:I OUT2:I OUT3:I OUT4:I OUT5:I OUT6:I OUT7:I OUT8:I 
*.PININFO OUT9:I OUT10:I OUT11:I OUT12:I OUT[0]:O OUT[1]:O OUT[2]:O OUT[3]:O 
*.PININFO OUT[4]:O OUT[5]:O OUT[6]:O OUT[7]:O OUT[8]:O OUT[9]:O OUT[10]:O 
*.PININFO OUT[11]:O OUT[12]:O CLK:B
XI12 CLK OUT11 OUT[11] / DFF
XI9 CLK OUT9 OUT[9] / DFF
XI8 CLK OUT2 OUT[2] / DFF
XI6 CLK OUT7 OUT[7] / DFF
XI5 CLK OUT3 OUT[3] / DFF
XI4 CLK OUT4 OUT[4] / DFF
XI3 CLK OUT5 OUT[5] / DFF
XI2 CLK OUT1 OUT[1] / DFF
XI0 CLK OUT0 OUT[0] / DFF
XI18 CLK OUT6 OUT[6] / DFF_inverting
XI20 CLK OUT8 OUT[8] / DFF_inverting
XI19 CLK OUT10 OUT[10] / DFF_inverting
XI21 CLK OUT12 OUT[12] / DFF_inverting
.ENDS


.end


