CREATE TABLE [dbo].[Central_PasswordResetRequestLog] (
    [Id]                           INT            IDENTITY (1, 1) NOT NULL,
    [UserId]                       INT            NOT NULL,
    [PasswordResetRequestReasonId] INT            NOT NULL,
    [Remark]                       NVARCHAR (500) NULL,
    [TxnDateTime]                  DATETIME       CONSTRAINT [DF_Central_PasswordResetRequestLog_TxnDateTime] DEFAULT (getdate()) NOT NULL,
    [TxnUserId]                    INT            NOT NULL,
    CONSTRAINT [PK_Central_PasswordResetRequestLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

