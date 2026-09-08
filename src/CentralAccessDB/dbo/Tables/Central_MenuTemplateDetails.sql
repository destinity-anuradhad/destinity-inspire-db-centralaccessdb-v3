CREATE TABLE [dbo].[Central_MenuTemplateDetails] (
    [Id]               INT             IDENTITY (1, 1) NOT NULL,
    [TemplateId]       INT             NULL,
    [ParentMenuItemId] INT             NULL,
    [OrderSeq]         DECIMAL (18, 3) NOT NULL,
    [MenuItemId]       INT             NULL,
    [IsActive]         BIT             NOT NULL,
    CONSTRAINT [PK_Central_MenuTemplateDetails] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

