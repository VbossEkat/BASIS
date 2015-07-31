#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 17:16 -> √енераци€ представлений
WAIT WINDOW [√енераци€ представлений дл€ ѕќ: ѕрайсы] NOWAIT NOCLEAR
SET MESSAGE TO [√енераци€ представлений дл€ ѕќ: ѕрайсы]
***
lvPrcTypeInfo()
lvPriceInfoByTvr()
lvPriceTvr()
lvPriceTvrDef()
lvPriceEdit()
lvCurTypeList()
lvPrcTypeList()
lvCurTypeEdit()
lvCurTypeView()
lvPrcTypeEdit()
lvPrcTypeView()
lvCurTypeByID()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------	

*/LV Price: информаци€ по типу прайса/*
PROCEDURE lvPrcTypeInfo
***
CREATE SQL VIEW lvPrcTypeInfo REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	PrcType.PrcTypeID, ;
	PrcType.CurTypeID, ;
	PrcType.PrcTypeNM, ;
	PrcType.PrcTypeIsDef ;
FROM PrcType ;
WHERE PrcType.PrcTypeID = ?_PARAM
***
DBSETPROP([lvPrcTypeInfo],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPrcTypeInfo],[VIEW],[COMMENT],[LV Price: информаци€ по типу прайса])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV Price: информаци€ по ценам данного товара/*
PROCEDURE lvPriceInfoByTvr
***
CREATE SQL VIEW lvPriceInfoByTvr REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Price.PrcId, ;
	Price.Price, ;
	Price.PrcTypeID, ;
	PrcType.CurTypeId, ;
	PrcType.PrcTypeIsDef AS IsDefault ;
FROM Price ;
INNER JOIN PrcType ON PrcType.PrcTypeID = Price.PrcTypeID ;
WHERE Price.TvrID = ?_PARAM
***
DBSETPROP([lvPriceInfoByTvr],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPriceInfoByTvr],[VIEW],[COMMENT],[LV Price: информаци€ по ценам данного товара])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Price: информаци€ по ценам данного товара по конкретному прайсу/*
PROCEDURE lvPriceTvr
***
CREATE SQL VIEW lvPriceTvr REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Price.PrcId, ;
	Price.Price, ;
	PrcType.CurTypeId, ;
	PrcType.PrcTypeIsDef AS IsDefault ;
FROM Price ;
INNER JOIN PrcType ON PrcType.PrcTypeID = Price.PrcTypeID ;
WHERE Price.TvrID = ?_PARAM1 AND Price.PrcTypeID = ?_PARAM2
***
DBSETPROP([lvPriceTvr],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPriceTvr],[VIEW],[COMMENT],[LV Price: информаци€ по ценам данного товара по конкрерному прайсу])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Price: информаци€ по ценам данного товара из прайса по умолчанию/*
PROCEDURE lvPriceTvrDef
***
CREATE SQL VIEW lvPriceTvrDef REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Price.PrcId, ;
	Price.Price, ;
	PrcType.CurTypeId, ;
	PrcType.PrcTypeIsDef AS IsDefault ;
FROM Price ;
INNER JOIN PrcType ON PrcType.PrcTypeID = Price.PrcTypeID ;
WHERE Price.TvrID = ?_PARAM AND PrcType.PrcTypeIsDef=1
***
DBSETPROP([lvPriceTvrDef],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPriceTvrDef],[VIEW],[COMMENT],[LV Price: информаци€ по ценам данного товара из прайса по умолчанию])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Price: редактирование цен товара/*
PROCEDURE lvPriceEdit
***
CREATE SQL VIEW lvPriceEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Price.PrcId, ;
	Price.PrcTypeId, ;
	Price.TvrId, ;
	Price.Price, ;	
	Price.PrcMargin, ;	
	Price.Stamp_, ;
	Price.User_ ;
FROM Price ;
WHERE Price.PrcID = ?_PARAM 
***
DBSETPROP([lvPriceEdit.PrcId],[FIELD],[KeyField],.T.)
DBSETPROP([lvPriceEdit.PrcId],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvPriceEdit.PrcTypeId],[FIELD],[Updatable],.T.)
DBSETPROP([lvPriceEdit.TvrId],[FIELD],[Updatable],.T.)
DBSETPROP([lvPriceEdit.Price],[FIELD],[Updatable],.T.)
DBSETPROP([lvPriceEdit.PrcMargin],[FIELD],[Updatable],.T.)
DBSETPROP([lvPriceEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvPriceEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvPriceEdit.Price],[FIELD],[DefaultValue],[0])
DBSETPROP([lvPriceEdit.PrcMargin],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvPriceEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvPriceEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvPriceEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPriceEdit],[VIEW],[COMMENT],[LV Price: редактирование цен товара])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Price: список типов валюты/*
PROCEDURE lvCurTypeList
***
CREATE SQL VIEW lvCurTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CurTypeId, ;
	CurTypeNM ;
FROM CurType
***
DBSETPROP([lvCurTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCurTypeList],[VIEW],[COMMENT],[LV Price: список типов валюты])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Price: список типов прайсов/*
PROCEDURE lvPrcTypeList
***
CREATE SQL VIEW lvPrcTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	PrcTypeID, ;
	PrcTypeNM, ;
	PrcTypeIsDef ;	
FROM PrcType ;
ORDER BY PrcType.PrcTypeNM
***
DBSETPROP([lvPrcTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPrcTypeList],[VIEW],[COMMENT],[LV Price: список типов прайсов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Price: редактирование типов валют/*
PROCEDURE lvCurTypeEdit
***
CREATE SQL VIEW lvCurTypeEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CurType.CurTypeId, ;
	CurType.CurTypeNM, ;
	CurType.CurTypeStdNM, ;
	CurType.CurTypeHONText, ;
	CurType.CurTypeHOGText, ;
	CurType.CurTypeHMGText, ;
	CurType.CurTypeLONText, ;
	CurType.CurTypeLOGText, ;
	CurType.CurTypeLMGText, ;
	CurType.Stamp_, ;
	CurType.User_ ;
FROM CurType ;
WHERE CurType.CurTypeID = ?_PARAM
***
DBSETPROP([lvCurTypeEdit.CurTypeID],[FIELD],[KeyField],.T.)
DBSETPROP([lvCurTypeEdit.CurTypeID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvCurTypeEdit.CurTypeNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCurTypeEdit.CurTypeStdNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCurTypeEdit.CurTypeHONText],[FIELD],[Updatable],.T.)
DBSETPROP([lvCurTypeEdit.CurTypeHOGText],[FIELD],[Updatable],.T.)
DBSETPROP([lvCurTypeEdit.CurTypeHMGText],[FIELD],[Updatable],.T.)
DBSETPROP([lvCurTypeEdit.CurTypeLONText],[FIELD],[Updatable],.T.)
DBSETPROP([lvCurTypeEdit.CurTypeLOGText],[FIELD],[Updatable],.T.)
DBSETPROP([lvCurTypeEdit.CurTypeLMGText],[FIELD],[Updatable],.T.)
DBSETPROP([lvCurTypeEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvCurTypeEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCurTypeEdit.CurTypeNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCurTypeEdit.CurTypeStdNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCurTypeEdit.CurTypeHONText],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCurTypeEdit.CurTypeHOGText],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCurTypeEdit.CurTypeHMGText],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCurTypeEdit.CurTypeLONText],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCurTypeEdit.CurTypeLOGText],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCurTypeEdit.CurTypeLMGText],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvCurTypeEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCurTypeEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCurTypeEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCurTypeEdit],[VIEW],[COMMENT],[LV Price: редактирование типов валют])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV Price: просмотр типов валют/*
PROCEDURE lvCurTypeView
***
CREATE SQL VIEW lvCurTypeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CurType.CurTypeID, ;
	CurType.CurTypeNM, ;
	CurType.CurTypeStdNM ;
FROM CurType
***
DBSETPROP([lvCurTypeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCurTypeView],[VIEW],[COMMENT],[LV Price: просмотр типов валют])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV Price: редактирование типов прайсов/*
PROCEDURE lvPrcTypeEdit
***
CREATE SQL VIEW lvPrcTypeEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	PrcType.PrcTypeID, ;
	PrcType.CurTypeID, ;
	PrcType.PrcTypeNM, ;
	PrcType.PrcTypeIsDef, ;
	PrcType.Stamp_, ;
	PrcType.User_ ;
FROM PrcType ;
WHERE PrcType.PrcTypeID = ?_PARAM
***
DBSETPROP([lvPrcTypeEdit.PrcTypeID],[FIELD],[KeyField],.T.)
DBSETPROP([lvPrcTypeEdit.PrcTypeID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvPrcTypeEdit.CurTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvPrcTypeEdit.PrcTypeNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvPrcTypeEdit.PrcTypeIsDef],[FIELD],[Updatable],.T.)
DBSETPROP([lvPrcTypeEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvPrcTypeEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvPrcTypeEdit.PrcTypeNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvPrcTypeEdit.PrcTypeIsDef],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvPrcTypeEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvPrcTypeEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvPrcTypeEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPrcTypeEdit],[VIEW],[COMMENT],[LV Price: редактирование типов прайсов])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV Price: просмотр типов прайсов/*
PROCEDURE lvPrcTypeView
***
CREATE SQL VIEW lvPrcTypeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	PrcType.PrcTypeID, ;
	CurType.CurTypeNM, ;
	PrcType.PrcTypeNM, ;
	PrcType.PrcTypeIsDef ;
FROM PrcType ;
INNER JOIN CurType ON CurType.CurTypeID = PrcType.CurTypeID
***
DBSETPROP([lvPrcTypeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPrcTypeView],[VIEW],[COMMENT],[LV Price: просмотр типов прайсов])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV Price: тип валюты по ID/*
PROCEDURE lvCurTypeByID
***
CREATE SQL VIEW lvCurTypeByID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CurType.CurTypeId, ;
	CurType.CurTypeNM, ;
	CurType.CurTypeStdNM, ;
	CurType.CurTypeHONText, ;
	CurType.CurTypeHOGText, ;
	CurType.CurTypeHMGText, ;
	CurType.CurTypeLONText, ;
	CurType.CurTypeLOGText, ;
	CurType.CurTypeLMGText ;
FROM CurType ;
WHERE CurType.CurTypeID = ?_PARAM
***
DBSETPROP([lvCurTypeByID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCurTypeByID],[VIEW],[COMMENT],[LV Price: тип валюты по ID])
***
ENDPROC
*------------------------------------------------------------------------------	