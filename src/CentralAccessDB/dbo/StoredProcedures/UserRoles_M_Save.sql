-- =============================================
-- Author:		Yasiru
-- Create date: 2017-09-07
-- Description:	User Roles
-- =============================================
CREATE PROCEDURE [dbo].[UserRoles_M_Save]
(
	@Id INT,
	@Name NVARCHAR(100),
	@UserId INT = -1,
	@Operation CHAR(1),
	@IsActive BIT,
	@PropertyId	INT
)

AS
BEGIN
SET NOCOUNT ON;
	IF(@Operation = 'I')
		BEGIN
			INSERT INTO UserRoles(Name, IsActive, CreatedUserId, CreatedDateTime, LastUpdatedUserId, LastUpdatedDateTime,IsUpload,PropertyId)
			VALUES(@Name, @IsActive,@UserId, GETDATE(), @UserId, GETDATE(),0,@PropertyId)
			--SET @Id = SCOPE_IDENTITY()
         END
		 ELSE IF(@Operation = 'U')
		 BEGIN
		 IF EXISTS (SELECT 1 FROM UserRoles WHERE Id = @Id)
		 BEGIN
			UPDATE  UserRoles
		    SET			
			Name = @Name,
			LastUpdatedDateTime = GETDATE(),
			LastUpdatedUserId = @UserId,
			IsActive = @IsActive,
			IsUpload=0
			WHERE Id = @Id AND PropertyId=@PropertyId
		END
		ELSE
		BEGIN
			RAISERROR('No record exists.',16,1)
		END		
	END
	ELSE
	BEGIN
		RAISERROR('Invalid operation',16,1)
	END


END

GO

