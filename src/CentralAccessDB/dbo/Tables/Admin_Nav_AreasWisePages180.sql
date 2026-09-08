CREATE TABLE [dbo].[Admin_Nav_AreasWisePages180] (
    [Id]                   INT            NOT NULL,
    [RootPageId]           INT            NULL,
    [AreaId]               INT            NULL,
    [Name]                 NVARCHAR (50)  NULL,
    [Url]                  NVARCHAR (250) NULL,
    [Icon]                 NVARCHAR (50)  NULL,
    [ImageURL]             NVARCHAR (100) NULL,
    [DispayOrder]          INT            NULL,
    [IsActive]             BIT            NULL,
    [ModuleId]             INT            NULL,
    [IsMainMenuNavigation] BIT            NULL
);


GO

