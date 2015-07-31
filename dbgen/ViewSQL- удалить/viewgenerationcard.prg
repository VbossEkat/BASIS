#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 16:41 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Скидки] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Скидки]
***
lvDiscView()
lvDiscViewRepl()
lvDiscEdit()
***
lvDiscCardView()
lvDiscCardViewRepl()
lvDiscCardEdit()
lvDiscCardList()
lvDiscCardViewByCLU()
***
lvDiscInfoByDiscCardID()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV DSC: типы скидок/*
PROCEDURE lvDiscView
***
CREATE VIEW lvDiscView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Discount.DiscID, ;
	Discount.DiscNM, ;
	Discount.DiscRate, ;
	Discount.DiscIsSystem ;
FROM Discount
***
DBSETPROP([lvDiscView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscView],[VIEW],[COMMENT],[LV DSC: Скидки])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: обновления для lvDiscView/*
PROCEDURE lvDiscViewRepl
***
CREATE VIEW lvDiscViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Discount.DiscID, ;
	Discount.DiscNM, ;
	Discount.DiscRate, ;
	Discount.DiscIsSystem ;
FROM Discount;
WHERE Discount.DiscID = ?_PARAM
***
DBSETPROP([lvDiscViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscViewRepl],[VIEW],[COMMENT],[LV DSC: обновления для lvDiscView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: Редактирование таблицы Discount/*
PROCEDURE lvDiscEdit
***
CREATE VIEW lvDiscEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Discount.DiscID, ;
	Discount.DiscNM, ;
	Discount.DiscRate, ;
	Discount.DiscIsSystem, ;
	Discount.Stamp_, ;
	Discount.User_ ;
FROM Discount ;
WHERE Discount.DiscID = ?_PARAM
***
DBSETPROP([lvDiscEdit.DiscID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvDiscEdit.DiscID],[FIELD],[Updatable],.F.)
DBSETPROP([lvDiscEdit.DiscNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvDiscEdit.DiscRate],[FIELD],[Updatable],.T.)
DBSETPROP([lvDiscEdit.DiscIsSystem],[FIELD],[Updatable],.T.)
DBSETPROP([lvDiscEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvDiscEdit.User_ ],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvDiscEdit.DiscNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvDiscEdit.DiscRate],[FIELD],[DefaultValue],[0])
DBSETPROP([lvDiscEdit.DiscIsSystem],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvDiscEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvDiscEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvDiscEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscEdit],[VIEW],[COMMENT],[LV DSC: Редактирование таблицы Discount])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: дисконтные карты/*
PROCEDURE lvDiscCardView
***
CREATE SQL VIEW lvDiscCardView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DiscCard.DiscCardID, ;
	DiscCard.DiscCardNM, ;
	DiscCard.CLU, ;
	ISNULL(Client.CltNM,'') AS CltNM, ;
	ISNULL(Discount.DiscNM,'') AS DiscNM, ;
	DiscCard.DiscCardIsActive ;
FROM DiscCard ;
LEFT JOIN Client ON Client.CltID = DiscCard.CltID ;
LEFT JOIN Discount ON Discount.DiscID = DiscCard.DiscID ;
ORDER BY 2
***
DBSETPROP([lvDiscCardView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscCardView],[VIEW],[COMMENT],[LV DSC: дисконтные карты])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: Обновления для lvDiscCardView/*
PROCEDURE lvDiscCardViewRepl
***
CREATE SQL VIEW lvDiscCardViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DiscCard.DiscCardID, ;
	DiscCard.DiscCardNM, ;
	DiscCard.CLU, ;
	ISNULL(Client.CltNM,'') AS CltNM, ;
	ISNULL(Discount.DiscNM,'') AS DiscNM, ;
	DiscCard.DiscCardIsActive ;
FROM DiscCard ;
LEFT JOIN Client ON Client.CltID = DiscCard.CltID ;
LEFT JOIN Discount ON Discount.DiscID = DiscCard.DiscID ;
WHERE DiscCard.DiscCardID = ?_PARAM
***
DBSETPROP([lvDiscCardViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscCardViewRepl],[VIEW],[COMMENT],[LV DSC: Обновления для lvDiscCardView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: Редактирование таблицы DiscCard/*
PROCEDURE lvDiscCardEdit
***
CREATE SQL VIEW lvDiscCardEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DiscCard.DiscCardID, ;
	DiscCard.CLU, ;
	DiscCard.CltID, ;
	DiscCard.DiscID, ;
	DiscCard.DiscCardDeliveryDate, ;
	DiscCard.DiscCardDisableDate, ;
	DiscCard.DiscCardIsActive, ;
	DiscCard.Stamp_, ;
	DiscCard.User_ ;
FROM DiscCard ;
WHERE DiscCard.DiscCardID = ?_PARAM
***
DBSETPROP([lvDiscCardEdit.DiscCardID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvDiscCardEdit.DiscCardID],[FIELD],[Updatable],.F.)
DBSETPROP([lvDiscCardEdit.CLU],[FIELD],[Updatable],.T.)
DBSETPROP([lvDiscCardEdit.CltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvDiscCardEdit.DiscID],[FIELD],[Updatable],.T.)
DBSETPROP([lvDiscCardEdit.DiscCardDeliveryDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvDiscCardEdit.DiscCardDisableDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvDiscCardEdit.DiscCardIsActive ],[FIELD],[Updatable],.T.)
DBSETPROP([lvDiscCardEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvDiscCardEdit.User_ ],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvDiscCardEdit.CLU],[FIELD],[DefaultValue],[""])
DBSETPROP([lvDiscCardEdit.DiscCardDeliveryDate],[FIELD],[DefaultValue],[DATE()])
DBSETPROP([lvDiscCardEdit.DiscCardIsActive ],[FIELD],[DefaultValue],[.T.])
DBSETPROP([lvDiscCardEdit.Stamp_],[FIELD],[DefaultValue],[DATETIME()])
DBSETPROP([lvDiscCardEdit.User_ ],[FIELD],[DefaultValue],[-1])
***
DBSETPROP([lvDiscCardEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvDiscCardEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvDiscCardEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscCardEdit],[VIEW],[COMMENT],[LV DSC: дисконтные карты])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: активные дисконтные карты/*
PROCEDURE lvDiscCardList
***
CREATE SQL VIEW lvDiscCardList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DiscCard.DiscCardID, ;
	DiscCard.DiscCardNM, ;
	DiscCard.CLU, ;
	ISNULL(Client.CltNM,'')	AS CltNM, ;
	ISNULL(Discount.DiscNM,'') AS DiscNM ;
FROM DiscCard ;
LEFT JOIN Client ON Client.CltID = DiscCard.CltID ;
LEFT JOIN Discount ON Discount.DiscID = DiscCard.DiscID ;
WHERE DiscCard.DiscCardIsActive ;
ORDER BY DiscCard.DiscCardNM
***
DBSETPROP([lvDiscCardList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscCardList],[VIEW],[COMMENT],[LV DSC: активные дисконтные карты])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: активные дисконтные карты/*
PROCEDURE lvDiscCardViewByCLU
***
CREATE SQL VIEW lvDiscCardViewByCLU REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DiscCard.DiscCardID, ;
	DiscCard.DiscCardNM, ;
	CltNM = CASE WHEN CltPhysical.CltID IS NULL THEN '' ELSE ;
		CltPhysical.CltPhysFNM + ' ' + ;
		CltPhysical.CltPhysINM + ' ' + ;
		CltPhysical.CltPhysONM END, ;
	ISNULL(Discount.DiscNM,'') AS DiscNM ;
FROM DiscCard ;
LEFT JOIN CltPhysical ON CltPhysical.CltID = DiscCard.CltID ;
LEFT JOIN Discount	  ON Discount.DiscID = DiscCard.DiscID ;
WHERE DiscCard.DiscCardIsActive=1 AND DiscCard.CLU = ?_PARAM
***
DBSETPROP([lvDiscCardViewByCLU],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscCardViewByCLU],[VIEW],[COMMENT],[LV DSC: данные дисконтной карты по CLU])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: информация о скидке по дисконтной карте/*
PROCEDURE lvDiscInfoByDiscCardID
***
CREATE SQL VIEW lvDiscInfoByDiscCardID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Discount.DiscID, ;
	Discount.DiscTypeID, ;
	Discount.DiscNM, ;
	Discount.DiscRate ;
FROM Discount ;
INNER JOIN DiscCard ON DiscCard.DiscID = Discount.DiscID ;
WHERE DiscCard.DiscCardID = ?_PARAM
***
DBSETPROP([lvDiscInfoByDiscCardID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscInfoByDiscCardID],[VIEW],[COMMENT],[LV DSC: информация о скидке по дисконтной карте])
***
ENDPROC
*------------------------------------------------------------------------------