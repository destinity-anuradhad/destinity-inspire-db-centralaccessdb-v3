

-- [Admin_SP] 'EventReservations','Sacith Nuwan Kalehe Watta'
create PROCEDURE [dbo].[Admin_SP]
	@TableName NVARCHAR(200),
	@CopyRights NVARCHAR(250)
AS
BEGIN

--DECLARE @TableName NVARCHAR(500)
--DECLARE @CopyRights NVARCHAR(500)
--SET @TableName = 'Clients'
--SET @CopyRights = '-- By Sachith Nuwan Kalehe Watta'

SET @CopyRights = '--'+@CopyRights

SELECT 
COLUMN_NAME,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH,IS_NULLABLE,COLUMN_DEFAULT
INTO #tempTable
FROM
INFORMATION_SCHEMA.COLUMNS
WHERE
TABLE_NAME = @TableName

DECLARE @InsertQuery NVARCHAR(MAX)
DECLARE @InsertColomns NVARCHAR(MAX)
DECLARE @InsertValues NVARCHAR(MAX)

DECLARE @UpdateQuery NVARCHAR(MAX)
DECLARE @UpdateColomns NVARCHAR(MAX)
DECLARE @UpdateValues NVARCHAR(MAX)

DECLARE @Parameters NVARCHAR(MAX)
DECLARE @AllColomns NVARCHAR(MAX)

DECLARE @Count INT
DECLARE @CurrentColomn NVARCHAR(50)
DECLARE @CurrentDataType NVARCHAR(50)
DECLARE @CurrentDataLength INT
DECLARE @CurrentIsNullable NVARCHAR(10)
DECLARE @CurrentColumnDefault NVARCHAR(100) =NULL

DECLARE @LikeColomns NVARCHAR(MAX)

SET @InsertColomns = CHAR(9)+'INSERT INTO '+@TableName+CHAR(10)+CHAR(9)+CHAR(9)+'('
SET @InsertValues = CHAR(9)+CHAR(9)+'VALUES'+CHAR(10)+CHAR(9)+CHAR(9)+'('

SET @UpdateQuery = CHAR(9)+'UPDATE '+@TableName+CHAR(10)+CHAR(9)+CHAR(9)+'SET'+CHAR(10)
SET @Parameters = ''
SET @AllColomns = ''
SET @Count = 0
SET @LikeColomns = ''

WHILE EXISTS(SELECT *  FROM #tempTable) 
BEGIN

	SELECT TOP 1 
	@CurrentColomn=COLUMN_NAME, 
	@CurrentDataType =DATA_TYPE,
	@CurrentDataLength = CHARACTER_MAXIMUM_LENGTH,
	@CurrentIsNullable = IS_NULLABLE,
	@CurrentColumnDefault = COLUMN_DEFAULT
	FROM #tempTable	

	

	IF @Count = 0
	BEGIN
		IF @CurrentColomn <> 'Id'
		BEGIN
			SET @InsertColomns = @InsertColomns+@CurrentColomn
			SET @InsertValues = @InsertValues+'@'+@CurrentColomn
			SET @UpdateQuery = @UpdateQuery+CHAR(9)+CHAR(9)+ @CurrentColomn +'=@' +@CurrentColomn
		END			
	END
	ELSE
	BEGIN
		IF @CurrentColomn <> 'Id'
		BEGIN
			SET @InsertColomns = @InsertColomns+' ,'+@CurrentColomn
			SET @InsertValues = @InsertValues+' ,@'+@CurrentColomn
			SET @UpdateQuery = @UpdateQuery +','+CHAR(10)+CHAR(9)+CHAR(9)+@CurrentColomn+'=@' +@CurrentColomn
		END			
	END	

	-- adding data typelenghth
	SET @CurrentDataType = CASE @CurrentDataType 
	WHEN 'nvarchar'
	THEN @CurrentDataType+'('+CONVERT(NVARCHAR(10),@CurrentDataLength)+')'
	WHEN 'varchar'
	THEN @CurrentDataType+'('+CONVERT(NVARCHAR(10),@CurrentDataLength)+')'
	WHEN 'int'
	THEN @CurrentDataType
	WHEN 'decimal'
	THEN @CurrentDataType+'(18,2)'
	WHEN 'money'
	THEN @CurrentDataType
	ELSE 
	@CurrentDataType
	END
	-- end of adding data typelenghth

	-- adding nullable and defualt
	IF @CurrentColumnDefault IS NULL
	BEGIN
		SET @CurrentDataType = CASE @CurrentIsNullable 
		WHEN 'YES'
		THEN @CurrentDataType+' = NULL'
		ELSE 
			@CurrentDataType
		END
	END
	ELSE
	BEGIN
		IF @CurrentDataType <> 'datetime'
		BEGIN

			SET @CurrentDataType = 
			@CurrentDataType +' = '+(
										CASE @CurrentDataType WHEN 'datetime' 
										THEN '' --@CurrentColumnDefault 
										ELSE REPLACE(REPLACE(@CurrentColumnDefault,'((',''),'))','') 
										END
									)
		END
	END
	-- end of adding nullable and defualt


	IF @CurrentColomn <> 'Id'
	BEGIN
		SET @Parameters = @Parameters+ ','+CHAR(10)+CHAR(9)+ '@'+@CurrentColomn+CHAR(9)+@CurrentDataType

		-- like colomns
		SET @LikeColomns = @LikeColomns+CHAR(10) +CHAR(9)+CHAR(9)+'OR '+@CurrentColomn+' LIKE ''%''+@Keyword+''%'''
		-- end of like colomns

		SET @Count = @Count+1
	END
	ELSE
	BEGIN
		SET @Parameters = @Parameters+CHAR(9)+'@'+@CurrentColomn+CHAR(9)+@CurrentDataType
		-- like colomns
		SET @LikeColomns = @LikeColomns +CHAR(9)+@CurrentColomn+' LIKE ''%''+@Keyword+''%'''
		-- end of like colomns
	END


	DELETE TOP (1) FROM #tempTable
END


SET @InsertQuery = @InsertColomns+') '+CHAR(10)+@InsertValues+')'
SET @UpdateQuery = @UpdateQuery + CHAR(10)+CHAR(9)+CHAR(9)+'WHERE Id=@Id'

DROP TABLE #tempTable

--PRINT @Parameters
--PRINT @InsertQuery
--PRINT @UpdateQuery

DECLARE @spInsert NVARCHAR(MAX)
DECLARE @spSelect NVARCHAR(MAX)
DECLARE @spSelectById NVARCHAR(MAX)
DECLARE @spSelectWithLike NVARCHAR(MAX)
DECLARE @spDelete NVARCHAR(MAX)


--- insert ----------------
SET @spInsert = 
'CREATE PROCEDURE '+@TableName+'_M_Save'+CHAR(10)+
@Parameters+CHAR(10)+
'AS'+CHAR(10)+
'BEGIN'+CHAR(10)+CHAR(10)+
CHAR(10)+@CopyRights+CHAR(10)+'-- @'+CONVERT(NVARCHAR(50),GETDATE())+CHAR(10)+CHAR(10)+
CHAR(9)+'SET NOCOUNT ON;'+CHAR(10)+
CHAR(9)+'SET DATEFORMAT DMY'+CHAR(10)+CHAR(10)+

CHAR(9)+'IF @Id = 0'+CHAR(10)+
CHAR(9)+'BEGIN'+CHAR(10)+
CHAR(9)+@InsertQuery+CHAR(10)+
CHAR(9)+'END'+CHAR(10)+
CHAR(9)+'ELSE'+CHAR(10)+
CHAR(9)+'BEGIN'+CHAR(10)+
CHAR(9)+@UpdateQuery+CHAR(10)+
CHAR(9)+'END'++CHAR(10)+
'END'


--- select ----------------
SET @spSelect = 
'CREATE PROCEDURE '+@TableName+'_M_Select'+CHAR(10)+
'AS'+CHAR(10)+
'BEGIN'+CHAR(10)+CHAR(10)+
CHAR(10)+@CopyRights+CHAR(10)+'-- @'+CONVERT(NVARCHAR(50),GETDATE())+CHAR(10)+CHAR(10)+
CHAR(9)+'SET NOCOUNT ON;'+CHAR(10)+
CHAR(9)+'SET DATEFORMAT DMY'+CHAR(10)+CHAR(10)+
CHAR(9)+'SELECT * FROM '+@TableName+CHAR(10)+
'END'

--- select by id ----------------
SET @spSelectById = 
'CREATE PROCEDURE '+@TableName+'_M_SelectById'+CHAR(10)+
'@Id  INT'+CHAR(10)+
'AS'+CHAR(10)+
'BEGIN'+CHAR(10)+CHAR(10)+
CHAR(10)+@CopyRights+CHAR(10)+'-- @'+CONVERT(NVARCHAR(50),GETDATE())+CHAR(10)+CHAR(10)+
CHAR(9)+'SET NOCOUNT ON;'+CHAR(10)+
CHAR(9)+'SET DATEFORMAT DMY'+CHAR(10)+CHAR(10)+
CHAR(9)+'SELECT * FROM '+@TableName+' WHERE Id=@Id'+CHAR(10)+
'END'

--- select with like----------------
SET @spSelectWithLike = 
'CREATE PROCEDURE '+@TableName+'_M_Search'+CHAR(10)+
'@Keyword  NVARCHAR(100) = '''''+CHAR(10)+
'AS'+CHAR(10)+
'BEGIN'+CHAR(10)+CHAR(10)+
CHAR(10)+@CopyRights+CHAR(10)+'-- @'+CONVERT(NVARCHAR(50),GETDATE())+CHAR(10)+CHAR(10)+
CHAR(9)+'SET NOCOUNT ON;'+CHAR(10)+
CHAR(9)+'SET DATEFORMAT DMY'+CHAR(10)+CHAR(10)+
CHAR(9)+'SELECT * '+CHAR(10)+CHAR(9)+'FROM '+@TableName+CHAR(10)+
CHAR(9)+'WHERE'+
CHAR(9)+'LEN(@Keyword) = 0'+CHAR(10)+
CHAR(9)+'OR '+CHAR(10)+CHAR(9)+'('+@LikeColomns+CHAR(10)+CHAR(9)+')'+CHAR(10)+
'END'



--- delete --------------------------------
SET @spDelete = 
'CREATE PROCEDURE '+@TableName+'_M_Delete'+CHAR(10)+
CHAR(9)+'@Id	INT'+CHAR(10)+
'AS'+CHAR(10)+
'BEGIN'+CHAR(10)+CHAR(10)+
CHAR(10)+@CopyRights+CHAR(10)+'-- @'+CONVERT(NVARCHAR(50),GETDATE())+CHAR(10)+CHAR(10)+
CHAR(9)+'SET NOCOUNT ON;'+CHAR(10)+
CHAR(9)+'SET DATEFORMAT DMY'+CHAR(10)+CHAR(10)+
CHAR(9)+'DELETE FROM '+@TableName+' WHERE Id=@Id'+CHAR(10)+
'END'


PRINT @spInsert
PRINT CHAR(10) PRINT CHAR(10)
PRINT @spSelectWithLike
PRINT CHAR(10) PRINT CHAR(10)
PRINT @spSelect
PRINT CHAR(10) PRINT CHAR(10)
PRINT @spSelectById
PRINT CHAR(10) PRINT CHAR(10)
PRINT @spDelete

--EXEC (@spInsert)
--EXEC (@spSelect)
--EXEC (@spSelectById)
--EXEC (@spDelete)
--EXEC (@spSelectWithLike)



END

GO

