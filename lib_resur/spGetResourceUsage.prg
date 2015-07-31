*------------------------------------------------------------------------------
* Project.........: BASIS.PJX
* File............: STORED PROCEDURES FOR BASIS
* Module/Procedure: spGetResourceUsage()
* Called by.......: <NA>
* Parameters......: <tnMsuID, tdStartDate, tuValue>
* Returns.........: <Datetime / Numeric>
* Notes...........: Вычисление времени использования ресурса (конечная дата или количество ресурса)
* Last Editor.....: Владимир Боярских
* Last Edit.......: September 13, 2007
*------------------------------------------------------------------------------
PROCEDURE spGetResourceUsage
LPARAMETERS tnMsuID, tdStartDate, tuValue

*13.09.2007 13:51 -> Объявление и инициализация переменных
LOCAL   lnConnectHandle, ;
		lnSqlExeResult
*------------------------------------------------------------------------------

*13.09.2007 13:51 -> Коннектимся к БД через существующее соединение
lnConnectHandle = SQLCONNECT(pcvCONNECTIONNAME)
*------------------------------------------------------------------------------

*13.09.2007 14:00 -> Выполняем запрос
lnSqlExeResult = 0
***
DO WHILE (lnSqlExeResult = 0) AND (lnSqlExeResult # -1)
	lnSqlExeResult = SQLEXEC(lnConnectHandle, ;
		[SET LOCK_TIMEOUT ] + pcvLOCKTIMEOUT + [ ] + ;
		[SELECT ] + ;
			[MsuTransKoeff = dbo.MsuTransKoeff(MeasureUnit.BaseMsuID, MeasureUnit.MsuID, NULL) ] + ;
		[FROM MeasureUnit ] + ;
		[WHERE MeasureUnit.MsuID = ?tnMsuID],[curMsu])
ENDDO
***
IF lnSqlExeResult = -1
	spHandleODBCError()
	RETURN .F.
ENDIF
*------------------------------------------------------------------------------

*13.09.2007 14:11 -> Получим конечную дату использования ресурса
IF TYPE([tuValue]) == [N]
	&& Количество ресурса домножаем на коэффициент ед.изм. времени, 
	&& домножаем на 60 секунд и прибавляем к начальной дате
	RETURN tdStartDate + (tuValue * curMsu.MsuTransKoeff * 60) 
ENDIF
*------------------------------------------------------------------------------

*13.09.2007 14:18 -> Получим количество использованного ресурса
IF TYPE([tuValue]) == [T]
	&& Из конечной даты вычитаем начальную и делим полученное количество 
	&& на 60 секунд и на коэффициент ед.изм. времени
	IF (curMsu.MsuTransKoeff * 60) # 0
		RETURN (tuValue - tdStartDate) / (curMsu.MsuTransKoeff * 60)
	ENDIF
ENDIF
*------------------------------------------------------------------------------

*13.09.2007 14:12 -> Что-то сработало не так
RETURN .F.
*------------------------------------------------------------------------------

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************