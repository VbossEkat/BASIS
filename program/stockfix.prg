*20.01.2006 09:49 ->��������� ���������� ��� ���������� ������ � ���������
PUBLIC qlStockAccountEnabled
*------------------------------------------------------------------------------

*20.01.2006 09:50 ->�������� ������ � ���������
qlStockAccountEnabled = .F.
*------------------------------------------------------------------------------

*20.01.2006 09:49 ->���������� � ������������� ����������
LOCAL   lnFrmID, ;
		lnSeconds
*------------------------------------------------------------------------------

*20.01.2006 09:53 ->����������� ���� ����� ����������
UPDATE Form ;
	SET FrmDateAcc = FrmDate ;
WHERE EMPTY(Form.FrmDateAcc)
*------------------------------------------------------------------------------

*20.01.2006 09:51 ->������� ��� ������������� ���������
SELECT ;
	Form.FrmID ;
FROM Form ;
WHERE INLIST(Form.FrmTypeID,1,3,5,20) AND Form.FrmStatusID > 2 ;
INTO TABLE tmp\AccForm
*------------------------------------------------------------------------------

*20.01.2006 09:55 ->��������� ������ ���������� ��� ��������
SELECT ;
	Form.FrmId, ;
	Form.FrmDate, ;
	Form.FrmDateAcc, ;
	Form.FrmTypeID ;
FROM Form ;
WHERE INLIST(Form.FrmTypeID,1,3,5,20) ;
INTO CURSOR curForm && AND Form.FrmStatusID > 2 ;
&& ORDER BY 3,4 ;

*------------------------------------------------------------------------------

*20.01.2006 09:58 ->������ ������ � ����������� ����������
UPDATE Form ;
	SET FrmStatusID = 1 ;
WHERE INLIST(Form.FrmTypeID,1,3,5,20) AND Form.FrmStatusID > 2
*------------------------------------------------------------------------------

*20.01.2006 09:59 ->������ �������
USE StockTrans IN 0 EXCLUSIVE
SELECT StockTrans
ZAP
USE
***
USE Stock IN 0 EXCLUSIVE
SELECT Stock
ZAP
USE
***
USE StockTransDetail IN 0 EXCLUSIVE
SELECT StockTransDetail
ZAP
USE
*------------------------------------------------------------------------------

*20.01.2006 09:50 ->�������� ������ � ���������
qlStockAccountEnabled = .T.
*------------------------------------------------------------------------------

*20.01.2006 10:01 ->�������� ���������
lnSeconds = Seconds()

SELECT curForm
SCAN ALL
	
	lnFrmID = curForm.FrmID
	
	WAIT WINDOW [������ ��������� ]+ALLTRIM(STR(lnFrmID,8,0))+[. �����: ]+ALLTRIM(STR(RECNO(),8,0))+[ �� ]+ALLTRIM(STR(RECCOUNT(),8,0)) NOWAIT NOCLEAR
	SET MESSAGE TO [������ ��������� ]+ALLTRIM(STR(lnFrmID,8,0))+[. �����: ]+ALLTRIM(STR(RECNO(),8,0))+[ �� ]+ALLTRIM(STR(RECCOUNT(),8,0))
	
	UPDATE Form ;
	SET ;
		FrmStatusID = 3 ;
	WHERE Form.FrmID = lnFrmID

SELECT curForm	
ENDSCAN

WAIT CLEAR
SET MESSAGE TO []

lnSeconds = SECONDS() - lnSeconds
MESSAGEBOX([��������� ����������� ]+ALLTRIM(STR(lnSeconds,10,0)),48,[��������������])
*------------------------------------------------------------------------------

RELEASE qlStockAccountEnabled
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************