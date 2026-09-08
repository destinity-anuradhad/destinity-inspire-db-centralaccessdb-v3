
CREATE procedure [FA_Ref].[SelectCategories]
(
	@CategoryID	INT,
	@CatLevelID	INT,
	@ParentCategoryID INT
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

		SELECT CategoryID,C.CategoryLevelID,[ParentCategoryID],L.HaveChilds,C.Name, C.IsActive,CreatedUserID AS UserID,CreatedDate, ModifiedUserID, ModifiedDate
		FROM [fa_ref].Categories C
		INNER JOIN CategoryLevels L ON L.CategoryLevelID = C.CategoryLevelID
		WHERE	CategoryID = CASE WHEN @CategoryID=-999 THEN CategoryID ELSE @CategoryID END 
		AND		C.CategoryLevelID = CASE WHEN @CatLevelID=-999 THEN C.CategoryLevelID ELSE @CatLevelID END 
		AND		ParentCategoryID = CASE WHEN @ParentCategoryID =-999 THEN ParentCategoryID ELSE @ParentCategoryID END 
		AND		C.isActive=1	

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

