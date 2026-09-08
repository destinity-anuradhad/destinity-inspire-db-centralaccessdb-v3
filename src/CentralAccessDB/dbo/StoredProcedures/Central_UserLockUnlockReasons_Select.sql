CREATE PROCEDURE [dbo].[Central_UserLockUnlockReasons_Select] 
	@IsActive	INT = 0,
	@Code		VARCHAR(5)
AS
BEGIN
	SELECT *
	FROM	Central_UserLockUnlockReasons
	WHERE	(@IsActive = 0 OR IsActive = @IsActive) AND Process = @Code
END

GO

