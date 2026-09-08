CREATE TABLE [FA_Ref].[SubDepartments] (
    [SubDepartmentID] INT           IDENTITY (1, 1) NOT NULL,
    [DepartmentID]    INT           NULL,
    [Name]            VARCHAR (200) NULL,
    [IsActive]        BIT           CONSTRAINT [DF_SubDepartments_IsActive] DEFAULT ((0)) NOT NULL,
    [CreatedUserID]   INT           NULL,
    [ModifiedUserID]  INT           NULL,
    [CreatedDate]     DATETIME      NULL,
    [ModifiedDate]    DATETIME      NULL
);


GO

