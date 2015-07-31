#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

lvDiscScaleViewByID()
lvFrmPartTvrEditOrder()
lvFSView()



PROCEDURE lvDiscScaleViewByID
***
CREATE SQL VIEW lvDiscScaleViewByID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
		discscale.discrate ;
	FROM discscale ;
	INNER JOIN tovar ON tovar.TvrDiscID = discscale.discID ;
	INNER JOIN CltAltClass ON CltAltClass.CltGroupID = discscale.CltGroupID ;
	WHERE CltAltClass.CltID = ?_PARAM1 ;
		AND tovar.TvrID = ?_PARAM2 ;
		AND discscale.discrate<>0

DBSETPROP([lvDiscScaleViewByID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscScaleViewByID],[VIEW],[COMMENT],[LV DSC: скидка по данному товару для данного клиента])
***
ENDPROC
*------------------------------------------------------------------------------



*/LV FRM: редактирование содержания документа (товарной позиции) для заказа/*
PROCEDURE lvFrmPartTvrEditOrder
***
CREATE SQL VIEW lvFrmPartTvrEditOrder REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPartTvrID, ;
	FrmID, ;
	TvrId, ;
	MsuId, ;
	TvrQnt, ;
	TvrQntNetto, ;
	TvrPrcBuy, ;
	TvrPrcSale, ;
	TvrVATRate, ;
	TvrExpiredDate, ;
	TvrIDCalc, ;
	TvrAttr, ;
	DiscPerc, ;
	Stamp_, ;
	User_ ;
FROM FrmPartTvr ;
WHERE FrmPartTvrID = ?_PARAM
***
DBSETPROP([lvFrmPartTvrEditOrder.FrmPartTvrID],[FIELD],[KeyField],.T.)
DBSETPROP([lvFrmPartTvrEditOrder.FrmPartTvrID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvFrmPartTvrEditOrder.FrmID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEditOrder.TvrId],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEditOrder.MsuId],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEditOrder.TvrQnt],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEditOrder.TvrQntNetto],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEditOrder.TvrPrcBuy],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEditOrder.TvrPrcSale],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEditOrder.TvrVATRate],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEditOrder.TvrExpiredDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEditOrder.TvrIDCalc],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEditOrder.TvrAttr],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEditOrder.DiscPerc],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEditOrder.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEditOrder.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvFrmPartTvrEditOrder.TvrQnt],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartTvrEditOrder.TvrQntNetto],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartTvrEditOrder.TvrPrcBuy],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartTvrEditOrder.TvrPrcSale],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartTvrEditOrder.TvrVATRate],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartTvrEditOrder.TvrIDCalc],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartTvrEditOrder.TvrAttr],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartTvrEditOrder.DiscPerc],[FIELD],[DefaultValue],[0.00])
***
DBSETPROP([lvFrmPartTvrEditOrder],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvFrmPartTvrEditOrder],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvFrmPartTvrEditOrder],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmPartTvrEditOrder],[VIEW],[COMMENT],[LV FRM: редактирование содержания документа (товарной позиции)])
***
ENDPROC
*------------------------------------------------------------------------------


*/LV FRM: список выбора схем факторинга/*
PROCEDURE lvFSView
***
CREATE SQL VIEW lvFSView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FSID, ;
	FSNM, ;
	FSPerc, ;
	FSDays ;
FROM FactSch
***
DBSETPROP([lvFSView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFSView],[VIEW],[COMMENT],[Список выбора схем факторинга])
***
