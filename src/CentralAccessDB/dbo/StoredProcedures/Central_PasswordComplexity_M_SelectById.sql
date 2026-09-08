---EXEC Central_PasswordComplexity_M_SelectById @PasswordPolicyId=1
CREATE PROCEDURE [dbo].[Central_PasswordComplexity_M_SelectById]
@PasswordPolicyId  INT
AS
BEGIN
	SELECT DISTINCT A.*,
	B.[Name],
	B.Regex
	FROM [dbo].[Central_PasswordPolicyWiseSettings] A
	INNER JOIN [dbo].[Central_PasswordAttirbutes] B ON B.Id=A.PasswordAttributeId
	WHERE [PasswordPolicyId] = @PasswordPolicyId AND B.PasswordPolicySegmentId = 1
	ORDER BY Name
END

GO

