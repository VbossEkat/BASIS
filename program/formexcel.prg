PROCEDURE FormExcel
cNameXLSFile=GETFILE('XLS','Файл XLS','Выбрать',0,'Выберите файл учета поступлений')  
  IF EMPTY(cNameXLSFile)  
      WAIT 'Действие отменено пользователем' WINDOW AT 20,80 NOWAIT   
      RETURN  
  ENDIF   
  SET SAFETY OFF   
  SET ESCAPE ON   
  SET TALK OFF  
  SET EXACT ON  
  SET NEAR OFF   

CLOSE DATABASES ALL
OPEN DATABASE D:\Develop\Work\DEMO\Kolcovo\basis.dbc EXCLUSIVE 
SET DATABASE TO Basis
LOCAL cTvrNm , cCatNM , cBarCode , cEd_izm, cGrpNM, ;
      lnMsuID , llResult ,lnTvrID , lnGrpID 

 *"Товар" "Каталог" "Код"    "Ед.изм" "Группа"  
*  CREATE CURSOR tmp(TvrNm C(200), CatNM C(50), BarCode C(50), Ed_izm C(20),GrpNM C(200))  
  XLRelek1=GetObject("","Excel.Application")  
  XLRelek=XLRelek1.Workbooks.open((cNameXLSFile))  
  XLRelek.application.visible=.f. &&[1]  
  && [1]Эту команду можно и пропустить, но если она присутствует Excel открывается и,   
 *если файл достаточно большой можно смотреть, как курсор прыгает по ячейкам   
  XLSheet1=XLRelek.Sheets(1)  &&Второй лист. Можно выбрать любой.  
  XLSheet1.select   
    
  ii=8 && Пропускаю шапку файла Excel  
  XLSheet1.Cells(ii,1).select   
  DO WHILE !EMPTY(XLSheet1.Cells(ii,1).value)   
      STORE '' to cTvrNm , cCatNM , cBarCode , cEd_izm, cGrpNM
         USE IN SELECT('Tovar')
         USE IN SELECT('TvrLookUp')
         USE IN SELECT('tmpMeasureUnit')
         USE IN SELECT('MeasureUnit')
       
    *  XLSheet1.Cells(ii,1).select &&[1]  
      cTvrNm   =NVL(ALLTRIM(XLSheet1.Cells(ii,1).value),'')  
      IF EMPTY(ALLTRIM(cTvrNm ))  
         ii=ii+1  
   LOOP   
      ENDIF 
    *  XLSheet1.Cells(ii,2).select &&[1]  
      cCatNM   =NVL(ALLTRIM(XLSheet1.Cells(ii,2).value),'') 
        
    *  XLSheet1.Cells(ii,3).select &&[1]  
      cBarCode =NVL(ALLTRIM(XLSheet1.Cells(ii,3).value),'') 
        
    *  XLSheet1.Cells(ii,4).select &&[1]  
      cEd_izm  =NVL(ALLTRIM(XLSheet1.Cells(ii,4).value),'') 
        
    *  XLSheet1.Cells(ii,5).select &&[1]  
      cGrpNM   =NVL(ALLTRIM(XLSheet1.Cells(ii,5).value),'') 
      *** проверка на пустоту
      
      IF !EMPTY(cEd_izm )
      *-* Выбираем новые единицы измерения и добавляем их в таблицу MeasureUnit 
        USE MeasureUnit IN 0
        SELECT DISTINCT MsuId,MsuNM FROM MeasureUnit WHERE MsuNM = cEd_izm ;
            UNION ;
            SELECT DISTINCT MsuId,MsuShortNM as MsuNM FROM MeasureUnit WHERE MsuShortNM = cEd_izm  ;
            INTO CURSOR tmpMeasureUnit
         IF _tally > 0
             SELECT tmpMeasureUnit
             GO TOP 
             lnMsuID = tmpMeasureUnit.MsuId
         ELSE 
             USE IN SELECT('MeasureUnit')
             USE MeasureUnit IN 0 NODATA 
             INSERT INTO MeasureUnit (MsuNM, MsuShortNM, MsuQnt, MsuType) VALUES (cEd_izm  ,cEd_izm,  1,0) 
             llResult = TABLEUPDATE(1,.T.,[MeasureUnit])
             lnMsuID = spGetLastIncrementedId([MeasureUnit])
        ENDIF 
         USE IN SELECT('tmpMeasureUnit')
         USE IN SELECT('MeasureUnit')
        ENDIF 
 
        *-* Выбираем новые товары и добавляем их в таблицу Tovar
        USE Tovar IN 0 NODATA 
       
        SELECT TvrId FROM Tovar WHERE TvrNM = cTvrNm  INTO CURSOR tmpTvr 
        IF !(_tally > 0)
             IF EMPTY(cEd_izm)
                ** добавляем название группы
                    INSERT INTO Tovar (TvrNM,  TvrTypeId,TvrIsActiv, TvrParId) VALUES (cTvrNm , 1,.t.,14) 
                 ELSE 
                    INSERT INTO Tovar (TvrNM, MsuId, TvrTypeId,TvrIsActiv, TvrParId) VALUES (cTvrNm , lnMsuID ,2,.t.,lnGrpID )
             ENDIF  
            llResult = TABLEUPDATE(1,.T.,[Tovar])
            IF llResult 
                 IF EMPTY(cEd_izm)
                    ** добавляем название группы
                        lnGrpID = spGetLastIncrementedId([Tovar])
                     ELSE 
                        lnTvrID = spGetLastIncrementedId([Tovar])
                        USE TvrLookUp IN 0 NODATA 
                        INSERT INTO TvrLookUp (TLUTypeId, TvrId, TvrQnt,TLU,TLUComment,TLUIsMain,TluMsuId) ;
                                       VALUES (9 , lnTvrID ,1,cBarCode ,'',.t.,lnMsuID ) 
                        llResult = TABLEUPDATE(1,.T.,[TvrLookUp])
                        IF !llResult 
                             SELECT  TvrLookUp
                             TABLEREVERT(.t.)
                        ENDIF 
                 ENDIF
             ELSE 
                 SELECT  Tovar
                 TABLEREVERT(.t.)
             ENDIF 
           ELSE
               IF EMPTY(cEd_izm)
                       lnGrpID = tmpTvr.TvrId
               ENDIF 
        ENDIF 
         USE IN SELECT('tmpTvr ')
         USE IN SELECT('Tovar')
         USE IN SELECT('TvrLookUp')
       
 
     
*!*          SELECT tmp   
*!*          APPEND BLANK  
*!*          REPLACE TvrNm WITH NVL(cTvrNm,'') ,;
*!*                  CatNM WITH NVL(cCatNM,'') ,;
*!*                  BarCode WITH NVL(cBarCode ,'') ,;
*!*                  Ed_izm WITH NVL(cEd_izm,'') ,;
*!*                  GrpNM WITH NVL(cGrpNM,'') 
         ii=ii+1  
  ENDDO   
    
  XLRelek.application.quit &&Закрываю. Можете и не закрывать для сверки  
*!*      IF RECCOUNT('tmp')=0  
*!*          MESSAGEBOX('В выбранном файле нет платежей.','Внимание!')  
*!*          USE IN tmp  
*!*      ENDIF   