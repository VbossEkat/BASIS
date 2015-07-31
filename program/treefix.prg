*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: TreeFix.prg
* Module/Procedure: TreeFix()
* Called by.......: <NA>
* Parameters......: <none>
* Returns.........: <none>
* Notes...........: Проверка дерева товаров
*------------------------------------------------------------------------------

*06.05.2006 09:39 ->Объявление и инициализация переменных
LOCAL   lcOldDeleted
*------------------------------------------------------------------------------

*06.05.2006 09:41 ->Устанавливаем окружение
lcOldDeleted = SET([DELETED])
SET DELETED ON
*------------------------------------------------------------------------------

*06.05.2006 09:41 ->Пошем заголовок в Log
STRTOFILE([***********************************]+CHR(13),[tree.log],1)
STRTOFILE([ ПРОВЕРКА ДЕРЕВА ТОВАРОВ ]+DTOC(DATE())+CHR(13),[tree.log],1)
STRTOFILE([***********************************]+CHR(13),[tree.log],1)
*------------------------------------------------------------------------------

*06.05.2006 09:43 ->Создаем копию справочника
SELECT ;
	Tovar.TvrID, ;
	Tovar.TvrParID, ;
	TvrType.TvrTypeIsCnt AS IsCnt, ;
	Tovar.TvrNM ;
FROM Tovar ;
INNER JOIN TvrType ON TvrType.TvrTypeID = Tovar.TvrTypeID ;
INTO TABLE tmp\tmpTovarAll
*------------------------------------------------------------------------------

*******************************************************************************	
*1. Проверка на уникальность      											  *
*******************************************************************************	
WAIT WINDOW [Проверка на уникальность] NOWAIT NOCLEAR
SET MESSAGE TO [Проверка на уникальность]
***
SELECT ;
	tmpTovarAll.TvrID, ;
	COUNT(*) AS DupCnt ;
FROM tmpTovarAll ;
GROUP BY 1 ;
INTO CURSOR curTmpTovarChkUnqStage1 NOFILTER
***
SELECT ;
	tmpTovarAll.TvrID, ;
	tmpTovarAll.TvrParID, ;
	tmpTovarAll.IsCnt, ;
	tmpTovarAll.TvrNM ;
FROM tmpTovarAll ;
INNER JOIN curTmpTovarChkUnqStage1 ON tmpTovarAll.TvrID = curTmpTovarChkUnqStage1.TvrID AND curTmpTovarChkUnqStage1.DupCnt > 1 ;
INTO TABLE tmp\tmpTovarNotUnq
***
USE IN SELECT([curTmpTovarChkUnqStage1])
***
IF _Tally >0
	MESSAGEBOX([Найдены повторяющеися элементы!!!],48,[Предупреждение...])	
	STRTOFILE([Найдены повторяющеися элементы]+CHR(13),[tree.log],1)
	SELECT([tmpTovarNotUnq])
	SCAN
		STRTOFILE([Код товара]+STR(TvrID)+[ ]+TvrNM+CHR(13),[tree.log],1)
	ENDSCAN
ENDIF
***
USE IN SELECT([tmpTovarNotUnq])
IF FILE([tmp\tmpTovarNotUnq.dbf])
   ERASE tmp\tmpTovarNotUnq.dbf
ENDIF
*------------------------------------------------------------------------------
	
*******************************************************************************	
*2. Проверка потерянных элементов											  *
*******************************************************************************	
WAIT WINDOW [Поиск потерянных элементов] NOWAIT NOCLEAR
SET MESSAGE TO [Поиск потерянных элементов]
***
SELECT ;
	tmpTovarAll.TvrID ;
FROM tmpTovarAll ;
WHERE tmpTovarAll.IsCnt ;
INTO CURSOR curTmpTovarPar NOFILTER
***
SELECT ;
	tmpTovarAll.TvrID, ;
	tmpTovarAll.TvrParID, ;
	tmpTovarAll.IsCnt, ;
	tmpTovarAll.TvrNM ;
FROM tmpTovarAll ;
WHERE 	(tmpTovarAll.TvrParID > 0) AND ;
		(tmpTovarAll.TvrParID NOT IN (SELECT curTmpTovarPar.TvrID FROM curTmpTovarPar)) ;
INTO TABLE tmp\tmpTovarLosed
***
USE IN SELECT([curTmpTovarPar])
***
IF _Tally>0
	MESSAGEBOX([Найдены потерянные элементы],48,[Предупреждение...])
	STRTOFILE([Найдены потерянные элементы]+CHR(13),[tree.log],1)
	SELECT([tmpTovarLosed])
	SCAN
		STRTOFILE([Код товара ]+STR(TvrID)+[ ]+TvrNM+CHR(13),[tree.log],1)
	ENDSCAN
ENDIF
***
USE IN SELECT([tmpTovarLosed])
IF FILE([tmp\tmpTovarLosed.dbf])
   ERASE tmp\tmpTovarLosed.dbf
ENDIF
*------------------------------------------------------------------------------

*******************************************************************************	
*3. Проверка цикличности дерева товаров										  *
*******************************************************************************	
WAIT WINDOW [Проверка цикличности дерева товаров] NOWAIT NOCLEAR
SET MESSAGE TO [Проверка цикличности дерева товаров]
***
CREATE TABLE tmp\tmpTovarCycl FREE (TvrID I)
***
SELECT ;
	tmpTovarAll.TvrID, ;
	tmpTovarAll.TvrParID ;
FROM tmpTovarAll ;
WHERE tmpTovarAll.IsCnt AND tmpTovarAll.TvrParID # 0 ;
INTO CURSOR curTmpTreeCyclMain NOFILTER
***
DO WHILE _Tally>0

	*06.05.2006 10:24 ->Выбираем "замкнувшиеся" элементы
	SELECT ;
		tmpTovarCycl.TvrID ;
	FROM tmpTovarCycl ;
	UNION ALL ;
	SELECT ;
		curTmpTreeCyclMain.TvrID ;
	FROM curTmpTreeCyclMain ;
	WHERE curTmpTreeCyclMain.TvrParID = curTmpTreeCyclMain.TvrID ;
	INTO CURSOR curTmpTovarCycl NOFILTER
	***
	SELECT * FROM curTmpTovarCycl INTO TABLE tmp\tmpTovarCycl
	*------------------------------------------------------------------------------
	
	*06.05.2006 10:26 ->Выбираем "незамкнувшиеся" товары, у которых родитель родителя не 0
	SELECT ;
		curTmpTreeCyclMain.TvrID, ;
		tmpTovarAll.TvrParID ;
	FROM curTmpTreeCyclMain ;
	INNER JOIN tmpTovarAll ON curTmpTreeCyclMain.TvrParID = tmpTovarAll.TvrID  ;
	WHERE curTmpTreeCyclMain.TvrParID # curTmpTreeCyclMain.TvrID ;
	INTO CURSOR curTmpTreeCyclStage1 NOFILTER
	***
	SELECT ;
		curTmpTreeCyclStage1.TvrID, ;
		curTmpTreeCyclStage1.TvrParID ;
	FROM curTmpTreeCyclStage1 ;
	WHERE 	curTmpTreeCyclStage1.TvrParID # 0 AND ;
			curTmpTreeCyclStage1.TvrParID NOT IN (SELECT tmpTovarCycl.TvrID FROM tmpTovarCycl) ;
	INTO CURSOR curTmpTreeCyclStage2 NOFILTER
	***
	IF _Tally > 0
		SELECT * FROM curTmpTreeCyclStage2 INTO CURSOR curTmpTreeCyclMain NOFILTER
	ENDIF
	*------------------------------------------------------------------------------	
ENDDO	
***
IF RECCOUNT([tmpTovarCycl])>0
	MESSAGEBOX([Найдены цикличные элементы],48,[Предупреждение...])
	STRTOFILE([Найдены цикличные элементы]+CHR(13),[tree.log],1)
	SELECT([tmpTovarCycl])
	SCAN
		STRTOFILE([Код товара]+STR(TvrID)+CHR(13),[tree.log],1)
	ENDSCAN
ENDIF	
*------------------------------------------------------------------------------

*06.05.2006 10:31 ->закрываем курсоры
USE IN SELECT([curTmpTreeCyclMain])
USE IN SELECT([curTmpTovarCycl])
USE IN SELECT([curTmpTreeCyclStage1])
USE IN SELECT([curTmpTreeCyclStage2])
USE IN SELECT([curTmpTreeCyclMain])
*------------------------------------------------------------------------------

*12.04.2004 18:03 ->удаляем временные таблицы
IF USED([tmpTovarCycl])
	USE IN tmpTovarCycl
ENDIF
IF FILE([tmp\tmpTovarCycl.dbf])
	ERASE tmp\tmpTovarCycl.dbf
ENDIF
***
IF USED([tmpTovarAll])
	USE IN tmpTovarAll
ENDIF
IF FILE([tmp\tmpTovarAll.dbf])
	ERASE tmp\tmpTovarAll.dbf
ENDIF
***
IF USED([tmpTovarLosed])
	USE IN tmpTovarLosed
ENDIF
IF FILE([tmp\tmpTovarLosed.dbf])
	ERASE tmp\tmpTovarLosed.dbf
ENDIF
***

WAIT CLEAR
SET MESSAGE TO

*06.05.2006 10:32 ->Восстанавливаем окружение
SET DELETED &lcOldDeleted
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************