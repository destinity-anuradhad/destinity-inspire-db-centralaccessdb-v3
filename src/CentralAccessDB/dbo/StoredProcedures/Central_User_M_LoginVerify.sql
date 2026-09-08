
---exec Central_User_M_LoginVerify 'serandib','1234',1
CREATE PROCEDURE [dbo].[Central_User_M_LoginVerify]
@UserName NVARCHAR(500),
@Password NVARCHAR(500),
@PropertyId INT

AS
BEGIN

    SET NOCOUNT ON	
	DECLARE @UserId Int
	DECLARE @UserPropertyId Int
	DECLARE @UserPassword  Nvarchar(MAX)
	DECLARE @UserUserDisplayName Nvarchar(100)
	DECLARE @UserIsActive BIT
	DECLARE @UserSalt Nvarchar(MAX)

	--Select 1

	 SET @UserId=(SELECT Id FROM [dbo].[Central_Users] WHERE UserName = @Username AND Password = (SELECT DBO.GetEncryption(@Password, @Username)))

     IF(@UserId IS NULL)
		   Select 0  As 'Access'
	 ELSE		  
		   Select 1 As 'Access'
		   update Central_UserWiseModuleLogin
		set  [LastCashierLoggedInDateTime]= GETDATE()
		WHERE [UserId] = @UserId
	   	   
END
--User_M_LoginVerify 'sweeni','123',0

GO

