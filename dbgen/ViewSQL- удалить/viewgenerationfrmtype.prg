#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 17:09 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Типы документов] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Типы документов]
***
lvFrmTypeEdit()
lvFrmTypeView()
lvFrmAttributeList()
lvFrmAttributeListByFrmID()
lvFrmAttributeListByFrmTypeID()
lvSpravList()
lvReportList()
lvStockTransTypeList()
lvFrmTypeStockTransList()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------	

*/LV FRMTYPE: редактирование типа документа/*
PROCEDURE lvFrmTypeEdit
***
CREATE SQL VIEW lvFrmTypeEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmType.FrmTypeID, ;
	FrmType.FrmTypeNM, ;
	FrmType.FrmTypeShortNM, ;
	FrmType.FrmTypeAbbr, ;
	FrmType.FrmTypeNote, ;
	FrmType.FrmTypeEditObjDesc, ;
	FrmType.FrmTypeDirection, ;
	FrmType.FrmTypeIsContainTvr, ;
	FrmType.FrmTypeIsContainFrm, ;
	FrmType.PointEmiRoleNM, ;
	FrmType.PointEmiSprID, ;
	FrmType.PointIspRoleNM, ;
	FrmType.PointIspSprID, ;
	FrmType.DevRoleNM, ;
	FrmType.DevSprID, ;
	FrmType.ExecEmiRoleNM, ;
	FrmType.ExecEmiSprID, ;
	FrmType.ExecIspRoleNM, ;
	FrmType.ExecIspSprID, ;
	FrmType.ContrRoleNM, ;
	FrmType.ContrSprID, ;
	FrmType.PointEmiAccountSprID, ;
	FrmType.PointIspAccountSprID, ;
	FrmType.ContainPriceBuy, ;
	FrmType.ContainPriceSale, ;
	FrmType.FrmTypePayListInc, ;
	FrmType.RptID, ;
	FrmType.StockTransTypeID, ;
	FrmType.FrmTypeAttribute, ;
	FrmType.Stamp_, ;
	FrmType.User_ ;
FROM FrmType ;
WHERE FrmType.FrmTypeID = ?_PARAM
***
DBSETPROP([lvFrmTypeEdit.FrmTypeID],[FIELD],[KeyField],.T.)
DBSETPROP([lvFrmTypeEdit.FrmTypeID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvFrmTypeEdit.FrmTypeNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.FrmTypeShortNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.FrmTypeAbbr],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.FrmTypeNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.FrmTypeEditObjDesc],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.FrmTypeDirection],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.FrmTypeIsContainTvr],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.FrmTypeIsContainFrm],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.PointEmiRoleNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.PointEmiSprID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.PointIspRoleNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.PointIspSprID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.DevRoleNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.DevSprID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.ExecEmiRoleNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.ExecEmiSprID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.ExecIspRoleNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.ExecIspSprID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.ContrRoleNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.ContrSprID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.PointEmiAccountSprID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.PointIspAccountSprID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.ContainPriceBuy],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.ContainPriceSale],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.FrmTypePayListInc],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.RptID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.StockTransTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.FrmTypeAttribute],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmTypeEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvFrmTypeEdit.FrmTypeNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmTypeEdit.FrmTypeShortNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmTypeEdit.FrmTypeAbbr],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmTypeEdit.FrmTypeNote],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmTypeEdit.FrmTypeEditObjDesc],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmTypeEdit.FrmTypeDirection],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmTypeEdit.FrmTypeIsContainTvr],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvFrmTypeEdit.FrmTypeIsContainFrm],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvFrmTypeEdit.PointEmiRoleNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmTypeEdit.PointIspRoleNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmTypeEdit.DevRoleNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmTypeEdit.ExecEmiRoleNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmTypeEdit.ExecIspRoleNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmTypeEdit.ContrRoleNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmTypeEdit.ContainPriceBuy],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvFrmTypeEdit.ContainPriceSale],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvFrmTypeEdit.FrmTypePayListInc],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvFrmTypeEdit.FrmTypeAttribute],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvFrmTypeEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvFrmTypeEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvFrmTypeEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTypeEdit],[VIEW],[COMMENT],[LV FRMTYPE: редактирование типа документа.])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV FRMTYPE: просмотр типов документов/*
PROCEDURE lvFrmTypeView
***
CREATE SQL VIEW lvFrmTypeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmType.FrmTypeID, ;
	FrmType.FrmTypeNM, ;
	FrmType.FrmTypeAbbr, ;
	FrmTypeDirection = CASE WHEN FrmType.FrmTypeDirection = 1 THEN 'Внутренний документ' ELSE CASE WHEN FrmType.FrmTypeDirection = 2 THEN 'Входящий документ' ELSE CASE WHEN FrmType.FrmTypeDirection = 3 THEN 'Исходящий документ' ELSE 'ERROR' END END END ;
FROM FrmType
***
DBSETPROP([lvFrmTypeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTypeView],[VIEW],[COMMENT],[LV FRMTYPE: просмотр типов документов.])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV FRMTYPE: список атрибутов документа/*
PROCEDURE lvFrmAttributeList
***
CREATE SQL VIEW lvFrmAttributeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmAttribute.FrmAttributeBit AS FrmAttrBit, ;
	FrmAttribute.FrmAttributeNM AS FrmAttrNM ;
FROM FrmAttribute ;
ORDER BY FrmAttribute.FrmAttributeNM
***
DBSETPROP([lvFrmAttributeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmAttributeList],[VIEW],[COMMENT],[LV FRMTYPE: список атрибутов документа])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRMTYPE: список атрибутов документа по идентификатору документа/*
PROCEDURE lvFrmAttributeListByFrmID
***
CREATE SQL VIEW lvFrmAttributeListByFrmID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmAttribute.FrmAttributeBit AS FrmAttrBit, ;
	FrmAttribute.FrmAttributeNM AS FrmAttrNM ;
FROM Form ;
INNER JOIN FrmType ON FrmType.FrmTypeID = Form.FrmTypeID ;
INNER JOIN FrmAttribute ON dbo.BITTEST(FrmType.FrmTypeAttribute,FrmAttribute.FrmAttributeBit) = 1 ;
WHERE Form.FrmID = ?_PARAM
***
DBSETPROP([lvFrmAttributeListByFrmID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmAttributeListByFrmID],[VIEW],[COMMENT],[LV FRMTYPE: список атрибутов документа по идентификатору документа])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRMTYPE: список атрибутов документа по идентификатору типа документа/*
PROCEDURE lvFrmAttributeListByFrmTypeID
***
CREATE SQL VIEW lvFrmAttributeListByFrmTypeID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmAttribute.FrmAttributeBit AS FrmAttrBit, ;
	FrmAttribute.FrmAttributeNM AS FrmAttrNM ;
FROM FrmType ;
INNER JOIN FrmAttribute ON dbo.BITTEST(FrmType.FrmTypeAttribute,FrmAttribute.FrmAttributeBit) = 1 ;
WHERE FrmType.FrmTypeID = ?_PARAM
***
DBSETPROP([lvFrmAttributeListByFrmTypeID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmAttributeListByFrmTypeID],[VIEW],[COMMENT],[LV FRMTYPE: список атрибутов документа по идентификатору типа документа])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRMTYPE: список справочников/*
PROCEDURE lvSpravList
***
CREATE SQL VIEW lvSpravList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	SprID AS ID, ;
	SprNM AS NM ;
FROM Sprav ;
ORDER BY Sprav.SprNM
***
DBSETPROP([lvSpravList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvSpravList],[VIEW],[COMMENT],[LV FRMTYPE: список справочников.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRMTYPE: список отчетов/*
PROCEDURE lvReportList
***
CREATE SQL VIEW lvReportList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	RptID AS ID, ;
	RptNM AS NM ;
FROM Report ;
ORDER BY Report.RptNM
***
DBSETPROP([lvReportList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvReportList],[VIEW],[COMMENT],[LV FRMTYPE: список отчетов.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRMTYPE: список типов товарных транзакций/*
PROCEDURE lvStockTransTypeList
***
CREATE SQL VIEW lvStockTransTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	StockTransTypeID AS ID, ;
	StockTransTypeNM AS NM ;
FROM StockTransType ;
ORDER BY StockTransType.StockTransTypeNM
***
DBSETPROP([lvStockTransTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvStockTransTypeList],[VIEW],[COMMENT],[LV FRMTYPE: список типов товарных транзакций.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRMTYPE: список документов, участвующих в количественном учете/*
PROCEDURE lvFrmTypeStockTransList
***
CREATE SQL VIEW lvFrmTypeStockTransList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmType.FrmTypeID AS ID, ;
	FrmType.FrmTypeNM AS NM ;
FROM FrmType ;
WHERE NOT FrmType.StockTransTypeID IS NULL ;
ORDER BY FrmType.FrmTypeNM
***
DBSETPROP([lvFrmTypeStockTransList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTypeStockTransList],[VIEW],[COMMENT],[LV FRMTYPE: список документов, участвующих в количественном учете])
***
ENDPROC
*------------------------------------------------------------------------------
