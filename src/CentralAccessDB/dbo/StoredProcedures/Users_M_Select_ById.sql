-- =============================================
-- Author:		Chiraj
-- Create date: 2020-10-15
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[Users_M_Select_ById] 
@Id		INT,
@PropertyId INT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT *
	FROM Users 
	WHERE Id = @Id AND PropertyId=@PropertyId
END

GO

