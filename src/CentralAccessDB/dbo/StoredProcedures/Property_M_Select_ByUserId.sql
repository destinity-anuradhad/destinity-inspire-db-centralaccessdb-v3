-- =============================================
-- Author:		Chiraj
-- Create date: 2020-6-18
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Property_M_Select_ByUserId]
@UserId  INT
AS
BEGIN	
	SET NOCOUNT ON;
	---**** NOte------------------------
	--Without Inventory
	--use Property TAble
	--SELECT U.*
	--FROM Property U
	--Inner join UserWiseProperty AS UWP On U.Id = UWP.ProductId
	--WHERE UWP.UserId = @UserId

	--With Inventory
	--use this company table to link with inventory Db(catelog_crv)
	SELECT C.*,C.CompanyID As Id
	FROM Companies C
	INNER JOIN UserWiseProperty AS UWP On C.CompanyID = UWP.ProductId
	WHERE UWP.UserId = @UserId


END

GO

