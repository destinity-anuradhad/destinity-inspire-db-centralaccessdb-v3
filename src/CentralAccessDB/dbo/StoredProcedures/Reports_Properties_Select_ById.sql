
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--[dbo].[Reports_UserRoles_Select_ByUserId]1
CREATE PROCEDURE [dbo].[Reports_Properties_Select_ById]
	@PropertyId INT
AS
BEGIN

	SELECT * FROM Central_Properties 
	WHERE Id = @PropertyId


END

GO

