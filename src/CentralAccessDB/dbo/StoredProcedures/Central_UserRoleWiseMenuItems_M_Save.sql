-- [Central_UserRoleWiseMenuItems_M_Save] 1, '[{"Id":0,"UserRoleId":56,"PropertyId":0,"ModuleId":13,"MenuItemId":1},{"Id":0,"UserRoleId":56,"PropertyId":0,"ModuleId":13,"MenuItemId":1},{"Id":0,"UserRoleId":56,"PropertyId":0,"ModuleId":13,"MenuItemId":1},{"Id":0,"UserRoleId":56,"PropertyId":0,"ModuleId":13,"MenuItemId":2},{"Id":0,"UserRoleId":56,"PropertyId":0,"ModuleId":13,"MenuItemId":3}]'
CREATE PROCEDURE [dbo].[Central_UserRoleWiseMenuItems_M_Save]
	--@UserRoleId	int,
	--@ModuleId	int,
	--@PropertyId	int,
	@UserRoleWiseMenuItemsJson  NVARCHAR(max),
	@UserId INT = -1
AS
BEGIN TRY
BEGIN TRANSACTION 

--Stehani
-- @Nov  9 2020 10:50AM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY
	DECLARE @PropertyId INT
	DECLARE @Id INT

	SET @PropertyId=0

			SELECT  UserRoleId ,
					@PropertyId AS 'PropertyId',
					(SELECT [dbo].[GetEncryption] (MenuItemId, UserRoleId)) AS 'EncryptedMenuItemId',
					ModuleId ,
					MenuItemId,
					MenuLevel
			INTO #tempUserRoleWiseMenuItems
			FROM 
				OPENJSON (@UserRoleWiseMenuItemsJson)
		    WITH (
			   MenuItemId INT '$.MenuItemId',
			   UserRoleId INT '$.UserRoleId',
			   ModuleId INT '$.ModuleId',
			   MenuLevel NVARCHAR(1) '$.MenuLevel'
		    )
	
	--SELECT TOP 1 UserRoleId FROM #tempUserRoleWiseMenuItems
	--IF((SELECT UserRoleId FROM #tempUserRoleWiseMenuItems)=0)
	--	BEGIN
	--		RAISERROR('Select a role.',16,1)
	--	END
	--IF((SELECT ModuleId FROM #tempUserRoleWiseMenuItems)=0)
	--	BEGIN
	--		RAISERROR('Select a module.',16,1)
	--	END

	IF EXISTS (SELECT * FROM #tempUserRoleWiseMenuItems where UserRoleId = 0)
	BEGIN
		RAISERROR('Select user role.',16,1)
	END

	DELETE FROM Central_UserRoleWiseMenuItems 
	WHERE [UserRoleId] IN (SELECT TOP 1 UserRoleId FROM #tempUserRoleWiseMenuItems) 
	AND [ModuleId] IN (SELECT TOP 1 ModuleId FROM #tempUserRoleWiseMenuItems)

	INSERT INTO Central_UserRoleWiseMenuItems 
	(UserRoleId ,PropertyId, EncryptedMenuItemId ,ModuleId ,MenuItemId) 
	SELECT UserRoleId,PropertyId,EncryptedMenuItemId,ModuleId,MenuItemId
	FROM #tempUserRoleWiseMenuItems
	WHERE MenuLevel = 'P'

	SET @Id=SCOPE_IDENTITY();

	-- Audit trail ----------------------------
	EXEC HotelResWeb_AuditTail_WriteToLog 'Central_UserRoleWiseMenuItems',@Id,'CA','URWMI','I',@UserId,@Id, @Id
	-- End of Audit trail ---------------------

	DROP TABLE #tempUserRoleWiseMenuItems
	
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

