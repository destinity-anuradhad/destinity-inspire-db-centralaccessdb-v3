CREATE TABLE [dbo].[Central_PropertyWiseModuleWiseMenuTemplates] (
    [PropertyId] INT NOT NULL,
    [ModuleId]   INT NOT NULL,
    [TemplateId] INT NOT NULL,
    [IsActive]   BIT CONSTRAINT [DF_Central_TemplatesAssignment_IsActive] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Central_TemplatesAssignment] PRIMARY KEY CLUSTERED ([PropertyId] ASC, [ModuleId] ASC, [TemplateId] ASC)
);


GO

