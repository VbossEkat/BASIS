*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: upc8.prg
* Module/Procedure: upc8()
* Called by.......: <N/A>
* Parameters......: <tcBarcode>
* Returns.........: <lcResult>
* Notes...........: Преобразование штрих-кода (EAN 8)
*-------------------------------------------------------

*17.08.2005 16:42 -> Объявим константы
#DEFINE	pcvSOURCE		[0123456789]
#DEFINE	pcvLEFT			[ABCDEFGHIJ]
#DEFINE	pcvRIGHT		[abcdefghij]
*------------------------------------------------------------------------------

LPARAMETERS tcBarcode

*17.08.2005 16:53 -> Объявление и инициализация переменных
LOCAL	laBarcode[8], ;
		lcResult
***
FOR lnCounter = 1 TO ALEN(laBarcode)
	laBarcode[lnCounter] = ALLTRIM(SUBSTR(tcBarcode,lnCounter,1))
ENDFOR
***
lcResult = [!]
*------------------------------------------------------------------------------

*17.08.2005 17:21 -> Формируем левую часть штрих-кода
FOR lnCounter = 1 TO 4
	lcResult = lcResult + CHRTRAN(laBarcode[lnCounter],pcvSOURCE,pcvLEFT)
ENDFOR
***
lcResult = lcResult + [-]
*------------------------------------------------------------------------------

*17.08.2005 17:22 -> Формируем правую часть штрих-кода
FOR lnCounter = 5 TO 8
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