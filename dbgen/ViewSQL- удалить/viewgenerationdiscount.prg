#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 16:41 -> ��������� �������������
WAIT WINDOW [��������� ������������� ��� ��: ������] NOWAIT NOCLEAR
SET MESSAGE TO [��������� ������������� ��� ��: ������]
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
lvCardViewByCardCode()
lvCardViewByCardID()
lvPayTypeView()
lvOUCouponList()
lvCouponByOUView()
lvCouponByIDView()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV DSC: ���� ������/*
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
DBSETPROP([lvDiscView],[VIEW],[COMMENT],[LV DSC: ������])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: ���������� ��� lvDiscView/*
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
DBSETPROP([lvDiscViewRepl],[VIEW],[COMMENT],[LV DSC: ���������� ��� lvDiscView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: �������������� ������� Discount/*
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
DBSETPROP([lvDiscEdit],[VIEW],[COMMENT],[LV DSC: �������������� ������� Discount])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: ���������� �����/*
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
DBSETPROP([lvDiscCardView],[VIEW],[COMMENT],[LV DSC: ���������� �����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: ���������� ��� lvDiscCardView/*
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
DBSETPROP([lvDiscCardViewRepl],[VIEW],[COMMENT],[LV DSC: ���������� ��� lvDiscCardView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: �������������� ������� DiscCard/*
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
	DiscCard.User_, ;
	ISNULL(DiscCardSumAccount,0) AS DiscCardSumAccount, ;
	ISNULL(DiscCardRestrictUp,0) AS DiscCardRestrictUp ;
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
DBSETPROP([lvDiscCardEdit.DiscCardSumAccount],[FIELD],[Updatable],.T.)
DBSETPROP([lvDiscCardEdit.DiscCardRestrictUp],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvDiscCardEdit.CLU],[FIELD],[DefaultValue],[""])
DBSETPROP([lvDiscCardEdit.DiscCardDeliveryDate],[FIELD],[DefaultValue],[DATE()])
DBSETPROP([lvDiscCardEdit.DiscCardIsActive ],[FIELD],[DefaultValue],[.T.])
DBSETPROP([lvDiscCardEdit.Stamp_],[FIELD],[DefaultValue],[DATETIME()])
DBSETPROP([lvDiscCardEdit.User_ ],[FIELD],[DefaultValue],[-1])
DBSETPROP([lvDiscCardEdit.DiscCardSumAccount],[FIELD],[DefaultValue],[0])
DBSETPROP([lvDiscCardEdit.DiscCardRestrictUp],[FIELD],[DefaultValue],[.T.])
***
DBSETPROP([lvDiscCardEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvDiscCardEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvDiscCardEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDiscCardEdit],[VIEW],[COMMENT],[LV DSC: �������������� ���������� ����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: �������� ���������� �����/*
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
DBSETPROP([lvDiscCardList],[VIEW],[COMMENT],[LV DSC: �������� ���������� �����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: �������� ���������� �����/*
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
DBSETPROP([lvDiscCardViewByCLU],[VIEW],[COMMENT],[LV DSC: ������ ���������� ����� �� CLU])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: ���������� � ������ �� ���������� �����/*
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
DBSETPROP([lvDiscInfoByDiscCardID],[VIEW],[COMMENT],[LV DSC: ���������� � ������ �� ���������� �����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: ����� ������� �� ���� �����(������������ ��� ����������� ����� ������)/*
PROCEDURE lvCardViewByCardCode
***
CREATE SQL VIEW lvCardViewByCardCode REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Card.CardID, ;
	Card.CardNo, ;
	Card.CardOwnerID, ;
	ISNULL(Client.CltNM,'')	AS CltNM ;
FROM Card ;
LEFT JOIN Client ON Client.CltID = Card.CardOwnerID ;
WHERE Card.CardIsActive=1 AND dbo.BITTEST(Card.CardRole,0)=1 AND (Card.CardCode = ?_PARAM1 OR Card.CardDecode = ?_PARAM2)
***
DBSETPROP([lvCardViewByCardCode],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCardViewByCardCode],[VIEW],[COMMENT],[LV DSC: ����� ������� �� ���� ����� (������������ ��� ����������� ����� ������)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV DSC: ����� ������� �� ID ����� /*
PROCEDURE lvCardViewByCardID
***
CREATE SQL VIEW lvCardViewByCardID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Card.CardID, ;
	Card.CardNo, ;
	Card.CardTypeID, ;
	ISNULL(Client.CltNM,'')	AS CltNM ;
FROM Card ;
LEFT JOIN Client ON Client.CltID = Card.CardOwnerID ;
WHERE Card.CardIsActive=1 AND dbo.BITTEST(Card.CardRole,0)=1 AND Card.CardID = ?_PARAM
***
DBSETPROP([lvCardViewByCardID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCardViewByCardID],[VIEW],[COMMENT],[LV DSC: ����� ������� �� ID ����� ])
***
ENDPROC
*------------------------------------------------------------------------------



*/LV DSC: �������� ������
PROCEDURE lvPayTypeView
***
CREATE SQL VIEW lvPayTypeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CheckPaymentType.CheckPaymentTypeID, ;
	CheckPaymentType.TypePayFscID AS ID_, ;
	CASE WHEN CheckPaymentType.CheckPaymentTypeID=1 THEN '��������' ;
		WHEN CheckPaymentType.CheckPaymentTypeID=2 THEN '���������� �����' ;
		WHEN CheckPaymentType.CheckPaymentTypeID=3 THEN '�����' ;
		ELSE '������ VIP ������' END AS NM ;
FROM CheckPaymentType ;
JOIN iter_intlist_to_table(?_PARAM) i ON CheckPaymentType.CheckPaymentTypeID = i.number

***
DBSETPROP([lvPayTypeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPayTypeView],[VIEW],[COMMENT],[LV DSC: �������� ������])
***
ENDPROC
*------------------------------------------------------------------------------


*/LV DSC: ������ �����������-��������� (��� ������ ��������)
PROCEDURE lvOUCouponList
***
CREATE SQL VIEW lvOUCouponList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT DISTINCT ;
	Coupon.CltID AS ID, ;
	ISNULL(Client.CltNM,'��������� �������') AS NM ;
FROM Coupon ;
LEFT JOIN Client ON Client.CltID = Coupon.CltID 

***
DBSETPROP([lvOUCouponList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOUCouponList],[VIEW],[COMMENT],[LV DSC: ������ �����������-��������� (��� ������ ��������)])
***
ENDPROC
*------------------------------------------------------------------------------
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************


*/LV DSC: ������ ������� ������ ����������� 
PROCEDURE lvCouponByOUView
***
CREATE SQL VIEW lvCouponByOUView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Coupon.CouponID AS ID, ;
	Coupon.CouponNM AS NM, ;
	Coupon.CouponPrc ;
FROM Coupon ;
WHERE Coupon.CltID = ?_PARAM
***
DBSETPROP([lvCouponByOUView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCouponByOUView],[VIEW],[COMMENT],[LV DSC: ������ ������� ������ �����������])
***
ENDPROC
*------------------------------------------------------------------------------
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************



*/LV DSC: ���������� �� ������
PROCEDURE lvCouponByIDView
***
CREATE SQL VIEW lvCouponByIDView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Coupon.CouponID AS ID, ;
	Coupon.CouponNM AS NM, ;
	Coupon.CouponPrc ;
FROM Coupon ;
WHERE Coupon.CouponID = ?_PARAM
***
DBSETPROP([lvCouponByIDView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCouponByIDView],[VIEW],[COMMENT],[LV DSC: ���������� �� ������])
***
ENDPROC
*------------------------------------------------------------------------------
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************

