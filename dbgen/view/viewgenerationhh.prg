#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*--Генерация представлений

*--lvFrmTypeSaveOrdView()
lvTvrByServView()
lvServByTvrView()
**
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV hh: Типы документов как варианты сохранения заказа/*
PROCEDURE lvFrmTypeSaveOrdView
***
CREATE SQL VIEW lvFrmTypeSaveOrdView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmTypeSaveOrd.FrmTypeID AS ID_, ;
	ISNULL(FrmType.FrmTypeNM,SPACE(20)) AS NM ;
FROM FrmTypeSaveOrd ;
INNER JOIN FrmType ON FrmType.FrmTypeID = FrmTypeSaveOrd.FrmTypeID
***
DBSETPROP([lvFrmTypeSaveOrdView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTypeSaveOrdView],[VIEW],[COMMENT],[LV hh: Варианты сохранения заказа])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV hh: Ресурсы, привязанные к данной услуге/*
PROCEDURE lvTvrByServView()
***
CREATE SQL VIEW lvTvrByServView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Tovar.TvrID AS TvrId, ;
	ISNULL(Tvr.TvrNM,SPACE(60)) AS TvrNM ;
FROM Tovar ;
LEFT OUTER JOIN Tovar Tvr ON Tvr.TvrID = Tovar.TvrID ;
WHERE Tovar.ServID = ?_PARAM AND Tvr.TvrTypeID=8
***
DBSETPROP([lvTvrByServView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrByServView],[VIEW],[COMMENT],[LV hh: Ресурсы по данной услуге])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV hh: Услуги, привязанные к данному ресурсу/*
PROCEDURE lvServByTvrView()
***
CREATE SQL VIEW lvServByTvrView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Tovar.ServID AS TvrId, ;
	ISNULL(Tvr.TvrNM,SPACE(60)) AS TvrNM ;
FROM Tovar ;
LEFT OUTER JOIN Tovar Tvr ON Tvr.TvrID = Tovar.ServID ;
WHERE Tovar.TvrID = ?_PARAM AND Tvr.TvrTypeID=3
***
DBSETPROP([lvServByTvrView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvServByTvrView],[VIEW],[COMMENT],[LV hh: Услуги по данному ресурсу])
***
ENDPROC
*------------------------------------------------------------------------------

