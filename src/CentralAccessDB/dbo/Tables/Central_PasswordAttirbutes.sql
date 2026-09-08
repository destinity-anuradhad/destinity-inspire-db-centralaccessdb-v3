CREATE TABLE [dbo].[Central_PasswordAttirbutes] (
    [Id]                      INT           NOT NULL,
    [Name]                    VARCHAR (50)  NULL,
    [DataType]                VARCHAR (50)  NULL,
    [PasswordPolicySegmentId] INT           NULL,
    [IsRequired]              BIT           CONSTRAINT [DF_Central_PasswordAttirbutes_IsRequired] DEFAULT ((0)) NOT NULL,
    [IsActive]                BIT           NOT NULL,
    [Regex]                   NVARCHAR (50) NULL,
    CONSTRAINT [PK_Central_PasswordAttirbutes] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

