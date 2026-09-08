CREATE TABLE [dbo].[Central_UserWiseOutlets] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [UserId]            INT            NOT NULL,
    [PropertyId]        INT            NULL,
    [OutletId]          INT            NOT NULL,
    [EncryptedOutletId] NVARCHAR (MAX) NULL,
    [CreatedUserId]     INT            NULL,
    [ModifiedUserId]    INT            NULL,
    [CreatedDate]       DATETIME       NOT NULL,
    [ModifiedDate]      DATETIME       NOT NULL,
    CONSTRAINT [PK_Central_UserWiseOutlets] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

