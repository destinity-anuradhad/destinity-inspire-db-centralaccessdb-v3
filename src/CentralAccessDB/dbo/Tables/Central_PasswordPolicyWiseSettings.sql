CREATE TABLE [dbo].[Central_PasswordPolicyWiseSettings] (
    [Id]                  BIGINT       IDENTITY (1, 1) NOT NULL,
    [GroupId]             INT          NULL,
    [PasswordPolicyId]    INT          NOT NULL,
    [PasswordAttributeId] INT          NULL,
    [Value]               VARCHAR (50) NULL
);


GO

