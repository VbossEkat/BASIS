PROCEDURE AddCardToBasis
** ��������� �����
SET DATABASE TO BASIS 
USE IN SELECT('Card')
USE Card IN 0
SELECT Card
CURSORSETPROP([BUFFERING],3,[Card])

FOR x = 471 TO 570 &&150
    xcode = '05'+REPLICATE('0',5-LEN(ALLTRIM(STR(x,10,0))))+ALLTRIM(STR(x,10,0)) && ��������� �����
    xn = 500000+x            && �����  �����
    WAIT WINDOW xn NOWAIT 

    INSERT INTO Card ;
           (CardTypeID ;
           ,CardNo ;
           ,CardCode ;
           ,CardActivationDate ;
           ,CardDeliveryDate ;
           ,CardIsActive ;
           ,CardOwnerID ) ;
     VALUES (1 ;
           ,ALLTRIM(STR(xn,10,0)) ;
           ,xcode ;
           ,DATETIME() ;
           ,{^2040-06-01};
           ,.t. ;
           ,418)     && ��� �������    418 ��� 5, 1 ��� 7, 2 ��� ����            
                     
ENDFOR 


TABLEUPDATE(0,.t.,'Card')

