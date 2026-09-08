
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--[dbo].[Reports_Users_Select_ById]-1
CREATE PROCEDURE [dbo].[Reports_Users_Select_ById]--1
	@UserId INT = -1
AS
BEGIN
	SELECT *, UserName As UsersName
	FROM Central_Users
	WHERE Id = @UserId

	UNION

	SELECT TOP 1 * ,'All' As UsersName
	FROM Central_Users
	WHERE  @UserId = -1
END

GO

