#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 16:41 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Талоны] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Талоны]

*23.06.2006 15:50 -> Типы карт
lvCouponView()
lvCouponEdit()
lvCouponRepl()
***

*------------------------------------------------------------------------------

WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV COUPON: талоны/*
PROCEDURE lvCouponView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE VIEW lvCouponView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Coupon.CouponID, ;
	Coupon.CouponNM, ;
	Coupon.CltID, ;
	ISNULL(Client.CltNM,'') AS CltNM, ;
	Coupon.CouponPrc, ;
	Coupon.CouponCLU ;
FROM Coupon ;
LEFT JOIN Client ON Client.CltID = Coupon.CltID
***
DBSETPROP([lvCouponView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCouponView],[VIEW],[COMMENT],[LV COUPON: типы карт])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV COUPON: редактирование талонов/*
PROCEDURE lvCouponEdit
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE VIEW lvCouponEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Coupon.CouponID, ;
	Coupon.CouponNM, ;
	Coupon.CltID, ;
	Coupon.CouponPrc, ;
	Coupon.CouponCLU, ;
	Coupon.Stamp_, ;
	Coupon.User_ ;
FROM Coupon ;
WHERE Coupon.CouponID = ?_PARAM
***
DBSETPROP([lvCouponEdit.CouponID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCouponEdit.CouponID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCouponEdit.CouponNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCouponEdit.CltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCouponEdit.CouponPrc],[FIELD],[Updatable],.T.)
DBSETPROP([lvCouponEdit.CouponCLU],[FIELD],[Updatable],.T.)
DBSETPROP([lvCouponEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvCouponEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCouponEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCouponEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCouponEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCouponEdit],[VIEW],[COMMENT],[LV COUPON: редактирование талонов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV COUPON: обновление талонов/*
PROCEDURE lvCouponRepl
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE VIEW lvCouponRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Coupon.CouponID, ;
	Coupon.CouponNM, ;
	Coupon.CltID, ;
	ISNULL(Client.CltNM,'') AS CltNM, ;
	Coupon.CouponPrc, ;
	Coupon.CouponCLU ;
FROM Coupon ;
LEFT JOIN Client ON Client.CltID = Coupon.CltID ;
WHERE Coupon.CouponID = ?_PARAM
***
DBSETPROP([lvCouponRepl],[VIEW],[COMMENT],[LV COUPON: обновление талонов])
***
ENDPROC
*------------------------------------------------------------------------------

*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************
