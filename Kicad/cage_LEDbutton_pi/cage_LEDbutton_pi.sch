EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L cage_LEDbutton_pi-rescue:LED_shift_register_SPI-additional_LED_drivers U9
U 1 1 5DC3894E
P 5550 4250
F 0 "U9" H 5575 4365 50  0000 C CNN
F 1 "LED_shift_register_SPI" H 5575 4274 50  0000 C CNN
F 2 "Package_SO:HTSSOP-28-1EP_4.4x9.7mm_P0.65mm_EP3.4x9.5mm" H 5550 4250 50  0001 C CNN
F 3 "/home/kevin/Documents/git/proc-kevin/Kicad/Libraries/PCA9745B.pdf" H 5550 4250 50  0001 C CNN
	1    5550 4250
	-1   0    0    -1  
$EndComp
Text Label 6300 4700 0    50   ~ 0
chipSelect-LED_5V
Wire Wire Line
	6050 4700 6300 4700
Text Label 6300 4600 0    50   ~ 0
MISO_5V
Wire Wire Line
	6050 4600 6300 4600
Text Label 1450 2700 2    50   ~ 0
MOSI_3V
Text Label 1450 2800 2    50   ~ 0
SCLK_3V
Text Label 5050 4600 2    50   ~ 0
SCLK_5V
Text Label 5050 4500 2    50   ~ 0
MOSI_5V
$Comp
L power:GND #PWR0101
U 1 1 5DC92189
P 1950 3600
F 0 "#PWR0101" H 1950 3350 50  0001 C CNN
F 1 "GND" H 1955 3427 50  0000 C CNN
F 2 "" H 1950 3600 50  0001 C CNN
F 3 "" H 1950 3600 50  0001 C CNN
	1    1950 3600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 5DC92993
P 6500 5300
F 0 "#PWR0102" H 6500 5050 50  0001 C CNN
F 1 "GND" H 6505 5127 50  0000 C CNN
F 2 "" H 6500 5300 50  0001 C CNN
F 3 "" H 6500 5300 50  0001 C CNN
	1    6500 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	6050 5300 6500 5300
Text Label 1450 2600 2    50   ~ 0
MISO_3V
Text Label 8300 2800 2    50   ~ 0
SCLK_3V
Text Label 8300 3450 2    50   ~ 0
chipSelect-LED_3V
Text Label 8300 4100 2    50   ~ 0
MISO_3V
Text Label 8300 4750 2    50   ~ 0
MOSI_3V
Text Label 9500 2800 0    50   ~ 0
SCLK_5V
Text Label 9500 3450 0    50   ~ 0
chipSelect-LED_5V
Text Label 9500 4100 0    50   ~ 0
MISO_5V
Text Label 9500 4750 0    50   ~ 0
MOSI_5V
Wire Notes Line
	7950 2300 9900 2300
Wire Notes Line
	9900 2300 9900 5100
Wire Notes Line
	9900 5100 7950 5100
Wire Notes Line
	7950 5100 7950 2300
Text Notes 8600 2250 0    50   ~ 10
Logic Level Shifting
$Comp
L Transistor_FET:BSN20 Q1
U 1 1 5DCC36DC
P 8900 2700
F 0 "Q1" V 9151 2700 50  0000 C CNN
F 1 "BSN20" V 8750 2850 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 9100 2625 50  0001 L CIN
F 3 "http://www.diodes.com/assets/Datasheets/ds31898.pdf" H 8900 2700 50  0001 L CNN
	1    8900 2700
	0    1    1    0   
$EndComp
$Comp
L Transistor_FET:BSN20 Q2
U 1 1 5DCCB66C
P 8900 3350
F 0 "Q2" V 9151 3350 50  0000 C CNN
F 1 "BSN20" V 8700 3500 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 9100 3275 50  0001 L CIN
F 3 "http://www.diodes.com/assets/Datasheets/ds31898.pdf" H 8900 3350 50  0001 L CNN
	1    8900 3350
	0    1    1    0   
$EndComp
$Comp
L Transistor_FET:BSN20 Q3
U 1 1 5DCCDB7A
P 8900 4000
F 0 "Q3" V 9151 4000 50  0000 C CNN
F 1 "BSN20" V 8700 4150 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 9100 3925 50  0001 L CIN
F 3 "http://www.diodes.com/assets/Datasheets/ds31898.pdf" H 8900 4000 50  0001 L CNN
	1    8900 4000
	0    1    1    0   
$EndComp
$Comp
L Transistor_FET:BSN20 Q4
U 1 1 5DCCFAB8
P 8900 4650
F 0 "Q4" V 9151 4650 50  0000 C CNN
F 1 "BSN20" V 8700 4800 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 9100 4575 50  0001 L CIN
F 3 "http://www.diodes.com/assets/Datasheets/ds31898.pdf" H 8900 4650 50  0001 L CNN
	1    8900 4650
	0    1    1    0   
$EndComp
Text Label 1450 2500 2    50   ~ 0
chipSelect-LED_3V
$Comp
L Device:R R10
U 1 1 5DD1ED41
P 8500 2650
F 0 "R10" H 8570 2696 50  0000 L CNN
F 1 "10k" H 8570 2605 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 8430 2650 50  0001 C CNN
F 3 "~" H 8500 2650 50  0001 C CNN
	1    8500 2650
	1    0    0    -1  
$EndComp
$Comp
L Device:R R14
U 1 1 5DD20707
P 9300 2650
F 0 "R14" H 9370 2696 50  0000 L CNN
F 1 "10k" H 9370 2605 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 9230 2650 50  0001 C CNN
F 3 "~" H 9300 2650 50  0001 C CNN
	1    9300 2650
	1    0    0    -1  
$EndComp
$Comp
L Device:R R11
U 1 1 5DD20C0F
P 8500 3300
F 0 "R11" H 8570 3346 50  0000 L CNN
F 1 "10k" H 8570 3255 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 8430 3300 50  0001 C CNN
F 3 "~" H 8500 3300 50  0001 C CNN
	1    8500 3300
	1    0    0    -1  
$EndComp
$Comp
L Device:R R15
U 1 1 5DD211AB
P 9300 3300
F 0 "R15" H 9370 3346 50  0000 L CNN
F 1 "10k" H 9370 3255 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 9230 3300 50  0001 C CNN
F 3 "~" H 9300 3300 50  0001 C CNN
	1    9300 3300
	1    0    0    -1  
$EndComp
$Comp
L Device:R R12
U 1 1 5DD22ACA
P 8500 3950
F 0 "R12" H 8570 3996 50  0000 L CNN
F 1 "10k" H 8570 3905 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 8430 3950 50  0001 C CNN
F 3 "~" H 8500 3950 50  0001 C CNN
	1    8500 3950
	1    0    0    -1  
$EndComp
$Comp
L Device:R R16
U 1 1 5DD231EE
P 9300 3950
F 0 "R16" H 9370 3996 50  0000 L CNN
F 1 "10k" H 9370 3905 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 9230 3950 50  0001 C CNN
F 3 "~" H 9300 3950 50  0001 C CNN
	1    9300 3950
	1    0    0    -1  
$EndComp
$Comp
L Device:R R13
U 1 1 5DD238A5
P 8500 4600
F 0 "R13" H 8570 4646 50  0000 L CNN
F 1 "10k" H 8570 4555 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 8430 4600 50  0001 C CNN
F 3 "~" H 8500 4600 50  0001 C CNN
	1    8500 4600
	1    0    0    -1  
$EndComp
$Comp
L Device:R R17
U 1 1 5DD23EF5
P 9300 4600
F 0 "R17" H 9370 4646 50  0000 L CNN
F 1 "10k" H 9370 4555 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 9230 4600 50  0001 C CNN
F 3 "~" H 9300 4600 50  0001 C CNN
	1    9300 4600
	1    0    0    -1  
$EndComp
Wire Wire Line
	8300 2800 8500 2800
Connection ~ 8500 2800
Wire Wire Line
	8500 2800 8700 2800
Wire Wire Line
	9100 2800 9300 2800
Connection ~ 9300 2800
Wire Wire Line
	9300 2800 9500 2800
Wire Wire Line
	8300 3450 8500 3450
Connection ~ 8500 3450
Wire Wire Line
	8500 3450 8700 3450
Wire Wire Line
	9100 3450 9300 3450
Connection ~ 9300 3450
Wire Wire Line
	9300 3450 9500 3450
Wire Wire Line
	8300 4100 8500 4100
Connection ~ 8500 4100
Wire Wire Line
	8500 4100 8700 4100
Wire Wire Line
	9100 4100 9300 4100
Connection ~ 9300 4100
Wire Wire Line
	9300 4100 9500 4100
Wire Wire Line
	9100 4750 9300 4750
Connection ~ 9300 4750
Wire Wire Line
	9300 4750 9500 4750
Wire Wire Line
	8700 4750 8500 4750
Connection ~ 8500 4750
Wire Wire Line
	8500 4750 8300 4750
Text Label 2450 1000 0    50   ~ 10
5V_source
Text Label 8500 2500 2    50   ~ 10
3V_source
Text Label 8500 3150 2    50   ~ 10
3V_source
Text Label 8500 3800 2    50   ~ 10
3V_source
Text Label 8500 4450 2    50   ~ 10
3V_source
Text Label 8900 3700 2    50   ~ 10
3V_source
Text Label 8900 4350 2    50   ~ 10
3V_source
Wire Wire Line
	8900 3800 8900 3700
Wire Wire Line
	8900 4450 8900 4350
Text Label 8900 3050 2    50   ~ 10
3V_source
Text Label 8900 2400 2    50   ~ 10
3V_source
Wire Wire Line
	8900 2400 8900 2500
Wire Wire Line
	8900 3050 8900 3150
Text Label 9300 4450 0    50   ~ 10
5V_source
Text Label 9300 3800 0    50   ~ 10
5V_source
Text Label 9300 3150 0    50   ~ 10
5V_source
Text Label 9300 2500 0    50   ~ 10
5V_source
$Comp
L power:GND #PWR0103
U 1 1 5DD7B007
P 4600 5300
F 0 "#PWR0103" H 4600 5050 50  0001 C CNN
F 1 "GND" H 4605 5127 50  0000 C CNN
F 2 "" H 4600 5300 50  0001 C CNN
F 3 "" H 4600 5300 50  0001 C CNN
	1    4600 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	5050 5300 4600 5300
$Comp
L power:GND #PWR0104
U 1 1 5DD85439
P 4600 4800
F 0 "#PWR0104" H 4600 4550 50  0001 C CNN
F 1 "GND" H 4605 4627 50  0000 C CNN
F 2 "" H 4600 4800 50  0001 C CNN
F 3 "" H 4600 4800 50  0001 C CNN
	1    4600 4800
	1    0    0    -1  
$EndComp
Wire Wire Line
	4600 4800 5050 4800
$Comp
L power:GND #PWR0105
U 1 1 5DD88137
P 6850 4500
F 0 "#PWR0105" H 6850 4250 50  0001 C CNN
F 1 "GND" H 7000 4450 50  0000 C CNN
F 2 "" H 6850 4500 50  0001 C CNN
F 3 "" H 6850 4500 50  0001 C CNN
	1    6850 4500
	1    0    0    -1  
$EndComp
Wire Wire Line
	6050 4500 6850 4500
$Comp
L Connector:USB_B_Micro J2
U 1 1 5DD902A6
P 5450 2300
F 0 "J2" H 5507 2767 50  0000 C CNN
F 1 "USB_B_Micro" H 5507 2676 50  0000 C CNN
F 2 "Connector_USB:USB_Micro-B_Amphenol_10103594-0001LF_Horizontal" H 5600 2250 50  0001 C CNN
F 3 "~" H 5600 2250 50  0001 C CNN
	1    5450 2300
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0106
U 1 1 5DDC07AB
P 5900 2100
F 0 "#PWR0106" H 5900 1950 50  0001 C CNN
F 1 "+5V" H 5915 2273 50  0000 C CNN
F 2 "" H 5900 2100 50  0001 C CNN
F 3 "" H 5900 2100 50  0001 C CNN
	1    5900 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	5900 2100 5750 2100
NoConn ~ 5750 2300
NoConn ~ 5750 2400
NoConn ~ 5750 2500
NoConn ~ 5350 2700
$Comp
L power:GND #PWR0107
U 1 1 5DDC32E5
P 5450 2700
F 0 "#PWR0107" H 5450 2450 50  0001 C CNN
F 1 "GND" H 5455 2527 50  0000 C CNN
F 2 "" H 5450 2700 50  0001 C CNN
F 3 "" H 5450 2700 50  0001 C CNN
	1    5450 2700
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0108
U 1 1 5DDCF4B6
P 4900 4400
F 0 "#PWR0108" H 4900 4250 50  0001 C CNN
F 1 "+5V" H 4915 4573 50  0000 C CNN
F 2 "" H 4900 4400 50  0001 C CNN
F 3 "" H 4900 4400 50  0001 C CNN
	1    4900 4400
	1    0    0    -1  
$EndComp
Wire Wire Line
	4900 4400 5050 4400
$Comp
L cage_LEDbutton_pi-rescue:LED_Button_connector-MillerLab_CommonComponents U2
U 1 1 5DCB3B09
P 1350 5850
F 0 "U2" H 1400 5925 50  0000 C CNN
F 1 "LED_Button_connector" H 1400 5834 50  0000 C CNN
F 2 "MD-80S:CUI_MD-80S" H 1350 5850 50  0001 C CNN
F 3 "" H 1350 5850 50  0001 C CNN
	1    1350 5850
	1    0    0    -1  
$EndComp
$Comp
L cage_LEDbutton_pi-rescue:LED_Button_connector-MillerLab_CommonComponents U3
U 1 1 5DCBFAD0
P 1350 6500
F 0 "U3" H 1400 6575 50  0000 C CNN
F 1 "LED_Button_connector" H 1400 6484 50  0000 C CNN
F 2 "MD-80S:CUI_MD-80S" H 1350 6500 50  0001 C CNN
F 3 "" H 1350 6500 50  0001 C CNN
	1    1350 6500
	1    0    0    -1  
$EndComp
$Comp
L cage_LEDbutton_pi-rescue:LED_Button_connector-MillerLab_CommonComponents U4
U 1 1 5DCBFF51
P 1350 7150
F 0 "U4" H 1400 7225 50  0000 C CNN
F 1 "LED_Button_connector" H 1400 7134 50  0000 C CNN
F 2 "MD-80S:CUI_MD-80S" H 1350 7150 50  0001 C CNN
F 3 "" H 1350 7150 50  0001 C CNN
	1    1350 7150
	1    0    0    -1  
$EndComp
$Comp
L cage_LEDbutton_pi-rescue:LED_Button_connector-MillerLab_CommonComponents U1
U 1 1 5DCC0482
P 1350 5150
F 0 "U1" H 1400 5225 50  0000 C CNN
F 1 "LED_Button_connector" H 1400 5134 50  0000 C CNN
F 2 "MD-80S:CUI_MD-80S" H 1350 5150 50  0001 C CNN
F 3 "" H 1350 5150 50  0001 C CNN
	1    1350 5150
	1    0    0    -1  
$EndComp
$Comp
L cage_LEDbutton_pi-rescue:LED_Button_connector-MillerLab_CommonComponents U5
U 1 1 5DCC0AEA
P 3150 5150
F 0 "U5" H 3200 5225 50  0000 C CNN
F 1 "LED_Button_connector" H 3200 5134 50  0000 C CNN
F 2 "MD-80S:CUI_MD-80S" H 3150 5150 50  0001 C CNN
F 3 "" H 3150 5150 50  0001 C CNN
	1    3150 5150
	1    0    0    -1  
$EndComp
$Comp
L cage_LEDbutton_pi-rescue:LED_Button_connector-MillerLab_CommonComponents U6
U 1 1 5DCC0F1E
P 3150 5850
F 0 "U6" H 3200 5925 50  0000 C CNN
F 1 "LED_Button_connector" H 3200 5834 50  0000 C CNN
F 2 "MD-80S:CUI_MD-80S" H 3150 5850 50  0001 C CNN
F 3 "" H 3150 5850 50  0001 C CNN
	1    3150 5850
	1    0    0    -1  
$EndComp
$Comp
L cage_LEDbutton_pi-rescue:LED_Button_connector-MillerLab_CommonComponents U7
U 1 1 5DCC133F
P 3150 6500
F 0 "U7" H 3200 6575 50  0000 C CNN
F 1 "LED_Button_connector" H 3200 6484 50  0000 C CNN
F 2 "MD-80S:CUI_MD-80S" H 3150 6500 50  0001 C CNN
F 3 "" H 3150 6500 50  0001 C CNN
	1    3150 6500
	1    0    0    -1  
$EndComp
$Comp
L cage_LEDbutton_pi-rescue:LED_Button_connector-MillerLab_CommonComponents U8
U 1 1 5DCC1766
P 3150 7150
F 0 "U8" H 3200 7225 50  0000 C CNN
F 1 "LED_Button_connector" H 3200 7134 50  0000 C CNN
F 2 "MD-80S:CUI_MD-80S" H 3150 7150 50  0001 C CNN
F 3 "" H 3150 7150 50  0001 C CNN
	1    3150 7150
	1    0    0    -1  
$EndComp
Text Label 6050 4900 0    50   ~ 0
LED0
Text Label 6050 5000 0    50   ~ 0
LED1
Text Label 6050 5100 0    50   ~ 0
LED2
Text Label 6050 5200 0    50   ~ 0
LED3
Text Label 6050 5400 0    50   ~ 0
LED4
Text Label 6050 5500 0    50   ~ 0
LED5
Text Label 6050 5600 0    50   ~ 0
LED6
Text Label 6050 5700 0    50   ~ 0
LED7
Text Label 950  5400 2    50   ~ 0
LED0
Text Label 950  6100 2    50   ~ 0
LED1
Text Label 950  6750 2    50   ~ 0
LED2
Text Label 950  7400 2    50   ~ 0
LED3
Text Label 2750 5400 2    50   ~ 0
LED4
Text Label 2750 6100 2    50   ~ 0
LED5
Text Label 2750 6750 2    50   ~ 0
LED6
Text Label 2750 7400 2    50   ~ 0
LED7
$Comp
L power:+5V #PWR0109
U 1 1 5DD1B9B0
P 850 5300
F 0 "#PWR0109" H 850 5150 50  0001 C CNN
F 1 "+5V" H 865 5473 50  0000 C CNN
F 2 "" H 850 5300 50  0001 C CNN
F 3 "" H 850 5300 50  0001 C CNN
	1    850  5300
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0110
U 1 1 5DD1C3D9
P 850 6000
F 0 "#PWR0110" H 850 5850 50  0001 C CNN
F 1 "+5V" H 865 6173 50  0000 C CNN
F 2 "" H 850 6000 50  0001 C CNN
F 3 "" H 850 6000 50  0001 C CNN
	1    850  6000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0111
U 1 1 5DD1C770
P 850 6650
F 0 "#PWR0111" H 850 6500 50  0001 C CNN
F 1 "+5V" H 865 6823 50  0000 C CNN
F 2 "" H 850 6650 50  0001 C CNN
F 3 "" H 850 6650 50  0001 C CNN
	1    850  6650
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0112
U 1 1 5DD1CBDA
P 850 7300
F 0 "#PWR0112" H 850 7150 50  0001 C CNN
F 1 "+5V" H 865 7473 50  0000 C CNN
F 2 "" H 850 7300 50  0001 C CNN
F 3 "" H 850 7300 50  0001 C CNN
	1    850  7300
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0113
U 1 1 5DD1D888
P 2650 5300
F 0 "#PWR0113" H 2650 5150 50  0001 C CNN
F 1 "+5V" H 2665 5473 50  0000 C CNN
F 2 "" H 2650 5300 50  0001 C CNN
F 3 "" H 2650 5300 50  0001 C CNN
	1    2650 5300
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0114
U 1 1 5DD1DDBD
P 2650 6000
F 0 "#PWR0114" H 2650 5850 50  0001 C CNN
F 1 "+5V" H 2665 6173 50  0000 C CNN
F 2 "" H 2650 6000 50  0001 C CNN
F 3 "" H 2650 6000 50  0001 C CNN
	1    2650 6000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0115
U 1 1 5DD1E30A
P 2650 6650
F 0 "#PWR0115" H 2650 6500 50  0001 C CNN
F 1 "+5V" H 2665 6823 50  0000 C CNN
F 2 "" H 2650 6650 50  0001 C CNN
F 3 "" H 2650 6650 50  0001 C CNN
	1    2650 6650
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0116
U 1 1 5DD1E64F
P 2650 7300
F 0 "#PWR0116" H 2650 7150 50  0001 C CNN
F 1 "+5V" H 2665 7473 50  0000 C CNN
F 2 "" H 2650 7300 50  0001 C CNN
F 3 "" H 2650 7300 50  0001 C CNN
	1    2650 7300
	1    0    0    -1  
$EndComp
Wire Wire Line
	850  5300 950  5300
Wire Wire Line
	850  6000 950  6000
Wire Wire Line
	850  6650 950  6650
Wire Wire Line
	850  7300 950  7300
Wire Wire Line
	2650 5300 2750 5300
Wire Wire Line
	2650 6000 2750 6000
Wire Wire Line
	2650 6650 2750 6650
Wire Wire Line
	2650 7300 2750 7300
$Comp
L Device:R R1
U 1 1 5DD28AB5
P 2050 5150
F 0 "R1" H 2120 5196 50  0000 L CNN
F 1 "10k" H 2120 5105 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 1980 5150 50  0001 C CNN
F 3 "~" H 2050 5150 50  0001 C CNN
	1    2050 5150
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5DD29114
P 2050 5850
F 0 "R2" H 2120 5896 50  0000 L CNN
F 1 "10k" H 2120 5805 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 1980 5850 50  0001 C CNN
F 3 "~" H 2050 5850 50  0001 C CNN
	1    2050 5850
	1    0    0    -1  
$EndComp
$Comp
L Device:R R3
U 1 1 5DD2959A
P 2050 6500
F 0 "R3" H 2120 6546 50  0000 L CNN
F 1 "10k" H 2120 6455 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 1980 6500 50  0001 C CNN
F 3 "~" H 2050 6500 50  0001 C CNN
	1    2050 6500
	1    0    0    -1  
$EndComp
$Comp
L Device:R R4
U 1 1 5DD29A83
P 2050 7150
F 0 "R4" H 2120 7196 50  0000 L CNN
F 1 "10k" H 2120 7105 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 1980 7150 50  0001 C CNN
F 3 "~" H 2050 7150 50  0001 C CNN
	1    2050 7150
	1    0    0    -1  
$EndComp
$Comp
L Device:R R5
U 1 1 5DD29EC4
P 3850 5150
F 0 "R5" H 3920 5196 50  0000 L CNN
F 1 "10k" H 3920 5105 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 3780 5150 50  0001 C CNN
F 3 "~" H 3850 5150 50  0001 C CNN
	1    3850 5150
	1    0    0    -1  
$EndComp
$Comp
L Device:R R6
U 1 1 5DD2A2FB
P 3850 5850
F 0 "R6" H 3920 5896 50  0000 L CNN
F 1 "10k" H 3920 5805 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 3780 5850 50  0001 C CNN
F 3 "~" H 3850 5850 50  0001 C CNN
	1    3850 5850
	1    0    0    -1  
$EndComp
$Comp
L Device:R R7
U 1 1 5DD2A6B6
P 3850 6500
F 0 "R7" H 3920 6546 50  0000 L CNN
F 1 "10k" H 3920 6455 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 3780 6500 50  0001 C CNN
F 3 "~" H 3850 6500 50  0001 C CNN
	1    3850 6500
	1    0    0    -1  
$EndComp
$Comp
L Device:R R8
U 1 1 5DD2AAFC
P 3850 7150
F 0 "R8" H 3920 7196 50  0000 L CNN
F 1 "10k" H 3920 7105 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 3780 7150 50  0001 C CNN
F 3 "~" H 3850 7150 50  0001 C CNN
	1    3850 7150
	1    0    0    -1  
$EndComp
Wire Wire Line
	1850 5300 2050 5300
Wire Wire Line
	1850 6000 2050 6000
Wire Wire Line
	1850 6650 2050 6650
Wire Wire Line
	1850 7300 2050 7300
Wire Wire Line
	3650 5300 3850 5300
Wire Wire Line
	3650 6000 3850 6000
Wire Wire Line
	3650 6650 3850 6650
Wire Wire Line
	3650 7300 3850 7300
Text Label 1850 5400 0    50   ~ 0
Button0
Text Label 1850 6100 0    50   ~ 0
Button1
Text Label 1850 6750 0    50   ~ 0
Button2
Text Label 1850 7400 0    50   ~ 0
Button3
Text Label 3650 5400 0    50   ~ 0
Button4
Text Label 3650 6100 0    50   ~ 0
Button5
Text Label 3650 6750 0    50   ~ 0
Button6
Text Label 3650 7400 0    50   ~ 0
Button7
Text Label 5050 5700 2    50   ~ 0
Button7
Text Label 5050 5600 2    50   ~ 0
Button6
Text Label 5050 5500 2    50   ~ 0
Button5
Text Label 5050 5400 2    50   ~ 0
Button4
Text Label 5050 5200 2    50   ~ 0
Button3
Text Label 5050 5100 2    50   ~ 0
Button2
Text Label 5050 5000 2    50   ~ 0
Button1
Text Label 5050 4900 2    50   ~ 0
Button0
$Comp
L power:+5V #PWR0117
U 1 1 5DD580ED
P 2050 5000
F 0 "#PWR0117" H 2050 4850 50  0001 C CNN
F 1 "+5V" H 2065 5173 50  0000 C CNN
F 2 "" H 2050 5000 50  0001 C CNN
F 3 "" H 2050 5000 50  0001 C CNN
	1    2050 5000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0118
U 1 1 5DD5879E
P 2050 5700
F 0 "#PWR0118" H 2050 5550 50  0001 C CNN
F 1 "+5V" H 2065 5873 50  0000 C CNN
F 2 "" H 2050 5700 50  0001 C CNN
F 3 "" H 2050 5700 50  0001 C CNN
	1    2050 5700
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0119
U 1 1 5DD59836
P 2050 6350
F 0 "#PWR0119" H 2050 6200 50  0001 C CNN
F 1 "+5V" H 2065 6523 50  0000 C CNN
F 2 "" H 2050 6350 50  0001 C CNN
F 3 "" H 2050 6350 50  0001 C CNN
	1    2050 6350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0120
U 1 1 5DD59CF1
P 2050 7000
F 0 "#PWR0120" H 2050 6850 50  0001 C CNN
F 1 "+5V" H 2065 7173 50  0000 C CNN
F 2 "" H 2050 7000 50  0001 C CNN
F 3 "" H 2050 7000 50  0001 C CNN
	1    2050 7000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0121
U 1 1 5DD5C53B
P 3850 5000
F 0 "#PWR0121" H 3850 4850 50  0001 C CNN
F 1 "+5V" H 3865 5173 50  0000 C CNN
F 2 "" H 3850 5000 50  0001 C CNN
F 3 "" H 3850 5000 50  0001 C CNN
	1    3850 5000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0122
U 1 1 5DD5CA69
P 3850 5700
F 0 "#PWR0122" H 3850 5550 50  0001 C CNN
F 1 "+5V" H 3865 5873 50  0000 C CNN
F 2 "" H 3850 5700 50  0001 C CNN
F 3 "" H 3850 5700 50  0001 C CNN
	1    3850 5700
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0123
U 1 1 5DD5CEA3
P 3850 6350
F 0 "#PWR0123" H 3850 6200 50  0001 C CNN
F 1 "+5V" H 3865 6523 50  0000 C CNN
F 2 "" H 3850 6350 50  0001 C CNN
F 3 "" H 3850 6350 50  0001 C CNN
	1    3850 6350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0124
U 1 1 5DD5D30E
P 3850 7000
F 0 "#PWR0124" H 3850 6850 50  0001 C CNN
F 1 "+5V" H 3865 7173 50  0000 C CNN
F 2 "" H 3850 7000 50  0001 C CNN
F 3 "" H 3850 7000 50  0001 C CNN
	1    3850 7000
	1    0    0    -1  
$EndComp
NoConn ~ 1450 1800
NoConn ~ 1450 1400
NoConn ~ 1450 1500
Text Label 5050 4700 2    50   ~ 0
Reset
Text Label 1450 1700 2    50   ~ 0
Reset
$Comp
L Device:R R9
U 1 1 5DD82DCC
P 6200 4250
F 0 "R9" H 6270 4296 50  0000 L CNN
F 1 "10k" H 6270 4205 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 6130 4250 50  0001 C CNN
F 3 "~" H 6200 4250 50  0001 C CNN
	1    6200 4250
	1    0    0    -1  
$EndComp
Wire Wire Line
	6050 4400 6200 4400
$Comp
L power:+5V #PWR0125
U 1 1 5DD84D1F
P 6200 4100
F 0 "#PWR0125" H 6200 3950 50  0001 C CNN
F 1 "+5V" H 6215 4273 50  0000 C CNN
F 2 "" H 6200 4100 50  0001 C CNN
F 3 "" H 6200 4100 50  0001 C CNN
	1    6200 4100
	1    0    0    -1  
$EndComp
NoConn ~ 1450 2000
NoConn ~ 1450 2100
NoConn ~ 1450 2200
NoConn ~ 3050 2600
NoConn ~ 3050 2700
NoConn ~ 3050 2800
NoConn ~ 3050 2900
NoConn ~ 3050 3000
NoConn ~ 3050 2300
NoConn ~ 3050 2200
NoConn ~ 3050 2100
NoConn ~ 3050 1900
NoConn ~ 3050 1800
NoConn ~ 3050 1700
NoConn ~ 3050 1500
NoConn ~ 3050 1400
NoConn ~ 1450 3000
NoConn ~ 1450 3100
NoConn ~ 1450 2400
$Comp
L power:GND #PWR0126
U 1 1 5DDE43AF
P 6500 4800
F 0 "#PWR0126" H 6500 4550 50  0001 C CNN
F 1 "GND" H 6505 4627 50  0000 C CNN
F 2 "" H 6500 4800 50  0001 C CNN
F 3 "" H 6500 4800 50  0001 C CNN
	1    6500 4800
	1    0    0    -1  
$EndComp
Wire Wire Line
	6050 4800 6500 4800
$Comp
L Connector:Raspberry_Pi_2_3 J1
U 1 1 5DC4AAA2
P 2250 2300
F 0 "J1" H 2250 3781 50  0000 C CNN
F 1 "Raspberry_Pi_2_3" H 2250 3690 50  0000 C CNN
F 2 "Connector_IDC:IDC-Header_2x20_P2.54mm_Vertical" H 2250 2300 50  0001 C CNN
F 3 "https://www.raspberrypi.org/documentation/hardware/raspberrypi/schematics/rpi_SCH_3bplus_1p0_reduced.pdf" H 2250 2300 50  0001 C CNN
	1    2250 2300
	-1   0    0    -1  
$EndComp
NoConn ~ 2050 3600
NoConn ~ 2150 3600
NoConn ~ 2250 3600
NoConn ~ 2350 3600
NoConn ~ 2450 3600
NoConn ~ 2550 3600
NoConn ~ 2650 3600
NoConn ~ 2050 1000
NoConn ~ 2350 1000
Text Label 2150 850  2    50   ~ 0
3V_source
Wire Wire Line
	2150 850  2150 1000
NoConn ~ 3050 2500
$EndSCHEMATC
