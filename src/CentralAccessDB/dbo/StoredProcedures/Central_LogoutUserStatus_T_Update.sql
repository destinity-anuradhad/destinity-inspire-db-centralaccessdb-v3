CREATE PROCEDURE [dbo].[Central_LogoutUserStatus_T_Update]
@Id INT,
@Token NVARCHAR(max),
@UserId INT=-1
AS
BEGIN

	DECLARE @Uuid NVARCHAR(max)
	SET @Uuid = @Token

	IF (ISNULL(@Uuid,'empty')='empty')
		BEGIN
			UPDATE	[CentralAccessDB]..[Central_UserWiseModuleLogin]
			SET [IsActive] = 0
			WHERE [UserId]= @Id
		END
	ELSE
		BEGIN
			
			UPDATE	[CentralAccessDB]..[Central_UserWiseModuleLogin]
			SET [IsActive] = 0
			WHERE [UserId]= @Id AND Uuid=@Token
		END
		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_UserWiseModuleLogin',@Id,'CA','UWMLCU','U',@UserId,@Id, @Token
		-- End of Audit trail ---------------------
END

--exec Central_LogoutUserStatus_T_Update @Id=46 @Token="e96ec311-54c9-4318-ba21-7867ef10c09c"

GO

