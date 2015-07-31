*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: IsCasher()
* Called by.......: <NA>
* Parameters......: <nUserId>
* Returns.........: L
* Notes...........: проверим, €вл€етс€ ли сотрудник кассиром
*------------------------------------------------------------------------------
PROCEDURE IsCasher
PARAMETERS nUserId
*-- проверим, €вл€етс€ ли сотрудник кассиром
LOCAL _PARAM

USE IN SELECT([lvcashierByCltView])
_PARAM = nUserId 
**This.spUserClt
USE lvcashierByCltView IN 0

IF RECCOUNT([lvcashierByCltView])<=0
    MESSAGEBOX([ƒанный сотрудник не €вл€етс€ кассиром],48,[ќбратитесь к администратору])
    USE IN SELECT([lvcashierByCltView])
    RETURN .F.
ELSE
    USE IN SELECT([lvcashierByCltView])
    RETURN .T.
ENDIF
ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
