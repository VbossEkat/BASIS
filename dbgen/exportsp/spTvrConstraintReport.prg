*-------------------------------------------------------
* Project.........: Basis.pjx
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spTvrConstraintReport()
* Called by.......: <NA>
* Parameters......: <tcQryParSID>
* Returns.........: <lcUniqueName>
* Notes...........: ������� ��� ������ "�������������� �������"
*------------------------------------------------------------------------------
PROCEDURE spTvrConstraintReport
LPARAMETERS tcQryParSID

*19.06.2006 10:26 ->���������� � ������������� ����������
LOCAL	lcOldAlias, ;
		lcUniqueName
***
lcOldAlias = ALIAS()
*------------------------------------------------------------------------------

*19.06.2006 10:18 ->������� ������ ��� ������
lcUniqueName = spTvrConstraintView(tcQryParSID)
*------------------------------------------------------------------------------

*19.06.2006 10:19 ->��������� ������������� �������
SELECT ;
	tmpTvrConstr.TvrID, ;
	tmpTvrConstr.TvrNM, ;
	tmpTvrConstr.OUNM, ;
	tmpTvrConstr.MsuNM, ;
	tmpTvrConstr.TvrMinQnt, ;
	tmpTvrConstr.TvrMaxQnt, ;
	tmpTvrConstr.TvrCurQnt ;
FROM ([tmp\]+lcUniqueName) tmpTvrConstr ;
WHERE tmpTvrConstr.TvrMinQnt > tmpTvrConstr.TvrCurQnt ;
INTO TABLE tmp\RptItog
*------------------------------------------------------------------------------

*19.06.2006 10:24 ->��������� �������
USE IN IIF(USED(lcUniqueName),lcUniqueName,0)
USE IN SELECT([RptItog])
*------------------------------------------------------------------------------

*19.06.2006 10:26 ->����������� ������� Alias
IF !EMPTY(lcOldAlias) AND USED(lcOldAlias) AND lcOldAlias#ALIAS()
	SELECT(lcOldAlias)
ENDIF
*------------------------------------------------------------------------------

*19.06.2006 10:26 ->������ ��������
RETURN [PrtItog.dbf]
*------------------------------------------------------------------------------

ENDPROC 
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
