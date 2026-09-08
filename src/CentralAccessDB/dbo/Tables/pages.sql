CREATE TABLE [dbo].[pages] (
    [Id]                   FLOAT (53)     NULL,
    [RootPageId]           NVARCHAR (255) NULL,
    [AreaId]               FLOAT (53)     NULL,
    [Name]                 NVARCHAR (255) NULL,
    [Url]                  NVARCHAR (255) NULL,
    [Icon]                 NVARCHAR (255) NULL,
    [ImageURL]             NVARCHAR (255) NULL,
    [DispayOrder]          FLOAT (53)     NULL,
    [IsActive]             FLOAT (53)     NULL,
    [ModuleId]             FLOAT (53)     NULL,
    [IsMainMenuNavigation] FLOAT (53)     NULL
);


GO

