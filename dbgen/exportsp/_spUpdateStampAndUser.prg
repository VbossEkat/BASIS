*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: _spUpdateStampAndUser()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: <~>
*------------------------------------------------------------------------------
PROCEDURE _spUpdateStampAndUser
LPARAMETERS tcAliasName, tnUserID

*23.01.2006 15:00 -> Объявление и инициализация переменных
LOCAL	lnFieldCount, ;
		lnCounter, ;
		llFieldIsExist
***
lnFieldCount = AFIELDS(laFieldArray,tcAliasName)
*------------------------------------------------------------------------------

*23.01.2006 15:40 -> Обновляем идентификатор пользователя
llFieldIsExist = .F.
***
FOR lnCounter = 1 TO lnFieldCount
	IF UPPER(ALLTRIM(laFieldArray(lnCounter,1))) == [USER_]
		llFieldIsExist = .T.
		EXIT
	ENDIF
ENDFOR
***
IF llFieldIsExist
	REPLACE User_ WITH tnUserID IN (tcAliasName)
ENDIF
*------------------------------------------------------------------------------

*23.01.2006 11:36 -> Возвращаем результат
RETURN .T.
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
