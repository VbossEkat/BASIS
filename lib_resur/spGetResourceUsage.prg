*------------------------------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spGetResourceUsage()
* Called by.......: <NA>
* Parameters......: <tnMsuID, tdStartDate, tuValue>
* Returns.........: <Datetime / Numeric>
* Notes...........: ���������� ������� ������������� ������� (�������� ���� ��� ���������� �������)
* Last Editor.....: �������� ��������
* Last Edit.......: September 13, 2007
*------------------------------------------------------------------------------
PROCEDURE spGetResourceUsage
LPARAMETERS tnMsuID, tdStartDate, tuValue

*13.09.2007 13:51 -> ���������� � ������������� ����������
LOCAL   lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*13.09.2007 13:51 -> ����������� � �� ����� ������������ ����������
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*13.09.2007 14:00 -> ��������� ������
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[MsuTransKoeff = dbo.MsuTransKoeff(MeasureUnit.BaseMsuID, MeasureUnit.MsuID, NULL) ] + ;
		[FROM MeasureUnit ] + ;
		[WHERE MeasureUnit.MsuID = ?tnMsuID],[curMsu])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.09.2007 14:11 -> ������� �������� ���� ������������� �������
IF TYPE([tuValue]) == [N]
	&& ���������� ������� ��������� �� ����������� ��.���. �������, 
	&& ��������� �� 60 ������ � ���������� � ��������� ����
	RETURN tdStartDate + (tuValue * curMsu.MsuTransKoeff * 60) 
ENDIF
*------------------------------------------------------------------------------

*13.09.2007 14:18 -> ������� ���������� ��������������� �������
IF TYPE([tuValue]) == [T]
	&& �� �������� ���� �������� ��������� � ����� ���������� ���������� 
	&& �� 60 ������ � �� ����������� ��.���. �������
	IF (curMsu.MsuTransKoeff * 60) # 0
		RETURN (tuValue - tdStartDate) / (curMsu.MsuTransKoeff * 60)
	ENDIF
ENDIF
*------------------------------------------------------------------------------

*13.09.2007 14:12 -> ���-�� ��������� �� ���
RETURN .F.
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************