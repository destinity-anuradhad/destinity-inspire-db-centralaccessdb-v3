CREATE PROCEDURE [dbo].[Central_UserWiseOutlets_M_Save]
	@UserId	int,
	@UserWiseOutletsJson  NVARCHAR(max)
AS
BEGIN TRY
BEGIN TRANSACTION

	DECLARE @AssignedPropertyId INT

	SELECT  UserId ,
			OutletId ,
			(SELECT [dbo].[GetEncryption] (OutletId, UserId)) AS 'EncryptedOutletId',
			@UserId AS 'CreatedUserId',
			@UserId AS 'ModifiedUserId',
			GETDATE() AS 'CreatedDate',
			GETDATE() AS 'ModifiedDate'
	INTO #tempUserWiseOutlets
	FROM 
		OPENJSON (@UserWiseOutletsJson)
	WITH (
		OutletId INT '$.OutletId',
		UserId INT '$.UserId'
	)

	SELECT * 
	INTO #tempUserWiseProperties
	FROM [dbo].[Central_UserWiseProperties]
	WHERE [UserId]=(SELECT Top 1 UserId FROM #tempUserWiseOutlets)

	WHILE EXISTS (SELECT * FROM #tempUserWiseProperties)
		BEGIN
			SELECT TOP 1 @AssignedPropertyId=PropertyId FROM #tempUserWiseProperties
			
			DELETE FROM Central_UserWiseOutlets 
			WHERE [UserId] IN (SELECT UserId FROM #tempUserWiseOutlets) 
			AND PropertyId = @AssignedPropertyId

			INSERT INTO Central_UserWiseOutlets
				(UserId ,PropertyId ,OutletId, EncryptedOutletId ,CreatedUserId ,ModifiedUserId ,CreatedDate ,ModifiedDate) 
			SELECT UserId,@AssignedPropertyId,OutletId,EncryptedOutletId,@UserId,@UserId,CreatedDate,ModifiedDate
			FROM #tempUserWiseOutlets

			DELETE TOP (1) FROM #tempUserWiseProperties
		END

		DROP TABLE #tempUserWiseProperties
		DROP TABLE #tempUserWiseOutlets

COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	
	DECLARE  @ERRmsg VARCHAR(MAX) =ERROR_MESSAGE()
	INSERT INTO GEN_ErrTable (ErrorNumber,ErrorSeverity,ErrorState,ErrorProcedure,ErrorLine,ErrorMessage)
    VALUES (ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_STATE(),ERROR_PROCEDURE(),ERROR_LINE(),@ERRmsg)		
	RAISERROR(@ERRmsg,16,1)

END CATCH

GO

