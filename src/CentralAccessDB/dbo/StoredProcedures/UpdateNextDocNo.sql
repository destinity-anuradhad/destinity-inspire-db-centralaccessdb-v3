-- =============================================
-- Author:		Sachith
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateNextDocNo]
	@Code VARCHAR(MAX)
AS
BEGIN
	
	UPDATE [dbo].[DocumentNumbers]
	SET [NextNo] = [NextNo]+1
	WHERE Code = @Code

END

GO

