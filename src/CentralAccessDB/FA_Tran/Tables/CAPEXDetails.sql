CREATE TABLE [FA_Tran].[CAPEXDetails] (
    [Id]              INT             IDENTITY (1, 1) NOT NULL,
    [CAPEXHeaderId]   INT             NOT NULL,
    [ItemDescription] NVARCHAR (500)  NOT NULL,
    [DelivaeryDate]   DATE            NOT NULL,
    [MainCatId]       INT             NOT NULL,
    [Quantity]        DECIMAL (18, 6) NOT NULL,
    [CategoryId]      INT             NOT NULL,
    [Price]           DECIMAL (18, 6) NOT NULL,
    [SubCatId]        INT             NOT NULL,
    [BudgetBalance]   DECIMAL (18, 6) NOT NULL,
    [BudgetRefId]     INT             NOT NULL
);


GO

