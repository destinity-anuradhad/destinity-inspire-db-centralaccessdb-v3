CREATE TABLE [dbo].[Central_PropertyWiseModules] (
    [GroupId]    INT NOT NULL,
    [PropertyId] INT NOT NULL,
    [ModuleId]   INT NOT NULL,
    [IsActive]   BIT CONSTRAINT [DF_PropertyWiseCentral_Modules_IsActive] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PropertyWiseCentral_Modules] PRIMARY KEY CLUSTERED ([GroupId] ASC, [PropertyId] ASC, [ModuleId] ASC)
);


GO

