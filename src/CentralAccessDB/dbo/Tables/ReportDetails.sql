CREATE TABLE [dbo].[ReportDetails] (
    [ReportId]               INT            IDENTITY (1, 1) NOT NULL,
    [ReportName]             NVARCHAR (150) NOT NULL,
    [DisplayName]            NVARCHAR (150) NULL,
    [ReportViewerWidth]      INT            CONSTRAINT [DF_ReportDetails_ReportViewerWidth] DEFAULT ((800)) NOT NULL,
    [ReportSPName]           NVARCHAR (250) NULL,
    [ReportCategory]         INT            NULL,
    [ReportPrameterCategory] VARCHAR (50)   NULL,
    [Active]                 BIT            NULL,
    [ParamOperation]         BIT            NULL,
    [ParamFromDate]          BIT            NULL,
    [ParamToDate]            BIT            NULL,
    [ParamFromTime]          BIT            NULL,
    [ParamToTime]            BIT            NULL,
    [IsPrintCopy]            BIT            NULL,
    [IsShowExportControls]   BIT            NULL,
    [ParamUserId]            BIT            NULL,
    [ParamPropertyId]        BIT            NULL,
    [ParamModuleId]          BIT            NULL
);


GO

