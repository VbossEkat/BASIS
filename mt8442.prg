*------------------------------------------------------------------------------
* Project.........: MT8442.pjx
* File............: MT8442.prg
* Module/Procedure: MT8442()
* Called by.......: <NA>
* Parameters......: <tcCommand>
* Returns.........: <none>
* Notes...........: ������� ��� MT8442
*------------------------------------------------------------------------------
LPARAMETERS	tcCommand

*08.09.2005 16:26 -> ���������� �������������
#DEFINE LOC_DRV_NAME [MT8442.APP]
#DEFINE LOC_VERSION [1.0.0.1]
*------------------------------------------------------------------------------

*08.09.2005 17:19 -> ��� ������� ��� ���������� - ������� ���������� � ������
IF TYPE([tcCommand])#[C]
	tcCommand = [VER]
ELSE
	tcCommand = UPPER(ALLTRIM(tcCommand))
ENDIF
*------------------------------------------------------------------------------

*08.09.2005 16:36 -> ��������� ��������� �������
DO CASE
	CASE tcCommand == [VER] &&���������� � ������

		*08.09.2005 16:34 -> ������� ����� ������
		RETURN LOC_VERSION
		*------------------------------------------------------------------------------

	OTHERWISE

		*08.09.2005 16:32 -> ��������
		MESSAGEBOX(LOC_DRV_NAME+[(]+LOC_VERSION+[): �������� ������� ��� ������ ������� �� �������������� ������ ������� ��������!],48,[��������������...])
		*------------------------------------------------------------------------------

ENDCASE
*------------------------------------------------------------------------------

*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************