*28.12.2005 16:14 -> ���������� � ������������� ����������
LOCAL	lcSourceDir, ;
		lcSourceFile, ;
		lcDuplicateDir, ;
		lcDuplicateFile
*------------------------------------------------------------------------------

*28.12.2005 16:14 -> ��������� �������� ������
lcSourceDir = ADDBS(GETDIR())
lcDuplicateDir = UPPER(SUBSTR(SYS(16),1,RAT([\],SYS(16))))
*------------------------------------------------------------------------------

*28.12.2005 16:22 -> �������� ��������� �� ������� Tovar
lcSourceFile = lcSourceDir + [_TOVAR.dbf]
lcDuplicateFile = lcDuplicateDir + [_TOVAR.dbf]
***
SELECT ;
	F1, ;
	F7 ;
FROM &lcSourceFile ;
WHERE F7 IN ( ;
	SELECT ;
		F7 ;
	FROM &lcSourceFile ;
	GROUP BY 1 ;
	HAVING COUNT(F1) # 1) OR ;
	EMPTY(F7) ;
ORDER BY 2 ;
INTO TABLE &lcDuplicateFile
*------------------------------------------------------------------------------

*28.12.2005 16:22 -> �������� ��������� �� ������� TvrLookUp
lcSourceFile = lcSourceDir + [_TVRLOOKUP.dbf]
lcDuplicateFile = lcDuplicateDir + [_TVRLOOKUP.dbf]
***
SELECT ;
	F1, ;
	F5 ;
FROM &lcSourceFile ;
WHERE F5 IN ( ;
	SELECT ;
		F5 ;
	FROM &lcSourceFile ;
	GROUP BY 1 ;
	HAVING COUNT(F1) # 1) OR ;
	EMPTY(F5) ;
ORDER BY 2 ;
INTO TABLE &lcDuplicateFile
*------------------------------------------------------------------------------

*28.12.2005 16:22 -> �������� ��������� �� ������� TvrSet
lcSourceFile = lcSourceDir + [_TVRSET.dbf]
lcDuplicateFile = lcDuplicateDir + [_TVRSET.dbf]
***
SELECT ;
	F1, ;
	F2 ;
FROM &lcSourceFile ;
WHERE F2 IN ( ;
	SELECT ;
		F2 ;
	FROM &lcSourceFile ;
	GROUP BY 1 ;
	HAVING COUNT(F1) # 1) OR ;
	EMPTY(F2) ;	
ORDER BY 2 ;
INTO TABLE &lcDuplicateFile
*------------------------------------------------------------------------------

*28.12.2005 16:22 -> �������� ��������� �� ������� Client
lcSourceFile = lcSourceDir + [_CLIENT.dbf]
lcDuplicateFile = lcDuplicateDir + [_CLIENT.dbf]
***
SELECT ;
	F1, ;
	F4 ;
FROM &lcSourceFile ;
WHERE F4 IN ( ;
	SELECT ;
		F4 ;
	FROM &lcSourceFile ;
	GROUP BY 1 ;
	HAVING COUNT(F1) # 1) OR ;
	EMPTY(F4) ;	
ORDER BY 2 ;
INTO TABLE &lcDuplicateFile
*------------------------------------------------------------------------------

*28.12.2005 16:22 -> �������� ��������� �� ������� OrgUnit
lcSourceFile = lcSourceDir + [_ORGUNIT.dbf]
lcDuplicateFile = lcDuplicateDir + [_ORGUNIT.dbf]
***
SELECT ;
	F1, ;
	F6 ;
FROM &lcSourceFile ;
WHERE F6 IN ( ;
	SELECT ;
		F6 ;
	FROM &lcSourceFile ;
	GROUP BY 1 ;
	HAVING COUNT(F1) # 1) OR ;
	EMPTY(F6) ;	
ORDER BY 2 ;
INTO TABLE &lcDuplicateFile
*------------------------------------------------------------------------------

*28.12.2005 16:22 -> �������� ��������� �� ������� MeasureUnit
lcSourceFile = lcSourceDir + [_MEASUREUNIT.dbf]
lcDuplicateFile = lcDuplicateDir + [_MEASUREUNIT.dbf]
***
SELECT ;
	F1, ;
	F2 ;
FROM &lcSourceFile ;
WHERE F2 IN ( ;
	SELECT ;
		F2 ;
	FROM &lcSourceFile ;
	GROUP BY 1 ;
	HAVING COUNT(F1) # 1) OR ;
	EMPTY(F2) ;	
ORDER BY 2 ;
INTO TABLE &lcDuplicateFile
*------------------------------------------------------------------------------

*28.12.2005 16:31 -> ������� ��
CLOSE DATABASES ALL
*------------------------------------------------------------------------------