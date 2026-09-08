-- =============================================
-- Author:		Chiraj	
-- Create date: 2020-10-15
-- Description:	Select AlertTypes by Id
-- =============================================
CREATE PROCEDURE [dbo].[Property_M_Select_ById] 
@Id		INT
AS
BEGIN
	SET NOCOUNT ON;
	--SELECT *	FROM Property 
	--use this company table to link with inventory Db(catelog_crv)
	SELECT *,CompanyID As Id FROM Companies
	WHERE CompanyID = @Id
END

GO

