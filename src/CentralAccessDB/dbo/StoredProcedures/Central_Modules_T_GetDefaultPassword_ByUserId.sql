-- =============================================
-- Author		:	Stehani 
-- Create date	:	2020-11-16
-- Description	:	Get Default Password By UserId
-- =============================================
---EXEC Central_Modules_T_GetDefaultPassword_ByUserId @UserId=1
CREATE PROCEDURE [dbo].[Central_Modules_T_GetDefaultPassword_ByUserId]
	@UserId INT
AS
BEGIN
	DECLARE @PasswordPolicyId INT
	DECLARE @DefaultPassword NVARCHAR(100)
	DECLARE @len INT =10,
			@min TINYINT = 48,
			@range TINYINT = 74,
			@exclude NVARCHAR(50) = '0:;<=>?@O[]`^\/'

	DECLARE @char CHAR
    SET @DefaultPassword = ''

	WHILE (@len > 0) 
		BEGIN
       SELECT @char = CHAR(round(rand() * @range + @min, 0))
		   IF (charindex(@char, @exclude) = 0 )
		   BEGIN
			   SET @DefaultPassword += @char
			   SET @len = @len - 1
		   END
		END

	SET @PasswordPolicyId = (SELECT [PasswordPolicyId] FROM [dbo].[Central_Users] WHERE [Id]=@UserId)
	
	SELECT 
		[Id],
		[PasswordPolicyId],
		@DefaultPassword AS 'DefaultPassword'
	FROM [dbo].[Central_Users] 
	WHERE [Id] = @UserId AND [PasswordPolicyId] = @PasswordPolicyId
END

GO

