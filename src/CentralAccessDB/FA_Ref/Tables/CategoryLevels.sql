CREATE TABLE [FA_Ref].[CategoryLevels] (
    [CategoryLevelID] INT          NOT NULL,
    [ParentLevelID]   INT          NULL,
    [Name]            VARCHAR (50) NOT NULL,
    [HaveChilds]      BIT          NOT NULL,
    [IsActive]        BIT          CONSTRAINT [DF_CategoryLevels_IsActive] DEFAULT ((0)) NOT NULL
);


GO

