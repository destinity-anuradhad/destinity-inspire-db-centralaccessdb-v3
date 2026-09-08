CREATE TABLE [dbo].[CASettings] (
    [Id]                       INT IDENTITY (1, 1) NOT NULL,
    [IsCopyPropertyWiseAccess] BIT NULL,
    [PropertyId]               INT NULL,
    CONSTRAINT [PK_CASettings] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

