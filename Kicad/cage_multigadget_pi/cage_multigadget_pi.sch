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
L Amplifier_Operational:TL064 U1
U 1 1 5DD4DA2C
P 1900 1400
F 0 "U1" H 1900 1767 50  0000 C CNN
F 1 "OP495" H 1900 1676 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 1850 1500 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tl061.pdf" H 1950 1600 50  0001 C CNN
	1    1900 1400
	1    0    0    -1  
$EndComp
$Comp
L Amplifier_Operational:TL064 U1
U 2 1 5DD4ED6D
P 2850 2200
F 0 "U1" H 2850 2567 50  0000 C CNN
F 1 "OP495" H 2850 2476 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2800 2300 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tl061.pdf" H 2900 2400 50  0001 C CNN
	2    2850 2200
	1    0    0    -1  
$EndComp
$Comp
L Amplifier_Operational:TL064 U1
U 3 1 5DD50258
P 1850 3300
F 0 "U1" H 1850 3667 50  0000 C CNN
F 1 "OP495" H 1850 3576 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 1800 3400 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tl061.pdf" H 1900 3500 50  0001 C CNN
	3    1850 3300
	1    0    0    -1  
$EndComp
$Comp
L Amplifier_Operational:TL064 U1
U 4 1 5DD50973
P 3000 4050
F 0 "U1" H 3000 4417 50  0000 C CNN
F 1 "OP495" H 3000 4326 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 2950 4150 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tl061.pdf" H 3050 4250 50  0001 C CNN
	4    3000 4050
	1    0    0    -1  
$EndComp
$Comp
L Amplifier_Operational:TL064 U1
U 5 1 5DD52315
P 1200 5000
F 0 "U1" H 1158 5046 50  0000 L CNN
F 1 "OP495" H 1158 4955 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 1150 5100 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tl061.pdf" H 1250 5200 50  0001 C CNN
	5    1200 5000
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5DD57EB0
P 1350 1650
F 0 "R2" H 1420 1696 50  0000 L CNN
F 1 "1k" H 1420 1605 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 1280 1650 50  0001 C CNN
F 3 "~" H 1350 1650 50  0001 C CNN
	1    1350 1650
	1    0    0    -1  
$EndComp
$Comp
L Device:R R5
U 1 1 5DD5AD6E
P 2250 2450
F 0 "R5" H 2320 2496 50  0000 L CNN
F 1 "1k" H 2320 2405 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 2180 2450 50  0001 C CNN
F 3 "~" H 2250 2450 50  0001 C CNN
	1    2250 2450
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 5DD5B5B2
P 1250 3550
F 0 "R1" H 1320 3596 50  0000 L CNN
F 1 "1k" H 1320 3505 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 1180 3550 50  0001 C CNN
F 3 "~" H 1250 3550 50  0001 C CNN
	1    1250 3550
	1    0    0    -1  
$EndComp
$Comp
L Device:R R6
U 1 1 5DD5BCEF
P 2250 4300
F 0 "R6" H 2320 4346 50  0000 L CNN
F 1 "1k" H 2320 4255 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 2180 4300 50  0001 C CNN
F 3 "~" H 2250 4300 50  0001 C CNN
	1    2250 4300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 5DD7EF03
P 1100 5300
F 0 "#PWR0102" H 1100 5050 50  0001 C CNN
F 1 "GND" H 1105 5127 50  0000 C CNN
F 2 "" H 1100 5300 50  0001 C CNN
F 3 "" H 1100 5300 50  0001 C CNN
	1    1100 5300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0103
U 1 1 5DD82205
P 3350 4700
F 0 "#PWR0103" H 3350 4450 50  0001 C CNN
F 1 "GND" H 3355 4527 50  0000 C CNN
F 2 "" H 3350 4700 50  0001 C CNN
F 3 "" H 3350 4700 50  0001 C CNN
	1    3350 4700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0104
U 1 1 5DD827EB
P 2250 4450
F 0 "#PWR0104" H 2250 4200 50  0001 C CNN
F 1 "GND" H 2255 4277 50  0000 C CNN
F 2 "" H 2250 4450 50  0001 C CNN
F 3 "" H 2250 4450 50  0001 C CNN
	1    2250 4450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0105
U 1 1 5DD844C0
P 2300 3700
F 0 "#PWR0105" H 2300 3450 50  0001 C CNN
F 1 "GND" H 2150 3600 50  0000 C CNN
F 2 "" H 2300 3700 50  0001 C CNN
F 3 "" H 2300 3700 50  0001 C CNN
	1    2300 3700
	-1   0    0    -1  
$EndComp
$Comp
L power:GND #PWR0106
U 1 1 5DD85440
P 1250 3700
F 0 "#PWR0106" H 1250 3450 50  0001 C CNN
F 1 "GND" H 1255 3527 50  0000 C CNN
F 2 "" H 1250 3700 50  0001 C CNN
F 3 "" H 1250 3700 50  0001 C CNN
	1    1250 3700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0107
U 1 1 5DD855F2
P 2250 2600
F 0 "#PWR0107" H 2250 2350 50  0001 C CNN
F 1 "GND" H 2255 2427 50  0000 C CNN
F 2 "" H 2250 2600 50  0001 C CNN
F 3 "" H 2250 2600 50  0001 C CNN
	1    2250 2600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0108
U 1 1 5DD85905
P 3200 2700
F 0 "#PWR0108" H 3200 2450 50  0001 C CNN
F 1 "GND" H 3205 2527 50  0000 C CNN
F 2 "" H 3200 2700 50  0001 C CNN
F 3 "" H 3200 2700 50  0001 C CNN
	1    3200 2700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0109
U 1 1 5DD86DF7
P 2350 1800
F 0 "#PWR0109" H 2350 1550 50  0001 C CNN
F 1 "GND" H 2355 1627 50  0000 C CNN
F 2 "" H 2350 1800 50  0001 C CNN
F 3 "" H 2350 1800 50  0001 C CNN
	1    2350 1800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0110
U 1 1 5DD87097
P 1350 1800
F 0 "#PWR0110" H 1350 1550 50  0001 C CNN
F 1 "GND" H 1355 1627 50  0000 C CNN
F 2 "" H 1350 1800 50  0001 C CNN
F 3 "" H 1350 1800 50  0001 C CNN
	1    1350 1800
	1    0    0    -1  
$EndComp
$Comp
L Device:R_POT RV2
U 1 1 5DDB9ACD
P 3200 2550
F 0 "RV2" H 3350 2650 50  0000 C CNN
F 1 "R_POT" H 3350 2400 50  0000 C CNN
F 2 "Potentiometers:Potentiometer_Trimmer_Bourns_3296Y" H 3200 2550 50  0001 C CNN
F 3 "~" H 3200 2550 50  0001 C CNN
	1    3200 2550
	-1   0    0    1   
$EndComp
$Comp
L Device:R_POT RV3
U 1 1 5DDC493C
P 2300 3550
F 0 "RV3" H 2450 3650 50  0000 C CNN
F 1 "R_POT" H 2500 3450 50  0000 C CNN
F 2 "Potentiometers:Potentiometer_Trimmer_Bourns_3296Y" H 2300 3550 50  0001 C CNN
F 3 "~" H 2300 3550 50  0001 C CNN
	1    2300 3550
	-1   0    0    1   
$EndComp
$Comp
L Device:R_POT RV4
U 1 1 5DDC696E
P 3350 4550
F 0 "RV4" H 3500 4650 50  0000 C CNN
F 1 "R_POT" H 3500 4400 50  0000 C CNN
F 2 "Potentiometers:Potentiometer_Trimmer_Bourns_3296Y" H 3350 4550 50  0001 C CNN
F 3 "~" H 3350 4550 50  0001 C CNN
	1    3350 4550
	-1   0    0    1   
$EndComp
Wire Wire Line
	1350 1500 1350 1300
Wire Wire Line
	1350 1300 1600 1300
Wire Wire Line
	2550 2100 2250 2100
Wire Wire Line
	2250 2100 2250 2300
Wire Wire Line
	1250 3400 1250 3200
Wire Wire Line
	1250 3200 1550 3200
Wire Wire Line
	2250 4150 2250 3950
Wire Wire Line
	2250 3950 2700 3950
$Comp
L Analog_ADC:MCP3004 U2
U 1 1 5DE19945
P 5050 2800
F 0 "U2" H 5350 3300 50  0000 C CNN
F 1 "MCP3004" H 5350 3200 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm" H 5950 2500 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/21295C.pdf" H 5950 2500 50  0001 C CNN
	1    5050 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	3300 4050 3350 4050
Wire Wire Line
	3450 4050 3450 3000
$Comp
L Connector:USB_B_Micro J1
U 1 1 5DE7CFB9
P 1350 6550
F 0 "J1" H 1407 7017 50  0000 C CNN
F 1 "USB_B_Micro" H 1407 6926 50  0000 C CNN
F 2 "Digikey_footprints:USB_Micro_B_Female_10118194-0001LF" H 1500 6500 50  0001 C CNN
F 3 "~" H 1500 6500 50  0001 C CNN
	1    1350 6550
	1    0    0    -1  
$EndComp
NoConn ~ 1650 6550
NoConn ~ 1650 6650
NoConn ~ 1650 6750
NoConn ~ 1250 6950
$Comp
L power:GND #PWR0112
U 1 1 5DE9ADE9
P 1350 7050
F 0 "#PWR0112" H 1350 6800 50  0001 C CNN
F 1 "GND" H 1355 6877 50  0000 C CNN
F 2 "" H 1350 7050 50  0001 C CNN
F 3 "" H 1350 7050 50  0001 C CNN
	1    1350 7050
	1    0    0    -1  
$EndComp
Wire Wire Line
	1350 6950 1350 7050
Wire Wire Line
	5050 2200 5050 2400
NoConn ~ 9550 950 
NoConn ~ 9850 950 
NoConn ~ 9950 950 
NoConn ~ 8950 1350
NoConn ~ 8950 1450
NoConn ~ 10550 2050
NoConn ~ 10550 2650
NoConn ~ 10550 2750
NoConn ~ 10550 2850
NoConn ~ 10550 2950
NoConn ~ 8950 3050
NoConn ~ 8950 2150
NoConn ~ 8950 2050
NoConn ~ 8950 1950
NoConn ~ 10050 3550
NoConn ~ 9950 3550
NoConn ~ 9850 3550
NoConn ~ 9750 3550
NoConn ~ 9650 3550
NoConn ~ 9550 3550
Text Label 5650 2700 0    50   ~ 0
SCLK
Text Label 5650 2800 0    50   ~ 0
MISO
Text Label 5650 2900 0    50   ~ 0
MOSI
Text Label 5650 3000 0    50   ~ 0
Chip_Select_ADC
Text Label 8950 2750 2    50   ~ 0
SCLK
Text Label 8950 2650 2    50   ~ 0
MOSI
Text Label 8950 2550 2    50   ~ 0
MISO
Text Label 8950 2450 2    50   ~ 0
Chip_Select_ADC
$Comp
L power:GNDD #PWR0114
U 1 1 5DECEFAC
P 5050 3300
F 0 "#PWR0114" H 5050 3050 50  0001 C CNN
F 1 "GNDD" H 5054 3145 50  0000 C CNN
F 2 "" H 5050 3300 50  0001 C CNN
F 3 "" H 5050 3300 50  0001 C CNN
	1    5050 3300
	1    0    0    -1  
$EndComp
$Comp
L power:GNDD #PWR0115
U 1 1 5DED1749
P 10150 3550
F 0 "#PWR0115" H 10150 3300 50  0001 C CNN
F 1 "GNDD" H 10154 3395 50  0000 C CNN
F 2 "" H 10150 3550 50  0001 C CNN
F 3 "" H 10150 3550 50  0001 C CNN
	1    10150 3550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0116
U 1 1 5DEDC84B
P 4950 3550
F 0 "#PWR0116" H 4950 3300 50  0001 C CNN
F 1 "GND" H 4955 3377 50  0000 C CNN
F 2 "" H 4950 3550 50  0001 C CNN
F 3 "" H 4950 3550 50  0001 C CNN
	1    4950 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	4950 3300 4950 3550
Wire Wire Line
	4950 2200 4950 2400
Wire Notes Line
	1050 7300 1050 6000
Wire Notes Line
	850  5550 850  850 
Wire Notes Line
	850  850  3550 850 
Wire Notes Line
	3550 850  3550 5550
Wire Notes Line
	3550 5550 850  5550
Text Notes 1750 5900 0    50   ~ 0
Power Supply
Text Notes 1950 800  0    50   ~ 0
OP495
$Comp
L cage_multigadget_pi-rescue:MultigadgetDevice-MillerLab_CommonComponents-cage_multigadget_pi-rescue U4
U 1 1 5E2EF314
P 5400 4050
F 0 "U4" H 5400 4175 50  0000 C CNN
F 1 "MultigadgetDevice" H 5400 4084 50  0000 C CNN
F 2 "MD-80S:CUI_MD-80S" H 5400 4050 50  0001 C CNN
F 3 "" H 5400 4050 50  0001 C CNN
	1    5400 4050
	1    0    0    -1  
$EndComp
$Comp
L cage_multigadget_pi-rescue:MultigadgetDevice-MillerLab_CommonComponents-cage_multigadget_pi-rescue U5
U 1 1 5E2F637C
P 5900 5000
F 0 "U5" H 5900 5125 50  0000 C CNN
F 1 "MultigadgetDevice" H 5900 5034 50  0000 C CNN
F 2 "MD-80S:CUI_MD-80S" H 5900 5000 50  0001 C CNN
F 3 "" H 5900 5000 50  0001 C CNN
	1    5900 5000
	1    0    0    -1  
$EndComp
$Comp
L cage_multigadget_pi-rescue:LED_Button_connector-MillerLab_CommonComponents-cage_multigadget_pi-rescue U6
U 1 1 5E2FDD90
P 10350 4250
F 0 "U6" H 10400 4325 50  0000 C CNN
F 1 "LED_Button_connector" H 10400 4234 50  0000 C CNN
F 2 "MD-80S:CUI_MD-80S" H 10350 4250 50  0001 C CNN
F 3 "" H 10350 4250 50  0001 C CNN
	1    10350 4250
	1    0    0    -1  
$EndComp
$Comp
L cage_multigadget_pi-rescue:LED_Button_connector-MillerLab_CommonComponents-cage_multigadget_pi-rescue U7
U 1 1 5E2FEBB6
P 10300 5250
F 0 "U7" H 10350 5325 50  0000 C CNN
F 1 "LED_Button_connector" H 10350 5234 50  0000 C CNN
F 2 "MD-80S:CUI_MD-80S" H 10300 5250 50  0001 C CNN
F 3 "" H 10300 5250 50  0001 C CNN
	1    10300 5250
	1    0    0    -1  
$EndComp
Text Label 1350 1300 2    50   ~ 0
Device0_FSR0
Text Label 2250 2100 2    50   ~ 0
Device0_FSR1
Text Label 1250 3200 2    50   ~ 0
Device1_FSR0
Text Label 2250 3950 2    50   ~ 0
Device1_FSR1
Text Label 5800 4300 0    50   ~ 0
Device0_FSR0
Text Label 5800 4450 0    50   ~ 0
Device0_FSR1
Text Label 6300 5250 0    50   ~ 0
Device1_FSR0
Text Label 6300 5400 0    50   ~ 0
Device1_FSR1
Wire Wire Line
	6350 4150 5800 4150
Wire Wire Line
	6850 5100 6300 5100
$Comp
L Device:R R20
U 1 1 5E371043
P 4850 4400
F 0 "R20" V 4750 4400 50  0000 C CNN
F 1 "150" V 4650 4400 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 4780 4400 50  0001 C CNN
F 3 "~" H 4850 4400 50  0001 C CNN
	1    4850 4400
	0    1    -1   0   
$EndComp
$Comp
L Device:R R21
U 1 1 5E371963
P 5350 5350
F 0 "R21" V 5450 5350 50  0000 C CNN
F 1 "150" V 5550 5350 50  0000 C CNN
F 2 "Resistor_SMD:R_1206_3216Metric_Pad1.42x1.75mm_HandSolder" V 5280 5350 50  0001 C CNN
F 3 "~" H 5350 5350 50  0001 C CNN
	1    5350 5350
	0    -1   1    0   
$EndComp
$Comp
L power:+5V #PWR0120
U 1 1 5E372C6A
P 5350 5150
F 0 "#PWR0120" H 5350 5000 50  0001 C CNN
F 1 "+5V" H 5365 5323 50  0000 C CNN
F 2 "" H 5350 5150 50  0001 C CNN
F 3 "" H 5350 5150 50  0001 C CNN
	1    5350 5150
	-1   0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0121
U 1 1 5E372F45
P 4850 4200
F 0 "#PWR0121" H 4850 4050 50  0001 C CNN
F 1 "+5V" H 4865 4373 50  0000 C CNN
F 2 "" H 4850 4200 50  0001 C CNN
F 3 "" H 4850 4200 50  0001 C CNN
	1    4850 4200
	-1   0    0    -1  
$EndComp
Wire Wire Line
	4850 4200 5000 4200
Wire Wire Line
	5350 5150 5500 5150
$Comp
L power:+5V #PWR0122
U 1 1 5E3C971D
P 9800 4400
F 0 "#PWR0122" H 9800 4250 50  0001 C CNN
F 1 "+5V" H 9815 4573 50  0000 C CNN
F 2 "" H 9800 4400 50  0001 C CNN
F 3 "" H 9800 4400 50  0001 C CNN
	1    9800 4400
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0123
U 1 1 5E3C9A73
P 9750 5400
F 0 "#PWR0123" H 9750 5250 50  0001 C CNN
F 1 "+5V" H 9765 5573 50  0000 C CNN
F 2 "" H 9750 5400 50  0001 C CNN
F 3 "" H 9750 5400 50  0001 C CNN
	1    9750 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	9800 4400 9950 4400
Wire Wire Line
	9750 5400 9900 5400
Text Label 10850 4500 0    50   ~ 0
Button0
Text Label 10800 5500 0    50   ~ 0
Button1
Wire Wire Line
	10900 5400 10800 5400
Wire Wire Line
	10950 4400 10850 4400
Wire Wire Line
	3450 3000 4450 3000
Wire Wire Line
	3350 2900 3350 3300
Wire Wire Line
	3350 3300 2300 3300
Wire Wire Line
	3350 2900 4450 2900
Wire Wire Line
	3150 2200 3200 2200
Wire Wire Line
	3350 2200 3350 2800
Wire Wire Line
	3350 2800 4450 2800
Wire Wire Line
	3450 2700 3450 1400
Wire Wire Line
	3450 1400 2350 1400
Wire Wire Line
	3450 2700 4450 2700
$Comp
L cage_multigadget_pi-rescue:LED_Button_connector-MillerLab_CommonComponents-cage_multigadget_pi-rescue U8
U 1 1 5E7FE5B8
P 8350 4250
F 0 "U8" H 8400 4325 50  0000 C CNN
F 1 "LED_Button_connector" H 8400 4234 50  0000 C CNN
F 2 "MD-80S:CUI_MD-80S" H 8350 4250 50  0001 C CNN
F 3 "" H 8350 4250 50  0001 C CNN
	1    8350 4250
	1    0    0    -1  
$EndComp
$Comp
L cage_multigadget_pi-rescue:LED_Button_connector-MillerLab_CommonComponents-cage_multigadget_pi-rescue U9
U 1 1 5E7FE5BE
P 8300 5250
F 0 "U9" H 8350 5325 50  0000 C CNN
F 1 "LED_Button_connector" H 8350 5234 50  0000 C CNN
F 2 "MD-80S:CUI_MD-80S" H 8300 5250 50  0001 C CNN
F 3 "" H 8300 5250 50  0001 C CNN
	1    8300 5250
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0133
U 1 1 5E7FE5C4
P 7800 4400
F 0 "#PWR0133" H 7800 4250 50  0001 C CNN
F 1 "+5V" H 7815 4573 50  0000 C CNN
F 2 "" H 7800 4400 50  0001 C CNN
F 3 "" H 7800 4400 50  0001 C CNN
	1    7800 4400
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0134
U 1 1 5E7FE5CA
P 7750 5400
F 0 "#PWR0134" H 7750 5250 50  0001 C CNN
F 1 "+5V" H 7765 5573 50  0000 C CNN
F 2 "" H 7750 5400 50  0001 C CNN
F 3 "" H 7750 5400 50  0001 C CNN
	1    7750 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	7800 4400 7950 4400
Wire Wire Line
	7750 5400 7900 5400
Text Label 8850 4500 0    50   ~ 0
Reward0Button
Text Label 8800 5500 0    50   ~ 0
Reward1Button
Wire Wire Line
	8900 5400 8800 5400
Wire Wire Line
	8950 4400 8850 4400
Text Label 10550 2150 0    50   ~ 0
Reward0
$Comp
L Connector_Generic:Conn_01x02 J3
U 1 1 5E97ECE6
P 4450 6300
F 0 "J3" H 4530 6292 50  0000 L CNN
F 1 "Conn_01x02" H 4530 6201 50  0000 L CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x02_Pitch2.54mm" H 4450 6300 50  0001 C CNN
F 3 "~" H 4450 6300 50  0001 C CNN
	1    4450 6300
	1    0    0    -1  
$EndComp
Text Label 4250 6300 2    50   ~ 0
Reward0
Text Label 4250 6400 2    50   ~ 0
GND
$Comp
L Connector_Generic:Conn_01x02 J4
U 1 1 5E9F915C
P 4450 6700
F 0 "J4" H 4530 6692 50  0000 L CNN
F 1 "Conn_01x02" H 4530 6601 50  0000 L CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x02_Pitch2.54mm" H 4450 6700 50  0001 C CNN
F 3 "~" H 4450 6700 50  0001 C CNN
	1    4450 6700
	1    0    0    -1  
$EndComp
Text Label 4250 6800 2    50   ~ 0
GND
Text Label 4250 6700 2    50   ~ 0
Reward1
Text Label 10550 2250 0    50   ~ 0
Reward1
Text Label 10550 1650 0    50   ~ 0
Device0LED
Text Label 8950 2950 2    50   ~ 0
Device1LED
Text Label 8950 1750 2    50   ~ 0
Button0LED
Text Label 8950 1650 2    50   ~ 0
Button0
Text Label 10550 1450 0    50   ~ 0
Button1LED
Text Label 10550 1350 0    50   ~ 0
Button1
NoConn ~ 8950 2350
Text Label 10550 1850 0    50   ~ 0
Reward0Button
Text Label 10550 1750 0    50   ~ 0
Reward0LED
$Comp
L Connector:Raspberry_Pi_2_3 J2
U 1 1 5DEA7FD2
P 9750 2250
F 0 "J2" H 9150 3650 50  0000 C CNN
F 1 "Raspberry_Pi_2_3" H 9100 3550 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x20_Pitch2.54mm" H 9750 2250 50  0001 C CNN
F 3 "https://www.raspberrypi.org/documentation/hardware/raspberrypi/schematics/rpi_SCH_3bplus_1p0_reduced.pdf" H 9750 2250 50  0001 C CNN
	1    9750 2250
	-1   0    0    -1  
$EndComp
Text Label 10550 2550 0    50   ~ 0
Reward1Button
Text Label 10550 2450 0    50   ~ 0
Reward1LED
$Comp
L Regulator_Linear:AZ1117-3.3 U3
U 1 1 5EA1A1EC
P 2400 6350
F 0 "U3" H 2400 6592 50  0000 C CNN
F 1 "AZ1117-3.3" H 2400 6501 50  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-223" H 2400 6600 50  0001 C CIN
F 3 "https://www.diodes.com/assets/Datasheets/AZ1117.pdf" H 2400 6350 50  0001 C CNN
	1    2400 6350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 5EA1C773
P 2400 6650
F 0 "#PWR0101" H 2400 6400 50  0001 C CNN
F 1 "GND" H 2405 6477 50  0000 C CNN
F 2 "" H 2400 6650 50  0001 C CNN
F 3 "" H 2400 6650 50  0001 C CNN
	1    2400 6650
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0111
U 1 1 5EA1CA1A
P 1950 6350
F 0 "#PWR0111" H 1950 6200 50  0001 C CNN
F 1 "+5V" H 1965 6523 50  0000 C CNN
F 2 "" H 1950 6350 50  0001 C CNN
F 3 "" H 1950 6350 50  0001 C CNN
	1    1950 6350
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0113
U 1 1 5EA1DFC3
P 2800 6350
F 0 "#PWR0113" H 2800 6200 50  0001 C CNN
F 1 "+3.3V" H 2815 6523 50  0000 C CNN
F 2 "" H 2800 6350 50  0001 C CNN
F 3 "" H 2800 6350 50  0001 C CNN
	1    2800 6350
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 6350 1950 6350
Wire Wire Line
	2700 6350 2800 6350
$Comp
L power:+3.3V #PWR0117
U 1 1 5EA262B5
P 1100 4700
F 0 "#PWR0117" H 1100 4550 50  0001 C CNN
F 1 "+3.3V" H 1115 4873 50  0000 C CNN
F 2 "" H 1100 4700 50  0001 C CNN
F 3 "" H 1100 4700 50  0001 C CNN
	1    1100 4700
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0118
U 1 1 5EA282AA
P 4950 2200
F 0 "#PWR0118" H 4950 2050 50  0001 C CNN
F 1 "+3.3V" H 4800 2300 50  0000 C CNN
F 2 "" H 4950 2200 50  0001 C CNN
F 3 "" H 4950 2200 50  0001 C CNN
	1    4950 2200
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0119
U 1 1 5EA2902C
P 5050 2200
F 0 "#PWR0119" H 5050 2050 50  0001 C CNN
F 1 "+3.3V" H 5200 2350 50  0000 C CNN
F 2 "" H 5050 2200 50  0001 C CNN
F 3 "" H 5050 2200 50  0001 C CNN
	1    5050 2200
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0124
U 1 1 5EA2E48B
P 6350 4150
F 0 "#PWR0124" H 6350 4000 50  0001 C CNN
F 1 "+3.3V" H 6365 4323 50  0000 C CNN
F 2 "" H 6350 4150 50  0001 C CNN
F 3 "" H 6350 4150 50  0001 C CNN
	1    6350 4150
	-1   0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0125
U 1 1 5EA2EFE3
P 6850 5100
F 0 "#PWR0125" H 6850 4950 50  0001 C CNN
F 1 "+3.3V" H 6865 5273 50  0000 C CNN
F 2 "" H 6850 5100 50  0001 C CNN
F 3 "" H 6850 5100 50  0001 C CNN
	1    6850 5100
	-1   0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0126
U 1 1 5EA2F6A8
P 8950 4400
F 0 "#PWR0126" H 8950 4250 50  0001 C CNN
F 1 "+3.3V" H 8965 4573 50  0000 C CNN
F 2 "" H 8950 4400 50  0001 C CNN
F 3 "" H 8950 4400 50  0001 C CNN
	1    8950 4400
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0127
U 1 1 5EA2FD7F
P 8900 5400
F 0 "#PWR0127" H 8900 5250 50  0001 C CNN
F 1 "+3.3V" H 8915 5573 50  0000 C CNN
F 2 "" H 8900 5400 50  0001 C CNN
F 3 "" H 8900 5400 50  0001 C CNN
	1    8900 5400
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0128
U 1 1 5EA30444
P 10950 4400
F 0 "#PWR0128" H 10950 4250 50  0001 C CNN
F 1 "+3.3V" H 10965 4573 50  0000 C CNN
F 2 "" H 10950 4400 50  0001 C CNN
F 3 "" H 10950 4400 50  0001 C CNN
	1    10950 4400
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0129
U 1 1 5EA30B2D
P 10900 5400
F 0 "#PWR0129" H 10900 5250 50  0001 C CNN
F 1 "+3.3V" H 10915 5573 50  0000 C CNN
F 2 "" H 10900 5400 50  0001 C CNN
F 3 "" H 10900 5400 50  0001 C CNN
	1    10900 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	1650 6350 1950 6350
Connection ~ 1950 6350
Wire Notes Line
	1050 6000 3050 6000
Wire Notes Line
	3050 6000 3050 7300
Wire Notes Line
	3050 7300 1050 7300
NoConn ~ 9650 950 
$Comp
L Transistor_FET:BSN20 Q1
U 1 1 5EA42007
P 4250 4600
F 0 "Q1" H 4455 4646 50  0000 L CNN
F 1 "BSN20" H 4455 4555 50  0000 L CNN
F 2 "TO_SOT_Packages_SMD:SOT-23" H 4450 4525 50  0001 L CIN
F 3 "http://www.diodes.com/assets/Datasheets/ds31898.pdf" H 4250 4600 50  0001 L CNN
	1    4250 4600
	1    0    0    -1  
$EndComp
$Comp
L Transistor_FET:BSN20 Q2
U 1 1 5EA44504
P 4700 5550
F 0 "Q2" H 4905 5596 50  0000 L CNN
F 1 "BSN20" H 4905 5505 50  0000 L CNN
F 2 "TO_SOT_Packages_SMD:SOT-23" H 4900 5475 50  0001 L CIN
F 3 "http://www.diodes.com/assets/Datasheets/ds31898.pdf" H 4700 5550 50  0001 L CNN
	1    4700 5550
	1    0    0    -1  
$EndComp
$Comp
L Transistor_FET:BSN20 Q4
U 1 1 5EA45EA2
P 7550 5700
F 0 "Q4" H 7755 5746 50  0000 L CNN
F 1 "BSN20" H 7755 5655 50  0000 L CNN
F 2 "TO_SOT_Packages_SMD:SOT-23" H 7750 5625 50  0001 L CIN
F 3 "http://www.diodes.com/assets/Datasheets/ds31898.pdf" H 7550 5700 50  0001 L CNN
	1    7550 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	4350 4400 4700 4400
Wire Wire Line
	4800 5350 5200 5350
$Comp
L Transistor_FET:BSN20 Q3
U 1 1 5EA68DEC
P 7550 4700
F 0 "Q3" H 7755 4746 50  0000 L CNN
F 1 "BSN20" H 7755 4655 50  0000 L CNN
F 2 "TO_SOT_Packages_SMD:SOT-23" H 7750 4625 50  0001 L CIN
F 3 "http://www.diodes.com/assets/Datasheets/ds31898.pdf" H 7550 4700 50  0001 L CNN
	1    7550 4700
	1    0    0    -1  
$EndComp
$Comp
L Transistor_FET:BSN20 Q5
U 1 1 5EA6A1CB
P 9600 4700
F 0 "Q5" H 9805 4746 50  0000 L CNN
F 1 "BSN20" H 9805 4655 50  0000 L CNN
F 2 "TO_SOT_Packages_SMD:SOT-23" H 9800 4625 50  0001 L CIN
F 3 "http://www.diodes.com/assets/Datasheets/ds31898.pdf" H 9600 4700 50  0001 L CNN
	1    9600 4700
	1    0    0    -1  
$EndComp
$Comp
L Transistor_FET:BSN20 Q6
U 1 1 5EA6B573
P 9600 5700
F 0 "Q6" H 9805 5746 50  0000 L CNN
F 1 "BSN20" H 9805 5655 50  0000 L CNN
F 2 "TO_SOT_Packages_SMD:SOT-23" H 9800 5625 50  0001 L CIN
F 3 "http://www.diodes.com/assets/Datasheets/ds31898.pdf" H 9600 5700 50  0001 L CNN
	1    9600 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	7650 5500 7900 5500
Wire Wire Line
	7650 4500 7950 4500
Wire Wire Line
	9700 4500 9950 4500
Wire Wire Line
	9700 5500 9900 5500
$Comp
L power:GND #PWR0130
U 1 1 5EA75987
P 7650 5900
F 0 "#PWR0130" H 7650 5650 50  0001 C CNN
F 1 "GND" H 7655 5727 50  0000 C CNN
F 2 "" H 7650 5900 50  0001 C CNN
F 3 "" H 7650 5900 50  0001 C CNN
	1    7650 5900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0131
U 1 1 5EA766F5
P 9700 5900
F 0 "#PWR0131" H 9700 5650 50  0001 C CNN
F 1 "GND" H 9705 5727 50  0000 C CNN
F 2 "" H 9700 5900 50  0001 C CNN
F 3 "" H 9700 5900 50  0001 C CNN
	1    9700 5900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0132
U 1 1 5EA7743B
P 9700 4900
F 0 "#PWR0132" H 9700 4650 50  0001 C CNN
F 1 "GND" H 9705 4727 50  0000 C CNN
F 2 "" H 9700 4900 50  0001 C CNN
F 3 "" H 9700 4900 50  0001 C CNN
	1    9700 4900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0135
U 1 1 5EA77877
P 7650 4900
F 0 "#PWR0135" H 7650 4650 50  0001 C CNN
F 1 "GND" H 7655 4727 50  0000 C CNN
F 2 "" H 7650 4900 50  0001 C CNN
F 3 "" H 7650 4900 50  0001 C CNN
	1    7650 4900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0136
U 1 1 5EA783F2
P 4800 5750
F 0 "#PWR0136" H 4800 5500 50  0001 C CNN
F 1 "GND" H 4805 5577 50  0000 C CNN
F 2 "" H 4800 5750 50  0001 C CNN
F 3 "" H 4800 5750 50  0001 C CNN
	1    4800 5750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0137
U 1 1 5EA78F91
P 4350 4800
F 0 "#PWR0137" H 4350 4550 50  0001 C CNN
F 1 "GND" H 4355 4627 50  0000 C CNN
F 2 "" H 4350 4800 50  0001 C CNN
F 3 "" H 4350 4800 50  0001 C CNN
	1    4350 4800
	1    0    0    -1  
$EndComp
Text Label 4050 4600 2    50   ~ 0
Device0LED
Text Label 4500 5550 2    50   ~ 0
Device1LED
Text Label 7350 4700 2    50   ~ 0
Reward0LED
Text Label 7350 5700 2    50   ~ 0
Reward1LED
Text Label 9400 4700 2    50   ~ 0
Button0LED
Text Label 9400 5700 2    50   ~ 0
Button1LED
Wire Wire Line
	1550 3400 1550 3550
$Comp
L power:GND #PWR0138
U 1 1 5EB2CCBC
P 9450 3550
F 0 "#PWR0138" H 9450 3300 50  0001 C CNN
F 1 "GND" H 9455 3377 50  0000 C CNN
F 2 "" H 9450 3550 50  0001 C CNN
F 3 "" H 9450 3550 50  0001 C CNN
	1    9450 3550
	1    0    0    -1  
$EndComp
$Comp
L Device:R_POT RV1
U 1 1 5DDC4EC4
P 2350 1650
F 0 "RV1" H 2500 1750 50  0000 C CNN
F 1 "R_POT" H 2550 1550 50  0000 C CNN
F 2 "Potentiometers:Potentiometer_Trimmer_Bourns_3296Y" H 2350 1650 50  0001 C CNN
F 3 "~" H 2350 1650 50  0001 C CNN
	1    2350 1650
	-1   0    0    1   
$EndComp
Wire Wire Line
	3350 4400 3350 4050
Connection ~ 3350 4050
Wire Wire Line
	3350 4050 3450 4050
Wire Wire Line
	2700 4550 3200 4550
Wire Wire Line
	2700 4150 2700 4550
Wire Wire Line
	2150 3550 1550 3550
Wire Wire Line
	2300 3400 2300 3300
Connection ~ 2300 3300
Wire Wire Line
	2300 3300 2150 3300
Wire Wire Line
	3200 2400 3200 2200
Connection ~ 3200 2200
Wire Wire Line
	3200 2200 3350 2200
Wire Wire Line
	2550 2300 2550 2550
Wire Wire Line
	2550 2550 3050 2550
Wire Wire Line
	2350 1500 2350 1400
Connection ~ 2350 1400
Wire Wire Line
	2350 1400 2200 1400
Wire Wire Line
	2200 1650 1600 1650
Wire Wire Line
	1600 1650 1600 1500
$EndSCHEMATC
