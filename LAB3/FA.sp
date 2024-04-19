****  Lab03: 4-bit FA  ***

*************************************************************
*************************************************************
***************Don't touch settings below********************
*************************************************************
*************************************************************
.lib "../../umc018.l" L18U18V_TT 
.vec 'FA4.vec'
.temp 25
.op
.options brief post

***************** parameter ****************************
.global  VDD  GND
.param supply = 1.8v
.param load = 10f
.param tr = 0.2n

***************** voltage source ****************************
Vclk CLK GND pulse(0 supply 0 0.1ns 0.1ns "1*period/2-tr" "period*1")
Vd1 VDD GND supply


***************** top-circuit ****************************
XFA CLK A[3] A[2] A[1] A[0] 
+ B[3] B[2] B[1] B[0] CIN 
+ SUM[3] SUM[2] SUM[1] SUM[0] COUT FA4

C0 SUM[0] GND load
C1 SUM[1] GND load
C2 SUM[2] GND load
C3 SUM[3] GND load
C4 COUT   GND load

***************** Average Power ****************************
.meas tran Iavg avg I(Vd1) from=0ns to='50*period'
.meas Pavg param='abs(Iavg)*supply'

.tran 0.1n '50*period'

*************************************************************
*************************************************************
***************Don't touch settings above********************
*************************************************************
*************************************************************


***** you can modify clock cycle here, remember synchronize with clock cycle in FA4.vec ****
.param period = 0.49n

***** Define your sub-circuit and self-defined parameter here , and only need to submmit this part ****
.param wp=440n
.param wn=580n

.param wpdff=720n
.param wndff=440n

.SUBCKT FA4 CLK A[3] A[2] A[1] A[0] B[3] B[2] B[1] B[0] CIN SUM[3] SUM[2] SUM[1] SUM[0] COUT 
xinv1 A[1] A[1]_BAR INV
xinv2 B[1] B[1]_BAR INV
xinv3 A[3] A[3]_BAR INV
xinv4 B[3] B[3]_BAR INV
xinv5 SUM0_BAR SUM0_temp INV
xinv6 SUM2_BAR SUM2_temp INV

xFA1 A[0] B[0] CIN COUT_1_BAR SUM0_BAR FA_1
xFA2 A[1]_BAR B[1]_BAR COUT_1_BAR COUT_2 SUM1_temp FA_1
xFA3 A[2] B[2] COUT_2 COUT_3_BAR SUM2_BAR FA_1
xFA4 A[3]_BAR B[3]_BAR COUT_3_BAR COUT_temp SUM3_temp FA_1 

xDFF1 CLK SUM0_temp SUM[0] DFF
xDFF2 CLK SUM1_temp SUM[1] DFF
xDFF3 CLK SUM2_temp SUM[2] DFF
xDFF4 CLK SUM3_temp SUM[3] DFF
xDFF5 CLK COUT_temp COUT DFF
.ends

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

.SUBCKT INV IN OUT
MM0 OUT IN GND GND N_18_G2 W=wn L=180n
MM1 OUT GND VDD VDD P_18_G2 W=wp L=180n
.ENDS

.SUBCKT FA_1 A B CIN COUT_BAR SUM_BAR
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

.end
