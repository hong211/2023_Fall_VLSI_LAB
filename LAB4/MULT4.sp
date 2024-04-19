****  Lab04: 4-bit Multiplier  ***

*************************************************************
*************************************************************
***************Don't touch settings below********************
*************************************************************
*************************************************************
.lib "../../umc018.l" L18U18V_TT
.vec 'MULT4.vec'

.temp 25
.op
.options post

***************** parameter ****************************
.global  VDD  GND
.param supply = 1.8v
.param load = 10f
.param tr = 0.2n

***************** voltage source ****************************
Vclk CLK GND pulse(0 supply 0 0.1ns 0.1ns "1*period/2-tr" "period*1")
Vd1 VDD GND supply


***************** top-circuit ****************************
XMULT4 A[3] A[2] A[1] A[0]
+ B[3] B[2] B[1] B[0]
+ CLK
+ OUT[7] OUT[6] OUT[5] OUT[4] OUT[3] OUT[2] OUT[1] OUT[0] MULT4

C0 OUT[0] GND load
C1 OUT[1] GND load
C2 OUT[2] GND load
C3 OUT[3] GND load
C4 OUT[4] GND load
C5 OUT[5] GND load
C6 OUT[6] GND load
C7 OUT[7] GND load


***************** Average Power ****************************
.meas tran Iavg avg I(Vd1) from=0ns to='257*period'
.meas Pavg param='abs(Iavg)*supply'

.meas tran AVG_Ckt_Pwr AVG power
.meas tran avg_power avg power from=0.1ns to='257*period'

.tran 0.1n '257*period'

*************************************************************
*************************************************************
***************Don't touch settings above********************
*************************************************************
*************************************************************


***** you can modify clock cycle here, remember synchronize with clock cycle in MULT4.vec ****
.param period = 0.55n

***** Define your sub-circuit and self-defined parameter here , and only need to submmit this part ****
.param wp=460n
.param wn=440n

.param wpdff=0.78u
.param wndff=0.44u


.subckt MULT4 A[3] A[2] A[1] A[0] 
+ B[3] B[2] B[1] B[0] 
+ CLK
+ OUT[7] OUT[6] OUT[5] OUT[4] OUT[3] OUT[2] OUT[1] OUT[0]

x1_dff CLK A[0] A[0]_ dff
x2_dff CLK A[1] A[1]_ dff
x3_dff CLK A[2] A[2]_ dff
x4_dff CLK A[3] A[3]_ dff
x5_dff CLK B[0] B[0]_ dff
x6_dff CLK B[1] B[1]_ dff
x7_dff CLK B[2] B[2]_ dff
x8_dff CLK B[3] B[3]_ dff

x9_dff CLK OUT[0]_ OUT[0] dff
x10_dff CLK OUT[1]_ OUT[1] dff
x11_dff CLK OUT[2]_ OUT[2] dff
x12_dff CLK OUT[3]_ OUT[3] dff
x13_dff CLK OUT[4]_ OUT[4] dff
x14_dff CLK OUT[5]_ OUT[5] dff
x15_dff CLK OUT[6]_ OUT[6] dff
x16_dff CLK OUT[7]_ OUT[7] dff

x1 A[0]_ B[0]_ OUT[0]_ pseudo_and
x5 A[0]_ B[1]_ net4 pseudo_nand
x9 A[0]_ B[2]_ net8 pseudo_nand
x4 A[0]_ B[3]_ net3 pseudo_and


x2 A[1]_ B[0]_ net1 pseudo_nand
x6 A[1]_ B[1]_ net5 pseudo_nand
x10 A[1]_ B[2]_ net9 pseudo_nand
x8 A[1]_ B[3]_ net7 pseudo_and

x3 A[2]_ B[0]_ net2 pseudo_nand
x7 A[2]_ B[1]_ net6 pseudo_nand
x11 A[2]_ B[2]_ net10 pseudo_nand
x12 A[2]_ B[3]_ net11 pseudo_nand

x13 A[3]_ B[0]_ net12 pseudo_nand
x14 A[3]_ B[1]_ net13 pseudo_nand
x15 A[3]_ B[2]_ net14 pseudo_nand
x16 A[3]_ B[3]_ net15 pseudo_and

xha1 net1 net4 c1 OUT[1]_ ha_bar
xfA2 net2 net5 net8 c2 s2 FA_bar
xfA3 net3 net6 net9 c3 s3 FA_bar
xfA4 gnd net7 net10 c4 s4 FA_bar
xha5 net11 net14 c5 s5 ha

xha6 s2 c1 c6 OUT[2]_ ha
xfA7 c2 s3 net12 c7 s7 FA
xfA8 s4 c3 net13 c8 s8 FA
xhA9 s5 c4 c9 s9 ha
xha10 net15 c5 c10 s10 ha


xha11 s7 c6 c11 OUT[3]_ ha
xfa4bit vdd s10 s9 s8 c10 c9 c8 c7 c11 OUT[7]_ OUT[6]_ OUT[5]_ OUT[4]_ co FA4
.ends

.SUBCKT FA4 A[3] A[2] A[1] A[0] B[3] B[2] B[1] B[0] CIN SUM[3] SUM[2] SUM[1] SUM[0] COUT
xinv1 A[1] A[1]_BAR INV
xinv2 B[1] B[1]_BAR INV
xinv3 A[3] A[3]_BAR INV
xinv4 B[3] B[3]_BAR INV
xinv5 SUM0_BAR SUM[0] INV
xinv6 SUM2_BAR SUM[2] INV

xFA1 A[0] B[0] CIN COUT_1_BAR SUM0_BAR FA_bar
xFA2 A[1]_BAR B[1]_BAR COUT_1_BAR COUT_2 SUM[1] FA_bar
xFA3 A[2] B[2] COUT_2 COUT_3_BAR SUM2_BAR FA_bar
xFA4 A[3]_BAR B[3]_BAR COUT_3_BAR COUT SUM[3] FA_bar 

.ends

.SUBCKT pseudo_and A B OUT
MM3 OUT GND VDD VDD P_18_G2 W=wp L=180n
MM0 net1 GND VDD VDD P_18_G2 W=wp L=180n
MM4 OUT net1 GND GND N_18_G2 W=wn L=180n
MM2 net2 B GND GND N_18_G2 W=wn L=180n
MM1 net1 A net2 GND N_18_G2 W=wn L=180n
.ENDS

.SUBCKT pseudo_nand A B OUT
MM0 OUT GND VDD VDD P_18_G2 W=wp L=180n
MM2 net1 B GND GND N_18_G2 W=wn L=180n
MM1 OUT A net1 GND N_18_G2 W=wn L=180n
.ENDS

.SUBCKT DFF CLK D Q
MM10 Q net4 GND GND N_18_G2 W=wndff L=180n
MM9 net4 CLK net5 GND N_18_G2 W=wndff L=180n
MM5 net2 D GND GND N_18_G2 W=wndff L=180n
MM8 net5 net3 GND GND N_18_G2 W=wndff L=180n
MM7 net1 CLK GND GND N_18_G2 W=wndff L=180n
MM6 net3 net2 net1 GND N_18_G2 W=wndff L=180n
MM1 net2 CLK VDD VDD P_18_G2 W=wpdff L=180n
MM2 net3 CLK VDD VDD P_18_G2 W=wpdff L=180n
MM4 Q net4 VDD VDD P_18_G2 W=wpdff L=180n
MM3 net4 net3 VDD VDD P_18_G2 W=wpdff L=180n
.ENDS

.SUBCKT FA_bar A B CIN COUT_BAR SUM_BAR
MM13 SUM_BAR GND VDD VDD P_18_G2 W=wp L=180n
MM0 COUT_BAR GND VDD VDD P_18_G2 W=wp L=180n
MM12 net2 A GND GND N_18_G2 W=wn L=180n
MM10 net5 B net2 GND N_18_G2 W=wn L=180n
MM9 SUM_BAR COUT_BAR net4 GND N_18_G2 W=wn L=180n
MM8 net4 B GND GND N_18_G2 W=wn L=180n
MM7 net4 A GND GND N_18_G2 W=wn L=180n
MM6 net4 CIN GND GND N_18_G2 W=wn L=180n
MM5 net3 B GND GND N_18_G2 W=wn L=180n
MM4 net3 A GND GND N_18_G2 W=wn L=180n
MM3 COUT_BAR CIN net3 GND N_18_G2 W=wn L=180n
MM2 net1 A GND GND N_18_G2 W=wn L=180n
MM1 COUT_BAR B net1 GND N_18_G2 W=wn L=180n
MM11 SUM_BAR CIN net5 GND N_18_G2 W=wn L=180n
.ENDS

.SUBCKT FA A B CIN COUT SUM
MM13 SUM_BAR GND VDD VDD P_18_G2 W=wp L=180n
MM0 COUT_BAR GND VDD VDD P_18_G2 W=wp L=180n
MM12 net2 A GND GND N_18_G2 W=wn L=180n
MM10 net5 B net2 GND N_18_G2 W=wn L=180n
MM9 SUM_BAR COUT_BAR net4 GND N_18_G2 W=wn L=180n
MM8 net4 B GND GND N_18_G2 W=wn L=180n
MM7 net4 A GND GND N_18_G2 W=wn L=180n
MM6 net4 CIN GND GND N_18_G2 W=wn L=180n
MM5 net3 B GND GND N_18_G2 W=wn L=180n
MM4 net3 A GND GND N_18_G2 W=wn L=180n
MM3 COUT_BAR CIN net3 GND N_18_G2 W=wn L=180n
MM2 net1 A GND GND N_18_G2 W=wn L=180n
MM1 COUT_BAR B net1 GND N_18_G2 W=wn L=180n
MM11 SUM_BAR CIN net5 GND N_18_G2 W=wn L=180n
MM14 COUT GND VDD VDD P_18_G2 W=wp L=180n
MM15 SUM GND VDD VDD P_18_G2 W=wp L=180n
MM16 COUT COUT_BAR GND GND N_18_G2 W=wn L=180n
MM17 SUM SUM_BAR GND GND N_18_G2 W=wn L=180n
.ENDS

.SUBCKT ha A B cout sum
xor A B sum xor
xnand A B cout pseudo_and
.ENDS

.SUBCKT ha_bar A B cout sum
xor A B sum xor
xnor A B cout nor
.ends


.subckt nor A B OUT
M1 OUT GND VDD VDD P_18_G2 w=wp l=180n
M4 OUT A GND GND N_18_G2 w=wn l=180n
M5 OUT B GND GND N_18_G2 w=wn l=180n
.ends

.subckt xor A B OUT
xinv1 A Abar inv
xinv2 B Bbar inv
M1 OUT GND VDD VDD P_18_G2 w=wp l=180n
M2 OUT Abar net1 GND N_18_G2 w=wn l=180n
M3 net1 Bbar GND GND N_18_G2 w=wn l=180n
M4 OUT A net2 GND N_18_G2 w=wn l=180n
M5 net2 B GND GND N_18_G2 w=wn l=180n
.ends

.subckt inv in out 
MM1 out GND VDD VDD P_18_G2 W=wp L=180n
MM2 out in GND GND N_18_G2 W=wn L=180n
.ends


.end
