CLEAR

? GetCode('Em-Marine[1700] 009,22847',1)
? GetCode(':170009593F48',2)
? GetCode('830017009593F01',3)

*!*	—читка1: Em-Marine[1700] 009,22847
*!*	—читка2: :170009593F48
*!*	—читка3: 830017009593F01
PROCEDURE GetCode
LPARAMETER lcReading, lnDeviceType


LOCAL lcStr

DO CASE
	CASE lnDeviceType = 1
		RETURN ROUND(VAL(RIGHT(lcReading,LEN(lcReading)-AT([,],lcReading))),0)
	CASE lnDeviceType = 2
		lcStr = [0x]+LEFT(RIGHT(lcReading,6),4)
		RETURN ROUND(VAL(STR(&lcStr)),0)
	CASE lnDeviceType = 3
		lcStr = [0x]+LEFT(RIGHT(lcReading,6),4)
		RETURN ROUND(VAL(STR(&lcStr)),0)
ENDCASE

ENDPROC

