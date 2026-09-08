--exec Reports_InputParameterDetails_Select 4179,1,1
CREATE PROCEDURE [dbo].[Reports_InputParameterDetails_Select]
	@UserId INT,
	@PropertyId INT,
	@ModuleId INT
AS
BEGIN
	DECLARE @UserName NVARCHAR(100)
	DECLARE @Property NVARCHAR(100)
	DECLARE @Module NVARCHAR(100)

	SELECT @UserName = UserName FROM Central_Users WHERE Id=@UserId
	SELECT @Property = Name FROM Central_Properties WHERE Id=@PropertyId
	SELECT @Module = Name FROM Central_Modules WHERE Id=@ModuleId

	SELECT @UserName AS UserName,@Property AS PropertyName,@Module AS ModuleName
END

GO

