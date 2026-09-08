CREATE TABLE [dbo].[UserWiseIndividualAccess] (
    [Id]                  INT      IDENTITY (1, 1) NOT NULL,
    [UserId]              INT      NOT NULL,
    [PropertyId]          INT      NULL,
    [MainNavigationId]    INT      NOT NULL,
    [PageId]              INT      NOT NULL,
    [IsAllowInsert]       BIT      NOT NULL,
    [IsAllowUpdate]       BIT      NOT NULL,
    [IsAllowDelete]       BIT      NOT NULL,
    [IsAllowSelect]       BIT      NOT NULL,
    [CreatedUserId]       INT      NULL,
    [CreatedDateTime]     DATETIME NOT NULL,
    [LastUpdatedUserId]   INT      NULL,
    [LastUpdatedDateTime] DATETIME NOT NULL,
    CONSTRAINT [PK_UserWiseIndividualAccess] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

