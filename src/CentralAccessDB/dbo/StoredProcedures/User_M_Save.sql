
-- =============================================  
-- Author:  Yasiru  
-- Create date: 2017-8-29  
-- Description:   
-- =============================================  
CREATE PROCEDURE [dbo].[User_M_Save]  
@Id INT,  
@Username NVARCHAR(20),   
@EmployeeId  INT = 1,  
@Password NVARCHAR(500),   
@Salt NVARCHAR(500),   
@IsActive BIT,   
@IsLocked BIT = 0,   
@UserId INT,
@UserRoleId INT,    
@Operation CHAR(1) ,
@IsPOSUser BIT,
@AccessCardNo VARCHAR(50),
@POSpassword NVARCHAR(MAX),
@PropertyId INT,
@IsPasswordChange BIT
AS  
BEGIN  TRY
	SET NOCOUNT ON;  
	IF @Operation='I'  
		IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username AND PropertyId=@PropertyId)  
		BEGIN  
			RAISERROR('This username is already taken. Please choose another name.',16,1)  
		END  
		ELSE  
		BEGIN  
			INSERT INTO [dbo].[Users]  
			([Username],[EmployeeId],[Password],[Salt],[IsActive] ,[UserRoleId], IsLocked,IsUpload,POSPassword,AccessCardNo,IsPOSUser, [CreatedUserId], [CreatedDateTime],PropertyId)  
			VALUES(@Username,@EmployeeId,@Password,@Salt,@IsActive, @UserRoleId, @IsLocked,0,@POSpassword,@AccessCardNo,@IsPOSUser, @UserId, GETDATE(),@PropertyId)   
			
			DECLARE @UserTableID INT	
			SET @UserTableID=SCOPE_IDENTITY()
			INSERT INTO UserWiseRoles([UserId], [RoleId], [IsActive], [CreatedUserId], [CreatedDateTime], [PropertyId])
			VALUES (@UserTableID,@UserRoleId,@IsActive, @UserId, GETDATE(),@PropertyId)

		
	END  
  
   
	ELSE IF @Operation='U'  
	BEGIN  

		

		IF EXISTS (SELECT 1 FROM Users WHERE Id = @Id AND PropertyId=@PropertyId)  
		BEGIN 
			IF @IsPasswordChange=1
			BEGIN
				UPDATE [dbo].[Users]   
				SET  
					Username   = @Username,   
					EmployeeId  =  @EmployeeId,  
					Password   =  @Password,   
					Salt  =  @Salt,  
					IsActive=   @IsActive,
					UserRoleId = @UserRoleId,  
					IsLocked =   @IsLocked,  
					LastEditedUserId= @UserId,   
					LastEditedDateTime= GETDATE(),
					PropertyId=@PropertyId,
					POSPassword=@POSpassword,
					AccessCardNo=@AccessCardNo,
					IsPOSUser=@IsPOSUser,
					IsUpload=0
					WHERE Id=  @Id  AND PropertyId=@PropertyId
			END
			ELSE
			BEGIN
			UPDATE [dbo].[Users]   
				SET 
					IsActive=   @IsActive,
					UserRoleId = @UserRoleId,  
					LastEditedUserId= @UserId,   
					LastEditedDateTime= GETDATE(),
					PropertyId=@PropertyId,
					AccessCardNo=@AccessCardNo,
					IsPOSUser=@IsPOSUser,
					IsUpload=0
					WHERE Id=  @Id  AND PropertyId=@PropertyId
			END

			IF NOT EXISTS(SELECT 1 FROM UserWiseRoles WHERE UserId= @Id  AND PropertyId=@PropertyId)
			BEGIN
				INSERT INTO UserWiseRoles([UserId], [RoleId], [IsActive], [CreatedUserId], [CreatedDateTime], [PropertyId])
				VALUES (@Id,@UserRoleId,@IsActive, @UserId, GETDATE(),@PropertyId)
			END
			ELSE
			BEGIN
				UPDATE UserWiseRoles
				SET
				RoleId=@UserRoleId,
				IsActive=@IsActive,
				PropertyId=@PropertyId
				WHERE UserId= @Id  AND PropertyId=@PropertyId
			END
			
		
	END   
	ELSE  
	BEGIN  
		RAISERROR('No record exists.',16,1)  
	END  
	END  
	ELSE  
	BEGIN  
		RAISERROR('Invalid operation',16,1)  
	END  
  
END TRY 
BEGIN CATCH
	INSERT INTO GEN_ErrTable (ErrorNumber,ErrorSeverity,ErrorState,ErrorProcedure,ErrorLine,ErrorMessage)
    VALUES (ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_STATE(),ERROR_PROCEDURE(),ERROR_LINE(),ERROR_MESSAGE())

	DECLARE  @ERRmsg VARCHAR(MAX) =ERROR_MESSAGE()
	RAISERROR(@ERRmsg,16,1)
END CATCH

GO

