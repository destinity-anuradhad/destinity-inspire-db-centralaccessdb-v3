
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--[dbo].[Reports_UserRoles_Select_ByUserId]1
CREATE PROCEDURE [dbo].[Reports_Modules_Select_ById]--1
	@ModuleId INT
AS
BEGIN

	SELECT *,Name As ModuleName FROM Central_Modules
	WHERE Id = @ModuleId


END

GO

