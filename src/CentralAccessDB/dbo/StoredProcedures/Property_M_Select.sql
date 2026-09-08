
-- =============================================
-- Author:		Chiraj
-- Create date: 2020-6-18
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Property_M_Select]
@IsActive       INT = 2
AS
BEGIN	
	SET NOCOUNT ON;

---**** NOte------------------------
	--Without Inventory
	--use Property TAble
	--SELECT *	FROM Property 
	--WHERE Id = @Id

	--With Inventory
	--use this company table to link with inventory Db(catelog_crv)
	SELECT * FROM Companies 
	WHERE(@IsActive = 2 OR @IsActive = IsActive)

END

GO

