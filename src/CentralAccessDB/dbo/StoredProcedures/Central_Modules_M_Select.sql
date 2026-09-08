CREATE PROCEDURE [dbo].[Central_Modules_M_Select]
AS
BEGIN


--Stehani
-- @Nov  9 2020  6:39PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * FROM Central_Modules
	WHERE [Name]<>'NULL'
END

GO

