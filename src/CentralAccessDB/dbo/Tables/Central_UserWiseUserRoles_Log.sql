CREATE TABLE [dbo].[Central_UserWiseUserRoles_Log] (
    [UserId]              INT             NOT NULL,
    [UserRoleId]          INT             NOT NULL,
    [EncryptedUserRoleId] VARCHAR (MAX)   NULL,
    [GroupId]             INT             NOT NULL,
    [IsMainRole]          BIT             NULL,
    [CreatedUserId]       INT             NULL,
    [ModifiedUserId]      INT             NULL,
    [CreatedDate]         DATETIME        NOT NULL,
    [ModifiedDate]        DATETIME        NOT NULL,
    [Uuid]                NVARCHAR (2000) NULL
);


GO

