
CREATE PROCEDURE [dbo].[Central_Users_M_Search]
@Keyword  NVARCHAR(100) = ''
AS
BEGIN


--Stehani
-- @Nov  9 2020  1:08PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT 
	[Id], [GroupId], [UserName], [Password], [FullName], [EmpNumber], ISNULL([Email],'-') AS [Email], ISNULL([MobileNumber],'-') AS [MobileNumber], [DesignationId], [DepartmentId], [AuhenticatedMethordId], [IsLoked], [IsPermanentlyLocked], [IsPasswordResetRequested], [LastLoginDate], [TerminationDate], [NextPasswordTerminationReminderOn], [LeagalIdnumber], [IsActive], [CreatedUserId], [ModifiedUserId], [CreatedDate], [ModifiedDate], [PasswordPolicyId], [LoginAttempts], [UniqueId]
	FROM Central_Users
	WHERE	LEN(@Keyword) = 0
	OR 
	(	Id LIKE '%'+@Keyword+'%'
		OR GroupId LIKE '%'+@Keyword+'%'
		OR UserName LIKE '%'+@Keyword+'%'
		OR Password LIKE '%'+@Keyword+'%'
		OR FullName LIKE '%'+@Keyword+'%'
		OR EmpNumber LIKE '%'+@Keyword+'%'
		OR Email LIKE '%'+@Keyword+'%'
		OR MobileNumber LIKE '%'+@Keyword+'%'
		OR DesignationId LIKE '%'+@Keyword+'%'
		OR DepartmentId LIKE '%'+@Keyword+'%'
		OR AuhenticatedMethordId LIKE '%'+@Keyword+'%'
		OR IsLoked LIKE '%'+@Keyword+'%'
		OR LastLoginDate LIKE '%'+@Keyword+'%'
		OR TerminationDate LIKE '%'+@Keyword+'%'
		OR LeagalIdnumber LIKE '%'+@Keyword+'%'
		OR IsActive LIKE '%'+@Keyword+'%'
		OR CreatedUserId LIKE '%'+@Keyword+'%'
		OR ModifiedUserId LIKE '%'+@Keyword+'%'
		OR CreatedDate LIKE '%'+@Keyword+'%'
		OR ModifiedDate LIKE '%'+@Keyword+'%'
	)
END

GO

