CREATE TABLE [dbo].[Central_UserRoleWiseProperties] (
    [UserRoleId]          INT           NOT NULL,
    [PropertyId]          INT           NOT NULL,
    [EncryptedPropertyId] VARCHAR (MAX) NULL,
    [CreatedUserId]       INT           NULL,
    [ModifiedUserId]      INT           NULL,
    [CreatedDate]         DATETIME      CONSTRAINT [DF_UserRoleWiseCentral_Properties_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedDate]        DATETIME      CONSTRAINT [DF_UserRoleWiseCentral_Properties_ModifiedDate] DEFAULT (getdate()) NOT NULL
);


GO

