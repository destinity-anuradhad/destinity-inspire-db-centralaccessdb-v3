--EXEC Central_Property_M_Select @UserId=92
CREATE PROCEDURE [dbo].[Central_Property_M_Select] 
@UserId									INT

AS
BEGIN
	
	SELECT 
	P.Id,
	P.Name,
	P.ServerName,
	P.DataBaseName,
	P.Username,
	P.Password,
	P.IsActive,
	P.Code AS 'Prefix'
	FROM [dbo].[Central_Properties] P

END

GO

