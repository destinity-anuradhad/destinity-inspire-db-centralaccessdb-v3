CREATE TABLE [dbo].[UserLoggingAttempts] (
    [Id]                    INT            IDENTITY (1, 1) NOT NULL,
    [LoggingUserName]       VARCHAR (500)  NULL,
    [LoggingAttemtDateTime] DATETIME       NULL,
    [Message]               NVARCHAR (500) NULL,
    [IsSuccessLogging]      INT            NULL
);


GO

