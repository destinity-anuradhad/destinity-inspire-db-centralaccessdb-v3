CREATE TABLE [dbo].[Central_UserRoles] (
    [Id]                INT           IDENTITY (1, 1) NOT NULL,
    [GroupId]           INT           NULL,
    [Name]              VARCHAR (100) NULL,
    [PasswordPolicyId]  INT           NULL,
    [IsActive]          BIT           NULL,
    [CreatedUserId]     INT           NULL,
    [ModifiedUserId]    INT           NULL,
    [CreatedDate]       DATETIME      CONSTRAINT [DF_UserRoles_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedDate]      DATETIME      CONSTRAINT [DF_UserRoles_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [HierarchicalLevel] INT           NULL,
    CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

