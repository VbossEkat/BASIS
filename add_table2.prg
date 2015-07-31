*Action Is Creating Table "FrmPartTvrCncRsn" ("Привязка ног к причинам отказа")
CREATE TABLE ("D:\Develop\Work\Basis_RST\DBGen\TargetDatabase\FrmPartTvrCncRsn") ( ;
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




********************************************************************************************
********************************************************************************************




*Action Is Creating Table "CancelReason" ("??????? ??????")
CREATE TABLE ("D:\Develop\Work\Basis_RST\DBGen\TargetDatabase\CancelReason") ( ;
	CancelReasonID I NOT NULL DEFAULT spIncrementID("CancelReason"), ;
	CancelReasonNM C(40) NOT NULL ;
)
***
DBSETPROP("CancelReason","TABLE","COMMENT","??????? ??????")
*-------------------------------------------------------------------------------


*Action Is Creating Triggers For Table "??????? ??????"
CREATE TRIGGER ON CancelReason FOR INSERT AS _spTriggerExec("CancelReason","INSERT")
CREATE TRIGGER ON CancelReason FOR UPDATE AS _spTriggerExec("CancelReason","UPDATE")
CREATE TRIGGER ON CancelReason FOR DELETE AS _spTriggerExec("CancelReason","DELETE")
*-------------------------------------------------------------------------------


*Action Is Creating Primary Key For Table "CancelReason"
ALTER TABLE CancelReason ;
	ADD PRIMARY KEY CancelReasonID TAG CncRsnID
*-------------------------------------------------------------------------------


