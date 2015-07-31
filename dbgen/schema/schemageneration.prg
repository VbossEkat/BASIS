LOCAL	lcTargetDatabaseLocation, ;
		lcTargetDBPath
***
lcTargetDatabaseLocation = DBC()
lcTargetDBPath = SUBSTR(lcTargetDatabaseLocation,1,RAT("\",lcTargetDatabaseLocation))
*-------------------------------------------------------------------------------

*Action Is Creating Table "_LocalSprav" ("Справочники для логирования")
CREATE TABLE (lcTargetDBPath+"_LocalSprav") ( ;
	LocalSpravID I NOT NULL DEFAULT spIncrementID("_LocalSprav"), ;
	LocalSpravNM C(40) NOT NULL, ;
	LocalFieldIDNM C(40) NOT NULL, ;
	LocalFieldsNM C(80) NOT NULL, ;
	LastOperationID I NOT NULL ;
)
***
DBSETPROP("_LocalSprav","TABLE","COMMENT","Справочники для логирования")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Справочники для логирования"
CREATE TRIGGER ON _LocalSprav FOR INSERT AS _spTriggerExec("_LocalSprav","INSERT")
CREATE TRIGGER ON _LocalSprav FOR UPDATE AS _spTriggerExec("_LocalSprav","UPDATE")
CREATE TRIGGER ON _LocalSprav FOR DELETE AS _spTriggerExec("_LocalSprav","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "_LocalSprav"
ALTER TABLE _LocalSprav ;
	ADD PRIMARY KEY LocalSpravID TAG LSID
*-------------------------------------------------------------------------------
*Action Is Creating Inversion Entry (Regular Index) For Table "_LocalSprav"
IF !USED("_LocalSprav")
	USE _LocalSprav IN 0 EXCLUSIVE
ENDIF
SELECT _LocalSprav
INDEX ON LocalSpravNM TAG LSNM
USE IN _LocalSprav
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "_LocalSprav" ("Справочники для логирования")
_WriteMetaInf(lcTargetDBPath,"_LocalSprav","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"_LocalSprav","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"_LocalSprav","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"_LocalSprav","META-INF","INCR_FLD","LocalSpravID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "AccountPeriod" ("Учётный период")
CREATE TABLE (lcTargetDBPath+"AccountPeriod") ( ;
	AccountPeriodID I NOT NULL DEFAULT spIncrementID("AccountPeriod"), ;
	AccountPeriodDateEnd T NOT NULL, ;
	AccountPeriodIsClosed L NOT NULL ;
)
***
DBSETPROP("AccountPeriod","TABLE","COMMENT","Учётный период")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Учётный период"
CREATE TRIGGER ON AccountPeriod FOR INSERT AS _spTriggerExec("AccountPeriod","INSERT")
CREATE TRIGGER ON AccountPeriod FOR UPDATE AS _spTriggerExec("AccountPeriod","UPDATE")
CREATE TRIGGER ON AccountPeriod FOR DELETE AS _spTriggerExec("AccountPeriod","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "AccountPeriod"
ALTER TABLE AccountPeriod ;
	ADD PRIMARY KEY AccountPeriodID TAG AccPerID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "AccountPeriod" ("Учётный период")
_WriteMetaInf(lcTargetDBPath,"AccountPeriod","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"AccountPeriod","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"AccountPeriod","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"AccountPeriod","META-INF","INCR_FLD","AccountPeriodID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "AccPlan" ("Справочник планов счетов")
CREATE TABLE (lcTargetDBPath+"AccPlan") ( ;
	AccPlanID I NOT NULL DEFAULT spIncrementID("AccPlan"), ;
	AccPlan C(40) NOT NULL, ;
	AccPlanNote C(100) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("AccPlan","TABLE","COMMENT","Справочник планов счетов")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Справочник планов счетов"
CREATE TRIGGER ON AccPlan FOR INSERT AS _spTriggerExec("AccPlan","INSERT")
CREATE TRIGGER ON AccPlan FOR UPDATE AS _spTriggerExec("AccPlan","UPDATE")
CREATE TRIGGER ON AccPlan FOR DELETE AS _spTriggerExec("AccPlan","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "AccPlan"
ALTER TABLE AccPlan ;
	ADD PRIMARY KEY AccPlanID TAG AccPlanID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "AccPlan" ("Справочник планов счетов")
_WriteMetaInf(lcTargetDBPath,"AccPlan","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"AccPlan","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"AccPlan","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"AccPlan","META-INF","INCR_FLD","AccPlanID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Bitmaps" ("Пиктограммы (BMP)")
CREATE TABLE (lcTargetDBPath+"Bitmaps") ( ;
	BmpId I NOT NULL DEFAULT spIncrementID("Bitmaps"), ;
	BmpFileNM C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("Bitmaps","TABLE","COMMENT","Пиктограммы (BMP)")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Пиктограммы (BMP)"
CREATE TRIGGER ON Bitmaps FOR INSERT AS _spTriggerExec("Bitmaps","INSERT")
CREATE TRIGGER ON Bitmaps FOR UPDATE AS _spTriggerExec("Bitmaps","UPDATE")
CREATE TRIGGER ON Bitmaps FOR DELETE AS _spTriggerExec("Bitmaps","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Bitmaps"
ALTER TABLE Bitmaps ;
	ADD PRIMARY KEY BmpId TAG TestTag
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Bitmaps" ("Пиктограммы (BMP)")
_WriteMetaInf(lcTargetDBPath,"Bitmaps","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Bitmaps","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Bitmaps","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"Bitmaps","META-INF","INCR_FLD","BmpId")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CancelReason" ("Причины отказа")
CREATE TABLE (lcTargetDBPath+"CancelReason") ( ;
	CancelReasonID I NOT NULL DEFAULT spIncrementID("CancelReason"), ;
	CancelReasonNM C(40) NOT NULL ;
)
***
DBSETPROP("CancelReason","TABLE","COMMENT","Причины отказа")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Причины отказа"
CREATE TRIGGER ON CancelReason FOR INSERT AS _spTriggerExec("CancelReason","INSERT")
CREATE TRIGGER ON CancelReason FOR UPDATE AS _spTriggerExec("CancelReason","UPDATE")
CREATE TRIGGER ON CancelReason FOR DELETE AS _spTriggerExec("CancelReason","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CancelReason"
ALTER TABLE CancelReason ;
	ADD PRIMARY KEY CancelReasonID TAG CncRsnID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CancelReason" ("Причины отказа")
_WriteMetaInf(lcTargetDBPath,"CancelReason","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CancelReason","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CancelReason","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CancelReason","META-INF","INCR_FLD","CancelReasonID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CardRole" ("Роли карты")
CREATE TABLE (lcTargetDBPath+"CardRole") ( ;
	CardRoleBit I NOT NULL, ;
	CardRoleNM C(40) NOT NULL ;
)
***
DBSETPROP("CardRole","TABLE","COMMENT","Роли карты")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Роли карты"
CREATE TRIGGER ON CardRole FOR INSERT AS _spTriggerExec("CardRole","INSERT")
CREATE TRIGGER ON CardRole FOR UPDATE AS _spTriggerExec("CardRole","UPDATE")
CREATE TRIGGER ON CardRole FOR DELETE AS _spTriggerExec("CardRole","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CardRole"
ALTER TABLE CardRole ;
	ADD PRIMARY KEY CardRoleBit TAG CardRBit
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CardRole" ("Роли карты")
_WriteMetaInf(lcTargetDBPath,"CardRole","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CardRole","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CardRole","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CardType" ("Типы карты")
CREATE TABLE (lcTargetDBPath+"CardType") ( ;
	CardTypeID I NOT NULL DEFAULT spIncrementID("CardType"), ;
	CardTypeNM C(40) NOT NULL, ;
	CardTypePay I NOT NULL ;
)
***
DBSETPROP("CardType","TABLE","COMMENT","Типы карты")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Типы карты"
CREATE TRIGGER ON CardType FOR INSERT AS _spTriggerExec("CardType","INSERT")
CREATE TRIGGER ON CardType FOR UPDATE AS _spTriggerExec("CardType","UPDATE")
CREATE TRIGGER ON CardType FOR DELETE AS _spTriggerExec("CardType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CardType"
ALTER TABLE CardType ;
	ADD PRIMARY KEY CardTypeID TAG CardTypeID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CardType" ("Типы карты")
_WriteMetaInf(lcTargetDBPath,"CardType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CardType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CardType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CardType","META-INF","INCR_FLD","CardTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CashierGroup" ("Группы кассиров")
CREATE TABLE (lcTargetDBPath+"CashierGroup") ( ;
	CashierGroupID I NOT NULL DEFAULT spIncrementID("CashierGroup"), ;
	CashierGroupNM C(40) NOT NULL ;
)
***
DBSETPROP("CashierGroup","TABLE","COMMENT","Группы кассиров")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Группы кассиров"
CREATE TRIGGER ON CashierGroup FOR INSERT AS _spTriggerExec("CashierGroup","INSERT")
CREATE TRIGGER ON CashierGroup FOR UPDATE AS _spTriggerExec("CashierGroup","UPDATE")
CREATE TRIGGER ON CashierGroup FOR DELETE AS _spTriggerExec("CashierGroup","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CashierGroup"
ALTER TABLE CashierGroup ;
	ADD PRIMARY KEY CashierGroupID TAG CsrGrpID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CashierGroup" ("Группы кассиров")
_WriteMetaInf(lcTargetDBPath,"CashierGroup","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CashierGroup","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CashierGroup","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CashierGroup","META-INF","INCR_FLD","CashierGroupID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CheckAttribute" ("Атрибуты чека")
CREATE TABLE (lcTargetDBPath+"CheckAttribute") ( ;
	CheckAttributeID I NOT NULL DEFAULT spIncrementID("CheckAttribute"), ;
	CheckAttributeNM C(40) NOT NULL ;
)
***
DBSETPROP("CheckAttribute","TABLE","COMMENT","Атрибуты чека")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Атрибуты чека"
CREATE TRIGGER ON CheckAttribute FOR INSERT AS _spTriggerExec("CheckAttribute","INSERT")
CREATE TRIGGER ON CheckAttribute FOR UPDATE AS _spTriggerExec("CheckAttribute","UPDATE")
CREATE TRIGGER ON CheckAttribute FOR DELETE AS _spTriggerExec("CheckAttribute","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CheckAttribute"
ALTER TABLE CheckAttribute ;
	ADD PRIMARY KEY CheckAttributeID TAG ChkAttrID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CheckAttribute" ("Атрибуты чека")
_WriteMetaInf(lcTargetDBPath,"CheckAttribute","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckAttribute","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckAttribute","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckAttribute","META-INF","INCR_FLD","CheckAttributeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CheckTransType" ("Тип транзакции чека")
CREATE TABLE (lcTargetDBPath+"CheckTransType") ( ;
	CheckTransTypeID I NOT NULL, ;
	CheckTransType C(40) NOT NULL, ;
	CheckTransTypeSign I NOT NULL, ;
	CheckTransTypeIsDisc L NOT NULL ;
)
***
DBSETPROP("CheckTransType","TABLE","COMMENT","Тип транзакции чека")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Тип транзакции чека"
CREATE TRIGGER ON CheckTransType FOR INSERT AS _spTriggerExec("CheckTransType","INSERT")
CREATE TRIGGER ON CheckTransType FOR UPDATE AS _spTriggerExec("CheckTransType","UPDATE")
CREATE TRIGGER ON CheckTransType FOR DELETE AS _spTriggerExec("CheckTransType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CheckTransType"
ALTER TABLE CheckTransType ;
	ADD PRIMARY KEY CheckTransTypeID TAG ChkTranTID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CheckTransType" ("Тип транзакции чека")
_WriteMetaInf(lcTargetDBPath,"CheckTransType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckTransType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckTransType","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CheckType" ("Тип чека")
CREATE TABLE (lcTargetDBPath+"CheckType") ( ;
	CheckTypeID I NOT NULL, ;
	CheckTypeNM C(40) NOT NULL, ;
	CheckTypeSign I NOT NULL, ;
	CheckTypeAborted L NOT NULL, ;
	CheckTypeMapCode I NOT NULL ;
)
***
DBSETPROP("CheckType","TABLE","COMMENT","Тип чека")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Тип чека"
CREATE TRIGGER ON CheckType FOR INSERT AS _spTriggerExec("CheckType","INSERT")
CREATE TRIGGER ON CheckType FOR UPDATE AS _spTriggerExec("CheckType","UPDATE")
CREATE TRIGGER ON CheckType FOR DELETE AS _spTriggerExec("CheckType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CheckType"
ALTER TABLE CheckType ;
	ADD PRIMARY KEY CheckTypeID TAG ChkTypeID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CheckType" ("Тип чека")
_WriteMetaInf(lcTargetDBPath,"CheckType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckType","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CltAddrType" ("Типы адресов")
CREATE TABLE (lcTargetDBPath+"CltAddrType") ( ;
	CltAddrTypeID I NOT NULL DEFAULT spIncrementID("CltAddrType"), ;
	CltAddrTypeNM C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("CltAddrType","TABLE","COMMENT","Типы адресов")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Типы адресов"
CREATE TRIGGER ON CltAddrType FOR INSERT AS _spTriggerExec("CltAddrType","INSERT")
CREATE TRIGGER ON CltAddrType FOR UPDATE AS _spTriggerExec("CltAddrType","UPDATE")
CREATE TRIGGER ON CltAddrType FOR DELETE AS _spTriggerExec("CltAddrType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CltAddrType"
ALTER TABLE CltAddrType ;
	ADD PRIMARY KEY CltAddrTypeID TAG AddrTypeID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CltAddrType" ("Типы адресов")
_WriteMetaInf(lcTargetDBPath,"CltAddrType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CltAddrType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CltAddrType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CltAddrType","META-INF","INCR_FLD","CltAddrTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CltBank" ("Банки")
CREATE TABLE (lcTargetDBPath+"CltBank") ( ;
	CltBankID I NOT NULL DEFAULT spIncrementID("CltBank"), ;
	CltBankBIK C(20) NOT NULL, ;
	CltBankKS C(20) NOT NULL, ;
	CltBankNM C(100) NOT NULL, ;
	CltBankAddr C(100) NOT NULL, ;
	CltBankIsSys L NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("CltBank","TABLE","COMMENT","Банки")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Банки"
CREATE TRIGGER ON CltBank FOR INSERT AS _spTriggerExec("CltBank","INSERT")
CREATE TRIGGER ON CltBank FOR UPDATE AS _spTriggerExec("CltBank","UPDATE")
CREATE TRIGGER ON CltBank FOR DELETE AS _spTriggerExec("CltBank","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CltBank"
ALTER TABLE CltBank ;
	ADD PRIMARY KEY CltBankID TAG CltBankID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CltBank" ("Банки")
_WriteMetaInf(lcTargetDBPath,"CltBank","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CltBank","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CltBank","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CltBank","META-INF","INCR_FLD","CltBankID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CltCountry" ("Страны")
CREATE TABLE (lcTargetDBPath+"CltCountry") ( ;
	CltCountryID I NOT NULL DEFAULT spIncrementID("CltCountry"), ;
	CltCountryNM C(40) NOT NULL, ;
	User_ I NOT NULL, ;
	Stamp_ T NOT NULL ;
)
***
DBSETPROP("CltCountry","TABLE","COMMENT","Страны")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Страны"
CREATE TRIGGER ON CltCountry FOR INSERT AS _spTriggerExec("CltCountry","INSERT")
CREATE TRIGGER ON CltCountry FOR UPDATE AS _spTriggerExec("CltCountry","UPDATE")
CREATE TRIGGER ON CltCountry FOR DELETE AS _spTriggerExec("CltCountry","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CltCountry"
ALTER TABLE CltCountry ;
	ADD PRIMARY KEY CltCountryID TAG CountryID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CltCountry" ("Страны")
_WriteMetaInf(lcTargetDBPath,"CltCountry","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CltCountry","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CltCountry","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CltCountry","META-INF","INCR_FLD","CltCountryID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CltLegalType" ("Организационно-правовая форма")
CREATE TABLE (lcTargetDBPath+"CltLegalType") ( ;
	CltLegalTypeID I NOT NULL DEFAULT spIncrementID("CltLegalType"), ;
	CltLegalTypeNM C(40) NOT NULL, ;
	CltLegalTypeAbbr C(20) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("CltLegalType","TABLE","COMMENT","Организационно-правовая форма")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Организационно-правовая форма"
CREATE TRIGGER ON CltLegalType FOR INSERT AS _spTriggerExec("CltLegalType","INSERT")
CREATE TRIGGER ON CltLegalType FOR UPDATE AS _spTriggerExec("CltLegalType","UPDATE")
CREATE TRIGGER ON CltLegalType FOR DELETE AS _spTriggerExec("CltLegalType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CltLegalType"
ALTER TABLE CltLegalType ;
	ADD PRIMARY KEY CltLegalTypeID TAG LegTypeID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CltLegalType" ("Организационно-правовая форма")
_WriteMetaInf(lcTargetDBPath,"CltLegalType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CltLegalType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CltLegalType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CltLegalType","META-INF","INCR_FLD","CltLegalTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CltRole" ("Роль клиента")
CREATE TABLE (lcTargetDBPath+"CltRole") ( ;
	CltRoleBit I NOT NULL DEFAULT spIncrementID("CltRole") CHECK BETWEEN(CltRoleBit,0,24) ERROR "Значение поля <Бит роли клиента> должно быть в дипазоне 0..24", ;
	CltRoleNM C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("CltRole","TABLE","COMMENT","Роль клиента")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Роль клиента"
CREATE TRIGGER ON CltRole FOR INSERT AS _spTriggerExec("CltRole","INSERT")
CREATE TRIGGER ON CltRole FOR UPDATE AS _spTriggerExec("CltRole","UPDATE")
CREATE TRIGGER ON CltRole FOR DELETE AS _spTriggerExec("CltRole","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CltRole"
ALTER TABLE CltRole ;
	ADD PRIMARY KEY CltRoleBit TAG CltRoleBit
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CltRole" ("Роль клиента")
_WriteMetaInf(lcTargetDBPath,"CltRole","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CltRole","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CltRole","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CltRole","META-INF","INCR_FLD","CltRoleBit")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CurType" ("Тип валюты")
CREATE TABLE (lcTargetDBPath+"CurType") ( ;
	CurTypeId I NOT NULL DEFAULT spIncrementID("CurType"), ;
	CurTypeNM C(40) NOT NULL, ;
	CurTypeStdNM C(40) NOT NULL, ;
	CurTypeHONText C(40) NOT NULL, ;
	CurTypeHOGText C(40) NOT NULL, ;
	CurTypeHMGText C(40) NOT NULL, ;
	CurTypeLONText C(40) NOT NULL, ;
	CurTypeLOGText C(40) NOT NULL, ;
	CurTypeLMGText C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("CurType","TABLE","COMMENT","Тип валюты")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Тип валюты"
CREATE TRIGGER ON CurType FOR INSERT AS _spTriggerExec("CurType","INSERT")
CREATE TRIGGER ON CurType FOR UPDATE AS _spTriggerExec("CurType","UPDATE")
CREATE TRIGGER ON CurType FOR DELETE AS _spTriggerExec("CurType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CurType"
ALTER TABLE CurType ;
	ADD PRIMARY KEY CurTypeId TAG CurTypeId
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CurType" ("Тип валюты")
_WriteMetaInf(lcTargetDBPath,"CurType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CurType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CurType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CurType","META-INF","INCR_FLD","CurTypeId")
*-------------------------------------------------------------------------------
*Action Is Creating Table "DiscType" ("DiscType")
CREATE TABLE (lcTargetDBPath+"DiscType") ( ;
	DiscTypeID I NOT NULL DEFAULT spIncrementID("DiscType"), ;
	DiscTypeNM C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("DiscType","TABLE","COMMENT","DiscType")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "DiscType"
CREATE TRIGGER ON DiscType FOR INSERT AS _spTriggerExec("DiscType","INSERT")
CREATE TRIGGER ON DiscType FOR UPDATE AS _spTriggerExec("DiscType","UPDATE")
CREATE TRIGGER ON DiscType FOR DELETE AS _spTriggerExec("DiscType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "DiscType"
ALTER TABLE DiscType ;
	ADD PRIMARY KEY DiscTypeID TAG DiscTypeID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "DiscType" ("DiscType")
_WriteMetaInf(lcTargetDBPath,"DiscType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"DiscType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"DiscType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"DiscType","META-INF","INCR_FLD","DiscTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmAttribute" ("Атрибуты документа")
CREATE TABLE (lcTargetDBPath+"FrmAttribute") ( ;
	FrmAttributeBit I NOT NULL DEFAULT spIncrementID("FrmAttribute") CHECK BETWEEN(FrmAttributeBit,0,24) ERROR "Значение поля <Бит атрибута документа> должно быть в дипазоне 0..24", ;
	FrmAttributeNM C(40) NOT NULL, ;
	User_ I NOT NULL, ;
	Stamp_ T NOT NULL ;
)
***
DBSETPROP("FrmAttribute","TABLE","COMMENT","Атрибуты документа")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Атрибуты документа"
CREATE TRIGGER ON FrmAttribute FOR INSERT AS _spTriggerExec("FrmAttribute","INSERT")
CREATE TRIGGER ON FrmAttribute FOR UPDATE AS _spTriggerExec("FrmAttribute","UPDATE")
CREATE TRIGGER ON FrmAttribute FOR DELETE AS _spTriggerExec("FrmAttribute","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "FrmAttribute"
ALTER TABLE FrmAttribute ;
	ADD PRIMARY KEY FrmAttributeBit TAG FrmAttrBit
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmAttribute" ("Атрибуты документа")
_WriteMetaInf(lcTargetDBPath,"FrmAttribute","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmAttribute","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmAttribute","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmAttribute","META-INF","INCR_FLD","FrmAttributeBit")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmStatus" ("Статус формы")
CREATE TABLE (lcTargetDBPath+"FrmStatus") ( ;
	FrmStatID I NOT NULL DEFAULT spIncrementID("FrmStatus"), ;
	FrmStatNM C(40) NOT NULL, ;
	FrmStatOrder I NOT NULL, ;
	FrmStatIsInvAcc L NOT NULL, ;
	FrmStatIsCostAcc L NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("FrmStatus","TABLE","COMMENT","Статус формы")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Статус формы"
CREATE TRIGGER ON FrmStatus FOR INSERT AS _spTriggerExec("FrmStatus","INSERT")
CREATE TRIGGER ON FrmStatus FOR UPDATE AS _spTriggerExec("FrmStatus","UPDATE")
CREATE TRIGGER ON FrmStatus FOR DELETE AS _spTriggerExec("FrmStatus","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "FrmStatus"
ALTER TABLE FrmStatus ;
	ADD PRIMARY KEY FrmStatID TAG FrmStatID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmStatus" ("Статус формы")
_WriteMetaInf(lcTargetDBPath,"FrmStatus","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmStatus","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmStatus","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmStatus","META-INF","INCR_FLD","FrmStatID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmSumSplitProc" ("Алгоритмы деления сумм")
CREATE TABLE (lcTargetDBPath+"FrmSumSplitProc") ( ;
	FrmSumSplitProcID I NOT NULL DEFAULT spIncrementID("FrmSumSplitProc"), ;
	FrmSumSplitProcNM C(40) NOT NULL, ;
	ProcedureNM C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("FrmSumSplitProc","TABLE","COMMENT","Алгоритмы деления сумм")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Алгоритмы деления сумм"
CREATE TRIGGER ON FrmSumSplitProc FOR INSERT AS _spTriggerExec("FrmSumSplitProc","INSERT")
CREATE TRIGGER ON FrmSumSplitProc FOR UPDATE AS _spTriggerExec("FrmSumSplitProc","UPDATE")
CREATE TRIGGER ON FrmSumSplitProc FOR DELETE AS _spTriggerExec("FrmSumSplitProc","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "FrmSumSplitProc"
ALTER TABLE FrmSumSplitProc ;
	ADD PRIMARY KEY FrmSumSplitProcID TAG SplitPrcID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmSumSplitProc" ("Алгоритмы деления сумм")
_WriteMetaInf(lcTargetDBPath,"FrmSumSplitProc","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmSumSplitProc","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmSumSplitProc","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmSumSplitProc","META-INF","INCR_FLD","FrmSumSplitProcID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Icons" ("Иконки (ICO)")
CREATE TABLE (lcTargetDBPath+"Icons") ( ;
	IcoID I NOT NULL DEFAULT spIncrementID("Icons"), ;
	IcoFileNM C(20) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("Icons","TABLE","COMMENT","Иконки (ICO)")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Иконки (ICO)"
CREATE TRIGGER ON Icons FOR INSERT AS _spTriggerExec("Icons","INSERT")
CREATE TRIGGER ON Icons FOR UPDATE AS _spTriggerExec("Icons","UPDATE")
CREATE TRIGGER ON Icons FOR DELETE AS _spTriggerExec("Icons","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Icons"
ALTER TABLE Icons ;
	ADD PRIMARY KEY IcoID TAG IcoID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Icons" ("Иконки (ICO)")
_WriteMetaInf(lcTargetDBPath,"Icons","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Icons","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Icons","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"Icons","META-INF","INCR_FLD","IcoID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "MsuType" ("Типы единиц измерения")
CREATE TABLE (lcTargetDBPath+"MsuType") ( ;
	MsuTypeID I NOT NULL, ;
	MsuTypeName C(40) NOT NULL ;
)
***
DBSETPROP("MsuType","TABLE","COMMENT","Типы единиц измерения")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Типы единиц измерения"
CREATE TRIGGER ON MsuType FOR INSERT AS _spTriggerExec("MsuType","INSERT")
CREATE TRIGGER ON MsuType FOR UPDATE AS _spTriggerExec("MsuType","UPDATE")
CREATE TRIGGER ON MsuType FOR DELETE AS _spTriggerExec("MsuType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "MsuType"
ALTER TABLE MsuType ;
	ADD PRIMARY KEY MsuTypeID TAG MsuTypeID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "MsuType" ("Типы единиц измерения")
_WriteMetaInf(lcTargetDBPath,"MsuType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"MsuType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"MsuType","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "ObjectFunction" ("Функции объектов-разрешений")
CREATE TABLE (lcTargetDBPath+"ObjectFunction") ( ;
	ObjectFunctionID I NOT NULL DEFAULT spIncrementID("ObjectFunction"), ;
	ObjectFunctionNM C(40) NOT NULL, ;
	ObjectFunctionDesc C(60) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("ObjectFunction","TABLE","COMMENT","Функции объектов-разрешений")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Функции объектов-разрешений"
CREATE TRIGGER ON ObjectFunction FOR INSERT AS _spTriggerExec("ObjectFunction","INSERT")
CREATE TRIGGER ON ObjectFunction FOR UPDATE AS _spTriggerExec("ObjectFunction","UPDATE")
CREATE TRIGGER ON ObjectFunction FOR DELETE AS _spTriggerExec("ObjectFunction","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "ObjectFunction"
ALTER TABLE ObjectFunction ;
	ADD PRIMARY KEY ObjectFunctionID TAG ObjFuncID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "ObjectFunction" ("Функции объектов-разрешений")
_WriteMetaInf(lcTargetDBPath,"ObjectFunction","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"ObjectFunction","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"ObjectFunction","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"ObjectFunction","META-INF","INCR_FLD","ObjectFunctionID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "ObjectType" ("Тип объектов-разрешений")
CREATE TABLE (lcTargetDBPath+"ObjectType") ( ;
	ObjectTypeID I NOT NULL DEFAULT spIncrementID("ObjectType"), ;
	ObjectTypeNM C(40) NOT NULL, ;
	TableNM C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL, ;
	FieldNM C(40) NOT NULL, ;
	FieldId C(40) NOT NULL, ;
	FieldDesc C(40) NOT NULL ;
)
***
DBSETPROP("ObjectType","TABLE","COMMENT","Тип объектов-разрешений")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Тип объектов-разрешений"
CREATE TRIGGER ON ObjectType FOR INSERT AS _spTriggerExec("ObjectType","INSERT")
CREATE TRIGGER ON ObjectType FOR UPDATE AS _spTriggerExec("ObjectType","UPDATE")
CREATE TRIGGER ON ObjectType FOR DELETE AS _spTriggerExec("ObjectType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "ObjectType"
ALTER TABLE ObjectType ;
	ADD PRIMARY KEY ObjectTypeID TAG ObjTypeID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "ObjectType" ("Тип объектов-разрешений")
_WriteMetaInf(lcTargetDBPath,"ObjectType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"ObjectType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"ObjectType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"ObjectType","META-INF","INCR_FLD","ObjectTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "OUType" ("Тип орг единиц")
CREATE TABLE (lcTargetDBPath+"OUType") ( ;
	OUTypeID I NOT NULL DEFAULT spIncrementID("OUType"), ;
	OUTypeNM C(40) NOT NULL, ;
	OUTypeObjDesc C(60) NOT NULL, ;
	OUTypeLink C(60) NOT NULL, ;
	OUTypeNote C(100) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("OUType","TABLE","COMMENT","Тип орг единиц")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Тип орг единиц"
CREATE TRIGGER ON OUType FOR INSERT AS _spTriggerExec("OUType","INSERT")
CREATE TRIGGER ON OUType FOR UPDATE AS _spTriggerExec("OUType","UPDATE")
CREATE TRIGGER ON OUType FOR DELETE AS _spTriggerExec("OUType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "OUType"
ALTER TABLE OUType ;
	ADD PRIMARY KEY OUTypeID TAG OUTypeID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "OUType" ("Тип орг единиц")
_WriteMetaInf(lcTargetDBPath,"OUType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"OUType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"OUType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"OUType","META-INF","INCR_FLD","OUTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "POSFunc" ("Функции POS")
CREATE TABLE (lcTargetDBPath+"POSFunc") ( ;
	POSFuncID I NOT NULL DEFAULT spIncrementID("POSFunc"), ;
	POSFuncNM C(40) NOT NULL, ;
	POSFuncMsg C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("POSFunc","TABLE","COMMENT","Функции POS")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Функции POS"
CREATE TRIGGER ON POSFunc FOR INSERT AS _spTriggerExec("POSFunc","INSERT")
CREATE TRIGGER ON POSFunc FOR UPDATE AS _spTriggerExec("POSFunc","UPDATE")
CREATE TRIGGER ON POSFunc FOR DELETE AS _spTriggerExec("POSFunc","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "POSFunc"
ALTER TABLE POSFunc ;
	ADD PRIMARY KEY POSFuncID TAG POSFuncID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "POSFunc" ("Функции POS")
_WriteMetaInf(lcTargetDBPath,"POSFunc","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"POSFunc","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"POSFunc","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"POSFunc","META-INF","INCR_FLD","POSFuncID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "POSFuncSet" ("Наборы функций POS")
CREATE TABLE (lcTargetDBPath+"POSFuncSet") ( ;
	POSFuncSetID I NOT NULL DEFAULT spIncrementID("POSFuncSet"), ;
	POSFuncSetNM C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("POSFuncSet","TABLE","COMMENT","Наборы функций POS")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Наборы функций POS"
CREATE TRIGGER ON POSFuncSet FOR INSERT AS _spTriggerExec("POSFuncSet","INSERT")
CREATE TRIGGER ON POSFuncSet FOR UPDATE AS _spTriggerExec("POSFuncSet","UPDATE")
CREATE TRIGGER ON POSFuncSet FOR DELETE AS _spTriggerExec("POSFuncSet","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "POSFuncSet"
ALTER TABLE POSFuncSet ;
	ADD PRIMARY KEY POSFuncSetID TAG SetID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "POSFuncSet" ("Наборы функций POS")
_WriteMetaInf(lcTargetDBPath,"POSFuncSet","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"POSFuncSet","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"POSFuncSet","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"POSFuncSet","META-INF","INCR_FLD","POSFuncSetID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "POSLinkObjType" ("Типы связанных объектов")
CREATE TABLE (lcTargetDBPath+"POSLinkObjType") ( ;
	POSLinkObjTypeID I NOT NULL DEFAULT spIncrementID("POSLinkObjType"), ;
	POSLinkObjTypeNM C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("POSLinkObjType","TABLE","COMMENT","Типы связанных объектов")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Типы связанных объектов"
CREATE TRIGGER ON POSLinkObjType FOR INSERT AS _spTriggerExec("POSLinkObjType","INSERT")
CREATE TRIGGER ON POSLinkObjType FOR UPDATE AS _spTriggerExec("POSLinkObjType","UPDATE")
CREATE TRIGGER ON POSLinkObjType FOR DELETE AS _spTriggerExec("POSLinkObjType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "POSLinkObjType"
ALTER TABLE POSLinkObjType ;
	ADD PRIMARY KEY POSLinkObjTypeID TAG LinkOTID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "POSLinkObjType" ("Типы связанных объектов")
_WriteMetaInf(lcTargetDBPath,"POSLinkObjType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"POSLinkObjType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"POSLinkObjType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"POSLinkObjType","META-INF","INCR_FLD","POSLinkObjTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "RptFrmTemplate" ("Шаблоны печатных представлений")
CREATE TABLE (lcTargetDBPath+"RptFrmTemplate") ( ;
	RptFrmTemplateID I NOT NULL DEFAULT spIncrementID("RptFrmTemplate"), ;
	RptFrmTemplateNM C(40) NOT NULL, ;
	RptFrmTemplateFRX M NOT NULL, ;
	RptFrmTemplateFRT M NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("RptFrmTemplate","TABLE","COMMENT","Шаблоны печатных представлений")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Шаблоны печатных представлений"
CREATE TRIGGER ON RptFrmTemplate FOR INSERT AS _spTriggerExec("RptFrmTemplate","INSERT")
CREATE TRIGGER ON RptFrmTemplate FOR UPDATE AS _spTriggerExec("RptFrmTemplate","UPDATE")
CREATE TRIGGER ON RptFrmTemplate FOR DELETE AS _spTriggerExec("RptFrmTemplate","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "RptFrmTemplate"
ALTER TABLE RptFrmTemplate ;
	ADD PRIMARY KEY RptFrmTemplateID TAG RptFrmTpID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "RptFrmTemplate" ("Шаблоны печатных представлений")
_WriteMetaInf(lcTargetDBPath,"RptFrmTemplate","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"RptFrmTemplate","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"RptFrmTemplate","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"RptFrmTemplate","META-INF","INCR_FLD","RptFrmTemplateID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "SalesLog" ("Загруженные данные о продажах")
CREATE TABLE (lcTargetDBPath+"SalesLog") ( ;
	SalesLogID I NOT NULL DEFAULT spIncrementID("SalesLog"), ;
	Stamp T NOT NULL, ;
	IDC M NOT NULL, ;
	IDCFileSize I NOT NULL, ;
	JRN M NOT NULL, ;
	JRNFileSize I NOT NULL, ;
	StampOpenDay T NOT NULL, ;
	EOD L NOT NULL ;
)
***
DBSETPROP("SalesLog","TABLE","COMMENT","Загруженные данные о продажах")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Загруженные данные о продажах"
CREATE TRIGGER ON SalesLog FOR INSERT AS _spTriggerExec("SalesLog","INSERT")
CREATE TRIGGER ON SalesLog FOR UPDATE AS _spTriggerExec("SalesLog","UPDATE")
CREATE TRIGGER ON SalesLog FOR DELETE AS _spTriggerExec("SalesLog","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "SalesLog"
ALTER TABLE SalesLog ;
	ADD PRIMARY KEY SalesLogID TAG SalesLogID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "SalesLog" ("Загруженные данные о продажах")
_WriteMetaInf(lcTargetDBPath,"SalesLog","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"SalesLog","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"SalesLog","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"SalesLog","META-INF","INCR_FLD","SalesLogID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "ScrFrmGrp" ("Группы экранных форм")
CREATE TABLE (lcTargetDBPath+"ScrFrmGrp") ( ;
	ScrFrmGrpID I NOT NULL DEFAULT spIncrementID("ScrFrmGrp"), ;
	ScrFrmGrpNM C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("ScrFrmGrp","TABLE","COMMENT","Группы экранных форм")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Группы экранных форм"
CREATE TRIGGER ON ScrFrmGrp FOR INSERT AS _spTriggerExec("ScrFrmGrp","INSERT")
CREATE TRIGGER ON ScrFrmGrp FOR UPDATE AS _spTriggerExec("ScrFrmGrp","UPDATE")
CREATE TRIGGER ON ScrFrmGrp FOR DELETE AS _spTriggerExec("ScrFrmGrp","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "ScrFrmGrp"
ALTER TABLE ScrFrmGrp ;
	ADD PRIMARY KEY ScrFrmGrpID TAG ScrFrmGID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "ScrFrmGrp" ("Группы экранных форм")
_WriteMetaInf(lcTargetDBPath,"ScrFrmGrp","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmGrp","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmGrp","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmGrp","META-INF","INCR_FLD","ScrFrmGrpID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Sprav" ("Справочник")
CREATE TABLE (lcTargetDBPath+"Sprav") ( ;
	SprID I NOT NULL DEFAULT spIncrementID("Sprav"), ;
	SprNM C(40) NOT NULL, ;
	SprDBObjectNM C(40) NOT NULL, ;
	SprNote C(100) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("Sprav","TABLE","COMMENT","Справочник")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Справочник"
CREATE TRIGGER ON Sprav FOR INSERT AS _spTriggerExec("Sprav","INSERT")
CREATE TRIGGER ON Sprav FOR UPDATE AS _spTriggerExec("Sprav","UPDATE")
CREATE TRIGGER ON Sprav FOR DELETE AS _spTriggerExec("Sprav","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Sprav"
ALTER TABLE Sprav ;
	ADD PRIMARY KEY SprID TAG SprID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Sprav" ("Справочник")
_WriteMetaInf(lcTargetDBPath,"Sprav","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Sprav","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Sprav","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"Sprav","META-INF","INCR_FLD","SprID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "StockTransType" ("Типы товарных операций")
CREATE TABLE (lcTargetDBPath+"StockTransType") ( ;
	StockTransTypeID I NOT NULL DEFAULT spIncrementID("StockTransType"), ;
	StockTransTypeNM C(40) NOT NULL, ;
	StockTransTypeAccProcNM C(40) NOT NULL, ;
	StockTransTypePriority I NOT NULL ;
)
***
DBSETPROP("StockTransType","TABLE","COMMENT","Типы товарных операций")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Типы товарных операций"
CREATE TRIGGER ON StockTransType FOR INSERT AS _spTriggerExec("StockTransType","INSERT")
CREATE TRIGGER ON StockTransType FOR UPDATE AS _spTriggerExec("StockTransType","UPDATE")
CREATE TRIGGER ON StockTransType FOR DELETE AS _spTriggerExec("StockTransType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "StockTransType"
ALTER TABLE StockTransType ;
	ADD PRIMARY KEY StockTransTypeID TAG StockTTID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "StockTransType" ("Типы товарных операций")
_WriteMetaInf(lcTargetDBPath,"StockTransType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"StockTransType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"StockTransType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"StockTransType","META-INF","INCR_FLD","StockTransTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "TvrSetType" ("Тип набора товаров")
CREATE TABLE (lcTargetDBPath+"TvrSetType") ( ;
	TvrSetTypeID I NOT NULL DEFAULT spIncrementID("TvrSetType"), ;
	TvrSetTypeNM C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("TvrSetType","TABLE","COMMENT","Тип набора товаров")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Тип набора товаров"
CREATE TRIGGER ON TvrSetType FOR INSERT AS _spTriggerExec("TvrSetType","INSERT")
CREATE TRIGGER ON TvrSetType FOR UPDATE AS _spTriggerExec("TvrSetType","UPDATE")
CREATE TRIGGER ON TvrSetType FOR DELETE AS _spTriggerExec("TvrSetType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "TvrSetType"
ALTER TABLE TvrSetType ;
	ADD PRIMARY KEY TvrSetTypeID TAG TvrSetTID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "TvrSetType" ("Тип набора товаров")
_WriteMetaInf(lcTargetDBPath,"TvrSetType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrSetType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrSetType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrSetType","META-INF","INCR_FLD","TvrSetTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "TypePayFsc" ("TypePayFsc")
CREATE TABLE (lcTargetDBPath+"TypePayFsc") ( ;
	TypePayFscID I NOT NULL DEFAULT spIncrementID("TypePayFsc"), ;
	TypePayFscNM C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("TypePayFsc","TABLE","COMMENT","TypePayFsc")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "TypePayFsc"
CREATE TRIGGER ON TypePayFsc FOR INSERT AS _spTriggerExec("TypePayFsc","INSERT")
CREATE TRIGGER ON TypePayFsc FOR UPDATE AS _spTriggerExec("TypePayFsc","UPDATE")
CREATE TRIGGER ON TypePayFsc FOR DELETE AS _spTriggerExec("TypePayFsc","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "TypePayFsc"
ALTER TABLE TypePayFsc ;
	ADD PRIMARY KEY TypePayFscID TAG TPFscID
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "TypePayFsc" ("TypePayFsc")
_WriteMetaInf(lcTargetDBPath,"TypePayFsc","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"TypePayFsc","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"TypePayFsc","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"TypePayFsc","META-INF","INCR_FLD","TypePayFscID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Discount" ("Скидки")
CREATE TABLE (lcTargetDBPath+"Discount") ( ;
	DiscID I NOT NULL DEFAULT spIncrementID("Discount"), ;
	DiscTypeID I NOT NULL, ;
	DiscNM C(40) NOT NULL, ;
	DiscRate N(6,2) NOT NULL, ;
	DiscIsSystem L NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("Discount","TABLE","COMMENT","Скидки")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Скидки"
CREATE TRIGGER ON Discount FOR INSERT AS _spTriggerExec("Discount","INSERT")
CREATE TRIGGER ON Discount FOR UPDATE AS _spTriggerExec("Discount","UPDATE")
CREATE TRIGGER ON Discount FOR DELETE AS _spTriggerExec("Discount","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Discount"
ALTER TABLE Discount ;
	ADD PRIMARY KEY DiscID TAG DiscID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Discount"
ALTER TABLE Discount ;
	ADD FOREIGN KEY DiscTypeID TAG DiscTypeID ;
	REFERENCES DiscType TAG DiscTypeID
***
_RIRuleWrite("Discount", "DiscTypeID", "DiscType", "DiscTypeID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Discount" ("Скидки")
_WriteMetaInf(lcTargetDBPath,"Discount","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Discount","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Discount","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"Discount","META-INF","INCR_FLD","DiscID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "_OperationLog" ("Лог операций над справочниками")
CREATE TABLE (lcTargetDBPath+"_OperationLog") ( ;
	OperationID I NOT NULL DEFAULT spIncrementID("_OperationLog"), ;
	LocalSpravID I NOT NULL, ;
	OperationType C(1) NOT NULL, ;
	RecordID I NOT NULL ;
)
***
DBSETPROP("_OperationLog","TABLE","COMMENT","Лог операций над справочниками")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Лог операций над справочниками"
CREATE TRIGGER ON _OperationLog FOR INSERT AS _spTriggerExec("_OperationLog","INSERT","_spLastOperationUpdate()")
CREATE TRIGGER ON _OperationLog FOR UPDATE AS _spTriggerExec("_OperationLog","UPDATE")
CREATE TRIGGER ON _OperationLog FOR DELETE AS _spTriggerExec("_OperationLog","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "_OperationLog"
ALTER TABLE _OperationLog ;
	ADD PRIMARY KEY OperationID TAG OperID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "_OperationLog"
ALTER TABLE _OperationLog ;
	ADD FOREIGN KEY LocalSpravID TAG LSID ;
	REFERENCES _LocalSprav TAG LSID
***
_RIRuleWrite("_OperationLog", "LSID", "_LocalSprav", "LSID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "_OperationLog" ("Лог операций над справочниками")
_WriteMetaInf(lcTargetDBPath,"_OperationLog","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"_OperationLog","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"_OperationLog","META-INF","AUTOINCREMENT","No")
_WriteMetaInf(lcTargetDBPath,"_OperationLog","META-INF","INCR_FLD","OperationID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CltType" ("Типы клиентов")
CREATE TABLE (lcTargetDBPath+"CltType") ( ;
	CltTypeID I NOT NULL DEFAULT spIncrementID("CltType"), ;
	CltTypeNM C(40) NOT NULL, ;
	CltTypeIsCnt L NOT NULL, ;
	CltTypeObjDesc C(60) NOT NULL, ;
	BmpID I NOT NULL, ;
	SelBmpID I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("CltType","TABLE","COMMENT","Типы клиентов")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Типы клиентов"
CREATE TRIGGER ON CltType FOR INSERT AS _spTriggerExec("CltType","INSERT",1)
CREATE TRIGGER ON CltType FOR UPDATE AS _spTriggerExec("CltType","UPDATE")
CREATE TRIGGER ON CltType FOR DELETE AS _spTriggerExec("CltType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CltType"
ALTER TABLE CltType ;
	ADD PRIMARY KEY CltTypeID TAG CltTypeID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CltType"
ALTER TABLE CltType ;
	ADD FOREIGN KEY BmpID TAG BmpID ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("CltType", "BmpID", "Bitmaps", "TestTag", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CltType"
ALTER TABLE CltType ;
	ADD FOREIGN KEY SelBmpID TAG SelBmpID ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("CltType", "SelBmpID", "Bitmaps", "TestTag", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CltType" ("Типы клиентов")
_WriteMetaInf(lcTargetDBPath,"CltType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CltType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CltType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CltType","META-INF","INCR_FLD","CltTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CheckPaymentType" ("Тип оплаты")
CREATE TABLE (lcTargetDBPath+"CheckPaymentType") ( ;
	CheckPaymentTypeID I NOT NULL, ;
	CheckPaymentTypeNM C(40) NOT NULL, ;
	CheckPaymentTypeMapCode I NULL, ;
	TypePayFscID I NULL, ;
	CheckPaymentTypeRate Y NOT NULL, ;
	CheckPaymentTypeObjDesc C(40) NULL ;
)
***
DBSETPROP("CheckPaymentType","TABLE","COMMENT","Тип оплаты")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Тип оплаты"
CREATE TRIGGER ON CheckPaymentType FOR INSERT AS _spTriggerExec("CheckPaymentType","INSERT")
CREATE TRIGGER ON CheckPaymentType FOR UPDATE AS _spTriggerExec("CheckPaymentType","UPDATE")
CREATE TRIGGER ON CheckPaymentType FOR DELETE AS _spTriggerExec("CheckPaymentType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CheckPaymentType"
ALTER TABLE CheckPaymentType ;
	ADD PRIMARY KEY CheckPaymentTypeID TAG ChkPayTID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CheckPaymentType"
ALTER TABLE CheckPaymentType ;
	ADD FOREIGN KEY TypePayFscID TAG TPFscID ;
	REFERENCES TypePayFsc TAG TPFscID
***
_RIRuleWrite("CheckPaymentType", "TPFscID", "TypePayFsc", "TPFscID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CheckPaymentType" ("Тип оплаты")
_WriteMetaInf(lcTargetDBPath,"CheckPaymentType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckPaymentType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckPaymentType","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "POSFuncInSet" ("Функции POS в наборах функций")
CREATE TABLE (lcTargetDBPath+"POSFuncInSet") ( ;
	POSFuncInSetID I NOT NULL DEFAULT spIncrementID("POSFuncInSet"), ;
	POSFuncID I NOT NULL, ;
	POSFuncSetID I NOT NULL, ;
	POSFuncInSetOrder I NOT NULL, ;
	POSLinkObjTypeID I NULL, ;
	POSFuncInSetLinkObj I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("POSFuncInSet","TABLE","COMMENT","Функции POS в наборах функций")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Функции POS в наборах функций"
CREATE TRIGGER ON POSFuncInSet FOR INSERT AS _spTriggerExec("POSFuncInSet","INSERT")
CREATE TRIGGER ON POSFuncInSet FOR UPDATE AS _spTriggerExec("POSFuncInSet","UPDATE")
CREATE TRIGGER ON POSFuncInSet FOR DELETE AS _spTriggerExec("POSFuncInSet","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "POSFuncInSet"
ALTER TABLE POSFuncInSet ;
	ADD PRIMARY KEY POSFuncInSetID TAG PFSID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "POSFuncInSet"
ALTER TABLE POSFuncInSet ;
	ADD FOREIGN KEY POSFuncID TAG POSFuncID ;
	REFERENCES POSFunc TAG POSFuncID
***
_RIRuleWrite("POSFuncInSet", "POSFuncID", "POSFunc", "POSFuncID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "POSFuncInSet"
ALTER TABLE POSFuncInSet ;
	ADD FOREIGN KEY POSFuncSetID TAG SetID ;
	REFERENCES POSFuncSet TAG SetID
***
_RIRuleWrite("POSFuncInSet", "SetID", "POSFuncSet", "SetID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "POSFuncInSet"
ALTER TABLE POSFuncInSet ;
	ADD FOREIGN KEY POSLinkObjTypeID TAG LinkOTID ;
	REFERENCES POSLinkObjType TAG LinkOTID
***
_RIRuleWrite("POSFuncInSet", "LinkOTID", "POSLinkObjType", "LinkOTID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "POSFuncInSet" ("Функции POS в наборах функций")
_WriteMetaInf(lcTargetDBPath,"POSFuncInSet","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"POSFuncInSet","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"POSFuncInSet","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"POSFuncInSet","META-INF","INCR_FLD","POSFuncInSetID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "PrcType" ("Тип прайса")
CREATE TABLE (lcTargetDBPath+"PrcType") ( ;
	PrcTypeId I NOT NULL DEFAULT spIncrementID("PrcType"), ;
	CurTypeId I NOT NULL, ;
	PrcTypeNM C(40) NOT NULL, ;
	PrcTypeIsDef L NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("PrcType","TABLE","COMMENT","Тип прайса")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Тип прайса"
CREATE TRIGGER ON PrcType FOR INSERT AS _spTriggerExec("PrcType","INSERT")
CREATE TRIGGER ON PrcType FOR UPDATE AS _spTriggerExec("PrcType","UPDATE")
CREATE TRIGGER ON PrcType FOR DELETE AS _spTriggerExec("PrcType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "PrcType"
ALTER TABLE PrcType ;
	ADD PRIMARY KEY PrcTypeId TAG PrcTypeId
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "PrcType"
ALTER TABLE PrcType ;
	ADD FOREIGN KEY CurTypeId TAG CurTypeId ;
	REFERENCES CurType TAG CurTypeId
***
_RIRuleWrite("PrcType", "CurTypeId", "CurType", "CurTypeId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "PrcType" ("Тип прайса")
_WriteMetaInf(lcTargetDBPath,"PrcType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"PrcType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"PrcType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"PrcType","META-INF","INCR_FLD","PrcTypeId")
*-------------------------------------------------------------------------------
*Action Is Creating Table "MeasureUnit" ("Единицы измерения")
CREATE TABLE (lcTargetDBPath+"MeasureUnit") ( ;
	MsuId I NOT NULL DEFAULT spIncrementID("MeasureUnit"), ;
	MsuType I NOT NULL, ;
	MsuNM C(40) NOT NULL, ;
	MsuShortNM C(40) NOT NULL, ;
	BaseMsuID I NULL, ;
	MsuQnt N(10,3) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL, ;
	CHECK _spRecordValidationRule("MsuID","MsuNM") ERROR "Нарушена уникальность записи в таблице MeasureUnit" ;
)
***
DBSETPROP("MeasureUnit","TABLE","COMMENT","Единицы измерения")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Единицы измерения"
CREATE TRIGGER ON MeasureUnit FOR INSERT AS _spTriggerExec("MeasureUnit","INSERT")
CREATE TRIGGER ON MeasureUnit FOR UPDATE AS _spTriggerExec("MeasureUnit","UPDATE","spMsuUpdate()")
CREATE TRIGGER ON MeasureUnit FOR DELETE AS _spTriggerExec("MeasureUnit","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "MeasureUnit"
ALTER TABLE MeasureUnit ;
	ADD PRIMARY KEY MsuId TAG MsuId
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "MeasureUnit"
ALTER TABLE MeasureUnit ;
	ADD FOREIGN KEY BaseMsuID TAG BaseMsuID ;
	REFERENCES MeasureUnit TAG MsuId
***
_RIRuleWrite("MeasureUnit", "BaseMsuID", "MeasureUnit", "MsuId", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "MeasureUnit"
ALTER TABLE MeasureUnit ;
	ADD FOREIGN KEY MsuType TAG MsuType ;
	REFERENCES MsuType TAG MsuTypeID
***
_RIRuleWrite("MeasureUnit", "MsuType", "MsuType", "MsuTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "MeasureUnit" ("Единицы измерения")
_WriteMetaInf(lcTargetDBPath,"MeasureUnit","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"MeasureUnit","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"MeasureUnit","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"MeasureUnit","META-INF","INCR_FLD","MsuId")
*-------------------------------------------------------------------------------
*Action Is Creating Table "QryParType" ("Типы параметров выборки")
CREATE TABLE (lcTargetDBPath+"QryParType") ( ;
	QryParTypeID I NOT NULL DEFAULT spIncrementID("QryParType"), ;
	QryParTypeNM C(40) NOT NULL, ;
	QryParTypeObjDesc C(60) NOT NULL, ;
	BmpID I NOT NULL, ;
	SelBmpId I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("QryParType","TABLE","COMMENT","Типы параметров выборки")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Типы параметров выборки"
CREATE TRIGGER ON QryParType FOR INSERT AS _spTriggerExec("QryParType","INSERT")
CREATE TRIGGER ON QryParType FOR UPDATE AS _spTriggerExec("QryParType","UPDATE")
CREATE TRIGGER ON QryParType FOR DELETE AS _spTriggerExec("QryParType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "QryParType"
ALTER TABLE QryParType ;
	ADD PRIMARY KEY QryParTypeID TAG QPTypeID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "QryParType"
ALTER TABLE QryParType ;
	ADD FOREIGN KEY BmpID TAG BmpID ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("QryParType", "BmpID", "Bitmaps", "TestTag", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "QryParType"
ALTER TABLE QryParType ;
	ADD FOREIGN KEY SelBmpId TAG SelBmpId ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("QryParType", "SelBmpId", "Bitmaps", "TestTag", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "QryParType" ("Типы параметров выборки")
_WriteMetaInf(lcTargetDBPath,"QryParType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"QryParType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"QryParType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"QryParType","META-INF","INCR_FLD","QryParTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "ScreenForm" ("Экранная форма")
CREATE TABLE (lcTargetDBPath+"ScreenForm") ( ;
	ScrFrmID I NOT NULL DEFAULT spIncrementID("ScreenForm"), ;
	ScrFrmGrpID I NOT NULL, ;
	ScrFrmNM C(40) NOT NULL, ;
	ScrFrmObjDesc C(60) NOT NULL, ;
	ScrFrmIsOnToolBar L NOT NULL, ;
	ScrFrmToolBarIdx I NULL, ;
	BmpId I NOT NULL, ;
	IcoID I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("ScreenForm","TABLE","COMMENT","Экранная форма")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Экранная форма"
CREATE TRIGGER ON ScreenForm FOR INSERT AS _spTriggerExec("ScreenForm","INSERT")
CREATE TRIGGER ON ScreenForm FOR UPDATE AS _spTriggerExec("ScreenForm","UPDATE")
CREATE TRIGGER ON ScreenForm FOR DELETE AS _spTriggerExec("ScreenForm","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "ScreenForm"
ALTER TABLE ScreenForm ;
	ADD PRIMARY KEY ScrFrmID TAG ScrFrmID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "ScreenForm"
ALTER TABLE ScreenForm ;
	ADD FOREIGN KEY BmpId TAG BmpId ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("ScreenForm", "BmpId", "Bitmaps", "TestTag", "CRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "ScreenForm"
ALTER TABLE ScreenForm ;
	ADD FOREIGN KEY IcoID TAG IcoID ;
	REFERENCES Icons TAG IcoID
***
_RIRuleWrite("ScreenForm", "IcoID", "Icons", "IcoID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "ScreenForm"
ALTER TABLE ScreenForm ;
	ADD FOREIGN KEY ScrFrmGrpID TAG ScrFrmGID ;
	REFERENCES ScrFrmGrp TAG ScrFrmGID
***
_RIRuleWrite("ScreenForm", "ScrFrmGID", "ScrFrmGrp", "ScrFrmGID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "ScreenForm" ("Экранная форма")
_WriteMetaInf(lcTargetDBPath,"ScreenForm","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"ScreenForm","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"ScreenForm","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"ScreenForm","META-INF","INCR_FLD","ScrFrmID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CustomFunc" ("Дополнительные функции")
CREATE TABLE (lcTargetDBPath+"CustomFunc") ( ;
	CstFuncID I NOT NULL DEFAULT spIncrementID("CustomFunc"), ;
	CstFuncNM C(40) NOT NULL, ;
	BmpId I NOT NULL, ;
	CstFuncMsg C(20) NOT NULL ;
)
***
DBSETPROP("CustomFunc","TABLE","COMMENT","Дополнительные функции")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Дополнительные функции"
CREATE TRIGGER ON CustomFunc FOR INSERT AS _spTriggerExec("CustomFunc","INSERT")
CREATE TRIGGER ON CustomFunc FOR UPDATE AS _spTriggerExec("CustomFunc","UPDATE")
CREATE TRIGGER ON CustomFunc FOR DELETE AS _spTriggerExec("CustomFunc","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CustomFunc"
ALTER TABLE CustomFunc ;
	ADD PRIMARY KEY CstFuncID TAG CustFuncID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CustomFunc"
ALTER TABLE CustomFunc ;
	ADD FOREIGN KEY BmpId TAG BmpId ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("CustomFunc", "BmpId", "Bitmaps", "TestTag", "CRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CustomFunc" ("Дополнительные функции")
_WriteMetaInf(lcTargetDBPath,"CustomFunc","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CustomFunc","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CustomFunc","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CustomFunc","META-INF","INCR_FLD","CstFuncID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "RptType" ("Типы отчетов")
CREATE TABLE (lcTargetDBPath+"RptType") ( ;
	RptTypeID I NOT NULL DEFAULT spIncrementID("RptType"), ;
	RptTypeNM C(40) NOT NULL, ;
	RptTypeIsCnt L NOT NULL, ;
	RptTypeObjDesc C(60) NOT NULL, ;
	BmpID I NOT NULL, ;
	SelBmpId I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("RptType","TABLE","COMMENT","Типы отчетов")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Типы отчетов"
CREATE TRIGGER ON RptType FOR INSERT AS _spTriggerExec("RptType","INSERT")
CREATE TRIGGER ON RptType FOR UPDATE AS _spTriggerExec("RptType","UPDATE")
CREATE TRIGGER ON RptType FOR DELETE AS _spTriggerExec("RptType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "RptType"
ALTER TABLE RptType ;
	ADD PRIMARY KEY RptTypeID TAG RptTypeID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "RptType"
ALTER TABLE RptType ;
	ADD FOREIGN KEY BmpID TAG BmpID ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("RptType", "BmpID", "Bitmaps", "TestTag", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "RptType"
ALTER TABLE RptType ;
	ADD FOREIGN KEY SelBmpId TAG SelBmpId ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("RptType", "SelBmpId", "Bitmaps", "TestTag", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "RptType" ("Типы отчетов")
_WriteMetaInf(lcTargetDBPath,"RptType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"RptType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"RptType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"RptType","META-INF","INCR_FLD","RptTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "_LocalSpravIndex" ("Индексы локальных справочников")
CREATE TABLE (lcTargetDBPath+"_LocalSpravIndex") ( ;
	LSIndexID I NOT NULL DEFAULT spIncrementID("_LocalSpravIndex"), ;
	LocalSpravID I NOT NULL, ;
	LSIndexNM C(40) NOT NULL, ;
	LSIndexFields C(40) NOT NULL, ;
	LSIndexExpr C(40) NOT NULL ;
)
***
DBSETPROP("_LocalSpravIndex","TABLE","COMMENT","Индексы локальных справочников")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Индексы локальных справочников"
CREATE TRIGGER ON _LocalSpravIndex FOR INSERT AS _spTriggerExec("_LocalSpravIndex","INSERT")
CREATE TRIGGER ON _LocalSpravIndex FOR UPDATE AS _spTriggerExec("_LocalSpravIndex","UPDATE")
CREATE TRIGGER ON _LocalSpravIndex FOR DELETE AS _spTriggerExec("_LocalSpravIndex","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "_LocalSpravIndex"
ALTER TABLE _LocalSpravIndex ;
	ADD PRIMARY KEY LSIndexID TAG LSIndexID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "_LocalSpravIndex"
ALTER TABLE _LocalSpravIndex ;
	ADD FOREIGN KEY LocalSpravID TAG LSID ;
	REFERENCES _LocalSprav TAG LSID
***
_RIRuleWrite("_LocalSpravIndex", "LSID", "_LocalSprav", "LSID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "_LocalSpravIndex" ("Индексы локальных справочников")
_WriteMetaInf(lcTargetDBPath,"_LocalSpravIndex","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"_LocalSpravIndex","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"_LocalSpravIndex","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"_LocalSpravIndex","META-INF","INCR_FLD","LSIndexID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "AccBuch" ("Бухгалтерские счета")
CREATE TABLE (lcTargetDBPath+"AccBuch") ( ;
	AccID I NOT NULL DEFAULT spIncrementID("AccBuch"), ;
	AccParID I NOT NULL, ;
	AccPlanID I NOT NULL, ;
	AccBuch C(20) NOT NULL, ;
	AccNM C(40) NOT NULL, ;
	IsParent L NOT NULL, ;
	AccActive I NOT NULL, ;
	AccSaldoType I NOT NULL, ;
	IsAnalytic L NOT NULL, ;
	AccAnalyticSpr I NOT NULL, ;
	AccAnalyticDoc I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("AccBuch","TABLE","COMMENT","Бухгалтерские счета")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Бухгалтерские счета"
CREATE TRIGGER ON AccBuch FOR INSERT AS _spTriggerExec("AccBuch","INSERT")
CREATE TRIGGER ON AccBuch FOR UPDATE AS _spTriggerExec("AccBuch","UPDATE")
CREATE TRIGGER ON AccBuch FOR DELETE AS _spTriggerExec("AccBuch","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "AccBuch"
ALTER TABLE AccBuch ;
	ADD PRIMARY KEY AccID TAG AccID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "AccBuch"
ALTER TABLE AccBuch ;
	ADD FOREIGN KEY AccAnalyticSpr TAG AccAnSpr ;
	REFERENCES Sprav TAG SprID
***
_RIRuleWrite("AccBuch", "AccAnSpr", "Sprav", "SprID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "AccBuch"
ALTER TABLE AccBuch ;
	ADD FOREIGN KEY AccParID TAG AccParID ;
	REFERENCES AccBuch TAG AccID
***
_RIRuleWrite("AccBuch", "AccParID", "AccBuch", "AccID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "AccBuch"
ALTER TABLE AccBuch ;
	ADD FOREIGN KEY AccPlanID TAG AccPlanID ;
	REFERENCES AccPlan TAG AccPlanID
***
_RIRuleWrite("AccBuch", "AccPlanID", "AccPlan", "AccPlanID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "AccBuch" ("Бухгалтерские счета")
_WriteMetaInf(lcTargetDBPath,"AccBuch","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"AccBuch","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"AccBuch","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"AccBuch","META-INF","INCR_FLD","AccID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "TvrType" ("Тип товаров")
CREATE TABLE (lcTargetDBPath+"TvrType") ( ;
	TvrTypeId I NOT NULL DEFAULT spIncrementID("TvrType"), ;
	TvrTypeNM C(20) NOT NULL, ;
	TvrTypeIsCnt L NOT NULL, ;
	TvrTypeIsForSale L NOT NULL, ;
	TvrTypeIsTare L NOT NULL, ;
	TvrTypeObjDesc C(40) NOT NULL, ;
	BmpId I NOT NULL, ;
	SelBmpId I NOT NULL, ;
	InactiveBmpId I NULL, ;
	SelInactiveBmpId I NULL, ;
	BmpMarkId I NULL, ;
	SelBmpMarkId I NULL, ;
	BmpPartMarkId I NULL, ;
	SelBmpPartMarkId I NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("TvrType","TABLE","COMMENT","Тип товаров")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Тип товаров"
CREATE TRIGGER ON TvrType FOR INSERT AS _spTriggerExec("TvrType","INSERT")
CREATE TRIGGER ON TvrType FOR UPDATE AS _spTriggerExec("TvrType","UPDATE")
CREATE TRIGGER ON TvrType FOR DELETE AS _spTriggerExec("TvrType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "TvrType"
ALTER TABLE TvrType ;
	ADD PRIMARY KEY TvrTypeId TAG TvrTypeId
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrType"
ALTER TABLE TvrType ;
	ADD FOREIGN KEY BmpId TAG BmpId ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("TvrType", "BmpId", "Bitmaps", "TestTag", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrType"
ALTER TABLE TvrType ;
	ADD FOREIGN KEY BmpMarkId TAG BmpMID ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("TvrType", "BmpMID", "Bitmaps", "TestTag", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrType"
ALTER TABLE TvrType ;
	ADD FOREIGN KEY BmpPartMarkId TAG BmpPMID ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("TvrType", "BmpPMID", "Bitmaps", "TestTag", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrType"
ALTER TABLE TvrType ;
	ADD FOREIGN KEY InactiveBmpId TAG IBmpId ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("TvrType", "IBmpId", "Bitmaps", "TestTag", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrType"
ALTER TABLE TvrType ;
	ADD FOREIGN KEY SelBmpId TAG SelBmpId ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("TvrType", "SelBmpId", "Bitmaps", "TestTag", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrType"
ALTER TABLE TvrType ;
	ADD FOREIGN KEY SelBmpMarkId TAG SelBmpMID ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("TvrType", "SelBmpMID", "Bitmaps", "TestTag", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrType"
ALTER TABLE TvrType ;
	ADD FOREIGN KEY SelBmpPartMarkId TAG SelBmpPMID ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("TvrType", "SelBmpPMID", "Bitmaps", "TestTag", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrType"
ALTER TABLE TvrType ;
	ADD FOREIGN KEY SelInactiveBmpId TAG SIBmpID ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("TvrType", "SIBmpID", "Bitmaps", "TestTag", "RRI")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "TvrType" ("Тип товаров")
_WriteMetaInf(lcTargetDBPath,"TvrType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrType","META-INF","INCR_FLD","TvrTypeId")
*-------------------------------------------------------------------------------
*Action Is Creating Table "DeviceType" ("DeviceType")
CREATE TABLE (lcTargetDBPath+"DeviceType") ( ;
	DeviceTypeID I NOT NULL DEFAULT spIncrementID("DeviceType"), ;
	DeviceTypeDescriptor C(60) NOT NULL, ;
	DeviceTypeNM C(40) NOT NULL, ;
	DeviceTypeIsCnt L NOT NULL, ;
	BmpId I NOT NULL, ;
	SelBmpId I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("DeviceType","TABLE","COMMENT","DeviceType")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "DeviceType"
CREATE TRIGGER ON DeviceType FOR INSERT AS _spTriggerExec("DeviceType","INSERT")
CREATE TRIGGER ON DeviceType FOR UPDATE AS _spTriggerExec("DeviceType","UPDATE")
CREATE TRIGGER ON DeviceType FOR DELETE AS _spTriggerExec("DeviceType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "DeviceType"
ALTER TABLE DeviceType ;
	ADD PRIMARY KEY DeviceTypeID TAG DevTypeID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "DeviceType"
ALTER TABLE DeviceType ;
	ADD FOREIGN KEY BmpId TAG BmpId ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("DeviceType", "BmpId", "Bitmaps", "TestTag", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "DeviceType"
ALTER TABLE DeviceType ;
	ADD FOREIGN KEY SelBmpId TAG SelBmpId ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("DeviceType", "SelBmpId", "Bitmaps", "TestTag", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "DeviceType" ("DeviceType")
_WriteMetaInf(lcTargetDBPath,"DeviceType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"DeviceType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"DeviceType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"DeviceType","META-INF","INCR_FLD","DeviceTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CheckTransTypeMap" ("Привязка типов транзакций")
CREATE TABLE (lcTargetDBPath+"CheckTransTypeMap") ( ;
	CheckTransTypeID I NOT NULL, ;
	CheckTransTypeMapCode C(4) NOT NULL, ;
	CheckTransTypeMapID I NOT NULL ;
)
***
DBSETPROP("CheckTransTypeMap","TABLE","COMMENT","Привязка типов транзакций")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Привязка типов транзакций"
CREATE TRIGGER ON CheckTransTypeMap FOR INSERT AS _spTriggerExec("CheckTransTypeMap","INSERT")
CREATE TRIGGER ON CheckTransTypeMap FOR UPDATE AS _spTriggerExec("CheckTransTypeMap","UPDATE")
CREATE TRIGGER ON CheckTransTypeMap FOR DELETE AS _spTriggerExec("CheckTransTypeMap","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CheckTransTypeMap"
ALTER TABLE CheckTransTypeMap ;
	ADD FOREIGN KEY CheckTransTypeID TAG ChkTTID ;
	REFERENCES CheckTransType TAG ChkTranTID
***
_RIRuleWrite("CheckTransTypeMap", "ChkTTID", "CheckTransType", "ChkTranTID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CheckTransTypeMap" ("Привязка типов транзакций")
_WriteMetaInf(lcTargetDBPath,"CheckTransTypeMap","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckTransTypeMap","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckTransTypeMap","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "TLUType" ("Типы идентификаторов")
CREATE TABLE (lcTargetDBPath+"TLUType") ( ;
	TLUTypeId I NOT NULL DEFAULT spIncrementID("TLUType"), ;
	TLUTypeNM C(40) NOT NULL, ;
	BmpId I NOT NULL, ;
	TLUTypeIsGenerate L NOT NULL, ;
	TLUTypeMask C(128) NOT NULL, ;
	TLUTypeIsWeight L NOT NULL, ;
	TLUTypeIsScalable L NOT NULL, ;
	IsDefault L NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("TLUType","TABLE","COMMENT","Типы идентификаторов")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Типы идентификаторов"
CREATE TRIGGER ON TLUType FOR INSERT AS _spTriggerExec("TLUType","INSERT")
CREATE TRIGGER ON TLUType FOR UPDATE AS _spTriggerExec("TLUType","UPDATE")
CREATE TRIGGER ON TLUType FOR DELETE AS _spTriggerExec("TLUType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "TLUType"
ALTER TABLE TLUType ;
	ADD PRIMARY KEY TLUTypeId TAG TLUTypeId
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TLUType"
ALTER TABLE TLUType ;
	ADD FOREIGN KEY BmpId TAG BmpId ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("TLUType", "BmpId", "Bitmaps", "TestTag", "CRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "TLUType" ("Типы идентификаторов")
_WriteMetaInf(lcTargetDBPath,"TLUType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"TLUType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"TLUType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"TLUType","META-INF","INCR_FLD","TLUTypeId")
*-------------------------------------------------------------------------------
*Action Is Creating Table "UserType" ("Типы пользователей")
CREATE TABLE (lcTargetDBPath+"UserType") ( ;
	UserTypeID I NOT NULL DEFAULT spIncrementID("UserType"), ;
	UserTypeNM C(40) NOT NULL, ;
	UserTypeIsCnt L NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL, ;
	BmpId I NOT NULL, ;
	SelBmpId I NOT NULL, ;
	InactiveBmpId I NOT NULL, ;
	SelInactiveBmpId I NOT NULL ;
)
***
DBSETPROP("UserType","TABLE","COMMENT","Типы пользователей")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Типы пользователей"
CREATE TRIGGER ON UserType FOR INSERT AS _spTriggerExec("UserType","INSERT")
CREATE TRIGGER ON UserType FOR UPDATE AS _spTriggerExec("UserType","UPDATE")
CREATE TRIGGER ON UserType FOR DELETE AS _spTriggerExec("UserType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "UserType"
ALTER TABLE UserType ;
	ADD PRIMARY KEY UserTypeID TAG UserTypeID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "UserType"
ALTER TABLE UserType ;
	ADD FOREIGN KEY BmpId TAG BmpId ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("UserType", "BmpId", "Bitmaps", "TestTag", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "UserType"
ALTER TABLE UserType ;
	ADD FOREIGN KEY InactiveBmpId TAG IBmpID ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("UserType", "IBmpID", "Bitmaps", "TestTag", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "UserType"
ALTER TABLE UserType ;
	ADD FOREIGN KEY SelBmpId TAG SelBmpId ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("UserType", "SelBmpId", "Bitmaps", "TestTag", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "UserType"
ALTER TABLE UserType ;
	ADD FOREIGN KEY SelInactiveBmpId TAG SIBmpID ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("UserType", "SIBmpID", "Bitmaps", "TestTag", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "UserType" ("Типы пользователей")
_WriteMetaInf(lcTargetDBPath,"UserType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"UserType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"UserType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"UserType","META-INF","INCR_FLD","UserTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "ScrFrmCustomFunc" ("Привязка ДФ к ЭФ")
CREATE TABLE (lcTargetDBPath+"ScrFrmCustomFunc") ( ;
	ScrFrmCstFuncID I NOT NULL DEFAULT spIncrementID("ScrFrmCustomFunc"), ;
	ScrFrmID I NOT NULL, ;
	CstFuncID I NOT NULL ;
)
***
DBSETPROP("ScrFrmCustomFunc","TABLE","COMMENT","Привязка ДФ к ЭФ")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Привязка ДФ к ЭФ"
CREATE TRIGGER ON ScrFrmCustomFunc FOR INSERT AS _spTriggerExec("ScrFrmCustomFunc","INSERT")
CREATE TRIGGER ON ScrFrmCustomFunc FOR UPDATE AS _spTriggerExec("ScrFrmCustomFunc","UPDATE")
CREATE TRIGGER ON ScrFrmCustomFunc FOR DELETE AS _spTriggerExec("ScrFrmCustomFunc","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "ScrFrmCustomFunc"
ALTER TABLE ScrFrmCustomFunc ;
	ADD PRIMARY KEY ScrFrmCstFuncID TAG ScrFrmCFID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "ScrFrmCustomFunc"
ALTER TABLE ScrFrmCustomFunc ;
	ADD FOREIGN KEY CstFuncID TAG CustFuncID ;
	REFERENCES CustomFunc TAG CustFuncID
***
_RIRuleWrite("ScrFrmCustomFunc", "CustFuncID", "CustomFunc", "CustFuncID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "ScrFrmCustomFunc"
ALTER TABLE ScrFrmCustomFunc ;
	ADD FOREIGN KEY ScrFrmID TAG ScrFrmID ;
	REFERENCES ScreenForm TAG ScrFrmID
***
_RIRuleWrite("ScrFrmCustomFunc", "ScrFrmID", "ScreenForm", "ScrFrmID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "ScrFrmCustomFunc" ("Привязка ДФ к ЭФ")
_WriteMetaInf(lcTargetDBPath,"ScrFrmCustomFunc","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmCustomFunc","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmCustomFunc","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmCustomFunc","META-INF","INCR_FLD","ScrFrmCstFuncID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Client" ("Клиент")
CREATE TABLE (lcTargetDBPath+"Client") ( ;
	CltID I NOT NULL DEFAULT spIncrementID("Client"), ;
	CltTypeID I NOT NULL, ;
	CltParID I NULL, ;
	CltNM C(40) NOT NULL, ;
	CltRole I NOT NULL, ;
	CltIsActiv L NOT NULL, ;
	CltINN N(12,0) NOT NULL, ;
	CltNote M NULL, ;
	ID_ I NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL, ;
	CHECK _spRecordValidationRule("CltID","CltNM") ERROR "Нарушена уникальность записи в таблице Client" ;
)
***
DBSETPROP("Client","TABLE","COMMENT","Клиент")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Клиент"
CREATE TRIGGER ON Client FOR INSERT AS _spTriggerExec("Client","INSERT")
CREATE TRIGGER ON Client FOR UPDATE AS _spTriggerExec("Client","UPDATE")
CREATE TRIGGER ON Client FOR DELETE AS _spTriggerExec("Client","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Client"
ALTER TABLE Client ;
	ADD PRIMARY KEY CltID TAG CltID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Client"
ALTER TABLE Client ;
	ADD FOREIGN KEY CltParID TAG CltParID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("Client", "CltParID", "Client", "CltID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Client"
ALTER TABLE Client ;
	ADD FOREIGN KEY CltTypeID TAG CltTypeID ;
	REFERENCES CltType TAG CltTypeID
***
_RIRuleWrite("Client", "CltTypeID", "CltType", "CltTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Client" ("Клиент")
_WriteMetaInf(lcTargetDBPath,"Client","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Client","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Client","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"Client","META-INF","INCR_FLD","CltID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "TvrSet" ("TovarSet")
CREATE TABLE (lcTargetDBPath+"TvrSet") ( ;
	TvrSetID I NOT NULL DEFAULT spIncrementID("TvrSet"), ;
	TvrSetNM C(40) NOT NULL, ;
	TvrSetTypeID I NOT NULL, ;
	BindTLU L NOT NULL, ;
	FilterByTvrType L NOT NULL, ;
	FilterByTluType L NOT NULL, ;
	Stamp_ T NOT NULL, ;
	PrcTypeId I NOT NULL, ;
	User_ I NOT NULL, ;
	CHECK _spRecordValidationRule("TvrSetID","TvrSetNM") ERROR "Нарушена уникальность записи в таблице TvrSet" ;
)
***
DBSETPROP("TvrSet","TABLE","COMMENT","TovarSet")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "TovarSet"
CREATE TRIGGER ON TvrSet FOR INSERT AS _spTriggerExec("TvrSet","INSERT")
CREATE TRIGGER ON TvrSet FOR UPDATE AS _spTriggerExec("TvrSet","UPDATE")
CREATE TRIGGER ON TvrSet FOR DELETE AS _spTriggerExec("TvrSet","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "TvrSet"
ALTER TABLE TvrSet ;
	ADD PRIMARY KEY TvrSetID TAG TvrSetID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrSet"
ALTER TABLE TvrSet ;
	ADD FOREIGN KEY PrcTypeId TAG PrcTypeId ;
	REFERENCES PrcType TAG PrcTypeId
***
_RIRuleWrite("TvrSet", "PrcTypeId", "PrcType", "PrcTypeId", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrSet"
ALTER TABLE TvrSet ;
	ADD FOREIGN KEY TvrSetTypeID TAG TvrSetTID ;
	REFERENCES TvrSetType TAG TvrSetTID
***
_RIRuleWrite("TvrSet", "TvrSetTID", "TvrSetType", "TvrSetTID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "TvrSet" ("TovarSet")
_WriteMetaInf(lcTargetDBPath,"TvrSet","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrSet","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrSet","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrSet","META-INF","INCR_FLD","TvrSetID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Report" ("Отчеты")
CREATE TABLE (lcTargetDBPath+"Report") ( ;
	RptID I NOT NULL DEFAULT spIncrementID("Report"), ;
	RptTypeID I NOT NULL, ;
	RptParID I NULL, ;
	RptNM C(40) NOT NULL, ;
	RptNote C(100) NOT NULL, ;
	RptQueryNM C(40) NOT NULL, ;
	RptQueryType N(1,0) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("Report","TABLE","COMMENT","Отчеты")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Отчеты"
CREATE TRIGGER ON Report FOR INSERT AS _spTriggerExec("Report","INSERT")
CREATE TRIGGER ON Report FOR UPDATE AS _spTriggerExec("Report","UPDATE")
CREATE TRIGGER ON Report FOR DELETE AS _spTriggerExec("Report","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Report"
ALTER TABLE Report ;
	ADD PRIMARY KEY RptID TAG RptID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Report"
ALTER TABLE Report ;
	ADD FOREIGN KEY RptParID TAG RptParID ;
	REFERENCES Report TAG RptID
***
_RIRuleWrite("Report", "RptParID", "Report", "RptID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Report"
ALTER TABLE Report ;
	ADD FOREIGN KEY RptTypeID TAG RptTypeID ;
	REFERENCES RptType TAG RptTypeID
***
_RIRuleWrite("Report", "RptTypeID", "RptType", "RptTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Report" ("Отчеты")
_WriteMetaInf(lcTargetDBPath,"Report","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Report","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Report","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"Report","META-INF","INCR_FLD","RptID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "DiscCardRange" ("Интервалы кодов дисконтных карт")
CREATE TABLE (lcTargetDBPath+"DiscCardRange") ( ;
	DiscCardRangeID I NOT NULL DEFAULT spIncrementID("DiscCardRange"), ;
	DiscID I NOT NULL, ;
	DiscCardPrefix C(3) NOT NULL, ;
	DiscCardRangeMax I NOT NULL, ;
	DiscCardRangeStartNo I NOT NULL ;
)
***
DBSETPROP("DiscCardRange","TABLE","COMMENT","Интервалы кодов дисконтных карт")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Интервалы кодов дисконтных карт"
CREATE TRIGGER ON DiscCardRange FOR INSERT AS _spTriggerExec("DiscCardRange","INSERT")
CREATE TRIGGER ON DiscCardRange FOR UPDATE AS _spTriggerExec("DiscCardRange","UPDATE")
CREATE TRIGGER ON DiscCardRange FOR DELETE AS _spTriggerExec("DiscCardRange","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "DiscCardRange"
ALTER TABLE DiscCardRange ;
	ADD PRIMARY KEY DiscCardRangeID TAG DCRangeID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "DiscCardRange"
ALTER TABLE DiscCardRange ;
	ADD FOREIGN KEY DiscID TAG DiscID ;
	REFERENCES Discount TAG DiscID
***
_RIRuleWrite("DiscCardRange", "DiscID", "Discount", "DiscID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "DiscCardRange" ("Интервалы кодов дисконтных карт")
_WriteMetaInf(lcTargetDBPath,"DiscCardRange","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"DiscCardRange","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"DiscCardRange","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"DiscCardRange","META-INF","INCR_FLD","DiscCardRangeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "PkgType" ("Фасовка")
CREATE TABLE (lcTargetDBPath+"PkgType") ( ;
	PkgTypeId I NOT NULL DEFAULT spIncrementID("PkgType"), ;
	PkgTypeNM C(40) NOT NULL, ;
	PkgTypeQnt N(10,3) NOT NULL, ;
	MsuId I NOT NULL, ;
	PkgTypeComment C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("PkgType","TABLE","COMMENT","Фасовка")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Фасовка"
CREATE TRIGGER ON PkgType FOR INSERT AS _spTriggerExec("PkgType","INSERT")
CREATE TRIGGER ON PkgType FOR UPDATE AS _spTriggerExec("PkgType","UPDATE")
CREATE TRIGGER ON PkgType FOR DELETE AS _spTriggerExec("PkgType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "PkgType"
ALTER TABLE PkgType ;
	ADD PRIMARY KEY PkgTypeId TAG PkgTypeId
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "PkgType"
ALTER TABLE PkgType ;
	ADD FOREIGN KEY MsuId TAG MsuId ;
	REFERENCES MeasureUnit TAG MsuId
***
_RIRuleWrite("PkgType", "MsuId", "MeasureUnit", "MsuId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "PkgType" ("Фасовка")
_WriteMetaInf(lcTargetDBPath,"PkgType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"PkgType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"PkgType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"PkgType","META-INF","INCR_FLD","PkgTypeId")
*-------------------------------------------------------------------------------
*Action Is Creating Table "DeviceModel" ("DeviceModel")
CREATE TABLE (lcTargetDBPath+"DeviceModel") ( ;
	DeviceModelID I NOT NULL DEFAULT spIncrementID("DeviceModel"), ;
	DeviceTypeID I NOT NULL, ;
	DeviceModelDescriptor C(60) NOT NULL, ;
	DeviceModelNM C(40) NOT NULL, ;
	DeviceModelGlobalAccess L NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("DeviceModel","TABLE","COMMENT","DeviceModel")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "DeviceModel"
CREATE TRIGGER ON DeviceModel FOR INSERT AS _spTriggerExec("DeviceModel","INSERT")
CREATE TRIGGER ON DeviceModel FOR UPDATE AS _spTriggerExec("DeviceModel","UPDATE")
CREATE TRIGGER ON DeviceModel FOR DELETE AS _spTriggerExec("DeviceModel","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "DeviceModel"
ALTER TABLE DeviceModel ;
	ADD PRIMARY KEY DeviceModelID TAG DevModelID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "DeviceModel"
ALTER TABLE DeviceModel ;
	ADD FOREIGN KEY DeviceTypeID TAG DevTypeID ;
	REFERENCES DeviceType TAG DevTypeID
***
_RIRuleWrite("DeviceModel", "DevTypeID", "DeviceType", "DevTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "DeviceModel" ("DeviceModel")
_WriteMetaInf(lcTargetDBPath,"DeviceModel","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"DeviceModel","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"DeviceModel","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"DeviceModel","META-INF","INCR_FLD","DeviceModelID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "QueryParam" ("Параметры выборки")
CREATE TABLE (lcTargetDBPath+"QueryParam") ( ;
	QryParID I NOT NULL DEFAULT spIncrementID("QueryParam"), ;
	QryParTypeID I NOT NULL, ;
	QryParNM C(40) NOT NULL, ;
	QryParNote C(100) NOT NULL, ;
	QryParObjCaption C(20) NOT NULL, ;
	QryParIsRequired L NOT NULL, ;
	QryParVarNMEnabled C(20) NOT NULL, ;
	QryParVarNMValue C(20) NOT NULL, ;
	QryParVarNMValue2 C(20) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("QueryParam","TABLE","COMMENT","Параметры выборки")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Параметры выборки"
CREATE TRIGGER ON QueryParam FOR INSERT AS _spTriggerExec("QueryParam","INSERT")
CREATE TRIGGER ON QueryParam FOR UPDATE AS _spTriggerExec("QueryParam","UPDATE")
CREATE TRIGGER ON QueryParam FOR DELETE AS _spTriggerExec("QueryParam","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "QueryParam"
ALTER TABLE QueryParam ;
	ADD PRIMARY KEY QryParID TAG QryParID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "QueryParam"
ALTER TABLE QueryParam ;
	ADD FOREIGN KEY QryParTypeID TAG QPTypeID ;
	REFERENCES QryParType TAG QPTypeID
***
_RIRuleWrite("QueryParam", "QPTypeID", "QryParType", "QPTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "QueryParam" ("Параметры выборки")
_WriteMetaInf(lcTargetDBPath,"QueryParam","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"QueryParam","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"QueryParam","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"QueryParam","META-INF","INCR_FLD","QryParID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Cashier" ("Кассиры")
CREATE TABLE (lcTargetDBPath+"Cashier") ( ;
	CashierID I NOT NULL DEFAULT spIncrementID("Cashier"), ;
	CltID I NOT NULL, ;
	CashierNo C(4) NOT NULL, ;
	CashierPassword C(2) NOT NULL, ;
	CashierIsActive L NOT NULL DEFAULT .T. ;
)
***
DBSETPROP("Cashier","TABLE","COMMENT","Кассиры")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Кассиры"
CREATE TRIGGER ON Cashier FOR INSERT AS _spTriggerExec("Cashier","INSERT")
CREATE TRIGGER ON Cashier FOR UPDATE AS _spTriggerExec("Cashier","UPDATE")
CREATE TRIGGER ON Cashier FOR DELETE AS _spTriggerExec("Cashier","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Cashier"
ALTER TABLE Cashier ;
	ADD PRIMARY KEY CashierID TAG CashierID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Cashier"
ALTER TABLE Cashier ;
	ADD FOREIGN KEY CltID TAG CltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("Cashier", "CltID", "Client", "CltID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Cashier" ("Кассиры")
_WriteMetaInf(lcTargetDBPath,"Cashier","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Cashier","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Cashier","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"Cashier","META-INF","INCR_FLD","CashierID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "RptForm" ("Формы отчетов")
CREATE TABLE (lcTargetDBPath+"RptForm") ( ;
	RptFrmID I NOT NULL DEFAULT spIncrementID("RptForm"), ;
	RptID I NOT NULL, ;
	RptFrmNM C(40) NOT NULL, ;
	RptFrmNote C(100) NOT NULL, ;
	RptFrmIsModify L NOT NULL, ;
	RptFrmSavePrnEnv L NOT NULL, ;
	RptFrmFRX M NOT NULL, ;
	RptFrmFRT M NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("RptForm","TABLE","COMMENT","Формы отчетов")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Формы отчетов"
CREATE TRIGGER ON RptForm FOR INSERT AS _spTriggerExec("RptForm","INSERT")
CREATE TRIGGER ON RptForm FOR UPDATE AS _spTriggerExec("RptForm","UPDATE")
CREATE TRIGGER ON RptForm FOR DELETE AS _spTriggerExec("RptForm","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "RptForm"
ALTER TABLE RptForm ;
	ADD PRIMARY KEY RptFrmID TAG RptFrmID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "RptForm"
ALTER TABLE RptForm ;
	ADD FOREIGN KEY RptID TAG RptID ;
	REFERENCES Report TAG RptID
***
_RIRuleWrite("RptForm", "RptID", "Report", "RptID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "RptForm" ("Формы отчетов")
_WriteMetaInf(lcTargetDBPath,"RptForm","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"RptForm","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"RptForm","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"RptForm","META-INF","INCR_FLD","RptFrmID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CltSAccount" ("РС клиентов")
CREATE TABLE (lcTargetDBPath+"CltSAccount") ( ;
	CltSAccID I NOT NULL DEFAULT spIncrementID("CltSAccount"), ;
	CltID I NOT NULL, ;
	CltBankID I NOT NULL, ;
	CltSAccNM C(40) NOT NULL, ;
	CltSAccNote C(100) NOT NULL, ;
	CltSAccIsMain L NOT NULL, ;
	CltSAcc C(20) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("CltSAccount","TABLE","COMMENT","РС клиентов")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "РС клиентов"
CREATE TRIGGER ON CltSAccount FOR INSERT AS _spTriggerExec("CltSAccount","INSERT")
CREATE TRIGGER ON CltSAccount FOR UPDATE AS _spTriggerExec("CltSAccount","UPDATE")
CREATE TRIGGER ON CltSAccount FOR DELETE AS _spTriggerExec("CltSAccount","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CltSAccount"
ALTER TABLE CltSAccount ;
	ADD PRIMARY KEY CltSAccID TAG CltSAccID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CltSAccount"
ALTER TABLE CltSAccount ;
	ADD FOREIGN KEY CltBankID TAG CltBankID ;
	REFERENCES CltBank TAG CltBankID
***
_RIRuleWrite("CltSAccount", "CltBankID", "CltBank", "CltBankID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CltSAccount"
ALTER TABLE CltSAccount ;
	ADD FOREIGN KEY CltID TAG CltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("CltSAccount", "CltID", "Client", "CltID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CltSAccount" ("РС клиентов")
_WriteMetaInf(lcTargetDBPath,"CltSAccount","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CltSAccount","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CltSAccount","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CltSAccount","META-INF","INCR_FLD","CltSAccID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "TvrSetTvrType" ("Привязка типов товаров к набору")
CREATE TABLE (lcTargetDBPath+"TvrSetTvrType") ( ;
	TvrSetTvrTypeID I NOT NULL DEFAULT spIncrementID("TvrSetTvrType"), ;
	TvrSetID I NOT NULL, ;
	TvrTypeId I NOT NULL ;
)
***
DBSETPROP("TvrSetTvrType","TABLE","COMMENT","Привязка типов товаров к набору")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Привязка типов товаров к набору"
CREATE TRIGGER ON TvrSetTvrType FOR INSERT AS _spTriggerExec("TvrSetTvrType","INSERT")
CREATE TRIGGER ON TvrSetTvrType FOR UPDATE AS _spTriggerExec("TvrSetTvrType","UPDATE")
CREATE TRIGGER ON TvrSetTvrType FOR DELETE AS _spTriggerExec("TvrSetTvrType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "TvrSetTvrType"
ALTER TABLE TvrSetTvrType ;
	ADD PRIMARY KEY TvrSetTvrTypeID TAG TvrSetTTID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrSetTvrType"
ALTER TABLE TvrSetTvrType ;
	ADD FOREIGN KEY TvrSetID TAG TvrSetID ;
	REFERENCES TvrSet TAG TvrSetID
***
_RIRuleWrite("TvrSetTvrType", "TvrSetID", "TvrSet", "TvrSetID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrSetTvrType"
ALTER TABLE TvrSetTvrType ;
	ADD FOREIGN KEY TvrTypeId TAG TvrTypeId ;
	REFERENCES TvrType TAG TvrTypeId
***
_RIRuleWrite("TvrSetTvrType", "TvrTypeId", "TvrType", "TvrTypeId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "TvrSetTvrType" ("Привязка типов товаров к набору")
_WriteMetaInf(lcTargetDBPath,"TvrSetTvrType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrSetTvrType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrSetTvrType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrSetTvrType","META-INF","INCR_FLD","TvrSetTvrTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "QryParIDCtlTreeProp" ("Параметры фильтра cntQPIDCtlGrid")
CREATE TABLE (lcTargetDBPath+"QryParIDCtlTreeProp") ( ;
	QryParID I NOT NULL, ;
	RSAliasNM C(40) NOT NULL, ;
	RSAliasParamPropName C(40) NULL, ;
	RSFieldNMID C(40) NOT NULL, ;
	RSFieldNMParentID C(40) NOT NULL, ;
	RSFieldNMParentFlag C(40) NOT NULL, ;
	RSFieldNMText C(40) NOT NULL, ;
	RSFieldNMImageIndex C(40) NOT NULL, ;
	RSFieldNMImageSelectedIndex C(40) NOT NULL, ;
	ParentOnly L NOT NULL, ;
	ShowTextEmpty C(40) NOT NULL, ;
	ShowTextNotFound C(40) NOT NULL, ;
	SelectObject C(60) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("QryParIDCtlTreeProp","TABLE","COMMENT","Параметры фильтра cntQPIDCtlGrid")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Параметры фильтра cntQPIDCtlGrid"
CREATE TRIGGER ON QryParIDCtlTreeProp FOR INSERT AS _spTriggerExec("QryParIDCtlTreeProp","INSERT")
CREATE TRIGGER ON QryParIDCtlTreeProp FOR UPDATE AS _spTriggerExec("QryParIDCtlTreeProp","UPDATE")
CREATE TRIGGER ON QryParIDCtlTreeProp FOR DELETE AS _spTriggerExec("QryParIDCtlTreeProp","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "QryParIDCtlTreeProp"
ALTER TABLE QryParIDCtlTreeProp ;
	ADD PRIMARY KEY QryParID TAG QryParID
***
_CreateRelation("QryParIDCtlTreeProp", "QryParID", "QueryParam", "QryParID")
_RIRuleWrite("QryParIDCtlTreeProp", "QryParID", "QueryParam", "QryParID", "CCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "QryParIDCtlTreeProp" ("Параметры фильтра cntQPIDCtlGrid")
_WriteMetaInf(lcTargetDBPath,"QryParIDCtlTreeProp","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"QryParIDCtlTreeProp","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"QryParIDCtlTreeProp","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "OrgUnit" ("Организационные единицы")
CREATE TABLE (lcTargetDBPath+"OrgUnit") ( ;
	OUID I NOT NULL DEFAULT spIncrementID("OrgUnit"), ;
	OUTypeID I NOT NULL, ;
	OUParID I NULL, ;
	CltID I NOT NULL, ;
	CltMRespID I NULL, ;
	OUNM C(40) NOT NULL, ;
	OUNote C(100) NOT NULL, ;
	OrgUnitStockAccType N(1,0) NOT NULL, ;
	OrgUnitAllowNegativeStock L NOT NULL, ;
	Operate_ L NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL, ;
	CHECK _spRecordValidationRule("OUID","OUNM") ERROR "Нарушена уникальность записи в таблице OrgUnit" ;
)
***
DBSETPROP("OrgUnit","TABLE","COMMENT","Организационные единицы")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Организационные единицы"
CREATE TRIGGER ON OrgUnit FOR INSERT AS _spTriggerExec("OrgUnit","INSERT","spOULink()")
CREATE TRIGGER ON OrgUnit FOR UPDATE AS _spTriggerExec("OrgUnit","UPDATE","spOULink()")
CREATE TRIGGER ON OrgUnit FOR DELETE AS _spTriggerExec("OrgUnit","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "OrgUnit"
ALTER TABLE OrgUnit ;
	ADD PRIMARY KEY OUID TAG OUID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "OrgUnit"
ALTER TABLE OrgUnit ;
	ADD FOREIGN KEY CltID TAG CltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("OrgUnit", "CltID", "Client", "CltID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "OrgUnit"
ALTER TABLE OrgUnit ;
	ADD FOREIGN KEY CltMRespID TAG CltMRespID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("OrgUnit", "CltMRespID", "Client", "CltID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "OrgUnit"
ALTER TABLE OrgUnit ;
	ADD FOREIGN KEY OUParID TAG OUParID ;
	REFERENCES OrgUnit TAG OUID
***
_RIRuleWrite("OrgUnit", "OUParID", "OrgUnit", "OUID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "OrgUnit"
ALTER TABLE OrgUnit ;
	ADD FOREIGN KEY OUTypeID TAG OUTypeID ;
	REFERENCES OUType TAG OUTypeID
***
_RIRuleWrite("OrgUnit", "OUTypeID", "OUType", "OUTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "OrgUnit" ("Организационные единицы")
_WriteMetaInf(lcTargetDBPath,"OrgUnit","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"OrgUnit","META-INF","TRIGGEREXECUTE","No")
_WriteMetaInf(lcTargetDBPath,"OrgUnit","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"OrgUnit","META-INF","INCR_FLD","OUID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "TvrSetTLUType" ("Привязка типов TLU к набору")
CREATE TABLE (lcTargetDBPath+"TvrSetTLUType") ( ;
	TvrSetTLUTypeID I NOT NULL DEFAULT spIncrementID("TvrSetTLUType"), ;
	TvrSetID I NOT NULL, ;
	TLUTypeId I NOT NULL ;
)
***
DBSETPROP("TvrSetTLUType","TABLE","COMMENT","Привязка типов TLU к набору")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Привязка типов TLU к набору"
CREATE TRIGGER ON TvrSetTLUType FOR INSERT AS _spTriggerExec("TvrSetTLUType","INSERT")
CREATE TRIGGER ON TvrSetTLUType FOR UPDATE AS _spTriggerExec("TvrSetTLUType","UPDATE")
CREATE TRIGGER ON TvrSetTLUType FOR DELETE AS _spTriggerExec("TvrSetTLUType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "TvrSetTLUType"
ALTER TABLE TvrSetTLUType ;
	ADD PRIMARY KEY TvrSetTLUTypeID TAG TvrSetTTID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrSetTLUType"
ALTER TABLE TvrSetTLUType ;
	ADD FOREIGN KEY TLUTypeId TAG TLUTypeId ;
	REFERENCES TLUType TAG TLUTypeId
***
_RIRuleWrite("TvrSetTLUType", "TLUTypeId", "TLUType", "TLUTypeId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrSetTLUType"
ALTER TABLE TvrSetTLUType ;
	ADD FOREIGN KEY TvrSetID TAG TvrSetID ;
	REFERENCES TvrSet TAG TvrSetID
***
_RIRuleWrite("TvrSetTLUType", "TvrSetID", "TvrSet", "TvrSetID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "TvrSetTLUType" ("Привязка типов TLU к набору")
_WriteMetaInf(lcTargetDBPath,"TvrSetTLUType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrSetTLUType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrSetTLUType","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrSetTLUType","META-INF","INCR_FLD","TvrSetTLUTypeID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "RptQryPar" ("Привязка праметров выборки к отчету")
CREATE TABLE (lcTargetDBPath+"RptQryPar") ( ;
	RptQryParID I NOT NULL DEFAULT spIncrementID("RptQryPar"), ;
	RptQryParIndex I NOT NULL, ;
	RptID I NOT NULL, ;
	QryParID I NOT NULL ;
)
***
DBSETPROP("RptQryPar","TABLE","COMMENT","Привязка праметров выборки к отчету")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Привязка праметров выборки к отчету"
CREATE TRIGGER ON RptQryPar FOR INSERT AS _spTriggerExec("RptQryPar","INSERT")
CREATE TRIGGER ON RptQryPar FOR UPDATE AS _spTriggerExec("RptQryPar","UPDATE")
CREATE TRIGGER ON RptQryPar FOR DELETE AS _spTriggerExec("RptQryPar","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "RptQryPar"
ALTER TABLE RptQryPar ;
	ADD PRIMARY KEY RptQryParID TAG RQPID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "RptQryPar"
ALTER TABLE RptQryPar ;
	ADD FOREIGN KEY QryParID TAG QryParID ;
	REFERENCES QueryParam TAG QryParID
***
_RIRuleWrite("RptQryPar", "QryParID", "QueryParam", "QryParID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "RptQryPar"
ALTER TABLE RptQryPar ;
	ADD FOREIGN KEY RptID TAG RptID ;
	REFERENCES Report TAG RptID
***
_RIRuleWrite("RptQryPar", "RptID", "Report", "RptID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "RptQryPar" ("Привязка праметров выборки к отчету")
_WriteMetaInf(lcTargetDBPath,"RptQryPar","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"RptQryPar","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"RptQryPar","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"RptQryPar","META-INF","INCR_FLD","RptQryParID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "QryParIDCtlProp" ("Параметры фильтра cntQPIDCtlGrid")
CREATE TABLE (lcTargetDBPath+"QryParIDCtlProp") ( ;
	QryParID I NOT NULL, ;
	RSAliasNM C(40) NOT NULL, ;
	RSAliasParamPropName C(40) NULL, ;
	RSFieldNMID C(40) NOT NULL, ;
	RSFieldNMText C(40) NOT NULL, ;
	ShowTextEmpty C(40) NOT NULL, ;
	ShowTextNotFound C(40) NOT NULL, ;
	SelectObject C(60) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("QryParIDCtlProp","TABLE","COMMENT","Параметры фильтра cntQPIDCtlGrid")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Параметры фильтра cntQPIDCtlGrid"
CREATE TRIGGER ON QryParIDCtlProp FOR INSERT AS _spTriggerExec("QryParIDCtlProp","INSERT")
CREATE TRIGGER ON QryParIDCtlProp FOR UPDATE AS _spTriggerExec("QryParIDCtlProp","UPDATE")
CREATE TRIGGER ON QryParIDCtlProp FOR DELETE AS _spTriggerExec("QryParIDCtlProp","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "QryParIDCtlProp"
ALTER TABLE QryParIDCtlProp ;
	ADD PRIMARY KEY QryParID TAG QryParID
***
_CreateRelation("QryParIDCtlProp", "QryParID", "QueryParam", "QryParID")
_RIRuleWrite("QryParIDCtlProp", "QryParID", "QueryParam", "QryParID", "CCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "QryParIDCtlProp" ("Параметры фильтра cntQPIDCtlGrid")
_WriteMetaInf(lcTargetDBPath,"QryParIDCtlProp","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"QryParIDCtlProp","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"QryParIDCtlProp","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmType" ("Тип формы")
CREATE TABLE (lcTargetDBPath+"FrmType") ( ;
	FrmTypeID I NOT NULL, ;
	FrmTypeNM C(40) NOT NULL, ;
	FrmTypeShortNM C(10) NOT NULL, ;
	FrmTypeAbbr C(20) NOT NULL, ;
	FrmTypeNote C(100) NOT NULL, ;
	FrmTypeEditObjDesc C(60) NOT NULL, ;
	FrmTypeDirection I NOT NULL, ;
	FrmTypeIsContainTvr L NOT NULL, ;
	FrmTypeIsContainFrm L NOT NULL, ;
	PointEmiRoleNM C(20) NOT NULL, ;
	PointEmiSprID I NULL, ;
	PointIspRoleNM C(20) NOT NULL, ;
	PointIspSprID I NULL, ;
	DevRoleNM C(20) NOT NULL, ;
	DevSprID I NULL, ;
	ExecEmiRoleNM C(20) NOT NULL, ;
	ExecEmiSprID I NULL, ;
	ExecIspRoleNM C(20) NOT NULL, ;
	ExecIspSprID I NULL, ;
	ContrRoleNM C(20) NOT NULL, ;
	ContrSprID I NULL, ;
	PointEmiAccountSprID I NULL, ;
	PointIspAccountSprID I NULL, ;
	ContainPriceBuy L NOT NULL, ;
	ContainPriceSale L NOT NULL, ;
	FrmTypePayListInc L NOT NULL, ;
	RptID I NULL, ;
	StockTransTypeID I NULL, ;
	FrmTypeAttribute I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("FrmType","TABLE","COMMENT","Тип формы")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Тип формы"
CREATE TRIGGER ON FrmType FOR INSERT AS _spTriggerExec("FrmType","INSERT")
CREATE TRIGGER ON FrmType FOR UPDATE AS _spTriggerExec("FrmType","UPDATE")
CREATE TRIGGER ON FrmType FOR DELETE AS _spTriggerExec("FrmType","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "FrmType"
ALTER TABLE FrmType ;
	ADD PRIMARY KEY FrmTypeID TAG FrmTypeID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmType"
ALTER TABLE FrmType ;
	ADD FOREIGN KEY ContrSprID TAG ContrSprID ;
	REFERENCES Sprav TAG SprID
***
_RIRuleWrite("FrmType", "ContrSprID", "Sprav", "SprID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmType"
ALTER TABLE FrmType ;
	ADD FOREIGN KEY DevSprID TAG DevSprID ;
	REFERENCES Sprav TAG SprID
***
_RIRuleWrite("FrmType", "DevSprID", "Sprav", "SprID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmType"
ALTER TABLE FrmType ;
	ADD FOREIGN KEY ExecEmiSprID TAG ExecESprID ;
	REFERENCES Sprav TAG SprID
***
_RIRuleWrite("FrmType", "ExecESprID", "Sprav", "SprID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmType"
ALTER TABLE FrmType ;
	ADD FOREIGN KEY ExecIspSprID TAG ExecISprID ;
	REFERENCES Sprav TAG SprID
***
_RIRuleWrite("FrmType", "ExecISprID", "Sprav", "SprID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmType"
ALTER TABLE FrmType ;
	ADD FOREIGN KEY PointEmiAccountSprID TAG PEmiASprID ;
	REFERENCES Sprav TAG SprID
***
_RIRuleWrite("FrmType", "PEmiASprID", "Sprav", "SprID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmType"
ALTER TABLE FrmType ;
	ADD FOREIGN KEY PointEmiSprID TAG PEmiSprID ;
	REFERENCES Sprav TAG SprID
***
_RIRuleWrite("FrmType", "PEmiSprID", "Sprav", "SprID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmType"
ALTER TABLE FrmType ;
	ADD FOREIGN KEY PointIspAccountSprID TAG PIspASprID ;
	REFERENCES Sprav TAG SprID
***
_RIRuleWrite("FrmType", "PIspASprID", "Sprav", "SprID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmType"
ALTER TABLE FrmType ;
	ADD FOREIGN KEY PointIspSprID TAG PIspSprID ;
	REFERENCES Sprav TAG SprID
***
_RIRuleWrite("FrmType", "PIspSprID", "Sprav", "SprID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmType"
ALTER TABLE FrmType ;
	ADD FOREIGN KEY RptID TAG RptID ;
	REFERENCES Report TAG RptID
***
_RIRuleWrite("FrmType", "RptID", "Report", "RptID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmType"
ALTER TABLE FrmType ;
	ADD FOREIGN KEY StockTransTypeID TAG StockTTID ;
	REFERENCES StockTransType TAG StockTTID
***
_RIRuleWrite("FrmType", "StockTTID", "StockTransType", "StockTTID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmType" ("Тип формы")
_WriteMetaInf(lcTargetDBPath,"FrmType","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmType","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmType","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "QryParSelCtlProp" ("Параметры фильтра cntQPSelCtlGrid")
CREATE TABLE (lcTargetDBPath+"QryParSelCtlProp") ( ;
	QryParID I NOT NULL, ;
	RSAliasNM C(40) NOT NULL, ;
	RSAliasParamPropName C(40) NOT NULL, ;
	RSFieldNMID C(40) NOT NULL, ;
	RSFieldNMText C(40) NOT NULL, ;
	ShowTextEmpty C(40) NOT NULL, ;
	ShowTextNotFound C(40) NOT NULL, ;
	SelectObject C(60) NOT NULL, ;
	SelectAllByDefault L NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("QryParSelCtlProp","TABLE","COMMENT","Параметры фильтра cntQPSelCtlGrid")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Параметры фильтра cntQPSelCtlGrid"
CREATE TRIGGER ON QryParSelCtlProp FOR INSERT AS _spTriggerExec("QryParSelCtlProp","INSERT")
CREATE TRIGGER ON QryParSelCtlProp FOR UPDATE AS _spTriggerExec("QryParSelCtlProp","UPDATE")
CREATE TRIGGER ON QryParSelCtlProp FOR DELETE AS _spTriggerExec("QryParSelCtlProp","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "QryParSelCtlProp"
ALTER TABLE QryParSelCtlProp ;
	ADD PRIMARY KEY QryParID TAG QryParID
***
_CreateRelation("QryParSelCtlProp", "QryParID", "QueryParam", "QryParID")
_RIRuleWrite("QryParSelCtlProp", "QryParID", "QueryParam", "QryParID", "CCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "QryParSelCtlProp" ("Параметры фильтра cntQPSelCtlGrid")
_WriteMetaInf(lcTargetDBPath,"QryParSelCtlProp","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"QryParSelCtlProp","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"QryParSelCtlProp","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "ScrFrmReport" ("Привязка отчётов к экранным формам")
CREATE TABLE (lcTargetDBPath+"ScrFrmReport") ( ;
	ScrFrmReportID I NOT NULL DEFAULT spIncrementID("ScrFrmReport"), ;
	ScrFrmID I NOT NULL, ;
	RptID I NOT NULL, ;
	IsDefault L NOT NULL ;
)
***
DBSETPROP("ScrFrmReport","TABLE","COMMENT","Привязка отчётов к экранным формам")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Привязка отчётов к экранным формам"
CREATE TRIGGER ON ScrFrmReport FOR INSERT AS _spTriggerExec("ScrFrmReport","INSERT")
CREATE TRIGGER ON ScrFrmReport FOR UPDATE AS _spTriggerExec("ScrFrmReport","UPDATE")
CREATE TRIGGER ON ScrFrmReport FOR DELETE AS _spTriggerExec("ScrFrmReport","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "ScrFrmReport"
ALTER TABLE ScrFrmReport ;
	ADD PRIMARY KEY ScrFrmReportID TAG SFrmRptID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "ScrFrmReport"
ALTER TABLE ScrFrmReport ;
	ADD FOREIGN KEY RptID TAG RptID ;
	REFERENCES Report TAG RptID
***
_RIRuleWrite("ScrFrmReport", "RptID", "Report", "RptID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "ScrFrmReport"
ALTER TABLE ScrFrmReport ;
	ADD FOREIGN KEY ScrFrmID TAG ScrFrmID ;
	REFERENCES ScreenForm TAG ScrFrmID
***
_RIRuleWrite("ScrFrmReport", "ScrFrmID", "ScreenForm", "ScrFrmID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "ScrFrmReport" ("Привязка отчётов к экранным формам")
_WriteMetaInf(lcTargetDBPath,"ScrFrmReport","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmReport","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmReport","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmReport","META-INF","INCR_FLD","ScrFrmReportID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "ScrFrmQryPar" ("Параметры выборки для экранной формы")
CREATE TABLE (lcTargetDBPath+"ScrFrmQryPar") ( ;
	ScrFrmQryParID I NOT NULL DEFAULT spIncrementID("ScrFrmQryPar"), ;
	ScrFrmQryParIndex I NOT NULL, ;
	ScrFrmID I NOT NULL, ;
	QryParID I NOT NULL ;
)
***
DBSETPROP("ScrFrmQryPar","TABLE","COMMENT","Параметры выборки для экранной формы")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Параметры выборки для экранной формы"
CREATE TRIGGER ON ScrFrmQryPar FOR INSERT AS _spTriggerExec("ScrFrmQryPar","INSERT")
CREATE TRIGGER ON ScrFrmQryPar FOR UPDATE AS _spTriggerExec("ScrFrmQryPar","UPDATE")
CREATE TRIGGER ON ScrFrmQryPar FOR DELETE AS _spTriggerExec("ScrFrmQryPar","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "ScrFrmQryPar"
ALTER TABLE ScrFrmQryPar ;
	ADD PRIMARY KEY ScrFrmQryParID TAG SFQPID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "ScrFrmQryPar"
ALTER TABLE ScrFrmQryPar ;
	ADD FOREIGN KEY QryParID TAG QryParID ;
	REFERENCES QueryParam TAG QryParID
***
_RIRuleWrite("ScrFrmQryPar", "QryParID", "QueryParam", "QryParID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "ScrFrmQryPar"
ALTER TABLE ScrFrmQryPar ;
	ADD FOREIGN KEY ScrFrmID TAG ScrFrmID ;
	REFERENCES ScreenForm TAG ScrFrmID
***
_RIRuleWrite("ScrFrmQryPar", "ScrFrmID", "ScreenForm", "ScrFrmID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "ScrFrmQryPar" ("Параметры выборки для экранной формы")
_WriteMetaInf(lcTargetDBPath,"ScrFrmQryPar","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmQryPar","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmQryPar","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmQryPar","META-INF","INCR_FLD","ScrFrmQryParID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "DeviceDriver" ("DeviceDriver")
CREATE TABLE (lcTargetDBPath+"DeviceDriver") ( ;
	DeviceDriverID I NOT NULL DEFAULT spIncrementID("DeviceDriver"), ;
	DeviceModelID I NOT NULL, ;
	DeviceDriverVersion C(20) NOT NULL, ;
	DeviceDriverAppDescriptor C(60) NOT NULL, ;
	DeviceDriverINI M NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("DeviceDriver","TABLE","COMMENT","DeviceDriver")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "DeviceDriver"
CREATE TRIGGER ON DeviceDriver FOR INSERT AS _spTriggerExec("DeviceDriver","INSERT")
CREATE TRIGGER ON DeviceDriver FOR UPDATE AS _spTriggerExec("DeviceDriver","UPDATE")
CREATE TRIGGER ON DeviceDriver FOR DELETE AS _spTriggerExec("DeviceDriver","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "DeviceDriver"
ALTER TABLE DeviceDriver ;
	ADD PRIMARY KEY DeviceDriverID TAG DevDrvID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "DeviceDriver"
ALTER TABLE DeviceDriver ;
	ADD FOREIGN KEY DeviceModelID TAG DevModelID ;
	REFERENCES DeviceModel TAG DevModelID
***
_RIRuleWrite("DeviceDriver", "DevModelID", "DeviceModel", "DevModelID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "DeviceDriver" ("DeviceDriver")
_WriteMetaInf(lcTargetDBPath,"DeviceDriver","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"DeviceDriver","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"DeviceDriver","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"DeviceDriver","META-INF","INCR_FLD","DeviceDriverID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "DiscCard" ("Дисконтные карты")
CREATE TABLE (lcTargetDBPath+"DiscCard") ( ;
	DiscCardID I NOT NULL DEFAULT spIncrementID("DiscCard"), ;
	DiscID I NOT NULL, ;
	DiscCardNM C(40) NOT NULL, ;
	CltID I NULL, ;
	CLU C(13) NOT NULL, ;
	DiscCardDeliveryDate T NOT NULL, ;
	DiscCardDisableDate T NOT NULL, ;
	DiscCardIsActive L NOT NULL CHECK spSwitchActive(), ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("DiscCard","TABLE","COMMENT","Дисконтные карты")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Дисконтные карты"
CREATE TRIGGER ON DiscCard FOR INSERT AS _spTriggerExec("DiscCard","INSERT")
CREATE TRIGGER ON DiscCard FOR UPDATE AS _spTriggerExec("DiscCard","UPDATE")
CREATE TRIGGER ON DiscCard FOR DELETE AS _spTriggerExec("DiscCard","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "DiscCard"
ALTER TABLE DiscCard ;
	ADD PRIMARY KEY DiscCardID TAG DiscCardID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "DiscCard"
ALTER TABLE DiscCard ;
	ADD FOREIGN KEY CltID TAG CltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("DiscCard", "CltID", "Client", "CltID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "DiscCard"
ALTER TABLE DiscCard ;
	ADD FOREIGN KEY DiscID TAG DiscID ;
	REFERENCES Discount TAG DiscID
***
_RIRuleWrite("DiscCard", "DiscID", "Discount", "DiscID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "DiscCard" ("Дисконтные карты")
_WriteMetaInf(lcTargetDBPath,"DiscCard","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"DiscCard","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"DiscCard","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"DiscCard","META-INF","INCR_FLD","DiscCardID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Tovar" ("Товар")
CREATE TABLE (lcTargetDBPath+"Tovar") ( ;
	TvrId I NOT NULL DEFAULT spIncrementID("Tovar"), ;
	TvrParId I NULL, ;
	TvrTypeId I NOT NULL, ;
	MsuId I NULL, ;
	MakerCltID I NULL, ;
	TvrDiscID I NULL, ;
	TvrNM C(80) NOT NULL, ;
	TvrIsDiv L NOT NULL, ;
	TvrIsActiv L NOT NULL, ;
	TvrVatRate N(6,2) NOT NULL, ;
	ID_ I NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL, ;
	CHECK _spRecordValidationRule("TvrID","TvrNM") ERROR "Нарушена уникальность записи в таблице Tovar" ;
)
***
DBSETPROP("Tovar","TABLE","COMMENT","Товар")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Товар"
CREATE TRIGGER ON Tovar FOR INSERT AS _spTriggerExec("Tovar","INSERT")
CREATE TRIGGER ON Tovar FOR UPDATE AS _spTriggerExec("Tovar","UPDATE","spBaseMsuUpdate()")
CREATE TRIGGER ON Tovar FOR DELETE AS _spTriggerExec("Tovar","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Tovar"
ALTER TABLE Tovar ;
	ADD PRIMARY KEY TvrId TAG TvrId
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Tovar"
ALTER TABLE Tovar ;
	ADD FOREIGN KEY MakerCltID TAG MakerCltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("Tovar", "MakerCltID", "Client", "CltID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Tovar"
ALTER TABLE Tovar ;
	ADD FOREIGN KEY MsuId TAG MsuId ;
	REFERENCES MeasureUnit TAG MsuId
***
_RIRuleWrite("Tovar", "MsuId", "MeasureUnit", "MsuId", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Tovar"
ALTER TABLE Tovar ;
	ADD FOREIGN KEY TvrDiscID TAG TvrDiscID ;
	REFERENCES Discount TAG DiscID
***
_RIRuleWrite("Tovar", "TvrDiscID", "Discount", "DiscID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Tovar"
ALTER TABLE Tovar ;
	ADD FOREIGN KEY TvrParId TAG TvrParId ;
	REFERENCES Tovar TAG TvrId
***
_RIRuleWrite("Tovar", "TvrParId", "Tovar", "TvrId", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Tovar"
ALTER TABLE Tovar ;
	ADD FOREIGN KEY TvrTypeId TAG TvrTypeId ;
	REFERENCES TvrType TAG TvrTypeId
***
_RIRuleWrite("Tovar", "TvrTypeId", "TvrType", "TvrTypeId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Tovar" ("Товар")
_WriteMetaInf(lcTargetDBPath,"Tovar","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Tovar","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Tovar","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"Tovar","META-INF","INCR_FLD","TvrId")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CltPhysical" ("Физические лица")
CREATE TABLE (lcTargetDBPath+"CltPhysical") ( ;
	CltID I NOT NULL, ;
	CltPhysFNM C(40) NOT NULL, ;
	CltPhysINM C(40) NOT NULL, ;
	CltPhysONM C(40) NOT NULL, ;
	CltPhysBirthDate T NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("CltPhysical","TABLE","COMMENT","Физические лица")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Физические лица"
CREATE TRIGGER ON CltPhysical FOR INSERT AS _spTriggerExec("CltPhysical","INSERT")
CREATE TRIGGER ON CltPhysical FOR UPDATE AS _spTriggerExec("CltPhysical","UPDATE")
CREATE TRIGGER ON CltPhysical FOR DELETE AS _spTriggerExec("CltPhysical","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CltPhysical"
ALTER TABLE CltPhysical ;
	ADD PRIMARY KEY CltID TAG CltID
***
_CreateRelation("CltPhysical", "CltID", "Client", "CltID")
_RIRuleWrite("CltPhysical", "CltID", "Client", "CltID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CltPhysical" ("Физические лица")
_WriteMetaInf(lcTargetDBPath,"CltPhysical","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CltPhysical","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CltPhysical","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "QryParCheckProp" ("Параметры фильтра cntQPCheck")
CREATE TABLE (lcTargetDBPath+"QryParCheckProp") ( ;
	QryParID I NOT NULL, ;
	Caption C(40) NOT NULL, ;
	TextChange L NOT NULL, ;
	TextChecked C(40) NOT NULL, ;
	TextUnChecked C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("QryParCheckProp","TABLE","COMMENT","Параметры фильтра cntQPCheck")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Параметры фильтра cntQPCheck"
CREATE TRIGGER ON QryParCheckProp FOR INSERT AS _spTriggerExec("QryParCheckProp","INSERT")
CREATE TRIGGER ON QryParCheckProp FOR UPDATE AS _spTriggerExec("QryParCheckProp","UPDATE")
CREATE TRIGGER ON QryParCheckProp FOR DELETE AS _spTriggerExec("QryParCheckProp","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "QryParCheckProp"
ALTER TABLE QryParCheckProp ;
	ADD PRIMARY KEY QryParID TAG QryParID
***
_CreateRelation("QryParCheckProp", "QryParID", "QueryParam", "QryParID")
_RIRuleWrite("QryParCheckProp", "QryParID", "QueryParam", "QryParID", "CCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "QryParCheckProp" ("Параметры фильтра cntQPCheck")
_WriteMetaInf(lcTargetDBPath,"QryParCheckProp","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"QryParCheckProp","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"QryParCheckProp","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "AppUser" ("Пользователи")
CREATE TABLE (lcTargetDBPath+"AppUser") ( ;
	UserLogin C(20) NOT NULL, ;
	UserPassword C(20) NOT NULL, ;
	UserComment C(100) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL, ;
	UserId I NOT NULL DEFAULT spIncrementID("AppUser"), ;
	UserParID I NULL, ;
	UserOptions M NOT NULL, ;
	UserIsActive L NOT NULL, ;
	UserTypeID I NOT NULL, ;
	UserCltID I NULL, ;
	CHECK _spRecordValidationRule("UserID","UserLogin") ERROR "Нарушена уникальность записи в таблице AppUser" ;
)
***
DBSETPROP("AppUser","TABLE","COMMENT","Пользователи")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Пользователи"
CREATE TRIGGER ON AppUser FOR INSERT AS _spTriggerExec("AppUser","INSERT")
CREATE TRIGGER ON AppUser FOR UPDATE AS _spTriggerExec("AppUser","UPDATE")
CREATE TRIGGER ON AppUser FOR DELETE AS _spTriggerExec("AppUser","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "AppUser"
ALTER TABLE AppUser ;
	ADD PRIMARY KEY UserId TAG UserId
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "AppUser"
ALTER TABLE AppUser ;
	ADD FOREIGN KEY UserCltID TAG UserCltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("AppUser", "UserCltID", "Client", "CltID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "AppUser"
ALTER TABLE AppUser ;
	ADD FOREIGN KEY UserParID TAG UserParID ;
	REFERENCES AppUser TAG UserId
***
_RIRuleWrite("AppUser", "UserParID", "AppUser", "UserId", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "AppUser"
ALTER TABLE AppUser ;
	ADD FOREIGN KEY UserTypeID TAG UserTypeID ;
	REFERENCES UserType TAG UserTypeID
***
_RIRuleWrite("AppUser", "UserTypeID", "UserType", "UserTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "AppUser" ("Пользователи")
_WriteMetaInf(lcTargetDBPath,"AppUser","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"AppUser","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"AppUser","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"AppUser","META-INF","INCR_FLD","UserId")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CltJuridical" ("Юридические лица")
CREATE TABLE (lcTargetDBPath+"CltJuridical") ( ;
	CltID I NOT NULL, ;
	CltLegalTypeID I NULL, ;
	CltJrdNM C(100) NOT NULL, ;
	CltJrdKpp I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("CltJuridical","TABLE","COMMENT","Юридические лица")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Юридические лица"
CREATE TRIGGER ON CltJuridical FOR INSERT AS _spTriggerExec("CltJuridical","INSERT")
CREATE TRIGGER ON CltJuridical FOR UPDATE AS _spTriggerExec("CltJuridical","UPDATE")
CREATE TRIGGER ON CltJuridical FOR DELETE AS _spTriggerExec("CltJuridical","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CltJuridical"
ALTER TABLE CltJuridical ;
	ADD PRIMARY KEY CltID TAG CltID
***
_CreateRelation("CltJuridical", "CltID", "Client", "CltID")
_RIRuleWrite("CltJuridical", "CltID", "Client", "CltID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CltJuridical"
ALTER TABLE CltJuridical ;
	ADD FOREIGN KEY CltLegalTypeID TAG LegTypeID ;
	REFERENCES CltLegalType TAG LegTypeID
***
_RIRuleWrite("CltJuridical", "LegTypeID", "CltLegalType", "LegTypeID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CltJuridical" ("Юридические лица")
_WriteMetaInf(lcTargetDBPath,"CltJuridical","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CltJuridical","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CltJuridical","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "QryParTXTProp" ("QryParTXTProp")
CREATE TABLE (lcTargetDBPath+"QryParTXTProp") ( ;
	QryParID I NOT NULL, ;
	Type C(1) NOT NULL, ;
	Width I NOT NULL, ;
	Decimal I NOT NULL ;
)
***
DBSETPROP("QryParTXTProp","TABLE","COMMENT","QryParTXTProp")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "QryParTXTProp"
CREATE TRIGGER ON QryParTXTProp FOR INSERT AS _spTriggerExec("QryParTXTProp","INSERT")
CREATE TRIGGER ON QryParTXTProp FOR UPDATE AS _spTriggerExec("QryParTXTProp","UPDATE")
CREATE TRIGGER ON QryParTXTProp FOR DELETE AS _spTriggerExec("QryParTXTProp","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "QryParTXTProp"
ALTER TABLE QryParTXTProp ;
	ADD PRIMARY KEY QryParID TAG QryParID
***
_CreateRelation("QryParTXTProp", "QryParID", "QueryParam", "QryParID")
_RIRuleWrite("QryParTXTProp", "QryParID", "QueryParam", "QryParID", "CCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "QryParTXTProp" ("QryParTXTProp")
_WriteMetaInf(lcTargetDBPath,"QryParTXTProp","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"QryParTXTProp","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"QryParTXTProp","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CltAddress" ("Адреса")
CREATE TABLE (lcTargetDBPath+"CltAddress") ( ;
	CltAddrID I NOT NULL DEFAULT spIncrementID("CltAddress"), ;
	CltAddrTypeID I NOT NULL, ;
	CltID I NOT NULL, ;
	CltAddrIsMain L NOT NULL, ;
	CltCountryID I NOT NULL, ;
	CltAddrZIP I NOT NULL, ;
	CltAddrRegNM C(40) NOT NULL, ;
	CltAddrAreaNM C(40) NOT NULL, ;
	CltAddrSettlNM C(40) NOT NULL, ;
	CltAddrStreetNM C(40) NOT NULL, ;
	CltAddrHouseNM C(40) NOT NULL, ;
	CltAddrRoom C(40) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("CltAddress","TABLE","COMMENT","Адреса")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Адреса"
CREATE TRIGGER ON CltAddress FOR INSERT AS _spTriggerExec("CltAddress","INSERT")
CREATE TRIGGER ON CltAddress FOR UPDATE AS _spTriggerExec("CltAddress","UPDATE")
CREATE TRIGGER ON CltAddress FOR DELETE AS _spTriggerExec("CltAddress","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CltAddress"
ALTER TABLE CltAddress ;
	ADD PRIMARY KEY CltAddrID TAG CltAddrID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CltAddress"
ALTER TABLE CltAddress ;
	ADD FOREIGN KEY CltAddrTypeID TAG AddrTypeID ;
	REFERENCES CltAddrType TAG AddrTypeID
***
_RIRuleWrite("CltAddress", "AddrTypeID", "CltAddrType", "AddrTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CltAddress"
ALTER TABLE CltAddress ;
	ADD FOREIGN KEY CltCountryID TAG CountryID ;
	REFERENCES CltCountry TAG CountryID
***
_RIRuleWrite("CltAddress", "CountryID", "CltCountry", "CountryID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CltAddress"
ALTER TABLE CltAddress ;
	ADD FOREIGN KEY CltID TAG CltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("CltAddress", "CltID", "Client", "CltID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CltAddress" ("Адреса")
_WriteMetaInf(lcTargetDBPath,"CltAddress","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CltAddress","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CltAddress","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CltAddress","META-INF","INCR_FLD","CltAddrID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "TvrLookUp" ("Идентификаторы товара")
CREATE TABLE (lcTargetDBPath+"TvrLookUp") ( ;
	TLUId I NOT NULL DEFAULT spIncrementID("TvrLookUp"), ;
	TLUTypeId I NOT NULL, ;
	TvrId I NOT NULL, ;
	TvrQnt N(10,3) NOT NULL, ;
	TLU C(20) NOT NULL, ;
	TLUComment C(100) NOT NULL, ;
	TLUIsMain L NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL, ;
	CHECK _spRecordValidationRule("TLUID","TLU") ERROR "Нарушена уникальность записи в таблице TvrLookUp" ;
)
***
DBSETPROP("TvrLookUp","TABLE","COMMENT","Идентификаторы товара")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Идентификаторы товара"
CREATE TRIGGER ON TvrLookUp FOR INSERT AS _spTriggerExec("TvrLookUp","INSERT")
CREATE TRIGGER ON TvrLookUp FOR UPDATE AS _spTriggerExec("TvrLookUp","UPDATE")
CREATE TRIGGER ON TvrLookUp FOR DELETE AS _spTriggerExec("TvrLookUp","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "TvrLookUp"
ALTER TABLE TvrLookUp ;
	ADD PRIMARY KEY TLUId TAG TLUId
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrLookUp"
ALTER TABLE TvrLookUp ;
	ADD FOREIGN KEY TLUTypeId TAG TLUTypeId ;
	REFERENCES TLUType TAG TLUTypeId
***
_RIRuleWrite("TvrLookUp", "TLUTypeId", "TLUType", "TLUTypeId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrLookUp"
ALTER TABLE TvrLookUp ;
	ADD FOREIGN KEY TvrId TAG TvrId ;
	REFERENCES Tovar TAG TvrId
***
_RIRuleWrite("TvrLookUp", "TvrId", "Tovar", "TvrId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "TvrLookUp" ("Идентификаторы товара")
_WriteMetaInf(lcTargetDBPath,"TvrLookUp","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrLookUp","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrLookUp","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrLookUp","META-INF","INCR_FLD","TLUId")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Price" ("Цена")
CREATE TABLE (lcTargetDBPath+"Price") ( ;
	PrcId I NOT NULL DEFAULT spIncrementID("Price"), ;
	TvrId I NOT NULL, ;
	PrcTypeId I NOT NULL, ;
	Price Y NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("Price","TABLE","COMMENT","Цена")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Цена"
CREATE TRIGGER ON Price FOR INSERT AS _spTriggerExec("Price","INSERT")
CREATE TRIGGER ON Price FOR UPDATE AS _spTriggerExec("Price","UPDATE")
CREATE TRIGGER ON Price FOR DELETE AS _spTriggerExec("Price","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Price"
ALTER TABLE Price ;
	ADD PRIMARY KEY PrcId TAG PrcId
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Price"
ALTER TABLE Price ;
	ADD FOREIGN KEY PrcTypeId TAG PrcTypeId ;
	REFERENCES PrcType TAG PrcTypeId
***
_RIRuleWrite("Price", "PrcTypeId", "PrcType", "PrcTypeId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Price"
ALTER TABLE Price ;
	ADD FOREIGN KEY TvrId TAG TvrId ;
	REFERENCES Tovar TAG TvrId
***
_RIRuleWrite("Price", "TvrId", "Tovar", "TvrId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Price" ("Цена")
_WriteMetaInf(lcTargetDBPath,"Price","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Price","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Price","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"Price","META-INF","INCR_FLD","PrcId")
*-------------------------------------------------------------------------------
*Action Is Creating Table "DeviceDriverFunc" ("Функции драйвера")
CREATE TABLE (lcTargetDBPath+"DeviceDriverFunc") ( ;
	DeviceDriverFuncID I NOT NULL DEFAULT spIncrementID("DeviceDriverFunc"), ;
	DeviceDriverID I NOT NULL, ;
	DeviceDriverFuncNM C(40) NOT NULL, ;
	DeviceDriverFuncMsg C(20) NOT NULL, ;
	BmpId I NOT NULL ;
)
***
DBSETPROP("DeviceDriverFunc","TABLE","COMMENT","Функции драйвера")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Функции драйвера"
CREATE TRIGGER ON DeviceDriverFunc FOR INSERT AS _spTriggerExec("DeviceDriverFunc","INSERT")
CREATE TRIGGER ON DeviceDriverFunc FOR UPDATE AS _spTriggerExec("DeviceDriverFunc","UPDATE")
CREATE TRIGGER ON DeviceDriverFunc FOR DELETE AS _spTriggerExec("DeviceDriverFunc","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "DeviceDriverFunc"
ALTER TABLE DeviceDriverFunc ;
	ADD PRIMARY KEY DeviceDriverFuncID TAG DDrvFuncID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "DeviceDriverFunc"
ALTER TABLE DeviceDriverFunc ;
	ADD FOREIGN KEY BmpId TAG BmpId ;
	REFERENCES Bitmaps TAG TestTag
***
_RIRuleWrite("DeviceDriverFunc", "BmpId", "Bitmaps", "TestTag", "CRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "DeviceDriverFunc"
ALTER TABLE DeviceDriverFunc ;
	ADD FOREIGN KEY DeviceDriverID TAG DDrvID ;
	REFERENCES DeviceDriver TAG DevDrvID
***
_RIRuleWrite("DeviceDriverFunc", "DDrvID", "DeviceDriver", "DevDrvID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "DeviceDriverFunc" ("Функции драйвера")
_WriteMetaInf(lcTargetDBPath,"DeviceDriverFunc","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"DeviceDriverFunc","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"DeviceDriverFunc","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"DeviceDriverFunc","META-INF","INCR_FLD","DeviceDriverFuncID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CashierMember" ("Членство кассиров в группах")
CREATE TABLE (lcTargetDBPath+"CashierMember") ( ;
	CashierMemberID I NOT NULL DEFAULT spIncrementID("CashierMember"), ;
	CashierGroupID I NOT NULL, ;
	CashierID I NOT NULL ;
)
***
DBSETPROP("CashierMember","TABLE","COMMENT","Членство кассиров в группах")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Членство кассиров в группах"
CREATE TRIGGER ON CashierMember FOR INSERT AS _spTriggerExec("CashierMember","INSERT")
CREATE TRIGGER ON CashierMember FOR UPDATE AS _spTriggerExec("CashierMember","UPDATE")
CREATE TRIGGER ON CashierMember FOR DELETE AS _spTriggerExec("CashierMember","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CashierMember"
ALTER TABLE CashierMember ;
	ADD PRIMARY KEY CashierMemberID TAG CsrMembID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CashierMember"
ALTER TABLE CashierMember ;
	ADD FOREIGN KEY CashierGroupID TAG CsrGrpID ;
	REFERENCES CashierGroup TAG CsrGrpID
***
_RIRuleWrite("CashierMember", "CsrGrpID", "CashierGroup", "CsrGrpID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CashierMember"
ALTER TABLE CashierMember ;
	ADD FOREIGN KEY CashierID TAG CashierID ;
	REFERENCES Cashier TAG CashierID
***
_RIRuleWrite("CashierMember", "CashierID", "Cashier", "CashierID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CashierMember" ("Членство кассиров в группах")
_WriteMetaInf(lcTargetDBPath,"CashierMember","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CashierMember","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CashierMember","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CashierMember","META-INF","INCR_FLD","CashierMemberID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "StorageDepartment" ("Отделы магазина")
CREATE TABLE (lcTargetDBPath+"StorageDepartment") ( ;
	StorageDepartmentID I NOT NULL, ;
	StorageDepartmentNo C(4) NOT NULL ;
)
***
DBSETPROP("StorageDepartment","TABLE","COMMENT","Отделы магазина")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Отделы магазина"
CREATE TRIGGER ON StorageDepartment FOR INSERT AS _spTriggerExec("StorageDepartment","INSERT")
CREATE TRIGGER ON StorageDepartment FOR UPDATE AS _spTriggerExec("StorageDepartment","UPDATE")
CREATE TRIGGER ON StorageDepartment FOR DELETE AS _spTriggerExec("StorageDepartment","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "StorageDepartment"
ALTER TABLE StorageDepartment ;
	ADD PRIMARY KEY StorageDepartmentID TAG StDepID
***
_CreateRelation("StorageDepartment", "StDepID", "OrgUnit", "OUID")
_RIRuleWrite("StorageDepartment", "StDepID", "OrgUnit", "OUID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "StorageDepartment" ("Отделы магазина")
_WriteMetaInf(lcTargetDBPath,"StorageDepartment","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"StorageDepartment","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"StorageDepartment","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmTypeCustomFunc" ("Привязка ДФ к типу документа")
CREATE TABLE (lcTargetDBPath+"FrmTypeCustomFunc") ( ;
	FrmTypeCstFuncID I NOT NULL DEFAULT spIncrementID("FrmTypeCustomFunc"), ;
	CstFuncID I NOT NULL, ;
	FrmTypeID I NOT NULL ;
)
***
DBSETPROP("FrmTypeCustomFunc","TABLE","COMMENT","Привязка ДФ к типу документа")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Привязка ДФ к типу документа"
CREATE TRIGGER ON FrmTypeCustomFunc FOR INSERT AS _spTriggerExec("FrmTypeCustomFunc","INSERT")
CREATE TRIGGER ON FrmTypeCustomFunc FOR UPDATE AS _spTriggerExec("FrmTypeCustomFunc","UPDATE")
CREATE TRIGGER ON FrmTypeCustomFunc FOR DELETE AS _spTriggerExec("FrmTypeCustomFunc","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "FrmTypeCustomFunc"
ALTER TABLE FrmTypeCustomFunc ;
	ADD PRIMARY KEY FrmTypeCstFuncID TAG FrmTypCFID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmTypeCustomFunc"
ALTER TABLE FrmTypeCustomFunc ;
	ADD FOREIGN KEY CstFuncID TAG CustFuncID ;
	REFERENCES CustomFunc TAG CustFuncID
***
_RIRuleWrite("FrmTypeCustomFunc", "CustFuncID", "CustomFunc", "CustFuncID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmTypeCustomFunc"
ALTER TABLE FrmTypeCustomFunc ;
	ADD FOREIGN KEY FrmTypeID TAG FrmTypeID ;
	REFERENCES FrmType TAG FrmTypeID
***
_RIRuleWrite("FrmTypeCustomFunc", "FrmTypeID", "FrmType", "FrmTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmTypeCustomFunc" ("Привязка ДФ к типу документа")
_WriteMetaInf(lcTargetDBPath,"FrmTypeCustomFunc","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmTypeCustomFunc","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmTypeCustomFunc","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmTypeCustomFunc","META-INF","INCR_FLD","FrmTypeCstFuncID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CltTel" ("Телефоны")
CREATE TABLE (lcTargetDBPath+"CltTel") ( ;
	CltTelID I NOT NULL, ;
	CltID I NOT NULL, ;
	CltAddrID I NULL, ;
	CltTelNumber C(20) NOT NULL, ;
	CltTelNote C(100) NOT NULL, ;
	CltTelIsMain L NOT NULL, ;
	User_ I NOT NULL, ;
	Stamp_ T NOT NULL ;
)
***
DBSETPROP("CltTel","TABLE","COMMENT","Телефоны")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Телефоны"
CREATE TRIGGER ON CltTel FOR INSERT AS _spTriggerExec("CltTel","INSERT")
CREATE TRIGGER ON CltTel FOR UPDATE AS _spTriggerExec("CltTel","UPDATE")
CREATE TRIGGER ON CltTel FOR DELETE AS _spTriggerExec("CltTel","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CltTel"
ALTER TABLE CltTel ;
	ADD PRIMARY KEY CltTelID TAG CltTelID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CltTel"
ALTER TABLE CltTel ;
	ADD FOREIGN KEY CltAddrID TAG CltAddrID ;
	REFERENCES CltAddress TAG CltAddrID
***
_RIRuleWrite("CltTel", "CltAddrID", "CltAddress", "CltAddrID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CltTel"
ALTER TABLE CltTel ;
	ADD FOREIGN KEY CltID TAG CltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("CltTel", "CltID", "Client", "CltID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CltTel" ("Телефоны")
_WriteMetaInf(lcTargetDBPath,"CltTel","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CltTel","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CltTel","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Package" ("Фасовка товара")
CREATE TABLE (lcTargetDBPath+"Package") ( ;
	TvrId I NOT NULL, ;
	TvPkgTypeId I NOT NULL, ;
	PkgTypeId I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("Package","TABLE","COMMENT","Фасовка товара")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Фасовка товара"
CREATE TRIGGER ON Package FOR INSERT AS _spTriggerExec("Package","INSERT")
CREATE TRIGGER ON Package FOR UPDATE AS _spTriggerExec("Package","UPDATE")
CREATE TRIGGER ON Package FOR DELETE AS _spTriggerExec("Package","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Package"
ALTER TABLE Package ;
	ADD PRIMARY KEY TvrId TAG TvrId
***
_CreateRelation("Package", "TvrId", "Tovar", "TvrId")
_RIRuleWrite("Package", "TvrId", "Tovar", "TvrId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Package"
ALTER TABLE Package ;
	ADD FOREIGN KEY PkgTypeId TAG PkgTypeId ;
	REFERENCES PkgType TAG PkgTypeId
***
_RIRuleWrite("Package", "PkgTypeId", "PkgType", "PkgTypeId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Package"
ALTER TABLE Package ;
	ADD FOREIGN KEY TvPkgTypeId TAG TPkgTypeId ;
	REFERENCES PkgType TAG PkgTypeId
***
_RIRuleWrite("Package", "TPkgTypeId", "PkgType", "PkgTypeId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Package" ("Фасовка товара")
_WriteMetaInf(lcTargetDBPath,"Package","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Package","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Package","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmTypePay" ("Типы документов на оплату")
CREATE TABLE (lcTargetDBPath+"FrmTypePay") ( ;
	FrmTypePayID I NOT NULL DEFAULT spIncrementID("FrmTypePay"), ;
	FrmTypeID I NOT NULL, ;
	IncludeFrmTypeID I NOT NULL, ;
	IsDefault L NOT NULL, ;
	User_ I NOT NULL, ;
	Stamp_ T NOT NULL ;
)
***
DBSETPROP("FrmTypePay","TABLE","COMMENT","Типы документов на оплату")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Типы документов на оплату"
CREATE TRIGGER ON FrmTypePay FOR INSERT AS _spTriggerExec("FrmTypePay","INSERT")
CREATE TRIGGER ON FrmTypePay FOR UPDATE AS _spTriggerExec("FrmTypePay","UPDATE")
CREATE TRIGGER ON FrmTypePay FOR DELETE AS _spTriggerExec("FrmTypePay","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "FrmTypePay"
ALTER TABLE FrmTypePay ;
	ADD PRIMARY KEY FrmTypePayID TAG FrmTPayID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmTypePay"
ALTER TABLE FrmTypePay ;
	ADD FOREIGN KEY FrmTypeID TAG FrmTypeID ;
	REFERENCES FrmType TAG FrmTypeID
***
_RIRuleWrite("FrmTypePay", "FrmTypeID", "FrmType", "FrmTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmTypePay"
ALTER TABLE FrmTypePay ;
	ADD FOREIGN KEY IncludeFrmTypeID TAG IncFrmTID ;
	REFERENCES FrmType TAG FrmTypeID
***
_RIRuleWrite("FrmTypePay", "IncFrmTID", "FrmType", "FrmTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmTypePay" ("Типы документов на оплату")
_WriteMetaInf(lcTargetDBPath,"FrmTypePay","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmTypePay","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmTypePay","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmTypePay","META-INF","INCR_FLD","FrmTypePayID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "SprOper" ("Справочник операций")
CREATE TABLE (lcTargetDBPath+"SprOper") ( ;
	OperID I NOT NULL DEFAULT spIncrementID("SprOper"), ;
	FrmTypeID I NOT NULL, ;
	OperNM C(40) NULL, ;
	OperNote C(100) NULL, ;
	OperSign N(10,3) NULL, ;
	IsDefault L NOT NULL, ;
	IsManual L NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("SprOper","TABLE","COMMENT","Справочник операций")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Справочник операций"
CREATE TRIGGER ON SprOper FOR INSERT AS _spTriggerExec("SprOper","INSERT")
CREATE TRIGGER ON SprOper FOR UPDATE AS _spTriggerExec("SprOper","UPDATE")
CREATE TRIGGER ON SprOper FOR DELETE AS _spTriggerExec("SprOper","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "SprOper"
ALTER TABLE SprOper ;
	ADD PRIMARY KEY OperID TAG OperID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "SprOper"
ALTER TABLE SprOper ;
	ADD FOREIGN KEY FrmTypeID TAG FrmTypeID ;
	REFERENCES FrmType TAG FrmTypeID
***
_RIRuleWrite("SprOper", "FrmTypeID", "FrmType", "FrmTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "SprOper" ("Справочник операций")
_WriteMetaInf(lcTargetDBPath,"SprOper","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"SprOper","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"SprOper","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"SprOper","META-INF","INCR_FLD","OperID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "NatLoss" ("Естественная убыль")
CREATE TABLE (lcTargetDBPath+"NatLoss") ( ;
	TvrId I NOT NULL, ;
	NatLossIsUsed L NOT NULL, ;
	NatLossWinter N(6,2) NOT NULL, ;
	NatLossSpring N(6,2) NOT NULL, ;
	NatLossSummer N(6,2) NOT NULL, ;
	NatLossAutumn N(6,2) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("NatLoss","TABLE","COMMENT","Естественная убыль")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Естественная убыль"
CREATE TRIGGER ON NatLoss FOR INSERT AS _spTriggerExec("NatLoss","INSERT")
CREATE TRIGGER ON NatLoss FOR UPDATE AS _spTriggerExec("NatLoss","UPDATE")
CREATE TRIGGER ON NatLoss FOR DELETE AS _spTriggerExec("NatLoss","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "NatLoss"
ALTER TABLE NatLoss ;
	ADD PRIMARY KEY TvrId TAG TvrId
***
_CreateRelation("NatLoss", "TvrId", "Tovar", "TvrId")
_RIRuleWrite("NatLoss", "TvrId", "Tovar", "TvrId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "NatLoss" ("Естественная убыль")
_WriteMetaInf(lcTargetDBPath,"NatLoss","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"NatLoss","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"NatLoss","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CltPhysPassp" ("Удостоверения")
CREATE TABLE (lcTargetDBPath+"CltPhysPassp") ( ;
	CltPhysPasspID I NOT NULL DEFAULT spIncrementID("CltPhysPassp"), ;
	CltID I NOT NULL, ;
	CltPhysPasspSeries C(20) NOT NULL, ;
	CltPhysPasspNumber C(20) NOT NULL, ;
	CltPhysPasspIssueBy C(100) NOT NULL, ;
	CltPhysPasspIssueDate T NULL, ;
	CltPhysPasspExpDate T NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("CltPhysPassp","TABLE","COMMENT","Удостоверения")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Удостоверения"
CREATE TRIGGER ON CltPhysPassp FOR INSERT AS _spTriggerExec("CltPhysPassp","INSERT")
CREATE TRIGGER ON CltPhysPassp FOR UPDATE AS _spTriggerExec("CltPhysPassp","UPDATE")
CREATE TRIGGER ON CltPhysPassp FOR DELETE AS _spTriggerExec("CltPhysPassp","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CltPhysPassp"
ALTER TABLE CltPhysPassp ;
	ADD PRIMARY KEY CltPhysPasspID TAG PhysPspID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CltPhysPassp"
ALTER TABLE CltPhysPassp ;
	ADD FOREIGN KEY CltID TAG CltID ;
	REFERENCES CltPhysical TAG CltID
***
_RIRuleWrite("CltPhysPassp", "CltID", "CltPhysical", "CltID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CltPhysPassp" ("Удостоверения")
_WriteMetaInf(lcTargetDBPath,"CltPhysPassp","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CltPhysPassp","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CltPhysPassp","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CltPhysPassp","META-INF","INCR_FLD","CltPhysPasspID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "UserGrant" ("Разрешения пользователей")
CREATE TABLE (lcTargetDBPath+"UserGrant") ( ;
	UserId I NOT NULL, ;
	UserGrantID I NOT NULL DEFAULT spIncrementID("UserGrant"), ;
	ObjectTypeID I NOT NULL, ;
	ObjectID I NOT NULL, ;
	ObjectFuncBit I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("UserGrant","TABLE","COMMENT","Разрешения пользователей")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Разрешения пользователей"
CREATE TRIGGER ON UserGrant FOR INSERT AS _spTriggerExec("UserGrant","INSERT")
CREATE TRIGGER ON UserGrant FOR UPDATE AS _spTriggerExec("UserGrant","UPDATE")
CREATE TRIGGER ON UserGrant FOR DELETE AS _spTriggerExec("UserGrant","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "UserGrant"
ALTER TABLE UserGrant ;
	ADD PRIMARY KEY UserGrantID TAG UserGID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "UserGrant"
ALTER TABLE UserGrant ;
	ADD FOREIGN KEY ObjectTypeID TAG ObjTypeID ;
	REFERENCES ObjectType TAG ObjTypeID
***
_RIRuleWrite("UserGrant", "ObjTypeID", "ObjectType", "ObjTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "UserGrant"
ALTER TABLE UserGrant ;
	ADD FOREIGN KEY UserId TAG UserId ;
	REFERENCES AppUser TAG UserId
***
_RIRuleWrite("UserGrant", "UserId", "AppUser", "UserId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "UserGrant" ("Разрешения пользователей")
_WriteMetaInf(lcTargetDBPath,"UserGrant","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"UserGrant","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"UserGrant","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"UserGrant","META-INF","INCR_FLD","UserGrantID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "ScrFrmViewObj" ("Документы для формы")
CREATE TABLE (lcTargetDBPath+"ScrFrmViewObj") ( ;
	ScrFrmViewObjID I NOT NULL DEFAULT spIncrementID("ScrFrmViewObj"), ;
	FrmTypeID I NOT NULL, ;
	ScrFrmID I NOT NULL ;
)
***
DBSETPROP("ScrFrmViewObj","TABLE","COMMENT","Документы для формы")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Документы для формы"
CREATE TRIGGER ON ScrFrmViewObj FOR INSERT AS _spTriggerExec("ScrFrmViewObj","INSERT")
CREATE TRIGGER ON ScrFrmViewObj FOR UPDATE AS _spTriggerExec("ScrFrmViewObj","UPDATE")
CREATE TRIGGER ON ScrFrmViewObj FOR DELETE AS _spTriggerExec("ScrFrmViewObj","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "ScrFrmViewObj"
ALTER TABLE ScrFrmViewObj ;
	ADD PRIMARY KEY ScrFrmViewObjID TAG ScrFrmOID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "ScrFrmViewObj"
ALTER TABLE ScrFrmViewObj ;
	ADD FOREIGN KEY FrmTypeID TAG FrmTypeID ;
	REFERENCES FrmType TAG FrmTypeID
***
_RIRuleWrite("ScrFrmViewObj", "FrmTypeID", "FrmType", "FrmTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "ScrFrmViewObj"
ALTER TABLE ScrFrmViewObj ;
	ADD FOREIGN KEY ScrFrmID TAG ScrFrmID ;
	REFERENCES ScreenForm TAG ScrFrmID
***
_RIRuleWrite("ScrFrmViewObj", "ScrFrmID", "ScreenForm", "ScrFrmID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "ScrFrmViewObj" ("Документы для формы")
_WriteMetaInf(lcTargetDBPath,"ScrFrmViewObj","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmViewObj","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmViewObj","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"ScrFrmViewObj","META-INF","INCR_FLD","ScrFrmViewObjID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmTypeAutoNum" ("Параметры автонумератора")
CREATE TABLE (lcTargetDBPath+"FrmTypeAutoNum") ( ;
	FrmTypeAutoNumID I NOT NULL DEFAULT spIncrementID("FrmTypeAutoNum"), ;
	FrmTypeID I NOT NULL, ;
	OUID I NULL, ;
	AutoNumIsEnabled L NOT NULL, ;
	AutoNumMask C(40) NOT NULL, ;
	FrmTypeIDIsConst L NOT NULL, ;
	FrmTypeIDConst I NOT NULL, ;
	OwnCltIDIsConst L NOT NULL, ;
	OwnCltIDConst I NOT NULL, ;
	OUIDIsConst L NOT NULL, ;
	OUIDConst I NOT NULL ;
)
***
DBSETPROP("FrmTypeAutoNum","TABLE","COMMENT","Параметры автонумератора")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Параметры автонумератора"
CREATE TRIGGER ON FrmTypeAutoNum FOR INSERT AS _spTriggerExec("FrmTypeAutoNum","INSERT")
CREATE TRIGGER ON FrmTypeAutoNum FOR UPDATE AS _spTriggerExec("FrmTypeAutoNum","UPDATE")
CREATE TRIGGER ON FrmTypeAutoNum FOR DELETE AS _spTriggerExec("FrmTypeAutoNum","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "FrmTypeAutoNum"
ALTER TABLE FrmTypeAutoNum ;
	ADD PRIMARY KEY FrmTypeAutoNumID TAG FRANumID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmTypeAutoNum"
ALTER TABLE FrmTypeAutoNum ;
	ADD FOREIGN KEY FrmTypeID TAG FrmTypeID ;
	REFERENCES FrmType TAG FrmTypeID
***
_RIRuleWrite("FrmTypeAutoNum", "FrmTypeID", "FrmType", "FrmTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmTypeAutoNum"
ALTER TABLE FrmTypeAutoNum ;
	ADD FOREIGN KEY OUID TAG OUID ;
	REFERENCES OrgUnit TAG OUID
***
_RIRuleWrite("FrmTypeAutoNum", "OUID", "OrgUnit", "OUID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmTypeAutoNum" ("Параметры автонумератора")
_WriteMetaInf(lcTargetDBPath,"FrmTypeAutoNum","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmTypeAutoNum","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmTypeAutoNum","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmTypeAutoNum","META-INF","INCR_FLD","FrmTypeAutoNumID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Cash" ("Кассы")
CREATE TABLE (lcTargetDBPath+"Cash") ( ;
	CashID I NOT NULL DEFAULT spIncrementID("Cash"), ;
	CashNo C(3) NOT NULL, ;
	CashNM C(40) NOT NULL, ;
	CashIsActive L NOT NULL DEFAULT .T., ;
	CashStorageID I NOT NULL, ;
	CashStoragePlace I NULL ;
)
***
DBSETPROP("Cash","TABLE","COMMENT","Кассы")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Кассы"
CREATE TRIGGER ON Cash FOR INSERT AS _spTriggerExec("Cash","INSERT")
CREATE TRIGGER ON Cash FOR UPDATE AS _spTriggerExec("Cash","UPDATE")
CREATE TRIGGER ON Cash FOR DELETE AS _spTriggerExec("Cash","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Cash"
ALTER TABLE Cash ;
	ADD PRIMARY KEY CashID TAG CashID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Cash"
ALTER TABLE Cash ;
	ADD FOREIGN KEY CashStorageID TAG CashStID ;
	REFERENCES OrgUnit TAG OUID
***
_RIRuleWrite("Cash", "CashStID", "OrgUnit", "OUID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Cash"
ALTER TABLE Cash ;
	ADD FOREIGN KEY CashStoragePlace TAG CashSP ;
	REFERENCES OrgUnit TAG OUID
***
_RIRuleWrite("Cash", "CashSP", "OrgUnit", "OUID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Cash" ("Кассы")
_WriteMetaInf(lcTargetDBPath,"Cash","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Cash","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Cash","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"Cash","META-INF","INCR_FLD","CashID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Device" ("Device")
CREATE TABLE (lcTargetDBPath+"Device") ( ;
	DeviceID I NOT NULL DEFAULT spIncrementID("Device"), ;
	DeviceParID I NULL, ;
	DeviceModelID I NOT NULL, ;
	DeviceDriverID I NULL, ;
	DeviceNM C(40) NOT NULL, ;
	DeviceINI M NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("Device","TABLE","COMMENT","Device")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Device"
CREATE TRIGGER ON Device FOR INSERT AS _spTriggerExec("Device","INSERT")
CREATE TRIGGER ON Device FOR UPDATE AS _spTriggerExec("Device","UPDATE")
CREATE TRIGGER ON Device FOR DELETE AS _spTriggerExec("Device","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Device"
ALTER TABLE Device ;
	ADD PRIMARY KEY DeviceID TAG DeviceID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Device"
ALTER TABLE Device ;
	ADD FOREIGN KEY DeviceDriverID TAG DevDrvID ;
	REFERENCES DeviceDriver TAG DevDrvID
***
_RIRuleWrite("Device", "DevDrvID", "DeviceDriver", "DevDrvID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Device"
ALTER TABLE Device ;
	ADD FOREIGN KEY DeviceModelID TAG DevModelID ;
	REFERENCES DeviceModel TAG DevModelID
***
_RIRuleWrite("Device", "DevModelID", "DeviceModel", "DevModelID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Device"
ALTER TABLE Device ;
	ADD FOREIGN KEY DeviceParID TAG DevParID ;
	REFERENCES Device TAG DeviceID
***
_RIRuleWrite("Device", "DevParID", "Device", "DeviceID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Device" ("Device")
_WriteMetaInf(lcTargetDBPath,"Device","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Device","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Device","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"Device","META-INF","INCR_FLD","DeviceID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmTypeCopyOper" ("Изменение типа документа")
CREATE TABLE (lcTargetDBPath+"FrmTypeCopyOper") ( ;
	CopyOperID I NOT NULL DEFAULT spIncrementID("FrmTypeCopyOper"), ;
	FromFrmTypeID I NOT NULL, ;
	ToFrmTypeID I NOT NULL, ;
	CopyOperProcType N(1,0) NOT NULL, ;
	CopyOperProcNM C(40) NOT NULL ;
)
***
DBSETPROP("FrmTypeCopyOper","TABLE","COMMENT","Изменение типа документа")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Изменение типа документа"
CREATE TRIGGER ON FrmTypeCopyOper FOR INSERT AS _spTriggerExec("FrmTypeCopyOper","INSERT")
CREATE TRIGGER ON FrmTypeCopyOper FOR UPDATE AS _spTriggerExec("FrmTypeCopyOper","UPDATE")
CREATE TRIGGER ON FrmTypeCopyOper FOR DELETE AS _spTriggerExec("FrmTypeCopyOper","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "FrmTypeCopyOper"
ALTER TABLE FrmTypeCopyOper ;
	ADD PRIMARY KEY CopyOperID TAG CopyOperID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmTypeCopyOper"
ALTER TABLE FrmTypeCopyOper ;
	ADD FOREIGN KEY FromFrmTypeID TAG FromFTID ;
	REFERENCES FrmType TAG FrmTypeID
***
_RIRuleWrite("FrmTypeCopyOper", "FromFTID", "FrmType", "FrmTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmTypeCopyOper"
ALTER TABLE FrmTypeCopyOper ;
	ADD FOREIGN KEY ToFrmTypeID TAG ToFTID ;
	REFERENCES FrmType TAG FrmTypeID
***
_RIRuleWrite("FrmTypeCopyOper", "ToFTID", "FrmType", "FrmTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmTypeCopyOper" ("Изменение типа документа")
_WriteMetaInf(lcTargetDBPath,"FrmTypeCopyOper","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmTypeCopyOper","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmTypeCopyOper","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmTypeCopyOper","META-INF","INCR_FLD","CopyOperID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "TvrConstraint" ("Ограничение товара")
CREATE TABLE (lcTargetDBPath+"TvrConstraint") ( ;
	TvrCID I NOT NULL DEFAULT spIncrementID("TvrConstraint"), ;
	TvrId I NOT NULL, ;
	OUID I NOT NULL, ;
	TvrMinQnt N(10,3) NOT NULL, ;
	TvrMaxQnt N(10,3) NOT NULL ;
)
***
DBSETPROP("TvrConstraint","TABLE","COMMENT","Ограничение товара")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Ограничение товара"
CREATE TRIGGER ON TvrConstraint FOR INSERT AS _spTriggerExec("TvrConstraint","INSERT")
CREATE TRIGGER ON TvrConstraint FOR UPDATE AS _spTriggerExec("TvrConstraint","UPDATE")
CREATE TRIGGER ON TvrConstraint FOR DELETE AS _spTriggerExec("TvrConstraint","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "TvrConstraint"
ALTER TABLE TvrConstraint ;
	ADD PRIMARY KEY TvrCID TAG TvrCID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrConstraint"
ALTER TABLE TvrConstraint ;
	ADD FOREIGN KEY OUID TAG OUID ;
	REFERENCES OrgUnit TAG OUID
***
_RIRuleWrite("TvrConstraint", "OUID", "OrgUnit", "OUID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrConstraint"
ALTER TABLE TvrConstraint ;
	ADD FOREIGN KEY TvrId TAG TvrId ;
	REFERENCES Tovar TAG TvrId
***
_RIRuleWrite("TvrConstraint", "TvrId", "Tovar", "TvrId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "TvrConstraint" ("Ограничение товара")
_WriteMetaInf(lcTargetDBPath,"TvrConstraint","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrConstraint","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrConstraint","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrConstraint","META-INF","INCR_FLD","TvrCID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmNumCounter" ("Счётчик автонумератора")
CREATE TABLE (lcTargetDBPath+"FrmNumCounter") ( ;
	FrmNumCntID I NOT NULL DEFAULT spIncrementID("FrmNumCounter"), ;
	FrmTypeID I NULL, ;
	OwnCltID I NULL, ;
	OUID I NULL, ;
	FrmNumCntVal I NOT NULL ;
)
***
DBSETPROP("FrmNumCounter","TABLE","COMMENT","Счётчик автонумератора")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Счётчик автонумератора"
CREATE TRIGGER ON FrmNumCounter FOR INSERT AS _spTriggerExec("FrmNumCounter","INSERT")
CREATE TRIGGER ON FrmNumCounter FOR UPDATE AS _spTriggerExec("FrmNumCounter","UPDATE")
CREATE TRIGGER ON FrmNumCounter FOR DELETE AS _spTriggerExec("FrmNumCounter","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "FrmNumCounter"
ALTER TABLE FrmNumCounter ;
	ADD PRIMARY KEY FrmNumCntID TAG FNumCntID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmNumCounter"
ALTER TABLE FrmNumCounter ;
	ADD FOREIGN KEY FrmTypeID TAG FrmTypeID ;
	REFERENCES FrmType TAG FrmTypeID
***
_RIRuleWrite("FrmNumCounter", "FrmTypeID", "FrmType", "FrmTypeID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmNumCounter"
ALTER TABLE FrmNumCounter ;
	ADD FOREIGN KEY OUID TAG OUID ;
	REFERENCES OrgUnit TAG OUID
***
_RIRuleWrite("FrmNumCounter", "OUID", "OrgUnit", "OUID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmNumCounter"
ALTER TABLE FrmNumCounter ;
	ADD FOREIGN KEY OwnCltID TAG OwnCltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("FrmNumCounter", "OwnCltID", "Client", "CltID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmNumCounter" ("Счётчик автонумератора")
_WriteMetaInf(lcTargetDBPath,"FrmNumCounter","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmNumCounter","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmNumCounter","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmNumCounter","META-INF","INCR_FLD","FrmNumCntID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CheckSale" ("Чек")
CREATE TABLE (lcTargetDBPath+"CheckSale") ( ;
	CheckID I NOT NULL DEFAULT spIncrementID("CheckSale"), ;
	CheckTypeID I NOT NULL, ;
	CheckDiscCardNo C(20) NOT NULL, ;
	CheckStamp T NOT NULL, ;
	CheckCashierID I NOT NULL, ;
	CheckCashID I NOT NULL, ;
	CheckNo I NOT NULL, ;
	CheckBranchNo I NOT NULL, ;
	CheckAttributeID I NULL, ;
	SalesLogID I NOT NULL, ;
	DiscCardID I NULL ;
)
***
DBSETPROP("CheckSale","TABLE","COMMENT","Чек")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Чек"
CREATE TRIGGER ON CheckSale FOR INSERT AS _spTriggerExec("CheckSale","INSERT")
CREATE TRIGGER ON CheckSale FOR UPDATE AS _spTriggerExec("CheckSale","UPDATE")
CREATE TRIGGER ON CheckSale FOR DELETE AS _spTriggerExec("CheckSale","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CheckSale"
ALTER TABLE CheckSale ;
	ADD PRIMARY KEY CheckID TAG CheckID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CheckSale"
ALTER TABLE CheckSale ;
	ADD FOREIGN KEY CheckAttributeID TAG ChkAttrID ;
	REFERENCES CheckAttribute TAG ChkAttrID
***
_RIRuleWrite("CheckSale", "ChkAttrID", "CheckAttribute", "ChkAttrID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CheckSale"
ALTER TABLE CheckSale ;
	ADD FOREIGN KEY CheckTypeID TAG ChkTypeID ;
	REFERENCES CheckType TAG ChkTypeID
***
_RIRuleWrite("CheckSale", "ChkTypeID", "CheckType", "ChkTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CheckSale"
ALTER TABLE CheckSale ;
	ADD FOREIGN KEY DiscCardID TAG DiscCardID ;
	REFERENCES DiscCard TAG DiscCardID
***
_RIRuleWrite("CheckSale", "DiscCardID", "DiscCard", "DiscCardID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CheckSale"
ALTER TABLE CheckSale ;
	ADD FOREIGN KEY SalesLogID TAG SalesLogID ;
	REFERENCES SalesLog TAG SalesLogID
***
_RIRuleWrite("CheckSale", "SalesLogID", "SalesLog", "SalesLogID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CheckSale" ("Чек")
_WriteMetaInf(lcTargetDBPath,"CheckSale","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckSale","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckSale","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckSale","META-INF","INCR_FLD","CheckID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "ActionRule" ("Правило действия")
CREATE TABLE (lcTargetDBPath+"ActionRule") ( ;
	ActionRuleID I NOT NULL DEFAULT spIncrementID("ActionRule"), ;
	ActionRuleNM C(40) NOT NULL, ;
	ActionRulePointEmi I NOT NULL, ;
	ActionRulePointIsp I NOT NULL, ;
	ActionRuleStockID I NULL, ;
	ActionRuleType I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("ActionRule","TABLE","COMMENT","Правило действия")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Правило действия"
CREATE TRIGGER ON ActionRule FOR INSERT AS _spTriggerExec("ActionRule","INSERT")
CREATE TRIGGER ON ActionRule FOR UPDATE AS _spTriggerExec("ActionRule","UPDATE")
CREATE TRIGGER ON ActionRule FOR DELETE AS _spTriggerExec("ActionRule","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "ActionRule"
ALTER TABLE ActionRule ;
	ADD PRIMARY KEY ActionRuleID TAG ActRuleID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "ActionRule"
ALTER TABLE ActionRule ;
	ADD FOREIGN KEY ActionRulePointEmi TAG ActRPIsp ;
	REFERENCES Cash TAG CashID
***
_RIRuleWrite("ActionRule", "ActRPIsp", "Cash", "CashID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "ActionRule"
ALTER TABLE ActionRule ;
	ADD FOREIGN KEY ActionRulePointIsp TAG ActRPEmi ;
	REFERENCES Device TAG DeviceID
***
_RIRuleWrite("ActionRule", "ActRPEmi", "Device", "DeviceID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "ActionRule"
ALTER TABLE ActionRule ;
	ADD FOREIGN KEY ActionRuleStockID TAG ActRSID ;
	REFERENCES OrgUnit TAG OUID
***
_RIRuleWrite("ActionRule", "ActRSID", "OrgUnit", "OUID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "ActionRule" ("Правило действия")
_WriteMetaInf(lcTargetDBPath,"ActionRule","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"ActionRule","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"ActionRule","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"ActionRule","META-INF","INCR_FLD","ActionRuleID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "TluInDpt" ("Товары в отделах")
CREATE TABLE (lcTargetDBPath+"TluInDpt") ( ;
	TluInDptID I NOT NULL DEFAULT spIncrementID("TluInDpt"), ;
	TluInDptStorageDepartmentID I NOT NULL, ;
	TluInDptTLUId I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("TluInDpt","TABLE","COMMENT","Товары в отделах")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Товары в отделах"
CREATE TRIGGER ON TluInDpt FOR INSERT AS _spTriggerExec("TluInDpt","INSERT")
CREATE TRIGGER ON TluInDpt FOR UPDATE AS _spTriggerExec("TluInDpt","UPDATE")
CREATE TRIGGER ON TluInDpt FOR DELETE AS _spTriggerExec("TluInDpt","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "TluInDpt"
ALTER TABLE TluInDpt ;
	ADD PRIMARY KEY TluInDptID TAG TluInDptID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TluInDpt"
ALTER TABLE TluInDpt ;
	ADD FOREIGN KEY TluInDptStorageDepartmentID TAG StDepID ;
	REFERENCES OrgUnit TAG OUID
***
_RIRuleWrite("TluInDpt", "StDepID", "OrgUnit", "OUID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TluInDpt"
ALTER TABLE TluInDpt ;
	ADD FOREIGN KEY TluInDptTLUId TAG TLUID ;
	REFERENCES TvrLookUp TAG TLUId
***
_RIRuleWrite("TluInDpt", "TLUID", "TvrLookUp", "TLUId", "RCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "TluInDpt" ("Товары в отделах")
_WriteMetaInf(lcTargetDBPath,"TluInDpt","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"TluInDpt","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"TluInDpt","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"TluInDpt","META-INF","INCR_FLD","TluInDptID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CheckTrans" ("Транзакции чека")
CREATE TABLE (lcTargetDBPath+"CheckTrans") ( ;
	CheckTransUID I NOT NULL DEFAULT spIncrementID("CheckTrans"), ;
	CheckTransID I NOT NULL, ;
	CheckID I NOT NULL, ;
	CheckTransTypeID I NOT NULL, ;
	CheckTransTvrId I NULL, ;
	CheckTransPLU C(20) NOT NULL, ;
	CheckTransDepartNo I NOT NULL, ;
	CheckTransQnt N(10,3) NOT NULL, ;
	CheckTransPrc Y NOT NULL ;
)
***
DBSETPROP("CheckTrans","TABLE","COMMENT","Транзакции чека")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Транзакции чека"
CREATE TRIGGER ON CheckTrans FOR INSERT AS _spTriggerExec("CheckTrans","INSERT")
CREATE TRIGGER ON CheckTrans FOR UPDATE AS _spTriggerExec("CheckTrans","UPDATE")
CREATE TRIGGER ON CheckTrans FOR DELETE AS _spTriggerExec("CheckTrans","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CheckTrans"
ALTER TABLE CheckTrans ;
	ADD PRIMARY KEY CheckTransUID TAG ChkTransID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CheckTrans"
ALTER TABLE CheckTrans ;
	ADD FOREIGN KEY CheckID TAG CheckID ;
	REFERENCES CheckSale TAG CheckID
***
_RIRuleWrite("CheckTrans", "CheckID", "CheckSale", "CheckID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CheckTrans"
ALTER TABLE CheckTrans ;
	ADD FOREIGN KEY CheckTransTvrId TAG ChkTTvrID ;
	REFERENCES Tovar TAG TvrId
***
_RIRuleWrite("CheckTrans", "ChkTTvrID", "Tovar", "TvrId", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CheckTrans"
ALTER TABLE CheckTrans ;
	ADD FOREIGN KEY CheckTransTypeID TAG ChkTTypeID ;
	REFERENCES CheckTransType TAG ChkTranTID
***
_RIRuleWrite("CheckTrans", "ChkTTypeID", "CheckTransType", "ChkTranTID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CheckTrans" ("Транзакции чека")
_WriteMetaInf(lcTargetDBPath,"CheckTrans","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckTrans","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckTrans","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckTrans","META-INF","INCR_FLD","CheckTransUID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Form" ("Форма")
CREATE TABLE (lcTargetDBPath+"Form") ( ;
	FrmID I NOT NULL DEFAULT spIncrementID("Form"), ;
	FrmParID I NULL, ;
	FrmTypeID I NOT NULL, ;
	FrmDate T NOT NULL, ;
	FrmDateAcc T NOT NULL, ;
	FrmNum C(20) NOT NULL, ;
	FrmNote C(100) NOT NULL, ;
	FrmReason C(100) NOT NULL, ;
	FrmStatusID I NOT NULL, ;
	FrmIsPayed L NOT NULL, ;
	PointEmiOUID I NULL, ;
	PointEmiCltID I NULL, ;
	PointIspOUID I NULL, ;
	PointIspCltID I NULL, ;
	DevCltID I NULL, ;
	ExecEmiCltID I NULL, ;
	ExecIspCltID I NULL, ;
	ContrCltID I NULL, ;
	PointEmiCltSAccID I NULL, ;
	PointIspCltSAccID I NULL, ;
	FrmPrcTypeId I NULL, ;
	FrmCurTypeId I NOT NULL, ;
	FrmAttribute I NOT NULL, ;
	OperID I NULL, ;
	ID_ N(16,0) NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("Form","TABLE","COMMENT","Форма")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Форма"
CREATE TRIGGER ON Form FOR INSERT AS _spTriggerExec("Form","INSERT")
CREATE TRIGGER ON Form FOR UPDATE AS _spTriggerExec("Form","UPDATE","spFrmUpdateMaster()")
CREATE TRIGGER ON Form FOR DELETE AS _spTriggerExec("Form","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Form"
ALTER TABLE Form ;
	ADD PRIMARY KEY FrmID TAG FrmID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY ContrCltID TAG ContrCltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("Form", "ContrCltID", "Client", "CltID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY DevCltID TAG DevCltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("Form", "DevCltID", "Client", "CltID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY ExecEmiCltID TAG ExecECltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("Form", "ExecECltID", "Client", "CltID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY ExecIspCltID TAG ExecICltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("Form", "ExecICltID", "Client", "CltID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY FrmCurTypeId TAG CurTypeID ;
	REFERENCES CurType TAG CurTypeId
***
_RIRuleWrite("Form", "CurTypeID", "CurType", "CurTypeId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY FrmParID TAG FrmParID ;
	REFERENCES Form TAG FrmID
***
_RIRuleWrite("Form", "FrmParID", "Form", "FrmID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY FrmPrcTypeId TAG FrmPrcTID ;
	REFERENCES PrcType TAG PrcTypeId
***
_RIRuleWrite("Form", "FrmPrcTID", "PrcType", "PrcTypeId", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY FrmStatusID TAG StatusID ;
	REFERENCES FrmStatus TAG FrmStatID
***
_RIRuleWrite("Form", "StatusID", "FrmStatus", "FrmStatID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY FrmTypeID TAG FrmTypeID ;
	REFERENCES FrmType TAG FrmTypeID
***
_RIRuleWrite("Form", "FrmTypeID", "FrmType", "FrmTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY OperID TAG OperID ;
	REFERENCES SprOper TAG OperID
***
_RIRuleWrite("Form", "OperID", "SprOper", "OperID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY PointEmiCltID TAG PEmiCltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("Form", "PEmiCltID", "Client", "CltID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY PointEmiCltSAccID TAG PECltSAID ;
	REFERENCES CltSAccount TAG CltSAccID
***
_RIRuleWrite("Form", "PECltSAID", "CltSAccount", "CltSAccID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY PointEmiOUID TAG PEmiOUID ;
	REFERENCES OrgUnit TAG OUID
***
_RIRuleWrite("Form", "PEmiOUID", "OrgUnit", "OUID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY PointIspCltID TAG PIspCltID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("Form", "PIspCltID", "Client", "CltID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY PointIspCltSAccID TAG PICltSAID ;
	REFERENCES CltSAccount TAG CltSAccID
***
_RIRuleWrite("Form", "PICltSAID", "CltSAccount", "CltSAccID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Form"
ALTER TABLE Form ;
	ADD FOREIGN KEY PointIspOUID TAG PIspOUID ;
	REFERENCES OrgUnit TAG OUID
***
_RIRuleWrite("Form", "PIspOUID", "OrgUnit", "OUID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Form" ("Форма")
_WriteMetaInf(lcTargetDBPath,"Form","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Form","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Form","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"Form","META-INF","INCR_FLD","FrmID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "SprProv" ("Справочник проводок")
CREATE TABLE (lcTargetDBPath+"SprProv") ( ;
	ProvID I NOT NULL DEFAULT spIncrementID("SprProv"), ;
	OperID I NOT NULL, ;
	DebetID I NOT NULL, ;
	CreditID I NOT NULL, ;
	DebetNote C(40) NULL, ;
	CreditNote C(40) NULL, ;
	ProvFormula C(150) NULL, ;
	ProvNote C(100) NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("SprProv","TABLE","COMMENT","Справочник проводок")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Справочник проводок"
CREATE TRIGGER ON SprProv FOR INSERT AS _spTriggerExec("SprProv","INSERT")
CREATE TRIGGER ON SprProv FOR UPDATE AS _spTriggerExec("SprProv","UPDATE")
CREATE TRIGGER ON SprProv FOR DELETE AS _spTriggerExec("SprProv","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "SprProv"
ALTER TABLE SprProv ;
	ADD PRIMARY KEY ProvID TAG AProvID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "SprProv"
ALTER TABLE SprProv ;
	ADD FOREIGN KEY CreditID TAG CreditID ;
	REFERENCES AccBuch TAG AccID
***
_RIRuleWrite("SprProv", "CreditID", "AccBuch", "AccID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "SprProv"
ALTER TABLE SprProv ;
	ADD FOREIGN KEY DebetID TAG DebetID ;
	REFERENCES AccBuch TAG AccID
***
_RIRuleWrite("SprProv", "DebetID", "AccBuch", "AccID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "SprProv"
ALTER TABLE SprProv ;
	ADD FOREIGN KEY OperID TAG OperID ;
	REFERENCES SprOper TAG OperID
***
_RIRuleWrite("SprProv", "OperID", "SprOper", "OperID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "SprProv" ("Справочник проводок")
_WriteMetaInf(lcTargetDBPath,"SprProv","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"SprProv","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"SprProv","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"SprProv","META-INF","INCR_FLD","ProvID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Storage" ("Магазин")
CREATE TABLE (lcTargetDBPath+"Storage") ( ;
	StorageID I NOT NULL, ;
	StoragePrcTypeId I NOT NULL, ;
	StorageDeviceID I NOT NULL, ;
	StorageNo C(4) NOT NULL, ;
	CashierGroupID I NULL ;
)
***
DBSETPROP("Storage","TABLE","COMMENT","Магазин")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Магазин"
CREATE TRIGGER ON Storage FOR INSERT AS _spTriggerExec("Storage","INSERT")
CREATE TRIGGER ON Storage FOR UPDATE AS _spTriggerExec("Storage","UPDATE")
CREATE TRIGGER ON Storage FOR DELETE AS _spTriggerExec("Storage","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Storage"
ALTER TABLE Storage ;
	ADD PRIMARY KEY StorageID TAG StorageID
***
_CreateRelation("Storage", "StorageID", "OrgUnit", "OUID")
_RIRuleWrite("Storage", "StorageID", "OrgUnit", "OUID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Storage"
ALTER TABLE Storage ;
	ADD FOREIGN KEY CashierGroupID TAG CsrGrpID ;
	REFERENCES CashierGroup TAG CsrGrpID
***
_RIRuleWrite("Storage", "CsrGrpID", "CashierGroup", "CsrGrpID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Storage"
ALTER TABLE Storage ;
	ADD FOREIGN KEY StorageDeviceID TAG StDevID ;
	REFERENCES Device TAG DeviceID
***
_RIRuleWrite("Storage", "StDevID", "Device", "DeviceID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Storage"
ALTER TABLE Storage ;
	ADD FOREIGN KEY StoragePrcTypeId TAG StPTID ;
	REFERENCES PrcType TAG PrcTypeId
***
_RIRuleWrite("Storage", "StPTID", "PrcType", "PrcTypeId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Storage" ("Магазин")
_WriteMetaInf(lcTargetDBPath,"Storage","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Storage","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Storage","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "CheckPayment" ("Оплата по чеку")
CREATE TABLE (lcTargetDBPath+"CheckPayment") ( ;
	CheckPaymentID I NOT NULL DEFAULT spIncrementID("CheckPayment"), ;
	CheckPaymentTypeID I NOT NULL, ;
	CheckID I NOT NULL, ;
	CheckPaymentPANNo C(40) NOT NULL, ;
	CheckPaymentQnt N(10,3) NOT NULL, ;
	CheckPaymentPrcSum Y NOT NULL ;
)
***
DBSETPROP("CheckPayment","TABLE","COMMENT","Оплата по чеку")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Оплата по чеку"
CREATE TRIGGER ON CheckPayment FOR INSERT AS _spTriggerExec("CheckPayment","INSERT")
CREATE TRIGGER ON CheckPayment FOR UPDATE AS _spTriggerExec("CheckPayment","UPDATE")
CREATE TRIGGER ON CheckPayment FOR DELETE AS _spTriggerExec("CheckPayment","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "CheckPayment"
ALTER TABLE CheckPayment ;
	ADD PRIMARY KEY CheckPaymentID TAG CHKPID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CheckPayment"
ALTER TABLE CheckPayment ;
	ADD FOREIGN KEY CheckID TAG CheckID ;
	REFERENCES CheckSale TAG CheckID
***
_RIRuleWrite("CheckPayment", "CheckID", "CheckSale", "CheckID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "CheckPayment"
ALTER TABLE CheckPayment ;
	ADD FOREIGN KEY CheckPaymentTypeID TAG ChkPayID ;
	REFERENCES CheckPaymentType TAG ChkPayTID
***
_RIRuleWrite("CheckPayment", "ChkPayID", "CheckPaymentType", "ChkPayTID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "CheckPayment" ("Оплата по чеку")
_WriteMetaInf(lcTargetDBPath,"CheckPayment","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckPayment","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckPayment","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"CheckPayment","META-INF","INCR_FLD","CheckPaymentID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "TvrInSet" ("TovarInSet")
CREATE TABLE (lcTargetDBPath+"TvrInSet") ( ;
	TvrInSetID I NOT NULL DEFAULT spIncrementID("TvrInSet"), ;
	TvrSetID I NOT NULL, ;
	TvrId I NOT NULL, ;
	TLUId I NULL, ;
	ListNumber I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("TvrInSet","TABLE","COMMENT","TovarInSet")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "TovarInSet"
CREATE TRIGGER ON TvrInSet FOR INSERT AS _spTriggerExec("TvrInSet","INSERT")
CREATE TRIGGER ON TvrInSet FOR UPDATE AS _spTriggerExec("TvrInSet","UPDATE")
CREATE TRIGGER ON TvrInSet FOR DELETE AS _spTriggerExec("TvrInSet","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "TvrInSet"
ALTER TABLE TvrInSet ;
	ADD PRIMARY KEY TvrInSetID TAG TvrInSetID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrInSet"
ALTER TABLE TvrInSet ;
	ADD FOREIGN KEY TLUId TAG TLUId ;
	REFERENCES TvrLookUp TAG TLUId
***
_RIRuleWrite("TvrInSet", "TLUId", "TvrLookUp", "TLUId", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrInSet"
ALTER TABLE TvrInSet ;
	ADD FOREIGN KEY TvrId TAG TvrId ;
	REFERENCES Tovar TAG TvrId
***
_RIRuleWrite("TvrInSet", "TvrId", "Tovar", "TvrId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "TvrInSet"
ALTER TABLE TvrInSet ;
	ADD FOREIGN KEY TvrSetID TAG TvrSetID ;
	REFERENCES TvrSet TAG TvrSetID
***
_RIRuleWrite("TvrInSet", "TvrSetID", "TvrSet", "TvrSetID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "TvrInSet" ("TovarInSet")
_WriteMetaInf(lcTargetDBPath,"TvrInSet","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrInSet","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrInSet","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"TvrInSet","META-INF","INCR_FLD","TvrInSetID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "POSActivity" ("Активность точек продажи")
CREATE TABLE (lcTargetDBPath+"POSActivity") ( ;
	POSActID I NOT NULL DEFAULT spIncrementID("POSActivity"), ;
	POSActSLID I NOT NULL, ;
	PosActCID I NOT NULL, ;
	PosActOpenStamp T NOT NULL, ;
	PosActCloseStamp T NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("POSActivity","TABLE","COMMENT","Активность точек продажи")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Активность точек продажи"
CREATE TRIGGER ON POSActivity FOR INSERT AS _spTriggerExec("POSActivity","INSERT")
CREATE TRIGGER ON POSActivity FOR UPDATE AS _spTriggerExec("POSActivity","UPDATE")
CREATE TRIGGER ON POSActivity FOR DELETE AS _spTriggerExec("POSActivity","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "POSActivity"
ALTER TABLE POSActivity ;
	ADD PRIMARY KEY POSActID TAG POSActID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "POSActivity"
ALTER TABLE POSActivity ;
	ADD FOREIGN KEY PosActCID TAG PosActCID ;
	REFERENCES Cash TAG CashID
***
_RIRuleWrite("POSActivity", "PosActCID", "Cash", "CashID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "POSActivity"
ALTER TABLE POSActivity ;
	ADD FOREIGN KEY POSActSLID TAG POSActSLID ;
	REFERENCES SalesLog TAG SalesLogID
***
_RIRuleWrite("POSActivity", "POSActSLID", "SalesLog", "SalesLogID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "POSActivity" ("Активность точек продажи")
_WriteMetaInf(lcTargetDBPath,"POSActivity","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"POSActivity","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"POSActivity","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"POSActivity","META-INF","INCR_FLD","POSActID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "SalesFormMap" ("Привязка документов к данным о продажах")
CREATE TABLE (lcTargetDBPath+"SalesFormMap") ( ;
	SalesFormMapID I NOT NULL DEFAULT spIncrementID("SalesFormMap"), ;
	SalesLogID I NOT NULL, ;
	FrmID I NOT NULL ;
)
***
DBSETPROP("SalesFormMap","TABLE","COMMENT","Привязка документов к данным о продажах")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Привязка документов к данным о продажах"
CREATE TRIGGER ON SalesFormMap FOR INSERT AS _spTriggerExec("SalesFormMap","INSERT")
CREATE TRIGGER ON SalesFormMap FOR UPDATE AS _spTriggerExec("SalesFormMap","UPDATE")
CREATE TRIGGER ON SalesFormMap FOR DELETE AS _spTriggerExec("SalesFormMap","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "SalesFormMap"
ALTER TABLE SalesFormMap ;
	ADD PRIMARY KEY SalesFormMapID TAG SFMapID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "SalesFormMap"
ALTER TABLE SalesFormMap ;
	ADD FOREIGN KEY FrmID TAG FrmID ;
	REFERENCES Form TAG FrmID
***
_RIRuleWrite("SalesFormMap", "FrmID", "Form", "FrmID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "SalesFormMap"
ALTER TABLE SalesFormMap ;
	ADD FOREIGN KEY SalesLogID TAG SalesLogID ;
	REFERENCES SalesLog TAG SalesLogID
***
_RIRuleWrite("SalesFormMap", "SalesLogID", "SalesLog", "SalesLogID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "SalesFormMap" ("Привязка документов к данным о продажах")
_WriteMetaInf(lcTargetDBPath,"SalesFormMap","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"SalesFormMap","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"SalesFormMap","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"SalesFormMap","META-INF","INCR_FLD","SalesFormMapID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "AccPrint" ("Правила печити")
CREATE TABLE (lcTargetDBPath+"AccPrint") ( ;
	AccPrintID I NOT NULL DEFAULT spIncrementID("AccPrint"), ;
	ActionRuleID I NOT NULL, ;
	TvrId I NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("AccPrint","TABLE","COMMENT","Правила печити")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Правила печити"
CREATE TRIGGER ON AccPrint FOR INSERT AS _spTriggerExec("AccPrint","INSERT")
CREATE TRIGGER ON AccPrint FOR UPDATE AS _spTriggerExec("AccPrint","UPDATE")
CREATE TRIGGER ON AccPrint FOR DELETE AS _spTriggerExec("AccPrint","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "AccPrint"
ALTER TABLE AccPrint ;
	ADD PRIMARY KEY AccPrintID TAG AccPrintID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "AccPrint"
ALTER TABLE AccPrint ;
	ADD FOREIGN KEY ActionRuleID TAG ActRuleID ;
	REFERENCES ActionRule TAG ActRuleID
***
_RIRuleWrite("AccPrint", "ActRuleID", "ActionRule", "ActRuleID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "AccPrint"
ALTER TABLE AccPrint ;
	ADD FOREIGN KEY TvrId TAG TvrId ;
	REFERENCES Tovar TAG TvrId
***
_RIRuleWrite("AccPrint", "TvrId", "Tovar", "TvrId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "AccPrint" ("Правила печити")
_WriteMetaInf(lcTargetDBPath,"AccPrint","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"AccPrint","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"AccPrint","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"AccPrint","META-INF","INCR_FLD","AccPrintID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "PracticalBook" ("Журнал хоз.операций")
CREATE TABLE (lcTargetDBPath+"PracticalBook") ( ;
	PBookID I NOT NULL DEFAULT spIncrementID("PracticalBook"), ;
	PBookFrmID I NOT NULL, ;
	PBookProvID I NOT NULL, ;
	PBookSum Y NOT NULL, ;
	PBookDate T NOT NULL, ;
	FrmPartId I NOT NULL, ;
	PBookNote C(150) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("PracticalBook","TABLE","COMMENT","Журнал хоз.операций")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Журнал хоз.операций"
CREATE TRIGGER ON PracticalBook FOR INSERT AS _spTriggerExec("PracticalBook","INSERT")
CREATE TRIGGER ON PracticalBook FOR UPDATE AS _spTriggerExec("PracticalBook","UPDATE")
CREATE TRIGGER ON PracticalBook FOR DELETE AS _spTriggerExec("PracticalBook","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "PracticalBook"
ALTER TABLE PracticalBook ;
	ADD PRIMARY KEY PBookID TAG PBookID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "PracticalBook"
ALTER TABLE PracticalBook ;
	ADD FOREIGN KEY PBookFrmID TAG PBookFrmID ;
	REFERENCES Form TAG FrmID
***
_RIRuleWrite("PracticalBook", "PBookFrmID", "Form", "FrmID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "PracticalBook"
ALTER TABLE PracticalBook ;
	ADD FOREIGN KEY PBookProvID TAG PBProvID ;
	REFERENCES SprProv TAG AProvID
***
_RIRuleWrite("PracticalBook", "PBProvID", "SprProv", "AProvID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "PracticalBook" ("Журнал хоз.операций")
_WriteMetaInf(lcTargetDBPath,"PracticalBook","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"PracticalBook","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"PracticalBook","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"PracticalBook","META-INF","INCR_FLD","PBookID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Accounting" ("Калькуляция")
CREATE TABLE (lcTargetDBPath+"Accounting") ( ;
	AccFrmID I NOT NULL, ;
	AccTvrId I NOT NULL, ;
	AccQnt N(10,3) NOT NULL, ;
	AccExit C(40) NOT NULL, ;
	AccNetto N(10,3) NOT NULL, ;
	AccIsActiv L NOT NULL, ;
	AccTCard C(40) NOT NULL, ;
	AccColor C(40) NOT NULL, ;
	AccPrice Y NOT NULL, ;
	AccAppr C(40) NOT NULL, ;
	AccTaste C(40) NOT NULL, ;
	AccSmell C(40) NOT NULL, ;
	AccState C(40) NOT NULL, ;
	AccTech M NOT NULL, ;
	AccCaloric N(10,3) NOT NULL, ;
	AccFiber N(10,3) NOT NULL, ;
	AccFat N(10,3) NOT NULL, ;
	AccCarb N(10,3) NOT NULL, ;
	AccNote C(100) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("Accounting","TABLE","COMMENT","Калькуляция")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Калькуляция"
CREATE TRIGGER ON Accounting FOR INSERT AS _spTriggerExec("Accounting","INSERT")
CREATE TRIGGER ON Accounting FOR UPDATE AS _spTriggerExec("Accounting","UPDATE")
CREATE TRIGGER ON Accounting FOR DELETE AS _spTriggerExec("Accounting","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Accounting"
ALTER TABLE Accounting ;
	ADD PRIMARY KEY AccFrmID TAG AccID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Accounting"
ALTER TABLE Accounting ;
	ADD FOREIGN KEY AccFrmID TAG AccFrmID ;
	REFERENCES Form TAG FrmID
***
_RIRuleWrite("Accounting", "AccFrmID", "Form", "FrmID", "III")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Accounting"
ALTER TABLE Accounting ;
	ADD FOREIGN KEY AccTvrId TAG TvrID ;
	REFERENCES Tovar TAG TvrId
***
_RIRuleWrite("Accounting", "TvrID", "Tovar", "TvrId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Accounting" ("Калькуляция")
_WriteMetaInf(lcTargetDBPath,"Accounting","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Accounting","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Accounting","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmPayQueue" ("Очередь документов на оплату")
CREATE TABLE (lcTargetDBPath+"FrmPayQueue") ( ;
	FrmPayQueueID I NOT NULL DEFAULT spIncrementID("FrmPayQueue"), ;
	FrmID I NOT NULL, ;
	FrmPaySum Y NOT NULL, ;
	FrmPayPlanDate T NOT NULL, ;
	Block L NOT NULL, ;
	User_ I NOT NULL, ;
	Stamp_ T NOT NULL ;
)
***
DBSETPROP("FrmPayQueue","TABLE","COMMENT","Очередь документов на оплату")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Очередь документов на оплату"
CREATE TRIGGER ON FrmPayQueue FOR INSERT AS _spTriggerExec("FrmPayQueue","INSERT")
CREATE TRIGGER ON FrmPayQueue FOR UPDATE AS _spTriggerExec("FrmPayQueue","UPDATE")
CREATE TRIGGER ON FrmPayQueue FOR DELETE AS _spTriggerExec("FrmPayQueue","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "FrmPayQueue"
ALTER TABLE FrmPayQueue ;
	ADD PRIMARY KEY FrmPayQueueID TAG FrmPayQID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmPayQueue"
ALTER TABLE FrmPayQueue ;
	ADD FOREIGN KEY FrmID TAG FrmID ;
	REFERENCES Form TAG FrmID
***
_RIRuleWrite("FrmPayQueue", "FrmID", "Form", "FrmID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmPayQueue" ("Очередь документов на оплату")
_WriteMetaInf(lcTargetDBPath,"FrmPayQueue","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPayQueue","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPayQueue","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPayQueue","META-INF","INCR_FLD","FrmPayQueueID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmPartTvr" ("Содержание товарных форм")
CREATE TABLE (lcTargetDBPath+"FrmPartTvr") ( ;
	FrmPartTvrID I NOT NULL DEFAULT spIncrementID("FrmPartTvr"), ;
	FrmID I NOT NULL, ;
	TvrId I NOT NULL, ;
	MsuId I NOT NULL, ;
	TvrQnt N(10,3) NOT NULL, ;
	TvrQntNetto N(10,3) NULL, ;
	TvrPrcBuy Y NOT NULL, ;
	TvrPrcSale Y NOT NULL, ;
	TvrVATRate N(6,2) NOT NULL, ;
	TvrExpiredDate T NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL, ;
	TvrIDCalc I NOT NULL, ;
	TvrAttr I NOT NULL ;
)
***
DBSETPROP("FrmPartTvr","TABLE","COMMENT","Содержание товарных форм")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Содержание товарных форм"
CREATE TRIGGER ON FrmPartTvr FOR INSERT AS _spTriggerExec("FrmPartTvr","INSERT")
CREATE TRIGGER ON FrmPartTvr FOR UPDATE AS _spTriggerExec("FrmPartTvr","UPDATE")
CREATE TRIGGER ON FrmPartTvr FOR DELETE AS _spTriggerExec("FrmPartTvr","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "FrmPartTvr"
ALTER TABLE FrmPartTvr ;
	ADD PRIMARY KEY FrmPartTvrID TAG PartTvrID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmPartTvr"
ALTER TABLE FrmPartTvr ;
	ADD FOREIGN KEY FrmID TAG FrmID ;
	REFERENCES Form TAG FrmID
***
_RIRuleWrite("FrmPartTvr", "FrmID", "Form", "FrmID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmPartTvr"
ALTER TABLE FrmPartTvr ;
	ADD FOREIGN KEY MsuId TAG MsuId ;
	REFERENCES MeasureUnit TAG MsuId
***
_RIRuleWrite("FrmPartTvr", "MsuId", "MeasureUnit", "MsuId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmPartTvr"
ALTER TABLE FrmPartTvr ;
	ADD FOREIGN KEY TvrId TAG TvrId ;
	REFERENCES Tovar TAG TvrId
***
_RIRuleWrite("FrmPartTvr", "TvrId", "Tovar", "TvrId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmPartTvr" ("Содержание товарных форм")
_WriteMetaInf(lcTargetDBPath,"FrmPartTvr","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPartTvr","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPartTvr","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPartTvr","META-INF","INCR_FLD","FrmPartTvrID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmPartFrm" ("Содержание суммовых форм")
CREATE TABLE (lcTargetDBPath+"FrmPartFrm") ( ;
	FrmPartFrmID I NOT NULL DEFAULT spIncrementID("FrmPartFrm"), ;
	FrmID I NOT NULL, ;
	CntFrmID I NULL, ;
	CntFrmIncludeSum Y NOT NULL, ;
	CntFrmSumSplitProcID I NOT NULL, ;
	FrmPartFrmNote C(100) NOT NULL, ;
	Stamp_ T NOT NULL, ;
	User_ I NOT NULL ;
)
***
DBSETPROP("FrmPartFrm","TABLE","COMMENT","Содержание суммовых форм")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Содержание суммовых форм"
CREATE TRIGGER ON FrmPartFrm FOR INSERT AS _spTriggerExec("FrmPartFrm","INSERT","spFrmPartFrmInsertMaster()")
CREATE TRIGGER ON FrmPartFrm FOR UPDATE AS _spTriggerExec("FrmPartFrm","UPDATE","spFrmPartFrmUpdateMaster()")
CREATE TRIGGER ON FrmPartFrm FOR DELETE AS _spTriggerExec("FrmPartFrm","DELETE","spFrmPartFrmDeleteMaster()")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "FrmPartFrm"
ALTER TABLE FrmPartFrm ;
	ADD PRIMARY KEY FrmPartFrmID TAG PartFrmID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmPartFrm"
ALTER TABLE FrmPartFrm ;
	ADD FOREIGN KEY CntFrmID TAG CntFrmID ;
	REFERENCES Form TAG FrmID
***
_RIRuleWrite("FrmPartFrm", "CntFrmID", "Form", "FrmID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmPartFrm"
ALTER TABLE FrmPartFrm ;
	ADD FOREIGN KEY CntFrmSumSplitProcID TAG SplitPrcID ;
	REFERENCES FrmSumSplitProc TAG SplitPrcID
***
_RIRuleWrite("FrmPartFrm", "SplitPrcID", "FrmSumSplitProc", "SplitPrcID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmPartFrm"
ALTER TABLE FrmPartFrm ;
	ADD FOREIGN KEY FrmID TAG FrmID ;
	REFERENCES Form TAG FrmID
***
_RIRuleWrite("FrmPartFrm", "FrmID", "Form", "FrmID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmPartFrm" ("Содержание суммовых форм")
_WriteMetaInf(lcTargetDBPath,"FrmPartFrm","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPartFrm","META-INF","TRIGGEREXECUTE","No")
_WriteMetaInf(lcTargetDBPath,"FrmPartFrm","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPartFrm","META-INF","INCR_FLD","FrmPartFrmID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmPayDetail" ("Документ_Банк")
CREATE TABLE (lcTargetDBPath+"FrmPayDetail") ( ;
	FrmID I NOT NULL, ;
	FrmPayDetailOrder C(2) NOT NULL, ;
	FrmPayDetailPayerStatus C(2) NOT NULL, ;
	FrmPayDetailCBC CHAR(20) NOT NULL, ;
	FrmPayDetailOCATO CHAR(11) NOT NULL, ;
	FrmPayDetailPurpose CHAR(2) NOT NULL, ;
	FrmPayDetailTaxPeriod CHAR(10) NOT NULL, ;
	FrmPayDetailNum C(15) NOT NULL, ;
	FrmPayDetailDate T NULL, ;
	FrmPayDetailType CHAR(2) NOT NULL ;
)
***
DBSETPROP("FrmPayDetail","TABLE","COMMENT","Документ_Банк")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Документ_Банк"
CREATE TRIGGER ON FrmPayDetail FOR INSERT AS _spTriggerExec("FrmPayDetail","INSERT")
CREATE TRIGGER ON FrmPayDetail FOR UPDATE AS _spTriggerExec("FrmPayDetail","UPDATE")
CREATE TRIGGER ON FrmPayDetail FOR DELETE AS _spTriggerExec("FrmPayDetail","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "FrmPayDetail"
ALTER TABLE FrmPayDetail ;
	ADD PRIMARY KEY FrmID TAG FrmID
***
_CreateRelation("FrmPayDetail", "FrmID", "Form", "FrmID")
_RIRuleWrite("FrmPayDetail", "FrmID", "Form", "FrmID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmPayDetail" ("Документ_Банк")
_WriteMetaInf(lcTargetDBPath,"FrmPayDetail","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPayDetail","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPayDetail","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Card" ("Карта")
CREATE TABLE (lcTargetDBPath+"Card") ( ;
	CardID I NOT NULL DEFAULT spIncrementID("Card"), ;
	CardTypeID I NOT NULL, ;
	CardNo C(20) NOT NULL, ;
	CardCode C(20) NOT NULL, ;
	CardDeliveryDate T NOT NULL, ;
	CardExpiredDate T NOT NULL, ;
	CardOwnerID I NOT NULL, ;
	CardSupplID I NOT NULL, ;
	CardFrmID I NOT NULL, ;
	CardRole I NOT NULL, ;
	CardIsActive L NOT NULL, ;
	CardNote C(100) NOT NULL ;
)
***
DBSETPROP("Card","TABLE","COMMENT","Карта")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Карта"
CREATE TRIGGER ON Card FOR INSERT AS _spTriggerExec("Card","INSERT")
CREATE TRIGGER ON Card FOR UPDATE AS _spTriggerExec("Card","UPDATE")
CREATE TRIGGER ON Card FOR DELETE AS _spTriggerExec("Card","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Card"
ALTER TABLE Card ;
	ADD PRIMARY KEY CardID TAG CardID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Card"
ALTER TABLE Card ;
	ADD FOREIGN KEY CardFrmID TAG CardFrmID ;
	REFERENCES Form TAG FrmID
***
_RIRuleWrite("Card", "CardFrmID", "Form", "FrmID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Card"
ALTER TABLE Card ;
	ADD FOREIGN KEY CardOwnerID TAG CardOwnID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("Card", "CardOwnID", "Client", "CltID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Card"
ALTER TABLE Card ;
	ADD FOREIGN KEY CardSupplID TAG CarSupID ;
	REFERENCES Client TAG CltID
***
_RIRuleWrite("Card", "CarSupID", "Client", "CltID", "RRI")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Card"
ALTER TABLE Card ;
	ADD FOREIGN KEY CardTypeID TAG CardTypeID ;
	REFERENCES CardType TAG CardTypeID
***
_RIRuleWrite("Card", "CardTypeID", "CardType", "CardTypeID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Card" ("Карта")
_WriteMetaInf(lcTargetDBPath,"Card","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Card","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Card","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"Card","META-INF","INCR_FLD","CardID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "StockTrans" ("LOG товарных операций")
CREATE TABLE (lcTargetDBPath+"StockTrans") ( ;
	StockTransUID I NOT NULL DEFAULT spIncrementID("StockTrans"), ;
	StockTransTypeID I NOT NULL, ;
	StockTransID I NOT NULL, ;
	StockTransOUID I NOT NULL, ;
	StockTransDate T NOT NULL, ;
	StockTransTvrId I NOT NULL, ;
	StockTransTvrQnt N(10,3) NOT NULL, ;
	StockTransMsuId I NOT NULL, ;
	StockTransTvrPrcBuy Y NOT NULL, ;
	StockTransTvrPrcSale Y NOT NULL, ;
	StockTransTvrExpiredDate T NULL ;
)
***
DBSETPROP("StockTrans","TABLE","COMMENT","LOG товарных операций")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "LOG товарных операций"
CREATE TRIGGER ON StockTrans FOR INSERT AS _spTriggerExec("StockTrans","INSERT","spStockTransInsertMaster()")
CREATE TRIGGER ON StockTrans FOR UPDATE AS _spTriggerExec("StockTrans","UPDATE")
CREATE TRIGGER ON StockTrans FOR DELETE AS _spTriggerExec("StockTrans","DELETE","spStockTransDeleteMaster()")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "StockTrans"
ALTER TABLE StockTrans ;
	ADD PRIMARY KEY StockTransUID TAG STUID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "StockTrans"
ALTER TABLE StockTrans ;
	ADD FOREIGN KEY StockTransID TAG STransID ;
	REFERENCES FrmPartTvr TAG PartTvrID
***
_RIRuleWrite("StockTrans", "STransID", "FrmPartTvr", "PartTvrID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "StockTrans"
ALTER TABLE StockTrans ;
	ADD FOREIGN KEY StockTransMsuId TAG MsuID ;
	REFERENCES MeasureUnit TAG MsuId
***
_RIRuleWrite("StockTrans", "MsuID", "MeasureUnit", "MsuId", "III")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "StockTrans"
ALTER TABLE StockTrans ;
	ADD FOREIGN KEY StockTransOUID TAG OUID ;
	REFERENCES OrgUnit TAG OUID
***
_RIRuleWrite("StockTrans", "OUID", "OrgUnit", "OUID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "StockTrans"
ALTER TABLE StockTrans ;
	ADD FOREIGN KEY StockTransTvrId TAG TvrID ;
	REFERENCES Tovar TAG TvrId
***
_RIRuleWrite("StockTrans", "TvrID", "Tovar", "TvrId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "StockTrans"
ALTER TABLE StockTrans ;
	ADD FOREIGN KEY StockTransTypeID TAG STransTID ;
	REFERENCES StockTransType TAG StockTTID
***
_RIRuleWrite("StockTrans", "STransTID", "StockTransType", "StockTTID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "StockTrans" ("LOG товарных операций")
_WriteMetaInf(lcTargetDBPath,"StockTrans","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"StockTrans","META-INF","TRIGGEREXECUTE","No")
_WriteMetaInf(lcTargetDBPath,"StockTrans","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"StockTrans","META-INF","INCR_FLD","StockTransUID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmPartFrmSum" ("Суммы содержания суммовых документов")
CREATE TABLE (lcTargetDBPath+"FrmPartFrmSum") ( ;
	FrmPartFrmSumID I NOT NULL DEFAULT spIncrementID("FrmPartFrmSum"), ;
	FrmPartFrmID I NOT NULL, ;
	FrmPartFrmSum Y NOT NULL, ;
	FrmPartFrmSumVATRate N(6,2) NOT NULL, ;
	User_ I NOT NULL, ;
	Stamp_ T NOT NULL ;
)
***
DBSETPROP("FrmPartFrmSum","TABLE","COMMENT","Суммы содержания суммовых документов")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Суммы содержания суммовых документов"
CREATE TRIGGER ON FrmPartFrmSum FOR INSERT AS _spTriggerExec("FrmPartFrmSum","INSERT")
CREATE TRIGGER ON FrmPartFrmSum FOR UPDATE AS _spTriggerExec("FrmPartFrmSum","UPDATE")
CREATE TRIGGER ON FrmPartFrmSum FOR DELETE AS _spTriggerExec("FrmPartFrmSum","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "FrmPartFrmSum"
ALTER TABLE FrmPartFrmSum ;
	ADD PRIMARY KEY FrmPartFrmSumID TAG PartFrmSID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmPartFrmSum"
ALTER TABLE FrmPartFrmSum ;
	ADD FOREIGN KEY FrmPartFrmID TAG PartFrmID ;
	REFERENCES FrmPartFrm TAG PartFrmID
***
_RIRuleWrite("FrmPartFrmSum", "PartFrmID", "FrmPartFrm", "PartFrmID", "RCR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmPartFrmSum" ("Суммы содержания суммовых документов")
_WriteMetaInf(lcTargetDBPath,"FrmPartFrmSum","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPartFrmSum","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPartFrmSum","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPartFrmSum","META-INF","INCR_FLD","FrmPartFrmSumID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "FrmPartTvrCncRsn" ("Привязка ног к причинам отказа")
CREATE TABLE (lcTargetDBPath+"FrmPartTvrCncRsn") ( ;
	FrmPartTvrCncRsnID I NOT NULL, ;
	CancelReasonID I NOT NULL ;
)
***
DBSETPROP("FrmPartTvrCncRsn","TABLE","COMMENT","Привязка ног к причинам отказа")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Привязка ног к причинам отказа"
CREATE TRIGGER ON FrmPartTvrCncRsn FOR INSERT AS _spTriggerExec("FrmPartTvrCncRsn","INSERT")
CREATE TRIGGER ON FrmPartTvrCncRsn FOR UPDATE AS _spTriggerExec("FrmPartTvrCncRsn","UPDATE")
CREATE TRIGGER ON FrmPartTvrCncRsn FOR DELETE AS _spTriggerExec("FrmPartTvrCncRsn","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmPartTvrCncRsn"
ALTER TABLE FrmPartTvrCncRsn ;
	ADD FOREIGN KEY CancelReasonID TAG CncRsnID ;
	REFERENCES CancelReason TAG CncRsnID
***
_RIRuleWrite("FrmPartTvrCncRsn", "CncRsnID", "CancelReason", "CncRsnID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "FrmPartTvrCncRsn"
ALTER TABLE FrmPartTvrCncRsn ;
	ADD FOREIGN KEY FrmPartTvrCncRsnID TAG PartTvrID ;
	REFERENCES FrmPartTvr TAG PartTvrID
***
_RIRuleWrite("FrmPartTvrCncRsn", "PartTvrID", "FrmPartTvr", "PartTvrID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "FrmPartTvrCncRsn" ("Привязка ног к причинам отказа")
_WriteMetaInf(lcTargetDBPath,"FrmPartTvrCncRsn","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPartTvrCncRsn","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"FrmPartTvrCncRsn","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
*Action Is Creating Table "Stock" ("Оперативные остатки")
CREATE TABLE (lcTargetDBPath+"Stock") ( ;
	StockUID I NOT NULL DEFAULT spIncrementID("Stock"), ;
	StockID I NOT NULL, ;
	StockOUID I NOT NULL, ;
	StockDateIn T NOT NULL, ;
	StockTvrId I NOT NULL, ;
	StockTvrQnt N(10,3) NOT NULL, ;
	StockMsuId I NOT NULL, ;
	StockTvrPrcBuy Y NOT NULL, ;
	StockTvrPrcSale Y NOT NULL, ;
	StockTvrExpiredDate T NULL, ;
	StockValidFrom T NOT NULL, ;
	StockValidThru T NULL ;
)
***
DBSETPROP("Stock","TABLE","COMMENT","Оперативные остатки")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Оперативные остатки"
CREATE TRIGGER ON Stock FOR INSERT AS _spTriggerExec("Stock","INSERT")
CREATE TRIGGER ON Stock FOR UPDATE AS _spTriggerExec("Stock","UPDATE")
CREATE TRIGGER ON Stock FOR DELETE AS _spTriggerExec("Stock","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Primary Key For Table "Stock"
ALTER TABLE Stock ;
	ADD PRIMARY KEY StockUID TAG StockUID
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Stock"
ALTER TABLE Stock ;
	ADD FOREIGN KEY StockID TAG StockID ;
	REFERENCES FrmPartTvr TAG PartTvrID
***
_RIRuleWrite("Stock", "StockID", "FrmPartTvr", "PartTvrID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Stock"
ALTER TABLE Stock ;
	ADD FOREIGN KEY StockMsuId TAG MsuID ;
	REFERENCES MeasureUnit TAG MsuId
***
_RIRuleWrite("Stock", "MsuID", "MeasureUnit", "MsuId", "III")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Stock"
ALTER TABLE Stock ;
	ADD FOREIGN KEY StockOUID TAG OUID ;
	REFERENCES OrgUnit TAG OUID
***
_RIRuleWrite("Stock", "OUID", "OrgUnit", "OUID", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "Stock"
ALTER TABLE Stock ;
	ADD FOREIGN KEY StockTvrId TAG TvrID ;
	REFERENCES Tovar TAG TvrId
***
_RIRuleWrite("Stock", "TvrID", "Tovar", "TvrId", "RRR")
*-------------------------------------------------------------------------------
*Action Is Creating Inversion Entry (Regular Index) For Table "Stock"
IF !USED("Stock")
	USE Stock IN 0 EXCLUSIVE
ENDIF
SELECT Stock
INDEX ON StockDateIn TAG DateIn
USE IN Stock
*-------------------------------------------------------------------------------
*Action Is Creating Inversion Entry (Regular Index) For Table "Stock"
IF !USED("Stock")
	USE Stock IN 0 EXCLUSIVE
ENDIF
SELECT Stock
INDEX ON StockTvrPrcBuy TAG TvrPrcBuy
USE IN Stock
*-------------------------------------------------------------------------------
*Action Is Creating Inversion Entry (Regular Index) For Table "Stock"
IF !USED("Stock")
	USE Stock IN 0 EXCLUSIVE
ENDIF
SELECT Stock
INDEX ON StockTvrPrcSale TAG TvrPrcSale
USE IN Stock
*-------------------------------------------------------------------------------
*Action Is Creating Inversion Entry (Regular Index) For Table "Stock"
IF !USED("Stock")
	USE Stock IN 0 EXCLUSIVE
ENDIF
SELECT Stock
INDEX ON StockTvrQnt TAG TvrQnt
USE IN Stock
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "Stock" ("Оперативные остатки")
_WriteMetaInf(lcTargetDBPath,"Stock","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"Stock","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"Stock","META-INF","AUTOINCREMENT","Yes")
_WriteMetaInf(lcTargetDBPath,"Stock","META-INF","INCR_FLD","StockUID")
*-------------------------------------------------------------------------------
*Action Is Creating Table "StockTransDetail" ("Детали LOG-а тов. транз.")
CREATE TABLE (lcTargetDBPath+"StockTransDetail") ( ;
	StockTransID I NOT NULL, ;
	StockUID I NOT NULL, ;
	StockID I NOT NULL, ;
	StockOUID I NOT NULL, ;
	StockDateIn T NOT NULL, ;
	StockTvrId I NOT NULL, ;
	StockTvrQnt N(10,3) NOT NULL, ;
	StockMsuId I NOT NULL, ;
	StockTvrPrcBuy Y NOT NULL, ;
	StockTvrPrcSale Y NOT NULL, ;
	ResultStockUID I NOT NULL ;
)
***
DBSETPROP("StockTransDetail","TABLE","COMMENT","Детали LOG-а тов. транз.")
*-------------------------------------------------------------------------------
*Action Is Creating Triggers For Table "Детали LOG-а тов. транз."
CREATE TRIGGER ON StockTransDetail FOR INSERT AS _spTriggerExec("StockTransDetail","INSERT")
CREATE TRIGGER ON StockTransDetail FOR UPDATE AS _spTriggerExec("StockTransDetail","UPDATE")
CREATE TRIGGER ON StockTransDetail FOR DELETE AS _spTriggerExec("StockTransDetail","DELETE")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "StockTransDetail"
ALTER TABLE StockTransDetail ;
	ADD FOREIGN KEY StockID TAG StockID ;
	REFERENCES FrmPartTvr TAG PartTvrID
***
_RIRuleWrite("StockTransDetail", "StockID", "FrmPartTvr", "PartTvrID", "III")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "StockTransDetail"
ALTER TABLE StockTransDetail ;
	ADD FOREIGN KEY StockMsuId TAG StockMsuId ;
	REFERENCES MeasureUnit TAG MsuId
***
_RIRuleWrite("StockTransDetail", "StockMsuId", "MeasureUnit", "MsuId", "III")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "StockTransDetail"
ALTER TABLE StockTransDetail ;
	ADD FOREIGN KEY StockOUID TAG StockOUID ;
	REFERENCES OrgUnit TAG OUID
***
_RIRuleWrite("StockTransDetail", "StockOUID", "OrgUnit", "OUID", "III")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "StockTransDetail"
ALTER TABLE StockTransDetail ;
	ADD FOREIGN KEY StockTransID TAG STransID ;
	REFERENCES FrmPartTvr TAG PartTvrID
***
_RIRuleWrite("StockTransDetail", "STransID", "FrmPartTvr", "PartTvrID", "III")
*-------------------------------------------------------------------------------
*Action Is Creating Foreign Key For Table "StockTransDetail"
ALTER TABLE StockTransDetail ;
	ADD FOREIGN KEY StockTvrId TAG StockTvrId ;
	REFERENCES Tovar TAG TvrId
***
_RIRuleWrite("StockTransDetail", "StockTvrId", "Tovar", "TvrId", "III")
*-------------------------------------------------------------------------------
*Action Is Writing Meta Data For Table "StockTransDetail" ("Детали LOG-а тов. транз.")
_WriteMetaInf(lcTargetDBPath,"StockTransDetail","META-INF","RELOAD","Yes")
_WriteMetaInf(lcTargetDBPath,"StockTransDetail","META-INF","TRIGGEREXECUTE","Yes")
_WriteMetaInf(lcTargetDBPath,"StockTransDetail","META-INF","AUTOINCREMENT","Yes")
*-------------------------------------------------------------------------------
