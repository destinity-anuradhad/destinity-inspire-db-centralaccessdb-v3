CREATE TABLE [dbo].[Central_UserLoginAttempts_History] (
    [Id]          BIGINT         NOT NULL,
    [UserId]      INT            NOT NULL,
    [Status]      CHAR (1)       NOT NULL,
    [TxnDateTime] DATETIME       NOT NULL,
    [BrowserKey]  NVARCHAR (MAX) NULL,
    [IPAddress]   NVARCHAR (MAX) NULL
);


GO

