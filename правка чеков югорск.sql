UPDATE [basis].[dbo].[CheckTrans]
   SET [CheckTransID] = [CheckTransUID]
 WHERE [CheckTransIsDisc]  IS NULL
GO

UPDATE [CT]
   SET [CheckTransID] = CT1.CheckTransUID
FROM CheckTrans AS CT
JOIN CheckTrans AS CT1
	ON CT.CheckID = CT1.CheckID
	AND CT.CheckTransTvrId = CT1.CheckTransTvrId
	AND CT1.CheckTransIsDisc IS null
	WHERE CT.CheckTransIsDisc = 1
GO

