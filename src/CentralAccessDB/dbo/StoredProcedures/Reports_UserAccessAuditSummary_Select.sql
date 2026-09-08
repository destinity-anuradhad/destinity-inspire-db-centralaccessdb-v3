
---
---exec Reports_UserAccessAuditSummary_Select 4179,1,1,'2021-02-29 00:00:00','2021-05-03 00:00:00'
CREATE PROCEDURE [dbo].[Reports_UserAccessAuditSummary_Select]
@UserId INT,
@PropertyId INT,
@ModuleId INT,
@FromDate DATETIME,
@ToDate DATETIME
AS
BEGIN
	DECLARE @ModuleCode NVARCHAR(12) 
	SELECT @ModuleCode = Code FROM Central_Modules with (nolock) WHERE Id=@ModuleId

	SELECT 
	A.HotelDate AS BusDate,
	(SELECT Name FROM [HotelResWeb_AuditTail]..AuditTrialProcesses with (nolock) WHERE Code=A.Process) AS Process,
	(SELECT Name FROM [HotelResWeb_AuditTail]..AuditTrialActions with (nolock) WHERE Code=A.Action) AS Action,
	A.LogDate,
	ISNULL(A.Reference01,'-') AS Reference01,
	ISNULL(A.Reference02,'-') AS Reference02,
	ISNULL(A.Reference03,'-') AS Reference03,
	ISNULL(A.Reference04,'-') AS Reference04,
	ISNULL(A.Reference05,'-') AS Reference05
	FROM [HotelResWeb_AuditTail]..AuditTrailMaster A with (nolock)
	WHERE CAST(A.LogDate AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
	AND A.Module=@ModuleCode AND A.UserID=@UserId
END

GO

