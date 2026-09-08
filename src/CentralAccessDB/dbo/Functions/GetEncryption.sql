

-- GetEncryption 'QA3','1234'
CREATE FUNCTION [dbo].[GetEncryption] 
(
	@Key	VARCHAR(MAX),
	@Salt	VARCHAR(MAX)
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @Encryption	VARCHAR(50)

	SET @Encryption =  CONVERT(VARCHAR(MAX), HASHBYTES('SHA2_512', (@Key + @Salt)))
	
	RETURN @Encryption

END

GO

