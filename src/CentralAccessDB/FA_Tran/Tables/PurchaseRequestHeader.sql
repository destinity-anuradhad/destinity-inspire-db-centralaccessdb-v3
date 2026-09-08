CREATE TABLE [FA_Tran].[PurchaseRequestHeader] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [BranchId]           INT            NOT NULL,
    [DepartmentId]       INT            NOT NULL,
    [SubDepartmentId]    INT            NOT NULL,
    [Reason]             NVARCHAR (500) NOT NULL,
    [SpecialInstruction] NVARCHAR (500) NOT NULL,
    [Status]             SMALLINT       CONSTRAINT [DF_PurchaseRequestHeader_Staus] DEFAULT ((1)) NOT NULL,
    [CreatedUser]        INT            NOT NULL,
    [CreatedDate]        DATETIME       NULL,
    [PRNo]               NVARCHAR (50)  NULL,
    CONSTRAINT [PK_PurchaseRequestHeader] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

