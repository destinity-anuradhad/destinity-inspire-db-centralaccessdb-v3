CREATE TABLE [dbo].[Central_PropertyGroups] (
    [Id]       INT           IDENTITY (1, 1) NOT NULL,
    [Name]     VARCHAR (200) NULL,
    [IsActive] BIT           CONSTRAINT [DF_Groups_IsActive] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

