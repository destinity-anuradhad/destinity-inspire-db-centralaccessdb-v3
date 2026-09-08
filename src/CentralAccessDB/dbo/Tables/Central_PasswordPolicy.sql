CREATE TABLE [dbo].[Central_PasswordPolicy] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [GroupId]        INT           NULL,
    [Name]           VARCHAR (100) NULL,
    [CreatedUserId]  INT           NULL,
    [ModifiedUserId] INT           NULL,
    [CreatedDate]    DATETIME      CONSTRAINT [DF_Central_PasswordPolicys_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedDate]   DATETIME      CONSTRAINT [DF_Central_PasswordPolicys_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Central_PasswordPolicys] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Central_PasswordPolicy_Central_PasswordPolicy] FOREIGN KEY ([Id]) REFERENCES [dbo].[Central_PasswordPolicy] ([Id])
);


GO

