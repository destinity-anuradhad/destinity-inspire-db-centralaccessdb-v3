CREATE TABLE [dbo].[Central_Designations] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [GroupId]        INT           NOT NULL,
    [Name]           VARCHAR (100) NULL,
    [IsActive]       BIT           NULL,
    [CreatedUserId]  INT           NULL,
    [ModifiedUserId] INT           NULL,
    [CreatedDate]    DATETIME      CONSTRAINT [DF_Central_Designations_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedDate]   DATETIME      CONSTRAINT [DF_Central_Designations_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Central_Designations] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

