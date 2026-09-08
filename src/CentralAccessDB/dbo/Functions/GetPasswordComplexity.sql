-- =============================================
-- Author:		<Stehani>
-- Create date: <2020-11-11>
-- Description:	<Password complexity validation>
-- =============================================
--SELECT dbo.GetPasswordComplexity( 1,'' )
CREATE FUNCTION [dbo].[GetPasswordComplexity] 
(
	@PasswordPolicyId INT,
	@Password VARCHAR(50)
)
RETURNS VARCHAR(100)
AS
BEGIN

	DECLARE @PasswordComplexity VARCHAR(max)
	DECLARE @PasswordLength		INT
	DECLARE @UpperCase			INT
	DECLARE @LowerCase			INT
	DECLARE @Numerics			INT
	DECLARE @SpecialCharacters  INT
	DECLARE @Value              VARCHAR(50)

	SET @PasswordLength = (SELECT [PasswordAttributeId] FROM [dbo].[Central_PasswordPolicyWiseSettings] WHERE [PasswordPolicyId] = @PasswordPolicyId AND [PasswordAttributeId]=1)

	SET @UpperCase = (SELECT [PasswordAttributeId] FROM [dbo].[Central_PasswordPolicyWiseSettings] WHERE [PasswordPolicyId] = @PasswordPolicyId AND [PasswordAttributeId]=2)

	SET @LowerCase = (SELECT [PasswordAttributeId] FROM [dbo].[Central_PasswordPolicyWiseSettings] WHERE [PasswordPolicyId] = @PasswordPolicyId AND [PasswordAttributeId]=3)

	SET @Numerics = (SELECT [PasswordAttributeId] FROM [dbo].[Central_PasswordPolicyWiseSettings] WHERE [PasswordPolicyId] = @PasswordPolicyId AND [PasswordAttributeId]=4)

	SET @SpecialCharacters = (SELECT [PasswordAttributeId] FROM [dbo].[Central_PasswordPolicyWiseSettings] WHERE [PasswordPolicyId] = @PasswordPolicyId AND [PasswordAttributeId]=5)
	
	DECLARE @Value1 VARCHAR(50)
	DECLARE @Value2 VARCHAR(50)
	DECLARE @Value3 VARCHAR(50)
	DECLARE @Value4 VARCHAR(50)
	DECLARE @Value5 VARCHAR(50)

	IF(@PasswordLength>0 OR @PasswordLength IS NOT NULL)
		BEGIN
			SET @Value1 = (SELECT [Value] FROM [dbo].[Central_PasswordPolicyWiseSettings] WHERE [PasswordPolicyId] = @PasswordPolicyId AND [PasswordAttributeId]=1)
			IF(LEN(@Password)<@Value1)
				BEGIN
					SET @PasswordComplexity = 'Your new password must contain at least'+' '+@Value1+' '+'characters.'
				END
		END

	IF(@UpperCase>0 OR @UpperCase IS NOT NULL)
		BEGIN
			SET @Value2 = (SELECT [Value] FROM [dbo].[Central_PasswordPolicyWiseSettings] WHERE [PasswordPolicyId] = @PasswordPolicyId AND [PasswordAttributeId]=2)
			IF(@Value2>0)
				BEGIN
				IF(@Password COLLATE Latin1_General_BIN NOT LIKE '%[A-Z]%')
						BEGIN
							SET @PasswordComplexity = 'Your new password must contain at least one uppercase character'
						END
				END
		END

	IF(@LowerCase>0 OR @LowerCase IS NOT NULL)
		BEGIN
			SET @Value3 = (SELECT [Value] FROM [dbo].[Central_PasswordPolicyWiseSettings] WHERE [PasswordPolicyId] = @PasswordPolicyId AND [PasswordAttributeId]=3)
			IF(@Value3>0)
				BEGIN
				IF(@Password COLLATE Latin1_General_BIN NOT LIKE '%[a-z]%')
						BEGIN
							SET @PasswordComplexity = 'Your new password must contain at least one lowercase character.'
						END
				END
		END

	IF(@Numerics>0 OR @Numerics IS NOT NULL)
		BEGIN
			SET @Value4 = (SELECT [Value] FROM [dbo].[Central_PasswordPolicyWiseSettings] WHERE [PasswordPolicyId] = @PasswordPolicyId AND [PasswordAttributeId]=4)
			IF(@Value4>0)
				BEGIN
				IF(@Password COLLATE Latin1_General_BIN NOT LIKE '%[0-9]%')
						BEGIN
							SET @PasswordComplexity = 'Your new password must contain at least one numeric value.'
						END
				END
		END

	IF(@SpecialCharacters>0 OR @SpecialCharacters IS NOT NULL)
		BEGIN
			SET @Value5 = (SELECT [Value] FROM [dbo].[Central_PasswordPolicyWiseSettings] WHERE [PasswordPolicyId] = @PasswordPolicyId AND [PasswordAttributeId]=5)
			IF(@Value5>0)
				BEGIN
				IF(@Password COLLATE Latin1_General_BIN NOT LIKE '%[~!@#$%^&*]%')
						BEGIN
							SET @PasswordComplexity = 'Your new password must contain at least one special character.'
						END
			END
		END

	IF(ISNULL(LEN(@PasswordComplexity),0)<1)
		BEGIN
			SET @PasswordComplexity = '1'
		END

	RETURN @PasswordComplexity 
END

GO

