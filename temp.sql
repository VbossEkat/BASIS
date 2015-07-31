

ALTER PROCEDURE [dbo].[spTvrSetEditSetPrepare] (@tnTvrSetID int) AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

/*Iauyaeaiea e eieoeaeecaoey ia?aiaiiuo*/
DECLARE
	@llBindTLU bit, 
	@llFilterByTLUType bit, 
	@llFilterByTvrType bit

/*Iieo?ei eioi?iaoe? i iaai?a*/
SELECT 
	@llBindTLU = TvrSet.BindTLU, 
	@llFilterByTLUType = TvrSet.FilterByTLUType, 
	@llFilterByTvrType = TvrSet.FilterByTvrType 
FROM TvrSet
WHERE TvrSet.TvrSetID = @tnTvrSetID

DECLARE @SQL varchar(8000)
SET @SQL = 

	/*Iauyaeaiea e eieoeaeecaoey ia?aiaiiuo*/
	'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED '+
	'DECLARE
		@lnCurLevel int
	DECLARE
		@TvrInSet table (TvrID int,TluID int,TvrParID int,TvrIsCnt bit,Level int,TvrNM varchar(80),ListNumber int,Mark int)
	SET @lnCurLevel = 0 ' + 

	/*Iieo?aai nienie oiaa?ia*/
	'INSERT INTO @TvrInSet 
	SELECT 
		Tovar.TvrId, ' + 
		CASE WHEN @llBindTLU = 1 THEN 'TvrLookUp.TluID' ELSE 'NULL AS TluID' END + ', ' + 
		'Tovar.TvrParId, 
		CAST(0 AS bit) AS TvrIsCnt, 
		@lnCurLevel AS Level, ' + 
		CASE WHEN @llBindTLU = 1 THEN 'Tovar.TvrNM+'' (''+TvrLookUp.TLU+'')'' AS TvrNM' ELSE 'Tovar.TvrNM AS TvrNM' END + ', ' + 
		'ISNULL(TvrInSet.ListNumber,0) AS ListNumber, 
		Mark = CASE WHEN TvrInSet.TvrInSetID IS NULL THEN 0 ELSE 1 END
	FROM Tovar 
	INNER JOIN TvrType ON TvrType.TvrTypeIsCnt = 0 AND Tovar.TvrTypeID = TvrType.TvrTypeID ' + 
	CASE WHEN @llBindTLU = 1 THEN 'INNER JOIN TvrLookUp ON TvrLookUp.TvrID = Tovar.TvrID' ELSE '' END + ' ' + 
	CASE WHEN @llFilterByTLUType = 1 THEN 'INNER JOIN TvrSetTLUType ON TvrSetTLUType.TLUTypeID = TvrLookUp.TLUTypeID AND TvrSetTLUType.TvrSetID = ' + CONVERT(varchar(10),@tnTvrSetID) ELSE '' END + ' ' + 
	CASE WHEN @llFilterByTvrType = 1 THEN 'INNER JOIN TvrSetTvrType ON TvrSetTvrType.TvrTypeID = Tovar.TvrTypeID AND TvrSetTvrType.TvrSetID = ' + CONVERT(varchar(10),@tnTvrSetID) ELSE '' END + ' ' + 
	'LEFT JOIN TvrInSet ON TvrInSet.TvrSetID = ' + CONVERT(varchar(10),@tnTvrSetID) + ' AND TvrInSet.TvrID = Tovar.TvrID' + 
	CASE WHEN @llBindTLU = 1 THEN ' AND TvrInSet.TLUID = TvrLookUp.TLUID' ELSE ' AND TvrInSet.TLUID IS NULL' END + ' ' + 

	/*Auae?aai ?iaeoaeae*/
	'SELECT 
		tmpTvrInSet.TvrParId AS TvrID, 
		SUM(1) AS ItemCount, 
		SUM(CASE WHEN tmpTvrInSet.Mark=1 THEN 1 ELSE 0 END) AS MarkItemCount, 
		SUM(CASE WHEN tmpTvrInSet.Mark=2 THEN 1 ELSE 0 END) AS PartMarkItemCount 
	INTO #curParent 
	FROM @TvrInSet tmpTvrInSet 
	WHERE NOT tmpTvrInSet.TvrParId IS NULL 
	GROUP BY tmpTvrInSet.TvrParId ' + 

	/*A oeeea aiaaaeyai anao ?iaeoaeae*/
	'WHILE @@rowcount>0 AND @lnCurLevel < 1000 
	begin 

		SELECT @lnCurLevel=@lnCurLevel+1 ' + 

		/*Aiaaaeyai ?iaeoaeae oaeouaai o?iaiy*/
		'DELETE FROM @TvrInSet WHERE TvrID IN (SELECT #curParent.TvrID FROM #curParent) 
		INSERT INTO @TvrInSet 
		SELECT 
			Tovar.TvrId, 
			NULL AS TLUId, 
			Tovar.TvrParId, 
			CAST(1 AS bit) AS TvrIsCnt, 
			@lnCurLevel AS Level, 
			Tovar.TvrNM AS TvrNM, 
			0 AS ListNumber, 
			CASE WHEN #curParent.MarkItemCount=#curParent.ItemCount THEN 1 WHEN #curParent.MarkItemCount+#curParent.PartMarkItemCount>0 THEN 2 ELSE 0 END AS Mark 
		FROM Tovar 
		INNER JOIN #curParent ON #curParent.TvrID = Tovar.TvrID ' + 

		/*I?euaai eo?ni?*/
		'DELETE FROM #curParent ' + 

		/*Auae?aai ?iaeoaeae neaao?uaai o?iaiy*/
		'INSERT INTO #curParent 
		SELECT 
			Tovar.TvrID, 
			SUM(1) AS ItemCount, 
			SUM(CASE WHEN tmpTvrInSet.Mark=1 THEN 1 ELSE 0 END) AS MarkItemCount, 
			SUM(CASE WHEN tmpTvrInSet.Mark=2 THEN 1 ELSE 0 END) AS PartMarkItemCount 
		FROM Tovar 
		LEFT JOIN @TvrInSet tmpTvrInSet ON tmpTvrInSet.TvrParID = Tovar.TvrID 
		WHERE Tovar.TvrID IN (SELECT curPrevParent.TvrParID FROM @TvrInSet curPrevParent WHERE curPrevParent.Level = @lnCurLevel) 
		GROUP BY Tovar.TvrID

	end ' + 

	/*Auaa?ai oaiu ec i?aena aey aaiiiai iaai?a oiaa?ia*/
	'SELECT 
		Price.TvrID, 
		Price.Price 
	INTO #tmpTvrSetPrice
	FROM Price 
	INNER JOIN TvrSet ON TvrSet.PrcTypeID = Price.PrcTypeID 
	WHERE TvrSet.TvrSetID = ' + CONVERT(varchar(10),@tnTvrSetID) + ' ' + 
	
	/*I?eoaieyai ea?oeiee*/
	'SELECT 
		tmpTvrInSet.TvrID AS TKey, 
		tmpTvrInSet.TvrID, 
		ISNULL(tmpTvrInSet.TluID,0) AS TluID, 
		ISNULL(tmpTvrInSet.TvrParID,0) AS TvrParID, 
		tmpTvrInSet.TvrIsCnt, 
		tmpTvrInSet.TvrNM, 
		tmpTvrInSet.ListNumber, 
		tmpTvrInSet.Mark, 
		TvrType.BmpID AS BmpID, 
		TvrType.SelBmpID AS SBmpID, 
		TvrType.BmpMarkID AS BmpMID, 
		TvrType.SelBmpMarkID AS SBmpMID, 
		TvrType.BmpPartMarkID AS BmpPMID, 
		TvrType.SelBmpPartMarkID AS SBmpPMID, 
		ISNULL(#tmpTvrSetPrice.Price,0) AS Price 
	FROM @TvrInSet tmpTvrInSet 
	INNER JOIN Tovar ON Tovar.TvrID = tmpTvrInSet.TvrID 
	INNER JOIN TvrType ON TvrType.TvrTypeID = Tovar.TvrTypeID 
	LEFT  JOIN #tmpTvrSetPrice ON #tmpTvrSetPrice.TvrID = tmpTvrInSet.TvrID 
	ORDER BY tmpTvrInSet.TvrNM'

/*Auiieiyai aeiaie?aneee cai?in*/
exec(@SQL)