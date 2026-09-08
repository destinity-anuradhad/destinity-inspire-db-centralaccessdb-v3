CREATE TABLE [dbo].[Central_Departments] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [GroupId]        INT           NULL,
    [Name]           VARCHAR (100) NULL,
    [IsActive]       BIT           NULL,
    [CreatedUserId]  INT           NULL,
    [ModifiedUserId] INT           NULL,
    [CreatedDate]    DATETIME      CONSTRAINT [DF_Central_Departments_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedDate]   DATETIME      CONSTRAINT [DF_Central_Departments_ModifiedDate] DEFAULT (getdate()) NOT NULL
);


GO

