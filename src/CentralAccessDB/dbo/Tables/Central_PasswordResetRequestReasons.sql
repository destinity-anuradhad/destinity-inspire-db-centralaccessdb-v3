CREATE TABLE [dbo].[Central_PasswordResetRequestReasons] (
    [Id]              INT            IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (100) NOT NULL,
    [IsActive]        BIT            CONSTRAINT [DF_Central_PasswordResetRequestReasons_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedDateTime] DATETIME       CONSTRAINT [DF_Central_PasswordResetRequestReasons_CreatedDateTime] DEFAULT (getdate()) NOT NULL,
    [CreatedUserId]   INT            CONSTRAINT [DF_Central_PasswordResetRequestReasons_CreatedUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Central_PasswordResetRequestReasons] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

