

--exec Central_UserWiseModuleLogin_T_SelectById  @Uuid='2bf6ff94-0ca8-4517-af3e-634bac841ae4'
CREATE PROCEDURE [dbo].[Central_UserWiseModuleLogin_T_SelectById]
	@Uuid  NVARCHAR(max)
AS
BEGIN
	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DECLARE @UserId INT
	DECLARE @ModuleId INT
	DECLARE @LastActiveTime DATETIME = GETDATE()
	DECLARE @TimeDiff INT
	DECLARE @Settimeout INT
	DECLARE @PasswordPolicyId INT
	

	SELECT  
	@UserId=[UserId], 
	@ModuleId=[ModuleId] 
	FROM [dbo].[Central_UserWiseModuleLogin] with (nolock)
	WHERE [Uuid]=@Uuid

	SELECT @PasswordPolicyId = [PasswordPolicyId] 
	FROM [dbo].[Central_Users] 
	with (nolock) 
	WHERE [Id]=@UserId
		

	DELETE 
	FROM [dbo].[Central_UserWiseLastActiveTime] 
	WHERE UserId=@UserId 
	AND ModuleId=@ModuleId
		
	DELETE 
	FROM [dbo].[Central_UserWiseLastActiveTime] 
	WHERE UserId IS NULL

	INSERT INTO [dbo].[Central_UserWiseLastActiveTime]
    (
		[UserId]
		,[ModuleId]
		,[LastActiveTime]
	)
	VALUES(@UserId,@ModuleId,GETDATE())


	DECLARE @ReportServerPassword NVARCHAR(250)
	SELECT TOP (1) @ReportServerPassword =[ReportServerPassword] FROM [dbo].[ReportSettings]  with (nolock) 

	SELECT	TOP 1 
	A.*, 
	B.Name AS  'ModuleName', 
	C.Name AS 'PropertyName',  
	D.Username, C.Code As 'PropertyCode',
	C.DataBaseName,
	C.ServerName,
	C.Username AS DatabaseUsername,
	c.Password As DatabasePassword,
	D.UniqueId,
	C.GLCompCode,
	@ReportServerPassword AS ReportServerPassword,
	[ServerNameBanquet],
	[DataBaseNameBanquet],
	[UsernameBanquet],
	[PasswordBanquet]
	FROM	Central_UserWiseModuleLogin  A with (nolock)
	INNER JOIN Central_Modules B with (nolock) ON A.ModuleId = B.Id
	INNER JOIN Central_Properties C with (nolock) ON C.Id = A.PropertyId
	INNER JOIN Central_Users D with (nolock) ON D.Id = A.UserId
	WHERE	Uuid = @Uuid
	AND A.IsActive = 1
	order by A.Id desc

END

GO

