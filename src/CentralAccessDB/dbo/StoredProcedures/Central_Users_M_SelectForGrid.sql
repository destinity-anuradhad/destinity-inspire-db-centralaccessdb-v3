
CREATE PROCEDURE [dbo].[Central_Users_M_SelectForGrid]
AS
BEGIN
	SELECT TOP 10
		[Id]
      ,[GroupId]
      ,[UserName]
      ,[Password]
      ,[FullName]
      ,[EmpNumber]
      ,ISNULL([Email],'') AS Email
      ,ISNULL([MobileNumber],'') AS MobileNumber
      ,[DesignationId]
      ,[DepartmentId]
      ,[AuhenticatedMethordId]
      ,[IsLoked]
      ,[IsPermanentlyLocked]
      ,[IsPasswordResetRequested]
      ,[LastLoginDate]
      ,[TerminationDate]
      ,[NextPasswordTerminationReminderOn]
      ,[LeagalIdnumber]
      ,[IsActive]
      ,[CreatedUserId]
      ,[ModifiedUserId]
      ,[CreatedDate]
      ,[ModifiedDate]
      ,[PasswordPolicyId]
      ,[LoginAttempts]
      ,[UniqueId]
	FROM	Central_Users WITH(NOLOCK)
	--WHERE Id IN (SELECT UserId FROM Central_UserWiseProperties WHERE PropertyId IN (SELECT PropertyId FROM @AccessibleProperties))
	ORDER BY FullName ASC 
END

GO

