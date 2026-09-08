
-- PropertyGroup_M_Select_UserWise  'CHD',71
CREATE PROCEDURE [dbo].[PropertyGroup_M_Select_UserWise]  --'HSI'
@Prefix									NVARCHAR(100),
@UserId									INT
AS
BEGIN
	
	

	SELECT CC.*, CC.code 'Prefix'
	FROM [dbo].[Central_Properties] CC
	LEFT JOIN [dbo].[Central_UserWiseProperties] AS CUWP ON CC.Id = CUWP.PropertyId
	WHERE CUWP.UserId = @UserId

END

GO

