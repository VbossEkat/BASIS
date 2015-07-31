#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*******************************************************************************
* Представления для получения данных о параметрах фильтра, используются при 
* инициализации объекта фильтра 
*******************************************************************************
WAIT WINDOW [Генерация представлений для ПО: Параметры выборки] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Параметры выборки]
***
lvQryParByQryParId()
lvQryParIdCtlPropByQryParId()
lvQryParSelCtlPropByQryParId()
lvQryParCheckPropByQryParId()
lvQryParTXTPropByQryParId()
lvQryParIdCtlTreePropByQryParId()
lvQryParEdit()
lvQryParIdCtlPropEdit()
lvQryParSelCtlPropEdit()
lvQryParCheckPropEdit()
lvQryParTxtPropEdit()
lvQryParIdCtlTreePropEdit()
lvQryParListByScrFrm()
lvQryParListByRpt()
lvQryParBmps()
lvQryParTypeTreeView()
lvQryParByQryTypeId()
lvQryParTypeList()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV QryPar: Общие параметры фильтра/*
PROCEDURE lvQryParByQryParId
***
CREATE SQL VIEW lvQryParByQryParId REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QueryParam.QryParID, ;
	QueryParam.QryParTypeID, ;
	QueryParam.QryParNM, ;
	QueryParam.QryParObjCaption, ;
	QueryParam.QryParIsRequired, ;
	QueryParam.QryParVarNMEnabled, ;
	QueryParam.QryParVarNMValue, ;
	QueryParam.QryParVarNMValue2 ;
FROM QueryParam ;
WHERE QueryParam.QryParID = ?_PARAM
***
DBSETPROP([lvQryParByQryParId],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParByQryParId],[VIEW],[COMMENT],[LV QryPar: Общие параметры фильтра])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QryPar: Параметры фильтра cntQPIdCtlGrid/*
PROCEDURE lvQryParIdCtlPropByQryParID
***
CREATE SQL VIEW lvQryParIdCtlPropByQryParID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QryParIdCtlProp.QryParID, ;
	QryParIdCtlProp.RSAliasNM, ;
	QryParIdCtlProp.RSAliasParamPropName, ;
	QryParIdCtlProp.RSFieldNMID, ;
	QryParIdCtlProp.RSFieldNMText, ;
	QryParIdCtlProp.ShowTextEmpty, ;
	QryParIdCtlProp.ShowTextNotFound, ;
	QryParIdCtlProp.SelectObject ;
FROM QryParIdCtlProp ;
WHERE QryParIdCtlProp.QryParID = ?_PARAM
***
DBSETPROP([lvQryParIdCtlPropByQryParID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParIdCtlPropByQryParID],[VIEW],[COMMENT],[LV QryPar: Параметры фильтра cntQPIdCtlGrid])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QryPar: Параметры фильтра cntQPSelCtlGrid/*
PROCEDURE lvQryParSelCtlPropByQryParID
***
CREATE SQL VIEW lvQryParSelCtlPropByQryParID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QryParSelCtlProp.QryParID, ;
	QryParSelCtlProp.RSAliasNM, ;
	QryParSelCtlProp.RSAliasParamPropName, ;
	QryParSelCtlProp.RSFieldNMID, ;
	QryParSelCtlProp.RSFieldNMText, ;
	QryParSelCtlProp.ShowTextEmpty, ;
	QryParSelCtlProp.ShowTextNotFound, ;
	QryParSelCtlProp.SelectObject, ;
	QryParSelCtlProp.SelectAllByDefault ;
FROM QryParSelCtlProp ;
WHERE QryParSelCtlProp.QryParID = ?_PARAM
***
DBSETPROP([lvQryParSelCtlPropByQryParID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParSelCtlPropByQryParID],[VIEW],[COMMENT],[LV QryPar: Параметры фильтра cntQPSelCtlGrid])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QryPar: Параметры фильтра cntQPCheck/*
PROCEDURE lvQryParCheckPropByQryParID
***
CREATE SQL VIEW lvQryParCheckPropByQryParID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QryParCheckProp.QryParID, ;
	QryParCheckProp.Caption, ;
	QryParCheckProp.TextChange, ;
	QryParCheckProp.TextChecked, ;
	QryParCheckProp.TextUnChecked ;
FROM QryParCheckProp ;
WHERE QryParCheckProp.QryParID = ?_PARAM
***
DBSETPROP([lvQryParCheckPropByQryParID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParCheckPropByQryParID],[VIEW],[COMMENT],[LV QryPar: Параметры фильтра cntQPCheck])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QryPar: Параметры фильтра cntQPTXT/*
PROCEDURE lvQryParTXTPropByQryParID
***
CREATE SQL VIEW lvQryParTXTPropByQryParID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QryParTXTProp.QryParID, ;
	QryParTXTProp.Type, ;
	QryParTXTProp.Width, ;
	QryParTXTProp.Decimal ;
FROM QryParTXTProp ;
WHERE QryParTXTProp.QryParID = ?_PARAM
***
DBSETPROP([lvQryParTXTPropByQryParID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParTXTPropByQryParID],[VIEW],[COMMENT],[LV QryPar: Параметры фильтра cntQPTXT])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QryPar: Параметры фильтра cntQPIdCtlTree/*
PROCEDURE lvQryParIdCtlTreePropByQryParID
***
CREATE SQL VIEW lvQryParIdCtlTreePropByQryParID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QryParIdCtlTreeProp.QryParID, ;
	QryParIdCtlTreeProp.RSAliasNM, ;
	QryParIdCtlTreeProp.RSAliasParamPropName, ;
	QryParIdCtlTreeProp.RSFieldNMID, ;
	QryParIdCtlTreeProp.RSFieldNMParentID, ;
	QryParIdCtlTreeProp.RSFieldNMParentFlag, ;
	QryParIdCtlTreeProp.RSFieldNMText, ;
	QryParIdCtlTreeProp.RSFieldNMImageIndex, ;
	QryParIdCtlTreeProp.RSFieldNMImageSelectedIndex, ;
	QryParIdCtlTreeProp.ParentOnly, ;
	QryParIdCtlTreeProp.ShowTextEmpty, ;
	QryParIdCtlTreeProp.ShowTextNotFound, ;
	QryParIdCtlTreeProp.SelectObject ;
FROM QryParIdCtlTreeProp ;
WHERE QryParIdCtlTreeProp.QryParID = ?_PARAM
***
DBSETPROP([lvQryParIdCtlTreePropByQryParID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParIdCtlTreePropByQryParID],[VIEW],[COMMENT],[LV QryPar: Параметры фильтра cntQPIdCtlTree])
***
ENDPROC
*------------------------------------------------------------------------------

*******************************************************************************
* Представления для редактирования данных о параметрах фильтра
*******************************************************************************

*/LV QryPar: Редактирование общих параметров фильтра/*
PROCEDURE lvQryParEdit
***
CREATE SQL VIEW lvQryParEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QueryParam.QryParID, ;
	QueryParam.QryParTypeID, ;
	QueryParam.QryParNM, ;
	QueryParam.QryParNote, ;
	QueryParam.QryParObjCaption, ;
	QueryParam.QryParIsRequired, ;
	QueryParam.QryParVarNMEnabled, ;
	QueryParam.QryParVarNMValue, ;
	QueryParam.QryParVarNMValue2, ;
	QueryParam.Stamp_, ;
	QueryParam.User_ ;
FROM QueryParam ;
WHERE QueryParam.QryParID = ?_PARAM 
***
DBSETPROP([lvQryParEdit.QryParID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvQryParEdit.QryParID],[FIELD],[Updatable],.F.)
DBSETPROP([lvQryParEdit.QryParTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParEdit.QryParNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParEdit.QryParNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParEdit.QryParObjCaption],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParEdit.QryParIsRequired],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParEdit.QryParVarNMEnabled],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParEdit.QryParVarNMValue],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParEdit.QryParVarNMValue2],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvQryParEdit.QryParNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParEdit.QryParNote],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParEdit.QryParObjCaption],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParEdit.QryParIsRequired],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvQryParEdit.QryParVarNMEnabled],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParEdit.QryParVarNMValue],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParEdit.QryParVarNMValue2],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvQryParEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvQryParEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvQryParEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParEdit],[VIEW],[COMMENT],[LV QryPar: Редактирование общих параметров фильтра])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QryPar: Редактирование параметров фильтра cntQPIdCtlGrid/*
PROCEDURE lvQryParIdCtlPropEdit
***
CREATE SQL VIEW lvQryParIdCtlPropEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QryParIdCtlProp.QryParID, ;
	QryParIdCtlProp.RSAliasNM, ;
	QryParIdCtlProp.RSAliasParamPropName, ;
	QryParIdCtlProp.RSFieldNMID, ;
	QryParIdCtlProp.RSFieldNMText, ;
	QryParIdCtlProp.ShowTextEmpty, ;
	QryParIdCtlProp.ShowTextNotFound, ;
	QryParIdCtlProp.SelectObject, ;
	QryParIdCtlProp.Stamp_, ;
	QryParIdCtlProp.User_ ;
FROM QryParIdCtlProp ;
WHERE QryParIdCtlProp.QryParID = ?_PARAM
***
DBSETPROP([lvQryParIdCtlPropEdit.QryParID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvQryParIdCtlPropEdit.QryParID],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIdCtlPropEdit.RSAliasNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIdCtlPropEdit.RSAliasParamPropName],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIdCtlPropEdit.RSFieldNMID],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIdCtlPropEdit.RSFieldNMText],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIdCtlPropEdit.ShowTextEmpty],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIdCtlPropEdit.ShowTextNotFound],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIdCtlPropEdit.SelectObject],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIdCtlPropEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIdCtlPropEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvQryParIdCtlPropEdit.RSAliasNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIdCtlPropEdit.RSAliasParamPropName],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIdCtlPropEdit.RSFieldNMID],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIdCtlPropEdit.RSFieldNMText],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIdCtlPropEdit.ShowTextEmpty],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIdCtlPropEdit.ShowTextNotFound],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIdCtlPropEdit.SelectObject],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvQryParIdCtlPropEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvQryParIdCtlPropEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvQryParIdCtlPropEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParIdCtlPropEdit],[VIEW],[COMMENT],[LV QryPar: Редактирование параметров фильтра cntQPIdCtlGrid])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QryPar: Редактирование параметров фильтра cntQPSelCtlGrid/*
PROCEDURE lvQryParSelCtlPropEdit
***
CREATE SQL VIEW lvQryParSelCtlPropEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QryParSelCtlProp.QryParID, ;
	QryParSelCtlProp.RSAliasNM, ;
	QryParSelCtlProp.RSAliasParamPropName, ;
	QryParSelCtlProp.RSFieldNMID, ;
	QryParSelCtlProp.RSFieldNMText, ;
	QryParSelCtlProp.ShowTextEmpty, ;
	QryParSelCtlProp.ShowTextNotFound, ;
	QryParSelCtlProp.SelectObject, ;
	QryParSelCtlProp.SelectAllByDefault, ;
	QryParSelCtlProp.Stamp_, ;
	QryParSelCtlProp.User_ ;
FROM QryParSelCtlProp ;
WHERE QryParSelCtlProp.QryParID = ?_PARAM
***
DBSETPROP([lvQryParSelCtlPropEdit.QryParID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvQryParSelCtlPropEdit.QryParID],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParSelCtlPropEdit.RSAliasNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParSelCtlPropEdit.RSAliasParamPropName],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParSelCtlPropEdit.RSFieldNMID],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParSelCtlPropEdit.RSFieldNMText],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParSelCtlPropEdit.ShowTextEmpty],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParSelCtlPropEdit.ShowTextNotFound],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParSelCtlPropEdit.SelectObject],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParSelCtlPropEdit.SelectAllByDefault],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParSelCtlPropEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParSelCtlPropEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvQryParSelCtlPropEdit.RSAliasNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParSelCtlPropEdit.RSAliasParamPropName],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParSelCtlPropEdit.RSFieldNMID],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParSelCtlPropEdit.RSFieldNMText],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParSelCtlPropEdit.ShowTextEmpty],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParSelCtlPropEdit.ShowTextNotFound],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParSelCtlPropEdit.SelectObject],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParSelCtlPropEdit.SelectAllByDefault],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvQryParSelCtlPropEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvQryParSelCtlPropEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvQryParSelCtlPropEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParSelCtlPropEdit],[VIEW],[COMMENT],[LV QryPar: Редактирование параметров фильтра cntQPSelCtlGrid])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QryPar: Редактирование параметров фильтра cntQPCheck/*
PROCEDURE lvQryParCheckPropEdit
***
CREATE SQL VIEW lvQryParCheckPropEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QryParCheckProp.QryParID, ;
	QryParCheckProp.Caption, ;
	QryParCheckProp.TextChange, ;
	QryParCheckProp.TextChecked, ;
	QryParCheckProp.TextUnChecked, ;
	QryParCheckProp.Stamp_, ;
	QryParCheckProp.User_ ;
FROM QryParCheckProp ;
WHERE QryParCheckProp.QryParID = ?_PARAM
***
DBSETPROP([lvQryParCheckPropEdit.QryParID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvQryParCheckPropEdit.QryParID],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParCheckPropEdit.Caption],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParCheckPropEdit.TextChange],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParCheckPropEdit.TextChecked],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParCheckPropEdit.TextUnChecked],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParCheckPropEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParCheckPropEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvQryParCheckPropEdit.Caption],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParCheckPropEdit.TextChange],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvQryParCheckPropEdit.TextChecked],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParCheckPropEdit.TextUnChecked],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvQryParCheckPropEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvQryParCheckPropEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvQryParCheckPropEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParCheckPropEdit],[VIEW],[COMMENT],[LV QryPar: Редактирование параметров фильтра cntQPCheck])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QryPar: Редактирование параметров фильтра cntQPTxt/*
PROCEDURE lvQryParTxtPropEdit
***
CREATE SQL VIEW lvQryParTxtPropEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QryParTXTProp.QryParID, ;
	QryParTXTProp.Type, ;
	QryParTXTProp.Width, ;
	QryParTXTProp.Decimal ;
FROM QryParTXTProp ;
WHERE QryParTXTProp.QryParID = ?_PARAM
***
DBSETPROP([lvQryParTxtPropEdit.QryParID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvQryParTxtPropEdit.QryParID],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParTxtPropEdit.Type],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParTxtPropEdit.Width],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParTxtPropEdit.Decimal],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvQryParTxtPropEdit.Type],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParTxtPropEdit.Width],[FIELD],[DefaultValue],[0])
DBSETPROP([lvQryParTxtPropEdit.Decimal],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvQryParTxtPropEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvQryParTxtPropEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvQryParTxtPropEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParTxtPropEdit],[VIEW],[COMMENT],[LV QryPar: Редактирование параметров фильтра cntQPTxt])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QryPar: Редактирование параметров фильтра cntQPIdCtlTree/*
PROCEDURE lvQryParIdCtlTreePropEdit
***
CREATE SQL VIEW lvQryParIdCtlTreePropEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QryParIdCtlTreeProp.QryParID, ;
	QryParIdCtlTreeProp.RSAliasNM, ;
	QryParIdCtlTreeProp.RSAliasParamPropName, ;
	QryParIdCtlTreeProp.RSFieldNMID, ;
	QryParIdCtlTreeProp.RSFieldNMParentID, ;
	QryParIdCtlTreeProp.RSFieldNMParentFlag, ;
	QryParIdCtlTreeProp.RSFieldNMText, ;
	QryParIdCtlTreeProp.RSFieldNMImageIndex, ;
	QryParIdCtlTreeProp.RSFieldNMImageSelectedIndex, ;
	QryParIdCtlTreeProp.ParentOnly, ;
	QryParIdCtlTreeProp.ShowTextEmpty, ;
	QryParIdCtlTreeProp.ShowTextNotFound, ;
	QryParIdCtlTreeProp.SelectObject, ;
	QryParIdCtlTreeProp.Stamp_, ;
	QryParIdCtlTreeProp.User_ ;
FROM QryParIDCtlTreeProp ;
WHERE QryParIDCtlTreeProp.QryParID = ?_PARAM
***
DBSETPROP([lvQryParIDCtlTreePropEdit.QryParID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvQryParIDCtlTreePropEdit.QryParID],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit.RSAliasNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit.RSAliasParamPropName],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit.RSFieldNMID],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit.RSFieldNMParentID],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit.RSFieldNMParentFlag],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit.RSFieldNMText],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit.RSFieldNMImageIndex],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit.RSFieldNMImageSelectedIndex],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit.ParentOnly],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit.ShowTextEmpty],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit.ShowTextNotFound],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit.SelectObject],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvQryParIDCtlTreePropEdit.RSAliasNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIDCtlTreePropEdit.RSAliasParamPropName],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIDCtlTreePropEdit.RSFieldNMID],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIDCtlTreePropEdit.RSFieldNMParentID],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIDCtlTreePropEdit.RSFieldNMParentFlag],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIDCtlTreePropEdit.RSFieldNMText],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIDCtlTreePropEdit.RSFieldNMImageIndex],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIDCtlTreePropEdit.RSFieldNMImageSelectedIndex],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIDCtlTreePropEdit.ParentOnly],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvQryParIDCtlTreePropEdit.ShowTextEmpty],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIDCtlTreePropEdit.ShowTextNotFound],[FIELD],[DefaultValue],[""])
DBSETPROP([lvQryParIDCtlTreePropEdit.SelectObject],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvQryParIDCtlTreePropEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvQryParIDCtlTreePropEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvQryParIDCtlTreePropEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParIDCtlTreePropEdit],[VIEW],[COMMENT],[LV QryPar: Редактирование параметров фильтра cntQPIdCtlTree])
***
ENDPROC
*------------------------------------------------------------------------------

*******************************************************************************
* Представления для получения списка фильтров, привязанных к экранной форме или
* отчету
*******************************************************************************

*/LV QryPar: Список фильтров, привязанных к экранной форме/*
PROCEDURE lvQryParListByScrFrm
***
CREATE SQL VIEW lvQryParListByScrFrm REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScrFrmQryPar.QryParID, ;
	QryParType.QryParTypeObjDesc, ;
	ScrFrmQryPar.ScrFrmQryParIndex ;
FROM ScrFrmQryPar ;
INNER JOIN QueryParam ON QueryParam.QryParID     = ScrFrmQryPar.QryParID ;
INNER JOIN QryParType ON QryParType.QryParTypeID = QueryParam.QryParTypeID ;
WHERE ScrFrmQryPar.ScrFrmID = ?_PARAM ;
ORDER BY 3
***
DBSETPROP([lvQryParListByScrFrm],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParListByScrFrm],[VIEW],[COMMENT],[LV QryPar: Список фильтров, привязанных к экранной форме])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QryPar: Список фильтров, привязанных к отчету/*
PROCEDURE lvQryParListByRpt
***
CREATE SQL VIEW lvQryParListByRpt REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	RptQryPar.QryParID, ;
	QryParType.QryParTypeObjDesc, ;
	RptQryPar.RptQryParIndex ;
FROM RptQryPar ;
INNER JOIN QueryParam ON QueryParam.QryParID     = RptQryPar.QryParID ;
INNER JOIN QryParType ON QryParType.QryParTypeID = QueryParam.QryParTypeID ;
WHERE RptQryPar.RptID = ?_PARAM ;
ORDER BY 3
***
DBSETPROP([lvQryParListByRpt],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParListByRpt],[VIEW],[COMMENT],[LV QryPar: Список фильтров, привязанных к отчету])
***
ENDPROC
*------------------------------------------------------------------------------

*******************************************************************************
* Представления для справочника параметров выборки
*******************************************************************************

*/LV QryPar: картинки для параметров выборки/*
PROCEDURE lvQryParBmps
***
CREATE SQL VIEW lvQryParBmps REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Bitmaps.BmpId, ;
	Bitmaps.BmpFileNM ;
FROM Bitmaps ;
WHERE	(Bitmaps.BmpId IN (SELECT QryParType.BmpID FROM QryParType)) OR ;
		(Bitmaps.BmpId IN (SELECT QryParType.SelBmpID FROM QryParType))
***
DBSETPROP([lvQryParBmps],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParBmps],[VIEW],[COMMENT],[LV QryPar: картинки для параметров выборки])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QryPar: список типов параметров выборки в формате, необходимом для построения дерева/*
PROCEDURE lvQryParTypeTreeView
***
CREATE SQL VIEW lvQryParTypeTreeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QryParType.QryParTypeID, ;
	0 AS QryParTypeParentID, ;
	CAST(1 AS bit) AS QryParTypeIsCnt, ;
	QryParType.QryParTypeNM, ;
	QryParType.BmpID, ;
	QryParType.SelBmpID ;
FROM QryParType ;
ORDER BY 4
***
DBSETPROP([lvQryParTypeTreeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParTypeTreeView],[VIEW],[COMMENT],[LV QryPar: список типов параметров выборки в формате, необходимом для построения дерева])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV QryPar: список фильтров одного типа/*
PROCEDURE lvQryParByQryTypeId
***
CREATE SQL VIEW lvQryParByQryTypeId REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QueryParam.QryParID, ;
	QueryParam.QryParTypeID, ;
	QueryParam.QryParNM, ;
	QryParType.BmpID ;
FROM QueryParam ;
INNER JOIN QryParType ON QryParType.QryParTypeId = QueryParam.QryParTypeId ;
WHERE QueryParam.QryParTypeID = ?_PARAM ;
ORDER BY 3
***
DBSETPROP([lvQryParByQryTypeId],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParByQryTypeId],[VIEW],[COMMENT],[LV QryPar: список фильтров одного типа])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: список типов фильтров/*
PROCEDURE lvQryParTypeList
***
CREATE SQL VIEW lvQryParTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QryParTypeID, ;
	QryParTypeNM ;
FROM QryParType ;
ORDER BY QryParType.QryParTypeNM
***
DBSETPROP([lvQryParTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvQryParTypeList],[VIEW],[COMMENT],[LV RPT: список типов фильтров])
***
ENDPROC
*------------------------------------------------------------------------------

*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************