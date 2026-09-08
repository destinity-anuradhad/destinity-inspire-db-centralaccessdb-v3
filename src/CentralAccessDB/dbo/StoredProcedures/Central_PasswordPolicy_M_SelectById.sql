--EXEC Central_PasswordPolicy_M_SelectById @Id=3
CREATE PROCEDURE [dbo].[Central_PasswordPolicy_M_SelectById]
@Id  INT
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:48PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * FROM Central_PasswordPolicy WHERE Id=@Id
END

GO

