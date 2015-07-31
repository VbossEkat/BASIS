#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 14:41 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Клиенты] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Клиенты]
***
lvCltCntTreeView()
lvCltCntTreeViewRepl()
lvCltInCntView()
lvCltInCntViewRepl()
lvCltEdit()
lvCltImageEdit()
lvCltPhysicalEdit()
lvCltJuridicalEdit()
lvCltAddrView()
lvCltAddrViewRepl()
lvCltAddrViewJoin()
lvCltAddrEdit()
lvCltTelViewByCltID()
lvCltTelViewByAddr()
lvCltTelViewRepl()
lvCltTelEdit()
lvCltPhysicalPasspEdit()
lvCltSAccountView()
lvCltSAccountViewRepl()
lvCltSAccountEdit()
lvCltPhysInfo()
lvCltTypeList()
lvCltTypeListWithoutGroup()
lvCltRoleList()
lvCltLegalTypeList()
lvCltCountryList()
lvCltAddrTypeList()
lvCltTypeInfoMgr()
lvCltNMView()
lvCltBmps()
lvCltSupplierList()
lvCltCustomerList()
lvCltCustPhysList()
lvCltSupAndCustList()
lvCltMakerList()
lvCltEmployeeList()
lvCltPhysicalList()
lvCltJuridicalList()
lvCltWaiterList()
lvOuOperateList()
lvOuOperateListInt()
lvCltSAccountList()
lvOUSAccountList()
lvCltPostList()
***
lvCltGrpView()
lvCltGrpViewRepl()
lvCltGrpEdit()
***
lvFactSchView()
lvFactSchViewRepl()
lvFactSchEdit()
***
lvCltLinkGrpView()
lvCltLinkGrpViewRepl()
lvCltLinkGrpEdit()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV CLT: дерево клиентов/*
PROCEDURE lvCltCntTreeView
***
CREATE SQL VIEW lvCltCntTreeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Client.CltID, ;
	ISNULL(Client.CltParID,0) AS CltParID, ;
	Client.CltNM, ;
	CltType.CltTypeIsCnt AS CltIsCnt, ;
	CltType.BmpId AS BmpId, ;
	CltType.SelBmpId AS SelBmpId ;
FROM Client ;
INNER JOIN CltType ON Client.CltTypeID = CltType.CltTypeID ;
WHERE CltType.CltTypeIsCnt = 1 ;
ORDER BY 3
***
DBSETPROP([lvCltCntTreeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltCntTreeView],[VIEW],[COMMENT],[LV CLT: дерево клиентов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: обновления для lvCltCntTreeView/*
PROCEDURE lvCltCntTreeViewRepl
***
CREATE SQL VIEW lvCltCntTreeViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Client.CltID, ;
	ISNULL(Client.CltParID,0) AS CltParID, ;
	Client.CltNM, ;
	CltType.CltTypeIsCnt AS CltIsCnt, ;
	CltType.BmpId AS BmpId, ;
	CltType.SelBmpId AS SelBmpId ;
FROM Client ;
INNER JOIN CltType ON Client.CltTypeID = CltType.CltTypeID ;
WHERE CltType.CltTypeIsCnt = 1 AND Client.CltID = ?_PARAM
***
DBSETPROP([lvCltCntTreeViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltCntTreeViewRepl],[VIEW],[COMMENT],[LV CLT: обновления для lvCltCntTreeView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: содержание группы клиентов/*
PROCEDURE lvCltInCntView
***
CREATE SQL VIEW lvCltInCntView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Client.CltID, ;
	Client.CltNM, ;
	ISNULL(Client.CltParID,0) AS CltParID, ;
	CltType.CltTypeID, ;
	CltType.CltTypeIsCnt, ;
	CltType.BmpId AS BmpId ;
FROM Client ;
INNER JOIN CltType ON Client.CltTypeID = CltType.CltTypeID ;
WHERE ISNULL(Client.CltParID,0) = ?_PARAM ;
ORDER BY CltType.CltTypeID,Client.CltNM
***
DBSETPROP([lvCltInCntView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltInCntView],[VIEW],[COMMENT],[LV CLT: содержание группы клиентов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: обновления для lvCltInCntView/*
PROCEDURE lvCltInCntViewRepl
***
CREATE SQL VIEW lvCltInCntViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Client.CltID, ;
	Client.CltNM, ;
	ISNULL(Client.CltParID,0) AS CltParID, ;
	CltType.CltTypeID, ;
	CltType.CltTypeIsCnt, ;
	CltType.BmpId AS BmpId ;
FROM Client ;
INNER JOIN CltType ON Client.CltTypeID = CltType.CltTypeID ;
WHERE Client.CltID = ?_PARAM
***
DBSETPROP([lvCltInCntViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltInCntViewRepl],[VIEW],[COMMENT],[LV CLT: обновления для lvCltInCntView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: редактирование таблицы Client*/
PROCEDURE lvCltEdit
***
CREATE SQL VIEW lvCltEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Client.CltID, ;
	Client.CltParID, ;
	Client.CltTypeID, ;
	Client.CltNM, ;
	Client.CltRole, ;
	Client.CltIsActiv, ;
	Client.CltINN, ;
	Client.CltNote, ;
	Client.Stamp_, ;
	Client.User_ ;
FROM Client ;
WHERE Client.CltID = ?_PARAM
***
DBSETPROP([lvCltEdit.CltID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCltEdit.CltID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCltEdit.CltParID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltEdit.CltTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltEdit.CltNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltEdit.CltRole],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltEdit.CltIsActiv],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltEdit.CltINN],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltEdit.CltNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCltEdit.CltNote],[FIELD],[DataType],[M])
DBSETPROP([lvCltEdit.CltTypeID],[FIELD],[DefaultValue],[2])
DBSETPROP([lvCltEdit.CltRole],[FIELD],[DefaultValue],[0])
DBSETPROP([lvCltEdit.CltIsActiv],[FIELD],[DefaultValue],[.T.])
DBSETPROP([lvCltEdit.CltINN],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvCltEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCltEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCltEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltEdit],[VIEW],[COMMENT],[LV CLT: редактирование таблицы Client])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: редактирование таблицы CltImage*/
PROCEDURE lvCltImageEdit
***
CREATE SQL VIEW lvCltImageEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltImage.CltID, ;
	CltImage.CltImage, ;
	CltImage.Stamp_, ;
	CltImage.User_ ;
FROM CltImage ;
WHERE CltImage.CltID = ?_PARAM
***
DBSETPROP([lvCltImageEdit.CltID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCltImageEdit.CltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltImageEdit.CltImage],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltImageEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltImageEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCltImageEdit.CltImage],[FIELD],[DataType],[M])
DBSETPROP([lvCltImageEdit.CltImage],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvCltImageEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCltImageEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCltImageEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltImageEdit],[VIEW],[COMMENT],[LV CLT: редактирование таблицы CltImage])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: редактирование таблицы с информацией о физическом лице*/
PROCEDURE lvCltPhysicalEdit
***
CREATE SQL VIEW lvCltPhysicalEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltPhysical.CltID, ;
	CltPhysical.CltPhysFNM, ;
	CltPhysical.CltPhysINM, ;
	CltPhysical.CltPhysONM, ;
	CltPhysical.CltPhysBirthDate, ;
	CltPhysical.CltPostID, ;
	CltPhysical.Stamp_, ;
	CltPhysical.User_ ;
FROM CltPhysical ;
WHERE CltPhysical.CltID = ?_PARAM
***
DBSETPROP([lvCltPhysicalEdit.CltID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCltPhysicalEdit.CltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalEdit.CltPhysFNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalEdit.CltPhysINM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalEdit.CltPhysONM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalEdit.CltPhysBirthDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalEdit.CltPostID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCltPhysicalEdit.CltPhysFNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltPhysicalEdit.CltPhysINM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltPhysicalEdit.CltPhysONM],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvCltPhysicalEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCltPhysicalEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCltPhysicalEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltPhysicalEdit],[VIEW],[COMMENT],[LV CLT: редактирование таблицы с информацией о физическом лице])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: редактирование таблицы с информацией о юридическои лице*/
PROCEDURE lvCltJuridicalEdit
***
CREATE SQL VIEW lvCltJuridicalEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltJuridical.CltID, ;
	CltJuridical.CltLegalTypeID, ;
	CltJuridical.CltJrdNM, ;
	CltJuridical.CltJrdKPP, ;
	CltJuridical.Stamp_, ;
	CltJuridical.User_ ;
FROM CltJuridical ;
WHERE CltJuridical.CltID = ?_PARAM
***
DBSETPROP([lvCltJuridicalEdit.CltID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCltJuridicalEdit.CltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltJuridicalEdit.CltLegalTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltJuridicalEdit.CltJrdNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltJuridicalEdit.CltJrdKPP],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltJuridicalEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltJuridicalEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCltJuridicalEdit.CltJrdKPP],[FIELD],[DataType],[I])
***
DBSETPROP([lvCltJuridicalEdit.CltJrdNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltJuridicalEdit.CltJrdKPP],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvCltJuridicalEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCltJuridicalEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCltJuridicalEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltJuridicalEdit],[VIEW],[COMMENT],[LV CLT: редактирование таблицы с информацией о юридическом лице])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: список адресов клиента/*
PROCEDURE lvCltAddrView
***
CREATE SQL VIEW lvCltAddrView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltAddress.CltAddrID, ;
	CltAddress.CltID, ;
	CltAddress.CltAddrIsMain, ;
	CltAddress.CltAddrZIP, ;
	CltAddress.CltAddrRegNM, ;
	CltAddress.CltAddrAreaNM, ;
	CltAddress.CltAddrSettlNM, ;
	CltAddress.CltAddrStreetNM, ;
	CltAddress.CltAddrHouseNM, ;
	CltAddress.CltAddrRoom ;
FROM CltAddress ;
WHERE CltAddress.CltID = ?_PARAM ;
ORDER BY ;
	CltAddress.CltAddrIsMain DESC, ;
	CltAddress.CltAddrZIP, ;
	CltAddress.CltAddrRegNM, ;
	CltAddress.CltAddrAreaNM, ;
	CltAddress.CltAddrSettlNM, ;
	CltAddress.CltAddrStreetNM, ;
	CltAddress.CltAddrHouseNM, ;
	CltAddress.CltAddrRoom 
***
DBSETPROP([lvCltAddrView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltAddrView],[VIEW],[COMMENT],[LV CLT: список адресов клиента])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: обновления для lvCltAddrView/*
PROCEDURE lvCltAddrViewRepl
***
CREATE SQL VIEW lvCltAddrViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltAddress.CltAddrID, ;
	CltAddress.CltID, ;
	CltAddress.CltAddrIsMain, ;
	CltAddress.CltAddrZIP, ;
	CltAddress.CltAddrRegNM, ;
	CltAddress.CltAddrAreaNM, ;
	CltAddress.CltAddrSettlNM, ;
	CltAddress.CltAddrStreetNM, ;
	CltAddress.CltAddrHouseNM, ;
	CltAddress.CltAddrRoom ;
FROM CltAddress ;
WHERE CltAddress.CltAddrID = ?_PARAM
***
DBSETPROP([lvCltAddrViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltAddrViewRepl],[VIEW],[COMMENT],[LV CLT: обновления для lvCltAddrView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: список адресов клиента/*
PROCEDURE lvCltAddrViewJoin
***
CREATE SQL VIEW lvCltAddrViewJoin REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltAddress.CltAddrID, ;
	CltAddrFull = CASE WHEN CltAddress.CltAddrZIP > 0 THEN LTRIM(STR(CltAddress.CltAddrZIP)) + ' ' ELSE '' END + CASE WHEN CltAddress.CltAddrRegNM = '' THEN '' ELSE CltAddress.CltAddrRegNM + ' ' END + CASE WHEN CltAddress.CltAddrAreaNM = '' THEN '' ELSE + ;
		CltAddress.CltAddrAreaNM + ' ' END + CASE WHEN CltAddress.CltAddrSettlNM = '' THEN '' ELSE CltAddress.CltAddrSettlNM + ' ' END + CASE WHEN CltAddress.CltAddrStreetNM = '' THEN '' ELSE CltAddress.CltAddrStreetNM + ' ' END + CASE WHEN + ;
		CltAddress.CltAddrHouseNM = '' THEN '' ELSE CltAddress.CltAddrHouseNM + ' ' END + CASE WHEN CltAddress.CltAddrRoom = '' THEN '' ELSE CltAddress.CltAddrRoom END ;
FROM CltAddress ;
WHERE CltAddress.CltID = ?_PARAM ;
ORDER BY ;
	CltAddress.CltAddrIsMain DESC, ;
	CltAddress.CltAddrZIP, ;
	CltAddress.CltAddrRegNM, ;
	CltAddress.CltAddrAreaNM, ;
	CltAddress.CltAddrSettlNM, ;
	CltAddress.CltAddrStreetNM, ;
	CltAddress.CltAddrHouseNM, ;
	CltAddress.CltAddrRoom
***
DBSETPROP([lvCltAddrViewJoin.CltAddrFull],[FIELD],[DataType],[C(250)])
***
DBSETPROP([lvCltAddrViewJoin],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltAddrView],[VIEW],[COMMENT],[LV CLT: список адресов клиента])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: редактирование таблицы CltAddress*/
PROCEDURE lvCltAddrEdit
***
CREATE SQL VIEW lvCltAddrEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltAddress.CltAddrID, ;
	CltAddress.CltID, ;
	CltAddress.CltAddrTypeID, ;
	CltAddress.CltCountryID, ;
	CltAddress.CltAddrZIP, ;
	CltAddress.CltAddrRegNM, ;
	CltAddress.CltAddrAreaNM, ;
	CltAddress.CltAddrSettlNM, ;
	CltAddress.CltAddrStreetNM, ;
	CltAddress.CltAddrHouseNM, ;
	CltAddress.CltAddrRoom, ;
	CltAddress.CltAddrIsMain, ;
	CltAddress.Stamp_, ;
	CltAddress.User_ ;
FROM CltAddress ;
WHERE CltAddress.CltAddrID = ?_PARAM
***
DBSETPROP([lvCltAddrEdit.CltAddrID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCltAddrEdit.CltAddrID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCltAddrEdit.CltAddrTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltAddrEdit.CltCountryID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltAddrEdit.CltAddrZIP],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltAddrEdit.CltAddrRegNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltAddrEdit.CltAddrAreaNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltAddrEdit.CltAddrSettlNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltAddrEdit.CltAddrStreetNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltAddrEdit.CltAddrHouseNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltAddrEdit.CltAddrRoom],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltAddrEdit.CltAddrIsMain],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltAddrEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltAddrEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCltAddrEdit.CltAddrZIP],[FIELD],[DefaultValue],[0])
DBSETPROP([lvCltAddrEdit.CltAddrRegNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltAddrEdit.CltAddrAreaNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltAddrEdit.CltAddrSettlNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltAddrEdit.CltAddrStreetNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltAddrEdit.CltAddrHouseNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltAddrEdit.CltAddrRoom],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltAddrEdit.CltAddrIsMain],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvCltAddrEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCltAddrEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCltAddrEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltAddrEdit],[VIEW],[COMMENT],[LV CLT: редактирование таблицы CltAddress])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: список телефонов клиента/*
PROCEDURE lvCltTelViewByCltID
***
CREATE SQL VIEW lvCltTelViewByCltID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltTel.CltTelID, ;
	CltTel.CltID, ;
	CltTel.CltAddrID, ;
	CltTel.CltTelNumber, ;
	CltTel.CltTelNote, ;
	CltTel.CltTelIsMain ;
FROM CltTel ;
WHERE CltTel.CltID = ?_PARAM ;
ORDER BY ;
	CltTel.CltTelIsMain DESC, ;
	CltTel.CltTelNumber
***
DBSETPROP([lvCltTelViewByCltID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltTelViewByCltID],[VIEW],[COMMENT],[LV CLT: список телефонов клиента])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: список телефонов клиента по определенному адресу/*
PROCEDURE lvCltTelViewByAddr
***
CREATE SQL VIEW lvCltTelViewByAddr REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltTel.CltTelID, ;
	CltTel.CltID, ;
	CltTel.CltAddrID, ;
	CltTel.CltTelNumber, ;
	CltTel.CltTelNote, ;
	CltTel.CltTelIsMain ;
FROM CltTel ;
WHERE CltTel.CltAddrID = ?_PARAM
***
DBSETPROP([lvCltTelViewByAddr],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltTelViewByAddr],[VIEW],[COMMENT],[LV CLT: список телефонов клиента по определенному адресу])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: обновления для lvCltTelView/*
PROCEDURE lvCltTelViewRepl
***
CREATE SQL VIEW lvCltTelViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltTel.CltTelID, ;
	CltTel.CltID, ;
	CltTel.CltAddrID, ;
	CltTel.CltTelNumber, ;
	CltTel.CltTelNote, ;
	CltTel.CltTelIsMain ;
FROM CltTel ;
WHERE CltTel.CltTelID = ?_PARAM
***
DBSETPROP([lvCltTelViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltTelViewRepl],[VIEW],[COMMENT],[LV CLT: обновления для lvCltTelView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: редактирование таблицы CltTel*/
PROCEDURE lvCltTelEdit
***
CREATE SQL VIEW lvCltTelEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltTel.CltTelID, ;
	CltTel.CltID, ;
	CltTel.CltAddrID, ;
	CltTel.CltTelNumber, ;
	CltTel.CltTelNote, ;
	CltTel.CltTelIsMain, ;
	CltTel.Stamp_, ;
	CltTel.User_ ;
FROM CltTel ;
WHERE CltTel.CltTelID = ?_PARAM
***
DBSETPROP([lvCltTelEdit.CltTelID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCltTelEdit.CltTelID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCltTelEdit.CltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltTelEdit.CltAddrID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltTelEdit.CltTelNumber],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltTelEdit.CltTelNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltTelEdit.CltTelIsMain],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltTelEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltTelEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCltTelEdit.CltTelNumber],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltTelEdit.CltTelNote],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltTelEdit.CltTelIsMain],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvCltTelEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCltTelEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCltTelEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltTelEdit],[VIEW],[COMMENT],[LV CLT: редактирование таблицы CltTel])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: редактирование паспортных данных физического лица*/
PROCEDURE lvCltPhysicalPasspEdit
***
CREATE SQL VIEW lvCltPhysicalPasspEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltPhysPassp.CltPhysPasspID, ;
	CltPhysPassp.CltID, ;
	CltPhysPassp.CltPhysPasspSeries, ;
	CltPhysPassp.CltPhysPasspNumber, ;
	CltPhysPassp.CltPhysPasspIssueBy, ;
	CltPhysPassp.CltPhysPasspIssueDate, ;
	CltPhysPassp.CltPhysPasspExpDate, ;
	CltPhysPassp.Stamp_, ;
	CltPhysPassp.User_ ;
FROM CltPhysPassp ;
WHERE CltPhysPassp.CltID = ?_PARAM
***
DBSETPROP([lvCltPhysicalPasspEdit.CltPhysPasspID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCltPhysicalPasspEdit.CltPhysPasspID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalPasspEdit.CltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalPasspEdit.CltPhysPasspSeries],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalPasspEdit.CltPhysPasspNumber],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalPasspEdit.CltPhysPasspIssueBy],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalPasspEdit.CltPhysPasspIssueDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalPasspEdit.CltPhysPasspExpDate],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalPasspEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltPhysicalPasspEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCltPhysicalPasspEdit.CltPhysPasspSeries],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltPhysicalPasspEdit.CltPhysPasspNumber],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltPhysicalPasspEdit.CltPhysPasspIssueBy],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvCltPhysicalPasspEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCltPhysicalPasspEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCltPhysicalPasspEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltPhysicalPasspEdit],[VIEW],[COMMENT],[LV CLT: редактирование паспортных данных физического лица])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: расчетные счета клиента/*
PROCEDURE lvCltSAccountView
***
CREATE SQL VIEW lvCltSAccountView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltSAccount.CltID, ;
	CltSAccount.CltSAccID, ;
	CltSAccount.CltSAcc, ;
	CltSAccount.CltSAccNM, ;
	CltSAccount.CltSAccIsMain, ;
	CltSAccount.CltSAccNote, ;
	CltSAccount.CltBankID, ;
	CltBank.CltBankBIK, ;
	CltBank.CltBankNM ;
FROM CltSAccount ;
LEFT JOIN CltBank ON CltSAccount.CltBankID = CltBank.CltBankID ;
WHERE CltSAccount.CltID = ?_PARAM
***
DBSETPROP([lvCltSAccountView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltSAccountView],[VIEW],[COMMENT],[LV CLT: расчетные счета клиента])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: обновления для lvCltSAccountView/*
PROCEDURE lvCltSAccountViewRepl
***
CREATE SQL VIEW lvCltSAccountViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltSAccount.CltID, ;
	CltSAccount.CltSAccID, ;
	CltSAccount.CltSAcc, ;
	CltSAccount.CltSAccNM, ;
	CltSAccount.CltSAccIsMain, ;
	CltSAccount.CltSAccNote, ;
	CltSAccount.CltBankID, ;
	CltBank.CltBankBIK, ;
	CltBank.CltBankNM ;
FROM CltSAccount ;
LEFT JOIN CltBank ON CltSAccount.CltBankID = CltBank.CltBankID ;
WHERE CltSAccount.CltSAccID = ?_PARAM
***
DBSETPROP([lvCltSAccountViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltSAccountViewRepl],[VIEW],[COMMENT],[LV CLT: обновления для lvCltSAccountView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: редактирование таблицы CltSAccount*/
PROCEDURE lvCltSAccountEdit
***
CREATE SQL VIEW lvCltSAccountEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltSAccount.CltID, ;
	CltSAccount.CltSAccID, ;
	CltSAccount.CltBankID, ;
	CltSAccount.CltSAcc, ;
	CltSAccount.CltSAccNM, ;
	CltSAccount.CltSAccIsMain, ;
	CltSAccount.CltSAccNote, ;
	CltSAccount.Stamp_, ;
	CltSAccount.User_ ;
FROM CltSAccount ;
WHERE CltSAccount.CltSAccID = ?_PARAM
***
DBSETPROP([lvCltSAccountEdit.CltSAccID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCltSAccountEdit.CltSAccID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCltSAccountEdit.CltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltSAccountEdit.CltBankID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltSAccountEdit.CltSAcc],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltSAccountEdit.CltSAccNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltSAccountEdit.CltSAccIsMain],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltSAccountEdit.CltSAccNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltSAccountEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltSAccountEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCltSAccountEdit.CltSAcc],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltSAccountEdit.CltSAccNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltSAccountEdit.CltSAccIsMain],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvCltSAccountEdit.CltSAccNote],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvCltSAccountEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCltSAccountEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCltSAccountEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltSAccountEdit],[VIEW],[COMMENT],[LV CLT: редактирование таблицы CltSAccount])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: информация о физическом лице/*
PROCEDURE lvCltPhysInfo
***
CREATE SQL VIEW lvCltPhysInfo REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltPhysical.CltID, ;
	CltPhysical.CltPhysFNM, ;
	CltPhysical.CltPhysINM, ;
	CltPhysical.CltPhysONM, ;
	CltPhysical.CltPhysBirthDate, ;
	ISNULL(CltAddress.CltAddrSettlNM,'') AS CltAddrSettlNM, ;
	ISNULL(CltAddress.CltAddrStreetNM,'') + ' ' + ISNULL(CltAddress.CltAddrHouseNM,'')  + ' ' + ISNULL(CltAddress.CltAddrRoom,'') AS CltAddr, ;
	ISNULL(CltTel.CltTelNumber,'') AS CltTelNumber, ;
	ISNULL(CltPhysPassp.CltPhysPasspSeries,'')		AS CltPasspSeries, ;
	ISNULL(CltPhysPassp.CltPhysPasspNumber,'')		AS CltPasspNumber, ;
	ISNULL(CltPhysPassp.CltPhysPasspIssueBy,'')		AS CltPasspIssueBy, ;
	ISNULL(CltPhysPassp.CltPhysPasspIssueDate,'')	AS CltPasspIssueDate, ;
	ISNULL(CltPost.CltPostNM,'')   AS CltPostNM ;
FROM CltPhysical ;
LEFT JOIN CltAddress   ON CltAddress.CltID	 = CltPhysical.CltID AND CltAddress.CltAddrIsMain = 1 ;
LEFT JOIN CltTel	   ON CltTel.CltID	     = CltPhysical.CltID AND CltTel.CltTelIsMain = 1 ;
LEFT JOIN CltPhysPassp ON CltPhysPassp.CltID = CltPhysical.CltID ;
LEFT JOIN CltPost	   ON CltPost.CltPostID  = CltPhysical.CltPostID ;
WHERE CltPhysical.CltID = ?_PARAM
***
DBSETPROP([lvCltPhysInfo],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltPhysInfo],[VIEW],[COMMENT],[LV CLT: информация о физическом лице])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: список типов клиентов/*
PROCEDURE lvCltTypeList
***
CREATE SQL VIEW lvCltTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltType.CltTypeID, ;
	CltType.CltTypeNM ;
FROM CltType
***
DBSETPROP([lvCltTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltTypeList],[VIEW],[COMMENT],[LV CLT: список типов клиентов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: список типов клиентов без групп/*
PROCEDURE lvCltTypeListWithoutGroup
***
CREATE SQL VIEW lvCltTypeListWithoutGroup REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltType.CltTypeID, ;
	CltType.CltTypeNM ;
FROM CltType ;
WHERE CltType.CltTypeID <> 1
***
DBSETPROP([lvCltTypeListWithoutGroup],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltTypeListWithoutGroup],[VIEW],[COMMENT],[LV CLT: список типов клиентов без групп])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: список ролей клиентов/*
PROCEDURE lvCltRoleList
***
CREATE SQL VIEW lvCltRoleList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltRole.CltRoleBit, ;
	CltRole.CltRoleNM ;
FROM CltRole ;
ORDER BY CltRole.CltRoleNM
***
DBSETPROP([lvCltRoleList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltRoleList],[VIEW],[COMMENT],[LV CLT: список ролей клиентов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: список типов ОПФ(организационно-правовых форм) клиентов/*
PROCEDURE lvCltLegalTypeList
***
CREATE SQL VIEW lvCltLegalTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltLegalType.CltLegalTypeID, ;
	CltLegalType.CltLegalTypeNM ;
FROM CltLegalType ;
ORDER BY CltLegalType.CltLegalTypeNM
***
DBSETPROP([lvCltLegalTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltLegalTypeList],[VIEW],[COMMENT],[LV CLT: список типов ОПФ(организационно-правовых форм) клиентов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: список стран/*
PROCEDURE lvCltCountryList
***
CREATE SQL VIEW lvCltCountryList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltCountry.CltCountryID ,;
	CltCountry.CltCountryNM ;
FROM CltCountry ;
ORDER BY CltCountry.CltCountryNM
***
DBSETPROP([lvCltCountryList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltCountryList],[VIEW],[COMMENT],[LV CLT: список стран])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: список типов адресов клиентов/*
PROCEDURE lvCltAddrTypeList
***
CREATE SQL VIEW lvCltAddrTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltAddrType.CltAddrTypeID, ;
	CltAddrType.CltAddrTypeNM ;
FROM CltAddrType
***
DBSETPROP([lvCltAddrTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltAddrTypeList],[VIEW],[COMMENT],[LV CLT: список типов адресов клиентов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: информация об объекте для редактирования для менеджера предметной области CLIENT/*
PROCEDURE lvCltTypeInfoMgr
***
CREATE SQL VIEW lvCltTypeInfoMgr REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltTypeObjDesc ;
FROM CltType ;
INNER JOIN Client ON CltType.CltTypeId = Client.CltTypeId ;
WHERE Client.CltID = ?_PARAM
***
DBSETPROP([lvCltTypeInfoMgr],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltTypeInfoMgr],[VIEW],[COMMENT],[LV CLT: информация об объекте для редактирования для менеджера предметной области CLIENT])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: просмотр имени клиента*/
PROCEDURE lvCltNMView
***
CREATE SQL VIEW lvCltNMView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Client.CltNM ;
FROM Client ;
WHERE Client.CltID = ?_PARAM
***
DBSETPROP([lvCltNMView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltNMView],[VIEW],[COMMENT],[LV CLT: просмотр имени клиента])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: список используемых картинок для типов клиентов/*
PROCEDURE lvCltBmps
***
CREATE SQL VIEW lvCltBmps REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Bitmaps.BmpId, ;
	Bitmaps.BmpFileNM ;
FROM Bitmaps ;
WHERE	(Bitmaps.BmpId IN (SELECT CltType.BmpId FROM CltType)) OR ;
		(Bitmaps.BmpId IN (SELECT CltType.SelBmpId FROM CltType))
***
DBSETPROP([lvCltBmps],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltBmps],[VIEW],[COMMENT],[LV CLT: список используемых картинок для типов клиентов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Клиенты - поставщики/*
PROCEDURE lvCltSupplierList
***
CREATE SQL VIEW lvCltSupplierList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltID AS ID, ;
	CltNM AS NM ;
FROM Client ;
WHERE dbo.BITTEST(Client.CltRole,0) = 1 ;
ORDER BY Client.CltNM
***
DBSETPROP([lvCltSupplierList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltSupplierList],[VIEW],[COMMENT],[LV CLT: Клиенты - поставщики])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Клиенты - покупатели/*
PROCEDURE lvCltCustomerList
***
CREATE SQL VIEW lvCltCustomerList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Client.CltID AS ID, ;
	Client.CltNM AS NM ;
FROM Client ;
LEFT JOIN DiscCard ON DiscCard.CltID = Client.CltID ;
WHERE ;
	dbo.BITTEST(Client.CltRole,1) = 1 AND ;
	DiscCard.DiscCardID IS NULL ;
ORDER BY Client.CltNM
***
DBSETPROP([lvCltCustomerList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltCustomerList],[VIEW],[COMMENT],[LV CLT: Клиенты - покупатели])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Клиенты - покупатели физические лица/*
PROCEDURE lvCltCustPhysList
***
CREATE SQL VIEW lvCltCustPhysList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltID AS ID, ;
	CltNM AS NM ;
FROM Client ;
WHERE (dbo.BITTEST(Client.CltRole,1) = 1 AND Client.CltTypeID = 3) OR Client.CltTypeID = 4 ;
ORDER BY Client.CltNM
***
DBSETPROP([lvCltCustPhysList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltCustPhysList],[VIEW],[COMMENT],[Клиенты - покупатели физические лица])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Клиенты - покупатели и клиенты - поставщики/*
PROCEDURE lvCltSupAndCustList
***
CREATE SQL VIEW lvCltSupAndCustList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltID AS ID, ;
	CltNM AS NM ;
FROM Client ;
WHERE dbo.BITTEST(Client.CltRole,0) = 1 OR dbo.BITTEST(Client.CltRole,1) = 1 ;
ORDER BY Client.CltNM
***
DBSETPROP([lvCltSupAndCustList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltSupAndCustList],[VIEW],[COMMENT],[LV CLT: Клиенты - покупатели и клиенты - поставщики])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Клиенты - производители/*
PROCEDURE lvCltMakerList
***
CREATE SQL VIEW lvCltMakerList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltID AS ID, ;
	CltNM AS NM ;
FROM Client ;
WHERE dbo.BITTEST(Client.CltRole,2) = 1 ;
ORDER BY Client.CltNM
***
DBSETPROP([lvCltMakerList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltMakerList],[VIEW],[COMMENT],[LV CLT: Клиенты - производители])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Клиенты - сотрудники/*
PROCEDURE lvCltEmployeeList
***
CREATE SQL VIEW lvCltEmployeeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltID AS ID, ;
	CltNM AS NM ;
FROM Client ;
WHERE Client.CltTypeID = 4 ;
ORDER BY Client.CltNM
***
DBSETPROP([lvCltEmployeeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltEmployeeList],[VIEW],[COMMENT],[LV CLT: Клиенты - сотрудники])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Физические лица/*
PROCEDURE lvCltPhysicalList
***
CREATE SQL VIEW lvCltPhysicalList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltID AS ID, ;
	CltNM AS NM ;
FROM Client ;
WHERE Client.CltTypeID = 3 OR Client.CltTypeID = 4 ;
ORDER BY Client.CltNM
***
DBSETPROP([lvCltPhysicalList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltPhysicalList],[VIEW],[COMMENT],[LV CLT: Физические лица])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Клиенты - юридические лица/*
PROCEDURE lvCltJuridicalList
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
DBSETPROP([lvCltJuridicalList],[VIEW],[COMMENT],[LV CLT: Клиенты - юридические лица])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Клиенты - официанты/*
PROCEDURE lvCltWaiterList
***
CREATE SQL VIEW lvCltWaiterList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltID AS ID, ;
	CltNM AS NM ;
FROM Client ;
WHERE dbo.BITTEST(Client.CltRole,3) = 1 ;
ORDER BY Client.CltNM
***
DBSETPROP([lvCltWaiterList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltWaiterList],[VIEW],[COMMENT],[LV CLT: Клиенты - официанты])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV OU: Список организационных единиц/*
PROCEDURE lvOuOperateList
***
CREATE SQL VIEW lvOuOperateList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	OUID AS ID, ;
	OUNM AS NM ;
FROM OrgUnit ;
INNER JOIN UserGrant ON UserGrant.ObjectID = OrgUnit.OUID AND UserGrant.UserID = ?_PARAM ;
INNER JOIN ObjectType ON ObjectType.ObjectTypeID = UserGrant.ObjectTypeID AND UPPER(ObjectType.TableNM) = 'ORGUNIT' ;
WHERE OrgUnit.Operate_ = 1 ;
ORDER BY OrgUnit.OUNM
***
DBSETPROP([lvOuOperateList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOuOperateList],[VIEW],[COMMENT],[LV OU: Список организационных единиц по которым могут проводиться транзакции])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV OU: Список организационных единиц (без ограничения правами пользователя, для внутренних документов)/*
PROCEDURE lvOuOperateListInt
***
CREATE SQL VIEW lvOuOperateListInt REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	OUID AS ID, ;
	OUNM AS NM ;
FROM OrgUnit ;
WHERE OrgUnit.Operate_ = 1 ;
ORDER BY OrgUnit.OUNM
***
DBSETPROP([lvOuOperateListInt],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOuOperateListInt],[VIEW],[COMMENT],[LV OU: Список организационных единиц (без ограничения правами пользователя, для внутренних документов)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV OU: Список рассчётных счетов клиента/*
PROCEDURE lvCltSAccountList
***
CREATE SQL VIEW lvCltSAccountList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltSAccount.CltSAccID AS ID, ;
	CltSAccount.CltSAccNM AS NM, ;
	CltSAccount.CltSAccIsMain AS default_ ;
FROM CltSAccount ;
WHERE CltSAccount.CltID = ?_PARAM
***
DBSETPROP([lvCltSAccountList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltSAccountList],[VIEW],[COMMENT],[LV OU: Список рассчётных счетов клиента])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV OU: Список рассчётных счетов подразделения/*
PROCEDURE lvOUSAccountList
***
CREATE SQL VIEW lvOUSAccountList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT DISTINCT ;
	CltSAccount.CltSAccID AS ID, ;
	CltSAccount.CltSAccNM AS NM, ;
	CltSAccount.CltSAccIsMain AS default_ ;
FROM CltSAccount ;
INNER JOIN OrgUnit ON CltSAccount.CltID = OrgUnit.CltID ;
WHERE OrgUnit.OUID = ?_PARAM
***
DBSETPROP([lvOUSAccountList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOUSAccountList],[VIEW],[COMMENT],[LV OU: Список рассчётных счетов подразделения])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Список должностей/*
PROCEDURE lvCltPostList
***
CREATE SQL VIEW lvCltPostList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT DISTINCT ;
	CltPost.CltPostID AS ID, ;
	CltPost.CltPostNM AS NM ;
FROM CltPost
***
DBSETPROP([lvCltPostList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltPostList],[VIEW],[COMMENT],[LV CLT: Список должностей])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Группы клиентов/*
PROCEDURE lvCltGrpView
***
CREATE SQL VIEW lvCltGrpView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltGroup.CltGroupID, ;
	CltGroup.CltGroupNM, ;
	CltGroup.CltGroupNote ;
FROM CltGroup
***
DBSETPROP([lvCltGrpView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltGrpView],[VIEW],[COMMENT],[LV CLT: Группы клиентов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Обновление группы клиентов/*
PROCEDURE lvCltGrpViewRepl
***
CREATE SQL VIEW lvCltGrpViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltGroup.CltGroupID, ;
	CltGroup.CltGroupNM, ;
	CltGroup.CltGroupNote ;
FROM CltGroup ;
WHERE CltGroup.CltGroupID = ?_PARAM
***
DBSETPROP([lvCltGrpViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltGrpViewRepl],[VIEW],[COMMENT],[LV CLT: Обновление группы клиентов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Редактирование группы клиентов/*
PROCEDURE lvCltGrpEdit
***
CREATE SQL VIEW lvCltGrpEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltGroup.CltGroupID, ;
	CltGroup.CltGroupNM, ;
	CltGroup.CltGroupNote, ;
	CltGroup.Stamp_, ;
	CltGroup.User_ ;
FROM CltGroup ;
WHERE CltGroup.CltGroupID = ?_PARAM
***
DBSETPROP([lvCltGrpEdit.CltGroupID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCltGrpEdit.CltGroupID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCltGrpEdit.CltGroupNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltGrpEdit.CltGroupNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltGrpEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltGrpEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCltGrpEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCltGrpEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCltGrpEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltGrpEdit],[VIEW],[COMMENT],[LV CLT: Редактирование группы клиентов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Список схем факторинга/*
PROCEDURE lvFactSchView
***
CREATE SQL VIEW lvFactSchView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FSID, ;
	FSNM, ;
	FSAbbr, ;
	FSPerc, ;
	FSDays, ;
	FSNote, ;
	FSAttr ;
FROM FactSch
***
DBSETPROP([lvFactSchView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFactSchView],[VIEW],[COMMENT],[LV CLT: Список схем факторинга])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Обновление списока схем факторинга/*
PROCEDURE lvFactSchViewRepl
***
CREATE SQL VIEW lvFactSchViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FSID, ;
	FSNM, ;
	FSAbbr, ;
	FSPerc, ;
	FSDays, ;
	FSNote, ;
	FSAttr ;
FROM FactSch ;
WHERE FSID = ?_PARAM
***
DBSETPROP([lvFactSchViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFactSchViewRepl],[VIEW],[COMMENT],[LV CLT: Обновление списока схем факторинга])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Редактирование списка схем факторинга/*
PROCEDURE lvFactSchEdit
***
CREATE SQL VIEW lvFactSchEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FSID, ;
	FSNM, ;
	FSAbbr, ;
	FSPerc, ;
	FSDays, ;
	FSNote, ;
	FSAttr ;
FROM FactSch ;
WHERE FSID = ?_PARAM
***
DBSETPROP([lvFactSchEdit.FSID],[FIELD],[KeyField],.T.)
*** 
DBSETPROP([lvFactSchEdit.FSID],[FIELD],[Updatable],.F.)
DBSETPROP([lvFactSchEdit.FSNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvFactSchEdit.FSAbbr],[FIELD],[Updatable],.T.)
DBSETPROP([lvFactSchEdit.FSPerc],[FIELD],[Updatable],.T.)
DBSETPROP([lvFactSchEdit.FSDays],[FIELD],[Updatable],.T.)
DBSETPROP([lvFactSchEdit.FSNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvFactSchEdit.FSAttr],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvFactSchEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvFactSchEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvFactSchEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvFactSchEdit],[VIEW],[COMMENT],[LV CLT: Редактирование списка схем факторинга])
***
*------------------------------------------------------------------------------

*/LV CLT: Привязка клиентов к группе клиентов/*
PROCEDURE lvCltLinkGrpView
***
CREATE SQL VIEW lvCltLinkGrpView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltAltClass.CltAltClassID, ;
	CltGroup.CltGroupID, ;
	CltGroup.CltGroupNM ;
FROM CltAltClass ;
INNER JOIN CltGroup ON CltGroup.CltGroupID = CltAltClass.CltGroupID ;
WHERE CltAltClass.CltID = ?_PARAM
***
DBSETPROP([lvCltLinkGrpView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltLinkGrpView],[VIEW],[COMMENT],[LV CLT: Привязка клиентов к группе клиентов])
***
ENDPROC
***
*------------------------------------------------------------------------------

*/LV CLT: Обновление привязки клиентов к группе клиентов/*
PROCEDURE lvCltLinkGrpViewRepl
***
CREATE SQL VIEW lvCltLinkGrpViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltAltClass.CltAltClassID, ;
	CltGroup.CltGroupID, ;
	CltGroup.CltGroupNM ;
FROM CltAltClass ;
INNER JOIN CltGroup ON CltGroup.CltGroupID = CltAltClass.CltGroupID ;
WHERE CltAltClass.CltAltClassID = ?_PARAM
***
DBSETPROP([lvCltLinkGrpViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltLinkGrpViewRepl],[VIEW],[COMMENT],[LV CLT: Обновление привязки клиентов к группе клиентов])
***
ENDPROC
***
*------------------------------------------------------------------------------

*/LV CLT: Редактирование привязки клиентов к группе клиентов/*
PROCEDURE lvCltLinkGrpEdit
***
CREATE SQL VIEW lvCltLinkGrpEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltAltClass.CltAltClassID, ;
	CltAltClass.CltGroupID, ;
	CltAltClass.CltID ;
FROM CltAltClass ;
WHERE CltAltClass.CltAltClassID = ?_PARAM
***
DBSETPROP([lvCltLinkGrpEdit.CltAltClassID],[FIELD],[KeyField],.T.)
*** 
DBSETPROP([lvCltLinkGrpEdit.CltAltClassID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCltLinkGrpEdit.CltGroupID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltLinkGrpEdit.CltID],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCltLinkGrpEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCltLinkGrpEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCltLinkGrpEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltLinkGrpEdit],[VIEW],[COMMENT],[LV CLT: Редактирование привязки клиентов к группе клиентов])
***
ENDPROC
***
*------------------------------------------------------------------------------

PROCEDURE lvClpGrpExclList
***
CREATE SQL VIEW lvClpGrpExclList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltGroup.CltGroupID AS ID, ;
	CltGroup.CltGroupNM AS NM  ;
FROM CltGroup ;
WHERE CltGroup.CltGroupID NOT IN (SELECT CltAltClass.CltGroupID FROM CltAltClass WHERE CltAltClass.CltID = ?_PARAM)
***
DBSETPROP([lvClpGrpExclList],[VIEW],[FetchSize],-1)
***
ENDPROC
*------------------------------------------------------------------------------

PROCEDURE lvClpGrpIncList
***
CREATE SQL VIEW lvClpGrpIncList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltGroup.CltGroupID AS ID, ;
	CltGroup.CltGroupNM AS NM  ;
FROM CltGroup ;
WHERE CltGroup.CltGroupID IN (SELECT CltAltClass.CltGroupID FROM CltAltClass WHERE CltAltClass.CltID = ?_PARAM)
***
DBSETPROP([lvClpGrpIncList],[VIEW],[FetchSize],-1)
***
ENDPROC
*------------------------------------------------------------------------------