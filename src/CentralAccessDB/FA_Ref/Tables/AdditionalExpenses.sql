CREATE TABLE [FA_Ref].[AdditionalExpenses] (
    [AdditionalExpenseID] INT           IDENTITY (1, 1) NOT NULL,
    [Name]                VARCHAR (200) NULL,
    [IsActive]            BIT           CONSTRAINT [DF_AdditinalExpenses_IsActive] DEFAULT ((0)) NOT NULL,
    [CreatedUserID]       INT           NULL,
    [ModifiedUserID]      INT           NULL,
    [CreatedDate]         DATETIME      CONSTRAINT [DF_AdditinalExpenses_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedDate]        DATETIME      CONSTRAINT [DF_AdditinalExpenses_ModifiedDate] DEFAULT (getdate()) NOT NULL
);


GO

