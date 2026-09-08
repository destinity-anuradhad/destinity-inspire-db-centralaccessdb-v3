CREATE TABLE [dbo].[Central_UserRoleWiseMenuItems] (
    [Id]                  INT           IDENTITY (1, 1) NOT NULL,
    [UserRoleId]          INT           NOT NULL,
    [PropertyId]          INT           NOT NULL,
    [ModuleId]            INT           NOT NULL,
    [MenuItemId]          INT           NOT NULL,
    [EncryptedMenuItemId] VARCHAR (MAX) NULL
);


GO

