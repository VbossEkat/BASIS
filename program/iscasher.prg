*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: IsCasher()
* Called by.......: <NA>
* Parameters......: <nUserId>
* Returns.........: L
* Notes...........: ��������, �������� �� ��������� ��������
*------------------------------------------------------------------------------
PROCEDURE IsCasher
PARAMETERS nUserId
*-- ��������, �������� �� ��������� ��������
LOCAL _PARAM

USE IN SELECT([lvcashierByCltView])
_PARAM = nUserId 
**This.spUserClt
USE lvcashierByCltView IN 0

IF RECCOUNT([lvcashierByCltView])<=0
    MESSAGEBOX([������ ��������� �� �������� ��������],48,[���������� � ��������������])
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
