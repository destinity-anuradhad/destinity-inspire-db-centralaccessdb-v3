CREATE PROCEDURE [dbo].[Central_UserWiseModuleLogin_T_Select]
AS
BEGIN


--Stehani
-- @Nov 25 2020 11:11AM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT	
	A.[Id],
	A.[UserId],
	A.[PropertyId],
	A.[ModuleId],
	A.[Uuid],
	CONVERT (VARCHAR,A.[TxnDateTime],100) AS TxnDate,
	A.[BrowserKey],
	A.[SessionID],
	A.[SessionStorageId],
	A.[LocalStorageId],
	A.[Authority],
	A.[IsActive],
	B.Name AS  'ModuleName', 
	C.Name AS 'PropertyName',  
	D.Username
	FROM Central_UserWiseModuleLogin A
	INNER JOIN Central_Modules B ON A.ModuleId = B.Id
	INNER JOIN Central_Properties C ON C.Id = A.PropertyId
	INNER JOIN Central_Users D ON D.Id = A.UserId
	WHERE A.[IsActive] = 1 ORDER BY A.[TxnDateTime] DESC
END

GO

