

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Test_Insert]
@Id			INT,  
@Name		VARCHAR(250)
AS
BEGIN	
	SET NOCOUNT ON;
	INSERT INTO [dbo].[Test]  
           ([Id]  
           ,[Name])
    VALUES  
           (@Id,
		   @Name)  
END

GO

