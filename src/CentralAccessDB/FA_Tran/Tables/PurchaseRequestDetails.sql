CREATE TABLE [FA_Tran].[PurchaseRequestDetails] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [ItemNo]           INT            NOT NULL,
    [CategoryLevel1Id] INT            NOT NULL,
    [CategoryLevel2Id] INT            NOT NULL,
    [CategoryLevel3Id] INT            NOT NULL,
    [Description]      NVARCHAR (500) NOT NULL,
    [Quantity]         NVARCHAR (500) NOT NULL,
    [RequestHeaderId]  INT            NOT NULL,
    [CreatedDate]      DATETIME       NOT NULL,
    CONSTRAINT [PK_PurchaseRequestDetails] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

