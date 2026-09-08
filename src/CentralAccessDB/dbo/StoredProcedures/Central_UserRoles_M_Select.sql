CREATE PROCEDURE [dbo].[Central_UserRoles_M_Select]
AS
BEGIN


--Stehani
-- @Nov  9 2020 10:45AM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * FROM Central_UserRoles
	WHERE [Name]<>'NULL'
	ORDER BY [Name] asc
END

GO

