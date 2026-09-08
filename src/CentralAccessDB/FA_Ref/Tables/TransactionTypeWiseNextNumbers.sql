CREATE TABLE [FA_Ref].[TransactionTypeWiseNextNumbers] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [TxnType]            NCHAR (10)     NULL,
    [BranchCode]         NVARCHAR (250) NULL,
    [DepartmentId]       INT            NULL,
    [SubDepartmentId]    INT            NULL,
    [LengthOfFormatting] INT            NULL,
    [NextNumber]         INT            NULL,
    CONSTRAINT [PK_TransactionTypeWiseNextNumbers] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

