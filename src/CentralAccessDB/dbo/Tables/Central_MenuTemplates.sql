CREATE TABLE [dbo].[Central_MenuTemplates] (
    [Id]       INT           IDENTITY (1, 1) NOT NULL,
    [ModuleId] INT           NOT NULL,
    [Name]     VARCHAR (200) NULL,
    [IsActive] BIT           CONSTRAINT [DF_MenuTemplate_IsActive] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_MenuTemplate] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

