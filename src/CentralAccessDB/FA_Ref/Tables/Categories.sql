CREATE TABLE [FA_Ref].[Categories] (
    [CategoryID]       INT           IDENTITY (1, 1) NOT NULL,
    [Name]             VARCHAR (200) NULL,
    [CategoryLevelID]  INT           NOT NULL,
    [ParentCategoryID] INT           NULL,
    [IsActive]         BIT           CONSTRAINT [DF_Categories_IsActive] DEFAULT ((0)) NOT NULL,
    [CreatedUserID]    INT           NULL,
    [ModifiedUserID]   INT           NULL,
    [CreatedDate]      DATETIME      CONSTRAINT [DF_Categories_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedDate]     DATETIME      CONSTRAINT [DF_Categories_ModifiedDate] DEFAULT (getdate()) NOT NULL
);


GO

