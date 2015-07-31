#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 17:31 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Администрирование] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Администрирование]
***
lvModuleView()
lvModuleRepl()
lvModuleEdit()
lvModuleBmps()
lvModuleTypeView()
***
lvVersionView()
lvVersionViewRepl()
lvModuleVersionEdit()
lvModuleListByWSTypeID()
lvModuleFileByID()
lvModuleExclList()
lvModuleIncList()
lvVersionFileView()
lvVersionFileViewRepl()
lvVersionFileEdit()
***
lvWSTypeView()
lvWSTypeViewRepl()
lvWSTypeEdit()
lvWSTypeModuleView()
lvWSTypeModuleViewRepl()
lvWSTypeModuleEdit()
***
lvUserMsgLast()
lvUserMsgView()
lvUserMsgEdit()
lvUserMsgRepl()
lvSessionView()
lvSessionEdit()
lvUserMsgActionView()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV Admin: список модулей/*
PROCEDURE lvModuleView
***
CREATE SQL VIEW lvModuleView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Module.ModuleID, ;
	Module.ModuleNM, ;
	ModuleType.ModuleTypeIsPacked, ;
	ModuleType.BmpID ;
FROM Module ;
INNER JOIN ModuleType ON ModuleType.ModuleTypeID = Module.ModuleTypeID
***
DBSETPROP([lvModuleView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvModuleView],[VIEW],[COMMENT],[LV Admin: список модулей])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: обновление списока модулей/*
PROCEDURE lvModuleRepl
***
CREATE SQL VIEW lvModuleRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Module.ModuleID, ;
	Module.ModuleNM, ;
	ModuleType.ModuleTypeIsPacked, ;
	ModuleType.BmpID ;
FROM Module ;
INNER JOIN ModuleType ON ModuleType.ModuleTypeID = Module.ModuleTypeID ;
WHERE Module.ModuleID = ?_PARAM
***
DBSETPROP([lvModuleRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvModuleRepl],[VIEW],[COMMENT],[LV Admin: списока модулей])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: редактирование списока модулей/*
PROCEDURE lvModuleEdit
***
CREATE SQL VIEW lvModuleEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Module.ModuleID, ;
	Module.ModuleTypeID, ;
	Module.ModuleNM ;
FROM Module ;
WHERE Module.ModuleID = ?_PARAM
***
DBSETPROP([lvModuleEdit.ModuleID],[FIELD],[KeyField],.T.)
DBSETPROP([lvModuleEdit.ModuleID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvModuleEdit.ModuleTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvModuleEdit.ModuleNM],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvModuleEdit.ModuleNM],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvModuleEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvModuleEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvModuleEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvModuleEdit],[VIEW],[COMMENT],[LV Admin: редактирование списока модулей])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: список используемых картинок для типов модулей/*
PROCEDURE lvModuleBmps
***
CREATE SQL VIEW lvModuleBmps REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Bitmaps.BmpId, ;
	Bitmaps.BmpFileNM ;
FROM Bitmaps ;
WHERE Bitmaps.BmpId IN (SELECT ModuleType.BmpId FROM ModuleType)
***
DBSETPROP([lvModuleBmps],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvModuleBmps],[VIEW],[COMMENT],[LV Admin: список используемых картинок для типов модулей])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: список типов модулей/*
PROCEDURE lvModuleTypeView
***
CREATE SQL VIEW lvModuleTypeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ModuleType.ModuleTypeId AS ID, ;
	ModuleType.ModuleTypeNM AS NM  ;
FROM ModuleType
***
DBSETPROP([lvModuleTypeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvModuleTypeView],[VIEW],[COMMENT],[LV Admin: список типов модулей])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: список версий модуля/*
PROCEDURE lvVersionView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvVersionView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ModuleVersion.ModuleVersionID, ;
	ModuleVersion.ModuleID, ;
	ModuleVersion.ModuleVersion, ;
	ModuleVersion.IsUsed ;
FROM ModuleVersion ;
WHERE ModuleVersion.ModuleID = ?_PARAM
***
DBSETPROP([lvVersionView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvVersionView],[VIEW],[COMMENT],[LV Admin: список версий модуля])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: обновление список версий модуля/*
PROCEDURE lvVersionViewRepl
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvVersionViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ModuleVersion.ModuleVersionID, ;
	ModuleVersion.ModuleID, ;
	ModuleVersion.ModuleVersion, ;
	ModuleVersion.IsUsed ;
FROM ModuleVersion ;
WHERE ModuleVersion.ModuleVersionID = ?_PARAM
***
DBSETPROP([lvVersionViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvVersionViewRepl],[VIEW],[COMMENT],[LV Admin: обновление список версий модуля])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: редактирование версий модуля/*
PROCEDURE lvModuleVersionEdit
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvModuleVersionEdit REMOTE CONNECTION SQLBasisConnection SHARE AS ;
SELECT ;
	ModuleVersion.ModuleVersionID, ;
	ModuleVersion.ModuleVersion, ;
	ModuleVersion.IsUsed, ;
	ModuleVersion.ModuleID ;
FROM ModuleVersion ;
WHERE ModuleVersion.ModuleVersionID = ?_PARAM
***
DBSETPROP([lvModuleVersionEdit.ModuleVersionID],[FIELD],[KeyField],.T.)
DBSETPROP([lvModuleVersionEdit.ModuleVersionID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvModuleVersionEdit.ModuleVersion],[FIELD],[Updatable],.T.)
DBSETPROP([lvModuleVersionEdit.IsUsed],[FIELD],[Updatable],.T.)
DBSETPROP([lvModuleVersionEdit.ModuleID],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvModuleVersionEdit.ModuleVersion],[FIELD],[DefaultValue],[""])
DBSETPROP([lvModuleVersionEdit.IsUsed],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvModuleVersionEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvModuleVersionEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvModuleVersionEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvVersionView],[VIEW],[COMMENT],[LV Admin: редактирование версий модуля])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: список используемых модулей для данного типа рабочей станции/*
PROCEDURE lvModuleListByWSTypeID
***
*!*	CREATE SQL VIEW lvModuleListByWSTypeID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
*!*	SELECT ;
*!*		Module.ModuleID, ;
*!*		Module.ModuleNM, ;
*!*		Module.ModuleFileNM, ;
*!*		ModuleVersion.ModuleVersionID, ;
*!*		ModuleVersion.ModuleFileSize, ;
*!*		ModuleVersion.ModuleFileCRC ;
*!*	FROM Module ;
*!*	INNER JOIN ModuleVersion ON ModuleVersion.ModuleID = Module.ModuleID AND ModuleVersion.IsUsed = 1 ;
*!*	WHERE Module.ModuleID IN (SELECT ModuleID FROM WorkStationModule WHERE WSTypeID = ?_PARAM) 
*!*	***
*!*	DBSETPROP([lvModuleListByWSTypeID],[VIEW],[FetchSize],-1)
*!*	***
*!*	DBSETPROP([lvModuleListByWSTypeID],[VIEW],[COMMENT],[LV Admin: список используемых модулей для данного типа рабочей станции])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: список модулей для данного типа рабочей станции/*
PROCEDURE lvModuleExclList
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvModuleExclList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Module.ModuleID AS ID, ;
	Module.ModuleNM AS NM  ;
FROM Module ;
WHERE Module.ModuleID NOT IN (SELECT ModuleID FROM WorkStationModule WHERE WSTypeID = ?_PARAM) 
***
DBSETPROP([lvModuleExclList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvModuleExclList],[VIEW],[COMMENT],[LV Admin: список модулей для данного типа рабочей станции])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: список добавленных модулей для данного типа рабочей станции/*
PROCEDURE lvModuleIncList
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvModuleIncList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Module.ModuleID AS ID, ;
	Module.ModuleNM AS NM  ;
FROM Module ;
WHERE Module.ModuleID IN (SELECT ModuleID FROM WorkStationModule WHERE WSTypeID = ?_PARAM) 
***
DBSETPROP([lvModuleIncList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvModuleIncList],[VIEW],[COMMENT],[LV Admin: список добавленных модулей для данного типа рабочей станции])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: версия файла модуля по ее идентификатору/*
PROCEDURE lvModuleFileByID
***
*!*	#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
*!*	***
*!*	CREATE SQL VIEW lvModuleFileByID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
*!*	SELECT ;
*!*		ModuleVersion.ModuleVersionID, ;
*!*		ModuleVersion.ModuleVersion, ;
*!*		ModuleVersion.ModuleFile ;
*!*	FROM ModuleVersion ;
*!*	WHERE ;
*!*		ModuleVersion.ModuleVersionID = ?_PARAM
*!*	***
*!*	DBSETPROP([lvModuleFileByID.ModuleFile],[FIELD],[DataType],[M])
*!*	***
*!*	DBSETPROP([lvModuleFileByID],[VIEW],[FetchSize],-1)
*!*	***
*!*	DBSETPROP([lvModuleFileByID],[VIEW],[COMMENT],[LV Admin: версия файла модуля по ее идентификатору])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: файлы версии модуля/*
PROCEDURE lvVersionFileView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvVersionFileView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	MVFileID, ;
	ModuleVersionID, ;
	ModuleFileNM, ;
	ModuleFilePath, ;
	ModuleFileSize, ;
	ModuleFileCRC ;
FROM ModuleVersionFile ;
WHERE ModuleVersionID = ?_PARAM
***
DBSETPROP([lvVersionFileView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvVersionFileView],[VIEW],[COMMENT],[LV Admin: файлы версии модуля])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: обновление файлов версии модуля/*
PROCEDURE lvVersionFileViewRepl
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvVersionFileViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	MVFileID, ;
	ModuleVersionID, ;
	ModuleFileNM, ;
	ModuleFilePath, ;
	ModuleFileSize, ;
	ModuleFileCRC ;
FROM ModuleVersionFile ;
WHERE MVFileID = ?_PARAM
***
DBSETPROP([lvVersionFileViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvVersionFileViewRepl],[VIEW],[COMMENT],[LV Admin: обновление файлов версии модуля])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: редактирование файла версии модуля/*
PROCEDURE lvVersionFileEdit
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvVersionFileEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	MVFileID, ;
	ModuleVersionID, ;
	ModuleFileNM, ;
	ModuleFile, ;
	ModuleFilePath, ;
	ModuleFileSize, ;
	ModuleFileCRC ;
FROM ModuleVersionFile ;
WHERE MVFileID = ?_PARAM
***
DBSETPROP([lvVersionFileEdit.MVFileID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvVersionFileEdit.MVFileID],[FIELD],[Updatable],.F.)
DBSETPROP([lvVersionFileEdit.ModuleVersionID],[FIELD],[Updatable],.T.)
DBSETPROP([lvVersionFileEdit.ModuleFileNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvVersionFileEdit.ModuleFile],[FIELD],[Updatable],.T.)
DBSETPROP([lvVersionFileEdit.ModuleFilePath],[FIELD],[Updatable],.T.)
DBSETPROP([lvVersionFileEdit.ModuleFileSize],[FIELD],[Updatable],.T.)
DBSETPROP([lvVersionFileEdit.ModuleFileCRC],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvVersionFileEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvVersionFileEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvVersionFileEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvVersionFileEdit.ModuleFile],[FIELD],[DataType],[M])
***
DBSETPROP([lvVersionFileEdit],[VIEW],[COMMENT],[LV Admin: редактирование файла версии модуля])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: типы рабочих мест/*
PROCEDURE lvWSTypeView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvWSTypeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	WorkStationType.WSTypeID, ;
	WorkStationType.WSTypeNM ;
FROM WorkStationType
***
DBSETPROP([lvWSTypeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvWSTypeView],[VIEW],[COMMENT],[LV Admin: типы рабочих мест])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: обновление типов рабочих мест/*
PROCEDURE lvWSTypeViewRepl
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvWSTypeViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	WorkStationType.WSTypeID, ;
	WorkStationType.WSTypeNM ;
FROM WorkStationType ;
WHERE WorkStationType.WSTypeID = ?_PARAM
***
DBSETPROP([lvWSTypeViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvWSTypeViewRepl],[VIEW],[COMMENT],[LV Admin: обновление типов рабочих мест])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: редактирование рабочих мест/*
PROCEDURE lvWSTypeEdit
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvWSTypeEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	WorkStationType.WSTypeID, ;
	WorkStationType.WSTypeNM ;
FROM WorkStationType ;
WHERE WorkStationType.WSTypeID = ?_PARAM
***
DBSETPROP([lvWSTypeView.WSTypeID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvWSTypeView.WSTypeID],[FIELD],[Updatable],.F.)
DBSETPROP([lvWSTypeView.WSTypeNM],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvWSTypeEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvWSTypeEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvWSTypeEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvWSTypeEdit],[VIEW],[COMMENT],[LV Admin: редактирование рабочих мест])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: привязка модулей к типам рабочих мест/*
PROCEDURE lvWSTypeModuleView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvWSTypeModuleView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Module.ModuleID, ;
	Module.ModuleNM ;
FROM WorkStationModule ;
INNER JOIN Module ON Module.ModuleID = WorkStationModule.ModuleID ;
WHERE WorkStationModule.WSTypeID = ?_PARAM
***
DBSETPROP([lvWSTypeModuleView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvWSTypeModuleView],[VIEW],[COMMENT],[LV Admin: привязка модулей к типам рабочих мест])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: обновление привязки модулей к типам рабочих мест/*
PROCEDURE lvWSTypeModuleViewRepl
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvWSTypeModuleViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Module.ModuleID, ;
	Module.ModuleNM ;
FROM WorkStationModule ;
INNER JOIN Module ON Module.ModuleID = WorkStationModule.ModuleID ;
WHERE WorkStationModule.WSTypeID = ?_PARAM1 AND WorkStationModule.ModuleID = ?_PARAM2
***
DBSETPROP([lvWSTypeModuleViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvWSTypeModuleViewRepl],[VIEW],[COMMENT],[LV Admin: обновление привязки модулей к типам рабочих мест])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: редактирование привязки модулей к типам рабочих мест/*
PROCEDURE lvWSTypeModuleEdit
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvWSTypeModuleEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	WorkStationModule.WSTypeID, ;
	WorkStationModule.ModuleID  ;
FROM WorkStationModule ;
WHERE WorkStationModule.WSTypeID = ?_PARAM1 AND WorkStationModule.ModuleID = ?_PARAM2
***
DBSETPROP([lvWSTypeModuleEdit.WSTypeID],[FIELD],[KeyField],.T.)
DBSETPROP([lvWSTypeModuleEdit.ModuleID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvWSTypeModuleEdit.WSTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvWSTypeModuleEdit.ModuleID],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvWSTypeModuleEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvWSTypeModuleEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvWSTypeModuleEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvWSTypeModuleEdit],[VIEW],[COMMENT],[LV Admin: редактирование привязки модулей к типам рабочих мест])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: последние(новые) необработанное сообщения пользователя/*
PROCEDURE lvUserMsgLast
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvUserMsgLast REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT TOP 1;
	UserMsg.UserMsgID, ;
	UserMsg.SessionID, ;
	UserMsg.UserMsgCont, ;
	UserMsg.UserMsgActionID, ;
	ISNULL(AppUser.UserLogin,'н/а') AS UserLogin, ;
	UserMsg.UserMsgCreateDate ;
FROM UserMsg ;
LEFT JOIN Session ON Session.SessionID = UserMsg.SessionID ;
LEFT JOIN AppUser ON AppUser.UserID = Session.UserID ;
WHERE Session.SessionID = ?_PARAM AND UserMsg.UserMsgReceptionDate IS NULL ;
ORDER BY UserMsg.UserMsgID	
***
DBSETPROP([lvUserMsgLast],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserMsgLast],[VIEW],[COMMENT],[LV Admin: последние(новые) необработанное сообщения пользователя])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: редактирование сообщения пользователя/*
PROCEDURE lvUserMsgEdit
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvUserMsgEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	UserMsg.UserMsgID, ;
	UserMsg.SessionID, ;
	UserMsg.UserMsgCont, ;
	UserMsg.UserMsgActionID, ;
	UserMsg.UserMsgCreateDate, ;
	UserMsg.UserMsgReceptionDate, ;
	UserMsg.AuthorSessionID ;
FROM UserMsg ;
WHERE UserMsg.UserMsgID = ?_PARAM
***
DBSETPROP([lvUserMsgEdit.UserMsgID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvUserMsgEdit.UserMsgID],[FIELD],[Updatable],.F.)
DBSETPROP([lvUserMsgEdit.UserMsgID],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserMsgEdit.UserMsgCont],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserMsgEdit.UserMsgActionID],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserMsgEdit.UserMsgCreateDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserMsgEdit.UserMsgReceptionDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserMsgEdit.AuthorSessionID ],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvUserMsgEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvUserMsgEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvUserMsgEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserMsgEdit],[VIEW],[COMMENT],[LV Admin: редактирование сообщения пользователя])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: обновление сообщения пользователя/*
PROCEDURE lvUserMsgRepl
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvUserMsgRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	UserMsg.UserMsgID, ;
	UserMsg.SessionID, ;
	UserMsg.UserMsgCont, ;
	UserMsg.UserMsgActionID, ;
	ISNULL(AppUser.UserLogin,'н/а') AS UserLogin, ;
	UserMsg.UserMsgCreateDate ;
FROM UserMsg ;
LEFT JOIN Session ON Session.SessionID = UserMsg.SessionID ;
LEFT JOIN AppUser ON AppUser.UserID = Session.UserID ;
WHERE UserMsg.UserMsgID = ?_PARAM
***
DBSETPROP([lvUserMsgRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserMsgRepl],[VIEW],[COMMENT],[LV Admin: обновление сообщения пользователя])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: просмотр сообщений пользователя/*
PROCEDURE lvUserMsgView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvUserMsgView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	UserMsg.UserMsgID, ;
	UserMsg.SessionID, ;
	UserMsg.UserMsgCont, ;
	UserMsg.UserMsgActionID, ;
	ISNULL(AppUser.UserLogin,'н/а') AS UserLogin, ;
	UserMsg.UserMsgCreateDate, ;
	0 AS MsgType ;
FROM UserMsg ;
LEFT JOIN Session ON Session.SessionID = UserMsg.SessionID ;
LEFT JOIN AppUser ON AppUser.UserID = Session.UserID ;
WHERE UserMsg.AuthorSessionID = ?_PARAM ;
UNION ALL ;
SELECT ;
	UserMsg.UserMsgID, ;
	UserMsg.SessionID, ;
	UserMsg.UserMsgCont, ;
	UserMsg.UserMsgActionID, ;
	ISNULL(AppUser.UserLogin,'н/а') AS UserLogin, ;
	UserMsg.UserMsgCreateDate, ;
	1 AS MsgType ;
FROM UserMsg ;
LEFT JOIN Session ON Session.SessionID = UserMsg.SessionID ;
LEFT JOIN AppUser ON AppUser.UserID = Session.UserID ;
WHERE UserMsg.SessionID = ?_PARAM ;
ORDER BY UserMsg.UserMsgID
***
DBSETPROP([lvUserMsgView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserMsgView],[VIEW],[COMMENT],[LV Admin: просмотр сообщений пользователя])
***
ENDPROC
*------------------------------------------------------------------------------


*/LV Admin: просмотр сеансов работы/*
PROCEDURE lvSessionView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvSessionView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Session.SessionID, ;
	Session.WSNM, ;
	Session.UserNM, ;
	Session.UserId, ;
	AppUser.UserLogin, ;
	Session.SessionBegin, ;
	Session.SessionDuration, ;
	CASE WHEN DATEDIFF(minute,Session.SessionDuration,GETDATE()) > 2 THEN 0 ELSE 1 END AS SessionLive ;
FROM Session ;
INNER JOIN AppUser ON AppUser.UserID = Session.UserId ;
WHERE Session.SessionStatus = 1 ;
ORDER BY Session.SessionBegin
***
DBSETPROP([lvSessionView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvSessionView],[VIEW],[COMMENT],[LV Admin: просмотр сеансов работы])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: редактирование сеансов работы/*
PROCEDURE lvSessionEdit
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvSessionEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Session.SessionID, ;
	Session.WSNM, ;
	Session.UserNM, ;
	Session.UserId, ;
	Session.SessionBegin, ;
	Session.SessionDuration, ;
	Session.SessionStatus ;
FROM Session ;
WHERE Session.SessionID = ?_PARAM
***
DBSETPROP([lvSessionEdit.SessionID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvSessionEdit.SessionID],[FIELD],[Updatable],.F.)
DBSETPROP([lvSessionEdit.WSNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvSessionEdit.UserNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvSessionEdit.UserId],[FIELD],[Updatable],.T.)
DBSETPROP([lvSessionEdit.SessionDuration],[FIELD],[Updatable],.T.)
DBSETPROP([lvSessionEdit.SessionStatus],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvSessionEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvSessionEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvSessionEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvSessionEdit],[VIEW],[COMMENT],[LV Admin: редактирование сеансов работы])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Admin: Список действий по сообщениям/*
PROCEDURE lvUserMsgActionView
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvUserMsgActionView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	UserMsgAction.UserMsgActionID AS ID, ;
	UserMsgAction.UserMsgActionNM AS NM  ;
FROM UserMsgAction 
***
DBSETPROP([lvUserMsgActionView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserMsgActionView],[VIEW],[COMMENT],[LV Admin: Список действий по сообщениям])
***
ENDPROC
*------------------------------------------------------------------------------

*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************