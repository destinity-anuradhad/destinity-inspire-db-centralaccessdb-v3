
CREATE PROCEDURE [dbo].[Central_PasswordPolicy_M_Delete]
	@Id	INT
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:48PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DELETE FROM Central_PasswordPolicy WHERE Id=@Id
END

GO

