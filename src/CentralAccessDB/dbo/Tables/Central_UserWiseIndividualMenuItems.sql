CREATE TABLE [dbo].[Central_UserWiseIndividualMenuItems] (
    [PropertyId]          INT           NOT NULL,
    [UserId]              INT           NOT NULL,
    [ModuleId]            INT           NOT NULL,
    [MenuItemId]          INT           NOT NULL,
    [EncryptedMenuItemId] VARCHAR (MAX) NULL,
    [CreatedUserId]       INT           NULL,
    [ModifiedUserId]      INT           NULL,
    [CreatedDate]         DATETIME      CONSTRAINT [DF_Central_UserDirectAccess_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedDate]        DATETIME      CONSTRAINT [DF_Central_UserDirectAccess_ModifiedDate] DEFAULT (getdate()) NOT NULL
);


GO

