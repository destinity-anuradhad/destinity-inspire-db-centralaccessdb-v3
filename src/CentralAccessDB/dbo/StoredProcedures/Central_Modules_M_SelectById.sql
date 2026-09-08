
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Central_Modules_M_SelectById]
	@Id INT
AS
BEGIN
	SELECT * FROM Central_Modules
	WHERE Id = @Id
END

GO

