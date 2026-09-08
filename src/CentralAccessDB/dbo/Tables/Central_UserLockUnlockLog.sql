CREATE TABLE [dbo].[Central_UserLockUnlockLog] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [UserId]             INT            NOT NULL,
    [LockUnlockReasonId] INT            NOT NULL,
    [Remark]             NVARCHAR (500) NULL,
    [TxnDateTime]        DATETIME       CONSTRAINT [DF_Central_UserLockUnlockLog_TxnDateTime] DEFAULT (getdate()) NOT NULL,
    [TxnUserId]          INT            NOT NULL,
    CONSTRAINT [PK_Central_UserLockUnlockLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

