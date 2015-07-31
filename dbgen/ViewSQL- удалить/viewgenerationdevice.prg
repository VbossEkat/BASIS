#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 16:34 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Устройства] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Устройства]
***
lvDeviceBmps()
***
lvDeviceTypeView()
lvDeviceTypeEdit()
lvDeviceTypeByDescriptor()
lvDeviceTypeList()
***
lvDeviceModelView()
lvDeviceModelViewRepl()
lvDeviceModelEdit()
lvDeviceModelByDescriptor()
lvDeviceModelList()
***
lvDeviceDriverView()
lvDeviceDriverEdit()
lvDeviceDriverByID()
lvDeviceDriverByModelAndVersion()
lvDeviceDriverList()
***
lvDeviceDriverFuncEdit()
lvDeviceDriverFuncByID()
lvDeviceDriverFuncByIDExpanded()
lvDeviceDriverFuncByMSG()
lvDeviceDriverFuncByCustomMSG()
lvDeviceDriverFuncByDeviceID()
***
lvDeviceTreeView()
lvDeviceCntTreeView()
lvDeviceCntTreeViewRepl()
lvDeviceInCntView()
lvDeviceInCntViewRepl()
lvDeviceEdit()
***
lvDeviceInfoByID()
***
lvCstFuncByMsg()
lvCstFuncEdit()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV Device: список используемых картинок/*
PROCEDURE lvDeviceBmps
***
CREATE SQL VIEW lvDeviceBmps REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Bitmaps.BmpId, ;
	Bitmaps.BmpFileNM ;
FROM Bitmaps ;
WHERE 	Bitmaps.BmpId IN (SELECT BmpID FROM DeviceType) OR ;
		Bitmaps.BmpId IN (SELECT SelBmpID FROM DeviceType)
***
DBSETPROP([lvDeviceBmps],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceBmps],[VIEW],[COMMENT],[LV Device: список используемых картинок])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: просмотр типов устройств/*
PROCEDURE lvDeviceTypeView
***
CREATE SQL VIEW lvDeviceTypeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceType.DeviceTypeID, ;
	DeviceType.DeviceTypeNM, ;
	DeviceType.DeviceTypeDescriptor, ;
	DeviceType.BmpId ;
FROM DeviceType ;
ORDER BY 2 ASC
***
DBSETPROP([lvDeviceTypeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceTypeView],[VIEW],[COMMENT],[LV Device: просмотр типов устройств])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: редактирование таблицы DeviceType*/
PROCEDURE lvDeviceTypeEdit
***
CREATE SQL VIEW lvDeviceTypeEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceType.DeviceTypeID, ;
	DeviceType.DeviceTypeDescriptor, ;
	DeviceType.DeviceTypeNM, ;
	DeviceType.DeviceTypeIsCnt, ;
	DeviceType.BmpID, ;
	DeviceType.SelBmpID, ;
	DeviceType.Stamp_, ;
	DeviceType.User_ ;
FROM DeviceType ;
WHERE DeviceType.DeviceTypeID = ?_PARAM
***
DBSETPROP([lvDeviceTypeEdit.DeviceTypeID],[FIELD],[KeyField],.T.)
DBSETPROP([lvDeviceTypeEdit.DeviceTypeID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvDeviceTypeEdit.DeviceTypeDescriptor],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceTypeEdit.DeviceTypeNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceTypeEdit.DeviceTypeIsCnt],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceTypeEdit.BmpID],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceTypeEdit.SelBmpID],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceTypeEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceTypeEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvDeviceTypeEdit.DeviceTypeDescriptor],[FIELD],[DefaultValue],[""])
DBSETPROP([lvDeviceTypeEdit.DeviceTypeNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvDeviceTypeEdit.DeviceTypeIsCnt],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvDeviceTypeEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvDeviceTypeEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvDeviceTypeEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceTypeEdit],[VIEW],[COMMENT],[LV Device: редактирование таблицы DeviceType])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: информация о типе устройств по дескриптору/*
PROCEDURE lvDeviceTypeByDescriptor
***
CREATE SQL VIEW lvDeviceTypeByDescriptor REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceType.DeviceTypeID, ;
	DeviceType.DeviceTypeDescriptor, ;
	DeviceType.DeviceTypeNM, ;
	DeviceType.DeviceTypeIsCnt, ;
	DeviceType.BmpId, ;
	DeviceType.SelBmpId ;
FROM DeviceType ;
WHERE UPPER(DeviceType.DeviceTypeDescriptor) = UPPER(?_PARAM)
***
DBSETPROP([lvDeviceTypeByDescriptor],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceTypeByDescriptor],[VIEW],[COMMENT],[LV Device: информация о типе устройств по дескриптору])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: список типов устройств/*
PROCEDURE lvDeviceTypeList
***
CREATE SQL VIEW lvDeviceTypeList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceType.DeviceTypeID, ;
	DeviceType.DeviceTypeNM ;
FROM DeviceType
***
DBSETPROP([lvDeviceTypeList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceTypeList],[VIEW],[COMMENT],[LV Device: список типов устройств])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: просмотр моделей устройств/*
PROCEDURE lvDeviceModelView
***
CREATE SQL VIEW lvDeviceModelView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceModel.DeviceModelID, ;
	DeviceModel.DeviceModelNM, ;
	DeviceModel.DeviceModelDescriptor, ;
	DeviceModel.DeviceModelGlobalAccess, ;
	DeviceType.BmpId ;
FROM DeviceModel ;
INNER JOIN DeviceType ON DeviceType.DeviceTypeID = DeviceModel.DeviceTypeID ;
ORDER BY 2 ASC
***
DBSETPROP([lvDeviceModelView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceModelView],[VIEW],[COMMENT],[LV Device: просмотр моделей устройств])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: обновление для lvDeviceModelView/*
PROCEDURE lvDeviceModelViewRepl
***
CREATE SQL VIEW lvDeviceModelViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceModel.DeviceModelID, ;
	DeviceModel.DeviceModelNM, ;
	DeviceModel.DeviceModelDescriptor, ;
	DeviceModel.DeviceModelGlobalAccess, ;
	DeviceType.BmpId ;
FROM DeviceModel ;
INNER JOIN DeviceType ON DeviceType.DeviceTypeID = DeviceModel.DeviceTypeID ;
WHERE DeviceModel.DeviceModelID = ?_PARAM
***
DBSETPROP([lvDeviceModelViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceModelViewRepl],[VIEW],[COMMENT],[LV Device: обновление для lvDeviceModelView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: редактирование таблицы DeviceModel*/
PROCEDURE lvDeviceModelEdit
***
CREATE SQL VIEW lvDeviceModelEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceModel.DeviceModelID, ;
	DeviceModel.DeviceTypeID, ;
	DeviceModel.DeviceModelDescriptor, ;
	DeviceModel.DeviceModelNM, ;
	DeviceModel.DeviceModelGlobalAccess, ;
	DeviceModel.Stamp_, ;
	DeviceModel.User_ ;
FROM DeviceModel ;
WHERE DeviceModel.DeviceModelID = ?_PARAM
***
DBSETPROP([lvDeviceModelEdit.DeviceModelID],[FIELD],[KeyField],.T.)
DBSETPROP([lvDeviceModelEdit.DeviceModelID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvDeviceModelEdit.DeviceTypeID],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceModelEdit.DeviceModelDescriptor],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceModelEdit.DeviceModelNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceModelEdit.DeviceModelGlobalAccess],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceModelEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceModelEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvDeviceModelEdit.DeviceModelDescriptor],[FIELD],[DefaultValue],[""])
DBSETPROP([lvDeviceModelEdit.DeviceModelNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvDeviceModelEdit.DeviceModelGlobalAccess],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvDeviceModelEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvDeviceModelEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvDeviceModelEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceModelEdit],[VIEW],[COMMENT],[LV Device: редактирование таблицы DeviceModel])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: информация о модели устройства по дескриптору/*
PROCEDURE lvDeviceModelByDescriptor
***
CREATE SQL VIEW lvDeviceModelByDescriptor REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceModel.DeviceModelID, ;
	DeviceModel.DeviceModelDescriptor, ;
	DeviceModel.DeviceModelNM, ;
	DeviceModel.DeviceModelGlobalAccess ;
FROM DeviceModel ;
WHERE UPPER(DeviceModel.DeviceModelDescriptor) = UPPER(?_PARAM)
***
DBSETPROP([lvDeviceModelByDescriptor],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceModelByDescriptor],[VIEW],[COMMENT],[LV Device: информация о модели устройства по дескриптору])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: список моделей устройств/*
PROCEDURE lvDeviceModelList
***
CREATE SQL VIEW lvDeviceModelList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceModel.DeviceModelID, ;
	DeviceModel.DeviceModelNM ;
FROM DeviceModel
***
DBSETPROP([lvDeviceModelList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceModelList],[VIEW],[COMMENT],[LV Device: список моделей устройств])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: просмотр драйверов для данной модели устройства/*
PROCEDURE lvDeviceDriverView
***
CREATE SQL VIEW lvDeviceDriverView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceDriver.DeviceDriverID, ;
	DeviceDriver.DeviceDriverVersion ;
FROM DeviceDriver ;
WHERE DeviceDriver.DeviceModelID = ?_PARAM ;
ORDER BY 2 ASC
***
DBSETPROP([lvDeviceDriverView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceDriverView],[VIEW],[COMMENT],[LV Device: просмотр драйверов для данной модели устройства])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: редактирование таблицы DeviceDriver*/
PROCEDURE lvDeviceDriverEdit
***
CREATE SQL VIEW lvDeviceDriverEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceDriver.DeviceDriverID, ;
	DeviceDriver.DeviceModelID, ;
	DeviceDriver.DeviceDriverVersion, ;
	DeviceDriver.DeviceDriverAppDescriptor, ;
	DeviceDriver.DeviceDriverINI, ;
	DeviceDriver.Stamp_, ;
	DeviceDriver.User_ ;	
FROM DeviceDriver ;
WHERE DeviceDriver.DeviceDriverID = ?_PARAM
***
DBSETPROP([lvDeviceDriverEdit.DeviceDriverID],[FIELD],[KeyField],.T.)
DBSETPROP([lvDeviceDriverEdit.DeviceDriverID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvDeviceDriverEdit.DeviceModelID],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceDriverEdit.DeviceDriverVersion],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceDriverEdit.DeviceDriverAppDescriptor],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceDriverEdit.DeviceDriverINI],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceDriverEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceDriverEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvDeviceDriverEdit.DeviceDriverINI],[FIELD],[DataType],[M])
DBSETPROP([lvDeviceDriverEdit.DeviceDriverVersion],[FIELD],[DefaultValue],[""])
DBSETPROP([lvDeviceDriverEdit.DeviceDriverAppDescriptor],[FIELD],[DefaultValue],[""])
DBSETPROP([lvDeviceDriverEdit.DeviceDriverINI],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvDeviceDriverEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvDeviceDriverEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvDeviceDriverEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceDriverEdit],[VIEW],[COMMENT],[LV Device: редактирование таблицы DeviceDriver])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: информация о драйвере устройства по идентификатору/*
PROCEDURE lvDeviceDriverByID
***
CREATE SQL VIEW lvDeviceDriverByID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceDriver.DeviceDriverID, ;
	DeviceDriver.DeviceModelID, ;
	DeviceDriver.DeviceDriverVersion, ;
	DeviceDriver.DeviceDriverAppDescriptor, ;
	DeviceDriver.DeviceDriverINI ;
FROM DeviceDriver ;
WHERE DeviceDriver.DeviceDriverID = ?_PARAM
***
DBSETPROP([lvDeviceDriverByID.DeviceDriverINI],[FIELD],[DataType],[M])
***
DBSETPROP([lvDeviceDriverByID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceDriverByID],[VIEW],[COMMENT],[LV Device: информация о драйвере устройства по идентификатору])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: информация о драйвере устройства по идентификатору модели и версии драйвера/*
PROCEDURE lvDeviceDriverByModelAndVersion
***
CREATE SQL VIEW lvDeviceDriverByModelAndVersion REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceDriver.DeviceDriverID, ;
	DeviceDriver.DeviceModelID, ;
	DeviceDriver.DeviceDriverVersion, ;
	DeviceDriver.DeviceDriverAppDescriptor, ;
	DeviceDriver.DeviceDriverINI ;
FROM DeviceDriver ;
WHERE DeviceDriver.DeviceModelID = ?_PARAM1 AND UPPER(DeviceDriver.DeviceDriverVersion) = UPPER(?_PARAM2)
***
DBSETPROP([lvDeviceDriverByModelAndVersion.DeviceDriverINI],[FIELD],[DataType],[M])
***
DBSETPROP([lvDeviceDriverByModelAndVersion],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceDriverByModelAndVersion],[VIEW],[COMMENT],[LV Device: информация о драйвере устройства по идентификатору модели и версии драйвера])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: список драйверов для устройства данной модели/*
PROCEDURE lvDeviceDriverList
***
CREATE SQL VIEW lvDeviceDriverList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceDriver.DeviceDriverID, ;
	DeviceDriver.DeviceDriverVersion ;
FROM DeviceDriver ;
WHERE DeviceDriver.DeviceModelID = ?_PARAM
***
DBSETPROP([lvDeviceDriverList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceDriverList],[VIEW],[COMMENT],[LV Device: список драйверов для устройства данной модели])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: редактирование таблицы DeviceDriverFunc*/
PROCEDURE lvDeviceDriverFuncEdit
***
CREATE SQL VIEW lvDeviceDriverFuncEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceDriverFunc.DeviceDriverFuncID, ;
	DeviceDriverFunc.DeviceDriverID, ;
	DeviceDriverFunc.DeviceDriverFuncNM, ;
	DeviceDriverFunc.DeviceDriverFuncMsg, ;
	DeviceDriverFunc.BmpId ;
FROM DeviceDriverFunc ;
WHERE DeviceDriverFunc.DeviceDriverFuncID = ?_PARAM
***
DBSETPROP([lvDeviceDriverFuncEdit.DeviceDriverFuncID],[FIELD],[KeyField],.T.)
DBSETPROP([lvDeviceDriverFuncEdit.DeviceDriverFuncID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvDeviceDriverFuncEdit.DeviceDriverID],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceDriverFuncEdit.DeviceDriverFuncNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceDriverFuncEdit.DeviceDriverFuncMsg],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceDriverFuncEdit.BmpId],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvDeviceDriverFuncEdit.DeviceDriverFuncNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvDeviceDriverFuncEdit.DeviceDriverFuncMsg],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvDeviceDriverFuncEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvDeviceDriverFuncEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvDeviceDriverFuncEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceDriverFuncEdit],[VIEW],[COMMENT],[LV Device: редактирование таблицы DeviceDriverFunc])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: информация о функции драйвера устройства по идентификатору функции*/
PROCEDURE lvDeviceDriverFuncByID
***
CREATE SQL VIEW lvDeviceDriverFuncByID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceDriverFunc.DeviceDriverFuncID, ;
	DeviceDriverFunc.DeviceDriverID, ;
	DeviceDriverFunc.DeviceDriverFuncNM, ;
	DeviceDriverFunc.DeviceDriverFuncMsg, ;
	DeviceDriverFunc.BmpId ;
FROM DeviceDriverFunc ;
WHERE DeviceDriverFunc.DeviceDriverFuncID = ?_PARAM
***
DBSETPROP([lvDeviceDriverFuncByID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceDriverFuncByID],[VIEW],[COMMENT],[LV Device: информация о функции драйвера устройства по идентификатору функции])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: расширенная информация о функции драйвера устройства по идентификатору функции*/
PROCEDURE lvDeviceDriverFuncByIDExpanded
***
CREATE SQL VIEW lvDeviceDriverFuncByIDExpanded REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceDriverFunc.DeviceDriverFuncID, ;
	DeviceDriverFunc.DeviceDriverID, ;
	DeviceDriverFunc.DeviceDriverFuncNM, ;
	DeviceDriverFunc.DeviceDriverFuncMsg, ;
	DeviceDriverFunc.BmpId, ;
	Bitmaps.BmpFileNM ;
FROM DeviceDriverFunc ;
INNER JOIN Bitmaps ON Bitmaps.BmpID = DeviceDriverFunc.BmpId ;
WHERE DeviceDriverFunc.DeviceDriverFuncID = ?_PARAM
***
DBSETPROP([lvDeviceDriverFuncByIDExpanded],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceDriverFuncByIDExpanded],[VIEW],[COMMENT],[LV Device: расширенная информация о функции драйвера устройства по идентификатору функции])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: информация о функции драйвера устройства по идентификатору драйвера и дескриптору функции*/
PROCEDURE lvDeviceDriverFuncByMSG
***
CREATE SQL VIEW lvDeviceDriverFuncByMSG REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceDriverFunc.DeviceDriverFuncID, ;
	DeviceDriverFunc.DeviceDriverID, ;
	DeviceDriverFunc.DeviceDriverFuncNM, ;
	DeviceDriverFunc.DeviceDriverFuncMsg, ;
	DeviceDriverFunc.BmpId ;
FROM DeviceDriverFunc ;
WHERE ;
	DeviceDriverFunc.DeviceDriverID = ?_PARAM AND ;
	UPPER(DeviceDriverFunc.DeviceDriverFuncMsg) = UPPER(?_MSG)
***
DBSETPROP([lvDeviceDriverFuncByMSG],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceDriverFuncByMSG],[VIEW],[COMMENT],[LV Device: информация о функции драйвера устройства по идентификатору дравера и дескриптору функции])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: полная информация о функции драйвера устройства по дескриптору пользовательской функции*/
PROCEDURE lvDeviceDriverFuncByCustomMSG
***
CREATE SQL VIEW lvDeviceDriverFuncByCustomMSG REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceDriverFunc.DeviceDriverFuncID, ;
	DeviceType.DeviceTypeDescriptor, ;
	DeviceModel.DeviceModelDescriptor, ;
	DeviceDriver.DeviceDriverVersion, ;
	DeviceDriver.DeviceDriverAppDescriptor, ;
	DeviceDriver.DeviceDriverINI, ;
	DeviceDriverFunc.DeviceDriverFuncNM, ;
	DeviceDriverFunc.DeviceDriverFuncMsg ;
FROM DeviceDriverFunc ;
INNER JOIN DeviceDriver	ON DeviceDriver.DeviceDriverID = DeviceDriverFunc.DeviceDriverID ;
INNER JOIN DeviceModel	ON DeviceModel.DeviceModelID = DeviceDriver.DeviceModelID ;
INNER JOIN DeviceType		ON DeviceType.DeviceTypeID = DeviceModel.DeviceTypeID ;
WHERE UPPER(DeviceDriverFunc.DeviceDriverFuncMsg) = UPPER(?_PARAM)
***
DBSETPROP([lvDeviceDriverFuncByCustomMSG.DeviceDriverINI],[FIELD],[DataType],[M])
***
DBSETPROP([lvDeviceDriverFuncByCustomMSG],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceDriverFuncByCustomMSG],[VIEW],[COMMENT],[LV Device: информация о функции драйвера устройства по дескриптору пользовательской функции])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: список функций дравера по идентификатору устройства*/
PROCEDURE lvDeviceDriverFuncByDeviceID
***
CREATE SQL VIEW lvDeviceDriverFuncByDeviceID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	DeviceDriverFunc.DeviceDriverFuncID, ;
	DeviceDriverFunc.DeviceDriverFuncNM, ;
	DeviceDriverFunc.DeviceDriverFuncMsg, ;
	DeviceDriverFunc.BmpId ;
FROM DeviceDriverFunc ;
INNER JOIN Device ON Device.DeviceDriverID = DeviceDriverFunc.DeviceDriverID ;
WHERE Device.DeviceID = ?_PARAM
***
DBSETPROP([lvDeviceDriverFuncByDeviceID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceDriverFuncByDeviceID],[VIEW],[COMMENT],[LV Device: список функций дравера по идентификатору устройства])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: дерево устройств (все устройства)/*
PROCEDURE lvDeviceTreeView
***
CREATE SQL VIEW lvDeviceTreeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Device.DeviceID, ;
	ISNULL(Device.DeviceParID,0) AS DeviceParID, ;
	Device.DeviceNM, ;
	DeviceType.DeviceTypeIsCnt AS DeviceIsCnt, ;
	DeviceType.BmpID, ;
	DeviceType.SelBmpID ;
FROM Device ;
INNER JOIN DeviceModel	ON DeviceModel.DeviceModelID = Device.DeviceModelID ;
INNER JOIN DeviceType	ON DeviceType.DeviceTypeID = DeviceModel.DeviceTypeID ;
ORDER BY 3 ASC
***
DBSETPROP([lvDeviceTreeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceTreeView],[VIEW],[COMMENT],[LV Device: дерево устройств (все устройства)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: дерево устройств (только родители)/*
PROCEDURE lvDeviceCntTreeView
***
CREATE SQL VIEW lvDeviceCntTreeView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Device.DeviceID, ;
	ISNULL(Device.DeviceParID,0) AS DeviceParID, ;
	Device.DeviceNM, ;
	DeviceType.DeviceTypeIsCnt AS DeviceIsCnt, ;
	DeviceType.BmpID, ;
	DeviceType.SelBmpID ;
FROM Device ;
INNER JOIN DeviceModel	ON DeviceModel.DeviceModelID = Device.DeviceModelID ;
INNER JOIN DeviceType	ON DeviceType.DeviceTypeID = DeviceModel.DeviceTypeID ;
WHERE DeviceType.DeviceTypeIsCnt = 1 ;
ORDER BY 3 ASC
***
DBSETPROP([lvDeviceCntTreeView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceCntTreeView],[VIEW],[COMMENT],[LV Device: дерево устройств (только родители)])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: обновления для lvDeviceCntTreeView/*
PROCEDURE lvDeviceCntTreeViewRepl
***
CREATE SQL VIEW lvDeviceCntTreeViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Device.DeviceID, ;
	ISNULL(Device.DeviceParID,0) AS DeviceParID, ;
	Device.DeviceNM, ;
	DeviceType.DeviceTypeIsCnt AS DeviceIsCnt, ;
	DeviceType.BmpID, ;
	DeviceType.SelBmpID ;
FROM Device ;
INNER JOIN DeviceModel	ON DeviceModel.DeviceModelID = Device.DeviceModelID ;
INNER JOIN DeviceType	ON DeviceType.DeviceTypeID = DeviceModel.DeviceTypeID ;
WHERE Device.DeviceID = ?_PARAM
***
DBSETPROP([lvDeviceCntTreeViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceCntTreeViewRepl],[VIEW],[COMMENT],[LV Device: обновления для lvDeviceCntTreeView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: содержание группы устройств/*
PROCEDURE lvDeviceInCntView
***
CREATE SQL VIEW lvDeviceInCntView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Device.DeviceID, ;
	ISNULL(Device.DeviceParID,0) AS DeviceParID, ;
	DeviceType.DeviceTypeIsCnt, ;
	Device.DeviceNM, ;
	DeviceType.BmpId ;
FROM Device ;
INNER JOIN DeviceModel	ON DeviceModel.DeviceModelID = Device.DeviceModelID ;
INNER JOIN DeviceType	ON DeviceType.DeviceTypeID = DeviceModel.DeviceTypeID ;
WHERE ISNULL(Device.DeviceParID,0) = ?_PARAM ;
ORDER BY 3 DESC, 4 ASC
***
DBSETPROP([lvDeviceInCntView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceInCntView],[VIEW],[COMMENT],[LV Device: содержание группы устройств])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: обновления для lvDeviceInCntView/*
PROCEDURE lvDeviceInCntViewRepl
***
CREATE SQL VIEW lvDeviceInCntViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Device.DeviceID, ;
	ISNULL(Device.DeviceParID,0) AS DeviceParID, ;
	DeviceType.DeviceTypeIsCnt, ;
	Device.DeviceNM, ;
	DeviceType.BmpId ;
FROM Device ;
INNER JOIN DeviceModel	ON DeviceModel.DeviceModelID = Device.DeviceModelID ;
INNER JOIN DeviceType	ON DeviceType.DeviceTypeID = DeviceModel.DeviceTypeID ;
WHERE Device.DeviceID = ?_PARAM
***
DBSETPROP([lvDeviceInCntViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceInCntViewRepl],[VIEW],[COMMENT],[LV Device: обновления для lvDeviceInCntView])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: редактирование таблицы Device*/
PROCEDURE lvDeviceEdit
***
CREATE SQL VIEW lvDeviceEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Device.DeviceID, ;
	Device.DeviceParID, ;
	Device.DeviceModelID, ;
	Device.DeviceDriverID, ;
	Device.DeviceNM, ;
	Device.DeviceINI, ;
	Device.Stamp_, ;
	Device.User_ ;
FROM Device ;
WHERE Device.DeviceID = ?_PARAM
***
DBSETPROP([lvDeviceEdit.DeviceID],[FIELD],[KeyField],.T.)
DBSETPROP([lvDeviceEdit.DeviceID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvDeviceEdit.DeviceParID],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceEdit.DeviceModelID],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceEdit.DeviceDriverID],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceEdit.DeviceNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceEdit.DeviceINI],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvDeviceEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvDeviceEdit.DeviceINI],[FIELD],[DataType],[M])
DBSETPROP([lvDeviceEdit.DeviceNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvDeviceEdit.DeviceINI],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvDeviceEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvDeviceEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvDeviceEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceEdit],[VIEW],[COMMENT],[LV Device: редактирование таблицы Device])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: информация об устройстве по идентификатору*/
PROCEDURE lvDeviceInfoByID
***
CREATE SQL VIEW lvDeviceInfoByID REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	Device.DeviceID, ;
	Device.DeviceNM, ;
	Device.DeviceINI, ;
	DeviceDriver.DeviceDriverVersion, ;
	DeviceDriver.DeviceDriverAppDescriptor, ;
	DeviceDriver.DeviceDriverINI, ;
	DeviceModel.DeviceModelDescriptor, ;
	DeviceModel.DeviceModelNM, ;
	DeviceModel.DeviceModelGlobalAccess, ;
	DeviceType.DeviceTypeDescriptor, ;
	DeviceType.DeviceTypeNM ;
FROM Device ;
INNER JOIN DeviceDriver ON DeviceDriver.DeviceDriverID = Device.DeviceDriverID ;
INNER JOIN DeviceModel	ON DeviceModel.DeviceModelID = Device.DeviceModelID ;
INNER JOIN DeviceType   ON DeviceType.DeviceTypeID = DeviceModel.DeviceTypeID ;
WHERE Device.DeviceID = ?_PARAM
***
DBSETPROP([lvDeviceInfoByID.DeviceINI],[FIELD],[DataType],[M])
DBSETPROP([lvDeviceInfoByID.DeviceDriverINI],[FIELD],[DataType],[M])
***
DBSETPROP([lvDeviceInfoByID],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvDeviceInfoByID],[VIEW],[COMMENT],[LV Device: информация об устройстве по идентификатору])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV Device: пользовательская функция по дескриптору/*
PROCEDURE lvCstFuncByMsg
***
CREATE SQL VIEW lvCstFuncByMsg REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CustomFunc.CstFuncID, ;
	CustomFunc.CstFuncNM, ;
	CustomFunc.CstFuncMsg, ;
	CustomFunc.BmpID ;
FROM CustomFunc ;
WHERE UPPER(CustomFunc.CstFuncMsg) = UPPER(?_PARAM)
***
DBSETPROP([lvCstFuncByMsg],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCstFuncByMsg],[VIEW],[COMMENT],[LV Device: пользовательская функция по дескриптору])
***
ENDPROC
*------------------------------------------------------------------------------

*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

*/LV Device: редактирование пользовательских функций/*
PROCEDURE lvCstFuncEdit
***
CREATE SQL VIEW lvCstFuncEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CustomFunc.CstFuncID, ;
	CustomFunc.CstFuncNM, ;
	CustomFunc.BmpID, ;
	CustomFunc.CstFuncMsg ;
FROM CustomFunc ;
WHERE CustomFunc.CstFuncID = ?_PARAM
***
DBSETPROP([lvCstFuncEdit.CstFuncID],[FIELD],[KeyField],.T.)
DBSETPROP([lvCstFuncEdit.CstFuncID],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvCstFuncEdit.CstFuncNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCstFuncEdit.BmpID],[FIELD],[Updatable],.T.)
DBSETPROP([lvCstFuncEdit.CstFuncMsg],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCstFuncEdit.CstFuncNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCstFuncEdit.CstFuncMsg],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvCstFuncEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCstFuncEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCstFuncEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCstFuncEdit],[VIEW],[COMMENT],[LV Device: редактирование пользовательских функций])
***
ENDPROC
*------------------------------------------------------------------------------

*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************