CREATE PROCEDURE [dbo].[Central_Designations_M_Save]
	@Id	int,
	@GroupId	int,
	@Name	varchar(100) = NULL,
	@IsActive	bit = NULL,
	@UserId INT = -1,
	@CreatedUserId	int = NULL,
	@ModifiedUserId	int = NULL,
	@CreatedDate	datetime=null,
	@ModifiedDate	datetime=null
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:44PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	IF @Id = 0
	BEGIN
		INSERT INTO Central_Designations
		(GroupId ,Name ,IsActive ,CreatedUserId ,ModifiedUserId ,CreatedDate ,ModifiedDate) 
		VALUES
		(@GroupId ,@Name ,@IsActive ,@CreatedUserId ,@ModifiedUserId ,@CreatedDate ,@ModifiedDate)

		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_Designations',@Id,'CA','DesCI','I',@UserId,@Id, @Name
		-- End of Audit trail ---------------------
	END
	ELSE
	BEGIN
		UPDATE Central_Designations
		SET
		GroupId=@GroupId,
		Name=@Name,
		IsActive=@IsActive,
		CreatedUserId=@CreatedUserId,
		ModifiedUserId=@ModifiedUserId,
		CreatedDate=@CreatedDate,
		ModifiedDate=@ModifiedDate
		WHERE Id=@Id

		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_Designations',@Id,'CA','DesCU','U',@UserId,@Id, @Name
		-- End of Audit trail ---------------------
	END
END

GO

