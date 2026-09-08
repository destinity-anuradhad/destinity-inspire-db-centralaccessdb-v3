-- =============================================
-- Author:		Chiraj
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UserRoleWisePages_M_Select_ById]
@RoleId			  INT,
@MainNavigationId INT,
@PropertyId INT

AS
BEGIN	
	SET NOCOUNT ON;

	SELECT * FROM UserRoleWisePages
	Where 
	RoleId = @RoleId 
	AND MainNavigationId = @MainNavigationId 
	AND PropertyId=@PropertyId

END

GO

