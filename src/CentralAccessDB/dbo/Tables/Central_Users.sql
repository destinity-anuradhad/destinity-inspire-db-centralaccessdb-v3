CREATE TABLE [dbo].[Central_Users] (
    [Id]                                INT              IDENTITY (1, 1) NOT NULL,
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
    [IsLoked]                           BIT              CONSTRAINT [DF_Users_IsLoked] DEFAULT ((0)) NOT NULL,
    [IsPermanentlyLocked]               BIT              CONSTRAINT [DF_Central_Users_IsPermanentlyLocked] DEFAULT ((0)) NOT NULL,
    [IsPasswordResetRequested]          BIT              NULL,
    [LastLoginDate]                     DATETIME         NULL,
    [TerminationDate]                   DATE             NULL,
    [NextPasswordTerminationReminderOn] DATE             NULL,
    [LeagalIdnumber]                    VARCHAR (100)    NULL,
    [IsActive]                          BIT              NULL,
    [CreatedUserId]                     INT              NULL,
    [ModifiedUserId]                    INT              NULL,
    [CreatedDate]                       DATETIME         CONSTRAINT [DF_Users_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedDate]                      DATETIME         CONSTRAINT [DF_Users_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [PasswordPolicyId]                  INT              NULL,
    [LoginAttempts]                     INT              CONSTRAINT [DF_Central_Users_RemainingLoginAttempts] DEFAULT ((0)) NOT NULL,
    [UniqueId]                          UNIQUEIDENTIFIER NOT NULL,
    [CentralRemark]                     NVARCHAR (1000)  NULL,
    [IsStagingUser]                     BIT              CONSTRAINT [DF__Central_U__IsSta__00750D23] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Central_Users_Central_PasswordPolicy] FOREIGN KEY ([PasswordPolicyId]) REFERENCES [dbo].[Central_PasswordPolicy] ([Id])
);


GO

