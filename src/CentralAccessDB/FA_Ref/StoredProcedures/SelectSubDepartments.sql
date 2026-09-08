
CREATE procedure [FA_Ref].[SelectSubDepartments] 
(
	@SubDepartmentID	INT,
	@DepartmentID		INT=-999
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

		SELECT	D.Name MainDepartment, SubDepartmentID,S.DepartmentID,S.Name, S.IsActive,S.CreatedUserID AS UserID,S.CreatedDate, S.ModifiedUserID, S.ModifiedDate
		FROM	[fa_ref].SubDepartments S
		INNER JOIN [fa_ref].Departments D ON D.DepartmentID= S.DepartmentID
		WHERE	s.SubDepartmentID = CASE WHEN @SubDepartmentID=-999 THEN s.SubDepartmentID ELSE @SubDepartmentID END
				AND s.DepartmentID = CASE WHEN @DepartmentID=-999 THEN s.DepartmentID ELSE @DepartmentID END

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

