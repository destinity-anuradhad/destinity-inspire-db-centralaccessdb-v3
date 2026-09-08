CREATE TABLE [dbo].[Central_User_Activation_Log] (
    [Id]                    INT      IDENTITY (1, 1) NOT NULL,
    [IsActivePreviousState] BIT      NULL,
    [ModifiedUserId]        INT      NOT NULL,
    [ModifiedDateTime]      DATETIME CONSTRAINT [DF_Central_User_Verification_Log_ModifiedDateTime] DEFAULT (getdate()) NOT NULL,
    [PropertyId]            INT      NOT NULL,
    [UserId]                INT      CONSTRAINT [DF_Central_User_Verification_Log_UserId] DEFAULT ((1)) NOT NULL,
    [IsActive]              BIT      CONSTRAINT [DF_Central_User_Verification_Log_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Central_User_Verification_Log] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

