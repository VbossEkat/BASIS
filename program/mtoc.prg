*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: MTOC.PRG
* Module/Procedure: MTOC()
* Called by.......: <N/A>
* Parameters......: <tnMonth>
* Returns.........: <lcMonth>
* Notes...........: �������������� ��������� �������� ������ � ���������� � ������ ������ �����
*-------------------------------------------------------
LPARAMETERS	tnMonth,tnPadezh

LOCAL lcMonth
***

lcMonth = []

DO CASE
	&&������������ �����
	CASE tnPadezh = 1
		DO CASE
			CASE tnMonth = 1
				lcMonth = [������]
			CASE tnMonth = 2
				lcMonth = [�������]
			CASE tnMonth = 3
				lcMonth = [����]
			CASE tnMonth = 4
				lcMonth = [������]
			CASE tnMonth = 5
				lcMonth = [���]
			CASE tnMonth = 6
				lcMonth = [����]
			CASE tnMonth = 7
				lcMonth = [����]
			CASE tnMonth = 8
				lcMonth = [������]
			CASE tnMonth = 9
				lcMonth = [��������]
			CASE tnMonth = 10
				lcMonth = [�������]
			CASE tnMonth = 11
				lcMonth = [������]
			CASE tnMonth = 12
				lcMonth = [�������]
		ENDCASE
	&&����������� �����
	CASE tnPadezh = 2
		DO CASE
			CASE tnMonth = 1
				lcMonth = [������]
			CASE tnMonth = 2
				lcMonth = [�������]
			CASE tnMonth = 3
				lcMonth = [�����]
			CASE tnMonth = 4
				lcMonth = [������]
			CASE tnMonth = 5
				lcMonth = [���]
			CASE tnMonth = 6
				lcMonth = [����]
			CASE tnMonth = 7
				lcMonth = [����]
			CASE tnMonth = 8
				lcMonth = [�������]
			CASE tnMonth = 9
				lcMonth = [��������]
			CASE tnMonth = 10
				lcMonth = [�������]
			CASE tnMonth = 11
				lcMonth = [������]
			CASE tnMonth = 12
				lcMonth = [�������]
		ENDCASE
ENDCASE

RETURN lcMonth
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************