#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 17:28 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Идентификаторы товаров] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Идентификаторы товаров]
***
lvTovarLookUpByTLU()
lvTovarLookUpByID()
lvTLUTypeByID()
lvTLUEdit()
lvTLUTypeList()
***
lvTLUInStorageDepartView()
lvTLUInStorageDepartRepl()
lvTLUInStorageDepartEdit()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV TLU: индентификатор товара по идентификатору товара/*
PROCEDURE lvTovarLookUpByTLU
***
CREATE SQL VIEW lvTovarLookUpByTLU REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ; 
SELECT ;
	TvrLookUp.TLUId, ;
	TvrLookUp.TLUTypeId, ;
	Tovar.TvrID, ;
	TvrLookUp.TvrQnt, ;
	TvrLookUp.TLU, ;
	TvrLookUp.TLUComment, ;
	TvrLookUp.TLUIsMain ;
FROM Tovar ;
LEFT JOIN TvrLookUp ON TvrLookUp.TvrID = Tovar.TvrID ;
WHERE TvrLookUp.TLU = ?_PARAM OR Tovar.TvrID = dbo.TLU2ID(?_PARAM)
***
DBSETPROP([lvTovarLookUpByTLU],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTovarLookUpByTLU],[VIEW],[COMMENT],[LV TLU: индентификатор товара по идентификатору товара])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TLU: TLU товара по идентификатору/*
PROCEDURE lvTovarLookUpByID
***
CREATE SQL VIEW lvTovarLookUpByID REMOTE CONNECTION SqlBasisConnection AS ;
SELECT ;
	TvrLookup.TLUID, ;
	TvrLookup.TLUTypeID, ;
	TvrLookup.TLU, ;
	TvrLookup.TLUComment, ;
	TvrLookup.TLUIsMain, ;
	TvrLookup.TvrID, ;
	TvrLookup.TvrQnt ;
FROM TvrLookup ;
WHERE TvrLookup.TvrID = ?_PARAM
***
DBSETPROP([lvTovarLookUpByID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTovarLookUpByID],[VIEW],[COMMENT],[LV TLU: TLU товара по идентификатору])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TLU: тип идентификатора товара по идентификатору/*
PROCEDURE lvTLUTypeByID
***
CREATE SQL VIEW lvTLUTypeByID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ; 
SELECT ;
	TLUType.TLUTypeID, ;
	TLUType.TLUTypeNM, ;
	TLUType.TLUTypeIsGenerate, ;
	TLUType.TLUTypeMask, ;
	TLUType.IsDefault ;
FROM TLUType ;
WHERE TLUType.TLUTypeID = ?_PARAM
***
DBSETPROP([lvTLUTypeByID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTLUTypeByID],[VIEW],[COMMENT],[LV TLU: тип идентификатора товара по идентификатору])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TLU: редактирование штрих-кодов товара/*
PROCEDURE lvTLUEdit
***
CREATE SQL VIEW lvTLUEdit REMOTE CONNECTION SqlBasisConnection AS ;
SELECT ;
	TvrLookUp.TLUId, ;
	TvrLookUp.TLUTypeId, ;
	TvrLookUp.TvrId, ;
	TvrLookUp.TvrQnt, ;	
	TvrLookUp.TLU, ;
	TvrLookUp.TLUComment, ;
	TvrLookUp.TLUIsMain, ;
	TvrLookUp.Stamp_, ;
	TvrLookUp.User_ ;
FROM TvrLookUp ;
WHERE TvrLookUp.TLUID = ?_PARAM 
***
DBSETPROP([lvTLUEdit.TLUId],[FIELD],[KeyField],.T.)
DBSETPROP([lvTLUEdit.TLUId],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvTLUEdit.TLUTypeId],[FIELD],[Updatable],.T.)
DBSETPROP([lvTLUEdit.TvrId],[FIELD],[Updatable],.T.)
DBSETPROP([lvTLUEdit.TvrQnt],[FIELD],[Updatable],.T.)
DBSETPROP([lvTLUEdit.TLU],[FIELD],[Updatable],.T.)
DBSETPROP([lvTLUEdit.TLUComment],[FIELD],[Updatable],.T.)
DBSETPROP([lvTLUEdit.TLUIsMain],[FIELD],[Updatable],.T.)
DBSETPROP([lvTLUEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvTLUEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTLUEdit.TvrQnt],[FIELD],[DefaultValue],[1])
DBSETPROP([lvTLUEdit.TLU],[FIELD],[DefaultValue],[""])
DBSETPROP([lvTLUEdit.TLUComment],[FIELD],[DefaultValue],[""])
DBSETPROP([lvTLUEdit.TLUIsMain],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvTLUEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvTLUEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvTLUEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTLUEdit],[VIEW],[COMMENT],[LV TLU: редактирование штрих-кодов товара])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TLU: список типов идентификаторов/*
PROCEDURE lvTLUTypeList
***
CREATE SQL VIEW lvTLUTypeList REMOTE CONNECTION SqlBasisConnection AS ;
SELECT ;
	TLUType.TLUTypeID, ;
	TLUType.TLUTypeNM, ;
	TLUType.TLUTypeIsGenerate, ;
	TLUType.TLUTypeMask, ;
	TLUType.IsDefault ;
FROM TLUType ;
ORDER BY TLUType.TLUTypeNM
***
DBSETPROP([lvTLUTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTLUTypeList],[VIEW],[COMMENT],[LV TLU: список типов идентификаторов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TLU: TLU в отделах магазина/*
PROCEDURE lvTLUInStorageDepartView
***
CREATE SQL VIEW lvTLUInStorageDepartView REMOTE CONNECTION SqlBasisConnection AS ;
SELECT ;
	TluInDpt.TluInDptId, ;
	Storage.OUNM AS StorageNM, ;
	StorageDepartment.OUNM AS StorageDepartmentNM ;
FROM TluInDpt ;
INNER JOIN OrgUnit StorageDepartment ON StorageDepartment.OUID = TluInDpt.TluInDptStorageDepartmentID ;
INNER JOIN OrgUnit Storage ON Storage.OUID = StorageDepartment.OUParID ;
WHERE TluInDpt.TluInDptTLUId = ?_PARAM
***
DBSETPROP([lvTLUInStorageDepartView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTLUInStorageDepartView],[VIEW],[COMMENT],[LV TLU: TLU в отделах магазина])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TLU: обновление TLU в отделах магазина/*
PROCEDURE lvTLUInStorageDepartRepl
***
CREATE SQL VIEW lvTLUInStorageDepartRepl REMOTE CONNECTION SqlBasisConnection AS ;
SELECT ;
	TluInDpt.TluInDptId, ;
	Storage.OUNM AS StorageNM, ;
	StorageDepartment.OUNM AS StorageDepartmentNM ;
FROM TluInDpt ;
INNER JOIN OrgUnit StorageDepartment ON StorageDepartment.OUID = TluInDpt.TluInDptStorageDepartmentID ;
INNER JOIN OrgUnit Storage ON Storage.OUID = StorageDepartment.OUParID ;
WHERE TluInDpt.TluInDptId = ?_PARAM
***
DBSETPROP([lvTLUInStorageDepartRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTLUInStorageDepartRepl],[VIEW],[COMMENT],[LV TLU: обновление TLU в отделах магазина])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV TLU: редактирование TLU в отделах магазина/*
PROCEDURE lvTLUInStorageDepartEdit
***
CREATE SQL VIEW lvTLUInStorageDepartEdit REMOTE CONNECTION SqlBasisConnection AS ;
SELECT ;
	TluInDpt.TluInDptID, ;
	TluInDpt.TluInDptStorageDepartmentID, ;
	TluInDpt.TluInDptTLUId, ;
	TluInDpt.Stamp_, ;
	TluInDpt.User_ ;
FROM TluInDpt ;
WHERE TluInDpt.TluInDptId = ?_PARAM
***
DBSETPROP([lvTLUInStorageDepartEdit.TluInDptID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvTLUInStorageDepartEdit.TluInDptStorageDepartmentID],[FIELD],[Updatable],.T.)
DBSETPROP([lvTLUInStorageDepartEdit.TluInDptTLUId],[FIELD],[Updatable],.T.)
DBSETPROP([lvTLUInStorageDepartEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvTLUInStorageDepartEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTLUInStorageDepartEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvTLUInStorageDepartEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvTLUInStorageDepartEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTLUInStorageDepartEdit],[VIEW],[COMMENT],[LV TLU: редактирование TLU в отделах магазина])
***
ENDPROC
*------------------------------------------------------------------------------