PROCEDURE EncodePasswordToString
LPARAMETERS tcStrPas
***
LOCAL	i, lcPrevSymbol, lcCurrentSymbol, ;
		lcBufPass
***
lcBufPass = []
lcPrevSymbol = CHR(LEN(tcStrPas))
FOR i = 1 TO LEN(tcStrPas)
	lcCurrentSymbol = CHR(MOD(ASC(lcPrevSymbol)+ASC(SUBSTR(tcStrPas,i,1)),256))
	lcBufPass = lcBufPass + lcCurrentSymbol
	lcPrevSymbol = lcCurrentSymbol
ENDFOR
lcBufPass = CHR(LEN(tcStrPas)) + lcBufPass
RETURN ChangeEscapePos(lcBufPass)
***
ENDPROC

PROCEDURE ChangeEscapePos
LPARAMETERS tcStr
***
LOCAL	i, lcResult, lcSymbol
***
lcResult = []
FOR i = 1 TO LEN(tcStr)
	lcSymbol = SUBSTR(tcStr,i,1)
	DO CASE
		CASE ASC(lcSymbol) = 0
			lcResult = lcResult + CHR(254)+CHR(1)
		CASE ASC(lcSymbol) = 254
			lcResult = lcResult + CHR(254)+CHR(2)
		CASE lcSymbol = [ ]
			lcResult = lcResult + CHR(254)+CHR(3)
		CASE lcSymbol = [\]
			lcResult = lcResult + CHR(254)+CHR(4)
		CASE ASC(lcSymbol) = 10
			lcResult = lcResult + CHR(254)+CHR(5)
		OTHERWISE
			lcResult = lcResult + lcSymbol
	ENDCASE
ENDFOR
RETURN lcResult
***
ENDPROC

PROCEDURE DecodePasswordToString
LPARAMETERS tcBufPass, tnConfig, tlNoShifr
***
LOCAL i, lcSTemp, lcBufPass1, lcStrPas
***
IF NOT tlNoShifr
	BufPass1 = DecodeEscapePos(tcBufPass)
ELSE
	BufPass1 = DecodeEscapePos(tcBufPass)
ENDIF
lcSTemp   = []
lcStrPass = []
IF BITAND(tnConfig,64) <> 0
	FOR i = LEN(BufPass1) TO 2 STEP -1
		lcSTemp = lcSTemp + CHR(MOD(ASC(SUBSTR(BufPass1,i,1))-ASC(SUBSTR(BufPass1,i-1,1)),256))
	ENDFOR
	***
	FOR i = LEN(lcSTemp)-1 TO 0 STEP -1
		lcStrPass = lcStrPass + SUBSTR(lcStemp,i+1,1)
	ENDFOR
ELSE
	FOR i = 2 TO LEN(BufPass1)
		lcStrPass = lcStrPass + SUBSTR(BufPass1,i,1)
	ENDFOR
ENDIF
***
RETURN lcStrPass
***
ENDPROC

PROCEDURE DecodeEscapePos
LPARAMETERS lcStr
***
LOCAL i, lcResult, lnSymbol
***
lcResult = []
i = 0
DO WHILE i < LEN(lcStr)
	i = i + 1
	IF ASC(SUBSTR(lcStr,i,1)) = 254
		lnSymbol = ASC(SUBSTR(lcStr,i+1,1))
		DO CASE
			CASE lnSymbol = 1
				lcResult = lcResult + CHR(0)
			CASE lnSymbol = 2
				lcResult = lcResult + CHR(254)
			CASE lnSymbol = 3
				lcResult = lcResult + [ ]
			CASE lnSymbol = 4
				lcResult = lcResult + [\]
			CASE lnSymbol = 4
				lcResult = lcResult + CHR(10)
		ENDCASE
		i = i + 1
	ELSE
		lcResult = lcResult + SUBSTR(lcStr,i,1)
	ENDIF
ENDDO
RETURN lcResult
***
ENDPROC