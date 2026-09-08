CREATE TABLE [dbo].[Central_Modules] (
    [Id]                INT            NOT NULL,
    [Name]              VARCHAR (200)  NULL,
    [IsActive]          BIT            CONSTRAINT [DF_Central_Modules_IsActive] DEFAULT ((0)) NULL,
    [Color]             VARCHAR (200)  NULL,
    [Image]             VARCHAR (MAX)  NULL,
    [PublishUrl]        NVARCHAR (250) NULL,
    [Code]              NVARCHAR (10)  NULL,
    [OrderId]           INT            NULL,
    [StagingPublishUrl] NVARCHAR (250) NULL,
    CONSTRAINT [PK_Central_Modules] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

