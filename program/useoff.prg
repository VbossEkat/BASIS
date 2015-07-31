FUNCTION useoff
PARAMETERS clvname
*****Открывает local view оторванно 
LOCAL clvnametmp
clvnametmp = 'TMP\'+clvname+'_tmp.dbf'

IF NOT FILE(clvnametmp) 
   USE (clvname) IN 0 
   SELECT * FROM (clvname) INTO TABLE (clvnametmp)  
****   CREATEOFFLINE(clvname ) &&, clvnametmp)
****   DROPOFFLINE(cViewName)

   USE IN (clvname)
   USE IN (clvname+'_tmp')
  
ENDIF

USE (clvnametmp) IN 0 ALIAS (clvname) 

RETU