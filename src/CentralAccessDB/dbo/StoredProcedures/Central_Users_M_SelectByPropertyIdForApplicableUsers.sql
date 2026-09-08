-- =============================================
-- Author:		Ganguli
-- Create date: 2022-08-16
-- Description:	Select User by PropertyId
--exec Central_Users_M_SelectByPropertyIdForApplicableUsers 2
-- =============================================
CREATE PROCEDURE [dbo].[Central_Users_M_SelectByPropertyIdForApplicableUsers]

@PropertyId INT=0

AS
BEGIN

	SET NOCOUNT ON;

	SELECT * 
	FROM Central_Users A
	--INNER JOIN Central_UserwiseProperties B ON A.Id=B.UserId
	--WHERE B.PropertyId=@PropertyId

	--select * from [Central_UserWiseProperties]
	--where PropertyId=2
END

GO

