CREATE PROCEDURE [dbo].[Central_UserWiseIndividualMenuItems_M_Save]
	--@PropertyId	int,
	@UserId	int,
	@UserWiseIndividualMenuItemsJson  NVARCHAR(max),
	@ApplicablePropertiesJson NVARCHAR(max)
AS
BEGIN TRY
BEGIN TRANSACTION 
	-- Stehani
	-- @Nov  9 2020  1:55PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DECLARE @AssignedPropertyId INT
	DECLARE @AssignedModuleId INT
	DECLARE @AssignedUserId INT

	SELECT  
			UserId ,
			ModuleId ,
			MenuItemId ,
			(SELECT [dbo].[GetEncryption] (MenuItemId, UserId)) AS 'EncryptedMenuItemId',
			@UserId AS 'CreatedUserId',
			@UserId AS 'ModifiedUserId',
			GETDATE() AS 'CreatedDate',
			GETDATE() AS 'ModifiedDate',
			MenuLevel
	INTO	#tempUserWiseIndividualMenuItems
	FROM	OPENJSON (@UserWiseIndividualMenuItemsJson)
	WITH	(
				MenuItemId INT '$.MenuItemId',
				UserId INT '$.UserId',
				ModuleId INT '$.ModuleId',
				MenuLevel NVARCHAR(1) '$.MenuLevel'
			)

	SELECT  
			PropertyId
	INTO	#tempUserWiseProperties
	FROM	OPENJSON (@ApplicablePropertiesJson)
	WITH	(
				PropertyId INT '$.PropertyId'
			)

	--SELECT * 
	--INTO #tempUserWiseProperties
	--FROM [dbo].[Central_UserWiseProperties]
	--WHERE [UserId]=(SELECT Top 1 UserId FROM #tempUserWiseIndividualMenuItems)

	SELECT TOP 1 
	@AssignedModuleId=ModuleId,
	@AssignedUserId = UserId
	FROM #tempUserWiseIndividualMenuItems

	IF @AssignedModuleId = 0 
	BEGIN
		RAISERROR('Please select module.',16,1)
	END

	IF @AssignedUserId = 0 
	BEGIN
		RAISERROR('Please select user.',16,1)
	END

	DELETE 
	FROM	Central_UserWiseIndividualMenuItems 
	WHERE	[UserId] = @AssignedUserId
	AND [ModuleId] = @AssignedModuleId
	AND [PropertyId] IN (SELECT PropertyId FROM #tempUserWiseProperties)

	WHILE EXISTS (SELECT * FROM #tempUserWiseProperties)
	BEGIN
		SELECT TOP 1 
		@AssignedPropertyId=PropertyId			
		FROM #tempUserWiseProperties		

		INSERT INTO Central_UserWiseIndividualMenuItems
		(PropertyId ,UserId ,ModuleId ,MenuItemId, EncryptedMenuItemId ,CreatedUserId ,ModifiedUserId ,CreatedDate ,ModifiedDate) 
		SELECT distinct @AssignedPropertyId,UserId,ModuleId,MenuItemId,EncryptedMenuItemId,CreatedUserId,ModifiedUserId,CreatedDate,ModifiedDate
		FROM #tempUserWiseIndividualMenuItems
		WHERE MenuLevel = 'P'

		DELETE TOP (1) FROM #tempUserWiseProperties
	END

	

	DROP TABLE #tempUserWiseProperties
	DROP TABLE #tempUserWiseIndividualMenuItems		

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

