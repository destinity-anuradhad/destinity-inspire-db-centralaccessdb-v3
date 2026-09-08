-- =============================================
-- Author:		Yasiru
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UserRoles_M_Delete]
(
	@Id INT ,
	@PropertyId INT 
)
AS
BEGIN	
	SET NOCOUNT ON;
	IF EXISTS (SELECT 1 FROM UserRoles WHERE Id = @Id)
	BEGIN
		DELETE FROM UserRoles WHERE Id = @Id AND PropertyId=@PropertyId
	END
	ELSE
	BEGIN
		RAISERROR('No record exists.',16,1)
	END	
END

GO

