---EXEC Central_PasswordPolicyAttribute_M_SelectByPasswordPolicyId @Id=7
CREATE PROCEDURE [dbo].[Central_PasswordPolicyAttribute_M_SelectByPasswordPolicyId]
@Id  INT
AS
BEGIN
	SELECT 
		A.Id AS 'PasswordPolicyId',
		A.[Name] AS 'PasswordPolicy',
		
	(
	SELECT
		B.GroupId,
		B.PasswordAttributeId,
		B.[Value] AS PasswordValue,
	(SELECT [DataType] FROM [dbo].[Central_PasswordAttirbutes] WHERE Id= B.PasswordAttributeId) AS 'DataType',
	(SELECT [Name] FROM [dbo].[Central_PasswordAttirbutes] WHERE Id= B.PasswordAttributeId) AS 'AttributeName'
	FROM [dbo].[Central_PasswordPolicyWiseSettings] B
	WHERE B.PasswordPolicyId = @Id 
	FOR JSON AUTO 
	) AS 'PolicyWiseAttributes'

	
	FROM Central_PasswordPolicy A
	WHERE A.Id=@Id
END

GO

