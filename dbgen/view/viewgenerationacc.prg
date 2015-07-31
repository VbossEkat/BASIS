#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*15.05.2006 13:12 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Калькуляция] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Калькуляция]
***
lvAccountingEdit()
lvbludolist()
lvAccLastBuy()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV ACC: редактирование калькуляционной формы/*
PROCEDURE lvAccountingEdit
***
CREATE SQL VIEW lvAccountingEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Accounting.AccFrmID, ;
	Accounting.AccTvrId, ;
	Tovar.MsuId, ;
	Accounting.AccQnt, ;
	Accounting.AccExit, ;
	Accounting.AccNetto, ;
	Accounting.AccIsActiv, ;
	Accounting.AccTCard, ;
	Accounting.AccColor, ;
	Accounting.AccPrice, ;
	Accounting.AccAppr, ;
	Accounting.AccTaste, ;
	Accounting.AccSmell, ;
	Accounting.AccState, ;
	Accounting.AccTech, ;
	Accounting.AccCaloric, ;
	Accounting.AccFiber, ;
	Accounting.AccFat, ;
	Accounting.AccCarb, ;
	Accounting.AccNote, ;
	Accounting.Stamp_, ;
	Accounting.User_ ;
FROM Accounting ;
INNER JOIN Tovar ON Tovar.TvrId = Accounting.AccTvrId ;
WHERE AccFrmID = ?_PARAM
***
DBSETPROP([lvAccountingEdit.AccFrmID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvAccountingEdit.AccFrmID],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccTvrId],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccQnt],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccExit],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccNetto],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccIsActiv],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccTCard],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccColor],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccPrice],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccAppr],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccTaste],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccSmell],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccState],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccTech],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccCaloric],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccFiber],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccFat],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccCarb],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.AccNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.Stamp_ ],[FIELD],[Updatable],.T.)
DBSETPROP([lvAccountingEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvAccountingEdit.AccTech],[FIELD],[DataType],[M])
***
DBSETPROP([lvAccountingEdit.AccQnt],[FIELD],[DefaultValue],[1])
DBSETPROP([lvAccountingEdit.AccExit],[FIELD],[DefaultValue],[""])
DBSETPROP([lvAccountingEdit.AccNetto],[FIELD],[DefaultValue],[0])
DBSETPROP([lvAccountingEdit.AccIsActiv],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvAccountingEdit.AccTCard],[FIELD],[DefaultValue],[""])
DBSETPROP([lvAccountingEdit.AccColor],[FIELD],[DefaultValue],[""])
DBSETPROP([lvAccountingEdit.AccPrice],[FIELD],[DefaultValue],[0])
DBSETPROP([lvAccountingEdit.AccAppr],[FIELD],[DefaultValue],[""])
DBSETPROP([lvAccountingEdit.AccTaste],[FIELD],[DefaultValue],[""])
DBSETPROP([lvAccountingEdit.AccSmell],[FIELD],[DefaultValue],[""])
DBSETPROP([lvAccountingEdit.AccState],[FIELD],[DefaultValue],[""])
DBSETPROP([lvAccountingEdit.AccTech],[FIELD],[DefaultValue],[""])
DBSETPROP([lvAccountingEdit.AccCaloric],[FIELD],[DefaultValue],[0])
DBSETPROP([lvAccountingEdit.AccFiber],[FIELD],[DefaultValue],[0])
DBSETPROP([lvAccountingEdit.AccFat],[FIELD],[DefaultValue],[0])
DBSETPROP([lvAccountingEdit.AccCarb],[FIELD],[DefaultValue],[0])
DBSETPROP([lvAccountingEdit.AccNote],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvAccountingEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvAccountingEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvAccountingEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvAccountingEdit],[VIEW],[COMMENT],[LV ACC: редактирование калькуляционной формы])
***
ENDPROC
*------------------------------------------------------------------------------

PROCEDURE lvbludolist
***
CREATE SQL VIEW lvbludolist REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT Tovar.tvrid, Tovar.tvrnm;
 FROM ;
     Tovar ;
    INNER JOIN TvrType ;
   ON  Tovar.tvrtypeid = Tvrtype.tvrtypeid;
WHERE ;
	Tvrtype.tvrtypeiscnt = 0 AND ;
	Tovar.tvrtypeid IN (5,6) ;
ORDER BY Tovar.tvrnm

DBSETPROP([lvbludolist],[VIEW],"Comment","LV TVR: список товаров.")
DBSETPROP([lvbludolist],[VIEW],"SendUpdates",.F.)
DBSETPROP([lvbludolist],[VIEW],"BatchUpdateCount",1)
DBSETPROP([lvbludolist],[VIEW],"CompareMemo",.T.)
DBSETPROP([lvbludolist],[VIEW],"FetchAsNeeded",.F.)
DBSETPROP([lvbludolist],[VIEW],"FetchMemo",.T.)
DBSETPROP([lvbludolist],[VIEW],"FetchSize",100)
DBSETPROP([lvbludolist],[VIEW],"MaxRecords",-1)
DBSETPROP([lvbludolist],[VIEW],"Prepared",.F.)
DBSETPROP([lvbludolist],[VIEW],"UpdateType",1)
DBSETPROP([lvbludolist],[VIEW],"UseMemoSize",255)
DBSETPROP([lvbludolist],[VIEW],"Tables","tovar")
DBSETPROP([lvbludolist],[VIEW],"WhereType",3)

DBSETPROP([lvbludolist]+".tvrid",[FIELD],"DataType","I")
DBSETPROP([lvbludolist]+".tvrid",[FIELD],"UpdateName","tovar.tvrid")
DBSETPROP([lvbludolist]+".tvrid",[FIELD],"KeyField",.T.)
DBSETPROP([lvbludolist]+".tvrid",[FIELD],"Updatable",.F.)

DBSETPROP([lvbludolist]+".tvrnm",[FIELD],"DataType","C(80)")
DBSETPROP([lvbludolist]+".tvrnm",[FIELD],"UpdateName","tovar.tvrnm")
DBSETPROP([lvbludolist]+".tvrnm",[FIELD],"KeyField",.F.)
DBSETPROP([lvbludolist]+".tvrnm",[FIELD],"Updatable",.T.)
***
DBSETPROP([lvbludolist],[VIEW],[FetchSize],-1)
***
ENDPROC
*------------------------------------------------------------------------------
*------------------------------------------------------------------------------
*------------------------------------------------------------------------------

*/LV AСС: Последняя цена./*
PROCEDURE lvAccLastBuy
***
CREATE SQL VIEW lvAccLastBuy REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	StockTransTvrPrcBuy = CAST(CASE WHEN Accounting.AccQnt <> 0 ;
		THEN Accounting.AccPrice/Accounting.AccQnt ELSE 0 END AS money) ;
FROM Accounting;
WHERE Accounting.AccTvrID = ?_PARAM
***
DBSETPROP([lvAccLastBuy],[VIEW],[Comment],[LV AСС: Последняя цена.])
***
DBSETPROP([lvAccLastBuy],[VIEW],[FetchSize],-1)
***
ENDPROC
*------------------------------------------------------------------------------