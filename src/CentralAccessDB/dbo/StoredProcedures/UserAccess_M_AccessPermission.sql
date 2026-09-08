

-- =============================================
-- Author:		Chiraj
-- Create date: 2020-10-16
-- Description:	UserAccess_M_AccessPermission
-- =============================================
-- [dbo].[UserAccess_M_AccessPermission] 1,1,8,'S','[8]'
CREATE PROCEDURE [dbo].[UserAccess_M_AccessPermission]

@UserId		 INT,
@PropertyId INT,
@PageId      INT,
@Right		 CHAR(1),
@AltPages	NVARCHAR(MAX) 

AS
BEGIN	
	SET NOCOUNT ON;
	--IF(@UserId=71)
	--BEGIN
	--	Select 1
	--END
	--ELSE
	--BEGIN
		SELECT ISNULL(SUM(X.authorized),0)  
	From(
 		SELECT 
		CASE(@Right)
		WHEN 'S' THEN IsAllowSelect
		WHEN 'I' THEN IsAllowInsert
		WHEN 'D' THEN IsAllowDelete
		WHEN 'U' THEN IsAllowUpdate
		ELSE 0
		END  AS  authorized
		FROM
		UserWiseIndividualAccess  with (nolock)
		WHERE UserId = @UserId  AND PropertyId=1
		AND (	PageId = @PageId 
				OR PageId IN (	SELECT [value]
								FROM OPENJSON (@AltPages)
							)
			)


		UNION

		SELECT 
		CASE(@Right)
		WHEN 'S' THEN URWP.IsAllowSelect
		WHEN 'I' THEN URWP.IsAllowInsert
		WHEN 'D' THEN URWP.IsAllowDelete
		WHEN 'U' THEN URWP.IsAllowUpdate
		ELSE 0
		END AS  authorized
		FROM
		UserRoleWisePages AS URWP with (nolock)	
		INNER JOIN users AS UWR with (nolock) ON UWR.UserRoleId = URWP.RoleId
		WHERE UWR.Id = @UserId  
		AND (	URWP.PageId = @PageId 
				OR PageId IN (	SELECT [value]
								FROM OPENJSON (@AltPages)
							)
			)
)  AS X
	--END
	

END

GO

