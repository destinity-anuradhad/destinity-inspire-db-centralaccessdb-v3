CREATE PROCEDURE [dbo].[Central_AuthenticationMethords_M_Save]
	@Id	int,
	@Name	varchar(100) = NULL,
	@IsActive	bit,
	@UserId INT=-1
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:35PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	IF @Id = 0
	BEGIN
		INSERT INTO Central_AuthenticationMethords
		(Name ,IsActive) 
		VALUES
		(@Name ,@IsActive)

		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_AuthenticationMethords',@Id,'CA','AMCI','I',@UserId,@Id, @Name
		-- End of Audit trail ---------------------
	END
	ELSE
	BEGIN
		UPDATE Central_AuthenticationMethords
		SET
		Name=@Name,
		IsActive=@IsActive
		WHERE Id=@Id

		-- Audit trail ----------------------------
		EXEC HotelResWeb_AuditTail_WriteToLog 'Central_AuthenticationMethords',@Id,'CA','AMCU','U',@UserId,@Id, @Name
		-- End of Audit trail ---------------------
	END
END

GO

