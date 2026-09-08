CREATE PROCEDURE [dbo].[Central_Outlets_T_Select]	
AS
BEGIN
	SELECT * FROM Central_Outlets
	WHERE [Name] <> 'NULL'
END

GO

