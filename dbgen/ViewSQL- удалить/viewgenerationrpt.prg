#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 17:19 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Отчеты] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Отчеты]
***
lvRptBmps()
lvRptFormByReport()
lvRptFormInfo()
lvRptEdit()
lvRptFormEdit()
lvRptTreeView()
lvRptTreeViewIsVisible()
lvRptTreeViewByScrFrm()
lvRptTreeViewByFrm()
lvRptCntTreeView()
lvRptCntTreeViewRepl()
lvRptInCntView()
lvRptInCntViewRepl()
lvRptFormView()
lvRptQryParView()
lvRptQryParEdit()
lvRptQryParIndexEdit()
lvRptQryParList()
lvRptTypeList()
lvRptTypeInfoMgr()
lvRptFrmTemplateList()
lvRptFrmTemplate()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV RPT: список используемых картинок для типов отчетов/*
PROCEDURE lvRptBmps
***
CREATE SQL VIEW lvRptBmps REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Bitmaps.BmpId, ;
	Bitmaps.BmpFileNM ;
FROM Bitmaps ;
WHERE	(Bitmaps.BmpId IN (SELECT RptType.BmpId FROM RptType)) OR ;
		(Bitmaps.BmpId IN (SELECT RptType.SelBmpId FROM RptType))
***
DBSETPROP([lvRptBmps],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptBmps],[VIEW],[COMMENT],[LV RPT: список используемых картинок для типов отчетов.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: формы отчетов (печатные представления) для отчета/*
PROCEDURE lvRptFormByReport
***
CREATE SQL VIEW lvRptFormByReport REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	RptForm.RptFrmID, ;
	RptForm.RptFrmNM ;
FROM RptForm ;
WHERE RptForm.RptID = ?_PARAM
***
DBSETPROP([lvRptFormByReport],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptFormByReport],[VIEW],[COMMENT],[LV RPT: формы отчетов (печатные представления) для отчета.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: информация о печатной форме (с MEMO полями)/*
PROCEDURE lvRptFormInfo	
***
CREATE SQL VIEW lvRptFormInfo REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	RptForm.RptFrmID, ;
	RptForm.RptFrmNM, ;
	RptForm.RptFrmNote, ;
	RptForm.RptFrmIsModify, ;
	RptForm.RptFrmSavePrnEnv, ;
	RptForm.RptFrmFRX, ;
	RptForm.RptFrmFRT, ;
	Report.RptQueryNM, ;
	Report.RptQueryType ;
FROM RptForm ;
INNER JOIN Report ON Report.RptID = RptForm.RptID ;
WHERE RptForm.RptFrmID = ?_PARAM
***
DBSETPROP([lvRptFormInfo.RptFrmFRX],[FIELD],[DataType],[M])
DBSETPROP([lvRptFormInfo.RptFrmFRT],[FIELD],[DataType],[M])
***
DBSETPROP([lvRptFormInfo],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptFormInfo],[VIEW],[COMMENT],[LV RPT: информация о печатной форме (с MEMO полями).])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: редактирование отчета/группы/*
PROCEDURE lvRptEdit
***
CREATE SQL VIEW lvRptEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	RptID, ;
	RptTypeID, ;
	RptParID, ;
	RptNM, ;
	RptNote, ;
	RptIsVisible, ;
	RptQueryNM, ;
	RptQueryType, ;
	Stamp_, ;
	User_ ;
FROM Report ;
WHERE Report.RptID = ?_PARAM 
***
DBSETPROP([lvRptEdit.RptID],[FIELD],[KeyField],.T.)
DBSETPROP([lvRptEdit.RptID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvRptEdit.RptTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptEdit.RptParID],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptEdit.RptNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptEdit.RptNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptEdit.RptIsVisible],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptEdit.RptQueryNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptEdit.RptQueryType],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvRptEdit.RptTypeID],[FIELD],[DefaultValue],[2])
DBSETPROP([lvRptEdit.RptNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvRptEdit.RptNote],[FIELD],[DefaultValue],[""])
DBSETPROP([lvRptEdit.RptIsVisible],[FIELD],[DefaultValue],[.T.])
DBSETPROP([lvRptEdit.RptQueryNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvRptEdit.RptQueryType],[FIELD],[DefaultValue],[0])
***
DBSETPROP([lvRptEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvRptEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvRptEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptEdit],[VIEW],[COMMENT],[LV RPT: редактирование отчета/группы])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: редактирование формы отчетов (печатных представлений)/*
PROCEDURE lvRptFormEdit
***
CREATE SQL VIEW lvRptFormEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	RptForm.RptFrmID, ;
	RptForm.RptID, ;
	RptForm.RptFrmNM, ;
	RptForm.RptFrmNote, ;
	RptForm.RptFrmIsModify, ;
	RptForm.RptFrmSavePrnEnv, ;
	RptForm.RptFrmFRX, ;
	RptForm.RptFrmFRT, ;
	RptForm.Stamp_, ;
	RptForm.User_ ;
FROM RptForm ;
WHERE RptForm.RptFrmID = ?_PARAM
***
DBSETPROP([lvRptFormEdit.RptFrmID],[FIELD],[KeyField],.T.)
DBSETPROP([lvRptFormEdit.RptFrmID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvRptFormEdit.RptID],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptFormEdit.RptFrmNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptFormEdit.RptFrmNote],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptFormEdit.RptFrmIsModify],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptFormEdit.RptFrmSavePrnEnv],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptFormEdit.RptFrmFRX],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptFormEdit.RptFrmFRT],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptFormEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptFormEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvRptFormEdit.RptFrmFRX],[FIELD],[DataType],[M])
DBSETPROP([lvRptFormEdit.RptFrmFRT],[FIELD],[DataType],[M])
DBSETPROP([lvRptFormEdit.RptFrmNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvRptFormEdit.RptFrmNote],[FIELD],[DefaultValue],[""])
DBSETPROP([lvRptFormEdit.RptFrmIsModify],[FIELD],[DefaultValue],[.T.])
DBSETPROP([lvRptFormEdit.RptFrmSavePrnEnv],[FIELD],[DefaultValue],[.F.])
DBSETPROP([lvRptFormEdit.RptFrmFRX],[FIELD],[DefaultValue],[""])
DBSETPROP([lvRptFormEdit.RptFrmFRT],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvRptFormEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvRptFormEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvRptFormEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptFormEdit],[VIEW],[COMMENT],[LV RPT: редактирование формы отчетов (печатных представлений).])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: дерево отчетов (группы + отчеты)/*
PROCEDURE lvRptTreeView
***
CREATE SQL VIEW lvRptTreeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Report.RptID, ;
	ISNULL(Report.RptParID,0) AS RptParID, ;
	Report.RptNM, ;
	RptType.RptTypeIsCnt AS RptIsCnt, ;
	RptType.BmpId AS BmpId, ;
	RptType.SelBmpId AS SelBmpId, ;
	CAST(0 AS bit) AS IsDefault ;
FROM Report ;
INNER JOIN RptType ON Report.RptTypeID = RptType.RptTypeID ;
WHERE ; 
	Report.RptIsVisible = 1 AND ;
	Report.RptID IN ( ;																&& Проверка прав
		SELECT UserGrant.ObjectID FROM UserGrant ;									&& Проверка прав
		INNER JOIN ObjectType ON ObjectType.ObjectTypeID = UserGrant.ObjectTypeID ;	&& Проверка прав
		WHERE ;																		&& Проверка прав
			UPPER(ObjectType.TableNM) = 'REPORT' AND ;								&& Проверка прав
			UserGrant.UserID = ?_USER_ID) ;											&& Проверка прав
ORDER BY 4 DESC, 3 ASC
&& Определяем есть ли права на отчет у пользователя (метка "Проверка прав"): 
&& 1. Внимание! Переменную _USER_ID необходимо инициализировать перед открытием данного RV 
&& 2. Права пользователя на отчет определяются по наличию объекта данного типа ("Отчет") в таблице прав пользователя 
***
DBSETPROP([lvRptTreeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptTreeView],[VIEW],[COMMENT],[LV RPT: дерево отчетов (группы + отчеты)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: дерево отчетов (группы + отчеты) видимые/*
PROCEDURE lvRptTreeViewIsVisible
***
#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION
***
CREATE SQL VIEW lvRptTreeViewIsVisible REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Report.RptID, ;
	ISNULL(Report.RptParID,0) AS RptParID, ;
	Report.RptNM, ;
	RptType.RptTypeIsCnt AS RptIsCnt, ;
	RptType.BmpId AS BmpId, ;
	RptType.SelBmpId AS SelBmpId, ;
	CAST(0 AS bit) AS IsDefault ;
FROM Report ;
INNER JOIN RptType ON Report.RptTypeID = RptType.RptTypeID ;
WHERE Report.IsVisible = 1 ;
ORDER BY 4 DESC, 3 ASC
***
DBSETPROP([lvRptTreeViewIsVisible],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptTreeViewIsVisible],[VIEW],[COMMENT],[LV RPT: дерево отчетов (группы + отчеты) видимые])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: дерево отчетов (группы + отчеты) для экранной формы/*
PROCEDURE lvRptTreeViewByScrFrm
***
CREATE SQL VIEW lvRptTreeViewByScrFrm REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Report.RptID, ;
	ISNULL(Report.RptParID,0) AS RptParID, ;
	Report.RptNM, ;
	RptType.RptTypeIsCnt AS RptIsCnt, ;
	RptType.BmpId AS BmpId, ;
	RptType.SelBmpId AS SelBmpId, ;
	ISNULL(ScrFrmReport.IsDefault,0) AS IsDefault ;
FROM Report ;
INNER JOIN RptType ON Report.RptTypeID = RptType.RptTypeID ;
LEFT JOIN ScrFrmReport ON Report.RptID = ScrFrmReport.RptID ;
WHERE ;
	(RptType.RptTypeIsCnt = 1 OR (NOT ScrFrmReport.ScrFrmID IS NULL AND ScrFrmReport.ScrFrmID = ?_PARAM)) AND ;
	Report.RptID IN ( ;																&& Проверка прав
		SELECT UserGrant.ObjectID FROM UserGrant ;									&& Проверка прав
		INNER JOIN ObjectType ON ObjectType.ObjectTypeID = UserGrant.ObjectTypeID ;	&& Проверка прав
		WHERE ;																		&& Проверка прав
			UPPER(ObjectType.TableNM) = 'REPORT' AND ;								&& Проверка прав
			UserGrant.UserID = ?_USER_ID) ;											&& Проверка прав
ORDER BY 4 DESC, 3 ASC
&& Определяем есть ли права на отчет у пользователя (метка "Проверка прав"): 
&& 1. Внимание! Переменную _USER_ID необходимо инициализировать перед открытием данного RV 
&& 2. Права пользователя на отчет определяются по наличию объекта данного типа ("Отчет") в таблице прав пользователя 
***
DBSETPROP([lvRptTreeViewByScrFrm],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptTreeViewByScrFrm],[VIEW],[COMMENT],[LV RPT: дерево отчетов (группы + отчеты) для экранной формы])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: дерево отчетов (группы + отчеты) для документа/*
PROCEDURE lvRptTreeViewByFrm
***
CREATE SQL VIEW lvRptTreeViewByFrm REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Report.RptID, ;
	ISNULL(Report.RptParID,0) AS RptParID, ;
	Report.RptNM, ;
	RptType.RptTypeIsCnt AS RptIsCnt, ;
	RptType.BmpId AS BmpId, ;
	RptType.SelBmpId AS SelBmpId, ;
	~RptType.RptTypeIsCnt AS IsDefault ;
FROM Report ;
INNER JOIN RptType ON Report.RptTypeID = RptType.RptTypeID ;
WHERE ;
	(RptType.RptTypeIsCnt = 1 OR ;
	Report.RptID IN ( ;
		SELECT ;
			FrmType.RptID ;
 		FROM FrmType ;
 		INNER JOIN Form ON Form.FrmTypeID = FrmType.FrmTypeID ;
		WHERE Form.FrmID = ?_PARAM)) AND ;
	Report.RptID IN ( ;																&& Проверка прав
		SELECT UserGrant.ObjectID FROM UserGrant ;									&& Проверка прав
		INNER JOIN ObjectType ON ObjectType.ObjectTypeID = UserGrant.ObjectTypeID ;	&& Проверка прав
		WHERE ;																		&& Проверка прав
			UPPER(ObjectType.TableNM) = 'REPORT' AND ;								&& Проверка прав
			UserGrant.UserID = ?_USER_ID) ;											&& Проверка прав
ORDER BY 4 DESC, 3 ASC
&& Определяем есть ли права на отчет у пользователя (метка "Проверка прав"): 
&& 1. Внимание! Переменную _USER_ID необходимо инициализировать перед открытием данного RV 
&& 2. Права пользователя на отчет определяются по наличию объекта данного типа ("Отчет") в таблице прав пользователя 
***
DBSETPROP([lvRptTreeViewByFrm],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptTreeViewByFrm],[VIEW],[COMMENT],[LV RPT: дерево отчетов (группы + отчеты) для документа])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: дерево отчетов (группы)/*
PROCEDURE lvRptCntTreeView
***
CREATE SQL VIEW lvRptCntTreeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Report.RptID, ;
	ISNULL(Report.RptParID,0) AS RptParID, ;
	Report.RptNM, ;
	RptType.RptTypeIsCnt AS RptIsCnt, ;
	RptType.BmpId AS BmpId, ;
	RptType.SelBmpId AS SelBmpId ;
FROM Report ;
INNER JOIN RptType ON Report.RptTypeID = RptType.RptTypeID ;
WHERE RptType.RptTypeIsCnt = 1 ;
ORDER BY 3 ASC
***
DBSETPROP([lvRptCntTreeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptCntTreeView],[VIEW],[COMMENT],[LV RPT: дерево отчетов (группы)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: обновление для lvRptCntTreeView/*
PROCEDURE lvRptCntTreeViewRepl
***
CREATE SQL VIEW lvRptCntTreeViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Report.RptID, ;
	ISNULL(Report.RptParID,0) AS RptParID, ;
	Report.RptNM, ;
	RptType.RptTypeIsCnt AS RptIsCnt, ;
	RptType.BmpId AS BmpId, ;
	RptType.SelBmpId AS SelBmpId ;
FROM Report ;
INNER JOIN RptType ON Report.RptTypeID = RptType.RptTypeID ;
WHERE Report.RptID = ?_PARAM
***
DBSETPROP([lvRptCntTreeViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptCntTreeViewRepl],[VIEW],[COMMENT],[LV RPT: обновление для lvRptCntTreeView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: содержание группы отчетов/*
PROCEDURE lvRptInCntView
***
CREATE SQL VIEW lvRptInCntView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Report.RptID, ;
	Report.RptNM, ;
	ISNULL(Report.RptParID,0) AS RptParID, ;
	RptType.RptTypeIsCnt, ;
	RptType.BmpId AS BmpId ;
FROM Report ;
INNER JOIN RptType ON Report.RptTypeID = RptType.RptTypeID ;
WHERE ISNULL(Report.RptParID,0) = ?_PARAM ;
ORDER BY 4 DESC,2
***
DBSETPROP([lvRptInCntView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptInCntView],[VIEW],[COMMENT],[LV RPT: содержание группы отчетов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: обновление для lvRptInCntView/*
PROCEDURE lvRptInCntViewRepl
***
CREATE SQL VIEW lvRptInCntViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Report.RptID, ;
	Report.RptNM, ;
	ISNULL(Report.RptParID,0) AS RptParID, ;
	RptType.RptTypeIsCnt, ;
	RptType.BmpId AS BmpId ;
FROM Report ;
INNER JOIN RptType ON Report.RptTypeID = RptType.RptTypeID ;
WHERE Report.RptID = ?_PARAM
***
DBSETPROP([lvRptInCntViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptInCntViewRepl],[VIEW],[COMMENT],[LV RPT: обновление для lvRptInCntView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: список доступных печатных форм для отчета/*
PROCEDURE lvRptFormView
***
CREATE SQL VIEW lvRptFormView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	RptForm.RptFrmID, ;
	RptForm.RptFrmNM, ;
	RptForm.RptFrmNote, ;
	RptForm.RptFrmIsModify, ;
	RptFrmIsModifyText = CASE WHEN RptForm.RptFrmIsModify = 1 THEN 'Р' ELSE ' ' END ;
FROM RptForm ;
WHERE RptForm.RptID = ?_PARAM
***
DBSETPROP([lvRptFormView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptFormView],[VIEW],[COMMENT],[LV RPT: список доступных печатных форм для отчета])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: список доступных параметров выборки для отчета/*
PROCEDURE lvRptQryParView
***
CREATE SQL VIEW lvRptQryParView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	RptQryPar.RptQryParID, ;
	QueryParam.QryParNM, ;
	RptQryPar.RptQryParIndex ;
FROM RptQryPar ;
INNER JOIN QueryParam ON QueryParam.QryParID = RptQryPar.QryParID ;
WHERE RptQryPar.RptID = ?_PARAM ;
ORDER BY 3
***
DBSETPROP([lvRptQryParView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptQryParView],[VIEW],[COMMENT],[LV RPT: список доступных параметров выборки для отчета])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: редактирование параметров отчета/*
PROCEDURE lvRptQryParEdit
***
CREATE SQL VIEW lvRptQryParEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	RptQryPar.RptQryParID, ;
	RptQryPar.RptID, ;
	RptQryPar.QryParID, ;
	RptQryPar.RptQryParIndex ;
FROM RptQryPar ;
WHERE RptQryParID = ?_PARAM
***
DBSETPROP([lvRptQryParEdit.RptQryParID],[FIELD],[KeyField],.T.)
DBSETPROP([lvRptQryParEdit.RptQryParID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvRptQryParEdit.RptID],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptQryParEdit.QryParID],[FIELD],[Updatable],.T.)
DBSETPROP([lvRptQryParEdit.RptQryParIndex],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvRptQryParEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvRptQryParEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvRptQryParEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptQryParEdit],[VIEW],[COMMENT],[LV RPT: редактирование параметров отчета.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: редактирование порядка параметров выборки для отчета/*
PROCEDURE lvRptQryParIndexEdit
***
CREATE SQL VIEW lvRptQryParIndexEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	RptQryPar.RptQryParID, ;
	QueryParam.QryParNM, ;
	RptQryPar.RptQryParIndex ;
FROM RptQryPar ;
INNER JOIN QueryParam ON QueryParam.QryParID = RptQryPar.QryParID ;
WHERE RptQryPar.RptID = ?_PARAM ;
ORDER BY 3
***
DBSETPROP([lvRptQryParIndexEdit.RptQryParID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvRptQryParIndexEdit.RptQryParID],[FIELD],[Updatable],.F.)
DBSETPROP([lvRptQryParIndexEdit.QryParNM],[FIELD],[Updatable],.F.)
DBSETPROP([lvRptQryParIndexEdit.RptQryParIndex],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvRptQryParIndexEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvRptQryParIndexEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvRptQryParIndexEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptQryParIndexEdit],[VIEW],[COMMENT],[LV RPT: редактирование порядка параметров выборки для отчета])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: список доступных параметров выборки для отчета/*
PROCEDURE lvRptQryParList
***
CREATE SQL VIEW lvRptQryParList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QueryParam.QryParID, ;
	QueryParam.QryParNM ;
FROM QueryParam ;
WHERE QueryParam.QryParID NOT IN (SELECT RptQryPar.QryParID FROM RptQryPar WHERE RptQryPar.RptID = ?_PARAM1 AND RptQryPar.QryParID <> ?_PARAM2) ;
ORDER BY QueryParam.QryParNM
***
DBSETPROP([lvRptQryParList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptQryParList],[VIEW],[COMMENT],[LV RPT: список доступных параметров выборки для отчета])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: список типов отчетов/*
PROCEDURE lvRptTypeList
***
CREATE SQL VIEW lvRptTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	RptTypeID, ;
	RptTypeNM ;
FROM RptType ;
ORDER BY RptType.RptTypeNM
***
DBSETPROP([lvRptTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptTypeList],[VIEW],[COMMENT],[LV RPT: список типов отчетов])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: информация об типе отчета для менеджера библиотеки/*
PROCEDURE lvRptTypeInfoMgr
***
CREATE SQL VIEW lvRptTypeInfoMgr REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	RptType.RptTypeID, ;
	RptType.RptTypeNM, ;
	RptType.RptTypeIsCnt, ;
	RptType.RptTypeObjDesc, ;
	RptType.BmpId, ;
	RptType.SelBmpId ;
FROM Report ;
INNER JOIN RptType ON RptType.RptTypeId = Report.RptTypeId ;
WHERE Report.RptID = ?_PARAM
***
DBSETPROP([lvRptTypeInfoMgr],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptTypeInfoMgr],[VIEW],[COMMENT],[LV RPT: информация об типе отчета для менеджера библиотеки])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: список доступных шаблонов форм отчетов (печатных представлений)/*
PROCEDURE lvRptFrmTemplateList
***
CREATE SQL VIEW lvRptFrmTemplateList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	RptFrmTemplate.RptFrmTemplateID, ;
	RptFrmTemplate.RptFrmTemplateNM ;
FROM RptFrmTemplate ;
ORDER BY 2
***
DBSETPROP([lvRptFrmTemplateList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptFrmTemplateList],[VIEW],[COMMENT],[LV RPT: список доступных шаблонов форм отчетов (печатных представлений)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV RPT: шаблон формы отчета (печатного представления)/*
PROCEDURE lvRptFrmTemplate
***
CREATE SQL VIEW lvRptFrmTemplate REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	RptFrmTemplate.RptFrmTemplateID, ;
	RptFrmTemplate.RptFrmTemplateNM, ;
	RptFrmTemplate.RptFrmTemplateFRX, ;
	RptFrmTemplate.RptFrmTemplateFRT, ;
	RptFrmTemplate.Stamp_, ;
	RptFrmTemplate.User_ ;
FROM RptFrmTemplate ;
WHERE RptFrmTemplate.RptFrmTemplateID = ?_PARAM
***
DBSETPROP([lvRptFrmTemplate.RptFrmTemplateFRX],[FIELD],[DataType],[M])
DBSETPROP([lvRptFrmTemplate.RptFrmTemplateFRT],[FIELD],[DataType],[M])
***
DBSETPROP([lvRptFrmTemplate],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvRptFrmTemplate],[VIEW],[COMMENT],[LV RPT: шаблон формы отчета (печатного представления)])
***
ENDPROC
*------------------------------------------------------------------------------