CREATE TABLE [dbo].[UserWiseProperty] (
    [Id]                  INT      IDENTITY (1, 1) NOT NULL,
    [UserId]              INT      NOT NULL,
    [ProductId]           INT      NOT NULL,
    [IsActive]            BIT      NULL,
    [CreatedUserId]       INT      NULL,
    [CreatedDateTime]     DATETIME NOT NULL,
    [LastUpdatedUserId]   INT      NULL,
    [LastUpdatedDateTime] DATETIME NULL,
    CONSTRAINT [PK_HUserWiseProperty] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

