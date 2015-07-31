PROCEDURE spHandleError
*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: Stored Procedures for Basis
* Module/Procedure: spHandleError()
* Called by.......: <NA>
* Parameters......: <taErrors>
* Returns.........: <none>
* Notes...........: Обработка ошибок ODBC
*------------------------------------------------------------------------------
*28.07.2006 09:38 ->Объявление и инициализация переменных
LOCAL    lnErrorRowsCount, ;
        lnCounter, ;
        lcErrorMessage,lcStErrorMessage,;
        lcWSNM   ,;
        ltDateTime,;
        lcUserNM ,;
        lnOldSelect
***
lnOldSelect = SELECT(0)
LOCAL ARRAY laErrors[1],laStErrors[1]
***
lcErrorMessage = []
*------------------------------------------------------------------------------
lcWSNM   = SYS(0)
lcUserNM = ALLTRIM(SUBSTR(lcWSNM,AT([#],lcWSNM)+1))
lcWSNM   = ALLTRIM(LEFT(lcWSNM,AT([#],lcWSNM)-1))
ltDateTime = DATETIME()

*21.01.2004 18:52 -> Прочитаем информацию об ошибке
lnErrorRowsCount = AERROR(laErrors)
lnStErrorRowsCount = ASTACKINFO(laStErrors)
*------------------------------------------------------------------------------

*28.07.2006 09:37 -> Последовательно обработаем все ошибки 
IF !FILE('ErrorStack.dbf')
   CREATE TABLE ErrorStack FREE (StLevel int NULL, PrgFl VarChar(254) NULL, ObjModul VarChar(254) NULL,;
                         ObjModFl VarChar(254) NULL,LineNum int NULL, SourCont VarChar(254) NULL,;
                         UserNm VarChar(254) NULL,Stamp_ datetime NULL,WSNM  VarChar(254) NULL)
  ELSE
   USE IN SELECT('ErrorStack')
   USE ErrorStack IN 0
ENDIF
INSERT INTO ErrorStack  FROM ARRAY laStErrors
REPLACE ALL UserNm WITH lcUserNM ,;
        WSNM   WITH lcWSNM   ,;
        Stamp_ WITH ltDateTime IN ErrorStack  FOR EMPTY(WSNM)

IF !FILE('ErrorLog.dbf')
   CREATE TABLE ErrorLog FREE(ErrNum1 int NULL, ErrorMs2 VarChar(254) NULL, ErorrPar3 VarChar(254) NULL,;
                         WkArr4 VarChar(254) NULL,TrgType5 VarChar(254) NULL, ODBCConn6 VarChar(254) NULL,;
                         OleEx int NULL, ;
                         UserNm VarChar(254) NULL,Stamp_ datetime NULL,WSNM  VarChar(254) NULL)
  ELSE
   USE IN SELECT('ErrorLog')
   USE ErrorLog IN 0
ENDIF
INSERT INTO ErrorLog FROM ARRAY laErrors
REPLACE ALL UserNm WITH lcUserNM ,;
        WSNM   WITH lcWSNM   ,;
        Stamp_ WITH ltDateTime IN ErrorLog FOR EMPTY(WSNM)

*!*    FOR lnCounter = 1 TO lnErrorRowsCount
*!*        IF laErrors[lnCounter,5] # 50001
*!*            lcErrorMessage = lcErrorMessage + STRTRAN(laErrors[lnCounter,3],pcvERRORHEADMSG,[* ]) + CHR(13)
*!*        ENDIF
*!*        STRTOFILE(TTOC(DATETIME())+[ -> ] + STRTRAN(laErrors[lnCounter,3],pcvERRORHEADMSG,[]) + CHR(13),[Error.log],1)
*!*        
*!*        *** Надо сохранить: сообщение об ошибке
*!*        ***  состояние стека
*!*    ENDFOR
*------------------------------------------------------------------------------
   USE IN SELECT('ErrorStack')
   USE IN SELECT('ErrorLog')
*28.07.2006 09:46 -> Выводим сообщение пользователю
IF lnErrorRowsCount > 0
    *MESSAGEBOX(lcErrorMessage,16,[Ошибка соединения...])
    MESSAGEBOX('Произошел сбой во внешней системе.',48,'Предупреждение')
ENDIF
*------------------------------------------------------------------------------
LOCAL lcExecuteProgram , lcExecuteProgramExtension 
lcExecuteProgram = SYS(16)
lcExecuteProgramExtension = UPPER(RIGHT(lcExecuteProgram,3))
SELECT (lnOldSelect )
IF !INLIST(lcExecuteProgramExtension,[EXE],[APP],[DLL])
    ON ERROR 
    RETRY 
ENDIF 

ENDPROC
*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************

