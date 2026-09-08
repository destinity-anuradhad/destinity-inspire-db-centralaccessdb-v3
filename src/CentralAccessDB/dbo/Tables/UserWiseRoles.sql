CREATE TABLE [dbo].[UserWiseRoles] (
    [Id]                  INT      IDENTITY (1, 1) NOT NULL,
    [UserId]              INT      NOT NULL,
    [RoleId]              INT      NOT NULL,
    [IsActive]            BIT      CONSTRAINT [DF_UserWiseRoles_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedUserId]       INT      NULL,
    [CreatedDateTime]     DATETIME CONSTRAINT [DF_UserWiseRoles_CreatedDateTime] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedUserId]   INT      NULL,
    [LastUpdatedDateTime] DATETIME CONSTRAINT [DF_UserWiseRoles_LastUpdatedDateTime] DEFAULT (getdate()) NOT NULL,
    [PropertyId]          INT      NULL,
    CONSTRAINT [PK_UserWiseRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

