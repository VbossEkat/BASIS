#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 14:41 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Ресторан] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Ресторан]
***
lvCltWaiterList()
lvCltRSTList()
lvOuTableList()
lvWaiterTableView()
lvOrderView()
lvOrderTvrView()
lvOrderTvrViewRepl()
lvSPrintView()
lvFrmSumView()
lvMgrView()
lvDiscList()
lvDiscType()
lvCancelReasonList()
lvTvrCncRsnEdit()
lvModList()
lvOrderTvrEdit()
lvcashierByCltView()
lvCstFunkByUserView()
lvParOUList()
lvCancelPrintView()
lvDiscCardByNo()
lvDiscountList()
lvShiftSumView()
**
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV RST: Клиенты - официанты/*
PROCEDURE lvCltWaiterList
***
CREATE SQL VIEW lvCltWaiterList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltID AS ID, ;
	CltNM AS NM ;
FROM Client ;
WHERE dbo.BITTEST(Client.CltRole,3) = 1
***
DBSETPROP([lvCltWaiterList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltWaiterList],[VIEW],[COMMENT],[LV RST: Клиенты - официанты])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RST: Клиенты ресторана*
PROCEDURE lvCltRSTList
***
CREATE SQL VIEW lvCltRSTList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltID AS ID, ;
	CltNM AS NM ;
 FROM Client ;
 WHERE dbo.BITTEST(Client.CltRole,4) = 1 OR ;
 		CltID IN (SELECT DISTINCT Coupon.CltID FROM Coupon) ;
 ORDER BY CltNM
 
***
DBSETPROP([lvCltRSTList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltRSTList],[VIEW],[COMMENT],[LV RST: Клиенты ресторана])
***
ENDPROC

*------------------------------------------------------------------------------

*/LV RST: Список столов/*
PROCEDURE lvOuTableList
***
CREATE SQL VIEW lvOuTableList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	OUID AS ID, ;
	OUNM AS NM ;
FROM OrgUnit ;
WHERE ;
	OrgUnit.OUTypeID = ?_PARAM1 AND ;
	OrgUnit.OUParID = ?_PARAM2
***
DBSETPROP([lvOuTableList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOuTableList],[VIEW],[COMMENT],[LV RST: Список столов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RST: Список столов текущего официанта*
PROCEDURE lvWaiterTableView
***
CREATE SQL VIEW lvWaiterTableView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	MAX(Form.FrmDate) AS FrmDate, ;
	Form.PointEmiOUID, ;
	ISNULL(OrgUnit.OUNM,CAST('' AS varchar(40))) AS TableNM ;
FROM Form ;
LEFT JOIN OrgUnit ON OrgUnit.OUID = Form.PointEmiOUID ;
WHERE Form.FrmStatusID < 3 ;
		AND dbo.BITTEST(Form.FrmAttribute,30) = 0 ;
		AND Form.FrmTypeId = ?_PARAM1 ;
		AND Form.PointEmiCltID = ?_PARAM2 ;
GROUP BY PointEmiOUID,OrgUnit.OUNM
***
DBSETPROP([lvWaiterTableView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvWaiterTableView],[VIEW],[COMMENT],[LV RST: Список столов текущего официанта])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RST: Список заказов по данному столу текущего официанта*
PROCEDURE lvOrderView
***
#DEFINE    pcvCONNECTIONNAME    SQLBASISCONNECTION
CREATE SQL VIEW lvOrderView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Form.FrmID, ;
	Form.FrmTypeID, ;
	Form.FrmDate, ;
	Form.FrmNum, ;
	Form.FrmNote, ;
	Form.FrmStatusID AS StatusId, ;
	Form.FrmIsPayed, ;
	Form.ID_, ;
	Form.PointEmiOUID AS PEmiOUID, ;
	Form.PointEmiCltID AS PEmiCltID, ;
	Form.PointIspOUID AS PIspOUID, ;
	Form.PointIspCltID AS PIspCltID, ;
	ISNULL(PEmiClient.CltNm,CAST('' AS varchar(40))) AS WaiterNM, ;
	ISNULL(PIspClient.CltNm,CAST('' AS varchar(40))) AS ClientNM, ;
	ISNULL(PEmiOrgUnit.OUNm,CAST('' AS varchar(40))) AS TableNM, ;
	CAST(ISNULL(SUM(ROUND(FrmPartTvr.TvrPrcSale*FrmPartTvr.TvrQnt,2)),0) AS money) AS FrmSum, ;
	CAST(0 AS money) AS FrmVatSum ;
FROM Form ;
LEFT JOIN OrgUnit PEmiOrgUnit ON PEmiOrgUnit.OUID = Form.PointEmiOUID ;
LEFT JOIN Client PEmiClient ON PEmiClient.CltID = Form.PointEmiCltID ;
LEFT JOIN Client PIspClient ON PIspClient.CltID = Form.PointIspCltID ;
LEFT JOIN FrmPartTvr ON FrmPartTvr.FrmID = Form.FrmID ;
WHERE Form.FrmStatusID < 3 ;
        AND dbo.BITTEST(Form.FrmAttribute,30) = 0 ;
        AND dbo.BITTEST(FrmPartTvr.TvrAttr,4)=0 ;
		AND Form.PointEmiCltID = ?_PARAM1 ;
		AND Form.PointEmiOUID = ?_PARAM2 ;
		AND Form.FrmTypeId = ?_PARAM3 ;
GROUP BY ;
	Form.FrmID, ;
	Form.FrmTypeID, ;
	Form.FrmDate, ;
	Form.FrmNum, ;
	Form.FrmNote, ;
	Form.FrmStatusID, ;
	Form.FrmIsPayed, ;
	Form.ID_, ;
	Form.PointEmiOUID, ;
	Form.PointEmiCltID, ;
	Form.PointIspOUID, ;
	Form.PointIspCltID, ;
	PEmiClient.CltNm, ;
	PIspClient.CltNm, ;
	PEmiOrgUnit.OUNm ;
ORDER BY FrmNum
***
DBSETPROP([lvOrderView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOrderView],[VIEW],[COMMENT],[LV RST: Список заказов по данному столу текущего официанта])
***
ENDPROC 
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*/LV RST: просмотр содержания заказа (товарные позиции)/*
PROCEDURE lvOrderTvrView
***
#DEFINE    pcvCONNECTIONNAME    SQLBASISCONNECTION
CREATE SQL VIEW lvOrderTvrView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPartTvr.FrmPartTvrID, ;
	FrmPartTvr.FrmID, ;
	FrmPartTvr.TvrId, ;
	ISNULL(Tovar.TvrNM,'') AS TvrNM, ;
	FrmPartTvr.TvrQnt, ;
	FrmPartTvr.MsuId, ;
	FrmPartTvr.TvrQntNetto, ;
	FrmPartTvr.TvrAttr, ;
	FrmPartTvr.TvrPrcSale, ;
	ROUND(FrmPartTvr.TvrPrcSale*FrmPartTvr.TvrQnt,2) AS TvrSum, ;
	CAST(0 AS bit) AS mark, ;
    Tovar.TvrVatRate ;
FROM FrmPartTvr ;
LEFT JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrId ;
WHERE FrmPartTvr.FrmID = ?_PARAM AND dbo.BITTEST(FrmPartTvr.TvrAttr,4) = 0
***
DBSETPROP([lvOrderTvrView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOrderTvrView],[VIEW],[COMMENT],[LV RST: редактирование содержания заказа (товарные позиции)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RST: Обновление для lvOrderTvrView/*
PROCEDURE lvOrderTvrViewRepl
***
CREATE SQL VIEW lvOrderTvrViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPartTvr.FrmPartTvrID, ;
	FrmPartTvr.FrmID, ;
	FrmPartTvr.TvrId, ;
	ISNULL(Tovar.TvrNM,'') AS TvrNM, ;
	FrmPartTvr.TvrQnt, ;
	FrmPartTvr.MsuId, ;
	FrmPartTvr.TvrQntNetto, ;
	FrmPartTvr.TvrAttr, ;
	FrmPartTvr.TvrPrcSale, ;
	ROUND(FrmPartTvr.TvrPrcSale*FrmPartTvr.TvrQnt,2) AS TvrSum, ;
	CAST(0 AS bit) AS mark, ;
    Tovar.TvrVatRate ;
FROM FrmPartTvr ;
LEFT JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrId ;
WHERE FrmPartTvr.FrmPartTvrID = ?_PARAM
***
DBSETPROP([lvOrderTvrViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOrderTvrViewRepl],[VIEW],[COMMENT],[LV RST: Обновление для lvOrderTvrView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RST: Печать заказа на сервис-принтер*
PROCEDURE lvSPrintView
***
CREATE SQL VIEW lvSPrintView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPartTvr.FrmPartTvrID, ;
	FrmPartTvr.TvrID, ;
	FrmPartTvr.TvrQnt, ;
	FrmPartTvr.TvrPrcSale, ;
	Form.PointEmiCltID, ;
	Form.PointEmiOUID, ;
	ISNULL(Client.CltNm,CAST('' as varchar(40))) AS WaiterNM, ;
	ISNULL(OrgUnit.OUNm,CAST('' as varchar(40))) AS TableNM, ;
	ISNULL(Tovar.TvrNM,CAST('' as varchar(40))) AS TvrNM, ;
	ISNULL(Device.DeviceID,CAST(0 as integer)) AS DeviceID, ;
	ISNULL(Device.DeviceNM,CAST('' as varchar(40))) AS DeviceNM, ;
	ISNULL(Device.DeviceINI,CAST('' as varchar(40))) AS DeviceINI ;
FROM FrmPartTvr ;
LEFT JOIN Form ON Form.FrmID = FrmPartTvr.FrmID ;
LEFT JOIN OrgUnit ON OrgUnit.OUID = Form.PointEmiOUID ;
LEFT JOIN Client ON Client.CltID = Form.PointEmiCltID ;
LEFT JOIN AccPrint ON AccPrint.TvrID = FrmPartTvr.TvrID ;
LEFT JOIN ActionRule ON ActionRule.ActionRuleID = AccPrint.ActionRuleID ;
LEFT JOIN Device ON Device.DeviceID = ActionRule.ActionRulePointIsp ;
LEFT JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrID ;
WHERE dbo.BITTEST(FrmPartTvr.TvrAttr,0) = 0 ;
	  AND dbo.BITTEST(FrmPartTvr.TvrAttr,4) = 0 ;
	  AND FrmPartTvr.FrmID = ?_PARAM1 ;
	  AND ActionRule.ActionRulePointEmi = ?_PARAM2 ;
ORDER BY FrmPartTvrID

***
DBSETPROP([lvSPrintView.DeviceINI],[Field],[DataType],[M])
***
DBSETPROP([lvSPrintView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvSPrintView],[VIEW],[COMMENT],[LV RST: Печать заказа на сервис-принтер])
***
ENDPROC 
*******************************************************************************************


*/LV RST: Сумма по данному заказу
PROCEDURE lvFrmSumView
***
        *!*        CREATE SQL VIEW lvFrmSumView REMOTE CONNECTION 'SQLBASISCONNECTION' SHARE AS ;
        *!*        SELECT ;
        *!*        	ISNULL(SUM(ROUND(FrmPartTvr.TvrPrcSale*FrmPartTvr.TvrQnt,2)),0) AS FrmSum ;
        *!*        FROM FrmPartTvr ;
        *!*        WHERE FrmPartTvr.FrmID = ?_PARAM ;
        *!*        		AND dbo.BITTEST(FrmPartTvr.TvrAttr,4) = 0 ;
        *!*        UNION ;
        *!*        SELECT  ;
        *!*            ISNULL(SUM(ROUND(FrmPartFrm.CntFrmIncludeSum,2)),0) AS FrmSum  ;
        *!*        FROM FrmPartFrm;
        *!*        WHERE FrmPartFrm.FrmID = ?_PARAM  

CREATE SQL VIEW lvFrmSumView REMOTE CONNECTION 'SQLBASISCONNECTION' SHARE AS ;
SELECT ;
    ISNULL(ROUND(FrmPartTvr.TvrPrcSale*FrmPartTvr.TvrQnt,2),0) AS FrmSum ;
FROM FrmPartTvr ;
WHERE FrmPartTvr.FrmID = ?_PARAM ;
        AND dbo.BITTEST(FrmPartTvr.TvrAttr,4) = 0 AND TvrId<>-1;
UNION ALL;
SELECT  ;
    ISNULL(ROUND(FrmPartFrm.CntFrmIncludeSum,2),0) AS FrmSum  ;
FROM FrmPartFrm;
WHERE FrmPartFrm.FrmID = ?_PARAM 

DBSETPROP([lvFrmSumView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFrmSumView],[VIEW],[COMMENT],[LV RST: Сумма по данному заказу с учетом имеющихся оплат (viewgenerationrst.prg)])
***
ENDPROC 
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************


*/LV RST: Список всех открытых заказов для менеджера*
PROCEDURE lvMgrView
***
CREATE SQL VIEW lvMgrView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Form.FrmID, ;
	Form.FrmNum, ;
	Form.PointEmiCltID, ;
	Form.PointEmiOUID, ;
	ISNULL(OrgUnit.OUNM,CAST('' as varchar(40))) AS TableNM, ;
	ISNULL(Client.CltNM,CAST('' as varchar(40))) AS ClientNM ;
FROM Form ;
LEFT JOIN OrgUnit ON OrgUnit.OUID = Form.PointEmiOUID ;
LEFT JOIN Client ON Client.CltID = Form.PointEmiCltID ;
WHERE Form.FrmStatusID < 3 ;
		AND dbo.BITTEST(Form.FrmAttribute,30) = 0 ;
		AND Form.FrmTypeId = ?_PARAM ;
		AND OrgUnit.OUParID = ?_PARAM_DOP ;
ORDER BY PointEmiCltID, PointEmiOUID, FrmNum

***
DBSETPROP([lvMgrView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvMgrView],[VIEW],[COMMENT],[LV RST: Список всех открытых заказов для менеджера])
***
ENDPROC 
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************


*/LV RST: Список скидок
PROCEDURE lvDiscList
***
CREATE SQL VIEW lvDiscList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DiscID AS ID, ;
	DiscNM AS NM ;
FROM Discount 
***
DBSETPROP([lvDiscList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscList],[VIEW],[COMMENT],[LV RST: Список скидок])
***
ENDPROC
*------------------------------------------------------------------------------
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************


*/LV RST: Список карточек с разными типами скидок/*
PROCEDURE lvDiscType
***
CREATE SQL VIEW lvDiscType REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Discrate, ;
	DisctypeID ;
FROM Discount ;
WHERE Discount.DiscID = ?_PARAM
***
DBSETPROP([lvDiscType],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscType],[VIEW],[COMMENT],[LV RST: Атрибуты скидки])
***
ENDPROC
*------------------------------------------------------------------------------
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************


*/LV RST: Список причин отказа
PROCEDURE lvCancelReasonList
***
CREATE SQL VIEW lvCancelReasonList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CancelReasonID AS ID, ;
	CancelReasonNM AS NM ;
FROM CancelReason 
***
DBSETPROP([lvCancelReasonList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCancelReasonList],[VIEW],[COMMENT],[LV RST: Список причин отказа])
***
ENDPROC
*------------------------------------------------------------------------------
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************


*/LV RST: редактирование привязок причин отказа к блюдам
PROCEDURE lvTvrCncRsnEdit
***
CREATE SQL VIEW lvTvrCncRsnEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPartTvrCncRsn.FrmPartTvrCncRsnID, ;
	FrmPartTvrCncRsn.CancelReasonID ;
FROM FrmPartTvrCncRsn ;
WHERE FrmPartTvrCncRsn.FrmPartTvrCncRsnID = ?_PARAM 
***
DBSETPROP([lvTvrCncRsnEdit.FrmPartTvrCncRsnID],[FIELD],[KeyField],.T.)
DBSETPROP([lvTvrCncRsnEdit.FrmPartTvrCncRsnID],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTvrCncRsnEdit.CancelReasonID],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTvrCncRsnEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvTvrCncRsnEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvTvrCncRsnEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrCncRsnEdit],[VIEW],[COMMENT],[LV RST: редактирование привязок причин отказа к блюдам])
***
ENDPROC
*------------------------------------------------------------------------------
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************


*/LV RST: Список модификаторов для данного блюда
PROCEDURE lvModList
***
CREATE SQL VIEW lvModList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPartTvr.TvrID AS ID, ;
	ISNULL(Tovar.TvrNM,CAST('' AS varchar(80))) AS NM, ;
	CAST(0 AS bit) AS mark ;
FROM FrmPartTvr ;
LEFT JOIN Form ON Form.FrmID = FrmPartTvr.FrmID ;
LEFT JOIN Accounting ON Form.FrmID = Accounting.AccFrmID ;
LEFT JOIN Tovar ON FrmPartTvr.TvrID = Tovar.TvrID ;
WHERE Accounting.AccTvrID = ?_PARAM ;
	  AND Tovar.TvrTypeID = 6
***
DBSETPROP([lvModList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvModList],[VIEW],[COMMENT],[LV RST: Список модификаторов для данного блюда])
***
ENDPROC
*------------------------------------------------------------------------------
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************


*/LV RST: редактирование содержания заказа (товарные позиции)/*
PROCEDURE lvOrderTvrEdit
***
CREATE SQL VIEW lvOrderTvrEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPartTvr.FrmPartTvrID, ;
	FrmPartTvr.FrmID, ;
	FrmPartTvr.TvrId, ;
	FrmPartTvr.MsuId, ;
	FrmPartTvr.TvrQnt, ;
	FrmPartTvr.TvrQntNetto, ;
	FrmPartTvr.TvrAttr, ;
	FrmPartTvr.TvrPrcBuy, ;
	FrmPartTvr.TvrPrcSale, ;
	FrmPartTvr.TvrVATRate, ;
	FrmPartTvr.TvrExpiredDate, ;
	FrmPartTvr.Stamp_, ;
	FrmPartTvr.User_ ;
FROM FrmPartTvr ;
WHERE FrmPartTvr.FrmPartTvrID = ?_PARAM
***
DBSETPROP([lvOrderTvrEdit.FrmPartTvrID],[FIELD],[KeyField],.T.)
DBSETPROP([lvOrderTvrEdit.FrmPartTvrID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvOrderTvrEdit.FrmID],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrderTvrEdit.TvrId],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrderTvrEdit.MsuId],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrderTvrEdit.TvrQnt],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrderTvrEdit.TvrQntNetto],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrderTvrEdit.TvrAttr],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrderTvrEdit.TvrPrcBuy],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrderTvrEdit.TvrPrcSale],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrderTvrEdit.TvrVATRate],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrderTvrEdit.TvrExpiredDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrderTvrEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrderTvrEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvOrderTvrEdit.TvrQnt],[FIELD],[DefaultValue],[0])
DBSETPROP([lvOrderTvrEdit.TvrQntNetto],[FIELD],[DefaultValue],[0])
DBSETPROP([lvOrderTvrEdit.TvrAttr],[FIELD],[DefaultValue],[0])
DBSETPROP([lvOrderTvrEdit.TvrPrcBuy],[FIELD],[DefaultValue],[0])
DBSETPROP([lvOrderTvrEdit.TvrPrcSale],[FIELD],[DefaultValue],[0])
DBSETPROP([lvOrderTvrEdit.TvrVATRate],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvOrderTvrEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvOrderTvrEdit],[VIEW],[WhereType],1) &&DB_KEY
***
DBSETPROP([lvOrderTvrEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOrderTvrEdit],[VIEW],[COMMENT],[LV RST: редактирование содержания заказа (товарные позиции)])
***
ENDPROC
*------------------------------------------------------------------------------



*/LV RST: Кассир по официанту
PROCEDURE lvcashierByCltView()
***
CREATE SQL VIEW lvcashierByCltView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CashierID, ;
	CltID, ;
	CashierIsActive ;
FROM Cashier ;
WHERE Cashier.CashierIsActive = 1 AND Cashier.CltID = ?_PARAM 
***
DBSETPROP([lvcashierByCltView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvcashierByCltView],[VIEW],[COMMENT],[LV RST: Кассир по официанту])
***
ENDPROC
*------------------------------------------------------------------------------
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************



*/LV RST: Проверка доступности функции для пользователя
PROCEDURE lvCstFunkByUserView()
***
CREATE SQL VIEW lvCstFunkByUserView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	UserID, ;
	ObjectID ;
FROM UserGrant ;
LEFT OUTER JOIN CustomFunc ON CustomFunc.cstfuncID = UserGrant.objectID ;
WHERE UserGrant.ObjectTypeID=3 AND UserGrant.UserID=?_PARAM1  AND CustomFunc.cstfuncmsg=?_PARAM2 
***
DBSETPROP([lvCstFunkByUserView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCstFunkByUserView],[VIEW],[COMMENT],[LV RST: Проверка доступности функции для пользователя])
***
ENDPROC
*------------------------------------------------------------------------------
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************



*/LV RST: Список подразделений-родителей, содержащих столы
PROCEDURE lvParOUList()
***
CREATE SQL VIEW lvParOUList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT DISTINCT ;
	OrgUnit.OUParID AS ID, ;
	ISNULL(OrgUnit1.OUNM,SPACE(40)) AS NM ;
FROM OrgUnit ;
LEFT OUTER JOIN OrgUnit OrgUnit1 ON OrgUnit1.OUID = OrgUnit.OUParID ;
WHERE OrgUnit.OUTypeID=4  
***
DBSETPROP([lvParOUList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvParOUList],[VIEW],[COMMENT],[LV RST: Список подразделений-родителей, содержащих столы])
***
ENDPROC
*------------------------------------------------------------------------------
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************



*/LV RST: Печать списка отмены на сервис-принтер*
PROCEDURE lvCancelPrintView
***
CREATE SQL VIEW lvCancelPrintView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPartTvr.FrmPartTvrID, ;
	FrmPartTvr.FrmID, ;
	FrmPartTvr.TvrID, ;
	FrmPartTvr.TvrQnt, ;
	FrmPartTvr.TvrPrcSale, ;
	Form.PointEmiCltID, ;
	Form.PointEmiOUID, ;
	ISNULL(Client.CltNm,CAST('' as varchar(40))) AS WaiterNM, ;
	ISNULL(OrgUnit.OUNm,CAST('' as varchar(40))) AS TableNM, ;
	ISNULL(Tovar.TvrNM,CAST('' as varchar(40))) AS TvrNM, ;
	ISNULL(Device.DeviceID,CAST(0 as integer)) AS DeviceID, ;
	ISNULL(Device.DeviceNM,CAST('' as varchar(40))) AS DeviceNM, ;
	ISNULL(Device.DeviceINI,CAST('' as varchar(40))) AS DeviceINI ;
FROM FrmPartTvr ;
LEFT JOIN Form ON Form.FrmID = FrmPartTvr.FrmID ;
LEFT JOIN OrgUnit ON OrgUnit.OUID = Form.PointEmiOUID ;
LEFT JOIN Client ON Client.CltID = Form.PointEmiCltID ;
LEFT JOIN AccPrint ON AccPrint.TvrID = FrmPartTvr.TvrID ;
LEFT JOIN ActionRule ON ActionRule.ActionRuleID = AccPrint.ActionRuleID ;
LEFT JOIN Device ON Device.DeviceID = ActionRule.ActionRulePointIsp ;
LEFT JOIN Tovar ON Tovar.TvrID = FrmPartTvr.TvrID ;
WHERE dbo.BITTEST(FrmPartTvr.TvrAttr,0)=1 ;
	  AND dbo.BITTEST(FrmPartTvr.TvrAttr,4) = 0 ;
	  AND FrmPartTvr.FrmID = ?_PARAM1 ;
	  AND ActionRule.ActionRulePointEmi = ?_PARAM2 ;
ORDER BY FrmPartTvrID

***
DBSETPROP([lvCancelPrintView.DeviceINI],[Field],[DataType],[M])
***
DBSETPROP([lvCancelPrintView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCancelPrintView],[VIEW],[COMMENT],[LV RST: Печать списка отмены на сервис-принтер])
***
ENDPROC 
*------------------------------------------------------------------------------
*******************************************************************************************

*/LV RST: Сведения о карточке по номеру
PROCEDURE lvDiscCardByNo
***
CREATE SQL VIEW lvDiscCardByNo REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DiscCardID, ;
	DiscID, ;
	DiscCardIsActive, ;
	ISNULL(DiscCardSumAccount,0) AS DiscCardSumAccount, ;
	ISNULL(DiscCardRestrictUp,0) AS DiscCardRestrictUp, ;
	CLU ;
FROM Disccard ;
WHERE Disccard.CLU  = ?_PARAM

***
DBSETPROP([lvDiscCardByNo],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscCardByNo],[VIEW],[COMMENT],[LV RST: информация о дисконтной карте по номеру])
***
ENDPROC
*------------------------------------------------------------------------------
******************************************************************************************

*/LV RST: Список скидок  с граничными суммами
PROCEDURE lvDiscountList
***
CREATE SQL VIEW lvDiscountList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DiscID, ;
	DiscRate, ;
	ISNULL(DiscRK,0) AS DiscRK ;
FROM Discount ;
ORDER BY DiscRK, DiscRate DESC 
***
DBSETPROP([lvDiscountList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscountList],[VIEW],[COMMENT],[LV RST: Список скидок  с граничными суммами])
***
ENDPROC

*------------------------------------------------------------------------------
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

*/LV RST: Сумма заказов по данной дисконтной карте за последние 12 часов
PROCEDURE lvShiftSumView
***
CREATE SQL VIEW lvShiftSumView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ISNULL(SUM(ROUND(CheckTrans.CheckTransQnt*CheckTrans.CheckTransPrc,2)*CheckTransType.CheckTransTypeSign),0) AS FrmSum ;
FROM CheckTrans  ;
INNER JOIN CheckTransType ON CheckTransType.CheckTransTypeID = CheckTrans.CheckTransTypeID ;
INNER JOIN CheckSale ON CheckSale.CheckID = CheckTrans.CheckID ;
WHERE CheckSale.DiscCardID = ?_PARAM ;
		AND (CheckSale.CheckAttributeID IS NULL OR CheckSale.CheckAttributeID<>2) ;
		AND CheckSale.CheckStamp>=DATEADD(hh,-12,GetDate())

***
DBSETPROP([lvShiftSumView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvShiftSumView],[VIEW],[COMMENT],[LV RST: Сумма заказов по данной дисконтной карте за последние 12 часов])
***
ENDPROC 



