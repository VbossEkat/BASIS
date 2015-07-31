*20.01.2006 09:49 ->Определим переменнюя для управления работы с остатками
PUBLIC qlStockAccountEnabled
*------------------------------------------------------------------------------

*20.01.2006 09:50 ->Запретим работу с остатками
qlStockAccountEnabled = .F.
*------------------------------------------------------------------------------

*20.01.2006 09:49 ->Объявление и инициализация переменных
LOCAL   lnFrmID, ;
		lnSeconds
*------------------------------------------------------------------------------

*20.01.2006 09:53 ->Восстановим даты учета документов
UPDATE Form ;
	SET FrmDateAcc = FrmDate ;
WHERE EMPTY(Form.FrmDateAcc)
*------------------------------------------------------------------------------

*20.01.2006 09:51 ->Выберем все акцептованные накладные
SELECT ;
	Form.FrmID ;
FROM Form ;
WHERE INLIST(Form.FrmTypeID,1,3,5,20) AND Form.FrmStatusID > 2 ;
INTO TABLE tmp\AccForm
*------------------------------------------------------------------------------

*20.01.2006 09:55 ->Определим список документов для проводки
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

*20.01.2006 09:58 ->Снимем акцепт с необходимых документов
UPDATE Form ;
	SET FrmStatusID = 1 ;
WHERE INLIST(Form.FrmTypeID,1,3,5,20) AND Form.FrmStatusID > 2
*------------------------------------------------------------------------------

*20.01.2006 09:59 ->Чистим остатки
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

*20.01.2006 09:50 ->Разрешим работу с остатками
qlStockAccountEnabled = .T.
*------------------------------------------------------------------------------

*20.01.2006 10:01 ->Проводим документы
lnSeconds = Seconds()

SELECT curForm
SCAN ALL
	
	lnFrmID = curForm.FrmID
	
	WAIT WINDOW [Акцепт документа ]+ALLTRIM(STR(lnFrmID,8,0))+[. Всего: ]+ALLTRIM(STR(RECNO(),8,0))+[ из ]+ALLTRIM(STR(RECCOUNT(),8,0)) NOWAIT NOCLEAR
	SET MESSAGE TO [Акцепт документа ]+ALLTRIM(STR(lnFrmID,8,0))+[. Всего: ]+ALLTRIM(STR(RECNO(),8,0))+[ из ]+ALLTRIM(STR(RECCOUNT(),8,0))
	
	UPDATE Form ;
	SET ;
		FrmStatusID = 3 ;
	WHERE Form.FrmID = lnFrmID

SELECT curForm	
ENDSCAN

WAIT CLEAR
SET MESSAGE TO []

lnSeconds = SECONDS() - lnSeconds
MESSAGEBOX([Процедура выполнялась ]+ALLTRIM(STR(lnSeconds,10,0)),48,[Предупреждение])
*------------------------------------------------------------------------------

RELEASE qlStockAccountEnabled
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************