CREATE PROCEDURE [dbo].[Central_AuthenticationMethords_M_SelectById]
@Id  INT
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:35PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * FROM Central_PasswordPolicyAttribute WHERE Id=@Id
END

GO

