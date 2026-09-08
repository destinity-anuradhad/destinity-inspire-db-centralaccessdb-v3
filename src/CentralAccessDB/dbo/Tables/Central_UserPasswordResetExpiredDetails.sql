CREATE TABLE [dbo].[Central_UserPasswordResetExpiredDetails] (
    [Id]              INT            IDENTITY (1, 1) NOT NULL,
    [UserId]          INT            NULL,
    [PasswordReset]   DATETIME       NULL,
    [PasswordExpired] DATETIME       NULL,
    [Remark]          NVARCHAR (500) NULL
);


GO

