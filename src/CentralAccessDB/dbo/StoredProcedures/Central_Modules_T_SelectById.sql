
CREATE PROCEDURE [dbo].[Central_Modules_T_SelectById]
@Id  INT
AS
BEGIN

--Central_Modules_T_SelectById @Id=1
--Stehani
-- @Nov 16 2020  1:07PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * FROM Central_Modules WHERE Id=@Id
END

GO

