#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 17:21 -> ��������� �������������
WAIT WINDOW [��������� ������������� ��� ��: �������� �����] NOWAIT NOCLEAR
SET MESSAGE TO [��������� ������������� ��� ��: �������� �����]
***
lvBitmapsEdit()
lvBitmapsByFileNM()
lvBmpsList()
lvIconsList()
lvScrFrmGrpList()
lvScrFrmEdit()
lvScrFrmView()
lvScrFrmViewObjEdit()
lvScrFrmViewObjView()
lvScrFrmViewObjList()
lvScrFrmCustomFuncEdit()
lvScrFrmCustomFuncView()
lvScrFrmCustomFuncList()
lvScrFrmQryParEdit()
lvScrFrmQryParView()
lvScrFrmQryParIndexEdit()
lvScrFrmQryParList()
lvScrFrmByID()
lvScrFrmByObjDesc()
lvScrFrmInfo()
lvScrFrmInfoAll()
lvCstFuncAllByScrFrm()
lvScrFrmToolBarIndexEdit()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV SCRFRM: �������������� ����������/*
PROCEDURE lvBitmapsEdit
***
CREATE SQL VIEW lvBitmapsEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Bitmaps.BmpId, ;
	Bitmaps.BmpFileNM, ;
	Bitmaps.Stamp_, ;
	Bitmaps.User_ ;
FROM Bitmaps ;
WHERE Bitmaps.BmpId = ?_PARAM
***
DBSETPROP([lvBitmapsEdit.BmpId],[FIELD],[KeyField],.T.)
DBSETPROP([lvBitmapsEdit.BmpId],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvBitmapsEdit.BmpFileNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvBitmapsEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvBitmapsEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvBitmapsEdit.BmpFileNM],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvBitmapsEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvBitmapsEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvBitmapsEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvBitmapsEdit],[VIEW],[COMMENT],[LV SCRFRM: �������������� ����������])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ���������� � ����������� �� ����� �����/*
PROCEDURE lvBitmapsByFileNM
***
CREATE SQL VIEW lvBitmapsByFileNM REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Bitmaps.BmpId, ;
	Bitmaps.BmpFileNM ;
FROM Bitmaps ;
WHERE UPPER(Bitmaps.BmpFileNM) = UPPER(?_PARAM)
***
DBSETPROP([lvBitmapsByFileNM],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvBitmapsByFileNM],[VIEW],[COMMENT],[LV SCRFRM: ���������� � ����������� �� ����� �����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ������ ����������/*
PROCEDURE lvBmpsList
***
CREATE SQL VIEW lvBmpsList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Bitmaps.BmpId, ;
	Bitmaps.BmpFileNM ;
FROM Bitmaps
***
DBSETPROP([lvBmpsList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvBmpsList],[VIEW],[COMMENT],[LV SCRFRM: ������ ����������.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ������ ������/*
PROCEDURE lvIconsList
***
CREATE SQL VIEW lvIconsList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Icons.IcoId, ;
	Icons.IcoFileNM ;
FROM Icons
***
DBSETPROP([lvIconsList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvIconsList],[VIEW],[COMMENT],[LV SCRFRM: ������ ������.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ������ ����� �������� ����/*
PROCEDURE lvScrFrmGrpList
***
CREATE SQL VIEW lvScrFrmGrpList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScrFrmGrp.ScrFrmGrpId, ;
	ScrFrmGrp.ScrFrmGrpNM ;
FROM ScrFrmGrp ;
ORDER BY ScrFrmGrp.ScrFrmGrpNM
***
DBSETPROP([lvScrFrmGrpList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmGrpList],[VIEW],[COMMENT],[LV SCRFRM: ������ ����� �������� ����.])
***
ENDPROC
*------------------------------------------------------------------------------
	
*/LV SCRFRM: �������������� �������� �����/*
PROCEDURE lvScrFrmEdit
***
CREATE SQL VIEW lvScrFrmEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScreenForm.ScrFrmID, ;
	ScreenForm.ScrFrmGrpID, ;
	ScreenForm.ScrFrmNM, ;
	ScreenForm.ScrFrmObjDesc, ;
	ScreenForm.BmpId, ;
	ScreenForm.IcoID, ;
	ScreenForm.ScrFrmIsOnToolBar, ;
	ScreenForm.Stamp_, ;
	ScreenForm.User_ ;
FROM ScreenForm ;
WHERE ScreenForm.ScrFrmID = ?_PARAM
***
DBSETPROP([lvScrFrmEdit.ScrFrmID],[FIELD],[KeyField],.T.)
DBSETPROP([lvScrFrmEdit.ScrFrmID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvScrFrmEdit.ScrFrmGrpID],[FIELD],[Updatable],.T.)
DBSETPROP([lvScrFrmEdit.ScrFrmNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvScrFrmEdit.ScrFrmObjDesc],[FIELD],[Updatable],.T.)
DBSETPROP([lvScrFrmEdit.BmpId],[FIELD],[Updatable],.T.)
DBSETPROP([lvScrFrmEdit.IcoID],[FIELD],[Updatable],.T.)
DBSETPROP([lvScrFrmEdit.ScrFrmIsOnToolBar],[FIELD],[Updatable],.T.)
DBSETPROP([lvScrFrmEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvScrFrmEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvScrFrmEdit.ScrFrmNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvScrFrmEdit.ScrFrmObjDesc],[FIELD],[DefaultValue],[""])
DBSETPROP([lvScrFrmEdit.ScrFrmIsOnToolBar],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvScrFrmEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvScrFrmEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvScrFrmEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmEdit],[VIEW],[COMMENT],[LV SCRFRM: �������������� �������� �����.])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV SCRFRM: �������� �������� ����/*
PROCEDURE lvScrFrmView
***
CREATE SQL VIEW lvScrFrmView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScreenForm.ScrFrmID, ;
	ScreenForm.ScrFrmNM, ;
	ScreenForm.BmpId ;
FROM ScreenForm
***
DBSETPROP([lvScrFrmView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmView],[VIEW],[COMMENT],[LV SCRFRM: �������� �������� ����.])
***
ENDPROC
*------------------------------------------------------------------------------	

*/LV SCRFRM: �������������� ������������ �� ����� ����������/*
PROCEDURE lvScrFrmViewObjEdit
***
CREATE SQL VIEW lvScrFrmViewObjEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScrFrmViewObj.ScrFrmViewObjID, ;
	ScrFrmViewObj.ScrFrmID, ;
	ScrFrmViewObj.FrmTypeID ;
FROM ScrFrmViewObj ;
WHERE ScrFrmViewObj.ScrFrmViewObjID = ?_PARAM
***
DBSETPROP([lvScrFrmViewObjEdit.ScrFrmViewObjID],[FIELD],[KeyField],.T.)
DBSETPROP([lvScrFrmViewObjEdit.ScrFrmViewObjID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvScrFrmViewObjEdit.ScrFrmID],[FIELD],[Updatable],.T.)
DBSETPROP([lvScrFrmViewObjEdit.FrmTypeID],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvScrFrmViewObjEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvScrFrmViewObjEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvScrFrmViewObjEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmViewObjEdit],[VIEW],[COMMENT],[LV SCRFRM: �������������� ������������ �� ����� ����������])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ������ ������������ �� ����� ����������/*
PROCEDURE lvScrFrmViewObjView
***
CREATE SQL VIEW lvScrFrmViewObjView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScrFrmViewObj.ScrFrmViewObjID, ;
	FrmType.FrmTypeNM ;
FROM ScrFrmViewObj ;
LEFT JOIN FrmType ON FrmType.FrmTypeID = ScrFrmViewObj.FrmTypeID ;
WHERE ScrFrmViewObj.ScrFrmID = ?_PARAM
***
DBSETPROP([lvScrFrmViewObjView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmViewObjView],[VIEW],[COMMENT],[LV SCRFRM: ������ ������������ �� ����� ����������])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ������ ��������� ���������� ��� �������� �����/*
PROCEDURE lvScrFrmViewObjList
***
CREATE SQL VIEW lvScrFrmViewObjList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	FrmType.FrmTypeID, ;
	FrmType.FrmTypeNM ;
FROM FrmType ;
WHERE FrmType.FrmTypeID NOT IN (SELECT ScrFrmViewObj.FrmTypeID FROM ScrFrmViewObj WHERE ScrFrmViewObj.ScrFrmID = ?_PARAM1 AND ScrFrmViewObj.FrmTypeID <> ?_PARAM2) ;
ORDER BY FrmType.FrmTypeNM
***
DBSETPROP([lvScrFrmViewObjList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmViewObjList],[VIEW],[COMMENT],[LV SCRFRM: ������ ��������� ���������� ��� �������� �����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: �������������� �������������� ������� �������� �����/*
PROCEDURE lvScrFrmCustomFuncEdit
***
CREATE SQL VIEW lvScrFrmCustomFuncEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScrFrmCustomFunc.ScrFrmCstFuncID, ;
	ScrFrmCustomFunc.ScrFrmID, ;
	ScrFrmCustomFunc.CstFuncID ;
FROM ScrFrmCustomFunc ;
WHERE ScrFrmCustomFunc.ScrFrmCstFuncID = ?_PARAM
***
DBSETPROP([lvScrFrmCustomFuncEdit.ScrFrmCstFuncID],[FIELD],[KeyField],.T.)
DBSETPROP([lvScrFrmCustomFuncEdit.ScrFrmCstFuncID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvScrFrmCustomFuncEdit.ScrFrmID],[FIELD],[Updatable],.T.)
DBSETPROP([lvScrFrmCustomFuncEdit.CstFuncID],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvScrFrmCustomFuncEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvScrFrmCustomFuncEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvScrFrmCustomFuncEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmCustomFuncEdit],[VIEW],[COMMENT],[LV SCRFRM: �������������� �������������� ������� �������� �����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ������ �������������� ������� �������� �����/*
PROCEDURE lvScrFrmCustomFuncView
***
CREATE SQL VIEW lvScrFrmCustomFuncView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScrFrmCustomFunc.ScrFrmCstFuncID, ;
	CustomFunc.CstFuncNM ;
FROM ScrFrmCustomFunc ;
LEFT JOIN CustomFunc ON CustomFunc.CstFuncID = ScrFrmCustomFunc.CstFuncID ;
WHERE ScrFrmCustomFunc.ScrFrmID = ?_PARAM
***
DBSETPROP([lvScrFrmViewObjView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmViewObjView],[VIEW],[COMMENT],[LV SCRFRM: ������ �������������� ������� �������� �����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ������ ��������� ������� ��� �������� �����/*
PROCEDURE lvScrFrmCustomFuncList
***
CREATE SQL VIEW lvScrFrmCustomFuncList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CustomFunc.CstFuncID, ;
	CustomFunc.CstFuncNM ;
FROM CustomFunc ;
WHERE CustomFunc.CstFuncID NOT IN (SELECT ScrFrmCustomFunc.CstFuncID FROM ScrFrmCustomFunc WHERE ScrFrmCustomFunc.ScrFrmID = ?_PARAM1 AND ScrFrmCustomFunc.CstFuncID <> ?_PARAM2)
***
DBSETPROP([lvScrFrmCustomFuncList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmCustomFuncList],[VIEW],[COMMENT],[LV SCRFRM: ������ ��������� ������� ��� �������� �����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: �������������� ���������� �������� �����/*
PROCEDURE lvScrFrmQryParEdit
***
CREATE SQL VIEW lvScrFrmQryParEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScrFrmQryParID, ;
	ScrFrmID, ;
	QryParID, ;
	ScrFrmQryParIndex;
FROM ScrFrmQryPar ;
WHERE ScrFrmQryParID = ?_PARAM
***
DBSETPROP([lvScrFrmQryParEdit.ScrFrmQryParID],[FIELD],[KeyField],.T.)
DBSETPROP([lvScrFrmQryParEdit.ScrFrmQryParID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvScrFrmQryParEdit.ScrFrmID],[FIELD],[Updatable],.T.)
DBSETPROP([lvScrFrmQryParEdit.QryParID],[FIELD],[Updatable],.T.)
DBSETPROP([lvScrFrmQryParEdit.ScrFrmQryParIndex],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvScrFrmQryParEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvScrFrmQryParEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvScrFrmQryParEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmQryParEdit],[VIEW],[COMMENT],[LV SCRFRM: �������������� ���������� �������� �����.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ������ ��������� ���������� ������� ��� �������� �����/*
PROCEDURE lvScrFrmQryParView
***
CREATE SQL VIEW lvScrFrmQryParView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScrFrmQryPar.ScrFrmQryParID, ;
	QueryParam.QryParNM, ;
	ScrFrmQryPar.ScrFrmQryParIndex ;
FROM ScrFrmQryPar ;
INNER JOIN QueryParam ON QueryParam.QryParID = ScrFrmQryPar.QryParID ;
WHERE ScrFrmQryPar.ScrFrmID = ?_PARAM ;
ORDER BY 3
***
DBSETPROP([lvScrFrmQryParView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmQryParView],[VIEW],[COMMENT],[LV SCRFRM: ������ ��������� ���������� ������� ��� �������� �����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: �������������� ������� ���������� ������� ��� �������� �����/*
PROCEDURE lvScrFrmQryParIndexEdit
***
CREATE SQL VIEW lvScrFrmQryParIndexEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScrFrmQryPar.ScrFrmQryParID, ;
	QueryParam.QryParNM, ;
	ScrFrmQryPar.ScrFrmQryParIndex ;
FROM ScrFrmQryPar ;
INNER JOIN QueryParam ON QueryParam.QryParID = ScrFrmQryPar.QryParID ;
WHERE ScrFrmQryPar.ScrFrmID = ?_PARAM ;
ORDER BY 3
***
DBSETPROP([lvScrFrmQryParIndexEdit.ScrFrmQryParID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvScrFrmQryParIndexEdit.ScrFrmQryParID],[FIELD],[Updatable],.F.)
DBSETPROP([lvScrFrmQryParIndexEdit.QryParNM],[FIELD],[Updatable],.F.)
DBSETPROP([lvScrFrmQryParIndexEdit.ScrFrmQryParIndex],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvScrFrmQryParIndexEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvScrFrmQryParIndexEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvScrFrmQryParIndexEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmQryParIndexEdit],[VIEW],[COMMENT],[LV SCRFRM: �������������� ������� ���������� ������� ��� �������� �����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ������ ��������� ���������� ������� ��� �������� �����/*
PROCEDURE lvScrFrmQryParList
***
CREATE SQL VIEW lvScrFrmQryParList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	QueryParam.QryParID, ;
	QueryParam.QryParNM ;
FROM QueryParam ;
WHERE QueryParam.QryParID NOT IN (SELECT ScrFrmQryPar.QryParID FROM ScrFrmQryPar WHERE ScrFrmQryPar.ScrFrmID = ?_PARAM1 AND ScrFrmQryPar.QryParID <> ?_PARAM2) ;
ORDER BY QueryParam.QryParNM
***
DBSETPROP([lvScrFrmQryParList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmQryParList],[VIEW],[COMMENT],[LV SCRFRM: ������ ��������� ���������� ������� ��� �������� �����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ���������� � ���������� �������� ����� �� ��������������/*
PROCEDURE lvScrFrmByID
***
CREATE SQL VIEW lvScrFrmByID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScreenForm.ScrFrmID, ;
	ScreenForm.ScrFrmGrpID, ;
	ScreenForm.ScrFrmNM, ;
	ScreenForm.ScrFrmObjDesc ;
FROM ScreenForm ;
WHERE ScreenForm.ScrFrmID = ?_PARAM
***
DBSETPROP([lvScrFrmByID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmByID],[VIEW],[COMMENT],[LV SCRFRM: ���������� � ���������� �������� ����� �� ��������������])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ���������� � ���������� �������� ����� �� ����������� �������/*
PROCEDURE lvScrFrmByObjDesc
***
CREATE SQL VIEW lvScrFrmByObjDesc REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScreenForm.ScrFrmID, ;
	ScreenForm.ScrFrmGrpID, ;
	ScreenForm.ScrFrmNM, ;
	ScreenForm.ScrFrmObjDesc ;
FROM ScreenForm ;
WHERE UPPER(ScreenForm.ScrFrmObjDesc) = UPPER(?_PARAM)
***
DBSETPROP([lvScrFrmByObjDesc],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmByObjDesc],[VIEW],[COMMENT],[LV SCRFRM: ���������� � ���������� �������� ����� �� ����������� �������])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ���������� � ���������� �������� �����/*
PROCEDURE lvScrFrmInfo
***
CREATE SQL VIEW lvScrFrmInfo REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScreenForm.ScrFrmID, ;
	ScreenForm.ScrFrmGrpID, ;
	ScreenForm.ScrFrmNM, ;
	ScreenForm.ScrFrmObjDesc, ;
	ScrFrmGrp.ScrFrmGrpNM, ;
	Bitmaps.BmpFileNM, ;
	Icons.IcoFileNM ;
FROM ScreenForm ;
LEFT OUTER JOIN Bitmaps ON Bitmaps.BmpID = ScreenForm.BmpID ;
LEFT OUTER JOIN Icons ON Icons.IcoID = ScreenForm.IcoID ;
LEFT OUTER JOIN ScrFrmGrp ON ScrFrmGrp.ScrFrmGrpID = ScreenForm.ScrFrmGrpID ;
WHERE Screenform.scrfrmid = ?_PARAM
***
DBSETPROP([lvScrFrmInfo],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmInfo],[VIEW],[COMMENT],[LV SCRFRM: ���������� � ���������� �������� �����.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ���������� � ���� �������� ������/*
PROCEDURE lvScrFrmInfoAll
***
CREATE SQL VIEW lvScrFrmInfoAll REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScreenForm.ScrFrmToolBarIdx, ;
	ScreenForm.ScrFrmID, ;
	ScreenForm.ScrFrmGrpID, ;
	ScreenForm.ScrFrmNM, ;
	ScreenForm.ScrFrmObjDesc, ;
	ScrFrmGrp.ScrFrmGrpNM, ;
	Bitmaps.BmpFileNM, ;
	Icons.IcoFileNM ;
FROM ScreenForm ;
LEFT OUTER JOIN Bitmaps ON Bitmaps.BmpID = ScreenForm.BmpID ;
LEFT OUTER JOIN Icons ON Icons.IcoID = ScreenForm.IcoID ;
LEFT OUTER JOIN ScrFrmGrp ON ScrFrmGrp.ScrFrmGrpID = ScreenForm.ScrFrmGrpID ;
WHERE ScreenForm.ScrFrmIsOnToolBar = 1 ;
ORDER BY ;
	ScreenForm.ScrFrmGrpID, ;
	ScreenForm.ScrFrmToolBarIdx, ;
	ScreenForm.ScrFrmID
***
DBSETPROP([lvScrFrmInfoAll],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmInfoAll],[VIEW],[COMMENT],[LV SCRFRM: ���������� � ���� �������� ������.])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: ������ ��������� CustomFunc ��� �������� �����/*
PROCEDURE lvCstFuncAllByScrFrm
***
CREATE SQL VIEW lvCstFuncAllByScrFrm REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CustomFunc.CstFuncID, ;
	CustomFunc.CstFuncNM, ;
	CustomFunc.CstFuncMsg, ;
	'1_' + LTRIM(STR(ScrFrmCustomFunc.ScrFrmID)) AS CstFuncGrp, ;
	ScrFrmCustomFunc.ScrFrmID AS ScrFrmID, ;
	0 AS FrmTypeID, ;
	CustomFunc.BmpID, ;
	Bitmaps.BmpFileNM ;
FROM CustomFunc ;
INNER JOIN ScrFrmCustomFunc ON ScrFrmCustomFunc.CstFuncID = CustomFunc.CstFuncID ;
INNER JOIN Bitmaps ON Bitmaps.BmpID = CustomFunc.BmpID ;
WHERE ScrFrmCustomFunc.ScrFrmID = ?_PARAM ;
UNION ;
SELECT ;
	CustomFunc.CstFuncID, ;
	CustomFunc.CstFuncNM, ;
	CustomFunc.CstFuncMsg, ;
	'2_' + LTRIM(STR(FrmTypeCustomFunc.FrmTypeID)) AS CstFuncGrp, ;
	0 AS ScrFrmID, ;
	FrmTypeCustomFunc.FrmTypeID AS FrmTypeID, ;
	CustomFunc.BmpID, ;
	Bitmaps.BmpFileNM ;
FROM CustomFunc ;
INNER JOIN FrmTypeCustomFunc ON FrmTypeCustomFunc.CstFuncID = CustomFunc.CstFuncID ;
INNER JOIN ScrFrmViewObj ON ScrFrmViewObj.FrmTypeID = FrmTypeCustomFunc.FrmTypeID ;
INNER JOIN Bitmaps ON Bitmaps.BmpID = CustomFunc.BmpID ;
WHERE ScrFrmViewObj.ScrFrmID = ?_PARAM ;
ORDER BY 4
***
DBSETPROP([lvCstFuncAllByScrFrm],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCstFuncAllByScrFrm],[VIEW],[COMMENT],[LV SCRFRM: ������ ��������� CustomFunc ��� �������� �����])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV SCRFRM: �������������� ������� �������� ���� �� ToolBar-e/*
PROCEDURE lvScrFrmToolBarIndexEdit
***
CREATE SQL VIEW lvScrFrmToolBarIndexEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	ScreenForm.ScrFrmID, ;
	ScreenForm.ScrFrmNM, ;
	ScreenForm.ScrFrmToolBarIdx ;
FROM ScreenForm ;
WHERE ScreenForm.ScrFrmIsOnToolBar = 1 ;
ORDER BY 3
***
DBSETPROP([lvScrFrmToolBarIndexEdit.ScrFrmID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvScrFrmToolBarIndexEdit.ScrFrmID],[FIELD],[Updatable],.F.)
DBSETPROP([lvScrFrmToolBarIndexEdit.ScrFrmNM],[FIELD],[Updatable],.F.)
DBSETPROP([lvScrFrmToolBarIndexEdit.ScrFrmToolBarIdx],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvScrFrmToolBarIndexEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvScrFrmToolBarIndexEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvScrFrmToolBarIndexEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvScrFrmToolBarIndexEdit],[VIEW],[COMMENT],[LV SCRFRM: �������������� ������� �������� ���� �� ToolBar-e])
***
ENDPROC
*------------------------------------------------------------------------------
