CREATE TABLE [dbo].[Central_UserWiseModules] (
    [UserId]            INT           NOT NULL,
    [PropertyId]        INT           NOT NULL,
    [ModuleId]          INT           NOT NULL,
    [EncryptedModuleId] VARCHAR (MAX) NULL,
    [CreatedUserId]     INT           NULL,
    [ModifiedUserId]    INT           NULL,
    [CreatedDate]       DATETIME      CONSTRAINT [DF_UserWiseCentral_Modules_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedDate]      DATETIME      CONSTRAINT [DF_UserWiseCentral_Modules_ModifiedDate] DEFAULT (getdate()) NOT NULL
);


GO

