#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 17:33 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Очередь документов на оплату] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Очередь документов на оплату]
***
lvQueueToPayFoot()
lvQueueToPay()
lvQueueSum()
lvQueueIns()
lvQueue()
lvPartFrmSum()
lvFrmPartFrm()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV QPAY: очередь на оплату по ногам/*
PROCEDURE lvQueueToPayFoot
***
CREATE SQL VIEW lvQueueToPayFoot REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmTypePay.FrmTypeID, ;
	FrmTypePay.IncludeFrmTypeID ;
FROM FrmTypePay ;
WHERE FrmTypePay.FrmTypeid = ?_PARAM
***
DBSETPROP([lvQueueToPayFoot],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQueueToPayFoot],[VIEW],[COMMENT],[LV QPAY: очередь на оплату по ногам])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QPAY: очередь на оплату по головам/*
PROCEDURE lvQueueToPay
***
CREATE SQL VIEW lvQueueToPay REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmTypePay.FrmTypeID, ;
	FrmTypePay.IncludeFrmTypeID ;
FROM FrmTypePay ;
WHERE  FrmTypePay.IncludeFrmTypeID = ?_PARAM
***
DBSETPROP([lvQueueToPay],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQueueToPay],[VIEW],[COMMENT],[LV QPAY: очередь на оплату по головам])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QPAY: запрос для создания очереди на оплату/*
PROCEDURE lvQueueSum
***
CREATE SQL VIEW lvQueueSum REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPayQueue.FrmID, ;
	FrmPayQueue.FrmPaySum, ;
	FrmPartFrm.CntFrmIncludeSum AS OplSum, ;
	FrmPartFrm.FrmID, ;
	Form.PointEmiCltID, ;
	Form.PointIspCltID, ;
	FrmType.FrmTypeDirection, ;
	FrmPayQueue.Block ;
FROM FrmPayQueue ;
LEFT  JOIN FrmPartFrm ON FrmPayQueue.FrmID = FrmPartFrm.FrmPartFrmID ;
INNER JOIN Form ON FrmPayQueue.FrmID = Form.FrmID ;
INNER JOIN FrmType ON FrmType.FrmTypeID = Form.FrmTypeID;
WHERE  Form.PointEmiCltID = ?_PARAM  OR  Form.PointIspCltID = ?_PARAM
***
DBSETPROP([lvQueueSum],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQueueSum],[VIEW],[COMMENT],[LV QPAY: запрос для создания очереди на оплату])
***
ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*/LV QPAY: запрос для создания очереди на оплату/*
PROCEDURE lvQueueIns
***
CREATE SQL VIEW lvQueueIns REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPayQueue.FrmPayQueueID, ;
	FrmPayQueue.FrmID, ;
	FrmPayQueue.FrmPaySum, ;
	FrmPayQueue.FrmPayPlanDate, ;
	FrmPayQueue.block, ;
	FrmPayQueue.user_, ;
	FrmPayQueue.stamp_ ; 
FROM FrmPayQueue ;
WHERE FrmPayQueue.FrmID = ?_PARAM
***
DBSETPROP([lvQueueIns],[View],[SendUpdates],.T.)
***
DBSETPROP([lvQueueIns.FrmPayqueueid],[Field],[KeyField],.T.)
DBSETPROP([lvQueueIns.FrmPayqueueid],[Field],[Updatable],.F.)
DBSETPROP([lvQueueIns.FrmID],[Field],[Updatable],.T.)
DBSETPROP([lvQueueIns.FrmPaySum],[Field],[Updatable],.T.)
DBSETPROP([lvQueueIns.FrmPayPlanDate],[Field],[Updatable],.T.)
DBSETPROP([lvQueueIns.User_],[Field],[Updatable],.T.)
DBSETPROP([lvQueueIns.Stamp_],[Field],[Updatable],.T.)
DBSETPROP([lvQueueIns.Block],[Field],[Updatable],.T.)
***
DBSETPROP([lvQueueIns],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQueueIns],[VIEW],[COMMENT],[LV QPAY: запрос для создания очереди на оплату])
***
ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

PROCEDURE lvQueue
***
CREATE SQL VIEW lvQueue REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPayQueue.FrmID, ;
	Form.PointEmiCltID, ;
	Form.PointIspCltID, ;
 	FrmType.FrmTypeDirection, ;
 	FrmPayQueue.FrmPaySum, ;
 	FrmType.FrmTypeAbbr,;
	Form.FrmNum, ;
	Form.FrmDate, ;
	FrmPayQueue.Block;
FROM FrmPayQueue ;
INNER JOIN Form ON  FrmPayQueue.FrmID = Form.FrmID ;
INNER JOIN FrmType ON  FrmType.FrmTypeID = Form.FrmTypeID;
WHERE !FrmPayQueue.Block AND ;
	   FrmType.FrmTypeDirection = ?_PARAMD AND ;
	  (Form.PointEmiCltID = ?_PARAMC OR Form.PointIspCltID = ?_PARAMC)
***
DBSETPROP([lvQueue],[VIEW],[FetchSize],-1)
***
ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

PROCEDURE lvPartFrmSum
***
CREATE SQL VIEW lvPartFrmSum REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmPartTvr.FrmID, ;
	SumDoc = SUM(ROUND(CASE WHEN FrmType.FrmTypeDirection = 3 THEN FrmPartTvr.TvrPrcSale ELSE FrmPartTvr.TvrPrcBuy END * FrmPartTvr.TvrQnt,2)) ;
FROM FrmPartTvr ;
INNER JOIN Form ON Form.FrmID = FrmPartTvr.FrmID ;
INNER JOIN FrmType ON FrmType.FrmTypeID = Form.FrmTypeID ;
WHERE FrmPartTvr.FrmID = ?_PARAM ;
GROUP BY FrmPartTvr.FrmID
***
DBSETPROP([lvPartFrmSum],[VIEW],[FetchSize],-1)
***
ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

PROCEDURE lvFrmPartFrm
***
CREATE SQL VIEW lvFrmPartFrm REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Frmpartfrm.frmpartfrmid, ;
	Frmpartfrm.frmid, ;
	Frmpartfrm.cntfrmid,;
	Frmpartfrm.cntfrmincludesum, ;
	Frmpartfrm.cntfrmsumsplitprocid,;
	Frmpartfrm.frmpartfrmnote;
FROM frmpartfrm;
WHERE  Frmpartfrm.frmid = ?_PARAM
***
DBSETPROP([lvFrmPartFrm],[VIEW],[FetchSize],-1)
***
ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************