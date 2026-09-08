
----exec Report_UserAccessSummary_Select 1
CREATE PROCEDURE [dbo].[Report_UserAccessSummary_Select]
	@PropertyId INT
AS
BEGIN
	SELECT A.Id AS UserId,
		   A.FullName,
		   A.UserName,
		   A.MobileNumber,
		   A.Email,
		   (CASE WHEN A.IsLoked=1 THEN 'Locked' ELSE 'Unlocked' END)+' / '+(CASE WHEN A.IsActive=1 THEN 'Active' ELSE 'Inactive' END) AS ActiveStatus,
		 --  ISNULL(CONVERT(nvarchar,(A.TerminationDate),20),'') AS PwdExpDate,
		   A.LastLoginDate,
		  ISNULL((SELECT TOP 1 CONVERT(NVARCHAR,PasswordExpired,20) FROM Central_UserPasswordResetExpiredDetails with (nolock) WHERE UserId=A.Id order by PasswordExpired desc),'') AS PwdExpDate,
		  ISNULL((SELECT TOP 1 CONVERT(NVARCHAR,PasswordReset,20) FROM Central_UserPasswordResetExpiredDetails with (nolock) WHERE UserId=A.Id order by PasswordReset desc),'') AS PwdResetDate
	FROM Central_Users A with (nolock)
	Order by FullName ASc
END
---select * from Central_Users

GO

