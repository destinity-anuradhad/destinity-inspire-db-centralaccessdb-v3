-- =============================================
-- Author		:	Ayomi Gunasekara
-- Create date	:	2020-11-11
-- Description	:	Central_Properties_T_Select_ByUserId
-- =============================================
CREATE PROCEDURE [dbo].[Central_Properties_T_Select_ByUserId]
	@UserId INT 
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT CC.*
	FROM [dbo].[Central_Properties] CC
	LEFT JOIN [dbo].[Central_UserWiseProperties] AS CUWP ON CC.Id = CUWP.PropertyId
	WHERE CUWP.UserId = @UserId

END

GO

