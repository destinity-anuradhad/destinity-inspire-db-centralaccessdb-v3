CREATE PROCEDURE [dbo].[Central_AuthenticationMethords_M_Select]
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:35PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * FROM Central_AuthenticationMethords
	WHERE [Name]<>'NULL'
END

GO

