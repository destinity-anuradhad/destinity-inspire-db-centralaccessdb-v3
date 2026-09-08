CREATE procedure [FA_Ref].[SelectCategoryLevels]
(
	@CategoryLevelID	INT
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

		SELECT  CategoryLevelID, ParentLevelID, Name, HaveChilds, IsActive
		FROM [fa_ref].CategoryLevels
		WHERE CategoryLevelID = 
				CASE WHEN 
					@CategoryLevelID=-999 
				THEN 
					CategoryLevelID 
				ELSE 
					@CategoryLevelID
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

