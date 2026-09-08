CREATE TABLE [dbo].[Central_UserWiseProperties] (
    [Id]                  INT           IDENTITY (1, 1) NOT NULL,
    [UserId]              INT           NOT NULL,
    [PropertyId]          INT           NOT NULL,
    [EncryptedPropertyId] VARCHAR (MAX) NULL,
    [CreatedUserId]       INT           NULL,
    [ModifiedUserId]      INT           NULL,
    [CreatedDate]         DATETIME      CONSTRAINT [DF_UserWiseCentral_Properties_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedDate]        DATETIME      CONSTRAINT [DF_UserWiseCentral_Properties_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_UserWiseCentral_Properties] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

