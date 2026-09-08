-- =============================================  
-- Author:  CHIRAJ  
-- Create date: 2020-10-15
-- Description: <Description,,>  
-- =============================================  
--[UserWiseIndividualAccess_M_Select_ById]   1, 1, 2
CREATE PROCEDURE [dbo].[UserWiseIndividualAccess_M_Select_ById]  
@UserId     INT,  
@MainNavigationId INT  ,
@PropertyId INT
  
AS  
BEGIN   
 SET NOCOUNT ON;  
  IF EXISTS(SELECT 1 FROM UserWiseIndividualAccess  Where UserId = @UserId AND PropertyId=@PropertyId AND MainNavigationId = @MainNavigationId )
  BEGIN
		SELECT *
		FROM UserWiseIndividualAccess  
		Where UserId = @UserId AND PropertyId=@PropertyId AND MainNavigationId = @MainNavigationId		
  END
 -- ELSE
  --BEGIN
  --DECLARE @jsondata NVARCHAR(MAX) = (select AccessCodeId from POS_UserAccessTemp where PropertyId=@PropertyId and UserId=@UserId for json auto)  
 -- select @jsondata as posaccessjson
  --END
 
  
 

END

GO

