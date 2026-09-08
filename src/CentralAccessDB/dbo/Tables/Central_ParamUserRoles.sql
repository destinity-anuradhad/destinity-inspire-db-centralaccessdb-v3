CREATE TABLE [dbo].[Central_ParamUserRoles] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [RoleId]           INT            NULL,
    [RoleName]         NVARCHAR (100) NULL,
    [PasswordPolicyId] INT            NULL,
    [IsActive]         BIT            NULL,
    [UserId]           INT            NULL
);


GO

