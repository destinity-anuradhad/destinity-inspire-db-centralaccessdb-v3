

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Reports_UserLoggingAttempts]
	@UserId INT = -1,
	@FromDate DateTime,
	@ToDate DateTime
AS
BEGIN
	
	SELECT (CASE Status WHEN 'S' THEN 'Success' ELSE 'Fail'END) As StatusName
	FROM [dbo].[Central_UserLoginAttempts] with(nolock)
	WHERE (@UserId = -1 OR UserId = @UserId) AND (TxnDateTime BETWEEN @FromDate AND @ToDate)

	SELECT (CASE Status WHEN 'S' THEN 'Success' ELSE 'Fail'END) As StatusName
	FROM [dbo].[Central_UserLoginAttempts_History] with(nolock)
	WHERE (@UserId = -1 OR UserId = @UserId) AND (TxnDateTime BETWEEN @FromDate AND @ToDate)	

END

GO

