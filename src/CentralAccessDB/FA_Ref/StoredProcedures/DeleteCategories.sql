
create PROCEDURE [FA_Ref].[DeleteCategories]
( 
	@CategoryID				INT,
	@SnapObject		VARCHAR(MAX),
	@UserId						INT,
	@SkipApproval				BIT=1
)

AS
BEGIN
	
	SET NOCOUNT ON;
	SET XACT_ABORT,
	QUOTED_IDENTIFIER,
	ARITHABORT,
	ANSI_NULLS,
	ANSI_PADDING,
	ANSI_WARNINGS,
	CONCAT_NULL_YIELDS_NULL ON;
	SET NUMERIC_ROUNDABORT OFF;
  
    DECLARE @sErrorProcedure	VARCHAR(200),
			@sLog				VARCHAR(500),
			@ReferenceId		INT,
            @datetoday			DATE,
			@HaveApprovals      BIT=0,
			@DBName				VARCHAR(100) =DB_NAME() ,
			@sErrorMessage		VARCHAR(500),
			@ModuleID			INT=4 ,
			@HaveValidation		BIT=1

    BEGIN TRY
		
		BEGIN TRANSACTION
		
			DECLARE @CustomText VARCHAR(500) ='Additinal Expenses Delete'

			EXEC  [ValidateOnDelete] '[fa_ref].[Categories] ', @CategoryID
			SET @HaveValidation =0

			IF @SkipApproval=0
				EXEC [CheckApprovalsForMasterData] @datetoday,@UserId,@ModuleID,'[fa_ref].Categories',' [fa_ref].[Categories]',@DBName,'D',@SnapObject,1,@CategoryID,@HaveApprovals OUTPUT	,@CustomText

			if @HaveApprovals = 0
			BEGIN

				DELETE 
				FROM	[fa_ref].Categories
				WHERE	CategoryID = @CategoryID
	 
			
				SET	@datetoday = GETDATE();
				SET	@ReferenceId = CAST(@CategoryID  AS VARCHAR);

				EXEC	InsertAuditMaster	4,'D','CategoryID', @ReferenceId, @CategoryID , @UserId, '192.168.1.1',
											'Categories', @datetoday, @datetoday, 'Test', @SnapObject;
			END 


    		IF @@TRANCOUNT>0
				COMMIT TRANSACTION
				RETURN 1
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION

		DECLARE @iErrorNumber INT

		SELECT	@sErrorProcedure=ERROR_PROCEDURE()
		SELECT	@sErrorMessage=ERROR_MESSAGE()
		SELECT	@iErrorNumber=ERROR_NUMBER()

		IF @HaveValidation=1
		BEGIN
			EXEC sp_addmessage @msgnum = 50005, @severity = 1, @msgtext = @sErrorMessage,@replace = 'REPLACE';
			RAISERROR (50005,11,1)
		END
		ELSE
			RAISERROR (@sErrorMessage,16,1)
		
		EXEC sp_dropmessage 50005;
		RETURN 0
  
    END CATCH   
END

GO

