*------------------------------------------------------------------------------
* Project.........: AS@R_BASIS_Exchange.pjx
* File............: EXCHANGE_SERVER.PRG
* Module/Procedure: Startup()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: ����� ������� ASR<==>BASIS
*------------------------------------------------------------------------------

*29.06.2005 17:25 ->��� ����������� ������������ ���������� ���������� ���������
#DEFINE cnAPPLICATION_NAME	MTX_Basis_Exchange
*------------------------------------------------------------------------------
*12.10.2005 10:47 ->
SET STRICTDATE TO 0
SET ENGINEBEHAVIOR 70
*------------------------------------------------------------------------------

*19.01.2005 17:43 ->���������� � ������������� ����������
LOCAL	lcOldPath, ;
		lcApplicationNM, ;
		lcApplicationClassLib
***
lcOldPath = SET([PATH])
lcApplicationNM = [cnAPPLICATION_NAME]
lcApplicationClassLib = lcApplicationNM + [.VCX]
*------------------------------------------------------------------------------

*29.06.2005 17:30 ->���������� ������ � ���������� ���������
*ON ERROR Error_Handler()
ON SHUTDOWN CLEAR EVENTS
*------------------------------------------------------------------------------

*29.06.2005 17:30 ->��������� ����
SET PATH TO (lcOldPath + [;tmp;data;Libs;Menus])
*------------------------------------------------------------------------------

*29.06.2005 17:30 ->������� ������ ����������
IF !(lcApplicationClassLib$SET([CLASSLIB]))
	SET CLASSLIB TO (lcApplicationClassLib) ALIAS (lcApplicationNM) ADDITIVE
	llLibLoad = .T.
ELSE
	llLibLoad = .F.	
ENDIF

oApp = CREATEOBJECT(lcApplicationNM,lcApplicationNM)
IF llLibLoad
	RELEASE CLASSLIB ALIAS (lcApplicationNM)
ENDIF
*------------------------------------------------------------------------------

*29.06.2005 17:30 ->������ ����������
IF TYPE([oApp])==[O] AND !ISNULL(oApp)
	oApp.Show()
	READ EVENTS
ENDIF
*------------------------------------------------------------------------------

*05.08.2003 15:20 ->�������������� �����
CLEAR DLLS
ON SHUTDOWN
CLEAR ALL
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************