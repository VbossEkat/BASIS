*/LV TVR: общая информация о товаре/*
PROCEDURE lvTovarInfo
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvTovarInfo REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Tovar.TvrID, ;
	Tovar.TvrParID, ;
	Tovar.TvrTypeID, ;
	Tovar.TvrNM, ;
	Tovar.TvrIsDiv, ;
	Tovar.TvrIsActiv, ;
	Tovar.TvrVATRate, ;
	Tovar.MsuID, ;
	ISNULL(MeasureUnit.MsuType,-1) AS MsuType, ;
    ISNULL(Price.PrcTypeID,0) AS PrcTypeID, ;
    ISNULL(Price.PrcMargin,0) AS PrcMargin, ;
    ISNULL(MeasureUnit.MsuNM,'') AS MsuNM ;
FROM Tovar ;
LEFT JOIN Price ON Price.TvrID = Tovar.TvrID AND Price.PrcTypeID = ?_PARAM_PRCTYPE ;
LEFT JOIN MeasureUnit ON MeasureUnit.MsuID = Tovar.MsuID ;
WHERE Tovar.TvrID = ?_PARAM
***
DBSETPROP([lvTovarInfo],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTovarInfo],[VIEW],[COMMENT],[LV TVR: общая информация о товаре.])
***
ENDPROC
*------------------------------------------------------------------------------
