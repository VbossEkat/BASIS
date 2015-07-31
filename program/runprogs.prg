*09.09.2008 15:25 -> Объявим DLL библиотеку для запуска программ
#DEFINE SW_NORMAL 1
DECLARE INTEGER ShellExecute IN Shell32 AS ShellExecute STRING @, STRING, STRING, STRING, STRING, INTEGER
*------------------------------------------------------------------------------
_Screen.WindowState = 2
_Screen.Caption = 'Базис.Настройка сервера'

*09.09.2008 15:26 -> Объявление и инициализация переменных
LOCAL    lcHwnd, ;
        luOperation, ;
        lcParameters, ;
        lcSoftDir, ;
        lcSoftExe, ;
        luInstance, ;
        luResult, ;
        ntimepause , ;
        nShowtype
***
USE runprogs.dbf IN 0 
SELECT runprogs
SCAN
    lcHwnd = REPLICATE(CHR(0),254)
    luOperation = .NULL.
    lcParameters = ALLTRIM(NVL(runprogs.prm,''))
    lcSoftDir = ALLTRIM(NVL(runprogs.softdir,''))
    lcSoftExe = lcSoftDir + ALLTRIM(NVL(runprogs.softexe,''))
    ntimepause = NVL(runprogs.timepause ,0)
    nShowtype = NVL(runprogs.Showtype,1)
    *------------------------------------------------------------------------------
    IF ntimepause<>0
        WAIT WINDOW 'Выполняется запуск программы '+chr(13)+;
                ALLTRIM(runprogs.softexe) TIMEOUT ntimepause 
    ENDIF 
    *------------------------------------------------------------------------------

    *09.09.2008 15:29 -> Выполним программу загрузки
    luInstance = ShellExecute(@lcHwnd,luOperation,lcSoftExe,lcParameters,lcSoftDir,nShowtype)
    ***
    IF luInstance<=32
        =MESSAGEBOX([Не удалось запустить программу!]+ALLTRIM(runprogs.softexe),48,[Предупреждение...])
        RETURN .F.
    ENDIF 
    SET STEP ON 
ENDSCAN 

*******************************************************************************
********************************* END METHOD **********************************
*******************************************************************************