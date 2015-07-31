
*27.04.2005 15:57 ->Объявление и инициализация переменных
LOCAL	laFrmType[2], ;
		laOUID[5], ;
		laIspClt[2], ;
		lnFrmTypeID, ;
		ltFrmDate, ;
		lcFrmNum, ;
		lnFrmStatusID, ;
		lnPointEmiOUID, ;
		lnPointEmiCltID, ;
		lnPointIspOUID, ;
		lnPointIspCltID, ;
		lnFrmCurTypeID, ;
		lnFrmID, ;
		lnTvrId, ;
		lnMsuId, ;
		lnTvrQnt, ;
		lnTvrPrcBuy, ;
		lnTvrPrcSale, ;
		lnTvrCurTypeId
***
laFrmType[1] = 1
laFrmType[2] = 3
***
laOUID[1] = 2
laOUID[2] = 3
laOUID[3] = 4
laOUID[4] = 6
laOUID[5] = 7
***
laIspClt[1] = 7
laIspClt[2] = 8
*------------------------------------------------------------------------------


*27.04.2005 15:44 ->Генерируем 100 документов
FOR lnDocumentCount = 1 TO 100
	
	*27.04.2005 15:52 ->Сочиняем параметры документа   
	lnFrmTypeID		= laFrmType(ROUND(RAND(),0)+1)
	ltFrmDate		= DATETIME() &&DTOT({01.01.2005}+ROUND(RAND()*365,0))
	lcFrmNum		= ALLTRIM(STR(lnDocumentCount,3,0))
	lnFrmStatusID	= 1
	lnPointEmiOUID	= IIF(lnFrmTypeID=1,0,laOUID(ROUND(RAND()*4,0)+1))
	lnPointEmiCltID = IIF(lnFrmTypeID=1,10,0)
	lnPointIspOUID	= IIF(lnFrmTypeID=1,laOUID(ROUND(RAND()*4,0)+1),0)
	lnPointIspCltID = IIF(lnFrmTypeID=1,0,laIspClt(ROUND(RAND(),0)+1))
	lnFrmCurTypeID	= 1
	*------------------------------------------------------------------------------
	
	*27.04.2005 16:07 ->Добавляем заголовок документа
	INSERT INTO Form ( ;
		FrmTypeID, ;
		FrmDate, ;
		FrmNum, ;
		FrmStatusID, ;
		PointEmiOUID, ;
		PointEmiCltID, ;
		PointIspOUID, ;
		PointIspCltID, ;
		FrmCurTypeID ;
	) VALUES ( ;
		lnFrmTypeID, ;
		ltFrmDate, ;
		lcFrmNum, ;
		lnFrmStatusID, ;
		lnPointEmiOUID, ;
		lnPointEmiCltID, ;
		lnPointIspOUID, ;
		lnPointIspCltID, ;	
		lnFrmCurTypeID ;
	)
	*------------------------------------------------------------------------------
	
	*27.04.2005 16:23 ->Получим идентификатор вновь добавленного документа
	lnFrmID = spGetLastIncrementedID([Form])
	*------------------------------------------------------------------------------
	
	*27.04.2005 16:22 ->Генериуем 100 ног
	FOR lnFrmPartTvrCounter = 1 TO 100
		
		*27.04.2005 16:29 ->Сочиняем параметры ноги
		lnTvrId			= ROUND(RAND(),0)+3
		lnMsuId			= 1
		lnTvrQnt		= 0.01 + ROUND(RAND()*1000,2)
		lnTvrPrcBuy		= 0.01 + ROUND(RAND()*1000,2)
		lnTvrPrcSale	= 0.01 + ROUND(RAND()*1000,2)
		lnTvrCurTypeId  = 1
		*------------------------------------------------------------------------------
		
		*27.04.2005 16:28 ->Добавляем ногу
		INSERT INTO FrmPartTvr ( ;
			FrmID, ;
			TvrId, ;
			MsuId, ;
			TvrQnt, ;
			TvrPrcBuy, ;
			TvrPrcSale, ;
			TvrCurTypeId ;
		) VALUES ( ;
			lnFrmID, ;
			lnTvrId, ;
			lnMsuId, ;
			lnTvrQnt, ;
			lnTvrPrcBuy, ;
			lnTvrPrcSale, ;
			lnTvrCurTypeId ;		
		)
		*------------------------------------------------------------------------------
	   
	ENDFOR &&* lnFrmPartTvrCounter = 1 TO 10
	*------------------------------------------------------------------------------

ENDFOR &&* lnDocumentCount = 1 TO 100
*------------------------------------------------------------------------------