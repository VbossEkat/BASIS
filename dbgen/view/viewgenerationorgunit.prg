#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 17:13 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Организационные единицы] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Организационные единицы]
***
lvOUCntTreeView()
lvOUCntTreeViewRepl()
lvOUInCntView()
lvOUInCntViewRepl()
lvOrgUnitEdit()
lvOUTypeList()
lvOUBmps()
lvOUTypeMgrInfo()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV OrgUnit: дерево организационных единиц/*
PROCEDURE lvOUCntTreeView
***
CREATE SQL VIEW lvOUCntTreeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	OrgUnit.OUID, ;
	ISNULL(OrgUnit.OUParID,0) AS OUParID, ;
	OrgUnit.OUNM, ;
	CAST(1 AS bit) AS OUIsCnt, ;
	103 AS BmpID, ;
	104 AS SelBmpID ;
FROM OrgUnit
***
DBSETPROP([lvOUCntTreeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOUCntTreeView],[VIEW],[COMMENT],[LV OrgUnit: дерево организационных единиц])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV OrgUnit: обновления для lvOUCntTreeView/*
PROCEDURE lvOUCntTreeViewRepl
***
CREATE SQL VIEW lvOUCntTreeViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	OrgUnit.OUID, ;
	ISNULL(OrgUnit.OUParID,0) AS OUParID, ;
	OrgUnit.OUNM, ;
	CAST(1 AS bit) AS OUIsCnt, ;
	103 AS BmpID, ;
	104 AS SelBmpID ;
FROM OrgUnit ;
WHERE OrgUnit.OUID = ?_PARAM
***
DBSETPROP([lvOUCntTreeViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOUCntTreeViewRepl],[VIEW],[COMMENT],[LV OrgUnit: обновления для lvOUCntTreeView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV OrgUnit: содержание группы организационных единиц/*
PROCEDURE lvOUInCntView
***
CREATE SQL VIEW lvOUInCntView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	OrgUnit.OUID, ;
	OrgUnit.OUNM, ;
	ISNULL(OrgUnit.OUParID,0) AS OUParID, ;
	103 AS BmpId ;
FROM OrgUnit ;
WHERE ISNULL(OrgUnit.OUParID,0) = ?_PARAM ;
ORDER BY 2
***
DBSETPROP([lvOUInCntView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOUInCntView],[VIEW],[COMMENT],[LV OrgUnit: содержание группы организационных единиц])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV OrgUnit: обновления для lvOUInCntView/*
PROCEDURE lvOUInCntViewRepl
***
CREATE SQL VIEW lvOUInCntViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	OrgUnit.OUID, ;
	OrgUnit.OUNM, ;
	ISNULL(OrgUnit.OUParID,0) AS OUParID, ;
	103 AS BmpId ;
FROM OrgUnit ;
WHERE OrgUnit.OUID = ?_PARAM
***
DBSETPROP([lvOUInCntViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOUInCntViewRepl],[VIEW],[COMMENT],[LV OrgUnit: обновления для lvOUInCntView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV OrgUnit: редактирование таблицы OrgUnit*/
PROCEDURE lvOrgUnitEdit
***
CREATE SQL VIEW lvOrgUnitEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	OrgUnit.OUID, ;
	OrgUnit.OUTypeID, ;
	OrgUnit.OUParID, ;
	OrgUnit.CltID, ;
	OrgUnit.CltMRespID, ;
	OrgUnit.OUNM, ;
	OrgUnit.OUNote, ;
	OrgUnit.OrgUnitStockAccType, ;
	OrgUnit.OrgUnitAllowNegativeStock, ;
	OrgUnit.Operate_, ;
	OrgUnit.Stamp_, ;
	OrgUnit.User_ ;
FROM OrgUnit ;
WHERE OrgUnit.OUID = ?_PARAM
***
DBSETPROP([lvOrgUnitEdit.OUID],[FIELD],[KeyField],.T.)
DBSETPROP([lvOrgUnitEdit.OUID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvOrgUnitEdit.OUTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrgUnitEdit.OUParID],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrgUnitEdit.CltID],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrgUnitEdit.CltMRespID],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrgUnitEdit.OUNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrgUnitEdit.OUNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrgUnitEdit.OrgUnitStockAccType],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrgUnitEdit.OrgUnitAllowNegativeStock],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrgUnitEdit.Operate_],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrgUnitEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvOrgUnitEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvOrgUnitEdit.OUNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvOrgUnitEdit.OUNote],[FIELD],[DefaultValue],[""])
DBSETPROP([lvOrgUnitEdit.OrgUnitStockAccType],[FIELD],[DefaultValue],[0])
DBSETPROP([lvOrgUnitEdit.OrgUnitAllowNegativeStock],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvOrgUnitEdit.Operate_],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvOrgUnitEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvOrgUnitEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvOrgUnitEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOrgUnitEdit],[VIEW],[COMMENT],[LV OrgUnit: редактирование таблицы OrgUnit])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV OrgUnit: список типов организационных единиц/*
PROCEDURE lvOUTypeList
***
CREATE SQL VIEW lvOUTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	OUType.OUTypeID, ;
	OUType.OUTypeNM ;
FROM OUType ;
ORDER BY OUType.OUTypeNM
***
DBSETPROP([lvOUTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOUTypeList],[VIEW],[COMMENT],[LV OrgUnit: список типов организационных единиц])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV OrgUnit: список используемых картинок/*
PROCEDURE lvOUBmps
***
CREATE SQL VIEW lvOUBmps REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Bitmaps.BmpId, ;
	Bitmaps.BmpFileNM ;
FROM Bitmaps ;
WHERE Bitmaps.BmpId IN (103,104)
***
DBSETPROP([lvOUBmps],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOUBmps],[VIEW],[COMMENT],[LV OrgUnit: список используемых картинок])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV OrgUnit: дескриптор типа ОУ/*
PROCEDURE lvOUTypeMgrInfo
***
CREATE SQL VIEW lvOUTypeMgrInfo REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	OUType.OUTypeObjDesc ;
FROM OUType ;
INNER JOIN OrgUnit ON OrgUnit.OUTypeID = OUType.OUTypeID ;
WHERE OrgUnit.OUID = ?_PARAM
***
DBSETPROP([lvOUTypeMgrInfo],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvOUTypeMgrInfo],[VIEW],[COMMENT],[LV OrgUnit: дескриптор типа ОЕ])
***
ENDPROC
*------------------------------------------------------------------------------
