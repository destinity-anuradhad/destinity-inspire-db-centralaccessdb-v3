CREATE PROCEDURE [dbo].[Central_User_M_Select_ByUserName]
@UserName       NVARCHAR(250)
AS
BEGIN	

SELECT * FROM [dbo].[Central_Users] WHERE [UserName]=@UserName

END

GO

