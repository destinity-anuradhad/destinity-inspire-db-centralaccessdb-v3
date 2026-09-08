CREATE PROCEDURE [dbo].[Central_PasswordPolicy_M_Save]
	@Id	int,
	@PropertyId	int = NULL,
	@Name	varchar(100) = NULL,
	@UserId INT=-1,
	@CreatedUserId	int = NULL,
	@ModifiedUserId	int = NULL,
	@CreatedDate	datetime=null,
	@ModifiedDate	datetime=null
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:48PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DECLARE @GroupId INT

	SET @GroupId=(SELECT [GroupId] FROM [dbo].[Central_Properties] WHERE Id=@PropertyId)

	IF @Id = 0
	BEGIN
		INSERT INTO Central_PasswordPolicy
		(GroupId ,Name ,CreatedUserId ,ModifiedUserId ,CreatedDate ,ModifiedDate) 
		VALUES
		(@GroupId ,@Name ,@CreatedUserId ,@ModifiedUserId ,@CreatedDate ,@ModifiedDate)
	END
	ELSE
	BEGIN
		UPDATE Central_PasswordPolicy
		SET
		GroupId=@GroupId,
		Name=@Name,
		CreatedUserId=@CreatedUserId,
		ModifiedUserId=@ModifiedUserId,
		CreatedDate=@CreatedDate,
		ModifiedDate=@ModifiedDate
		WHERE Id=@Id
	END
END

GO

