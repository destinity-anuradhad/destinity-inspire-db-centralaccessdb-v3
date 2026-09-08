

-- =============================================
-- Author		:	Ayomi Gunasekara
-- Create date	:	2020-11-23
-- Description	:	Central Password Attribute Select
-- =============================================
CREATE PROCEDURE [dbo].[Central_PasswordAttributes_M_Select]	
@IsActive		INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT * FROM
	[dbo].[Central_PasswordAttirbutes]
	WHERE IsActive = 1


END

GO

