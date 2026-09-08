CREATE TABLE [FA_Ref].[BudgetReferences] (
    [BudgetReferenceId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]              VARCHAR (200) NULL,
    [IsActive]          BIT           CONSTRAINT [DF_BudgetReferences_IsActive] DEFAULT ((0)) NOT NULL,
    [CreatedUserID]     INT           NULL,
    [ModifiedUserID]    INT           NULL,
    [CreatedDate]       DATETIME      CONSTRAINT [DF_BudgetReferences_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedDate]      DATETIME      CONSTRAINT [DF_BudgetReferences_ModifiedDate] DEFAULT (getdate()) NOT NULL
);


GO

