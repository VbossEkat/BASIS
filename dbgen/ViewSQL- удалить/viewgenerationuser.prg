#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 17:31 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Пользователи] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Пользователи]
***
lvUserInfoByLogin()
lvUserInfoByPwd()
lvUserInfoByID()
***
lvUserCntTreeView()
lvUserCntTreeViewRepl()
lvUserInCntView()
lvUserInCntViewRepl()
***
lvUserEdit()
lvUserPassword()
***
lvUserTypeList()
***
lvUserGrantView()
lvUserGrantEdit()
lvUserObjFuncList()
***
lvObjTypeList()
***
lvUserBmps()
***
lvCltByUser()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV User: информация о пользователе (по логину)/*
PROCEDURE lvUserInfoByLogin
***
CREATE SQL VIEW lvUserInfoByLogin REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	AppUser.UserId, ;
	AppUser.UserParId, ;
	AppUser.UserLogin, ;
	AppUser.UserPassword, ;
	AppUser.UserOptions, ;
	AppUser.UserCltID ;
FROM AppUser ;
INNER JOIN UserType ON UserType.UserTypeID = AppUser.UserTypeID AND UserType.UserTypeIsCnt = 0 ;
WHERE AppUser.UserIsActive = 1 AND UPPER(AppUser.UserLogin) = UPPER(?_PARAM)
***
DBSETPROP([lvUserInfoByLogin.UserOptions],[FIELD],[DataType],[M])
***
DBSETPROP([lvUserInfoByLogin],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserInfoByLogin],[VIEW],[COMMENT],[LV User: информация о пользователе (по логину)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: информация о пользователе (по паролю)/*
PROCEDURE lvUserInfoByPwd
***
CREATE SQL VIEW lvUserInfoByPwd REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	AppUser.UserId, ;
	AppUser.UserParId, ;
	AppUser.UserLogin, ;
	AppUser.UserPassword, ;
	AppUser.UserOptions, ;
	AppUser.UserCltID ;
FROM AppUser ;
INNER JOIN UserType ON UserType.UserTypeID = AppUser.UserTypeID AND UserType.UserTypeIsCnt = 0 ;
WHERE AppUser.UserIsActive = 1 AND AppUser.UserPassword = ?_PARAM
***
DBSETPROP([lvUserInfoByPwd.UserOptions],[FIELD],[DataType],[M])
***
DBSETPROP([lvUserInfoByPwd],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserInfoByPwd],[VIEW],[COMMENT],[LV User: информация о пользователе (по паролю)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: информация о пользователе (по ID)/*
PROCEDURE lvUserInfoByID
***
CREATE SQL VIEW lvUserInfoByID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	AppUser.UserId, ;
	AppUser.UserParId, ;
	AppUser.UserLogin, ;
	AppUser.UserPassword, ;
	AppUser.UserOptions, ;
	AppUser.UserCltID ;
FROM AppUser ;
INNER JOIN UserType ON UserType.UserTypeID = AppUser.UserTypeID AND UserType.UserTypeIsCnt = 0 ;
WHERE UserId = ?_PARAM
***
DBSETPROP([lvUserInfoByID.UserOptions],[FIELD],[DataType],[M])
***
DBSETPROP([lvUserInfoByID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserInfoByID],[VIEW],[COMMENT],[LV User: информация о пользователе (по ID)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: дерево пользователей/*
PROCEDURE lvUserCntTreeView
***
CREATE SQL VIEW lvUserCntTreeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	AppUser.UserId, ;
	ISNULL(AppUser.UserParId,0) AS UserParId, ;
	AppUser.UserLogin, ;
	UserType.UserTypeIsCnt AS UserIsCnt, ;
	UserType.BmpId, ;
	UserType.SelBmpId ;
FROM AppUser ;
INNER JOIN UserType ON AppUser.UserTypeID = UserType.UserTypeID ;
WHERE UserType.UserTypeIsCnt = 1
***
DBSETPROP([lvUserCntTreeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserCntTreeView],[VIEW],[COMMENT],[LV User: дерево пользователей])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: обновления для lvUserCntTreeViewRepl/*
PROCEDURE lvUserCntTreeViewRepl
***
CREATE SQL VIEW lvUserCntTreeViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	AppUser.UserId, ;
	ISNULL(AppUser.UserParId,0) AS UserParId, ;
	AppUser.UserLogin, ;
	UserType.UserTypeIsCnt AS UserIsCnt, ;
	AppUser.UserIsActive, ;
	UserType.BmpId, ;
	UserType.SelBmpId ;
FROM AppUser ;
INNER JOIN UserType ON AppUser.UserTypeID = UserType.UserTypeID ;
WHERE UserType.UserTypeIsCnt = 1 AND AppUser.UserId = ?_PARAM
***
DBSETPROP([lvUserCntTreeViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserCntTreeViewRepl],[VIEW],[COMMENT],[LV User: обновления для lvUserCntTreeViewRepl])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: содержание группы пользователей/*
PROCEDURE lvUserInCntView
***
CREATE SQL VIEW lvUserInCntView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	AppUser.UserId, ;
	ISNULL(AppUser.UserParId,0) AS UserParId, ;
	AppUser.UserLogin, ;
	UserType.UserTypeIsCnt AS UserIsCnt, ;
	AppUser.UserIsActive, ;
	AppUser.UserComment, ;
	UserType.BmpId ;
FROM AppUser ;
INNER JOIN UserType ON AppUser.UserTypeID = UserType.UserTypeID ;
WHERE ISNULL(AppUser.UserParId,0) = ?_PARAM ;
ORDER BY 3
***
DBSETPROP([lvUserInCntView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserInCntView],[VIEW],[COMMENT],[LV User: содержание группы пользователей])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: обновления для lvUserInCntView/*
PROCEDURE lvUserInCntViewRepl
***
CREATE SQL VIEW lvUserInCntViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	AppUser.UserId, ;
	ISNULL(AppUser.UserParId,0) AS UserParId, ;
	AppUser.UserLogin, ;
	UserType.UserTypeIsCnt AS UserIsCnt, ;
	AppUser.UserIsActive, ;
	AppUser.UserComment, ;
	UserType.BmpId ;
FROM AppUser ;
INNER JOIN UserType ON AppUser.UserTypeID = UserType.UserTypeID ;
WHERE AppUser.UserId = ?_PARAM
***
DBSETPROP([lvUserInCntViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserInCntViewRepl],[VIEW],[COMMENT],[LV User: обновления для lvUserInCntView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: редактирование списка пользователей/*
PROCEDURE lvUserEdit
***
CREATE VIEW lvUserEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	AppUser.UserId, ;
	AppUser.UserTypeId, ;
	AppUser.UserParId, ;
	AppUser.UserCltId, ;
	AppUser.UserLogin, ;
	AppUser.UserPassword, ;
	AppUser.UserComment, ;
	AppUser.UserIsActive, ;
	AppUser.UserOptions, ;
	AppUser.Stamp_, ;
	AppUser.User_ ;
FROM AppUser ;
WHERE AppUser.UserId = ?_PARAM
***
DBSETPROP([lvUserEdit.UserId],[FIELD],[KeyField],.T.)
DBSETPROP([lvUserEdit.UserId],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvUserEdit.UserTypeId],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserEdit.UserParId],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserEdit.UserCltId],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserEdit.UserLogin],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserEdit.UserPassword],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserEdit.UserComment],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserEdit.UserIsActive],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserEdit.UserOptions],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvUserEdit.UserOptions],[FIELD],[DataType],[M])
DBSETPROP([lvUserEdit.UserLogin],[FIELD],[DefaultValue],[""])
DBSETPROP([lvUserEdit.UserPassword],[FIELD],[DefaultValue],[""])
DBSETPROP([lvUserEdit.UserComment],[FIELD],[DefaultValue],[""])
DBSETPROP([lvUserEdit.UserIsActive],[FIELD],[DefaultValue],[.T.])
DBSETPROP([lvUserEdit.UserOptions],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvUserEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvUserEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvUserEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserEdit],[VIEW],[COMMENT],[LV User: обновление списка пользователей])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: пароль/*
PROCEDURE lvUserPassword
***
CREATE VIEW lvUserPassword REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	AppUser.UserId, ;
	AppUser.UserLogin, ;
	AppUser.UserPassword ;
FROM AppUser ;
INNER JOIN UserType ON UserType.UserTypeID = AppUser.UserTypeID AND UserType.UserTypeIsCnt = 0 ;
WHERE AppUser.UserId = ?_PARAM
***
DBSETPROP([lvUserPassword.UserId],[FIELD],[KeyField],.T.)
DBSETPROP([lvUserPassword.UserId],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvUserPassword.UserLogin],[FIELD],[Updatable],.F.)
DBSETPROP([lvUserPassword.UserPassword],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvUserPassword],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvUserPassword],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvUserPassword],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserPassword],[VIEW],[COMMENT],[LV User: пароль])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: список типов пользователей/*
PROCEDURE lvUserTypeList
***
CREATE SQL VIEW lvUserTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	UserType.UserTypeID, ;
	UserType.UserTypeNM ;
FROM UserType
***
DBSETPROP([lvUserTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserTypeList],[VIEW],[COMMENT],[LV User: список типов пользователей])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: просмотр прав пользователя/*
PROCEDURE lvUserGrantView
***
CREATE VIEW lvUserGrantView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	UserGrant.UserGrantID, ;
	UserGrant.ObjectTypeID, ;
	UserGrant.ObjectID, ;
	UserGrant.ObjectFuncBit ;
FROM UserGrant ;
WHERE UserGrant.UserId = ?_PARAM
***
DBSETPROP([lvUserGrantView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserGrantView],[VIEW],[COMMENT],[LV User: просмотр прав пользователя])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: права пользователя/*
PROCEDURE lvUserGrantEdit
***
CREATE VIEW lvUserGrantEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	UserGrant.UserGrantID, ;
	UserGrant.UserID, ;
	UserGrant.ObjectTypeID, ;
	UserGrant.ObjectID, ;
	UserGrant.ObjectFuncBit, ;
	UserGrant.Stamp_, ;
	UserGrant.User_ ;
FROM UserGrant ;
WHERE UserGrant.UserId = ?_PARAM
***
DBSETPROP([lvUserGrantEdit.UserGrantID],[FIELD],[KeyField],.T.)
DBSETPROP([lvUserGrantEdit.UserGrantID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvUserGrantEdit.UserID],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserGrantEdit.ObjectTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserGrantEdit.ObjectID],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserGrantEdit.ObjectFuncBit],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserGrantEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvUserGrantEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvUserGrantEdit.ObjectFuncBit],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvUserGrantEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvUserGrantEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvUserGrantEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserGrantEdit],[VIEW],[COMMENT],[LV User: права пользователя])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: список функций обектов/*
PROCEDURE lvUserObjFuncList
***
CREATE SQL VIEW lvUserObjFuncList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ObjectFunction.ObjectFunctionID AS FuncID, ;
	ObjectFunction.ObjectFunctionNM AS FuncNM, ;
	ObjectFunction.ObjectFunctionDesc AS FuncDesc ;
FROM ObjectFunction
***
DBSETPROP([lvUserObjFuncList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserObjFuncList],[VIEW],[COMMENT],[LV User: список функций объектов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: список типов объектов/*
PROCEDURE lvObjTypeList
***
CREATE SQL VIEW lvObjTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ObjectType.ObjectTypeID, ;
	ObjectType.ObjectTypeNM ;
FROM ObjectType ;
ORDER BY ObjectType.ObjectTypeNM
***
DBSETPROP([lvObjTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvObjTypeList],[VIEW],[COMMENT],[LV User: список типов объектов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: список используемых картинок для типов пользователей/*
PROCEDURE lvUserBmps
***
CREATE SQL VIEW lvUserBmps REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Bitmaps.BmpId, ;
	Bitmaps.BmpFileNM ;
FROM Bitmaps ;
WHERE	(Bitmaps.BmpId IN (SELECT UserType.BmpId FROM UserType)) OR ;
		(Bitmaps.BmpId IN (SELECT UserType.SelBmpId FROM UserType))
***
DBSETPROP([lvUserBmps],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvUserBmps],[VIEW],[COMMENT],[LV User: список используемых картинок для типов пользователей])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV User: Код клиента по коду пользователя/*
PROCEDURE lvCltByUser()
***
CREATE SQL VIEW lvCltByUser REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	AppUser.UserCltID ;
FROM AppUser ;
WHERE AppUser.UserID = ?_PARAM
***
DBSETPROP([lvCltByUser],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltByUser],[VIEW],[COMMENT],[LV User: Код клиента по коду пользователя])
***
ENDPROC
*------------------------------------------------------------------------------

*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************