-- =============================================
-- Author:		Yasiru
-- Create date: 2017-8-29
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[User_M_UpdateLoginGuid]
@Username NVARCHAR(20),
@GUID     NVARCHAR(500)	

AS
	 BEGIN
		  IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username)
		  BEGIN
		        UPDATE [dbo].[Users] 
		        SET	
				Guid =   @GUID
				WHERE [Username] = @Username
			END 
			ELSE
			BEGIN
				  RAISERROR('No record exists.',16,1)
			END

END

GO

