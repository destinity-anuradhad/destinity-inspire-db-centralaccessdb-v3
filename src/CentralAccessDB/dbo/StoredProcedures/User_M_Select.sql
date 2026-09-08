
-- =============================================  
-- Author:  Yasiru  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
--User_M_Select 2,1,1
--ALTER PROCEDURE [dbo].[User_M_Select]--  1,-1,1
--@IsActive       INT = 2,  
--@Id    INT = -1 ,
--@PropertyId INT
--AS  
--BEGIN   
-- SET NOCOUNT ON;  
  
-- SELECT * ,
-- (SELECT * FROM UserWiseRoles WHERE UserId = UR.Id AND UR.PropertyId=@PropertyId FOR JSON AUTO) AS RolesJson  
-- FROM Users UR  
-- WHERE(@Id = -1 OR UR.Id=@Id)    AND UR.PropertyId=@PropertyId
-- AND (@IsActive = 2 OR @IsActive = UR.IsActive) OR IsGroupUser=1  
 
--END  
CREATE PROCEDURE [dbo].[User_M_Select]--  1,-1,1

@PropertyId INT,
@IsActive INT
AS  
BEGIN   
 SET NOCOUNT ON;  
  
 SELECT * FROM Central_Users
 WHERE @IsActive=1
END

GO

