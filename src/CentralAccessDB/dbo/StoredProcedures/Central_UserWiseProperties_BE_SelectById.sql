CREATE PROCEDURE [dbo].[Central_UserWiseProperties_BE_SelectById]
@UserId  INT
AS
BEGIN


	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT PropertyId as Id,PropertyId as CompanyID FROM Central_UserWiseProperties WHERE UserId= @UserId
END

GO

