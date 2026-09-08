CREATE PROCEDURE [dbo].[Central_Properties_M_SelectByUserIdForApplicableProperties]
@UserId INT
AS
BEGIN
	SELECT A.[PropertyId],
		   B.[Name] AS PropertyName 
	FROM [dbo].[Central_UserWiseProperties] A
	INNER JOIN [dbo].[Central_Properties] B ON B.Id=A.PropertyId
	WHERE A.[UserId]=@UserId
END

--Central_Properties_M_SelectByUserIdForApplicableProperties -1

GO

