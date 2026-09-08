CREATE TABLE [dbo].[UserRoleWisePages] (
    [Id]                  INT      IDENTITY (1, 1) NOT NULL,
    [RoleId]              INT      NOT NULL,
    [MainNavigationId]    INT      NOT NULL,
    [PageId]              INT      NOT NULL,
    [IsAllowInsert]       BIT      CONSTRAINT [DF_UserRoleWisePages_IsAllowInsert] DEFAULT ((0)) NOT NULL,
    [IsAllowUpdate]       BIT      CONSTRAINT [DF_UserRoleWisePages_IsAllowUpdate] DEFAULT ((0)) NOT NULL,
    [IsAllowDelete]       BIT      CONSTRAINT [DF_UserRoleWisePages_IsAllowDelete] DEFAULT ((0)) NOT NULL,
    [IsAllowSelect]       BIT      CONSTRAINT [DF_UserRoleWisePages_IsAllowSelect] DEFAULT ((0)) NOT NULL,
    [CreatedUserId]       INT      NULL,
    [CreatedDateTime]     DATETIME CONSTRAINT [DF_UserRoleWisePages_CreatedDateTime] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedUserId]   INT      NULL,
    [LastUpdatedDateTime] DATETIME CONSTRAINT [DF_UserRoleWisePages_LastUpdatedDateTime] DEFAULT (getdate()) NOT NULL,
    [PropertyId]          INT      NULL,
    CONSTRAINT [PK_UserRoleWisePages] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

