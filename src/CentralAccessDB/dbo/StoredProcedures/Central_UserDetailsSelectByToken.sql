-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Central_UserDetailsSelectByToken] 
	
	@token Nvarchar (500)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	select 
	[UserId] as Id,
	[UserId],
	[PropertyId], 
	[ModuleId],
	[Uuid], 
	[TxnDateTime],
	[BrowserKey], [SessionID],
	[SessionStorageId], [LocalStorageId],
	[Authority], [IsActive], 
	[LastActiveDateTime], 
	[LastCashierLoggedInDateTime]
	from Central_UserWiseModuleLogin A WITH(NOLOCK)
	WHERE A.Uuid=@token

    -- Insert statements for procedure here
	
	end

GO

