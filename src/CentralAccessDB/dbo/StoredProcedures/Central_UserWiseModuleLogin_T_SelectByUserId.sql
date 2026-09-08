CREATE PROCEDURE [dbo].[Central_UserWiseModuleLogin_T_SelectByUserId]
@Id  INT
AS
BEGIN
--Stehani
-- @Nov 24 2020 11:51AM
--Central_UserWiseModuleLogin_T_SelectByUserId @Id = 15

	SET NOCOUNT ON;
	SET DATEFORMAT DMY
		
	update A
	set A.LastActiveDateTime = GETDATE()
	FROM Central_UserWiseModuleLogin A   with (nolock)  	
	WHERE [UserId] = @Id
	and IsActive = 1

	SELECT top 1 * 
	FROM Central_UserWiseModuleLogin with (nolock)  
	WHERE [UserId] = @Id
	and IsActive = 1
	order by Id desc  


END

GO

