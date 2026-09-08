CREATE PROCEDURE [dbo].[Central_UserWiseModuleLoginStatus_T_Update]
	@SelectedUserListForLogoutJson NVARCHAR(MAX)
AS
BEGIN TRY
BEGIN TRANSACTION

	SELECT 
		[Id]	
	INTO #TempSelectedUserListForLogoutJson
	FROM 	
	OPENJSON (@SelectedUserListForLogoutJson)
	WITH
	(
		Id INT '$.Id'
	)

	DECLARE @Id INT

	WHILE EXISTS (SELECT * FROM #TempSelectedUserListForLogoutJson)
	BEGIN
		SELECT TOP (1) @Id = Id FROM #TempSelectedUserListForLogoutJson
			UPDATE	[dbo].[Central_UserWiseModuleLogin]
			SET [IsActive] = 0
			WHERE [Id]= @Id
		DELETE TOP (1) FROM #TempSelectedUserListForLogoutJson
	END

	DROP TABLE #TempSelectedUserListForLogoutJson
COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION

	DECLARE @Error NVARCHAR(MAX)
	SELECT @Error = ERROR_MESSAGE()

	INSERT INTO GEN_ErrTable (ErrorNumber,ErrorSeverity,ErrorState,ErrorProcedure,ErrorLine,ErrorMessage)
        VALUES (ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_STATE(),ERROR_PROCEDURE(),ERROR_LINE(),ERROR_MESSAGE())

	RAISERROR(@Error,16,1)

END CATCH

GO

