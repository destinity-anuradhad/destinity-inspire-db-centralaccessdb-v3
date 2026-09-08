CREATE TABLE [dbo].[Central_UserWiseUserRoles] (
    [UserId]              INT           NOT NULL,
    [UserRoleId]          INT           NOT NULL,
    [EncryptedUserRoleId] VARCHAR (MAX) NULL,
    [GroupId]             INT           NOT NULL,
    [IsMainRole]          BIT           NULL,
    [CreatedUserId]       INT           NULL,
    [ModifiedUserId]      INT           NULL,
    [CreatedDate]         DATETIME      CONSTRAINT [DF_UserWiseUserRoles_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedDate]        DATETIME      CONSTRAINT [DF_UserWiseUserRoles_ModifiedDate] DEFAULT (getdate()) NOT NULL
);


GO

