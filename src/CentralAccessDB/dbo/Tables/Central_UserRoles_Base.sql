CREATE TABLE [dbo].[Central_UserRoles_Base] (
    [Id]                INT           IDENTITY (1, 1) NOT NULL,
    [GroupId]           INT           NULL,
    [Name]              VARCHAR (100) NULL,
    [PasswordPolicyId]  INT           NULL,
    [IsActive]          BIT           NULL,
    [CreatedUserId]     INT           NULL,
    [ModifiedUserId]    INT           NULL,
    [CreatedDate]       DATETIME      NOT NULL,
    [ModifiedDate]      DATETIME      NOT NULL,
    [HierarchicalLevel] INT           NULL
);


GO

