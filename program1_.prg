#DEFINE    pcvCONNECTIONNAME    SQLBASISCONNECTION

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
    TvrLinkServ.TvrID AS ID_, ;
    ISNULL(Tovar.TvrNM,SPACE(60)) AS NM ;
FROM TvrLinkServ ;
LEFT OUTER JOIN Tovar ON Tovar.TvrID = TvrLinkServ.TvrID ;
WHERE TvrLinkServ.ServID = ?_PARAM AND Tovar.TvrTypeID=8
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
    TvrLinkServ.ServID AS ID_, ;
    ISNULL(Tovar.TvrNM,SPACE(60)) AS NM ;
FROM TvrLinkServ ;
LEFT OUTER JOIN Tovar ON Tovar.TvrID = TvrLinkServ.ServID ;
WHERE TvrLinkServ.TvrID = ?_PARAM AND Tovar.TvrTypeID=3
***
DBSETPROP([lvServByTvrView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvServByTvrView],[VIEW],[COMMENT],[LV hh: Услуги по данному ресурсу])
***
ENDPROC
*------------------------------------------------------------------------------

