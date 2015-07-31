#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 17:29 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Товары] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Товары]
***
lvTvrCntTreeView()
lvTvrCntTreeViewRepl()
lvTvrInCntView()
lvTvrInCntViewRepl()
lvTvrTLUView()
lvTvrTLUViewRepl()
lvTvrPriceView()
lvTvrPriceViewRepl()
lvTvrTypeInfoMgr()
lvTvrBmps()
lvTvrTLUBmps()
lvTvrEdit()
lvTvrPkgEdit()
lvTvrNlsEdit()
lvTvrTypeList()
lvTvrPkgTypeList()
lvTvrMsuList()
lvTovarList()
lvTovarListWithPrice()
lvTvrOnlyList()
lvTovarInfo()
lvTvrGrpList()
lvTvrLastBuy()
lvTvrLastBuyOU()
***
lvTvrSetBmps()
lvTvrSetEdit()
lvTvrSetById()
lvTvrSetTLUTypeView()
lvTvrSetTLUTypeEdit()
lvTvrSetTvrTypeView()
lvTvrSetTvrTypeEdit()
lvTvrSetView()
lvTvrSetList()
lvTvrSetListToScale()
lvTvrSetListBindTLU()
lvTvrSetTypeList()
***
lvTvrInSetEdit()
lvTvrSetInfo()
***
lvTvrActRuleEdit()
lvTvrActRuleView()
lvAccTypeList()
lvAccTypeListAdd()
lvAccRetFrm()
lvAccRetTvr()
***
lvDocToTo29()
lvTvrMnuList()
***
lvTvrConstraintEdit()
***
lvStockTvrQnt()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV TVR: дерево товаров (только контейнерные типы)/*
PROCEDURE lvTvrCntTreeView
***
CREATE SQL VIEW lvTvrCntTreeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Tovar.TvrID, ;
	ISNULL(Tovar.TvrParID,0) AS TvrParID, ;
	Tovar.TvrNM, ;
	TvrType.TvrTypeIsCnt AS TvrIsCnt, ;
	TvrType.BmpId AS BmpId, ;
	TvrType.SelBmpId AS SelBmpId ;
FROM Tovar ;
INNER JOIN TvrType ON Tovar.TvrTypeID = TvrType.TvrTypeID ;
WHERE TvrType.TvrTypeIsCnt = 1 ;
ORDER BY Tovar.TvrNM
***
DBSETPROP([lvTvrCntTreeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrCntTreeView],[VIEW],[COMMENT],[LV TVR: дерево товаров (только контейнерные типы)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: обновления для lvTvrCntTreeView/*
PROCEDURE lvTvrCntTreeViewRepl
***
CREATE SQL VIEW lvTvrCntTreeViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Tovar.TvrID, ;
	ISNULL(Tovar.TvrParID,0) AS TvrParID, ;
	Tovar.TvrNM, ;
	TvrType.TvrTypeIsCnt AS TvrIsCnt, ;
	TvrType.BmpId AS BmpId, ;
	TvrType.SelBmpId AS SelBmpId ;
FROM Tovar ;
INNER JOIN TvrType ON Tovar.TvrTypeID = TvrType.TvrTypeID ;
WHERE TvrType.TvrTypeIsCnt = 1 AND Tovar.TvrID = ?_PARAM
***
DBSETPROP([lvTvrCntTreeViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrCntTreeViewRepl],[VIEW],[COMMENT],[LV TVR: обновления для lvTvrCntTreeView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: содержание товарной группы/*
PROCEDURE lvTvrInCntView
***
CREATE SQL VIEW lvTvrInCntView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Tovar.TvrID, ;
	Tovar.TvrNM, ;
	ISNULL(Tovar.TvrParID,0) AS TvrParID, ;
	Tovar.TvrIsActiv, ;
	TvrType.TvrTypeID, ;
	TvrType.TvrTypeIsCnt, ;
	TvrType.TvrTypeIsForSale, ;
	BmpId = CASE WHEN Tovar.TvrIsActiv = 1 THEN TvrType.BmpId ELSE TvrType.InactiveBmpId END, ;
	ISNULL(Measureunit.MsuNM,'') AS MsuNM ;
FROM Tovar ;
INNER JOIN TvrType		ON Tovar.TvrTypeID = TvrType.TvrTypeID ;
LEFT JOIN MeasureUnit	ON MeasureUnit.MsuID = Tovar.MsuID ;
WHERE ISNULL(Tovar.TvrParID,0) = ?_PARAM ;
ORDER BY TvrType.TvrTypeIsCnt DESC, Tovar.TvrIsActiv DESC, Tovar.TvrNM
***
DBSETPROP([lvTvrInCntView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrInCntView],[VIEW],[COMMENT],[LV TVR: содержание товарной группы])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: обновление для lvTvrInCntView/*
PROCEDURE lvTvrInCntViewRepl
***
CREATE SQL VIEW lvTvrInCntViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Tovar.TvrID, ;
	Tovar.TvrNM, ;
	ISNULL(Tovar.TvrParID,0) AS TvrParID, ;
	Tovar.TvrIsActiv, ;
	TvrType.TvrTypeID, ;
	TvrType.TvrTypeIsCnt, ;
	TvrType.TvrTypeIsForSale, ;
	BmpId = CASE WHEN Tovar.TvrIsActiv = 1 THEN TvrType.BmpId ELSE TvrType.InactiveBmpId END, ;
	ISNULL(Measureunit.MsuNM,'') AS MsuNM ;
FROM Tovar ;
INNER JOIN TvrType		ON Tovar.TvrTypeID = TvrType.TvrTypeID ;
LEFT JOIN MeasureUnit	ON MeasureUnit.MsuID = Tovar.MsuID ;
WHERE Tovar.TvrID = ?_PARAM
***
DBSETPROP([lvTvrInCntViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrInCntViewRepl],[VIEW],[COMMENT],[LV TVR: содержание товарной группы])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список доступных идентификаторов (ШК) для товара/*
PROCEDURE lvTvrTLUView 
***
CREATE SQL VIEW lvTvrTLUView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrLookUp.TluID, ;
	TvrLookUp.Tlu, ;
	TvrLookUp.TLUComment, ;
	TLUType.BmpId ;
FROM TvrLookUp ;
INNER JOIN TLUType ON TvrLookUp.TLUTypeID = TLUType.TLUTypeID ;
WHERE TvrLookUp.TvrID = ?_PARAM 
***
DBSETPROP([lvTvrTLUView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrTLUView],[VIEW],[COMMENT],[LV TVR: список доступных идентификаторов (ШК) для товара])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: обновления для lvTvrTLU/*
PROCEDURE lvTvrTLUViewRepl
***
CREATE SQL VIEW lvTvrTLUViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrLookUp.TluID, ;
	TvrLookUp.Tlu, ;
	TvrLookUp.TLUComment, ;
	TLUType.BmpId ;
FROM TvrLookUp ;
INNER JOIN TLUType ON TvrLookUp.TLUTypeID = TLUType.TLUTypeID ;
WHERE TvrLookUp.TLUID = ?_PARAM
***
DBSETPROP([lvTvrTLUViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrTLUViewRepl],[VIEW],[COMMENT],[LV TVR: обновления для lvTvrTLUView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список цен для товара/*
PROCEDURE lvTvrPriceView
***
CREATE SQL VIEW lvTvrPriceView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Price.PrcID, ;
	Price.Price, ;
	PrcType.PrcTypeNM, ;
	CurType.CurTypeNM ;
FROM Price ;
INNER JOIN PrcType ON Price.PrcTypeID = PrcType.PrcTypeID ;
INNER JOIN CurType ON PrcType.CurTypeID = CurType.CurTypeID ;
WHERE Price.TvrID = ?_PARAM
***
DBSETPROP([lvTvrPriceView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrPriceView],[VIEW],[COMMENT],[LV TVR: список цен для товара])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: обновления для lvTvrPrice/*
PROCEDURE lvTvrPriceViewRepl
***
CREATE SQL VIEW lvTvrPriceViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Price.PrcID, ;
	Price.Price, ;
	PrcType.PrcTypeNM, ;
	CurType.CurTypeNM ;
FROM Price ;
INNER JOIN PrcType ON Price.PrcTypeID = PrcType.PrcTypeID ;
INNER JOIN CurType ON PrcType.CurTypeID = CurType.CurTypeID ;
WHERE Price.PrcID = ?_PARAM
***
DBSETPROP([lvTvrPriceViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrPriceViewRepl],[VIEW],[COMMENT],[LV TVR: обновления для lvTvrPriceView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: информация об объетке для редактирования для менеджера предметной области TOVAR/*
PROCEDURE lvTvrTypeInfoMgr
***
CREATE SQL VIEW lvTvrTypeInfoMgr REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrType.TvrTypeId, ;
	TvrType.TvrTypeNM, ;
	TvrType.TvrTypeIsCnt, ;
	TvrType.TvrTypeIsForSale, ;
	TvrType.TvrTypeIsTare, ;
	TvrType.TvrTypeIsDisc, ;
	TvrType.TvrTypeObjDesc, ;
	TvrType.BmpId, ;
	TvrType.SelBmpId, ;
	TvrType.InactiveBmpId, ;
	TvrType.SelInactiveBmpId, ;
	TvrType.BmpMarkId, ;
	TvrType.SelBmpMarkId, ;
	TvrType.BmpPartMarkId, ;
	TvrType.SelBmpPartMarkId ;
FROM TvrType ;
INNER JOIN Tovar ON TvrType.TvrTypeId = Tovar.TvrTypeId ;
WHERE Tovar.TvrID = ?_PARAM
***
DBSETPROP([lvTvrTypeInfoMgr],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrTypeInfoMgr],[VIEW],[COMMENT],[LV TVR: информация об объетке для редактирования для менеджера предметной области TOVAR])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список используемых картинок для типов товаров/*
PROCEDURE lvTvrBmps
***
CREATE SQL VIEW lvTvrBmps REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Bitmaps.BmpId, ;
	Bitmaps.BmpFileNM ;
FROM Bitmaps ;
WHERE	(Bitmaps.BmpId IN (SELECT TvrType.BmpId FROM TvrType)) OR ;
		(Bitmaps.BmpId IN (SELECT TvrType.SelBmpId FROM TvrType)) OR ;
		(Bitmaps.BmpId IN (SELECT TvrType.InactiveBmpId FROM TvrType)) OR ;
		(Bitmaps.BmpId IN (SELECT TvrType.SelInactiveBmpId FROM TvrType))
***
DBSETPROP([lvTvrBmps],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrBmps],[VIEW],[COMMENT],[LV TVR: список используемых картинок для типов товаров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список используемых картинок для типов идентификаторов (ШК)/*
PROCEDURE lvTvrTLUBmps
***
CREATE SQL VIEW lvTvrTLUBmps REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Bitmaps.BmpId, ;
	Bitmaps.BmpFileNM ;
FROM Bitmaps ;
WHERE	(Bitmaps.BmpId IN (SELECT TLUType.BmpId FROM TLUType))
***
DBSETPROP([lvTvrTLUBmps],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrTLUBmps],[VIEW],[COMMENT],[LV TVR: список используемых картинок для типов идентификаторов (ШК)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: редактирование таблицы Tovar*/
PROCEDURE lvTvrEdit
***
CREATE SQL VIEW lvTvrEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Tovar.TvrID, ;
	Tovar.TvrParID, ;
	Tovar.TvrTypeID, ;
	Tovar.MakerCltID, ;
	Tovar.TvrNM, ;
	Tovar.TvrIsDiv, ;
	Tovar.TvrIsActiv, ;
	Tovar.TvrVATRate, ;
	Tovar.MsuID, ;
	Tovar.TvrDiscID, ;
	Tovar.Stamp_, ;
	Tovar.User_, ;
	Tovar.ID_ ;
FROM Tovar ;
WHERE Tovar.TvrID = ?_PARAM
***
DBSETPROP([lvTvrEdit.TvrID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvTvrEdit.TvrID],[FIELD],[Updatable],.F.)
DBSETPROP([lvTvrEdit.TvrParID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrEdit.TvrTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrEdit.MakerCltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrEdit.TvrNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrEdit.TvrIsDiv],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrEdit.TvrIsActiv],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrEdit.TvrVATRate],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrEdit.MsuID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrEdit.TvrDiscID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrEdit.User_],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrEdit.ID_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTvrEdit.TvrTypeID],[FIELD],[DefaultValue],[2])
DBSETPROP([lvTvrEdit.TvrNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvTvrEdit.TvrIsDiv],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvTvrEdit.TvrIsActiv],[FIELD],[DefaultValue],[.T.])
DBSETPROP([lvTvrEdit.TvrVATRate],[FIELD],[DefaultValue],[18])
***
DBSETPROP([lvTvrEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvTvrEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvTvrEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrEdit],[VIEW],[COMMENT],[TV TVR: редактирование таблицы Tovar])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: редактирование таблицы Package/*
PROCEDURE lvTvrPkgEdit
***
CREATE SQL VIEW lvTvrPkgEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Package.TvrID, ;
	Package.PkgTypeID, ;
	Package.TvPkgTypeID, ;
	Package.Stamp_, ;
	Package.User_ ;
FROM Package ;
WHERE Package.TvrID = ?_PARAM
***
DBSETPROP([lvTvrPkgEdit.TvrID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvTvrPkgEdit.TvrID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrPkgEdit.PkgTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrPkgEdit.TvPkgTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrPkgEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrPkgEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTvrPkgEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvTvrPkgEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvTvrPkgEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrPkgEdit],[VIEW],[COMMENT],[LV TVR: редактирование таблицы Package])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: редактирование таблицы NatLoss/*
PROCEDURE lvTvrNlsEdit
***
CREATE SQL VIEW lvTvrNlsEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	NatLoss.TvrID, ;
	NatLoss.NatLossIsUsed, ;
	NatLoss.NatLossWinter, ;
	NatLoss.NatLossSpring, ;
	NatLoss.NatLossSummer, ;
	NatLoss.NatLossAutumn, ;
	NatLoss.Stamp_, ;
	NatLoss.User_ ;
FROM NatLoss ;
WHERE NatLoss.TvrID = ?_PARAM
***
DBSETPROP([lvTvrNlsEdit.TvrID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvTvrNlsEdit.TvrID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrNlsEdit.NatLossIsUsed],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrNlsEdit.NatLossWinter],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrNlsEdit.NatLossSpring],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrNlsEdit.NatLossSummer],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrNlsEdit.NatLossAutumn],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrNlsEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrNlsEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTvrNlsEdit.NatLossIsUsed],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvTvrNlsEdit.NatLossWinter],[FIELD],[DefaultValue],[0])
DBSETPROP([lvTvrNlsEdit.NatLossSpring],[FIELD],[DefaultValue],[0])
DBSETPROP([lvTvrNlsEdit.NatLossSummer],[FIELD],[DefaultValue],[0])
DBSETPROP([lvTvrNlsEdit.NatLossAutumn],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvTvrNlsEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvTvrNlsEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvTvrNlsEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrNlsEdit],[VIEW],[COMMENT],[LV TVR: редактирование таблицы NatLoss])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список типов товаров/*
PROCEDURE lvTvrTypeList
***
CREATE SQL VIEW lvTvrTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrType.TvrTypeID, ;
	TvrType.TvrTypeNM ;
FROM TvrType	
***
DBSETPROP([lvTvrTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrTypeList],[VIEW],[COMMENT],[LV TVR: список типов товаров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список типов фасовок/*
PROCEDURE lvTvrPkgTypeList
***
CREATE SQL VIEW lvTvrPkgTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	PkgTypeID, ;
	PkgTypeNM ;
FROM PkgType 
***
DBSETPROP([lvTvrPkgTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrPkgTypeList],[VIEW],[COMMENT],[LV TVR: список типов фасовок])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список единиц измерения/*
PROCEDURE lvTvrMsuList
***
CREATE SQL VIEW lvTvrMsuList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	MeasureUnit.MsuID, ;
	MeasureUnit.MsuNM ;
FROM MeasureUnit
***
DBSETPROP([lvTvrMsuList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrMsuList],[VIEW],[COMMENT],[LV TVR: список единиц измерения])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список товаров/*
PROCEDURE lvTovarList
#DEFINE    pcvCONNECTIONNAME    SQLBASISCONNECTION
***
CREATE SQL VIEW lvTovarList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT Vtovarlist.TvrId, Vtovarlist.TvrNM, Vtovarlist.TvrParId,;
  Vtovarlist.MakerOuId, Vtovarlist.TvrTypeId, Vtovarlist.TvrTypeNM,;
  Vtovarlist.TvrTypeIsCnt, Vtovarlist.SelBmpPartMarkId,;
  Vtovarlist.BmpPartMarkId, Vtovarlist.SelBmpMarkId,;
  Vtovarlist.BmpMarkId, Vtovarlist.SelInactiveBmpId,;
  Vtovarlist.InactiveBmpId, Vtovarlist.SelBmpId, Vtovarlist.BmpId;
 FROM ;
     dbo.vTovarList Vtovarlist
***
DBSETPROP([lvTovarList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTovarList],[VIEW],[COMMENT],[LV TVR: список товаров.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список товаров (с ценой)/*
PROCEDURE lvTovarListWithPrice
***
CREATE SQL VIEW lvTovarListWithPrice REMOTE CONNECTION SQLBasisConnection SHARE AS ;
SELECT ;
	Tovar.TvrId, ;
	LTRIM(RTRIM(Tovar.TvrNM)) + ' (' + LTRIM(RTRIM(CAST(dbo.GetLastTvrPrcBuy(Tovar.TvrID, GETDATE()) as varchar(10)))) + ')' AS TvrNM ;
FROM Tovar ;
INNER JOIN TvrType ON Tovar.TvrTypeID = TvrType.TvrTypeID ;
WHERE TvrType.TvrTypeIsCnt = 0 ;
ORDER BY Tovar.TvrNM
***
DBSETPROP([lvTovarListWithPrice],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTovarListWithPrice],[VIEW],[COMMENT],[LV TVR: список товаров (с ценой).])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список только товаров/*
PROCEDURE lvTvrOnlyList
***
CREATE SQL VIEW lvTvrOnlyList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Tovar.TvrId, ;
	Tovar.TvrNM ;
FROM Tovar ;
WHERE Tovar.TvrTypeID <> 1 ;
ORDER BY Tovar.TvrNM
***
DBSETPROP([lvTvrOnlyList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrOnlyList],[VIEW],[COMMENT],[LV TVR: список только товаров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список групп товаров/*
PROCEDURE lvTvrGrpList
***
CREATE SQL VIEW lvTvrGrpList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Tovar.TvrID AS ID, ;
	Tovar.TvrNM AS NM;
FROM Tovar ;
INNER JOIN TvrType ON TvrType.TvrTypeID = Tovar.TvrTypeID AND TvrType.TvrTypeIsCnt = 1
***
DBSETPROP([lvTvrGrpList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrGrpList],[VIEW],[COMMENT],[LV TVR: список групп товаров.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: общая информация о товаре/*
PROCEDURE lvTovarInfo
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
    ISNULL(Price.PrcTypeID,0) AS PrcTypeID, ;
    ISNULL(Price.PrcMargin,0) AS PrcMargin, ;
    ISNULL(MeasureUnit.MsuNM,'') AS MsuNM ;
FROM Tovar ;
LEFT JOIN Price ON Price.TvrID = Tovar.TvrID ;
LEFT JOIN MeasureUnit ON MeasureUnit.MsuID = Tovar.MsuID ;
WHERE Tovar.TvrID = ?_PARAM
***
DBSETPROP([lvTovarInfo],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTovarInfo],[VIEW],[COMMENT],[LV TVR: общая информация о товаре.])
***
ENDPROC
*------------------------------------------------------------------------------
*/LV TVR: общая информация о товаре/*
PROCEDURE lvTovarInfoPrc
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

*/LV TVR: общая информация о товаре/*
PROCEDURE lvTvrLastBuy
***
CREATE SQL VIEW lvTvrLastBuy REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT TOP 1 ;
	StockTrans.StockTransTvrPrcBuy;
FROM StockTrans;
WHERE StockTrans.StockTransTypeID	 = 1 AND ;
	  StockTrans.StockTransTvrPrcBuy <> 0 AND ;
	  StockTrans.StockTransTvrID	 = ?_PARAM ;
ORDER BY StockTrans.StockTransDate DESC
***
DBSETPROP([lvTvrLastBuy],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrLastBuy],[VIEW],[COMMENT],[LV TVR: Последняя цена поступления товара])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: последняя цена поступления товара по подразделению/*
PROCEDURE lvTvrLastBuyOU
***
CREATE SQL VIEW lvTvrLastBuyOU REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT TOP 1 ;
	StockTrans.StockTransTvrPrcBuy;
FROM StockTrans;
WHERE StockTrans.StockTransTypeID	 = 1 AND ;
	  StockTrans.StockTransTvrPrcBuy <> 0 AND ;
	  StockTrans.StockTransOUID		 = ?_PARAM1 AND;
	  StockTrans.StockTransTvrID	 = ?_PARAM2 ;
ORDER BY StockTrans.StockTransDate DESC
***
DBSETPROP([lvTvrLastBuyOU],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrLastBuyOU],[VIEW],[COMMENT],[LV TVR: последняя цена поступления товара по подразделению])
***
ENDPROC
*------------------------------------------------------------------------------


*******************************************************************************
* Представления для наборов товаров
*******************************************************************************

*/LV TVR: редактирование набора товаров/*
PROCEDURE lvTvrSetEdit
***
CREATE VIEW lvTvrSetEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrSet.TvrSetID, ;
	TvrSet.TvrSetTypeID, ;
	TvrSet.TvrSetNM, ;
	TvrSet.BindTLU, ;
	TvrSet.FilterByTLUType, ;
	TvrSet.FilterByTvrType, ;	
	TvrSet.PrcTypeID, ;	
	TvrSet.Stamp_, ;
	TvrSet.User_ ;
FROM TvrSet ;
WHERE TvrSet.TvrSetID = ?_PARAM
***
DBSETPROP([lvTvrSetEdit.TvrSetID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvTvrSetEdit.TvrSetTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrSetEdit.TvrSetNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrSetEdit.BindTLU],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrSetEdit.FilterByTLUType],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrSetEdit.FilterByTvrType],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrSetEdit.PrcTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrSetEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrSetEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTvrSetEdit.TvrSetNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvTvrSetEdit.BindTLU],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvTvrSetEdit.FilterByTLUType],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvTvrSetEdit.FilterByTvrType],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvTvrSetEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvTvrSetEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvTvrSetEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrSetEdit],[VIEW],[COMMENT],[LV TVR: редактирование набора товаров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: редактирование вхождения набора товаров/*
PROCEDURE lvTvrInSetEdit
***
CREATE VIEW lvTvrInSetEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrInSet.TvrInSetID, ;
	TvrInSet.TvrSetID, ;
	TvrInSet.TvrId, ;
	TvrInSet.TLUId, ;
	TvrInSet.ListNumber, ;
	TvrInSet.Stamp_, ;
	TvrInSet.User_ ;
FROM TvrInSet ;
WHERE TvrInSet.TvrSetID = ?_PARAM
***
DBSETPROP([lvTvrInSetEdit.TvrInSetID],[FIELD],[KeyField],.T.)
DBSETPROP([lvTvrInSetEdit.TvrInSetID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvTvrInSetEdit.TvrSetID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrInSetEdit.TvrId],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrInSetEdit.TLUId],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrInSetEdit.ListNumber],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrInSetEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrInSetEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTvrInSetEdit.ListNumber],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvTvrInSetEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvTvrInSetEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvTvrInSetEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrInSetEdit],[VIEW],[COMMENT],[LV TVR: редактирование вхождения набора товаров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список используемых картинок/*
PROCEDURE lvTvrSetBmps
***
CREATE SQL VIEW lvTvrSetBmps REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Bitmaps.BmpId, ;
	Bitmaps.BmpFileNM ;
FROM Bitmaps ;
WHERE ;
	Bitmaps.BmpID IN (SELECT BmpID FROM TvrType) OR ;
	Bitmaps.BmpID IN (SELECT SelBmpID FROM TvrType) OR ;
	Bitmaps.BmpID IN (SELECT BmpMarkID FROM TvrType) OR ;
	Bitmaps.BmpID IN (SELECT SelBmpMarkID FROM TvrType) OR ;
	Bitmaps.BmpID IN (SELECT BmpPartMarkID FROM TvrType) OR ;
	Bitmaps.BmpID IN (SELECT SelBmpPartMarkID FROM TvrType)
***
DBSETPROP([lvTvrSetBmps],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrSetBmps],[VIEW],[COMMENT],[LV TVR: список используемых картинок])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: информация о наборе товаров/*
PROCEDURE lvTvrSetById
***
CREATE VIEW lvTvrSetById REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrSet.TvrSetID, ;
	TvrSet.TvrSetTypeID, ;
	TvrSet.TvrSetNM, ;
	TvrSet.BindTLU, ;
	TvrSet.FilterByTLUType, ;
	TvrSet.FilterByTvrType ;	
FROM TvrSet ;
WHERE TvrSet.TvrSetID = ?_PARAM
***
DBSETPROP([lvTvrSetById],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrSetById],[VIEW],[COMMENT],[LV TVR: информация о наборе товаров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список привязок к типам идентификаторов для набора товаров/*
PROCEDURE lvTvrSetTLUTypeView
***
CREATE SQL VIEW lvTvrSetTLUTypeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrSetTLUType.TvrSetTLUTypeID, ;
	TLUType.TLUTypeNM ;
FROM TvrSetTLUType ;
INNER JOIN TLUType ON TLUType.TLUTypeID = TvrSetTLUType.TLUTypeID ;
WHERE TvrSetTLUType.TvrSetID = ?_PARAM ;
ORDER BY TLUType.TLUTypeNM
***
DBSETPROP([lvTvrSetTLUTypeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrSetTLUTypeView],[VIEW],[COMMENT],[LV TVR: список привязок к типам идентификаторов для набора товаров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: редактирование привязок к типам идентификаторов для набора товаров/*
PROCEDURE lvTvrSetTLUTypeEdit
***
CREATE SQL VIEW lvTvrSetTLUTypeEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrSetTLUType.TvrSetTLUTypeID, ;
	TvrSetTLUType.TvrSetID, ;
	TvrSetTLUType.TLUTypeID ;
FROM TvrSetTLUType ;
WHERE TvrSetTLUType.TvrSetTLUTypeID = ?_PARAM
***
DBSETPROP([lvTvrSetTLUTypeEdit.TvrSetTLUTypeID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvTvrSetTLUTypeEdit.TvrSetID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrSetTLUTypeEdit.TLUTypeID],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTvrSetTLUTypeEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvTvrSetTLUTypeEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvTvrSetTLUTypeEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrSetTLUTypeEdit],[VIEW],[COMMENT],[LV TVR: редактирование привязок к типам идентификаторов для набора товаров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список привязок к типам товаров для набора товаров/*
PROCEDURE lvTvrSetTvrTypeView
***
CREATE SQL VIEW lvTvrSetTvrTypeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrSetTvrType.TvrSetTvrTypeID, ;
	TvrType.TvrTypeNM ;
FROM TvrSetTvrType ;
INNER JOIN TvrType ON TvrType.TvrTypeID = TvrSetTvrType.TvrTypeID ;
WHERE TvrSetTvrType.TvrSetID = ?_PARAM ;
ORDER BY TvrType.TvrTypeNM
***
DBSETPROP([lvTvrSetTvrTypeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrSetTvrTypeView],[VIEW],[COMMENT],[LV TVR: список привязок к типам товаров для набора товаров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: редактирование привязок к типам товаров для набора товаров/*
PROCEDURE lvTvrSetTvrTypeEdit
***
CREATE SQL VIEW lvTvrSetTvrTypeEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrSetTvrType.TvrSetTvrTypeID, ;
	TvrSetTvrType.TvrSetID, ;
	TvrSetTvrType.TvrTypeID ;
FROM TvrSetTvrType ;
WHERE TvrSetTvrType.TvrSetTvrTypeID = ?_PARAM
***
DBSETPROP([lvTvrSetTvrTypeEdit.TvrSetTvrTypeID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvTvrSetTvrTypeEdit.TvrSetID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrSetTvrTypeEdit.TvrTypeID],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTvrSetTvrTypeEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvTvrSetTvrTypeEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvTvrSetTvrTypeEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrSetTvrTypeEdit],[VIEW],[COMMENT],[LV TVR: редактирование привязок к типам товаров для набора товаров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: просмотр наборов товаров/*
PROCEDURE lvTvrSetView
***
CREATE SQL VIEW lvTvrSetView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrSet.TvrSetID, ;
	TvrSet.TvrSetTypeID, ;
	TvrSet.TvrSetNM ;
FROM TvrSet ;
ORDER BY Tvrset.TvrSetNM
***
DBSETPROP([lvTvrSetView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrSetView],[VIEW],[COMMENT],[LV TVR: просмотр наборов товаров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список наборов товаров/*
PROCEDURE lvTvrSetList
***
CREATE SQL VIEW lvTvrSetList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrSet.TvrSetID AS ID, ;
	TvrSet.TvrSetNM AS NM ;
FROM TvrSet ;
ORDER BY TvrSet.TvrSetNM
***
DBSETPROP([lvTvrSetList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrSetList],[VIEW],[COMMENT],[LV TVR: список наборов товаров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список наборов товаров для весов/*
PROCEDURE lvTvrSetListToScale
***
CREATE SQL VIEW lvTvrSetListToScale REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrSet.TvrSetID AS ID, ;
	TvrSet.TvrSetNM AS NM ;
FROM TvrSet ;
INNER JOIN TvrSetTLUType ON TvrSetTLUType.TvrSetID = TvrSet.TvrSetID ;
INNER JOIN TLUType		 ON TLUType.TLUTypeID = TvrSetTLUType.TLUTypeID ;
GROUP BY TvrSet.TvrSetID,TvrSet.TvrSetNM ;
HAVING SUM(CASE WHEN TLUType.TLUTypeIsWeight = 1 THEN 1 ELSE 0 END) > 0 AND SUM(CASE WHEN TLUType.TLUTypeIsWeight = 1 THEN 0 ELSE 1 END) = 0 ;
ORDER BY TvrSet.TvrSetNM
***
DBSETPROP([lvTvrSetListToScale],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrSetListToScale],[VIEW],[COMMENT],[LV TVR: список наборов товаров для весов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список наборов товаров с ШК/*
PROCEDURE lvTvrSetListBindTLU
***
CREATE SQL VIEW lvTvrSetListBindTLU REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrSet.TvrSetID AS ID, ;
	TvrSet.TvrSetNM AS NM ;
FROM TvrSet ;
WHERE TvrSet.BindTLU = 1
***
DBSETPROP([lvTvrSetListBindTLU],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrSetListBindTLU],[VIEW],[COMMENT],[LV TVR: список наборов товаров с ШК])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список типов наборов товаров/*
PROCEDURE lvTvrSetTypeList
***
CREATE SQL VIEW lvTvrSetTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrSetType.TvrSetTypeID AS ID, ;
	TvrSetType.TvrSetTypeNM AS NM ;
FROM TvrSetType
***
DBSETPROP([lvTvrSetTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrSetTypeList],[VIEW],[COMMENT],[LV TVR: список типов наборов товаров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: корень поддерева и тип прайс-листа набора товаров/*
PROCEDURE lvTvrSetInfo
***
CREATE SQL VIEW lvTvrSetInfo REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrSet.TvrSetTypeID, ;
	TvrInSet.TvrID, ;
	TvrSet.PrcTypeID ;
FROM TvrSet ;
INNER JOIN TvrInSet ON TvrInSet.TvrSetID = TvrSet.TvrSetID ;
WHERE TvrSet.TvrSetID = ?_PARAM
***
DBSETPROP([lvTvrSetInfo],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrSetInfo],[VIEW],[COMMENT],[LV TVR: корень поддерева и тип прайс-листа набора товаров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: редактирование правил печати/*
PROCEDURE lvTvrActRuleEdit
***
CREATE SQL VIEW lvTvrActRuleEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	AccPrint.AccPrintID, ;
	AccPrint.ActionRuleID, ;
	AccPrint.TvrID, ;
	AccPrint.Stamp_, ;
	AccPrint.User_ ;
FROM AccPrint ;
WHERE AccPrint.AccPrintID = ?_PARAM
***
DBSETPROP([lvTvrActRuleEdit.AccPrintID],[FIELD],[KeyField],.T.)
DBSETPROP([lvTvrActRuleEdit.AccPrintID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvTvrActRuleEdit.ActionRuleID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrActRuleEdit.TvrID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrActRuleEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrActRuleEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTvrActRuleEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvTvrActRuleEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvTvrActRuleEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrActRuleEdit],[VIEW],[COMMENT],[LV TVR: редактирование правил печати])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: просмотр правил печати/*
PROCEDURE lvTvrActRuleView
***
CREATE SQL VIEW lvTvrActRuleView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ActionRule.ActionRuleNM, ;
	AccPrint.AccPrintID, ;
	AccPrint.ActionRuleID, ;
	AccPrint.TvrID, ;
	Cash.CashNM ;
FROM ActionRule ;
INNER JOIN AccPrint	ON ActionRule.ActionRuleID = AccPrint.ActionRuleID ;
INNER JOIN Cash		ON Cash.CashID = ActionRule.ActionRulePointEmi ;
WHERE AccPrint.TvrID = ?_PARAM
***
DBSETPROP([lvTvrActRuleView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrActRuleView],[VIEW],[Comment],[LV TVR: просмотр правил печати])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: список правил печати/*
PROCEDURE lvAccTypeList
***
CREATE SQL VIEW lvAccTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ActionRule.ActionRuleID, ;
	ActionRule.ActionRuleNM ;
FROM ActionRule;
ORDER BY ActionRule.ActionRuleNM
***
DBSETPROP([lvAccTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvAccTypeList],[VIEW],[Comment],[LV TVR: просмотр правил печати])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR/*
PROCEDURE lvAccTypeListAdd
***
CREATE SQL VIEW lvAccTypeListAdd REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ActionRule.ActionRuleID, ;
	ActionRule.ActionRuleNM ;
FROM ActionRule ;
WHERE ActionRule.ActionRuleID NOT IN (SELECT ;
										  ActionRule.ActionRuleID ;
									  FROM ActionRule ;
									  INNER JOIN AccPrint ON ActionRule.ActionRuleID = AccPrint.ActionRuleID ;
									  WHERE AccPrint.TvrID = ?_PARAM );
ORDER BY ActionRule.ActionRuleNM
***
DBSETPROP([lvAccTypeListAdd],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvAccTypeListAdd],[VIEW],[Comment],[LV TVR])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: Возвращает по коду товара код формы/*
PROCEDURE lvAccRetFrm
***
CREATE SQL VIEW lvAccRetFrm REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Accounting.AccFrmID ;
FROM Accounting ;
WHERE Accounting.AccTvrID = ?_PARAM
***
DBSETPROP([lvAccRetFrm],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvAccRetFrm],[VIEW],[Comment],[LV TVR: Возвращает по коду товара код формы])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: Возвращает по коду формы код товара/*
PROCEDURE lvAccRetTvr
***
CREATE SQL VIEW lvAccRetTvr REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Accounting.AccTvrID ;
FROM Accounting ;
WHERE Accounting.AccFrmID = ?_PARAM
***
DBSETPROP([lvAccRetTvr],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvAccRetTvr],[VIEW],[Comment],[LV TVR: Возвращает по коду формы код товара])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: Возвращает по коду формы код товара/*
PROCEDURE lvDocToTo29
***
CREATE SQL VIEW lvDocToTo29 REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
    Frmtype.frmtypeabbr + ' №' + Form.frmnum + ' от ' + CONVERT(varchar(12),Form.frmdateacc,104) AS NM, ;
    Frmtype.frmtypedirection, ;
    Frmtype.frmtypeabbr, ;
    Form.frmnum, ;
    Form.frmdate, ;
    Form.frmdateacc, ;
    Form.frmid, ;
    Form.pointemiouid, ;
    Form.pointispouid ;
FROM Form ;
INNER JOIN FrmType ON Frmtype.frmtypeid = Form.frmtypeid ;
WHERE ( ;
	Form.frmdateacc =?_PARAMDv AND ;
	Form.frmid <>?_PARAM) AND ( ;
	Form.pointemiouid =?_PARAMO OR ;
	Form.pointispouid = ?_PARAMO)
***
DBSETPROP([lvDocToTo29],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDocToTo29],[VIEW],[Comment],[LV TVR: Список документов для включения в ТО 29])
***
ENDPROC
*------------------------------------------------------------------------------


*/LV TVR: список групп меню/*
PROCEDURE lvTvrMnuList
***
CREATE SQL VIEW lvTvrMnuList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Tovar.TvrId AS Id, ;
	Tovar.TvrNm AS Nm ;
FROM Tovar;
WHERE Tovar.TvrTypeId = 7
***
DBSETPROP([lvTvrMnuList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrMnuList],[VIEW],[Comment],[LV TVR: список групп меню])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: редактирование таблицы TvrConstraint*/
PROCEDURE lvTvrConstraintEdit
***
CREATE SQL VIEW lvTvrConstraintEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrConstraint.TvrCID, ;
	TvrConstraint.TvrID, ;
	TvrConstraint.OUID, ;
	TvrConstraint.TvrMinQnt, ;
	TvrConstraint.TvrMaxQnt ;
FROM TvrConstraint ;
WHERE TvrConstraint.TvrCID = ?_PARAM
***
DBSETPROP([lvTvrConstraintEdit.TvrCID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvTvrConstraintEdit.TvrCID],[FIELD],[Updatable],.F.)
DBSETPROP([lvTvrConstraintEdit.TvrID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrConstraintEdit.OUID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrConstraintEdit.TvrMinQnt],[FIELD],[Updatable],.T.)
DBSETPROP([lvTvrConstraintEdit.TvrMaxQnt],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTvrConstraintEdit.TvrMinQnt],[FIELD],[DefaultValue],[0])
DBSETPROP([lvTvrConstraintEdit.TvrMaxQnt],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvTvrConstraintEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvTvrConstraintEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvTvrConstraintEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrConstraintEdit],[VIEW],[COMMENT],[LV TVR: редактирование таблицы TvrConstraint])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TVR: текущие остатки товара на складе*/
PROCEDURE lvStockTvrQnt
***
CREATE SQL VIEW lvStockTvrQnt REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CAST(ISNULL(SUM(Stock.stocktvrqnt),0) AS numeric(10,3)) AS tvrqnt ;
FROM Stock ;
WHERE ;
	Stock.stocktvrid = ?_PARAM_TVR AND ;
	(Stock.stockouid = ?_PARAM_OU OR ?_PARAM_OU IS NULL OR ?_PARAM_OU = 0) AND ;
	Stock.stockvalidthru IS NULL
***
DBSETPROP([lvStockTvrQnt],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvStockTvrQnt],[VIEW],[COMMENT],[LV TVR: Текущие остатки товара на складе])
***
ENDPROC
*------------------------------------------------------------------------------