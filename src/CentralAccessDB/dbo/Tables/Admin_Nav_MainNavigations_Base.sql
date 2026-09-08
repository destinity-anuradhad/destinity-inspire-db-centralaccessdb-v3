CREATE TABLE [dbo].[Admin_Nav_MainNavigations_Base] (
    [Id]                   INT            NOT NULL,
    [Name]                 NVARCHAR (50)  NOT NULL,
    [Description]          NVARCHAR (250) NULL,
    [Url]                  NVARCHAR (100) NULL,
    [DisplayOrder]         INT            NULL,
    [IsActive]             BIT            NULL,
    [TemplateId]           INT            NULL,
    [ModuleId]             INT            NOT NULL,
    [IsMainMenuNavigation] BIT            NULL
);


GO

