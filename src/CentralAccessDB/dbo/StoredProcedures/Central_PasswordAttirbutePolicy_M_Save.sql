
CREATE PROCEDURE [dbo].[Central_PasswordAttirbutePolicy_M_Save]
	@Id							INT,
	@Name						VARCHAR(250),
	@DataType					VARCHAR(250),	
	@IsActive					INT,
	@selectedDataTypes			VARCHAR(MAX)
AS
BEGIN
	
	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DECLARE @UserId					INT
	DECLARE @PasswordPolicyId		INT
	DECLARE @PasswordAttributesId	INT
	DECLARE @Value					VARCHAR(250)
	DECLARE @GroupId				VARCHAR(250)
	DECLARE @Ids					INT 

	SET @UserId = @Id
	
	SELECT * FROM Central_PasswordPolicy;
	SELECT * FROM [dbo].[Central_PasswordPolicyWiseSettings]

	SELECT 
	[Id] = @PasswordPolicyId
	FROM [dbo].[Central_PasswordPolicy]
	
	SELECT 
	[Id] = @PasswordAttributesId
	FROM [dbo].[Central_PasswordAttirbutes]

	SELECT * INTO #TempTableselectedDataTypes
	FROM 
	OPENJSON (@selectedDataTypes)
		WITH (
				Id			INT		'$.Id' 
			 )

	SET @Ids = (SELECT COUNT(Id) FROM #TempTableselectedDataTypes)

	IF @Id = 0
	BEGIN
		INSERT INTO Central_PasswordPolicy
		([Id], [GroupId], [Name], [CreatedUserId],[ModifiedUserId], [CreatedDate], [ModifiedDate]) 
		VALUES
		(@Id ,ISNULL(@GroupId, '-1'), @Name, @UserId,@UserId, GETDATE(),GETDATE())
		
		INSERT INTO Central_PasswordPolicyWiseSettings
		([GroupId],[PasswordPolicyId],[PasswordAttributeId],[Value])
		VALUES
		(ISNULL(@GroupId, '-1'), @PasswordPolicyId,@PasswordAttributesId, @Ids)
	END
	ELSE
	BEGIN
		UPDATE Central_PasswordPolicy
		SET			
		Name=@Name		
		WHERE Id=@Id

		UPDATE Central_PasswordPolicyWiseSettings
		SET		
		[Value]=@Ids
		WHERE  PasswordPolicyId=@PasswordPolicyId

	END
 DROP TABLE #TempTableselectedDataTypes
END

GO

