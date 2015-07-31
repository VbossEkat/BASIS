LOCAL lnFrmID

SELECT ;
	FrmId, ;
	FrmDate, ;
	FrmDateAcc, ;
	FrmTypeID ;
FROM Form ;
WHERE FrmStatusID > 1;
ORDER BY 3 DESC ;
INTO CURSOR curForm
** INLIST(FrmTypeID,1,3,5) ;
*!*	USE Form IN 0 SHARED
*!*    SELECT Form
*!*    REPLACE Form.FrmDateAcc WITH Form.FrmDate ALL FOR EMPTY(Form.FrmDateAcc)

*!*	SELECT ;
*!*		Form.FrmId, ;
*!*		Form.FrmDate, ;
*!*		Form.FrmDateAcc, ;
*!*		Form.FrmTypeID ;
*!*	FROM Form ;
*!*	INNER JOIN AccForm ON AccForm.FrmID = Form.FrmID ;
*!*	WHERE INLIST(Form.FrmTypeID,1,3,5) ;
*!*	ORDER BY 3,4;
*!*	INTO CURSOR curForm

lnSeconds = Seconds()

SELECT curForm
SCAN ALL
	
	lnFrmID = curForm.FrmID
	
	WAIT WINDOW [ДеАкцепт документа ]+ALLTRIM(STR(RECNO(),8,0))+[ из ]+ALLTRIM(STR(RECCOUNT(),8,0)) NOWAIT NOCLEAR
	SET MESSAGE TO [ДеАкцепт документа ]+ALLTRIM(STR(RECNO(),8,0))+[ из ]+ALLTRIM(STR(RECCOUNT(),8,0))
	
	UPDATE Form ;
	SET ;
		FrmStatusID = 1 ;
	WHERE Form.FrmID = lnFrmID

SELECT curForm	
ENDSCAN

lnSeconds = SECONDS() - lnSeconds
=MESSAGEBOX('Остатки колбасились '+ALLTRIM(STR(lnSeconds,10,0)),48,'Предупреждение')
