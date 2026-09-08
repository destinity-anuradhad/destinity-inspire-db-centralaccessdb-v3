--exec Central_User_T_Select @Username='Stehani',@Password='123'
-- =============================================
-- Author		:	Ayomi Gunasekara
-- Create date	:	2020-11-11
-- Description	:	User Select
-- =============================================
CREATE PROCEDURE [dbo].[Central_User_T_Select]
	@Username as NVARCHAR(50),
	@Password as NVARCHAR(50)
AS
BEGIN	
	SET NOCOUNT ON;

	SELECT * FROM  Central_Users
	WHERE UserName = @Username 
	--AND Password = @Password

	--IF EXISTS (SELECT 1 FROM Central_Users WHERE UserName <> @Username)
	--BEGIN
	--	RAISERROR('No user found with entered username.',16,1)
	--END

	--ELSE IF EXISTS(SELECT 1 FROM Central_Users WHERE Password <> @Password)
	--BEGIN
	--	RAISERROR('Invalid credentials. Please check and try again.',16,1)
	--END

END

GO

