CREATE TABLE [dbo].[Central_MenuItems] (
    [MenuItemId] INT           NOT NULL,
    [ParentId]   INT           NULL,
    [ModuleId]   INT           NOT NULL,
    [Name]       VARCHAR (500) NULL,
    [URL]        VARCHAR (500) NULL,
    [MenuType]   CHAR (1)      CONSTRAINT [DF_Central_MenuItems_AccessType] DEFAULT ('M') NOT NULL,
    [IsActive]   BIT           CONSTRAINT [DF_Central_MenuItems_IsActive] DEFAULT ((0)) NULL
);


GO

