CREATE TABLE [dbo].[ParamUserSave] (
    [Id]                    INT           NULL,
    [GroupId]               INT           NULL,
    [UserId]                INT           NULL,
    [UserName]              VARCHAR (200) NULL,
    [Password]              VARCHAR (MAX) NULL,
    [FullName]              VARCHAR (100) NULL,
    [EmpNumber]             VARCHAR (50)  NULL,
    [Email]                 VARCHAR (100) NULL,
    [MobileNumber]          VARCHAR (50)  NULL,
    [DesignationId]         INT           NULL,
    [DepartmentId]          INT           NULL,
    [AuhenticatedMethordId] INT           NULL,
    [LeagalIdnumber]        VARCHAR (100) NULL,
    [IsActive]              BIT           NULL,
    [PasswordPolicyId]      INT           NULL,
    [PropertyId]            INT           NULL
);


GO

