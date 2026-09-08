CREATE TABLE [dbo].[Central_UserLockUnlockReasons] (
    [Id]              INT            IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (250) NOT NULL,
    [Process]         NVARCHAR (10)  CONSTRAINT [DF_Central_Process] DEFAULT (N'TL') NOT NULL,
    [IsActive]        BIT            CONSTRAINT [DF_Central_UserLockUnlockReasons_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedDateTime] DATETIME       CONSTRAINT [DF_Central_CreatedDateTime] DEFAULT (getdate()) NOT NULL,
    [CreatedUserId]   INT            CONSTRAINT [DF_Central_CreatedUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Central] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

