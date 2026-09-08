
CREATE PROCEDURE [dbo].[Central_Designations_M_Select]
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:44PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT [Id],[Name],[IsActive]
	FROM Central_Designations WITH(NOLOCK)
	WHERE [Name]<>'NULL'
	order by Name aSC
END

GO

