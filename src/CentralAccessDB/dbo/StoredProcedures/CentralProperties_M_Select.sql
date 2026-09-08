-- =============================================
-- Author:		Ganguli
-- Create date: 2022-08-16
-- Description:	CentralProperties_M_Select
-- =============================================
CREATE PROCEDURE [dbo].[CentralProperties_M_Select]
@IsActive       INT = 2
AS
BEGIN	
	SET NOCOUNT ON;

	SELECT * FROM Central_Properties 
	WHERE(@IsActive = 2 OR @IsActive = IsActive)

END

GO

