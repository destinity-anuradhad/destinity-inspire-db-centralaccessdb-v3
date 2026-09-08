
CREATE PROCEDURE [dbo].[Central_Users_M_Select]
---exec [Central_Users_M_Select] 4169

	@UserId INT =0--,
	--@PropertyId INT
AS
BEGIN

	SET NOCOUNT ON;
	SET DATEFORMAT DMY
------------- Filter Users by Ganguli on 2022-03-11 --------------
--DECLARE @UserId INT --4269

DECLARE @AccessibleProperties TABLE
(
	PropertyId INT
)

INSERT INTO @AccessibleProperties
(PropertyId)
SELECT DISTINCT PropertyId FROM Central_UserWiseProperties WHERE UserId=@UserId

-------------END-----Filter Users by Ganguli on 2022-03-11 --------------

------------ Filter Users by Ganguli on 2022-08-16--------------
--DECLARE @AccessibleUsers TABLE
--(
--	Id INT,
--	UserId INT,
--	PropertyId INT,
--	UserName Nvarchar(50),
--	PropertyName Nvarchar(50)

--)

	--INSERT INTO @AccessibleUsers
	--(Id,UserId,PropertyId,UserName,PropertyName)
	--SELECT  UP.Id,UP.UserId,UP.PropertyId,U.UserName,P.Name
	--FROM [Central_UserWiseProperties]	UP
	--INNER JOIN Central_Users			U ON UP.UserId=U.Id
	--INNER JOIN Central_Properties		P ON P.Id=UP.PropertyId
	--Where P.Id=@PropertyId

--select * from @AccessibleUsers
-------------END-----Filter Users by Ganguli on 2022-03-11 --------------

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
	FROM	Central_Users WITH(NOLOCK)
	--WHERE Id IN (SELECT UserId FROM Central_UserWiseProperties WHERE PropertyId IN (SELECT PropertyId FROM @AccessibleProperties))
	ORDER BY FullName ASC
---------------------------------------------------------
END

GO

