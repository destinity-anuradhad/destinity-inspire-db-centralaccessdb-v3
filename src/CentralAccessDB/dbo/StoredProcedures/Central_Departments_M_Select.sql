CREATE PROCEDURE [dbo].[Central_Departments_M_Select]
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:40PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * FROM Central_Departments
	WHERE [Name]<>'NULL'

END

GO

