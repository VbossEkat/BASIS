PROCEDURE deleLOCALDB
IF FILE([LOCAL\LOCALDB.DBC]) ;
        AND MESSAGEBOX('������� ��������� ����� ������������?',4+64+256,'������� ������ ...')=6
        IF DBUSED('LOCALDB')
            SET DATABASE TO LOCALDB 
            CLOSE DATABASES 
        ENDIF
        DELETE DATABASE LOCAL\LOCALDB DELETETABLES
ENDIF
SET DATABASE TO BASIS 

