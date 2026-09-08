-- =============================================
-- Author:	Chiraj
-- Create date: 2020-10-15
-- Description:Delete user
-- =============================================
CREATE PROCEDURE [dbo].[Users_M_Delete]
(
	@Id INT ,
	@PropertyId INT
)
AS
BEGIN	
	SET NOCOUNT ON;
	IF EXISTS (SELECT 1 FROM Users WHERE Id = @Id AND PropertyId=@PropertyId )
	BEGIN
		DELETE FROM Users WHERE Id = @Id AND PropertyId=@PropertyId 
		DELETE FROM UserWiseRoles WHERE UserId=@Id AND  PropertyId=@PropertyId
	END
	ELSE
	BEGIN
		RAISERROR('No record exists.',16,1)
	END	
END

GO

