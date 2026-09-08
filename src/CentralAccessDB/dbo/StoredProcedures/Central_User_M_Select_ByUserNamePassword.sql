CREATE PROCEDURE [dbo].[Central_User_M_Select_ByUserNamePassword]
@UserName       NVARCHAR(250),
@Password		NVARCHAR(250)
AS
BEGIN	

--SELECT * FROM [dbo].[Central_Users] WHERE [UserName]=@UserName
			SELECT	* 
			FROM	Central_Users with(nolock)
			WHERE	UserName = @Username 
			AND Password = (DBO.GetEncryption(@Password, @Username))

END

GO

