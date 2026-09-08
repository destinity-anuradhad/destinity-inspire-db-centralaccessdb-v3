
-- =============================================
-- Author:		Chiraj
-- Create date: 2020-09-15
-- Description:	user wise property
-- =============================================
CREATE PROCEDURE [dbo].[UserWiseProperty_M_Save]
@SelectedPropertyJson NVARCHAR(MAX),
@UserId INT,
@CreatedUserId INT,
@Operation CHAR

AS
BEGIN
	IF @Operation = 'I'
	BEGIN
	  
		DELETE FROM UserWiseProperty WHERE UserId = @UserId

		INSERT INTO UserWiseProperty(UserId, ProductId, CreatedUserId, CreatedDateTime, LastUpdatedUserId, LastUpdatedDateTime)
		SELECT @UserId, ProductId,@CreatedUserId, GETDATE(),@CreatedUserId, GETDATE()
		FROM OPENJSON(@SelectedPropertyJson)
		WITH 
		(
			ProductId NVARCHAR(50) '$.PropertyId'
		)
	END

END

GO

