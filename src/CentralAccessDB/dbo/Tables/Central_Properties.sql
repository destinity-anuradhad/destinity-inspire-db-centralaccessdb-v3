CREATE TABLE [dbo].[Central_Properties] (
    [Id]                         INT            NOT NULL,
    [GroupId]                    INT            NULL,
    [Name]                       VARCHAR (200)  NOT NULL,
    [IsActive]                   BIT            CONSTRAINT [DF_Central_Properties_IsActive] DEFAULT ((0)) NOT NULL,
    [Images]                     NVARCHAR (MAX) NULL,
    [Code]                       NVARCHAR (250) NULL,
    [ServerName]                 NVARCHAR (150) NULL,
    [DataBaseName]               NVARCHAR (150) NULL,
    [Username]                   NVARCHAR (50)  NULL,
    [Password]                   NVARCHAR (50)  NULL,
    [GLCompCode]                 VARCHAR (3)    NULL,
    [MasterID]                   VARCHAR (5)    CONSTRAINT [DF_Central_Properties_MasterID] DEFAULT ((0)) NOT NULL,
    [ServerNameBanquet]          NVARCHAR (150) NULL,
    [DataBaseNameBanquet]        NVARCHAR (150) NULL,
    [UsernameBanquet]            NVARCHAR (50)  NULL,
    [PasswordBanquet]            NVARCHAR (50)  NULL,
    [POSDataBaseServerName]      NVARCHAR (150) NULL,
    [POSDataBaseName]            NVARCHAR (150) NULL,
    [POSDataBaseUsername]        NVARCHAR (50)  NULL,
    [POSDataBasePassword]        NVARCHAR (50)  NULL,
    [IsDayEndBanquetEnabled]     BIT            CONSTRAINT [DF__Central_P__IsDay__2739D489] DEFAULT ((0)) NOT NULL,
    [IsDayEndPOSEnabled]         BIT            CONSTRAINT [DF__Central_P__IsDay__282DF8C2] DEFAULT ((0)) NOT NULL,
    [IsDayEndGLEnabled]          BIT            CONSTRAINT [DF__Central_P__IsDay__29221CFB] DEFAULT ((0)) NOT NULL,
    [IsDayEndInventoryEnabled]   BIT            CONSTRAINT [DF__Central_P__IsDay__2A164134] DEFAULT ((0)) NOT NULL,
    [IsDayEndFrontOfficeEnabled] BIT            CONSTRAINT [DF__Central_P__IsDay__2B0A656D] DEFAULT ((0)) NOT NULL,
    [IsDirectPrintEnable]        BIT            CONSTRAINT [DF__Central_P__IsDir__7E8CC4B1] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Central_Properties] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

