CREATE TABLE [dbo].[Central_UserWiseModuleLogin_History] (
    [Id]                          INT            NOT NULL,
    [UserId]                      INT            NOT NULL,
    [PropertyId]                  INT            NOT NULL,
    [ModuleId]                    INT            NOT NULL,
    [Uuid]                        NVARCHAR (MAX) NOT NULL,
    [TxnDateTime]                 DATETIME       NOT NULL,
    [BrowserKey]                  NVARCHAR (MAX) NULL,
    [SessionID]                   NVARCHAR (MAX) NULL,
    [SessionStorageId]            NVARCHAR (MAX) NULL,
    [LocalStorageId]              NVARCHAR (MAX) NULL,
    [Authority]                   NVARCHAR (MAX) NULL,
    [IsActive]                    BIT            NULL,
    [LastActiveDateTime]          DATETIME       NULL,
    [LastCashierLoggedInDateTime] DATETIME       NULL,
    CONSTRAINT [PK_Central_UserWiseModuleLog_History] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

