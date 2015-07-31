PROCEDURE AddCardToBolid
** Добаление пусты
SET DATABASE TO BASIS 
USE IN SELECT('bolid_plist')
USE bolid_plist IN 0
SELECT bolid_plist
CURSORSETPROP([BUFFERING],3,[bolid_plist])

FOR x = 21 TO 1000
    xn = REPLICATE('0',5-LEN(ALLTRIM(STR(x,10,0))))+ALLTRIM(STR(x,10,0))
    WAIT WINDOW xn NOWAIT 
    INSERT INTO  bolid_plist(ID, Name,             Status, TabNumber,FirstName);
                     VALUES (x,xn ,5      ,xn,'')
                     
    INSERT INTO bolid_pMark (ID, Gtype,  Config,;
                             CodeP, CodePAdd,  Owner, OwnerName,;
                             GrStatus, GroupID) VALUES ;
                             (x,4,128,;
                             '','',x,xn,;
                             1,16)
ENDFOR 


TABLEUPDATE(0,.t.,'bolid_plist')
TABLEUPDATE(0,.t.,'bolid_pMark')

***    Формирование данных в таблице-связке 
*!*    DELETE FROM [basis].[dbo].[OrionKeys]
*!*    INSERT INTO [basis].[dbo].[OrionKeys]
*!*               ([KeyID]
*!*               ,[Code])
*!*        SELECT [CardID]
*!*          ,[CardCode]
*!*      FROM [basis].[dbo].[Card]