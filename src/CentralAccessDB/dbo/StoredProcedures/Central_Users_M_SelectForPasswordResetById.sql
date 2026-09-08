
CREATE PROCEDURE [dbo].[Central_Users_M_SelectForPasswordResetById]
@Id INT
AS
BEGIN
		SELECT Id,FullNAme,EmpNumber,ISNULL(IsLoked,0) AS IsLoked
		FROM Central_Users WITH(NOLOCK)
		WHERE Id=@Id

END

GO

