
create procedure [FA_Ref].[SelectBudgetReferences]
(
	@BudgetReferenceID	INT
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
			@sErrorMessage		VARCHAR(500)

    BEGIN TRY

		SELECT BudgetReferenceID,Name, IsActive,CreatedUserID AS UserID,CreatedDate, ModifiedUserID, ModifiedDate
		FROM [fa_ref].BudgetReferences
		WHERE BudgetReferenceID = 
				CASE WHEN 
					@BudgetReferenceID=-999 
				THEN 
					BudgetReferenceID 
				ELSE 
					@BudgetReferenceID 
				END 

	END TRY
	
	BEGIN CATCH

	DECLARE @iErrorNumber INT

	SELECT	@sErrorProcedure=ERROR_PROCEDURE()
	SELECT	@sErrorMessage=ERROR_MESSAGE()
	SELECT	@iErrorNumber=ERROR_NUMBER()

	RAISERROR (@sErrorMessage,16,1)

	RETURN 0
  
    END CATCH  
END

GO

