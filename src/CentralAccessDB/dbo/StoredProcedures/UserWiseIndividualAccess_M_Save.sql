

-- =============================================  
-- Author:  chiraj  
-- Create date: 2020-09-15  
-- Description: User wise individual access
-- =============================================  
CREATE PROCEDURE [dbo].[UserWiseIndividualAccess_M_Save]  
(  
 @Operation CHAR(1),  
 @MainNavigationId INT,  
 @UserId     INT,  
 @UserWiseIndividualAccessJson  NVARCHAR(max),  
 @CreatedUserId Int , 
  @PropertyId INT
)  
  
AS  
BEGIN  
SET NOCOUNT ON;  
 IF(@Operation = 'I')  
  BEGIN  
	DECLARE @Uuid NVARCHAR(2000) = NEWID()

	INSERT INTO [dbo].[UserWiseIndividualAccess_Log]
           ([Id],[UserId],[PropertyId],[MainNavigationId],[PageId],[IsAllowInsert],[IsAllowUpdate],[IsAllowDelete]
           ,[IsAllowSelect],[CreatedUserId],[CreatedDateTime],[LastUpdatedUserId],[LastUpdatedDateTime],[Uuid])
	SELECT [Id],[UserId],[PropertyId],[MainNavigationId],[PageId],[IsAllowInsert],[IsAllowUpdate],[IsAllowDelete]
           ,[IsAllowSelect],[CreatedUserId],[CreatedDateTime],[LastUpdatedUserId],[LastUpdatedDateTime],@Uuid
	FROM UserWiseIndividualAccess WHERE UserId = @UserId AND PropertyId=@PropertyId AND  MainNavigationId = @MainNavigationId  

	DELETE FROM UserWiseIndividualAccess WHERE UserId = @UserId AND PropertyId=@PropertyId AND  MainNavigationId = @MainNavigationId  
  
	INSERT INTO UserWiseIndividualAccess(UserId,PropertyId,MainNavigationId, PageId, IsAllowInsert, IsAllowUpdate, IsAllowDelete, IsAllowSelect, CreatedUserId, CreatedDateTime, LastUpdatedUserId, LastUpdatedDateTime)  
	Select @UserId,@PropertyId,@MainNavigationId, PageId, IsAllowInsert, IsAllowUpdate, IsAllowDelete, IsAllowSelect,@CreatedUserId, GETDATE(), @CreatedUserId, GETDATE()  
	FROM   
	OPENJSON (@UserWiseIndividualAccessJson)  
	WITH (  
			  PageId INT '$.PageId',  
			  IsAllowInsert BIT '$.IsAllowInsert',  
			  IsAllowUpdate BIT '$.IsAllowUpdate',  
			  IsAllowDelete BIT '$.IsAllowDelete',  
			  IsAllowSelect BIT '$.IsAllowSelect'  
		  )  
  END  
  
END  
  
  --select * from UserWiseIndividualAccess

GO

