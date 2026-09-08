
--Central_Users_M_Select 
CREATE PROCEDURE [dbo].[Central_Users_M_Select_Exists20240108]
AS
BEGIN

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT	
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
	FROM	Central_Users
	ORDER BY FullName ASC
END

GO

