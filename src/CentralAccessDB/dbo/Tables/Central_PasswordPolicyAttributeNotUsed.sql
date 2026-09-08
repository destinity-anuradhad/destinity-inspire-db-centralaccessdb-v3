CREATE TABLE [dbo].[Central_PasswordPolicyAttributeNotUsed] (
    [Id]       INT           IDENTITY (1, 1) NOT NULL,
    [Name]     VARCHAR (500) NOT NULL,
    [IsActive] BIT           NOT NULL,
    [Value]    INT           NULL,
    CONSTRAINT [PK_Central_PasswordPolicyAttribute] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

