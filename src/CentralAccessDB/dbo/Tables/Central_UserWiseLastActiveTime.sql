CREATE TABLE [dbo].[Central_UserWiseLastActiveTime] (
    [Id]             INT      IDENTITY (1, 1) NOT NULL,
    [UserId]         INT      NULL,
    [ModuleId]       INT      NULL,
    [LastActiveTime] DATETIME NOT NULL,
    CONSTRAINT [PK_Central_UserWiseLastActiveTime] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

