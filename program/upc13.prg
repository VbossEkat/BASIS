*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: upc13.prg
* Module/Procedure: upc13()
* Called by.......: <N/A>
* Parameters......: <tcBarcode>
* Returns.........: <lcResult>
* Notes...........: Преобразование штрих-кода (EAN 13)
*-------------------------------------------------------

*17.08.2005 16:42 -> Объявим константы
#DEFINE	pcvSOURCE		[0123456789]
#DEFINE	pcvTYPE			[#$%&'()*+,]
#DEFINE	pcvLEFT_ALT_A	[0123456789]
#DEFINE	pcvLEFT_ALT_B	[ABCDEFGHIJ]
#DEFINE	pcvRIGHT		[abcdefghij]
*------------------------------------------------------------------------------

LPARAMETERS tcBarcode

*17.08.2005 16:53 -> Объявление и инициализация переменных
LOCAL	laBarcode[13], ;
		lcResult
***
FOR lnCounter = 1 TO ALEN(laBarcode)
	laBarcode[lnCounter] = ALLTRIM(SUBSTR(tcBarcode,lnCounter,1))
ENDFOR
***
lcResult = []
*------------------------------------------------------------------------------

*17.08.2005 17:20 -> Формируем начало штрих-кода
lcResult = lcResult + CHRTRAN(laBarcode[1],pcvSOURCE,pcvTYPE) + [!]
*------------------------------------------------------------------------------

*17.08.2005 17:21 -> Формируем левую часть штрих-кода
lcResult = lcResult + CHRTRAN(laBarcode[2],pcvSOURCE,pcvLEFT_ALT_A)
***
DO CASE
	CASE laBarcode[1] == [0]
		lcResult = lcResult + CHRTRAN(laBarcode[3],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[4],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[5],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[6],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[7],pcvSOURCE,pcvLEFT_ALT_A)
	CASE laBarcode[1] == [1]
		lcResult = lcResult + CHRTRAN(laBarcode[3],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[4],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[5],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[6],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[7],pcvSOURCE,pcvLEFT_ALT_B)
	CASE laBarcode[1] == [2]
		lcResult = lcResult + CHRTRAN(laBarcode[3],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[4],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[5],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[6],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[7],pcvSOURCE,pcvLEFT_ALT_B)
	CASE laBarcode[1] == [3]
		lcResult = lcResult + CHRTRAN(laBarcode[3],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[4],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[5],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[6],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[7],pcvSOURCE,pcvLEFT_ALT_A)
	CASE laBarcode[1] == [4]
		lcResult = lcResult + CHRTRAN(laBarcode[3],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[4],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[5],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[6],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[7],pcvSOURCE,pcvLEFT_ALT_B)
	CASE laBarcode[1] == [5]
		lcResult = lcResult + CHRTRAN(laBarcode[3],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[4],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[5],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[6],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[7],pcvSOURCE,pcvLEFT_ALT_B)
	CASE laBarcode[1] == [6]
		lcResult = lcResult + CHRTRAN(laBarcode[3],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[4],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[5],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[6],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[7],pcvSOURCE,pcvLEFT_ALT_A)
	CASE laBarcode[1] == [7]
		lcResult = lcResult + CHRTRAN(laBarcode[3],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[4],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[5],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[6],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[7],pcvSOURCE,pcvLEFT_ALT_B)
	CASE laBarcode[1] == [8]
		lcResult = lcResult + CHRTRAN(laBarcode[3],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[4],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[5],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[6],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[7],pcvSOURCE,pcvLEFT_ALT_A)
	CASE laBarcode[1] == [9]
		lcResult = lcResult + CHRTRAN(laBarcode[3],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[4],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[5],pcvSOURCE,pcvLEFT_ALT_A)
		lcResult = lcResult + CHRTRAN(laBarcode[6],pcvSOURCE,pcvLEFT_ALT_B)
		lcResult = lcResult + CHRTRAN(laBarcode[7],pcvSOURCE,pcvLEFT_ALT_A)
	OTHERWISE
		RETURN [ERROR]
ENDCASE
***
lcResult = lcResult + [-]
*------------------------------------------------------------------------------

*17.08.2005 17:22 -> Формируем правую часть штрих-кода
FOR lnCounter = 8 TO 13
	lcResult = lcResult + CHRTRAN(laBarcode[lnCounter],pcvSOURCE,pcvRIGHT)
ENDFOR
***
lcResult = lcResult + [!]
*------------------------------------------------------------------------------

*17.08.2005 16:55 -> Возвращаем результат
RETURN lcResult
*------------------------------------------------------------------------------

*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************