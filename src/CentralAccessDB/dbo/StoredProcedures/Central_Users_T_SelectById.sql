
-- =============================================
-- Author		:	Ayomi Gunasekara
-- Create date	:	2020-11-13
-- Description	:	Central_Users_T_SelectById
-- =============================================
---exec Central_Users_T_SelectById 4165
CREATE PROCEDURE [dbo].[Central_Users_T_SelectById]
	@Id  INT
AS
BEGIN	
	SET NOCOUNT ON;
	SET DATEFORMAT DMY
	SELECT * FROM Central_Users WHERE Id=@Id
END

GO

