
---exec Report_UserWiseModuleLoginDetails_Select 4206
CREATE PROCEDURE [dbo].[Report_UserWiseModuleLoginDetails_Select]
	@UserId INT
AS
BEGIN

	DECLARE @userName NVARCHAR(250)

	SELECT @userName = UserName 
	FROM Central_Users with(nolock)
	WHERE Id=@UserId

	SELECT *
	FROM 
	(
		SELECT DISTINCT
		@userName AS UserName,
		ISNULL(A.BrowserKey,'') AS Browser,
		ISNULL(A.IPAddress,'') AS Authority,
		A.TxnDateTime AS 'DateTime',
		(SELECT CASE Status WHEN 'S' THEN 'Success' ELSE 'Fail'END)As Status
		FROM [dbo].[Central_UserLoginAttempts] A with(nolock)
		WHERE A.UserId=@UserId 

		UNION

		SELECT DISTINCT
		@userName AS UserName,
		ISNULL(A.BrowserKey,'') AS Browser,
		ISNULL(A.IPAddress,'') AS Authority,
		A.TxnDateTime AS 'DateTime',
		(SELECT CASE Status WHEN 'S' THEN 'Success' ELSE 'Fail'END)As Status
		FROM [dbo].[Central_UserLoginAttempts_history] A with(nolock)
		WHERE A.UserId=@UserId 
	) AS X
	ORDER BY X.DateTime desc


END

--select * from Central_UserLoginAttempts where userid=4179
--select * from [dbo].[Central_UserWiseModuleLogin] where userid=4179

GO

