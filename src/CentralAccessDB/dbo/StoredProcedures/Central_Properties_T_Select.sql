
-- =============================================
-- Author		:	Ayomi Gunasekara
-- Create date	:	2020-11-13
-- Description	:	Central_Properties_T_Select
-- =============================================
CREATE PROCEDURE [dbo].[Central_Properties_T_Select]	
AS
BEGIN	
	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * FROM Central_Properties
	WHERE [Name]<>'NULL'
END

GO

