CREATE TABLE [FA_Tran].[CAPEXHeader] (
    [Id]              INT            IDENTITY (1, 1) NOT NULL,
    [CAPEXNo]         NVARCHAR (200) NOT NULL,
    [CAPEXDate]       DATE           NOT NULL,
    [DepartmentId]    INT            NOT NULL,
    [BranchCode]      NVARCHAR (250) NOT NULL,
    [SubDepartmentId] INT            NOT NULL,
    [Remarks]         NVARCHAR (500) NULL,
    [CAPEXTypeId]     INT            NOT NULL,
    [SupplierCode]    NVARCHAR (250) NOT NULL,
    [PRNo]            NVARCHAR (300) NULL,
    [RequestedDate]   DATE           NULL,
    CONSTRAINT [PK_CAPEXHeader] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

