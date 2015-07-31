*------------------------------------------------------------------------------
* Project.........: AS@R_BASIS_Exchange.pjx
* File............: TDS_EXCHANGE_SERVER.PRG
* Module/Procedure: Startup()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: Обмен данными ASR<==>BASIS
*------------------------------------------------------------------------------

*29.06.2005 17:25 ->Для определения запускаемого приложения используем константы
#DEFINE cnAPPLICATION_NAME	TSD_Basis_Exchange
*------------------------------------------------------------------------------
*SYS(3050, 1,512*1024*1024)
*SYS(3050, 2,64*1024*1024)

*12.10.2005 10:47 ->
SET STRICTDATE TO 0
SET ENGINEBEHAVIOR 70
*------------------------------------------------------------------------------

*19.01.2005 17:43 ->Объявление и инициализация переменных
LOCAL	lcOldPath, ;
		lcApplicationNM, ;
		lcApplicationClassLib,;
        lcExecuteProgram, ;
        lcExecuteProgramExtension, ;
        lcExecuteProgramPath, ;
        lcApplicationIniFNM, ;
        llLibLoad
***
lcExecuteProgram = Sys(16)
lcExecuteProgramExtension = Upper(Right(lcExecuteProgram,3))
lcExecuteProgramPath = Upper(Substr(lcExecuteProgram,1,Rat([\],lcExecuteProgram)))
***
lcOldPath = SET([PATH])
lcApplicationNM = [cnAPPLICATION_NAME]
lcApplicationClassLib = lcApplicationNM + [.VCX]
lcApplicationIniFNM = lcExecuteProgramPath + lcApplicationNM + [.INI]
*------------------------------------------------------------------------------

*29.06.2005 17:30 ->Обработчик ошибок и завершения программы
*ON ERROR Error_Handler()
ON SHUTDOWN CLEAR EVENTS
*------------------------------------------------------------------------------

*29.06.2005 17:30 ->Установим пути
SET PATH TO (lcOldPath + [;tmp;data;Libs;Menus])
*------------------------------------------------------------------------------

*02.05.2004 15:48 ->Создадим объект для работы с INI файлами
If !([GENERAL_V1.VCX]$Set([CLASSLIB]))
    Set Classlib To GENERAL_V1.vcx Alias GENERAL_V1 Additive
    llLibLoad = .T.
Else
    llLibLoad = .F.
Endif
oRes = Createobject([resource],lcApplicationIniFNM)
If llLibLoad
    Release Classlib Alias GENERAL_V1
Endif
*------------------------------------------------------------------------------


*29.06.2005 17:30 ->Создаем объект приложения
IF !(lcApplicationClassLib$SET([CLASSLIB]))
	SET CLASSLIB TO (lcApplicationClassLib) ALIAS (lcApplicationNM) ADDITIVE
	llLibLoad = .T.
ELSE
	llLibLoad = .F.	
ENDIF

oApp = CREATEOBJECT(lcApplicationNM,lcApplicationNM)
IF llLibLoad
	RELEASE CLASSLIB ALIAS (lcApplicationNM)
ENDIF
*------------------------------------------------------------------------------

*29.06.2005 17:30 ->Запуск приложения
IF TYPE([oApp])==[O] AND !ISNULL(oApp)
	oApp.Show()
	READ EVENTS
ENDIF
*------------------------------------------------------------------------------

*05.08.2003 15:20 ->Восстановление среды
CLEAR DLLS
ON SHUTDOWN
CLEAR ALL
*------------------------------------------------------------------------------

************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************