
CREATE PROCEDURE [dbo].[Central_Designations_M_SelectById]
@Id  INT
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:44PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * FROM Central_Designations WHERE Id=@Id
END

GO

