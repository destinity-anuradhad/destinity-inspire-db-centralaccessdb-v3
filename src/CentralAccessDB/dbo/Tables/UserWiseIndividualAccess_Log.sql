CREATE TABLE [dbo].[UserWiseIndividualAccess_Log] (
    [Id]                  INT             NOT NULL,
    [UserId]              INT             NOT NULL,
    [PropertyId]          INT             NULL,
    [MainNavigationId]    INT             NOT NULL,
    [PageId]              INT             NOT NULL,
    [IsAllowInsert]       BIT             NOT NULL,
    [IsAllowUpdate]       BIT             NOT NULL,
    [IsAllowDelete]       BIT             NOT NULL,
    [IsAllowSelect]       BIT             NOT NULL,
    [CreatedUserId]       INT             NULL,
    [CreatedDateTime]     DATETIME        NOT NULL,
    [LastUpdatedUserId]   INT             NULL,
    [LastUpdatedDateTime] DATETIME        NOT NULL,
    [Uuid]                NVARCHAR (2000) NULL
);


GO

