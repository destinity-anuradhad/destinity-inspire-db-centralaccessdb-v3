
CREATE PROCEDURE [dbo].[Central_PasswordPolicyAttribute_M_Save]
	@Id								INT=0,
	@UserId							INT,
	@Name							VARCHAR(100),
	@SelectedAttributresJson		NVARCHAR(max)
AS
BEGIN TRY
BEGIN TRANSACTION	

	IF(ISNULL(@Name,'NULL')='NULL')
		BEGIN
			RAISERROR('Enter a name.',16,1)
		END

	SELECT [PasswordAttributeId], [Value]
	INTO #TempSelectedAttributres
	FROM OPENJSON (@SelectedAttributresJson)  
    WITH (  
              PasswordAttributeId INT '$.PasswordAttributeId',
			  Value		  VARCHAR(50) '$.Value'
		 )

	DECLARE		@PasswordAttributeId INT,
				@Value		  VARCHAR(50)

	IF @Id =0
	BEGIN
		IF EXISTS(SELECT [Name] FROM [dbo].[Central_PasswordPolicy] WHERE [Name]=@Name)
			BEGIN
				RAISERROR('Name already exists.',16,1)
			END

		INSERT INTO [dbo].[Central_PasswordPolicy]
				([GroupId]
				,[Name]
				,[CreatedUserId]
				,[ModifiedUserId]
				,[CreatedDate]
				,[ModifiedDate])
		SELECT 1,@Name,@UserId,@UserId,GETDATE(),GETDATE()

		SET @Id = SCOPE_IDENTITY()

		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_Users',@Id,'CA','PPHC','C', @UserId, @Name
		-- End of Audit trail ---------------------
		
	END
	ELSE
	BEGIN
		UPDATE [dbo].[Central_PasswordPolicy]
		SET 
			[GroupId] =1,
			[Name]=@Name
		WHERE Id=@Id

		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_Users',@Id,'CA','PPHU','U', @UserId, @Name
		-- End of Audit trail ---------------------
	END

	SELECT * 
	INTO #tempDeletingCentral_PasswordPolicyWiseSettings
	FROM [Central_PasswordPolicyWiseSettings]
	WHERE [PasswordPolicyId] = @Id 
	ORDER BY PasswordAttributeId

	DECLARE @TempPasswordAttributeId	INT, 
			@AttributeValue				INT

	--DELETE ATTRIBUTES LOGGING-----
	WHILE EXISTS(SELECT TOP 1 1 FROM #tempDeletingCentral_PasswordPolicyWiseSettings)
	BEGIN
		SELECT TOP 1 @TempPasswordAttributeId = PasswordAttributeId FROM #tempDeletingCentral_PasswordPolicyWiseSettings

		DELETE FROM [Central_PasswordPolicyWiseSettings] WHERE PasswordPolicyId = @Id AND PasswordAttributeId = @TempPasswordAttributeId

		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_PasswordPolicyWiseSettings',@TempPasswordAttributeId,'CA','PPDD','D', @UserId
		-- End of Audit trail ---------------------

		DELETE TOP (1) FROM #tempDeletingCentral_PasswordPolicyWiseSettings
	END


	--RE INSERT LOGGING----
	WHILE EXISTS(SELECT TOP 1 1 FROM #TempSelectedAttributres)
	BEGIN
		SELECT TOP 1 @TempPasswordAttributeId = PasswordAttributeId, @AttributeValue = [Value] FROM #TempSelectedAttributres

		INSERT INTO [dbo].[Central_PasswordPolicyWiseSettings]([GroupId] ,[PasswordPolicyId] ,[PasswordAttributeId] ,[Value])
		SELECT TOP 1 1,@Id,PasswordAttributeId,Value 
		FROM #TempSelectedAttributres

		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_PasswordPolicyWiseSettings',@TempPasswordAttributeId,'CA','PPDD','C', @UserId, @AttributeValue
		-- End of Audit trail ---------------------	

		DELETE TOP (1) FROM #TempSelectedAttributres
	END

	--INSERT INTO [dbo].[Central_PasswordPolicyWiseSettings]
	--		   ([GroupId]
	--		   ,[PasswordPolicyId]
	--		   ,[PasswordAttributeId]
	--		   ,[Value])
	--SELECT 1,@Id,PasswordAttributeId,Value 
	--FROM #TempSelectedAttributres

	--DROP TABLE #TempSelectedAttributres

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

