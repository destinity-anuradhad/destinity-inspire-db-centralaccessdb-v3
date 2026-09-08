CREATE TABLE [dbo].[Companies] (
    [CompanyID]    INT            NOT NULL,
    [Name]         NVARCHAR (100) NULL,
    [IsActive]     BIT            NOT NULL,
    [IPAddress]    NVARCHAR (MAX) NULL,
    [LogoURL]      NVARCHAR (MAX) NULL,
    [GLCompCode]   VARCHAR (3)    NULL,
    [DataBaseName] NVARCHAR (300) CONSTRAINT [DF_Companies_DataBaseName] DEFAULT ('') NOT NULL
);


GO

