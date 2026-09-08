CREATE TABLE [dbo].[Admin_Nav_MainNavigationWiseAreas_Base] (
    [Id]                   INT            NOT NULL,
    [MainNavigationId]     INT            NULL,
    [Name]                 NVARCHAR (50)  NULL,
    [Description]          NVARCHAR (250) NULL,
    [Url]                  NVARCHAR (250) NULL,
    [ImageUrl]             NVARCHAR (250) NULL,
    [DisplayOrder]         INT            NULL,
    [IsActive]             BIT            NULL,
    [IsMainMenuNavigation] BIT            NULL,
    [ModuleId]             INT            NOT NULL
);


GO

