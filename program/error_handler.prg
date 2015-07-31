*-------------------------------------------------------
* Project.........: TRANS_MTX_ABG.PJX
* File............: ERROR_HANDLER.PRG
* Module/Procedure: ERROR_HANDLER()
* Called by.......: <ON ERROR>
* Parameters......: <none>
* Returns.........: <.T.>
* Last Edit Date..: 5, August, 2003
* Notes...........: Обработка ошибок
*-------------------------------------------------------
*05.08.2003 15:46 ->Объявление и инициализация переменных
LOCAL	laError[1], ;
		ErrorDat, ;
		ErrorNum, ;
		ErrorNam, ;
		ErrorMtd, ;
		ErrorLne, ;
		ErrorTxt
*------------------------------------------------------------------------------ 

*05.08.2003 15:45 ->Создаем файл ошибки
IF !FILE([errorlog.dbf])
	CREATE TABLE errorlog.dbf FREE ( ;
		ErrorDat T, ;
		ErrorNum I, ;
		ErrorNam C(100), ;
		ErrorMtd C(100), ;
		ErrorLne I, ;
		ErrorTxt C(100), ;
		ErrorDmp M NOCPTRANS)
	USE IN errorlog
ENDIF
*------------------------------------------------------------------------------

*05.08.2003 15:46 ->Получим информацию об ошибке
=AERROR(laError)
*------------------------------------------------------------------------------

*05.08.2003 15:46 ->Формируем данные об ошибке
DISPLAY MEMORY TO FILE dump.txt NOCONSOLE
m.errordat = DATETIME()
m.errornum = laError[1]
m.errornam = MESSAGE()
m.errormtd = PROGRAM()
m.errorlne = LINENO()
m.errortxt = MESSAGE(1)
*------------------------------------------------------------------------------

*05.08.2003 15:46 ->Запишем информацию об ошибке
IF FILE([errorlog.dbf]) AND FILE([dump.txt])
	IF !USED([errorlog])
		USE errorlog.dbf IN 0 SHARED
	ENDIF
	***
	SELECT errorlog
	APPEND BLANK
	GATHER MEMVAR
	APPEND MEMO ErrorDmp FROM dump.txt OVERWRITE
	***
	USE IN errorlog
	ERASE dump.txt
ENDIF
*------------------------------------------------------------------------------

*05.08.2003 15:48 ->Выводим сообщение об ошибке
ASSERT .F. MESSAGE ;
	[Ошибка: ] + ALLTRIM(STR(m.errornum)) + CHR(13) + MESSAGE() + CHR(13) + ;
	[Метод:  ] + ALLTRIM(m.errormtd) + CHR(13) + ;
	[Строка: ] + ALLTRIM(STR(m.errorlne)) + CHR(13) + MESSAGE(1)
*------------------------------------------------------------------------------
	
RETURN .T.
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************