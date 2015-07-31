#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 17:11 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Единицы измерения] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Единицы измерения]
***
lvMeasureUnitEdit()
lvMeasureUnitView()
lvMeasureUnitBaseList()
***
lvMsuType()
lvMsuList()
***
lvMsuIDByTvr()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------	

*/LV MeasureUnit: редактирование единиц измерения/*
PROCEDURE lvMeasureUnitEdit
***
CREATE SQL VIEW lvMeasureUnitEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	MeasureUnit.MsuID, ;
	MeasureUnit.MsuNM, ;
	MeasureUnit.MsuShortNM, ;
	MeasureUnit.BaseMsuID, ;
	MeasureUnit.MsuQnt, ;
	MeasureUnit.MsuType, ;
	MeasureUnit.Stamp_, ;
	MeasureUnit.User_ ;
FROM MeasureUnit ;
WHERE MeasureUnit.MsuID = ?_PARAM
DBSETPROP([lvMeasureUnitEdit.MsuID],[FIELD],[KeyField],.T.)
DBSETPROP([lvMeasureUnitEdit.MsuID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvMeasureUnitEdit.MsuNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvMeasureUnitEdit.MsuShortNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvMeasureUnitEdit.BaseMsuID],[FIELD],[Updatable],.T.)
DBSETPROP([lvMeasureUnitEdit.MsuQnt],[FIELD],[Updatable],.T.)
DBSETPROP([lvMeasureUnitEdit.MsuType],[FIELD],[Updatable],.T.)
DBSETPROP([lvMeasureUnitEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvMeasureUnitEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvMeasureUnitEdit.MsuNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvMeasureUnitEdit.MsuShortNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvMeasureUnitEdit.MsuQnt],[FIELD],[DefaultValue],[0])
DBSETPROP([lvMeasureUnitEdit.MsuType],[FIELD],[DefaultValue],[1])
***
DBSETPROP([lvMeasureUnitEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvMeasureUnitEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvMeasureUnitEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvMeasureUnitEdit],[VIEW],[COMMENT],[LV MeasureUnit: редактирование единиц измерения.])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV MeasureUnit: просмотр единиц измерения/*
PROCEDURE lvMeasureUnitView
***
CREATE SQL VIEW lvMeasureUnitView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	MeasureUnit.MsuID, ;
	MeasureUnit.MsuNM, ;
	MeasureUnit.MsuShortNM, ;
	ISNULL(BaseMeasureUnit.MsuNM,'') AS BaseMsuNM, ;
	MeasureUnit.MsuQnt, ;
	MeasureUnit.MsuType, ;
	MsuType.MsuTypeName ;
FROM MeasureUnit ;
LEFT JOIN MeasureUnit BaseMeasureUnit ON BaseMeasureUnit.MsuID = MeasureUnit.BaseMsuID ;
INNER JOIN MsuType ON MeasureUnit.MsuType = MsuType.MsuTypeID ;
ORDER BY MeasureUnit.MsuNM
***
DBSETPROP([lvMeasureUnitView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvMeasureUnitView],[VIEW],[COMMENT],[LV MeasureUnit: просмотр единиц измерения.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV MeasureUnit: список базовых единиц измерения/*
PROCEDURE lvMeasureUnitBaseList
***
CREATE SQL VIEW lvMeasureUnitBaseList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	MeasureUnit.MsuID, ;
	MeasureUnit.MsuNM ;
FROM MeasureUnit ;
WHERE MeasureUnit.MsuID <> ?_PARAM ;
ORDER BY MeasureUnit.MsuNM
***
DBSETPROP([lvMeasureUnitBaseList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvMeasureUnitBaseList],[VIEW],[COMMENT],[LV MeasureUnit: список базовых единиц измерения.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV MeasureUnit: типы единиц измерения/*
PROCEDURE lvMsuType
***
CREATE SQL VIEW lvMsuType REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	MsuType.MsuTypeID, ;
	MsuType.MsuTypename ;
FROM MsuType ;
ORDER BY MsuType.MsuTypeName
***
DBSETPROP([lvMsuType],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvMsuType],[View],[Comment],[LV MeasureUnit: типы единиц измерения.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV MeasureUnit: список единиц измерения/*
PROCEDURE lvMsuList
***
CREATE SQL VIEW lvMsuList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	MeasureUnit.MsuID, ;
	MeasureUnit.MsuNM, ;
	MeasureUnit.MsuType ;
FROM MeasureUnit;
ORDER BY 3, 2
***
DBSETPROP([lvMsuList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvMsuList],[View],[Comment],[LV MeasureUnit: список единиц измерения.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV MeasureUnit: единица измерения для конкретного товара/*
PROCEDURE lvMsuIDByTvr
***
CREATE SQL VIEW lvMsuIDByTvr REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Tovar.MsuID ;
FROM Tovar ;
WHERE Tovar.TvrID = ?_PARAM
***
DBSETPROP([lvMsuIDByTvr],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvMsuIDByTvr],[View],[Comment],[LV MeasureUnit: единица измерения для конкретного товара.])
***
ENDPROC
*------------------------------------------------------------------------------