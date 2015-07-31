#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*15.05.2006 13:12 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: ЖХО] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: ЖХО]
***
lvAccBuch()
lvAccBuchEdit()
lvAccBuchView()
lvAutoOper()
lvAutoOperEdit()
lvAutoProv()
lvAutoProvEdit()
lvOperSpr()
lvPrBookEdit()
lvPrBookView()
lvSummList()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV PBook: /*
PROCEDURE lvAccBuch
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvAccBuch REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	AccBuch.AccID, ;
	RTRIM(AccBuch.AccBuch)+' '+RTRIM(AccBuch.AccNM) AS AccNm, ;
	Accbuch.AccParID, ;
	Accbuch.AccPlanID ;
FROM Accbuch ;
ORDER BY AccBuch.AccBuch, AccBuch.AccNM
***
DBSETPROP([lvAccBuch],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvAccBuch],[VIEW],[COMMENT],[LV PBook: ])
***
ENDPROC
*------------------------------------------------------------------------------

PROCEDURE lvAccBuchEdit
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvAccBuchEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Accbuch.AccID, ;
	Accbuch.AccParID, ;
	Accbuch.AccPlanID, ;
	Accbuch.AccBuch, ;
	Accbuch.AccNM, ;
	Accbuch.IsParent, ;
	Accbuch.AccActive, ;
	Accbuch.AccSaldoType, ;
	Accbuch.IsAnalytic, ;
	Accbuch.AccAnalyticSpr, ;
	Accbuch.AccAnalyticDoc ;
FROM Accbuch ;
WHERE Accbuch.AccID = ?_PARAM
***
DBSETPROP([lvAccBuchEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvAccBuchEdit],[VIEW],[WhereType],1)
***
DBSETPROP([lvAccBuchEdit.AccID],[FIELD],[KeyField],.T.)
DBSETPROP([lvAccBuchEdit.AccID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvAccBuchEdit.AccParID],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccBuchEdit.Accplanid],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccBuchEdit.Accbuch],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccBuchEdit.Accnm],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccBuchEdit.IsParent],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccBuchEdit.AccActive],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccBuchEdit.AccSaldoType],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccBuchEdit.IsAnalytic],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccBuchEdit.AccAnalyticSpr],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccBuchEdit.AccAnalyticDoc],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvAccBuchEdit],[VIEW],[FetchSize],-1)
***
ENDPROC
*------------------------------------------------------------------------------

PROCEDURE lvAccBuchView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvAccBuchView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Accbuch.AccID, ;
	AccbuchPar.AccBuch AS ParBuch, ;
	Accbuch.AccParID, ;
	Accbuch.AccPlanID, ;
	Accbuch.AccBuch, ;
	Accbuch.AccNM, ;
	Accbuch.IsParent, ;
	Accbuch.AccActive, ;
	Accbuch.AccSaldoType, ;
	Accbuch.IsAnalytic, ;
	Accbuch.AccAnalyticSpr, ;
	Accbuch.AccAnalyticDoc ;
FROM Accbuch ;
LEFT JOIN AccBuch AccbuchPar ON Accbuch.AccParID = AccbuchPar.AccID ;
WHERE Accbuch.AccPlanID = ?_PARAM ;
ORDER BY AccbuchPar.AccNM, Accbuch.AccBuch
***
DBSETPROP([lvAccBuchView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvAccBuchView],[VIEW],[COMMENT],[LV PBook: ])
***
ENDPROC
*------------------------------------------------------------------------------

PROCEDURE lvAutoOper
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvAutoOper REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Sproper.OperID, ;
	Frmtype.FrmTypeNM, ;
	Sproper.FrmTypeID, ;
	Sproper.OperNM, ;
	Sproper.OperNote, ;
	Sproper.OperSign, ;
	Sproper.IsDefault, ;
	Sproper.IsManual, ;
	Sproper.Stamp_, ;
	Sproper.User_ ;
FROM Sproper ;
LEFT JOIN FrmType Frmtype ON Sproper.FrmTypeID = Frmtype.FrmTypeID
***
DBSETPROP([lvAutoOper],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvAutoOper],[VIEW],[COMMENT],[LV PBook: Просмотр справочника автоматических проводок])
***
ENDPROC
*------------------------------------------------------------------------------

PROCEDURE lvAutoOperEdit
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvAutoOperEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Sproper.OperID, ;
	Sproper.FrmTypeID, ;
	Sproper.OperNM, ;
	Sproper.OperNote, ;
	Sproper.OperSign, ;
	Sproper.IsDefault, ;
	Sproper.IsManual, ;
	Sproper.Stamp_, ;
	Sproper.User_ ;
FROM Sproper;
WHERE Sproper.OperID = ?_PARAM
***
DBSETPROP([lvAutoOperEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvAutoOperEdit],[VIEW],[WhereType],1)
***
DBSETPROP([lvAutoOperEdit.OperID],[FIELD],[KeyField],.T.)
DBSETPROP([lvAutoOperEdit.OperID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvAutoOperEdit.FrmTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvAutoOperEdit.OperNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvAutoOperEdit.OperNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvAutoOperEdit.OperSign],[FIELD],[Updatable],.T.)
DBSETPROP([lvAutoOperEdit.IsDefault],[FIELD],[Updatable],.T.)
DBSETPROP([lvAutoOperEdit.IsManual],[FIELD],[Updatable],.T.)
DBSETPROP([lvAutoOperEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvAutoOperEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvAutoOperEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvAutoOperEdit],[VIEW],[COMMENT],[LV PBook: Просмотр справочника автоматических проводок])
***
ENDPROC
*------------------------------------------------------------------------------

PROCEDURE lvAutoProv
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvAutoProv REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Sprprov.ProvID, ;
	Sprprov.OperID, ;
	Sprprov.DebetID, ;
	Accplan.accbuch+' '+Accplan.accnm AS accdeb, ;
	Sprprov.CreditID, ;
	AccBuch.accbuch+' '+AccBuch.accnm AS acccre, ;
	Sprprov.DebetNote, ;
	Sprprov.CreditNote, ;
	Sprsummlist.summnm+' * '+Sprprov.provformula AS provformula, ;
	Sprprov.ProvNote, ;
	Sprprov.Stamp_, ;
	Sprprov.User_ ;
FROM Sprprov ;
LEFT JOIN AccBuch Accplan ON Sprprov.DebetID = Accplan.AccID ;
LEFT JOIN SprSummList ON Sprprov.SummFld = Sprsummlist.SummId ;
LEFT JOIN AccBuch ON  Sprprov.CreditID = AccBuch.AccID ;
WHERE  Sprprov.OperID = ?_PARAM
***
DBSETPROP([lvAutoProv],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvAutoProv],[VIEW],[COMMENT],[LV PBook: ])
***
ENDPROC
*------------------------------------------------------------------------------

PROCEDURE lvAutoProvEdit
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvAutoProvEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Sprprov.ProvID, ;
	Sprprov.OperID, ;
	Sprprov.SummFld,;
	Sprprov.ProvFormula, ;
	Sprprov.DebetID, ;
	Sprprov.DebetNote, ;
	Sprprov.CreditID, ;
	Sprprov.CreditNote, ;
	Sprprov.ProvNote ;
FROM Sprprov ;
WHERE Sprprov.ProvID = ?_PARAM
***
DBSETPROP([lvAutoProvEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvAutoProvEdit],[VIEW],[WhereType],1)
***
DBSETPROP([lvAutoProvEdit.ProvID],[FIELD],[KeyField],.T.)
DBSETPROP([lvAutoProvEdit.ProvID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvAutoProvEdit.OperID],[FIELD],[DefaultValue],[?_PARAM])
DBSETPROP([lvAutoProvEdit.OperID],[FIELD],[Updatable],.T.)
DBSETPROP([lvAutoProvEdit.summfld],[FIELD],[Updatable],.T.)
DBSETPROP([lvAutoProvEdit.summfld],[FIELD],[DataType],[I])
DBSETPROP([lvAutoProvEdit.provformula],[FIELD],[Updatable],.T.)
DBSETPROP([lvAutoProvEdit.debetid],[FIELD],[Updatable],.T.)
DBSETPROP([lvAutoProvEdit.debetnote],[FIELD],[Updatable],.T.)
DBSETPROP([lvAutoProvEdit.creditid],[FIELD],[Updatable],.T.)
DBSETPROP([lvAutoProvEdit.creditnote],[FIELD],[Updatable],.T.)
DBSETPROP([lvAutoProvEdit.provnote],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvAutoProvEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvAutoProvEdit],[VIEW],[COMMENT],[LV PBook: ])
***
ENDPROC
*------------------------------------------------------------------------------

PROCEDURE lvOperSpr
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvOperSpr REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Sproper.OperID, ;
	Sproper.OperNM, ;
	Sproper.IsDefault, ;
	Sproper.IsManual ;
FROM SprOper ;
WHERE SprOper.FrmTypeID = ?_PARAM ;
ORDER BY Sproper.OperNM
***
DBSETPROP([lvOperSpr],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOperSpr],[VIEW],[COMMENT],[LV PBook: ])
***
ENDPROC
*------------------------------------------------------------------------------

PROCEDURE lvPrBookEdit
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvPrBookEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Practicalbook.PBookID, ;
	Practicalbook.PBookFrmID, ;
	Practicalbook.PBookProvID, ;
	Practicalbook.PBookSum, ;
	Practicalbook.DebetID, ;
	Practicalbook.CreditID, ;
	Practicalbook.PBookNote, ;
	Practicalbook.FrmPartId ;
FROM PracticalBook ;
WHERE Practicalbook.PBookID = ?_PARAM
***
DBSETPROP([lvPrBookEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvPrBookEdit],[VIEW],[WhereType],1)
***
DBSETPROP([lvPrBookEdit.PBookID],[FIELD],[KeyField],.T.)
DBSETPROP([lvPrBookEdit.PBookID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvPrBookEdit.pbookfrmid],[FIELD],[Updatable],.T.)
DBSETPROP([lvPrBookEdit.pbookprovid],[FIELD],[Updatable],.T.)
DBSETPROP([lvPrBookEdit.pbooksum],[FIELD],[Updatable],.T.)
DBSETPROP([lvPrBookEdit.debetid],[FIELD],[Updatable],.T.)
DBSETPROP([lvPrBookEdit.creditid],[FIELD],[Updatable],.T.)
DBSETPROP([lvPrBookEdit.pbooknote],[FIELD],[Updatable],.T.)
DBSETPROP([lvPrBookEdit.frmpartid],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvPrBookEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPrBookEdit],[VIEW],[COMMENT],[LV PBook: ])
***
ENDPROC
*------------------------------------------------------------------------------

PROCEDURE lvPrBookView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvPrBookView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Practicalbook.PBookID, ;
	Practicalbook.PBookFrmID,;
	Practicalbook.PBookProvID, ;
	Practicalbook.PBookSum, ;
	Practicalbook.DebetID, ;
	Practicalbook.CreditID, ;
	Practicalbook.FrmPartId ;
FROM Practicalbook;
WHERE Practicalbook.PBookFrmID = ?_PARAM
***
DBSETPROP([lvPrBookView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPrBookView],[VIEW],[COMMENT],[LV PBook: ])
***
ENDPROC
*------------------------------------------------------------------------------

PROCEDURE lvSummList
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvSummList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Sprsummlist.SummId, ;
	Sprsummlist.SummNm ;
FROM SprSummList ;
ORDER BY Sprsummlist.SummNm
***
DBSETPROP([lvSummList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvSummList],[VIEW],[COMMENT],[LV PBook: ])
***
ENDPROC
*------------------------------------------------------------------------------

PROCEDURE lvAccBuch_copy 
*** 
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvAccBuch_copy REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	AccBuch.AccID, ;
	RTRIM(AccBuch.AccBuch)+' '+RTRIM(AccBuch.AccNM) AS AccNM, ;
	AccBuch.AccParID, ;
	AccBuch.AccPlanID ;
FROM ;
	Accbuch Accbuch;
ORDER BY AccBuch.AccBuch, AccBuch.AccNM
***
DBSETPROP([lvAccBuch_copy],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvAccBuch_copy],[View],[Comment],[LV PBook: ])
DBSETPROP([lvAccBuch_copy],[View],[SendUpdates],.F.)
***
ENDPROC
*------------------------------------------------------------------------------