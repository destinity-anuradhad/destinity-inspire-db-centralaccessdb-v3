
CREATE PROCEDURE [dbo].[Central_Users_M_SelectForPasswordReset]
AS
BEGIN
		SELECT Id,FullNAme,EmpNumber,ISNULL(IsLoked,0) AS IsLoked
		FROM Central_Users WITH(NOLOCK)
		WHERE IsActive=1
END

GO

