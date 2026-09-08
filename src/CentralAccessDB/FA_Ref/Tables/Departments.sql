CREATE TABLE [FA_Ref].[Departments] (
    [DepartmentID]   INT           IDENTITY (1, 1) NOT NULL,
    [Name]           VARCHAR (200) NULL,
    [IsActive]       BIT           CONSTRAINT [DF_Department_IsActive] DEFAULT ((0)) NOT NULL,
    [CreatedUserID]  INT           NULL,
    [ModifiedUserID] INT           NULL,
    [CreatedDate]    DATETIME      NULL,
    [ModifiedDate]   DATETIME      NULL
);


GO

