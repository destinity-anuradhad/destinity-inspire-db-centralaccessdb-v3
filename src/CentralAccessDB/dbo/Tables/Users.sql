CREATE TABLE [dbo].[Users] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [EmployeeId]         INT            NULL,
    [PropertyId]         INT            NULL,
    [ProductId]          INT            NULL,
    [Username]           NVARCHAR (20)  NULL,
    [Password]           NVARCHAR (500) NULL,
    [UserRoleId]         INT            NULL,
    [Salt]               NVARCHAR (500) NULL,
    [Guid]               NVARCHAR (500) NULL,
    [POSPassword]        NVARCHAR (MAX) CONSTRAINT [DF_Users_POSPassword] DEFAULT ('') NULL,
    [AccessCardNo]       NVARCHAR (50)  CONSTRAINT [DF_Users_AccessCardNo] DEFAULT ('') NULL,
    [IsPOSUser]          BIT            NULL,
    [IsUpload]           BIT            NULL,
    [IsActive]           BIT            CONSTRAINT [DF_Users_IsActive] DEFAULT ((0)) NOT NULL,
    [IsLocked]           BIT            NOT NULL,
    [CreatedUserId]      INT            NOT NULL,
    [CreatedDateTime]    DATETIME       NOT NULL,
    [LastEditedUserId]   INT            NULL,
    [LastEditedDateTime] DATETIME       NULL,
    [IsGroupUser]        BIT            NULL,
    CONSTRAINT [PK_dbo.Users] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UNQ__Users__UserName] UNIQUE NONCLUSTERED ([Username] ASC)
);


GO

