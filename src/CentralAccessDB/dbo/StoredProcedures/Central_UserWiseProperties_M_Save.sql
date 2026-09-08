
CREATE PROCEDURE [dbo].[Central_UserWiseProperties_M_Save]
	@UserId	int,
	@UserWisePropertiesJson  NVARCHAR(max)
	
AS
BEGIN TRY
BEGIN TRANSACTION 

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT	
		UserId ,
		PropertyId ,
		(SELECT [dbo].[GetEncryption] (PropertyId, UserId)) AS 'EncryptedPropertyId',
		@UserId AS 'CreatedUserId',
		@UserId AS 'ModifiedUserId',
		GETDATE() AS 'CreatedDate' ,
		GETDATE() AS  'ModifiedDate'
	INTO #tempUserWiseProperties
	FROM 
	OPENJSON (@UserWisePropertiesJson)
	WITH (
		PropertyId INT '$.PropertyId',
		UserId INT '$.UserId'
	)

	-----Copy property wise access-------------------
	DECLARE @SourcePropertyId INT=0
	DECLARE @AssignedPropertyId INT
	DECLARE @AssignedUserId INT
	DECLARE @IsCopyPropertyWiseAccess BIT

	IF EXISTS(SELECT * FROM Central_UserWiseProperties WHERE [UserId] IN (SELECT UserId FROM #tempUserWiseProperties))
	BEGIN
		SET @SourcePropertyId= (SELECT TOP (1) PropertyId FROM Central_UserWiseProperties WHERE [UserId] IN (SELECT UserId FROM #tempUserWiseProperties) ORDER BY Id DESC)
	END
	-------------------------------------------------

	DELETE 
	FROM Central_UserWiseProperties 
	WHERE [UserId] IN (SELECT UserId FROM #tempUserWiseProperties)

	INSERT INTO Central_UserWiseProperties
	(UserId ,PropertyId, EncryptedPropertyId, CreatedUserId ,ModifiedUserId ,CreatedDate ,ModifiedDate) 
	SELECT * FROM #tempUserWiseProperties

	IF(@SourcePropertyId>0)
	BEGIN
		WHILE EXISTS(SELECT * FROM #tempUserWiseProperties WHERE PropertyId <> @SourcePropertyId)
		BEGIN
			SELECT TOP (1) @AssignedUserId=UserId,@AssignedPropertyId=PropertyId FROM #tempUserWiseProperties WHERE PropertyId <> @SourcePropertyId
			SELECT @IsCopyPropertyWiseAccess=IsCopyPropertyWiseAccess FROM CASettings WHERE PropertyId=@AssignedPropertyId

			IF(@IsCopyPropertyWiseAccess<>0)
			BEGIN
				---------Insert into user wise modules-----------------------
				INSERT INTO Central_UserWiseModules
				(UserId ,PropertyId ,ModuleId, EncryptedModuleId ,CreatedUserId ,ModifiedUserId ,CreatedDate ,ModifiedDate) 
				SELECT 
				@AssignedUserId,@AssignedPropertyId,ModuleId,(SELECT [dbo].[GetEncryption] (ModuleId, @AssignedUserId)),@UserId,@UserId,GETDATE(),GETDATE()
				FROM Central_UserWiseModules
				WHERE PropertyId=@SourcePropertyId AND UserId=@AssignedUserId
				-------------------------------------------------------------

				--------Insert into user wise individual access--------------
				INSERT INTO Central_UserWiseIndividualMenuItems
				(PropertyId ,UserId ,ModuleId ,MenuItemId, EncryptedMenuItemId ,CreatedUserId ,ModifiedUserId ,CreatedDate ,ModifiedDate) 
				SELECT distinct @AssignedPropertyId,@AssignedUserId,ModuleId,MenuItemId,(SELECT [dbo].[GetEncryption] (MenuItemId, @AssignedUserId)),@UserId,@UserId,GETDATE(),GETDATE()
				FROM Central_UserWiseIndividualMenuItems
				WHERE PropertyId=@SourcePropertyId AND UserId=@AssignedUserId
				-------------------------------------------------------------

				-------Insert into user role wise menu items-----------------
				INSERT INTO Central_UserRoleWiseMenuItems 
				(UserRoleId ,PropertyId, EncryptedMenuItemId ,ModuleId ,MenuItemId) 
				SELECT UserRoleId,@AssignedPropertyId,EncryptedMenuItemId,ModuleId,MenuItemId
				FROM Central_UserRoleWiseMenuItems
				WHERE PropertyId=@SourcePropertyId
				-------------------------------------------------------------

				-----Insert into GL Property Access -----------------------
				EXEC eFinancials_Accounting..[Destinity_Acc_InsertBranchWiseUserAccess_WithCentralModule] @AssignedUserId,@AssignedPropertyId
				-----------------------------------------------------------

			END

			DELETE TOP (1) FROM #tempUserWiseProperties
		END
	END

	CREATE TABLE #TempApplicableProperties (
	PropertyId INT 
	)

	DECLARE @AppliedUserId		INT
	DECLARE @AppliedPropertyId INT

	SELECT TOP 1 @AppliedUserId=UserId FROM #tempUserWiseProperties

	INSERT INTO #TempApplicableProperties
	(PropertyId)
	SELECT 
	PropertyId
	FROM Central_UserWiseProperties WITH(NOLOCK)
	WHERE UserId=@AppliedUserId

	WHILE EXISTS(SELECT 1 FROM #TempApplicableProperties)
	BEGIN
		SELECT TOP (1) @AppliedPropertyId=PropertyId FROM #TempApplicableProperties
	
			-----Insert into GL Property Access -----------------------
			EXEC eFinancials_Accounting..[Destinity_Acc_InsertBranchWiseUserAccess_WithCentralModule] @AppliedUserId,@AppliedPropertyId
			-----------------------------------------------------------
	
		DELETE TOP (1) FROM #TempApplicableProperties
	END

	DROP TABLE #TempApplicableProperties

	DROP TABLE #tempUserWiseProperties		

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

