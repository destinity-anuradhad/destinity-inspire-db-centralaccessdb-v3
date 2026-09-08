CREATE TABLE [dbo].[GEN_ErrTable] (
    [ErrorNumber]    VARCHAR (MAX) NULL,
    [ErrorSeverity]  VARCHAR (MAX) NULL,
    [ErrorState]     VARCHAR (MAX) NULL,
    [ErrorProcedure] VARCHAR (MAX) NULL,
    [ErrorLine]      VARCHAR (MAX) NULL,
    [ErrorMessage]   VARCHAR (MAX) NULL,
    [SysDate]        DATETIME      CONSTRAINT [DF_GEN_ErrTable_SysDate] DEFAULT (getdate()) NULL
);


GO

