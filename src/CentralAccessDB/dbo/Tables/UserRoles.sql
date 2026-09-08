CREATE TABLE [dbo].[UserRoles] (
    [Id]                  INT           IDENTITY (1, 1) NOT NULL,
    [Name]                NVARCHAR (50) NULL,
    [IsActive]            BIT           CONSTRAINT [DF_UserRoles_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedUserId]       INT           NULL,
    [CreatedDateTime]     DATETIME      CONSTRAINT [DF_UserRoles_CreatedDateTime] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedUserId]   INT           NULL,
    [LastUpdatedDateTime] DATETIME      CONSTRAINT [DF_UserRoles_LastUpdatedDateTime] DEFAULT (getdate()) NOT NULL,
    [IsUpload]            BIT           NULL,
    [PropertyId]          INT           NULL,
    CONSTRAINT [PK_HUserRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

