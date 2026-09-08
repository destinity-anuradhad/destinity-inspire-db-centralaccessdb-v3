CREATE PROCEDURE [dbo].[Central_PasswordPolicyWiseSettings_M_Save]
	@PropertyId	int = NULL,
	@PasswordPolicyId	int,
	@PasswordAttributeId	int = NULL,
	@Value	varchar(50) = NULL
AS
BEGIN


--Stehani
-- @Nov 10 2020 12:39PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DECLARE @GroupId INT
	SET @GroupId = (SELECT [GroupId] FROM [dbo].[Central_Properties] WHERE Id=@PropertyId)

		INSERT INTO Central_PasswordPolicyWiseSettings
		(GroupId ,PasswordPolicyId ,PasswordAttributeId ,Value) 
		VALUES
		(@GroupId ,@PasswordPolicyId ,@PasswordAttributeId ,@Value)
	
END

GO

