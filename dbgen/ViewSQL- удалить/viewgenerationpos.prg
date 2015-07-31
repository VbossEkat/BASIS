#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*07.04.2006 09:32 -> ������� ��������� ��� ������������
WAIT WINDOW [��������� ������������� ��� ��: POS] NOWAIT NOCLEAR
SET MESSAGE TO [��������� ������������� ��� ��: POS]
***
lvPosFuncView()
lvPosFuncViewRepl()
lvPosFuncEdit()
***
lvPOSFuncSetView()
lvPOSFuncSetViewRepl()
lvPOSFuncSetEdit()
***
lvPOSFuncInSetView()
lvPOSFuncInSetEdit()
lvPOSFuncInSetViewRepl()
lvPOSFuncInSetLink()
***
lvPOSLinkObjType()
***
lvTvrInSetView()
***
lvPOSDishesList()
lvPOSFuncSetList()
lvPOSFuncList()
lvPaymentTypeView()
lvPaymentTypeInfo()
lvPOSKeyMap()
***
lvJrdCouponView()
lvCouponList()
*------------------------------------------------------------------------------

*07.04.2006 09:32 ->������ ���������
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV POS: ������ ������� POS/*
PROCEDURE lvPosFuncView
***
CREATE SQL VIEW lvPosFuncView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	PosFunc.PosFuncId, ;
	PosFunc.PosFuncNM, ;
	CAST(0 AS bit) AS IsMark ;
FROM PosFunc
***
DBSETPROP([lvPosFuncView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPosFuncView],[VIEW],[COMMENT],[LV POS: ������ ������� POS])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ���������� ������ ������� POS/*
PROCEDURE lvPosFuncViewRepl
***
CREATE SQL VIEW lvPosFuncViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	PosFunc.PosFuncId, ;
	PosFunc.PosFuncNM, ;
	CAST(0 AS bit) AS IsMark ;
FROM PosFunc ;
WHERE PosFunc.PosFuncId = ?_PARAM 
***
DBSETPROP([lvPosFuncViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPosFuncViewRepl],[VIEW],[COMMENT],[LV POS: ���������� ������ ������� POS])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: �������������� ������� POS/*
PROCEDURE lvPosFuncEdit
***
CREATE SQL VIEW lvPosFuncEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	PosFunc.PosFuncId, ;
	PosFunc.PosFuncNM, ;
	PosFunc.PosFuncMsg ;
FROM PosFunc ;
WHERE PosFunc.PosFuncId = ?_PARAM 
***
DBSETPROP([lvPosFuncEdit.PosFuncId],[FIELD],[KeyField],.T.)
DBSETPROP([lvPosFuncEdit.PosFuncId],[FIELD],[Updatable],.F.)
*** 
DBSETPROP([lvPosFuncEdit.PosFuncMsg],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvPosFuncEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvPosFuncEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvPosFuncEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPosFuncEdit],[VIEW],[COMMENT],[LV POS: �������������� ������� POS])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ����� ������� POS/*
PROCEDURE lvPosFuncSetView
***
CREATE SQL VIEW lvPosFuncSetView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	POSFuncSet.POSFuncSetID, ;
	POSFuncSet.POSFuncSetNM ;
FROM POSFuncSet
***
DBSETPROP([lvPosFuncSetView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPosFuncSetView],[VIEW],[COMMENT],[LV POS: ����� ������� POS])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ���������� ������ ������� POS/*
PROCEDURE lvPosFuncSetViewRepl
***
CREATE SQL VIEW lvPosFuncSetViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	POSFuncSet.POSFuncSetID, ;
	POSFuncSet.POSFuncSetNM ;
FROM POSFuncSet ;
WHERE POSFuncSet.POSFuncSetID = ?_PARAM
***
DBSETPROP([lvPosFuncSetViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPosFuncSetViewRepl],[VIEW],[COMMENT],[LV POS: ���������� ������ ������� POS])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: �������������� ������ ������� POS/*
PROCEDURE lvPosFuncSetEdit
***
CREATE SQL VIEW lvPosFuncSetEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	POSFuncSet.POSFuncSetID, ;
	POSFuncSet.POSFuncSetNM ;
FROM POSFuncSet ;
WHERE POSFuncSet.POSFuncSetID = ?_PARAM
***
DBSETPROP([lvPosFuncSetEdit.POSFuncSetID],[FIELD],[KeyField],.T.)
DBSETPROP([lvPosFuncSetEdit.POSFuncSetID],[FIELD],[Updatable],.F.)
*** 
DBSETPROP([lvPosFuncSetEdit.POSFuncSetNM],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvPosFuncSetEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvPosFuncSetEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvPosFuncSetEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPosFuncSetEdit],[VIEW],[COMMENT],[LV POS: �������������� ������ ������� POS])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ��������� ������� POS/*
PROCEDURE lvPOSFuncInSetView
***
CREATE SQL VIEW lvPOSFuncInSetView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	POSFuncInSet.POSFuncSetID, ;
	POSFuncInSet.POSFuncInSetID, ;
	POSFuncInSet.POSFuncID, ;
	CAST(CASE ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 1 THEN ISNULL(POSFuncList.POSFuncMsg,'') ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 2 THEN 'FUNCLIST' ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 3 THEN 'DISH' ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 4 THEN 'DISHES' ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 5 THEN 'PAY' ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 6 THEN ISNULL(POSFuncList.POSFuncMsg,'') ;
		 END AS varchar(40))AS POSFuncMsg, ;
	POSFuncInSet.POSFuncInSetOrder, ;
	CAST(CASE ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 1 THEN ISNULL(POSFuncList.POSFuncID,000000) ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 2 THEN POSFuncSet.POSFuncSetID ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 3 THEN ISNULL(Tovar.TvrID,000000) ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 4 THEN ISNULL(TvrSet.TvrSetID,000000) ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 5 THEN ISNULL(CheckPaymentType.CheckPaymentTypeID,000000) ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 6 THEN ISNULL(POSFuncList.POSFuncID,000000) ;
		 END AS integer) AS ID, ;
	CAST(CASE ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 1 THEN ISNULL(POSFuncList.POSFuncNM,'') ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 2 THEN POSFuncSet.POSFuncSetNM ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 3 THEN ISNULL(Tovar.TvrNM,'') ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 4 THEN ISNULL(TvrSet.TvrSetNM,'') ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 5 THEN ISNULL(CheckPaymentType.CheckPaymentTypeNM,'') ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 6 THEN ISNULL(POSFuncList.POSFuncNM,'') ;
		 END AS varchar(40)) AS NM, ;
	POSFuncInSet.POSEnabledMode, ;
	CAST(CASE WHEN POSFuncInSetLinkObj <> 0 THEN 1 ELSE 0 END AS bit) AS IsLinked ;
FROM POSFuncInSet ;
LEFT JOIN POSFuncSet ON POSFuncSet.POSFuncSetID = POSFuncInSet.POSFuncID ;
LEFT JOIN Tovar		 ON Tovar.TvrID		  = POSFuncInSet.POSFuncInSetLinkObj ;	
LEFT JOIN TvrSet  	 ON TvrSet.TvrSetID   = POSFuncInSet.POSFuncInSetLinkObj ;	
LEFT JOIN CheckPaymentType	  ON CheckPaymentType.CheckPaymentTypeID = POSFuncInSet.POSFuncInSetLinkObj ;	
LEFT JOIN POSFunc POSFuncList ON POSFuncList.POSFuncID = POSFuncInSet.POSFuncInSetLinkObj ;	
WHERE POSFuncInSet.PosFuncSetID = ?_PARAM ;
ORDER BY 5
***
DBSETPROP([lvPOSFuncInSetView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPOSFuncInSetView],[VIEW],[COMMENT],[LV POS: ��������� ������� POS])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ���������� ��������� ������� POS/*
PROCEDURE lvPOSFuncInSetViewRepl
***
CREATE SQL VIEW lvPOSFuncInSetViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	POSFuncInSet.POSFuncSetID, ;
	POSFuncInSet.POSFuncInSetID, ;
	POSFuncInSet.POSFuncID, ;
	POSFuncList.POSFuncMsg, ;
	POSFuncInSet.POSFuncInSetOrder, ;
	CAST(0 AS integer) AS TvrSetID, ;
	CAST(CASE ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 1 THEN ISNULL(POSFuncList.POSFuncNM,'') ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 2 THEN POSFuncSet.POSFuncSetNM ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 3 THEN ISNULL(Tovar.TvrNM,'') ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 4 THEN ISNULL(TvrSet.TvrSetNM,'') ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 5 THEN ISNULL(CheckPaymentType.CheckPaymentTypeNM,'') ;
			WHEN POSFuncInSet.POSLinkObjTypeID = 6 THEN ISNULL(POSFuncList.POSFuncNM,'') ;
			ELSE '' ;
		 END AS varchar(40)) AS TvrSetNM, ;
	POSFuncInSet.POSEnabledMode, ;
	CAST(CASE WHEN POSFuncInSetLinkObj <> 0 THEN 1 ELSE 0 END AS bit) AS IsLinked ;
FROM POSFuncInSet ;
LEFT JOIN POSFuncSet ON POSFuncSet.POSFuncSetID = POSFuncInSet.POSFuncID ;
LEFT JOIN Tovar		 ON Tovar.TvrID		  = POSFuncInSet.POSFuncInSetLinkObj ;	
LEFT JOIN TvrSet  	 ON TvrSet.TvrSetID   = POSFuncInSet.POSFuncInSetLinkObj ;	
LEFT JOIN CheckPaymentType	  ON CheckPaymentType.CheckPaymentTypeID = POSFuncInSet.POSFuncInSetLinkObj ;	
LEFT JOIN POSFunc POSFuncList ON POSFuncList.POSFuncID = POSFuncInSet.POSFuncInSetLinkObj ;	
WHERE POSFuncInSet.PosFuncInSetID = ?_PARAM
***
DBSETPROP([lvPOSFuncInSetViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPOSFuncInSetViewRepl],[VIEW],[COMMENT],[LV POS: ���������� ��������� ������� POS])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: �������������� ��������� ������� POS/*
PROCEDURE lvPOSFuncInSetEdit
***
CREATE SQL VIEW lvPOSFuncInSetEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	POSFuncInSet.POSFuncInSetID, ;
	POSFuncInSet.POSFuncID, ;
	POSFuncInSet.POSFuncSetID, ;
	POSFuncInSet.POSFuncInSetOrder ;
FROM POSFuncInSet ;
INNER JOIN POSFunc ON POSFunc.POSFuncID = POSFuncInSet.POSFuncID ;
WHERE POSFuncInSet.POSFuncSetID = ?_PARAM
***
DBSETPROP([lvPOSFuncInSetEdit],[VIEW],[COMMENT],[LV POS: �������������� ��������� ������� POS])
***
DBSETPROP([lvPOSFuncInSetEdit.POSFuncInSetID],[FIELD],[KeyField],.T.)
DBSETPROP([lvPOSFuncInSetEdit.POSFuncInSetID],[FIELD],[Updatable],.F.)
*** 
DBSETPROP([lvPOSFuncInSetEdit.POSFuncID],[FIELD],[Updatable],.T.)
DBSETPROP([lvPOSFuncInSetEdit.POSFuncSetID],[FIELD],[Updatable],.T.)
DBSETPROP([lvPOSFuncInSetEdit.POSFuncInSetOrder],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvPOSFuncInSetEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvPOSFuncInSetEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvPOSFuncInSetEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPosFuncSetEdit],[VIEW],[COMMENT],[LV POS: �������������� ������ ������� POS])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: �������� ������� POS �� ������/*
PROCEDURE lvPOSFuncInSetLink
***
CREATE SQL VIEW lvPOSFuncInSetLink REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	POSFuncInSet.POSFuncInSetID, ;
	POSFuncInSet.POSFuncSetID, ;
	POSFuncInSet.POSLinkObjTypeID, ;
	POSFuncInSet.POSFuncInSetLinkObj, ;
	POSFuncInSet.POSFuncInSetOrder, ;
	POSFuncInSet.POSEnabledMode, ;
	POSFuncInSet.POSKeyCode ;
FROM POSFuncInSet ;
WHERE POSFuncInSet.POSFuncInSetID = ?_PARAM
***
DBSETPROP([lvPOSFuncInSetLink],[VIEW],[COMMENT],[LV POS: �������������� ��������� ������� POS])
***
DBSETPROP([lvPOSFuncInSetLink.POSFuncInSetID],[FIELD],[KeyField],.T.)
DBSETPROP([lvPOSFuncInSetLink.POSFuncInSetID],[FIELD],[Updatable],.F.)
*** 
DBSETPROP([lvPOSFuncInSetLink.POSFuncSetID],[FIELD],[Updatable],.T.)
DBSETPROP([lvPOSFuncInSetLink.POSLinkObjTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvPOSFuncInSetLink.POSFuncInSetLinkObj],[FIELD],[Updatable],.T.)
DBSETPROP([lvPOSFuncInSetLink.POSFuncInSetOrder],[FIELD],[Updatable],.T.)
DBSETPROP([lvPOSFuncInSetLink.POSEnabledMode],[FIELD],[Updatable],.T.)
DBSETPROP([lvPOSFuncInSetLink.POSKeyCode],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvPOSFuncInSetLink],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvPOSFuncInSetLink],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvPOSFuncInSetLink],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPOSFuncInSetLink],[VIEW],[COMMENT],[LV POS: �������� ������� POS �� ������])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ������ ����� ������������� ��������/*
PROCEDURE lvPOSLinkObjType()
***
CREATE SQL VIEW lvPOSLinkObjType REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	POSLinkObjType.POSLinkObjTypeID AS ID, ;
	POSLinkObjType.POSLinkObjTypeNM AS NM;
FROM POSLinkObjType
***
DBSETPROP([lvPOSLinkObjType],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPOSLinkObjType],[VIEW],[COMMENT],[LV POS: ������ ����� ������������� ��������])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ������ �������� �������/*
PROCEDURE lvTvrInSetView
***
CREATE SQL VIEW lvTvrInSetView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrInSet.TvrId, ;
	Tovar.TvrNM, ;
	SPACE(3) AS num_cnt ;
FROM TvrInSet ;
INNER JOIN Tovar ON Tovar.TvrID = TvrInSet.TvrID ;
WHERE TvrInSet.TvrSetID = ?_PARAM ;
ORDER BY Tovar.TvrNM
***
DBSETPROP([lvTvrInSetView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrInSetView],[VIEW],[COMMENT],[LV POS: ������ �������� �������])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ������ ����/*
PROCEDURE lvPOSDishesList
***
CREATE SQL VIEW lvPOSDishesList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Tovar.TvrID AS ID, ;
	Tovar.TvrNM AS NM ;
FROM Tovar ;
WHERE Tovar.TvrTypeID = 5 AND Tovar.TvrIsActiv = 1
***
DBSETPROP([lvPOSDishesList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPOSDishesList],[VIEW],[COMMENT],[LV POS: ������ ����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ������ ������� �������/*
PROCEDURE lvPOSFuncSetList
***
CREATE SQL VIEW lvPOSFuncSetList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	POSFuncSet.POSFuncSetID AS ID, ;
	POSFuncSet.POSFuncSetNM AS NM ;
FROM POSFuncSet
***
DBSETPROP([lvPOSFuncSetList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPOSFuncSetList],[VIEW],[COMMENT],[LV POS: ������ ������� �������])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ������ �������/*
PROCEDURE lvPOSFuncList
***
CREATE SQL VIEW lvPOSFuncList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	POSFunc.POSFuncID AS ID, ;
	POSFunc.POSFuncNM AS NM ;
FROM POSFunc
***
DBSETPROP([lvPOSFuncList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPOSFuncList],[VIEW],[COMMENT],[LV POS: ������ �������])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ������ ����� �����/*
PROCEDURE lvPaymentTypeView
***
CREATE SQL VIEW lvPaymentTypeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CheckPaymentType.CheckPaymentTypeID AS ID, ;
	CheckPaymentType.CheckPaymentTypeNM AS NM ;
FROM CheckPaymentType
***
DBSETPROP([lvPaymentTypeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPaymentTypeView],[VIEW],[COMMENT],[LV POS: ������ ����� �����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ��������� ����������/*
PROCEDURE lvPOSKeyMap
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvPOSKeyMap REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	POSFuncInSet.POSFuncInSetLinkObj, ;
	POSFunc.POSFuncMsg, ;
	POSFuncInSet.POSKeyCode, ;
	POSFuncInSet.POSEnabledMode ;
FROM POSFuncInSet ;
INNER JOIN POSFunc ON POSFunc.POSFuncID = POSFuncInSet.POSFuncInSetLinkObj ;
WHERE POSFuncInSet.POSFuncSetID = ?_PARAM
***
DBSETPROP([lvPOSKeyMap],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPOSKeyMap],[VIEW],[COMMENT],[LV POS: ��������� ����������])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ���������� � ���� ������/*
PROCEDURE lvPaymentTypeInfo
***
CREATE SQL VIEW lvPaymentTypeInfo REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CheckPaymentType.CheckPaymentTypeID AS ID, ;
	CheckPaymentType.CheckPaymentTypeNM AS NM, ;
	CheckPaymentType.CheckPaymentTypeObjDesc AS ObjDesc, ;
	CheckPaymentType.CheckPaymentTypeRate AS Rate ;
FROM CheckPaymentType ;
WHERE CheckPaymentType.CheckPaymentTypeID = ?_PARAM
***
DBSETPROP([lvPaymentTypeInfo],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPaymentTypeInfo],[VIEW],[COMMENT],[LV POS: ���������� � ���� ������])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ���������� �� ������������ � ��������/*
PROCEDURE lvJrdCouponView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvJrdCouponView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT DISTINCT ;
	Coupon.CltID AS ID, ;
	Client.CltNM AS NM ;
FROM Coupon ;
INNER JOIN Client ON Client.CltID = Coupon.CltID ;
ORDER BY 2
***
DBSETPROP([lvJrdCouponView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvJrdCouponView],[VIEW],[COMMENT],[LV POS: ���������� �� ������������ � ��������])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV POS: ������ ������� � �����������/*
PROCEDURE lvCouponList
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvCouponList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT DISTINCT ;
	Coupon.CouponID AS ID, ;
	Coupon.CouponNM AS NM ;
FROM Coupon ;
WHERE Coupon.CltID = ?_PARAM
***
DBSETPROP([lvCouponList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCouponList],[VIEW],[COMMENT],[LV POS: ������ ������� � �����������])
***
ENDPROC
*------------------------------------------------------------------------------
