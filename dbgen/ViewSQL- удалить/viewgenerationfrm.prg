#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 16:38 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Документы] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Документы]
***
lvFrmEdit()
lvFrmPayDetailEdit()
lvFrmPartTvrEdit()
lvFrmPartFrmEdit()
lvFrmPartFrmSumEdit()
lvFrmTvrSumFrm()
lvFrmTvrSumPay()
lvFrmTypeInfoByScrFrm()
lvFrmTypeInfo()
lvFrmTypeObjDescInfo()
lvFrmTypeInfoByFrm()
lvFrmTypeObjDescInfoByFrm()
lvFrmTypeListByScrFrm()
lvFrmTypeList()
lvFrmStatusList()
lvFrmStatusInfoByID()
lvFrmStatusInfoByFrmID()
lvFrmSumSplitProcList()
lvFrmSumSplitProc()
lvFrmPartFrmSumView()
lvOwnSAccountByFrm()
lvFrmTypeListCopyAsByFrm()
lvFrmTypeListInheritByFrm()
lvFrmParListByFrmType()
lvNaklInList()
***
lvFrmAutoNumView()
lvFrmAutoNumEdit()
lvFrmAutoNumViewRepl()
***
lvFrmActionView()
***
lvFrmView()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV FRM: редактирование заголовка документа/*
PROCEDURE lvFrmEdit
***
CREATE SQL VIEW lvFrmEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Form.FrmID, ;
	Form.FrmParID, ;
	Form.FrmTypeID, ;
	Form.FrmDate, ;
	Form.FrmDateAcc, ;
	Form.FrmNum, ;
	Form.FrmNote, ;
	Form.FrmReason, ;
	Form.FrmStatusID, ;
	Form.FrmIsPayed, ;
	Form.PointEmiOuID, ;
	Form.PointEmiCltID, ;
	Form.PointIspOuID, ;
	Form.PointIspCltID, ;
	Form.DevCltID, ;
	Form.ExecEmiCltID, ;
	Form.ExecIspCltID, ;
	Form.ContrCltID, ;
	Form.PointEmiCltSAccID, ;
	Form.PointIspCltSAccID, ;
	Form.FrmCurTypeID, ;
	Form.FrmPrcTypeID, ;
	Form.FrmAttribute, ;
	Form.OperID, ;
	Form.Stamp_, ;
	Form.User_ ;
FROM Form ;
WHERE FrmID = ?_PARAM
***
DBSETPROP([lvFrmEdit.FrmID],[FIELD],[KeyField],.T.)
DBSETPROP([lvFrmEdit.FrmID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvFrmEdit.FrmParID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.FrmTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.FrmDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.FrmDateAcc],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.FrmNum],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.FrmNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.FrmReason],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.FrmStatusID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.FrmIsPayed],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.PointEmiOuID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.PointEmiCltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.PointIspOuID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.PointIspCltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.DevCltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.ExecEmiCltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.ExecIspCltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.ContrCltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.PointEmiCltSAccID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.PointIspCltSAccID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.FrmCurTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.FrmPrcTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.FrmAttribute],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.OperID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvFrmEdit.FrmDate],[FIELD],[DefaultValue],[DATETIME()])
DBSETPROP([lvFrmEdit.FrmDateAcc],[FIELD],[DefaultValue],[DATETIME()])
DBSETPROP([lvFrmEdit.FrmNum],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmEdit.FrmNote],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmEdit.FrmReason],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmEdit.FrmStatusID],[FIELD],[DefaultValue],[1])
DBSETPROP([lvFrmEdit.FrmIsPayed],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvFrmEdit.FrmAttribute],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvFrmEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvFrmEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvFrmEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmEdit],[VIEW],[COMMENT],[LV FRM: редактирование заголовка документа])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: редактирование дополнительных атрибутов платежного документа/*
PROCEDURE lvFrmPayDetailEdit
***
CREATE SQL VIEW lvFrmPayDetailEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPayDetail.FrmID, ;
	FrmPayDetail.FrmPayDetailOrder, ;
	FrmPayDetail.FrmPayDetailPayerStatus, ;
	FrmPayDetail.FrmPayDetailCBC, ;
	FrmPayDetail.FrmPayDetailOCATO, ;
	FrmPayDetail.FrmPayDetailPurpose, ;
	FrmPayDetail.FrmPayDetailTaxPeriod, ;
	FrmPayDetail.FrmPayDetailNum, ;
	FrmPayDetail.FrmPayDetailDate,;
	FrmPayDetail.FrmPayDetailType;
FROM FrmPayDetail ;
WHERE FrmID = ?_PARAM
***
DBSETPROP([lvFrmPayDetailEdit.FrmID],[FIELD],[KeyField],.T.)
DBSETPROP([lvFrmPayDetailEdit.FrmID],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailOrder],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailPayerStatus],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailCBC],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailOCATO],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailPurpose],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailTaxPeriod],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailNum],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailType],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailOrder],[FIELD],[DefaultValue],["06"])
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailPayerStatus],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailCBC],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailOCATO],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailPurpose],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailTaxPeriod],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailNum],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmPayDetailEdit.FrmPayDetailType],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvFrmPayDetailEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvFrmPayDetailEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvFrmPayDetailEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmPayDetailEdit],[VIEW],[COMMENT],[LV FRM: редактирование дополнительных атрибутов платежного документа])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: редактирование содержания документа (товарной позиции)/*
PROCEDURE lvFrmPartTvrEdit
***
CREATE SQL VIEW lvFrmPartTvrEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
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
	Stamp_, ;
	User_ ;
FROM FrmPartTvr ;
WHERE FrmPartTvrID = ?_PARAM
***
DBSETPROP([lvFrmPartTvrEdit.FrmPartTvrID],[FIELD],[KeyField],.T.)
DBSETPROP([lvFrmPartTvrEdit.FrmPartTvrID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvFrmPartTvrEdit.FrmID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEdit.TvrId],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEdit.MsuId],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEdit.TvrQnt],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEdit.TvrQntNetto],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEdit.TvrPrcBuy],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEdit.TvrPrcSale],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEdit.TvrVATRate],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEdit.TvrExpiredDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEdit.TvrIDCalc],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEdit.TvrAttr],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartTvrEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvFrmPartTvrEdit.TvrQnt],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartTvrEdit.TvrQntNetto],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartTvrEdit.TvrPrcBuy],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartTvrEdit.TvrPrcSale],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartTvrEdit.TvrVATRate],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartTvrEdit.TvrIDCalc],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartTvrEdit.TvrAttr],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvFrmPartTvrEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvFrmPartTvrEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvFrmPartTvrEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmPartTvrEdit],[VIEW],[COMMENT],[LV FRM: редактирование содержания документа (товарной позиции)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: редактирование содержания документа (суммовой позиции)/*
PROCEDURE lvFrmPartFrmEdit

#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvFrmPartFrmEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPartFrm.FrmPartFrmID, ;
	FrmPartFrm.FrmID, ;
	FrmPartFrm.CntFrmID, ;
	FrmPartFrm.CntFrmIncludeSum, ;
	FrmPartFrm.CntFrmIncludeSumVAT, ;
	FrmPartFrm.CntFrmIncludeSumVATRate, ;
	FrmPartFrm.CntFrmSumSplitProcID, ;
	FrmPartFrm.FrmPartFrmNote, ;
	FrmPartFrm.Stamp_, ;
	FrmPartFrm.User_ ;
FROM FrmPartFrm ;
WHERE FrmPartFrm.FrmPartFrmID = ?_PARAM
***
DBSETPROP([lvFrmPartFrmEdit.FrmPartFrmID],[FIELD],[KeyField],.T.)
DBSETPROP([lvFrmPartFrmEdit.FrmPartFrmID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvFrmPartFrmEdit.FrmID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartFrmEdit.CntFrmID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartFrmEdit.CntFrmIncludeSum],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartFrmEdit.CntFrmIncludeSumVAT],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartFrmEdit.CntFrmIncludeSumVATRate],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartFrmEdit.CntFrmSumSplitProcID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartFrmEdit.FrmPartFrmNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartFrmEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartFrmEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvFrmPartFrmEdit.CntFrmIncludeSum],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartFrmEdit.CntFrmIncludeSumVAT],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartFrmEdit.CntFrmIncludeSumVATRate],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartFrmEdit.CntFrmSumSplitProcID],[FIELD],[DefaultValue],[1])
DBSETPROP([lvFrmPartFrmEdit.FrmPartFrmNote],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvFrmPartFrmEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvFrmPartFrmEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvFrmPartFrmEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmPartFrmEdit],[VIEW],[COMMENT],[LV FRM: редактирование содержания документа (суммовой позиции)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: редактирование суммового содержания документа (таблица FrmPartFrmSum)/*
PROCEDURE lvFrmPartFrmSumEdit
***
CREATE SQL VIEW lvFrmPartFrmSumEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPartFrmSum.FrmPartFrmSumID, ;
	FrmPartFrmSum.FrmPartFrmID, ;
	FrmPartFrmSum.FrmPartFrmSum, ;
	FrmPartFrmSum.FrmPartFrmSumVATRate, ;
	FrmPartFrmSum.User_, ;
	FrmPartFrmSum.Stamp_ ;
FROM FrmPartFrmSum ;
WHERE FrmPartFrmSum.FrmPartFrmSumID = ?_PARAM
***
DBSETPROP([lvFrmPartFrmSumEdit.FrmPartFrmSumID],[FIELD],[KeyField],.T.)
DBSETPROP([lvFrmPartFrmSumEdit.FrmPartFrmSumID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvFrmPartFrmSumEdit.FrmPartFrmID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartFrmSumEdit.FrmPartFrmSum],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartFrmSumEdit.FrmPartFrmSumVATRate],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartFrmSumEdit.User_],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmPartFrmSumEdit.Stamp_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvFrmPartFrmSumEdit.FrmPartFrmSum],[FIELD],[DefaultValue],[0])
DBSETPROP([lvFrmPartFrmSumEdit.FrmPartFrmSumVATRate],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvFrmPartFrmSumEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvFrmPartFrmSumEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvFrmPartFrmSumEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmPartFrmSumEdit],[VIEW],[COMMENT],[LV FRM: редактирование суммого содержания документа (таблица FrmPartFrmSum)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: сумма документа (содеращего товарные позиции)/*
PROCEDURE lvFrmTvrSumFrm
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

CREATE SQL VIEW lvFrmTvrSumFrm REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmSum = CAST(ISNULL(SUM(CASE WHEN FrmType.FrmTypeDirection = 2 ;
	                            THEN ROUND(FrmPartTvr.TvrPrcBuy*FrmPartTvr.TvrQnt,2) ;
	                            ELSE ROUND(FrmPartTvr.TvrPrcSale*FrmPartTvr.TvrQnt,2) END),0) AS money), ;
	FrmVAT = CAST(ISNULL(SUM(CASE WHEN FrmType.FrmTypeDirection = 2 ;
	                            THEN ROUND(FrmPartTvr.TvrPrcBuy*FrmPartTvr.TvrQnt,2) ;
	                            ELSE ROUND(FrmPartTvr.TvrPrcSale*FrmPartTvr.TvrQnt,2) END * ;
	                            (FrmPartTvr.TvrVATRate/(100+FrmPartTvr.TvrVATRate))),0) AS money) ;
FROM FrmPartTvr ;
INNER JOIN Form ON Form.FrmID = FrmPartTvr.FrmID ;
INNER JOIN FrmType ON FrmType.FrmTypeID = Form.FrmTypeID ;
WHERE FrmPartTvr.FrmID = ?_PARAM
**TvrVATRate
***
DBSETPROP([lvFrmTvrSumFrm],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTvrSumFrm],[VIEW],[COMMENT],[LV FRM: сумма документа (содержащего товарные позиции)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: сумма оплат по документу (содеращего товарные позиции)/*
PROCEDURE lvFrmTvrSumPay
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
*!*	CREATE SQL VIEW lvFrmTvrSumPay REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
*!*	SELECT ;
*!*		CAST(ISNULL(SUM(FrmPartFrmSum.FrmPartFrmSum),0) AS money) AS FrmSumPay ;
*!*	FROM FrmPartFrm ;
*!*	INNER JOIN FrmPartFrmSum ON FrmPartFrmSum.FrmPartFrmID = FrmPartFrm.FrmPartFrmID ;
*!*	WHERE FrmPartFrm.CntFrmID = ?_PARAM


CREATE SQL VIEW lvFrmTvrSumPay REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CAST(ISNULL(SUM(FrmPartFrm.CntFrmIncludeSum),0) AS money) AS FrmSumPay, ;
	CAST(ISNULL(SUM(FrmPartFrm.CntFrmIncludeSumVAT),0) AS money) AS FrmSumVAT ;
FROM FrmPartFrm ;
WHERE FrmPartFrm.CntFrmID = ?_PARAM
*** CntFrmIncludeSum CntFrmIncludeSumVAT
DBSETPROP([lvFrmTvrSumPay],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTvrSumPay],[VIEW],[COMMENT],[LV FRM: сумма оплат по документу (содеращего товарные позиции)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: информация о документах отображаемых на форме/*
PROCEDURE lvFrmTypeInfoByScrFrm
***
CREATE SQL VIEW lvFrmTypeInfoByScrFrm REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmType.FrmTypeID, ;
	FrmType.FrmTypeNM, ;
	FrmType.FrmTypeAbbr, ;
	FrmType.FrmTypeNote, ;
	FrmType.FrmTypeDirection, ;
	FrmType.FrmTypeIsContainTvr, ;
	FrmType.FrmTypeIsContainFrm, ;
	FrmType.PointEmiRoleNM, ;
	FrmType.PointEmiSprID, ;
	FrmType.PointIspRoleNM, ;
	FrmType.PointIspSprId, ;
	FrmType.DevRoleNM, ;
	FrmType.DevSprId, ;
	FrmType.ExecEmiRoleNM, ;
	FrmType.ExecEmiSprID, ;
	FrmType.ExecIspRoleNM, ;
	FrmType.ExecIspSprID, ;
	FrmType.ContrRoleNM, ;
	FrmType.ContrSprID, ;
	FrmType.PointEmiAccountSprID, ;
	FrmType.PointIspAccountSprID ;
FROM FrmType ;
INNER JOIN ScrFrmViewObj ON FrmType.FrmTypeID = ScrFrmViewObj.FrmTypeID ;
WHERE ScrFrmViewObj.ScrFrmID = ?_PARAM
***
DBSETPROP([lvFrmTypeInfoByScrFrm],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTypeInfoByScrFrm],[VIEW],[COMMENT],[LV FRM: информация о документах отображаемых на форме.])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV FRM: информация о конкретном типе документа/*
PROCEDURE lvFrmTypeInfo
***
CREATE SQL VIEW lvFrmTypeInfo REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmType.FrmTypeID, ;
	FrmType.FrmTypeNM, ;
	FrmType.FrmTypeAbbr, ;
	FrmType.FrmTypeNote, ;
	FrmType.FrmTypeDirection, ;
	FrmType.FrmTypeIsContainTvr, ;
	FrmType.FrmTypeIsContainFrm, ;
	FrmType.PointEmiRoleNM, ;
	FrmType.PointEmiSprID, ;
	PointEmiSpr.SprDBObjectNM AS PointEmiSprDBObjNM, ;
	FrmType.PointIspRoleNM, ;
	FrmType.PointIspSprID, ;
	PointIspSpr.SprDBObjectNM AS PointIspSprDBObjNM, ;
	FrmType.DevRoleNM, ;
	FrmType.DevSprID, ;
	DevSpr.SprDBObjectNM AS DevSprDBObjNM, ;
	FrmType.ExecEmiRoleNM, ;
	FrmType.ExecEmiSprID, ;
	ExecEmiSpr.SprDBObjectNM AS ExecEmiSprDBObjNM, ;
	FrmType.ExecIspRoleNM, ;
	FrmType.ExecIspSprID, ;
	ExecIspSpr.SprDBObjectNM AS ExecIspSprDBObjNM, ;
	FrmType.ContrRoleNM, ;
	FrmType.ContrSprID, ;
	ContrSpr.SprDBObjectNM AS ContrSprDBObjNM, ;
	FrmType.PointEmiAccountSprID, ;
	PointEmiAccountSpr.SprDBObjectNM AS PointEmiAccountSprDBObjNM, ;
	FrmType.PointIspAccountSprID, ;
	PointIspAccountSpr.SprDBObjectNM AS  PointIspAccountSprDBObjNM, ;
	FrmType.RptID ;
FROM FrmType ;
LEFT JOIN Sprav PointEmiSpr ON PointEmiSpr.SprID = FrmType.PointEmiSprID ;
LEFT JOIN Sprav PointIspSpr ON PointIspSpr.SprID = FrmType.PointIspSprID ;
LEFT JOIN Sprav DevSpr ON DevSpr.SprID = FrmType.DevSprID ;
LEFT JOIN Sprav ExecEmiSpr ON ExecEmiSpr.SprID = FrmType.ExecEmiSprID ;
LEFT JOIN Sprav ExecIspSpr ON ExecIspSpr.SprID = FrmType.ExecIspSprID ;
LEFT JOIN Sprav ContrSpr ON ContrSpr.SprID = FrmType.ContrSprID ;
LEFT JOIN Sprav PointEmiAccountSpr ON PointEmiAccountSpr.SprID = FrmType.PointEmiAccountSprID ;
LEFT JOIN Sprav PointIspAccountSpr ON PointIspAccountSpr.SprID = FrmType.PointIspAccountSprID ;
WHERE FrmType.FrmTypeID = ?_PARAM
***
DBSETPROP([lvFrmTypeInfo],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTypeInfo],[VIEW],[COMMENT],[LV FRM: информация о конкретном типе документа])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV FRM: информация об объекте для редактирования для конкретного типа документа/*
PROCEDURE lvFrmTypeObjDescInfo
***
CREATE SQL VIEW lvFrmTypeObjDescInfo REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmType.FrmTypeEditObjDesc ;
FROM FrmType ;
WHERE FrmType.FrmTypeID = ?_PARAM
***
DBSETPROP([lvFrmTypeObjDescInfo],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTypeObjDescInfo],[VIEW],[COMMENT],[LV FRM: информация об объекте для редактирования для конкретного типа документа])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV FRM: информация о типе конкретного документа/*
PROCEDURE lvFrmTypeInfoByFrm
***
CREATE SQL VIEW lvFrmTypeInfoByFrm REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmType.FrmTypeID, ;
	FrmType.FrmTypeNM, ;
	FrmType.FrmTypeAbbr, ;
	FrmType.FrmTypeNote, ;
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
	FrmType.ContainExpDate, ;
	FrmType.ContainPriceBuyLast, ;
	FrmType.ContainPriceBuy, ;
	FrmType.ContainPriceSale, ;
	FrmType.ContainPrcMargin, ;
	FrmType.ContainVatRate, ;
	FrmType.ContainStockTvr, ;
	FrmType.RptID, ;
	Form.FrmPrcTypeID, ;
	OUID = CASE WHEN FrmType.FrmTypeDirection=2 THEN Form.PointIspOUID ELSE Form.PointEmiOUID END ;
FROM Form ;
LEFT JOIN FrmType ON FrmType.FrmTypeID = Form.FrmTypeID ;
WHERE Form.FrmID = ?_PARAM
***
DBSETPROP([lvFrmTypeInfoByFrm],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTypeInfoByFrm],[VIEW],[COMMENT],[LV FRM: информация о типе конкретного документа.])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV FRM: информация об объекте для редактирования для конкретного документа/*
PROCEDURE lvFrmTypeObjDescInfoByFrm
***
CREATE SQL VIEW lvFrmTypeObjDescInfoByFrm REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmType.FrmTypeEditObjDesc ;
FROM Form ;
INNER JOIN FrmType ON Form.FrmTypeID = FrmType.FrmTypeID ;
WHERE Form.FrmID = ?_PARAM
***
DBSETPROP([lvFrmTypeObjDescInfoByFrm],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTypeObjDescInfoByFrm],[VIEW],[COMMENT],[LV FRM: информация об объекте для редактирования для конкретного документа])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV FRM: список типов документов для экранной формы/*
PROCEDURE lvFrmTypeListByScrFrm
***
CREATE SQL VIEW lvFrmTypeListByScrFrm REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmType.FrmTypeID, ;
	FrmType.FrmTypeNM ;
FROM FrmType ;
INNER JOIN ScrFrmViewObj ON ScrFrmViewObj.FrmTypeID = FrmType.FrmTypeID ;
WHERE ScrFrmViewObj.ScrFrmID = ?_PARAM
***
DBSETPROP([lvFrmTypeListByScrFrm],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTypeListByScrFrm],[VIEW],[COMMENT],[LV FRM: список типов документов для экранной формы])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV FRM: список всех типов документов/*
PROCEDURE lvFrmTypeList
***
CREATE SQL VIEW lvFrmTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmType.FrmTypeID, ;
	FrmType.FrmTypeNM ;
FROM FrmType ;
ORDER BY FrmType.FrmTypeNM
***
DBSETPROP([lvFrmTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTypeList],[VIEW],[COMMENT],[LV FRM: список всех типов документов.])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV FRM: список статусов документов/*
PROCEDURE lvFrmStatusList
***
CREATE SQL VIEW lvFrmStatusList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmStatID, ;
	FrmStatNM, ;
	CAST(CASE WHEN NOT ( ;
		SELECT ;
			UserGrant.ObjectID ;
		FROM UserGrant ;
		INNER JOIN ObjectType ON ObjectType.ObjectTypeID = UserGrant.ObjectTypeID AND UPPER(ObjectType.TableNM) = 'FRMSTATUS' ;
		WHERE ;
			UserGrant.ObjectID = FrmStatus.FrmStatID AND ;
			UserGrant.UserID = ?_PARAM ;
		GROUP BY UserGrant.ObjectID) IS NULL THEN 1 ELSE 0 END AS bit) AS IsEnabled ;
FROM FrmStatus ;
ORDER BY FrmStatOrder
***
DBSETPROP([lvFrmStatusList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmStatusList],[VIEW],[COMMENT],[LV FRM: список статусов документов.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: информация о статусе документа (по идентификатору статуса)/*
PROCEDURE lvFrmStatusInfoByID
***
CREATE SQL VIEW lvFrmStatusInfoByID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmStatus.FrmStatNM, ;
	FrmStatus.FrmStatIsInvAcc, ;
	FrmStatus.FrmStatIsCostAcc ;
FROM FrmStatus ;
WHERE FrmStatus.FrmStatID = ?_PARAM
***
DBSETPROP([lvFrmStatusInfoByID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmStatusInfoByID],[VIEW],[COMMENT],[LV FRM: информация о статусе документа (по идентификатору статуса)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: информация о статусе документа (по идентификатору документа)/*
PROCEDURE lvFrmStatusInfoByFrmID
***
CREATE SQL VIEW lvFrmStatusInfoByFrmID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmStatus.FrmStatNM, ;
	FrmStatus.FrmStatIsInvAcc, ;
	FrmStatus.FrmStatIsCostAcc ;
FROM Form ;
INNER JOIN FrmStatus ON FrmStatus.FrmStatID = Form.FrmStatusID ;
WHERE Form.FrmID = ?_PARAM
***
DBSETPROP([lvFrmStatusInfoByFrmID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmStatusInfoByFrmID],[VIEW],[COMMENT],[LV FRM: информация о статусе документа (по идентификатору документа)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: список алгоритмов деления сумм включаемых документов/*
PROCEDURE lvFrmSumSplitProcList
***
CREATE SQL VIEW lvFrmSumSplitProcList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmSumSplitProcID AS ID, ;
	FrmSumSplitProcNM AS NM ;
FROM FrmSumSplitProc
***
DBSETPROP([lvFrmSumSplitProcList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmSumSplitProcList],[VIEW],[COMMENT],[LV FRM: список алгоритмов деления сумм включаемых документов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: алгоритм деления сумм включаемых документов/*
PROCEDURE lvFrmSumSplitProc
***
CREATE SQL VIEW lvFrmSumSplitProc REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmSumSplitProcID, ;
	FrmSumSplitProcNM, ;
	ProcedureNM ;
FROM FrmSumSplitProc ;
WHERE FrmSumSplitProcID = ?_PARAM
***
DBSETPROP([lvFrmSumSplitProc],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmSumSplitProc],[VIEW],[COMMENT],[LV FRM: алгоритм деления сумм включаемых документов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: список сумм/ставок НДС по суммовой позиции/*
PROCEDURE lvFrmPartFrmSumView
***
CREATE SQL VIEW lvFrmPartFrmSumView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPartFrmSum.FrmPartFrmSumVatRate, ;
	FrmPartFrmSum.FrmPartFrmSum, ;
	ROUND(FrmPartFrmSum.FrmPartFrmSum*FrmPartFrmSum.FrmPartFrmSumVatRate/(100+FrmPartFrmSum.FrmPartFrmSumVatRate),2) AS FrmPartFrmSumVatSum ;
FROM FrmPartFrmSum;
WHERE FrmPartFrmSum.FrmPartFrmID = ?_PARAM
***
DBSETPROP([lvFrmPartFrmSumView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmPartFrmSumView],[VIEW],[COMMENT],[LV FRM: список сумм/ставок НДС по суммовой позиции])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: информация о нашем рассчётном счёте/*
PROCEDURE lvOwnSAccountByFrm
***
CREATE SQL VIEW lvOwnSAccountByFrm REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	OwnSAcc = CASE WHEN FrmType.FrmTypeDirection=2 THEN IspSAccount.CltSAcc ELSE EmiSAccount.CltSAcc END ;
FROM Form ;
INNER JOIN FrmType ON FrmType.FrmTypeID = Form.FrmTypeID ;
LEFT JOIN CltSAccount EmiSAccount ON EmiSAccount.CltSAccID = Form.PointEmiCltSAccID ;
LEFT JOIN CltSAccount IspSAccount ON IspSAccount.CltSAccID = Form.PointIspCltSAccID ;
WHERE Form.FrmID = ?_PARAM
***
DBSETPROP([lvOwnSAccountByFrm],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOwnSAccountByFrm],[VIEW],[COMMENT],[LV FRM: информация о нашем рассчётном счёте])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: список типов документов которые можно создать на основе текущего документа/*
PROCEDURE lvFrmTypeListCopyAsByFrm
***
CREATE SQL VIEW lvFrmTypeListCopyAsByFrm REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmTypeTo.FrmTypeID, ;
	FrmTypeTo.FrmTypeNM, ;
	FrmTypeCopyOper.CopyOperProcType, ;
	FrmTypeCopyOper.CopyOperProcNM, ;
	default_ = CASE WHEN FrmTypeTo.FrmTypeID = FormFrom.FrmTypeID THEN 1 ELSE 0 END ;
FROM Form FormFrom ;
INNER JOIN FrmTypeCopyOper ON FrmTypeCopyOper.FromFrmTypeID = FormFrom.FrmTypeID ;
INNER JOIN FrmType FrmTypeTo ON FrmTypeTo.FrmTypeID = FrmTypeCopyOper.ToFrmTypeID ;
WHERE FormFrom.FrmID = ?_PARAM ;
ORDER BY 5 DESC, 2 ASC
***
DBSETPROP([lvFrmTypeListCopyAsByFrm],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTypeListCopyAsByFrm],[VIEW],[COMMENT],[LV FRM: список типов документов которые можно создать на основе текущего документа])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV FRM: список типов документов которые можно наследовать на основе текущего (создание документа с ссылкой на родителя)/*
PROCEDURE lvFrmTypeListInheritByFrm
***
CREATE SQL VIEW lvFrmTypeListInheritByFrm REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmTypeTo.FrmTypeID, ;
	FrmTypeTo.FrmTypeNM, ;
	FrmTypeCopyOper.CopyOperProcType, ;
	FrmTypeCopyOper.CopyOperProcNM, ;
	CAST(0 AS bit) AS default_ ;
FROM Form FormFrom ;
INNER JOIN FrmTypeCopyOper ON FrmTypeCopyOper.FromFrmTypeID = FormFrom.FrmTypeID ;
INNER JOIN FrmType FrmTypeFrom ON FrmTypeFrom.FrmTypeID = FormFrom.FrmTypeID ;
INNER JOIN FrmType FrmTypeTo   ON FrmTypeTo.FrmTypeID   = FrmTypeCopyOper.ToFrmTypeID ;
WHERE FormFrom.FrmID = ?_PARAM AND FrmTypeFrom.FrmTypeID <> FrmTypeTo.FrmTypeID ;
ORDER BY 5 DESC, 2 ASC
***
DBSETPROP([lvFrmTypeListInheritByFrm],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTypeListInheritByFrm],[VIEW],[COMMENT],[LV FRM: список типов документов которые можно наследовать на основе текущего (создание документа с ссылкой на родителя)])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV FRM: список документов которые могут быть родителями для текущего документа/*
PROCEDURE lvFrmParListByFrmType
***
CREATE SQL VIEW lvFrmParListByFrmType REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Form.FrmID AS ID, ;
	NM = FrmType.FrmTypeAbbr + ' №' + Form.FrmNum + ' от ' + CONVERT(varchar(12),Form.FrmDate,104) ;
FROM Form ;
INNER JOIN FrmType ON FrmType.FrmTypeID = Form.FrmTypeID ;
WHERE Form.FrmTypeID IN ;
   (SELECT ;
		FrmTypeCopyOper.FromFrmTypeID ;
	FROM FrmTypeCopyOper ;
	WHERE FrmTypeCopyOper.ToFrmTypeID = ?_PARAM AND FrmTypeCopyOper.FromFrmTypeID <> FrmTypeCopyOper.ToFrmTypeID)
***
DBSETPROP([lvFrmParListByFrmType],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmParListByFrmType],[VIEW],[COMMENT],[LV FRM: список документов которые могут быть родителями для текущего документа])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV FRM: список приходных накладных/*
PROCEDURE lvNaklInList
***
CREATE SQL VIEW lvNaklInList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Form.FrmID AS ID, ;
	FrmType.FrmTypeAbbr + ' №' + Form.FrmNum + ' от ' + CONVERT(varchar(12),Form.FrmDate,104) AS NM, ;
	OrgUnit.OuNm ;
FROM Form ;
INNER JOIN FrmType ON Form.FrmTypeID = FrmType.FrmTypeID ;
INNER JOIN OrgUnit ON  OrgUnit.OuId = Form.PointIspOuId ;
WHERE FrmType.FrmTypeID IN (1,21) ;
ORDER BY Form.FrmDate, OrgUnit.OuNm
***
DBSETPROP([lvNaklInList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvNaklInList],[VIEW],[COMMENT],[LV FRM: список приходных накладных])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV PD: автонумераторы/*
PROCEDURE lvFrmAutoNumView
***
CREATE SQL VIEW lvFrmAutoNumView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmTypeAutoNum.FrmTypeAutoNumID, ;
	FrmTypeAutoNum.AutoNumIsEnabled, ;
	FrmTypeAutoNum.AutoNumMask, ;
	OrgUnit.OUNM, ;
	FrmType.FrmTypeNM ;
FROM FrmTypeAutoNum ;
LEFT JOIN FrmType ON FrmType.FrmTypeID = FrmTypeAutoNum.FrmTypeID ;
LEFT JOIN OrgUnit ON OrgUnit.OUID = FrmTypeAutoNum.OUID ;
ORDER BY  FrmTypeAutoNum.FrmTypeAutoNumID
***
DBSETPROP([lvFrmAutoNumView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmAutoNumView],[VIEW],[COMMENT],[LV PD: автонумераторы])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV PD: автонумераторы/*
PROCEDURE lvFrmAutoNumViewRepl
***
CREATE SQL VIEW lvFrmAutoNumViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmTypeAutoNum.FrmTypeAutoNumID, ;
	FrmTypeAutoNum.AutoNumIsEnabled, ;
	FrmTypeAutoNum.AutoNumMask, ;
	OrgUnit.OUNM, ;
	FrmType.FrmTypeNM ;
FROM FrmTypeAutoNum ;
LEFT JOIN FrmType ON FrmType.FrmTypeID = FrmTypeAutoNum.FrmTypeID ;
LEFT JOIN OrgUnit ON OrgUnit.OUID = FrmTypeAutoNum.OUID ;
WHERE FrmTypeAutoNum.FrmTypeAutoNumid = ?_PARAM
***
DBSETPROP([lvFrmAutoNumViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmAutoNumViewRepl],[VIEW],[COMMENT],[LV PD: обновление автонумераторы])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV PD: редактирование автонумераторы/*
PROCEDURE lvFrmAutoNumEdit
***
CREATE SQL VIEW lvFrmAutoNumEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmTypeAutoNum.FrmTypeAutoNumID, ;
	FrmTypeAutoNum.FrmTypeID, ;
	FrmTypeAutoNum.OUID, ;
	FrmTypeAutoNum.AutoNumIsEnabled, ;
	FrmTypeAutoNum.AutoNumMask, ;
	FrmTypeAutoNum.FrmTypeIDIsConst, ;
	FrmTypeAutoNum.FrmTypeIDConst, ;
	FrmTypeAutoNum.OwnCltIDIsConst, ;
	FrmTypeAutoNum.OwnCltIDConst, ;
	FrmTypeAutoNum.OUIDIsConst, ;
	FrmTypeAutoNum.OUIDConst ;
FROM FrmTypeAutoNum;
WHERE FrmTypeAutoNum.FrmTypeAutoNumid = ?_PARAM
***
DBSETPROP([lvFrmAutoNumEdit.FrmTypeAutoNumID],[FIELD],[KeyField],.T.)
DBSETPROP([lvFrmAutoNumEdit.FrmTypeAutoNumID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvFrmAutoNumEdit.FrmTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmAutoNumEdit.OUID],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmAutoNumEdit.AutoNumIsEnabled],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmAutoNumEdit.AutoNumMask],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmAutoNumEdit.FrmTypeIDIsConst],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmAutoNumEdit.FrmTypeIDConst],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmAutoNumEdit.OwnCltIDIsConst],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmAutoNumEdit.OwnCltIDConst],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmAutoNumEdit.OUIDIsConst],[FIELD],[Updatable],.T.)
DBSETPROP([lvFrmAutoNumEdit.OUIDConst],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvFrmAutoNumEdit.AutoNumIsEnabled],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvFrmAutoNumEdit.AutoNumMask],[FIELD],[DefaultValue],[""])
DBSETPROP([lvFrmAutoNumEdit.FrmTypeIDIsConst],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvFrmAutoNumEdit.OwnCltIDIsConst],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvFrmAutoNumEdit.OUIDIsConst],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvFrmAutoNumEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvFrmAutoNumEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvFrmAutoNumEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmAutoNumEdit],[VIEW],[COMMENT],[LV PD: редактирование автонумераторы])
***
ENDPROC
*------------------------------------------------------------------------------

*/Просмотр истории  документов/*
PROCEDURE lvFrmActionView
***
CREATE SQL VIEW lvFrmActionView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT Frmaction.ActID, Frmstatus.FrmStatNM AS action,;
       Frmaction.Stamp_ AS frmdateacc,;
       Frmaction.FrmActionOperationNM, ;
       Appuser.UserLogin AS usernm, ;
       Frmaction.FrmActionOperationState AS state ;
   FROM  Frmaction  ;
   LEFT OUTER JOIN dbo.FrmStatus Frmstatus  ON  Frmaction.FrmStatusId = Frmstatus.FrmStatID  ;
   LEFT OUTER JOIN dbo.AppUser Appuser  ON  Frmaction.User_ = Appuser.UserId ;
   WHERE  Frmaction.FrmID = ( ?_PARAM )

***
ENDPROC
*------------------------------------------------------------------------------
*/Просмотр заданий на акцепт документов/*
PROCEDURE lvFrmActionView_
***
CREATE SQL VIEW lvFrmActionView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmAction.FrmID, ;
	FrmType.FrmTypeAbbr+' '+Form.FrmNum AS FrmNum, ;
	Form.FrmDateAcc, ;
	FrmAction.ActID, ;
	FrmAction.FrmActionOperationNM, ;
	FrmAction.FrmActionOperationState, ;
	FrmAction.FrmActionErrorMsg, ;
	CASE ;
		WHEN FrmAction.FrmActionOperationState=1 THEN 'Постановка в очередь' ;
		WHEN FrmAction.FrmActionOperationState=2 THEN 'Обработка' ;
		WHEN FrmAction.FrmActionOperationState=3 THEN 'Выполнено' ;
		WHEN FrmAction.FrmActionOperationState IN (4,5) THEN 'Ошибка '+ISNULL(FrmAction.FrmActionErrorMsg, '') ;
		ELSE '???' ;
	END AS State, ;
	FrmAction.Stamp_ ;
FROM FrmAction ;
INNER JOIN Form ON Form.FrmID = FrmAction.FrmID ;
INNER JOIN FrmType ON FrmType.FrmTypeID = Form.FrmTypeID ;
WHERE FrmAction.Stamp_ >= DATEADD(day,-1,GETDATE()) AND NOT FrmAction.FrmActionOperationNM IS NULL AND FrmAction.User_ = ?_PARAM ;
ORDER BY ;
	FrmAction.ActID
***
ENDPROC
*------------------------------------------------------------------------------

*/LV PD: Просмотр заголовка документа/*
PROCEDURE lvFrmView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvFrmView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Form.FrmID, ;
	Form.FrmParID, ;
	Form.FrmTypeID, ;
	Form.FrmDate, ;
	Form.FrmDateAcc, ;
	Form.FrmNum, ;
	Form.FrmNote, ;
	Form.FrmReason, ;
	Form.FrmStatusID, ;
	Form.FrmIsPayed, ;
	Form.PointEmiOuID, ;
	Form.PointEmiCltID, ;
	Form.PointIspOuID, ;
	Form.PointIspCltID, ;
	Form.DevCltID, ;
	Form.ExecEmiCltID, ;
	Form.ExecIspCltID, ;
	Form.ContrCltID, ;
	Form.PointEmiCltSAccID, ;
	Form.PointIspCltSAccID, ;
	Form.FrmCurTypeID, ;
	Form.FrmPrcTypeID, ;
	Form.FrmAttribute, ;
	Form.OperID, ;
	Form.Stamp_, ;
	Form.User_ ;
FROM Form ;
WHERE FrmID = ?_PARAM
***
DBSETPROP([lvFrmView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmView],[VIEW],[COMMENT],[LV PD: обновление автонумераторы])
***
ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************

*/LV PD: просмотр ног документа/*
PROCEDURE lvFrmPartTvrViewExt
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvFrmPartTvrViewExt REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPartTvr.TvrId, ;
	Tovar.TvrNM, ;
	FrmPartTvr.MsuId, ;
	FrmPartTvr.TvrQnt, ;
	FrmPartTvr.TvrQntNetto, ;
	FrmPartTvr.TvrPrcBuy, ;
	FrmPartTvr.TvrPrcSale, ;
	FrmPartTvr.TvrVATRate, ;
	FrmPartTvr.TvrExpiredDate, ;
	FrmPartTvr.TvrIDCalc, ;
	FrmPartTvr.TvrAttr ;
FROM FrmPartTvr ;
INNER JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrID ;
WHERE FrmID = ?_PARAM
***
DBSETPROP([lvFrmPartTvrViewExt],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmPartTvrViewExt],[VIEW],[COMMENT],[LV PD: просмотр ног документа])
***
ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************


*/LV PD: просмотр документов, которые можно включить в другой/*
PROCEDURE lvFrmTypeListIncl
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvFrmTypeListIncl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT Frmtype.frmtypeid, Frmtype.frmtypenm, Frmtype.frmtypepaylistinc,;
  Frmtype.frmtypeshortnm, Frmtype.frmtypeabbr, Frmtype.frmtypenote,;
  Frmtype.frmtypeeditobjdesc, Frmtype.frmtypedirection,;
  Frmtype.frmtypeiscontaintvr, Frmtype.frmtypeiscontainfrm,;
  Frmtype.pointemirolenm, Frmtype.pointemisprid, Frmtype.pointisprolenm,;
  Frmtype.pointispsprid, Frmtype.devrolenm, Frmtype.devsprid,;
  Frmtype.execemirolenm, Frmtype.execemisprid, Frmtype.execisprolenm,;
  Frmtype.execispsprid, Frmtype.contrrolenm, Frmtype.contrsprid,;
  Frmtype.pointemiaccountsprid, Frmtype.pointispaccountsprid,;
  Frmtype.containpricebuy, Frmtype.containpricesale, Frmtype.rptid,;
  Frmtype.stocktranstypeid, Frmtype.frmtypeattribute, Frmtype.stamp_,;
  Frmtype.user_;
 FROM frmtype;
 WHERE  Frmtype.frmtypeid <> (?_PARAM);
 ORDER BY Frmtype.frmtypenm
***
DBSETPROP([lvFrmTypeListIncl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmTypeListIncl],[VIEW],[COMMENT],[LV PD: просмотр документов, которые можно включить в другой])
***
ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************
*/LV PD: просмотр документов, которые включены в этот/*
PROCEDURE lvFrmTypeListIncl
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvFrmIncl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT Frmtypepay.frmtypepayid, Frmtypepay.frmtypeid, Frmtypepay.includefrmtypeid, ;
       Frmtypepay.isdefault, Frmtypepay.user_, Frmtypepay.stamp_, Frmtype.frmtypenm ;
       FROM  frmtypepay  ;
 INNER JOIN frmtype  ON  Frmtypepay.includefrmtypeid = Frmtype.frmtypeid;
 WHERE  Frmtypepay.frmtypeid = (?_PARAM)

***
DBSETPROP([lvFrmIncl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmIncl],[VIEW],[COMMENT],[LV PD: просмотр документов, которые включены в этот])
***
ENDPROC
*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************
