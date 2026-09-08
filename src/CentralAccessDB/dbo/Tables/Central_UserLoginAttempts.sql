CREATE TABLE [dbo].[Central_UserLoginAttempts] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [UserId]      INT            NOT NULL,
    [Status]      CHAR (1)       CONSTRAINT [DF_Central_UserLoginAttempts_Status] DEFAULT ('F') NOT NULL,
    [TxnDateTime] DATETIME       CONSTRAINT [DF_Central_UserLoginAttempts_TxnDateTime] DEFAULT (getdate()) NOT NULL,
    [BrowserKey]  NVARCHAR (MAX) NULL,
    [IPAddress]   NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Central_UserLoginAttempts] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

