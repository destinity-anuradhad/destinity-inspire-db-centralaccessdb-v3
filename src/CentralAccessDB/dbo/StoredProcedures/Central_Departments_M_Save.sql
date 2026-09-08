CREATE PROCEDURE [dbo].[Central_Departments_M_Save]
	@Id	int,
	@PropertyId	int = NULL,
	@Name	varchar(100) = NULL,
	@IsActive	bit = NULL,
	@UserId INT = -1,
	@CreatedUserId	int = NULL,
	@ModifiedUserId	int = NULL,
	@CreatedDate	datetime = NULL,
	@ModifiedDate	datetime = NULL
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:40PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DECLARE @GroupId INT
	SET @GroupId = (SELECT [GroupId] FROM [dbo].[Central_Properties] WHERE Id=@PropertyId)

	IF @Id = 0
	BEGIN
		INSERT INTO Central_Departments
		(GroupId ,Name ,IsActive ,CreatedUserId ,ModifiedUserId ,CreatedDate ,ModifiedDate) 
		VALUES
		(@GroupId ,@Name ,@IsActive ,@CreatedUserId ,@ModifiedUserId ,@CreatedDate ,@ModifiedDate)

		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_Departments',@Id,'CA','DepCI','I',@UserId,@Id, @Name
		-- End of Audit trail ---------------------
	END
	ELSE
	BEGIN
		UPDATE Central_Departments
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
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_Departments',@Id,'CA','DepCU','U',@UserId,@Id, @Name
		-- End of Audit trail ---------------------
	END
END

GO

