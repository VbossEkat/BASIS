#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 16:41 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Карты] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Карты]

*23.06.2006 15:50 ->Типы карт
lvCardTypeView()
lvCardTypeEdit()
lvCardTypeRepl()
***

*23.06.2006 16:27 ->Карты
lvCardView()
lvCardEdit()
lvCardRepl()
***

*28.06.2006 11:36 ->Действия с картами
lvCardViewByCLU()
lvCardViewByDecode()
lvCardOwnerInfoByID()
***

*04.07.2006 12:38 ->SCUD
lvPassRegEdit()
lvIOJrnEdit()
lvIOJrnView()
lvSearchCardByOwner()
lvCltJuridicalList()
*------------------------------------------------------------------------------

WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV CARD: типы карт/*
PROCEDURE lvCardTypeView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE VIEW lvCardTypeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CardType.CardTypeID, ;
	CardType.CardTypeNM, ;
	CardType.CardTypeIsSingle ;
FROM CardType
***
DBSETPROP([lvCardTypeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCardTypeView],[VIEW],[COMMENT],[LV CARD: типы карт])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CARD: редактирование типов карт/*
PROCEDURE lvCardTypeEdit
***
CREATE VIEW lvCardTypeEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CardType.CardTypeID, ;
	CardType.CardTypeNM, ;
	CardType.CardTypePay ;
FROM CardType ;
WHERE CardType.CardTypeID = ?_PARAM
***
DBSETPROP([lvCardTypeEdit.CardTypeID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCardTypeEdit.CardTypeID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCardTypeEdit.CardTypeNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardTypeEdit.CardTypePay],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardTypeEdit.CardTypePay],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvCardTypeEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCardTypeEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCardTypeEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCardTypeEdit],[VIEW],[COMMENT],[LV CARD: типы карт])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CARD: обновление типов карт/*
PROCEDURE lvCardTypeRepl
***
CREATE VIEW lvCardTypeRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CardType.CardTypeID, ;
	CardType.CardTypeNM, ;
	CardType.CardTypePay ;
FROM CardType ;
WHERE CardType.CardTypeID = ?_PARAM
***
DBSETPROP([lvCardTypeEdit],[VIEW],[COMMENT],[LV CARD: обновление типов карт])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CARD: все карты/*
PROCEDURE lvCardView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE VIEW lvCardView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Card.CardID, ;
	Card.CardTypeID, ;
	CardType.CardTypeNM, ;
	Card.CardNo, ;
	Card.CardCode, ;
	Card.CardDeliveryDate, ;
	Card.CardExpiredDate, ;
	Card.CardActivationDate, ;
	Card.CardOwnerID, ;
	ISNULL(Owner.CltNM,SPACE(40)) AS OwnerNM, ;
	Card.CardSupplID, ;
	ISNULL(Suppl.CltNM,SPACE(40)) AS SupplNM, ;
	Card.CltJrdID, ;
	ISNULL(Jrd.CltNM,SPACE(40))	  AS JrdNM, ;
	Card.CardFrmID, ;
	Card.CardRole, ;
	Card.CardIsActive, ;
	Card.CardNote, ;
	Card.CardIsPay ;
FROM Card ;
INNER JOIN CardType ON CardType.CardTypeID = Card.CardTypeID ;
LEFT  JOIN Client Owner ON Owner.CltID = Card.CardOwnerID ;
LEFT  JOIN Client Suppl ON Suppl.CltID = Card.CardSupplID ;
LEFT  JOIN Client Jrd   ON Jrd.CltID   = Card.CltJrdID ;
ORDER BY 3
***
DBSETPROP([lvCardView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCardView],[VIEW],[COMMENT],[LV CARD: дисконтные карты])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CARD: редактирование карты/*
PROCEDURE lvCardEdit
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE VIEW lvCardEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Card.CardID, ;
	Card.CardTypeID, ;
	Card.CardNo, ;
	Card.CardCode, ;
	Card.CardDeCode, ;
	Card.CardDeliveryDate, ;
	Card.CardExpiredDate, ;
	Card.CardActivationDate, ;
	Card.CardOwnerID, ;
	Card.CardSupplID, ;
	Card.CardSupplID, ;
	Card.CltJrdID, ;
	Card.CardFrmID, ;
	Card.CardRole, ;
	Card.CardIsActive, ;
	Card.CardNote, ;
	Card.CardIsPay, ;
	Card.User_ ;
FROM Card ;
WHERE Card.CardID = ?_PARAM
***
DBSETPROP([lvCardEdit.CardID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCardEdit.CardID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCardEdit.CardTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.CardNo],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.CardCode],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.CardDeCode],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.CardDeliveryDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.CardExpiredDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.CardActivationDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.CardOwnerID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.CardSupplID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.CardSupplID],[FIELD],[DefaultValue],[1227])
DBSETPROP([lvCardEdit.CltJrdID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.CardFrmID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.CardRole],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.CardRole],[FIELD],[DefaultValue],[0])
DBSETPROP([lvCardEdit.CardIsActive],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.CardIsActive],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvCardEdit.CardNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.CardIsPay],[FIELD],[Updatable],.T.)
DBSETPROP([lvCardEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCardEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCardEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCardEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCardEdit],[VIEW],[COMMENT],[LV CARD: типы карт])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CARD: обновление карты/*
PROCEDURE lvCardRepl
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE VIEW lvCardRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Card.CardID, ;
	Card.CardTypeID, ;
	CardType.CardTypeNM, ;
	Card.CardNo, ;
	Card.CardCode, ;
	Card.CardDeliveryDate, ;
	Card.CardExpiredDate, ;
	Card.CardActivationDate, ;
	Card.CardOwnerID, ;
	ISNULL(Owner.CltNM,SPACE(40)) AS OwnerNM, ;
	Card.CardSupplID, ;
	ISNULL(Suppl.CltNM,SPACE(40)) AS SupplNM, ;
	Card.CltJrdID, ;
	ISNULL(Jrd.CltNM,SPACE(40))	  AS JrdNM, ;
	Card.CardFrmID, ;
	Card.CardRole, ;
	Card.CardIsActive, ;
	Card.CardNote ;
FROM Card ;
INNER JOIN CardType ON CardType.CardTypeID = Card.CardTypeID ;
LEFT  JOIN Client Owner ON Owner.CltID = Card.CardOwnerID ;
LEFT  JOIN Client Suppl ON Suppl.CltID = Card.CardSupplID ;
LEFT  JOIN Client Jrd   ON Jrd.CltID   = Card.CltJrdID ;
WHERE Card.CardID = ?_PARAM
***
DBSETPROP([lvCardRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCardRepl],[VIEW],[COMMENT],[LV CARD: обновление карты])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Card: активные дисконтные карты/* 
PROCEDURE lvCardViewByCLU
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvCardViewByCLU REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Card.CardID, ;
	Card.CardTypeID, ;
	Card.CardExpiredDate, ;
	Card.CardActivationDate, ;
	WPObjDesc.WPODNM ;
FROM Card ;
INNER JOIN CardType  ON CardType.CardTypeID = Card.CardTypeID ;
INNER JOIN WPObjDesc ON WPObjDesc.CardTypeID = CardType.CardTypeID ;
WHERE ;
	LEN(Card.CardCode)>0 AND ;
	Card.CardIsActive = 1 AND ;
	dbo.BITTEST(Card.CardRole,0)=1 AND ;
	Card.CardCode = ?_PARAM1 AND WPObjDesc.PlaceTypeID = ?_PARAM2
***
DBSETPROP([lvCardViewByCLU],[VIEW],[COMMENT],[LV Card: данные карты по CLU])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Card: активные дисконтные карты/* 
PROCEDURE lvCardViewByDecode
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvCardViewByDecode REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Card.CardID, ;
	Card.CardTypeID, ;
	Card.CardExpiredDate, ;
	Card.CardActivationDate, ;
	WPObjDesc.WPODNM ;
FROM Card ;
INNER JOIN CardType  ON CardType.CardTypeID = Card.CardTypeID ;
INNER JOIN WPObjDesc ON WPObjDesc.CardTypeID = CardType.CardTypeID ;
WHERE ;
	Card.CardIsActive = 1 AND ;
	dbo.BITTEST(Card.CardRole,0)=1 AND ;
	Card.CardDecode = ?_PARAM1 AND WPObjDesc.PlaceTypeID = ?_PARAM2
***
DBSETPROP([lvCardViewByDecode],[VIEW],[COMMENT],[LV Card: данные карты по CLU])
***
ENDPROC
*------------------------------------------------------------------------------


*/LV Card: Информация о владельце по ID карты/*
PROCEDURE lvCardOwnerInfoByID
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

CREATE SQL VIEW lvCardOwnerInfoByID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Card.CardID, ;
	Card.CardNo, ;
	Card.CardOwnerID AS CltID, ;
	CardType.CardTypeNM, ;
	ISNULL(CltPhysical.CltPhysFNM,'') AS CltPhysFNM, ;
	ISNULL(CltPhysical.CltPhysINM,'') AS CltPhysINM, ;
	ISNULL(CltPhysical.CltPhysONM,'') AS CltPhysONM, ;
	ISNULL(CltPhysPassp.CltPhysPasspSeries,'') AS CltPhysPasspSeries, ;
	ISNULL(CltPhysPassp.CltPhysPasspNumber,'') AS CltPhysPasspNumber, ;
	ISNULL(CltPhysPassp.CltPhysPasspIssueBy,'') AS CltPhysPasspIssueBy, ;
	CltPhysPassp.CltPhysPasspIssueDate, ;
	CltImage.CltImage, ;
	ISNULL(CltJuridical.CltJrdNM,'') AS CltJrdNM, ;
	ISNULL(CltLegalType.CltLegalTypeAbbr,'') AS CltLegalTypeAbbr, ;
	ISNULL(CltLegalType.CltLegalTypeNM,'') AS CltLegalTypeNM, ;
	ISNULL(CltPost.CltPostNM,'') AS CltPostNM ;
FROM Card ;
INNER JOIN CardType		ON CardType.CardTypeID	= Card.CardTypeID ;
LEFT  JOIN CltPhysical	ON CltPhysical.CltID	= Card.CardOwnerID ;
LEFT  JOIN CltPhysPassp ON CltPhysPassp.CltID	= Card.CardOwnerID ;
LEFT  JOIN CltImage		ON CltImage.CltID		= Card.CardOwnerID ;
LEFT  JOIN CltJuridical ON CltJuridical.CltID	= Card.CltJrdID ;
LEFT  JOIN CltLegalType ON CltLegalType.CltLegalTypeID = CltJuridical.CltLegalTypeID ;
LEFT  JOIN CltPost		ON CltPost.CltPostID	= CltPhysical.CltPostID ;
WHERE Card.CardID = ?_PARAM
***
DBSETPROP([lvCardOwnerInfoByID.CltImage],[FIELD],[DataType],[M])
***
DBSETPROP([lvCardOwnerInfoByID],[VIEW],[COMMENT],[LV Card: Информация о владельце по ID карты])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Card: Регистрация пассажира на рейс/*
PROCEDURE lvPassRegEdit
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvPassRegEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT TOP 1;
	PassReg.PassRegID, ;
	PassReg.CardID, ;
	PassReg.FlightTypeID, ;
	PassReg.PassRegFlightNo, ;
	PassReg.PassRegCompanyCode, ;
	PassReg.PassRegTime, ;
	PassReg.CltID, ;
	PassReg.CltFNM, ;
	PassReg.CltINM, ;
	PassReg.CltONM, ;
	PassReg.CltPasspSeries, ;
	PassReg.CltPasspNumber, ;
	PassReg.CltPasspIssueBy, ;
	PassReg.CltPasspIssueDate,  ;
	PassReg.CltJrdID, ;
	PassReg.PassRegNote, ;
	PassReg.User_  ;
FROM PassReg ;
INNER JOIN Card ON Card.CardID = PassReg.CardID ;
WHERE PassReg.Stamp_ > DATEADD(day,-1,GETDATE()) AND PassReg.CardID = ?_PARAM ;
ORDER BY PassReg.PassRegID DESC
***
DBSETPROP([lvPassRegEdit.PassRegID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvPassRegEdit.PassRegID],[FIELD],[Updatable],.F.)
DBSETPROP([lvPassRegEdit.CardID],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.FlightTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.PassRegFlightNo],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.PassRegCompanyCode],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.PassRegTime],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.CltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.CltFNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.CltINM],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.CltONM],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.CltPasspSeries],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.CltPasspNumber],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.CltPasspIssueBy],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.CltPasspIssueDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.CltJrdID],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.PassRegNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvPassRegEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvPassRegEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvPassRegEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvPassRegEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPassRegEdit],[VIEW],[COMMENT],[LV Card: Регистрация пассажира на рейс])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Card: Типы рейсов/*
PROCEDURE lvFligthTypeList
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvFligthTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FlightType.FlightTypeID   AS ID, ;
	FlightType.FlightTypeAbbr AS NM  ;
FROM FlightType
***
DBSETPROP([lvFligthTypeList],[VIEW],[COMMENT],[LV Card: Типы рейсов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Card: Редактирование журнала событий/*
PROCEDURE lvIOJrnEdit
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE VIEW lvIOJrnEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	IOJrn.IOJrnID, ;
	IOJrn.IOJrnCardID, ;
	IOJrn.IOActionTypeID, ;
	IOJrn.IOJrnDate, ;
	IOJrn.IOJrnAccPoint, ;
	IOJrn.Stamp_, ;
	IOJrn.User_ ;
FROM IOJrn ;
WHERE IOJrn.IOJrnID = ?_PARAM
***
DBSETPROP([lvIOJrnEdit.IOJrnID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvIOJrnEdit.IOJrnID],[FIELD],[Updatable],.F.)
DBSETPROP([lvIOJrnEdit.IOJrnCardID],[FIELD],[Updatable],.T.)
DBSETPROP([lvIOJrnEdit.IOActionTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvIOJrnEdit.IOJrnDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvIOJrnEdit.IOJrnAccPoint],[FIELD],[Updatable],.T.)
DBSETPROP([lvIOJrnEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvIOJrnEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvIOJrnEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvIOJrnEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvIOJrnEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvIOJrnEdit],[VIEW],[COMMENT],[LV Card: Редактирование журнала событий])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Card: Просмотр журнала событий/*
PROCEDURE lvIOJrnView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE VIEW lvIOJrnView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	IOJrn.IOJrnID, ;
	IOJrn.IOJrnCardID, ;
	Card.CardNo, ;
	CardType.CardTypeNM, ;
	Client.CltNM AS OwnerNM, ;
	IOJrn.IOActionTypeID, ;
	IOJrn.IOJrnDate, ;
	Card.CardExpiredDate, ;
	IOJrn.IOJrnAccPoint, ;
	IOJrn.Stamp_, ;
	IOJrn.User_ ;
FROM IOJrn ;
LEFT  JOIN Card		ON Card.CardID = IOJrn.IOJrnCardID ;
INNER JOIN CardType	ON CardType.CardTypeID = Card.CardTypeID ;
LEFT  JOIN Client	ON Client.CltID = Card.CardOwnerID
***
DBSETPROP([lvIOJrnView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvIOJrnView],[VIEW],[COMMENT],[LV Card: Просмотр журнала событий])
***
ENDPROC
*------------------------------------------------------------------------------


*/LV Card: Поиск карты по владельцу/*
PROCEDURE lvSearchCardByOwner
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE VIEW lvSearchCardByOwner REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Card.CardID, ;
	WPObjDesc.WPODNM ;
FROM Card ;
INNER JOIN CardType  ON CardType.CardTypeID = Card.CardTypeID ;
INNER JOIN WPObjDesc ON WPObjDesc.CardTypeID = CardType.CardTypeID ;
WHERE Card.CardOwnerID = ?_PARAM1 AND WPObjDesc.PlaceTypeID = ?_PARAM2
***
DBSETPROP([lvSearchCardByOwner],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvSearchCardByOwner],[VIEW],[COMMENT],[LV Card: Поиск карты по владельцу])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CARD: Клиенты - юридические лица/*
PROCEDURE lvCltJuridicalList
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvCltJuridicalList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltID AS ID, ;
	CltNM AS NM ;
FROM Client ;
WHERE Client.CltTypeID = 2 ;
ORDER BY Client.CltNM
***
DBSETPROP([lvCltJuridicalList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltJuridicalList],[VIEW],[COMMENT],[LV CARD: Клиенты - юридические лица])
***
ENDPROC
*------------------------------------------------------------------------------
