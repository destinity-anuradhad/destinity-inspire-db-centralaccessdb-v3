CREATE PROCEDURE [dbo].[Central_UserWiseModuleLogin_T_Save]
	@Id	INT,
	@UserId	INT,
	@PropertyId	INT,
	@ModuleId	INT,
	@Uuid	NVARCHAR(max),
	@BrowserKey NVARCHAR(max),
	@SessionID NVARCHAR(max),
	@SessionStorageId NVARCHAR(max),
	@LocalStorageId NVARCHAR(max),
	@Authority NVARCHAR(max)

AS
BEGIN

--Stehani
-- @Nov 16 2020 12:25PM

	SET NOCOUNT ON;

	UPDATE	[dbo].[Central_UserWiseModuleLogin]
	SET [IsActive] = 0
	WHERE UserId = @UserId


	INSERT INTO Central_UserWiseModuleLogin
	(UserId ,PropertyId ,ModuleId ,Uuid ,TxnDateTime,BrowserKey,SessionID,SessionStorageId,LocalStorageId,Authority,IsActive) 
	VALUES
	(@UserId ,@PropertyId ,@ModuleId ,@Uuid ,GETDATE(),@BrowserKey,@SessionID,@SessionStorageId,@LocalStorageId,@Authority,1)

	

	select @Uuid AS Uuid
	
END

GO

