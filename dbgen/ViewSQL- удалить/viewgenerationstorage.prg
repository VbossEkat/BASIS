#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 17:25 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Продажи] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Продажи]
***
lvStorageView()
lvStorageEdit()
lvStorageDepartmentView()
lvStorageDepartmentEdit()
lvStorageByDep()
***
lvLoadServerList()
lvPriceList()
***
lvCashView()
lvCashViewRepl()
lvCashEdit()
lvCashierView()
lvCashierViewRepl()
lvCashierEdit()
lvCashList()
lvCashierList()
lvNotCashierList()
lvCashDepart()
lvCashierGroupView()
lvCashierGroupViewRepl()
lvCashierGroupEdit()
lvCashierGroupMemberView()
lvCashierGroupMemberEdit()
lvCashierGroupMemberViewRepl()
***
lvCheckEdit()
lvCheckViewRepl()
lvCheckType()
***
lvCheckTransView()
lvCheckTransViewRepl()
lvCheckTransEdit()
lvCheckTransType()
lvCheckTransMaxID()
lvCheckPaymentEdit()
lvCheckPaymentView()
***
lvSalesIDCCont()
lvNotEOD()
***
lvPosActivityView()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*03.08.2005 17:53 ->Справочник магазинов
*/LV STORAGE: Справочник магазинов/*
PROCEDURE lvStorageView
***
CREATE SQL VIEW lvStorageView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Storage.StorageID, ;
	Storage.StorageNo, ;
	ROUND(CONVERT(int,Storage.StorageNo),0) AS StorageNoInt, ;
	OrgUnit.OUNM AS StorageNM ;
FROM Storage ;
INNER JOIN OrgUnit ON OrgUnit.OUID = Storage.StorageID
***
DBSETPROP([lvStorageView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvStorageView],[VIEW],[COMMENT],[LV STORAGE: справочник магазинов (таблица Storage)])
***
ENDPROC
*------------------------------------------------------------------------------

*03.08.2005 17:58 ->Редактирование справочника магазинов
*/LV STORAGE: Редактирование справочника магазинов/*
PROCEDURE lvStorageEdit
***
CREATE SQL VIEW lvStorageEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Storage.StorageID, ;
	Storage.StorageNo, ;
	Storage.StoragePrcTypeID, ;
	Storage.StorageDeviceID, ;
	Storage.CashierGroupID ;
FROM Storage ;
WHERE Storage.StorageID = ?_PARAM
***
DBSETPROP([lvStorageEdit.StorageID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvStorageEdit.StorageID],[FIELD],[Updatable],.T.)
DBSETPROP([lvStorageEdit.StorageNo],[FIELD],[Updatable],.T.)
DBSETPROP([lvStorageEdit.StoragePrcTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvStorageEdit.StorageDeviceID],[FIELD],[Updatable],.T.)
DBSETPROP([lvStorageEdit.CashierGroupID],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvStorageEdit.StorageNo],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvStorageEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvStorageEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvStorageEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvStorageEdit],[VIEW],[COMMENT],[LV STORAGE: редактирование справочника магазинов (таблица Storage)])
***
ENDPROC
*------------------------------------------------------------------------------

*03.08.2005 18:02 ->Справочник отделов
*/LV STORAGE: Справочник отделов/*
PROCEDURE lvStorageDepartmentView
***
CREATE SQL VIEW lvStorageDepartmentView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	StorageDepartment.StorageDepartmentID, ;
	StorageDepartment.StorageDepartmentNo, ;
	ROUND(CONVERT(int,StorageDepartment.StorageDepartmentNo),0) AS DepartNo, ;
	OrgUnit.OUNM AS StorageDepartmentNM ;
FROM StorageDepartment ;
INNER JOIN OrgUnit ON OrgUnit.OUID = StorageDepartment.StorageDepartmentID ;
WHERE OrgUnit.OUParID = ?_PARAM
***
DBSETPROP([lvStorageDepartmentView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvStorageDepartmentView],[VIEW],[COMMENT],[LV STORAGE: справочник отделов магазина(таблица StorageDepartment)])
***
ENDPROC
*------------------------------------------------------------------------------

*03.08.2005 18:04 ->Редактирование справочника магазинов
*/LV STORAGE: Редактирование справочника магазинов/*
PROCEDURE lvStorageDepartmentEdit
***
CREATE SQL VIEW lvStorageDepartmentEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	StorageDepartment.StorageDepartmentID, ;
	StorageDepartment.StorageDepartmentNo ;
FROM StorageDepartment ;
WHERE StorageDepartment.StorageDepartmentID = ?_PARAM
***
DBSETPROP([lvStorageDepartmentEdit.StorageDepartmentID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvStorageDepartmentEdit.StorageDepartmentID],[FIELD],[Updatable],.T.)
DBSETPROP([lvStorageDepartmentEdit.StorageDepartmentNo],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvStorageDepartmentEdit.StorageDepartmentNo],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvStorageDepartmentEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvStorageDepartmentEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvStorageDepartmentEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvStorageDepartmentEdit],[VIEW],[COMMENT],[LV STORAGE: редактирование справочника магазинов (таблица StorageDepartment)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV STORAGE: Магазин по отделу/*
PROCEDURE lvStorageByDep
***
CREATE SQL VIEW lvStorageByDep REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Storage.StorageID, ;
	Storage.StorageNo, ;
	OrgUnit.OUNM AS StorageNM;
FROM Storage ;
INNER JOIN OrgUnit ON OrgUnit.OUParID = Storage.StorageID ;
WHERE OrgUnit.OUID = ?_PARAM
***
DBSETPROP([lvStorageByDep],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvStorageByDep],[VIEW],[COMMENT],[LV STORAGE: Магазин по отделу])
***
ENDPROC
*------------------------------------------------------------------------------

*03.08.2005 18:04 ->Список серверов загрузки
*/LV STORAGE: Список серверов загрузки/*
PROCEDURE lvLoadServerList
***
CREATE SQL VIEW lvLoadServerList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Device.DeviceID, ;
	Device.DeviceNM ;
FROM Device ;
INNER JOIN DeviceModel ON Device.DeviceModelID = DeviceModel.DeviceModelID ;
INNER JOIN DeviceType  ON DeviceModel.DeviceTypeID = DeviceType.DeviceTypeID AND DeviceType.DeviceTypeIsCnt = 0 ;
WHERE UPPER(DeviceModel.DeviceModelDescriptor) LIKE '%ASR%' ;
ORDER BY Device.DeviceNM 
***
DBSETPROP([lvLoadServerList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvLoadServerList],[VIEW],[COMMENT],[LV STORAGE: список серверов загрузки])
***
ENDPROC
*------------------------------------------------------------------------------

*04.08.2005 14:00 ->Справочник прайсов
*/LV CASH: Справочник прайсов
PROCEDURE lvPriceList
***
CREATE SQL VIEW lvPriceList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	PrcType.PrcTypeID, ;
	PrcType.PrcTypeNM ;
FROM PrcType ;
ORDER BY PrcType.PrcTypeNM
***
DBSETPROP([lvPriceList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPriceList],[VIEW],[COMMENT],[LV CASH: Справочник прайсов])
***
ENDPROC
*------------------------------------------------------------------------------

*29.07.2005 14:18 ->Справочник касс
*/LV CASH: справочник касс/*
PROCEDURE lvCashView
***
CREATE SQL VIEW lvCashView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Cash.CashID, ;
	Cash.CashNo, ;
	Cash.CashNM, ;
	ISNULL(OrgUnit.OUNM,'') AS CashStoragePlaceNM, ;
	Cash.CashIsActive ;
FROM Cash ;
LEFT JOIN OrgUnit ON Cash.CashStoragePlace = OrgUnit.OUID ;
WHERE Cash.CashStorageID = ?_PARAM ;
ORDER BY Cash.CashNo
***
DBSETPROP([lvCashView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashView],[VIEW],[COMMENT],[LV CAHS: справочник касс (таблица Cash)])
***
ENDPROC
*------------------------------------------------------------------------------

*29.07.2005 14:38 ->Обновления для справочника касс
*/LV CASH: Обновления для справочника касс/*
PROCEDURE lvCashViewRepl
***
CREATE SQL VIEW lvCashViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Cash.CashID, ;
	Cash.CashNo, ;
	Cash.CashNM, ;
	ISNULL(OrgUnit.OUNM,'') AS CashStoragePlaceNM, ;
	Cash.CashIsActive ;
FROM Cash ;
LEFT JOIN OrgUnit ON Cash.CashStoragePlace = OrgUnit.OUID ;
WHERE Cash.CashID = ?_PARAM
***
DBSETPROP([lvCashViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashViewRepl],[VIEW],[COMMENT],[LV CAHS: Обновления для справочника касс (таблица Cash)])
***
ENDPROC
*------------------------------------------------------------------------------

*29.07.2005 14:42 ->Редактирование справочника касс
*/LV CASH: Редактирование справочника касс*/
PROCEDURE lvCashEdit
***
CREATE SQL VIEW lvCashEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Cash.CashID, ;
	Cash.CashStorageID, ;
	Cash.CashNo, ;
	Cash.CashNM, ;
	Cash.CashStoragePlace, ;
	Cash.CashIsActive ;
FROM Cash ;
WHERE Cash.CashID = ?_PARAM
***
DBSETPROP([lvCashEdit.CashID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCashEdit.CashID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCashEdit.CashStorageID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCashEdit.CashNo],[FIELD],[Updatable],.T.)
DBSETPROP([lvCashEdit.CashNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCashEdit.CashStoragePlace],[FIELD],[Updatable],.T.)
DBSETPROP([lvCashEdit.CashIsActive],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCashEdit.CashNo],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCashEdit.CashNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCashEdit.CashIsActive],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvCashEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCashEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCashEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashEdit],[VIEW],[COMMENT],[LV CASH: Редактирование справочника касс (таблица Cash)])
***
ENDPROC
*------------------------------------------------------------------------------

*01.08.2005 16:13 ->Создание справочника касс
*/LV CASH: справочник касс/
PROCEDURE lvCashList
***
CREATE SQL VIEW lvCashList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Cash.CashID, ;
	Cash.CashNM ;
FROM Cash ;
ORDER BY Cash.CashNM
***
DBSETPROP([lvCashList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashList],[VIEW],[COMMENT],[LV CASH: Список касс (таблица Cashier)])
***
ENDPROC
*------------------------------------------------------------------------------

*01.08.2005 11:00 ->Справочник кассиров
*/LV CASHIER: справочник кассиров/*
PROCEDURE lvCashierView
***
CREATE SQL VIEW lvCashierView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Cashier.CashierID, ;
	Client.CltNM, ;
	Cashier.CashierNo, ;
	Cashier.CashierIsActive ;
FROM Cashier ;
INNER JOIN Client ON Cashier.CltID = Client.CltID ;
ORDER BY Client.CltNM
***
DBSETPROP([lvCashierView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashierView],[VIEW],[COMMENT],[LV CAHSIER: справочник кассиров (таблица Cashier)])
***
ENDPROC
*------------------------------------------------------------------------------

*01.08.2005 11:07 ->Обновления для справочника кассиров
*/LV CASH: Обновления для справочника кассиров/*
PROCEDURE lvCashierViewRepl
***
CREATE SQL VIEW lvCashierViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Cashier.CashierID, ;
	Client.CltNM, ;
	Cashier.CashierNo, ;
	Cashier.CashierIsActive ;
FROM Cashier ;
INNER JOIN Client ON Cashier.CltID = Client.CltID ;
WHERE Cashier.CashierID = ?_PARAM
***
DBSETPROP([lvCashierViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashierViewRepl],[VIEW],[COMMENT],[LV CAHSIER: Обновления для справочника кассиров (таблица Cashier)])
***
ENDPROC
*------------------------------------------------------------------------------

*01.08.2005 11:07 ->Редактирование справочника кассиров
*/LV CASH: Редактирование справочника кассиров*/
PROCEDURE lvCashierEdit
***
CREATE SQL VIEW lvCashierEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Cashier.CashierID, ;
	Cashier.CltID, ;
	Cashier.CashierNo, ;
	Cashier.CashierPassword, ;
	Cashier.CashierIsActive ;
FROM Cashier ;
WHERE Cashier.CashierID = ?_PARAM
***
DBSETPROP([lvCashierEdit.CashierID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCashierEdit.CashierID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCashierEdit.CltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCashierEdit.CashierNo],[FIELD],[Updatable],.T.)
DBSETPROP([lvCashierEdit.CashierPassword],[FIELD],[Updatable],.T.)
DBSETPROP([lvCashierEdit.CashierIsActive],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCashierEdit.CashierNo],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCashierEdit.CashierPassword],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCashierEdit.CashierIsActive],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvCashierEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCashierEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCashierEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashierEdit],[VIEW],[COMMENT],[LV CASHIER: Редактирование справочника кассиров (таблица Cashier)])
***
ENDPROC
*------------------------------------------------------------------------------

*01.08.2005 16:17 ->Создание справочника кассиров
*/LV CASH: справочник кассиров/
PROCEDURE lvCashierList
***
CREATE SQL VIEW lvCashierList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Cashier.CashierID, ;
	Client.CltNM AS CashierNM ;
FROM Cashier ;
INNER JOIN Client ON Cashier.CltID = Client.CltID ;
WHERE Cashier.CashierIsActive = 1 ;
ORDER BY Client.CltNM
***
DBSETPROP([lvCashierList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashierList],[VIEW],[COMMENT],[LV CASHIER: Список кассиров (таблица Cashier)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: Сотрудники - не кассиры/*
PROCEDURE lvNotCashierList
***
CREATE SQL VIEW lvNotCashierList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltID AS ID, ;
	CltNM AS NM ;
FROM Client ;
WHERE Client.CltTypeID = 4 AND (Client.CltID = ?_PARAM OR Client.CltID NOT IN (SELECT Cashier.CltID FROM Cashier)) ;
ORDER BY Client.CltNM
***
DBSETPROP([lvNotCashierList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvNotCashierList],[VIEW],[COMMENT],[LV CLT: Сотрудники - не кассиры])
***
ENDPROC
*------------------------------------------------------------------------------

*29.07.2005 15:55 ->Справочник отделов
*/LV CASH: Справочник отделов
PROCEDURE lvCashDepart
***
CREATE SQL VIEW lvCashDepart REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	OrgUnit.OUID, ;
	OrgUnit.OUNM ;
FROM OrgUnit ;
WHERE OrgUnit.Operate_ = 1 ;
ORDER BY OrgUnit.OUNM
***
DBSETPROP([lvCashDepart],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashDepart],[VIEW],[COMMENT],[LV CASH: Справочник отделов])
***
ENDPROC
*------------------------------------------------------------------------------

*08.09.2005 11:38 ->Справочник групп кассиров
*/LV CASH: Справочник групп кассиров/*
PROCEDURE lvCashierGroupView
***
CREATE SQL VIEW lvCashierGroupView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CashierGroup.CashierGroupID, ;
	CashierGroup.CashierGroupNM ;
FROM CashierGroup ;
ORDER BY CashierGroup.CashierGroupNM
***
DBSETPROP([lvCashierGroupView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashierGroupView],[VIEW],[COMMENT],[LV CASH: Справочник групп кассиров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: Обновления справочника групп кассиров/*
PROCEDURE lvCashierGroupViewRepl
***
CREATE SQL VIEW lvCashierGroupViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CashierGroup.CashierGroupID, ;
	CashierGroup.CashierGroupNM ;
FROM CashierGroup ;
WHERE CashierGroup.CashierGroupID = ?_PARAM
***
DBSETPROP([lvCashierGroupViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashierGroupViewRepl],[VIEW],[COMMENT],[LV CASH: Обновления справочника групп кассиров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: Редактирование справочника групп кассиров/*
PROCEDURE lvCashierGroupEdit
***
CREATE SQL VIEW lvCashierGroupEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CashierGroup.CashierGroupID, ;
	CashierGroup.CashierGroupNM ;
FROM CashierGroup ;
WHERE CashierGroup.CashierGroupID = ?_PARAM
***
DBSETPROP([lvCashierGroupEdit.CashierGroupID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCashierGroupEdit.CashierGroupID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCashierGroupEdit.CashierGroupNM],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCashierGroupEdit.CashierGroupNM],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvCashierGroupEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCashierGroupEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCashierGroupEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashierGroupEdit],[VIEW],[COMMENT],[LV CASH: Редактирование справочника групп кассиров])
***
ENDPROC
*------------------------------------------------------------------------------

*08.09.2005 11:39 ->Справочник членов групп кассиров
*/LV CASH: Справочник членов групп кассиров/*
PROCEDURE lvCashierGroupMemberView
***
CREATE VIEW lvCashierGroupMemberView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CashierMember.CashierMemberID, ;
	Client.CltNM AS CashierMemberNM ;
FROM CashierMember ;
INNER JOIN Cashier	ON Cashier.CashierID = CashierMember.CashierID ;
INNER JOIN Client	ON Client.CltID = Cashier.CltID ;
WHERE CashierMember.CashierGroupID = ?_PARAM ;
ORDER BY Client.CltNM
***
DBSETPROP([lvCashierGroupMemberView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashierGroupMemberView],[VIEW],[COMMENT],[LV CASH: Справочник членов групп кассиров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: Обновления справочника членов групп кассиров/*
PROCEDURE lvCashierGroupMemberViewRepl
***
CREATE VIEW lvCashierGroupMemberViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CashierMember.CashierMemberID, ;
	Client.CltNM AS CashierMemberNM ;
FROM CashierMember ;
INNER JOIN Cashier	ON Cashier.CashierID = CashierMember.CashierID ;
INNER JOIN Client	ON Client.CltID = Cashier.CltID ;
WHERE CashierMember.CashierMemberID = ?_PARAM
***
DBSETPROP([lvCashierGroupMemberViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashierGroupMemberViewRepl],[VIEW],[COMMENT],[LV CASH: Обновления справочника членов групп кассиров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: Редактирование справочника членов групп кассиров/*
PROCEDURE lvCashierGroupMemberEdit
***
CREATE SQL VIEW lvCashierGroupMemberEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CashierMember.CashierMemberID, ;
	CashierMember.CashierGroupID, ;
	CashierMember.CashierID ;
FROM CashierMember ;
WHERE CashierMember.CashierMemberID = ?_PARAM
***
DBSETPROP([lvCashierGroupMemberEdit.CashierMemberID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCashierGroupMemberEdit.CashierMemberID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCashierGroupMemberEdit.CashierGroupID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCashierGroupMemberEdit.CashierID ],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCashierGroupMemberEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCashierGroupMemberEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCashierGroupMemberEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCashierGroupMemberEdit],[VIEW],[COMMENT],[LV CASH: Редактирование справочника членов групп кассиров])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: Редактирование чеков/*
PROCEDURE lvCheckEdit
***
CREATE SQL VIEW lvCheckEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CheckSale.CheckID, ;
	CheckSale.CheckTypeID, ;
	CheckSale.CheckBranchNo, ;
	CheckSale.CheckNo, ;
	CheckSale.CheckCashID, ;
	CheckSale.CheckCashierID, ;
	CheckSale.CheckStamp, ;
	CheckSale.CheckDiscCardNo ;
FROM CheckSale ;
WHERE CheckSale.CheckID = ?_PARAM
***
DBSETPROP([lvCheckEdit.CheckID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCheckEdit.CheckID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCheckEdit.CheckTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckEdit.CheckBranchNo],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckEdit.CheckNo],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckEdit.CheckCashID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckEdit.CheckCashierID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckEdit.CheckStamp],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckEdit.CheckDiscCardNo],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCheckEdit.CheckBranchNo],[FIELD],[DefaultValue],[0])
DBSETPROP([lvCheckEdit.CheckNo],[FIELD],[DefaultValue],[0])
DBSETPROP([lvCheckEdit.CheckDiscCardNo],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvCheckEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCheckEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCheckEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCheckEdit],[VIEW],[COMMENT],[LV CASH: Редактирование чеков])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: Обновление чеков/*
PROCEDURE lvCheckViewRepl
***
CREATE SQL VIEW lvCheckViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CheckSale.CheckID, ;
	Storage.StorageID		AS BranchID, ;
	OrgUnit.OUNM			AS BranchNM, ;
	CheckType.CheckTypeNM	AS ChkTypeNM, ;
	CheckSale.CheckNo, ;
	Cash.CashNM, ;
	Client.CltNM			AS CashierNM, ;
	CheckSale.CheckStamp, ;
	CheckSale.CheckDiscCardNo	AS DiscCardNo ;
FROM CheckSale ;
INNER JOIN CheckType ON CheckType.CheckTypeID = CheckSale.CheckTypeID ;
INNER JOIN Storage	 ON CONVERT(int,Storage.StorageNo) = CheckSale.CheckBranchNo ;
INNER JOIN OrgUnit	 ON OrgUnit.OUID = Storage.StorageID ;
INNER JOIN Cash		 ON Cash.CashID = CheckSale.CheckCashID ;
INNER JOIN Cashier	 ON Cashier.CashierID = CheckSale.CheckCashierID ;
INNER JOIN Client	 ON Client.CltID = Cashier.CltID ; 
WHERE CheckSale.CheckID = ?_PARAM
***
DBSETPROP([lvCheckViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCheckViewRepl],[VIEW],[COMMENT],[LV CASH: Обновление чеков])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: Типы чеков/*
PROCEDURE lvCheckType
***
CREATE SQL VIEW lvCheckType REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CheckType.CheckTypeID, ;
	CheckType.CheckTypeNM, ;
	CheckType.CheckTypeAborted ;
FROM CheckType
***
DBSETPROP([lvCheckType],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCheckType],[VIEW],[COMMENT],[LV CASH: Типы чеков])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: Транзакции чека привязка кассы к подразделению/*
PROCEDURE lvCheckTransView
***
CREATE SQL VIEW lvCheckTransView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CheckTrans.CheckTransUID, ;
	CheckTrans.CheckTransID, ;
	CheckTransType.CheckTransType, ;
	CheckTransType.CheckTransTypeSign, ;
	OrgUnit.OUNM AS DepartNM, ;
	CheckTrans.CheckTransTvrID, ;
	ISNULL(Tovar.TvrNM,'') AS TvrNM, ;
	CheckTrans.CheckTransPLU, ;
	CheckTrans.CheckTransQnt, ;
	CheckTrans.CheckTransPrc, ;
	CAST(0 AS bit) AS Mark ;
FROM CheckTrans ;
INNER JOIN CheckTransType	 ON CheckTransType.CheckTransTypeID = CheckTrans.CheckTransTypeID ;
INNER JOIN CheckSale		 ON CheckSale.CheckID = CheckTrans.CheckID ;
INNER JOIN Cash				 ON Cash.CashID = CheckSale.CheckCashID ;
INNER JOIN OrgUnit			 ON OrgUnit.OUID = Cash.CashStoragePlace ;
LEFT  JOIN Tovar			 ON Tovar.TvrID = CheckTrans.CheckTransTvrID ; 
WHERE CheckTrans.CheckID = ?_PARAM
***
DBSETPROP([lvCheckTransView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCheckTransView],[VIEW],[COMMENT],[LV CASH: Транзакции чека])
***
ENDPROC
*------------------------------------------------------------------------------

*!*	*/LV CASH: Транзакции чека/*
*!*	PROCEDURE lvCheckTransView
*!*	***
*!*	CREATE SQL VIEW lvCheckTransView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
*!*	SELECT ;
*!*		CheckTrans.CheckTransUID, ;
*!*		CheckTrans.CheckTransID, ;
*!*		CheckTransType.CheckTransType, ;
*!*		CheckTransType.CheckTransTypeSign, ;
*!*		OrgUnit.OUNM AS DepartNM, ;
*!*		CheckTrans.CheckTransTvrID, ;
*!*		ISNULL(Tovar.TvrNM,'') AS TvrNM, ;
*!*		CheckTrans.CheckTransPLU, ;
*!*		CheckTrans.CheckTransQnt, ;
*!*		CheckTrans.CheckTransPrc, ;
*!*		CAST(0 AS bit) AS Mark ;
*!*	FROM CheckTrans ;
*!*	INNER JOIN CheckTransType	 ON CheckTransType.CheckTransTypeID = CheckTrans.CheckTransTypeID ;
*!*	INNER JOIN StorageDepartment ON CONVERT(int,StorageDepartment.StorageDepartmentNo) = CheckTrans.CheckTransDepartNo ;
*!*	INNER JOIN OrgUnit			 ON OrgUnit.OUID = StorageDepartment.StorageDepartmentID ;
*!*	LEFT  JOIN Tovar			 ON Tovar.TvrID = CheckTrans.CheckTransTvrID ; 
*!*	WHERE CheckTrans.CheckID = ?_PARAM
*!*	***
*!*	DBSETPROP([lvCheckTransView],[VIEW],[FetchSize],-1)
*!*	***
*!*	DBSETPROP([lvCheckTransView],[VIEW],[COMMENT],[LV CASH: Транзакции чека])
*!*	***
*!*	ENDPROC
*!*	*------------------------------------------------------------------------------

*/LV CASH: Обновление lvCheckTransView привязка товара к кассе/*
PROCEDURE lvCheckTransViewRepl
***
CREATE SQL VIEW lvCheckTransViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CheckTrans.CheckTransUID, ;
	CheckTrans.CheckTransID, ;
	CheckTransType.CheckTransType, ;
	CheckTransType.CheckTransTypeSign, ;
	OrgUnit.OUNM AS DepartNM, ;
	CheckTrans.CheckTransTvrID, ;
	ISNULL(Tovar.TvrNM,'') AS TvrNM, ;
	CheckTrans.CheckTransPLU, ;
	CheckTrans.CheckTransQnt, ;
	CheckTrans.CheckTransPrc ;
FROM CheckTrans ;
INNER JOIN CheckTransType	 ON CheckTransType.CheckTransTypeID = CheckTrans.CheckTransTypeID ;
INNER JOIN CheckSale		 ON CheckSale.CheckID = CheckTrans.CheckID ;
INNER JOIN Cash				 ON Cash.CashID = CheckSale.CheckCashID ;
INNER JOIN OrgUnit			 ON OrgUnit.OUID = Cash.CashStoragePlace ;
LEFT  JOIN Tovar			 ON Tovar.TvrID = CheckTrans.CheckTransTvrID ; 
WHERE CheckTrans.CheckTransUID = ?_PARAM
***
DBSETPROP([lvCheckTransViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCheckTransViewRepl],[VIEW],[COMMENT],[LV CASH: Обновление lvCheckTransView])
***
ENDPROC
*------------------------------------------------------------------------------

*!*	*/LV CASH: Обновление lvCheckTransView/*
*!*	PROCEDURE lvCheckTransViewRepl
*!*	***
*!*	CREATE SQL VIEW lvCheckTransViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
*!*	SELECT ;
*!*		CheckTrans.CheckTransUID, ;
*!*		CheckTrans.CheckTransID, ;
*!*		CheckTransType.CheckTransType, ;
*!*		CheckTransType.CheckTransTypeSign, ;
*!*		OrgUnit.OUNM AS DepartNM, ;
*!*		CheckTrans.CheckTransTvrID, ;
*!*		ISNULL(Tovar.TvrNM,'') AS TvrNM, ;
*!*		CheckTrans.CheckTransPLU, ;
*!*		CheckTrans.CheckTransQnt, ;
*!*		CheckTrans.CheckTransPrc ;
*!*	FROM CheckTrans ;
*!*	INNER JOIN CheckTransType	 ON CheckTransType.CheckTransTypeID = CheckTrans.CheckTransTypeID ;
*!*	INNER JOIN StorageDepartment ON CONVERT(int,StorageDepartment.StorageDepartmentNo) = CheckTrans.CheckTransDepartNo ;
*!*	INNER JOIN OrgUnit			 ON OrgUnit.OUID = StorageDepartment.StorageDepartmentID ;
*!*	LEFT  JOIN Tovar			 ON Tovar.TvrID = CheckTrans.CheckTransTvrID ; 
*!*	WHERE CheckTrans.CheckTransUID = ?_PARAM
*!*	***
*!*	DBSETPROP([lvCheckTransViewRepl],[VIEW],[FetchSize],-1)
*!*	***
*!*	DBSETPROP([lvCheckTransViewRepl],[VIEW],[COMMENT],[LV CASH: Обновление lvCheckTransView])
*!*	***
*!*	ENDPROC
*!*	*------------------------------------------------------------------------------

*/LV CASH: Редактирование таблицы Check/*
PROCEDURE lvCheckTransEdit
***
CREATE SQL VIEW lvCheckTransEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CheckTrans.CheckID, ;
	CheckTrans.CheckTransUID, ;
	CheckTrans.CheckTransID, ;
	CheckTrans.CheckTransTypeID, ;
	CheckTrans.CheckTransDepartNo, ;
	CheckTrans.CheckTransTvrID, ;
	CheckTrans.CheckTransPLU, ;
	CheckTrans.CheckTransQnt, ;
	CheckTrans.CheckTransPrc ;
FROM CheckTrans ;
WHERE CheckTrans.CheckTransUID = ?_PARAM
***
DBSETPROP([lvCheckTransEdit.CheckTransUID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCheckTransEdit.CheckTransUID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCheckTransEdit.CheckTransID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckTransEdit.CheckTransTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckTransEdit.CheckTransDepartNo],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckTransEdit.CheckTransTvrID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckTransEdit.CheckTransPLU],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckTransEdit.CheckTransQnt],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckTransEdit.CheckTransPrc],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCheckTransEdit.CheckTransDepartNo],[FIELD],[DefaultValue],[0])
DBSETPROP([lvCheckTransEdit.CheckTransPLU],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCheckTransEdit.CheckTransQnt],[FIELD],[DefaultValue],[0])
DBSETPROP([lvCheckTransEdit.CheckTransPrc],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvCheckTransEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCheckTransEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCheckTransEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCheckTransEdit],[VIEW],[COMMENT],[LV CASH: Редактирование таблицы Check])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: Типы транзакций чеков/*
PROCEDURE lvCheckTransType
***
CREATE SQL VIEW lvCheckTransType REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CheckTransType.CheckTransTypeID, ;
	CheckTransType.CheckTransType ;
FROM CheckTransType
***
DBSETPROP([lvCheckTransType],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCheckTransType],[VIEW],[COMMENT],[LV CASH: Типы транзакций чеков])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: Максимальный ID транзакции чека*/
PROCEDURE lvCheckTransMaxID
***
CREATE SQL VIEW lvCheckTransMaxID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	MAX(CheckTrans.CheckTransID) AS CheckTransID ;
FROM CheckTrans ;
WHERE CheckTrans.CheckID = ?_PARAM
***
DBSETPROP([lvCheckTransMaxID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCheckTransMaxID],[VIEW],[COMMENT],[LV CASH: Максимальный ID транзакции чека])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: Оплаты по чеку/*
PROCEDURE lvCheckPaymentEdit
***
CREATE VIEW lvCheckPaymentEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CheckPayment.CheckPaymentID, ;
	CheckPayment.CheckPaymentTypeID, ;
	CheckPayment.CheckID, ;
	CheckPayment.CheckPaymentPANNo, ;
	CheckPayment.CheckPaymentQnt, ;
	CheckPayment.CheckPaymentPrcSum, ;
	CheckPayment.CouponID ;
FROM CheckPayment
***
DBSETPROP([lvCheckPaymentEdit.CheckPaymentID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCheckPaymentEdit.CheckPaymentID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCheckPaymentEdit.CheckPaymentTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckPaymentEdit.CheckID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckPaymentEdit.CheckPaymentPANNo],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckPaymentEdit.CheckPaymentQnt],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckPaymentEdit.CheckPaymentPrcSum ],[FIELD],[Updatable],.T.)
DBSETPROP([lvCheckPaymentEdit.CouponID],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCheckPaymentEdit.CheckPaymentPANNo],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCheckPaymentEdit.CheckPaymentQnt],[FIELD],[DefaultValue],[0])
DBSETPROP([lvCheckPaymentEdit.CheckPaymentPrcSum],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvCheckPaymentEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCheckPaymentEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCheckPaymentEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCheckPaymentEdit],[VIEW],[COMMENT],[LV CASH: Оплаты по чеку])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: Оплатa по чеку/*
PROCEDURE lvCheckPaymentView
***
CREATE VIEW lvCheckPaymentView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CheckPayment.CheckPaymentID, ;
	CheckPayment.CheckPaymentTypeID, ;
	CheckPayment.CheckID, ;
	CheckPayment.CheckPaymentPANNo, ;
	CheckPayment.CheckPaymentQnt, ;
	CheckPayment.CheckPaymentPrcSum ;
FROM CheckPayment ;
WHERE CheckPayment.CheckPaymentID = ?_PARAM
***
DBSETPROP([lvCheckPaymentView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCheckPaymentView],[VIEW],[COMMENT],[LV CASH: Оплата по чеку])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: IDC и JRN файлы/*
PROCEDURE lvSalesIDCCont
***
CREATE SQL VIEW lvSalesIDCCont REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	SalesLog.IDC, ;
	SalesLog.IDCFileSize, ;
	SalesLog.JRN, ;
	SalesLog.JRNFileSize ;
FROM SalesLog ;
WHERE SalesLog.SalesLogID = ?_PARAM
***
DBSETPROP([lvSalesIDCCont.IDC],[FIELD],[DataType],[M])
DBSETPROP([lvSalesIDCCont.JRN],[FIELD],[DataType],[M])
***
DBSETPROP([lvSalesIDCCont],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvSalesIDCCont],[VIEW],[COMMENT],[LV CASH: IDC и JRN файлы])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: не закрытые дни/*
PROCEDURE lvNotEod
***
CREATE SQL VIEW lvNotEod REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	SalesLog.SalesLogID, ;
	SalesLog.StampOpenDay ;
FROM SalesLog ;
WHERE SalesLog.EOD = 0
***
DBSETPROP([lvNotEod],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvNotEod],[VIEW],[COMMENT],[LV CASH: не закрытые дни])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CASH: просмотр не закрытых касс/*
PROCEDURE lvPosActivityView
***
CREATE SQL VIEW lvPosActivityView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	PosActivity.PosActID, ;
	SalesLog.StampOpenDay, ;
	Cash.CashNo, ;
	Cash.CashNM, ;
	PosActivity.PosActOpenStamp, ;
	CAST(CASE WHEN PosActivity.PosActCloseStamp IS NULL THEN 0 ELSE 1 END AS bit) AS EOD ;
FROM PosActivity ;
INNER JOIN Cash ON Cash.CashID = PosActivity.PosActCID ;
INNER JOIN SalesLog ON SalesLog.SalesLogID = PosActivity.PosActSLID ;
WHERE PosActivity.PosActCloseStamp IS NULL
***
DBSETPROP([lvPosActivityView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvPosActivityView],[VIEW],[COMMENT],[LV CASH: просмотр не закрытых касс])
***
ENDPROC
*------------------------------------------------------------------------------
