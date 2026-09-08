CREATE TABLE [dbo].[ProcessedEvents] (
    [EventId]     UNIQUEIDENTIFIER NOT NULL,
    [ProcessedAt] DATETIME2 (7)    DEFAULT (sysdatetime()) NOT NULL,
    [Status]      NVARCHAR (20)    DEFAULT ('Success') NOT NULL,
    [Notes]       NVARCHAR (2000)  NULL,
    PRIMARY KEY CLUSTERED ([EventId] ASC)
);


GO

