
CREATE PROCEDURE [dbo].[Central_Departments_M_SelectById]
@Id  INT
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:40PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * FROM Central_Departments WHERE Id=@Id
END

GO

