CREATE TABLE [dbo].[Central_Users_DeletedUserLog] (
    [Id]                                INT              IDENTITY (1, 1) NOT NULL,
    [CentralUserId]                     INT              NULL,
    [GroupId]                           INT              NULL,
    [UserName]                          VARCHAR (200)    NULL,
    [Password]                          NVARCHAR (MAX)   NULL,
    [FullName]                          VARCHAR (100)    NULL,
    [EmpNumber]                         VARCHAR (50)     NULL,
    [Email]                             VARCHAR (100)    NULL,
    [MobileNumber]                      VARCHAR (50)     NULL,
    [DesignationId]                     INT              NOT NULL,
    [DepartmentId]                      INT              NOT NULL,
    [AuhenticatedMethordId]             INT              NOT NULL,
    [IsLoked]                           BIT              NOT NULL,
    [IsPermanentlyLocked]               BIT              NOT NULL,
    [IsPasswordResetRequested]          BIT              NULL,
    [LastLoginDate]                     DATETIME         NULL,
    [TerminationDate]                   DATE             NULL,
    [NextPasswordTerminationReminderOn] DATE             NULL,
    [LeagalIdnumber]                    VARCHAR (100)    NULL,
    [IsActive]                          BIT              NULL,
    [CreatedUserId]                     INT              NULL,
    [ModifiedUserId]                    INT              NULL,
    [CreatedDate]                       DATETIME         NOT NULL,
    [ModifiedDate]                      DATETIME         NOT NULL,
    [PasswordPolicyId]                  INT              NULL,
    [LoginAttempts]                     INT              NOT NULL,
    [UniqueId]                          UNIQUEIDENTIFIER NOT NULL
);


GO

