CREATE TABLE [dbo].[Central_Outlets] (
    [Id]                 INT               IDENTITY (1, 1) NOT NULL,
    [Code]               NVARCHAR (5)      NULL,
    [Name]               NVARCHAR (50)     NULL,
    [IsActive]           BIT               NULL,
    [Address]            NVARCHAR (500)    NULL,
    [Description]        NVARCHAR (500)    NULL,
    [PickUpTime]         INT               NULL,
    [CreatedUserId]      INT               NULL,
    [CreatedDateTime]    DATETIME          NULL,
    [LastEditedUserId]   INT               NULL,
    [LastEditedDateTime] DATETIME          NULL,
    [Point]              [sys].[geography] NULL,
    [PromiseTime]        INT               NULL,
    [Emails]             NVARCHAR (1000)   NULL,
    CONSTRAINT [PK_Central_Outlets] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

