
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Central_Properties_M_SelectById]
@Id INt
AS
BEGIN
	select * from Central_Properties
	Where Id = @Id
END

GO

