-- [dbo].[Central_UserAccess_M_AccessPermission]  4259,2010,'S', '[0]','d2c003c8-f578-4fd8-afed-02acf85819e1',3
CREATE PROCEDURE [dbo].[Central_UserAccess_M_AccessPermission] 

@UserId		 INT,	
@PageId      INT,
@Right		 CHAR(1),
@AltPages	NVARCHAR(MAX) ='',
@token		NVARCHAR(max)='',
@SwitchedPropertyId INT = -1

AS
BEGIN	
	SET NOCOUNT ON;

	--Select 1

	DECLARE @ModuleId INT
	DECLARE @PropertyId INT

	SET @ModuleId=(SELECT TOP 1 ModuleId FROM [dbo].[Central_UserWiseModuleLogin] with (nolock) WHERE trim(Uuid)=trim(@token) order by TxnDateTime desc)
	IF(@SwitchedPropertyId>0)
	BEGIN
		SET @PropertyId=@SwitchedPropertyId
	END
	ELSE
	BEGIN
		SET @PropertyId=(SELECT TOP 1 PropertyId FROM [dbo].[Central_UserWiseModuleLogin] with (nolock)  WHERE trim(Uuid)=trim(@token)  order by TxnDateTime desc)
	END
	--IF(@UserId=71)
	--BEGIN
	--	Select 1
	--END
	--ELSE
	--BEGIN
	IF EXISTS (	select 1 
				from  [dbo].[Admin_Nav_AreasWisePages] with (nolock) 
				where (Id IN (SELECT [value]FROM OPENJSON (@AltPages)) OR Id = @PageId)
				and IsActive = 0 
				AND ModuleId=@ModuleId
	)
	BEGIN
		SELECT 1
	END
	ELSE 
	BEGIN		
		SELECT ISNULL(SUM(X.authorized),0)  
		From(
 			SELECT 
			CASE(@Right)
			WHEN 'S' THEN 1
			WHEN 'I' THEN 1
			WHEN 'D' THEN 1
			WHEN 'U' THEN 1
			ELSE 0
			END  AS  authorized
			FROM
			[dbo].[Central_UserWiseIndividualMenuItems] with (nolock) 
			WHERE UserId = @UserId  AND ModuleId=@ModuleId AND PropertyId=@PropertyId
			AND (	MenuItemId = @PageId 
					OR MenuItemId IN (	SELECT [value]
									FROM OPENJSON (@AltPages)
					)
				)

			UNION

			SELECT 
			CASE(@Right)
			WHEN 'S' THEN 1
			WHEN 'I' THEN 1
			WHEN 'D' THEN 1
			WHEN 'U' THEN 1
			ELSE 0
			END AS  authorized
			FROM
			[dbo].[Central_UserRoleWiseMenuItems] AS URWP with (nolock) 	
			INNER JOIN Central_UserWiseUserRoles AS UWR with (nolock)  ON UWR.UserRoleId = URWP.UserRoleId
			WHERE UWR.UserId = @UserId  AND URWP.ModuleId=@ModuleId 
			--AND URWP.PropertyId=@PropertyId
			AND (	URWP.MenuItemId = @PageId 
					OR URWP.MenuItemId  IN (	SELECT [value]
									FROM OPENJSON (@AltPages)
								)
				)
		)  AS X

	END
	--END
	-- select acess as 1 when the page is active false
	--SELECT [value]FROM OPENJSON (@AltPages)

	--SELECT * from Central_UserRoleWiseMenuItems


	

END

GO

