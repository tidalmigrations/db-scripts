CREATE DATABASE DemoMSSQLDatabase
GO

Use DemoMSSQLDatabase
Go

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- Non-relational Tables - -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Create a new table called '__EFMigrationsHistory', if it doesn't exist
IF OBJECT_ID('dbo.__EFMigrationsHistory', 'U') IS NULL
CREATE TABLE [dbo].[__EFMigrationsHistory] (
    [MigrationId]    NVARCHAR (150) NOT NULL,
    [ProductVersion] NVARCHAR (32)  NOT NULL,
    CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED ([MigrationId] ASC)
);
GO


-- Create a new table called 'ScheduleOverrides', if it doesn't exist
IF OBJECT_ID('dbo.ScheduleOverrides', 'U') IS NULL
CREATE TABLE [dbo].[ScheduleOverrides] (
    [Id]             BIGINT          IDENTITY (1, 1) NOT NULL,
	[Status]		 INT		     NOT NULL,
    [Type]           INT		     NOT NULL,
    [RefId]          BIGINT          NOT NULL,
    [StartDateUtc]   DATETIME        NOT NULL,
    [EndDateUtc]     DATETIME        NOT NULL,
    [UserId]	     VARCHAR (200)   NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

IF IndexProperty(Object_Id('ScheduleOverrides'), 'UQ_ScheduleOverrides_Type_RefId', 'IndexID') IS NULL
CREATE UNIQUE INDEX [UQ_ScheduleOverrides_Type_RefId]
ON [dbo].[ScheduleOverrides] ([Type], [RefId]);
GO


-- Create a new table called 'UserInvites', if it doesn't exist
IF OBJECT_ID('[dbo].[UserInvites]', 'U') IS NULL
CREATE TABLE [dbo].[UserInvites] (
    [Id]                  BIGINT        IDENTITY (1, 1) NOT NULL,
    [BossUserId]          VARCHAR (100) NOT NULL,
    [BossEmail]           VARCHAR (200) NOT NULL,
    [UserEmail]           VARCHAR (100) NOT NULL,
    [Accepted]            BIT           DEFAULT ((0)) NOT NULL,
    [InviteDateTimeUTC]   DATETIME      NOT NULL,
    [AcceptedDateTimeUTC] DATETIME      NULL,
    [Token]               VARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

IF IndexProperty(Object_Id('UserInvites'), 'IX_UserInvites_GetAllParentUsersIds', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_UserInvites_GetAllParentUsersIds]
    ON [dbo].[UserInvites]([UserEmail] ASC, [Accepted] ASC)
    INCLUDE([BossUserId]);
GO

IF IndexProperty(Object_Id('UserInvites'), 'ix_UserInvites_BossUserId_UserEmail', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [ix_UserInvites_BossUserId_UserEmail]
    ON [dbo].[UserInvites]([BossUserId] ASC)
    INCLUDE([UserEmail], [Accepted], [InviteDateTimeUTC], [AcceptedDateTimeUTC], [BossEmail], [Token]);
GO

IF IndexProperty(Object_Id('UserInvites'), 'ix_UserInvites_Token', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [ix_UserInvites_Token]
    ON [dbo].[UserInvites]([Token] ASC)
    INCLUDE([UserEmail], [Accepted], [InviteDateTimeUTC], [AcceptedDateTimeUTC], [BossEmail], [BossUserId]);
GO

-- Create a new table called 'Pricing', if it doesn't exist
IF OBJECT_ID('[dbo].[Pricing]', 'U') IS NULL
CREATE TABLE [dbo].[Pricing]
(
	[Id]             INT             NOT NULL PRIMARY KEY IDENTITY(1,1),
	[CloudProvider]  INT             NOT NULL,
	[ResourceType]   INT             NOT NULL,
	[InstanceType]   VARCHAR(500),
	[Region]         VARCHAR(200),
	[PurchaseModel]  INT,
	[UpFrontYears]   INT,
	[PricePerHour]   MONEY,
	[OsType]         VARCHAR(100)
);
GO

IF IndexProperty(Object_Id('Pricing'), 'IX_Pricing', 'IndexID') IS NULL
CREATE INDEX [IX_Pricing]
    ON [dbo].[Pricing] ([CloudProvider],[ResourceType],[InstanceType],[PurchaseModel],[UpFrontYears],[Region],[OsType])
    INCLUDE([PricePerHour],[Id]);
GO


-- Create a new table called 'cloudeventlogs', if it doesn't exist
IF OBJECT_ID('[dbo].[cloudeventlogs]', 'U') IS NULL
CREATE TABLE [dbo].[cloudeventlogs] (
    [activitytype]     INT            NOT NULL,
    [resourceid]       BIGINT         NULL,
    [resourcecloudid]  VARCHAR (1000) NULL,
    [accountid]        BIGINT         NULL,
    [resourcetype]     INT            NOT NULL,
    [eventdatetimeutc] DATETIME       NOT NULL,
    [asgmin]           INT            NULL,
    [asgmax]           INT            NULL,
    [asgdesired]       INT            NULL,
    [userid]           VARCHAR (100)  NOT NULL,
    [id]               BIGINT         IDENTITY (1, 1) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);
GO

IF IndexProperty(Object_Id('cloudeventlogs'), 'ix_cloudeventargs_resourceid_eventdatetime', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [ix_cloudeventargs_resourceid_eventdatetime]
    ON [dbo].[cloudeventlogs]([resourceid] ASC, [eventdatetimeutc] ASC)
    INCLUDE([activitytype], [resourcecloudid], [accountid], [resourcetype], [asgmin], [asgmax], [asgdesired], [userid], [id]);
GO


-- Create a new table called 'Channels', if it doesn't exist
IF OBJECT_ID('[dbo].[Channels]', 'U') IS NULL
CREATE TABLE [dbo].[Channels] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [OwnerUserId]    VARCHAR (100)  NOT NULL,
    [ChannelType]    INT            DEFAULT ((1)) NULL,
    [Name]           NVARCHAR (200) NOT NULL,
    [WebHookAddress] VARCHAR (MAX)  NULL,
    [InstanceStop]   BIT            DEFAULT ((0)) NULL,
    [InstanceStart]  BIT            DEFAULT ((0)) NULL,
    [EnvStop]        BIT            DEFAULT ((0)) NULL,
    [EnvStart]       BIT            DEFAULT ((0)) NULL,
    [AccountErrors]  BIT            DEFAULT ((1)) NULL,
    [Enabled]        BIT            DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

IF IndexProperty(Object_Id('Channels'), 'IX_Channel_Covering', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_Channel_Covering]
    ON [dbo].[Channels]([OwnerUserId] ASC)
    INCLUDE([Id],[AccountErrors],[ChannelType],[Enabled],[EnvStart],[EnvStop],[InstanceStart],[InstanceStop],[Name],[WebHookAddress])
    WITH (DROP_EXISTING = OFF, PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


-- Create a new table called 'GoogleVmPricing', if it doesn't exist
IF OBJECT_ID('[dbo].[GoogleVmPricing]', 'U') IS NULL
Create Table [dbo].[GoogleVmPricing](
    [Id]        INT            NOT NULL PRIMARY KEY IDENTITY(1,1),
    [Region]    VARCHAR(100),
    [RamOrCpu]  VARCHAR(10)    NOT NULL,
    [Price]     MONEY          NOT NULL
);
GO

IF IndexProperty(Object_Id('GoogleVmPricing'), 'IX_GoogleVmPricing', 'IndexID') IS NULL
CREATE INDEX [IX_GoogleVmPricing] 
    ON [dbo].[GoogleVmPricing] ([Region], [RamOrcpu])
    INCLUDE ([Price]);
GO


-- Create a new table called 'Subscriptions', if it doesn't exist
IF OBJECT_ID('[dbo].[Subscriptions]', 'U') IS NULL
CREATE TABLE [dbo].[Subscriptions] (
    [Id]                        BIGINT        IDENTITY (1, 1) NOT NULL,
    [UserId]                    VARCHAR (450) NOT NULL,
    [StartedDateUtc]            DATETIME      NOT NULL,
    [ExpiresOnUtc]              DATETIME      NOT NULL,
    [SubscriptionType]          INT           DEFAULT ((1)) NOT NULL,
    [NextBillingDateUtc]        DATETIME      NULL,
    [LastSuccessfulBillDateUtc] DATETIME      NULL,
    [StripeCustomerId]          VARCHAR (100) NULL,
    [StripeSubscriptionItemId]  VARCHAR (100) NULL,
    [IsActive]                  BIT           DEFAULT ((0)) NOT NULL,
    [NextUsageReportDateUtc]   DATETIME NOT  NULL, 
    [StripeSubscriptionId]      VARCHAR(100)  NULL, 
    [Contacted]                 BIT           NULL DEFAULT(0),
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

IF IndexProperty(Object_Id('Subscriptions'), 'IX_CloudAccounts_Id', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_CloudAccounts_Id]
    ON [dbo].[Subscriptions]([IsActive] ASC, [SubscriptionType] ASC, [ExpiresOnUtc] ASC)
    INCLUDE([UserId]);
GO



-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- Cloud Resources Tables  -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Create a new table called 'CloudAccounts', if it doesn't exist
IF OBJECT_ID('[dbo].[CloudAccounts]', 'U') IS NULL
CREATE TABLE [dbo].[CloudAccounts] (
    [Id]                  BIGINT         IDENTITY (1, 1) NOT NULL,
    [CreatorUserID]       VARCHAR (200)  NOT NULL,
    [CreatedDateTimeUTC]  DATETIME       NOT NULL,
    [AccountType]         INT            DEFAULT ((1)) NOT NULL,
    [AccountName]         NVARCHAR (200) NOT NULL,
    [AWSRoleArn]          VARCHAR (500)  NULL,
    [AWSAccountNumber]    VARCHAR (100)  NULL,
    [AWSRegionName]       VARCHAR (100)  NULL,
    [SourceAccountNumber] VARCHAR (100)  NULL,
    [ExternalID]          VARCHAR (200)  NULL,
    [GCProjectId]         VARCHAR (500)  NULL,
    [GCJsonBody]          VARCHAR (MAX)  NULL,
    [GcClientId]          VARCHAR (500)  NULL,
    [AzureSubscriptionId] VARCHAR (500)  NULL,
    [AzureTenantId]       VARCHAR (500)  NULL,
    [AzureClientId]       VARCHAR (500)  NULL,
    [AzureclientSecret]   VARCHAR (500)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO


IF IndexProperty(Object_Id('CloudAccounts'), 'IX_CloudAccounts_GetAllCloudAccounts', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_CloudAccounts_GetAllCloudAccounts]
    ON [dbo].[CloudAccounts]([CreatorUserID] ASC)
    INCLUDE([Id], [AccountName], [AccountType]);
GO

IF IndexProperty(Object_Id('CloudAccounts'), 'IX_CloudAccounts_AWSAccount', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_CloudAccounts_AWSAccount]
    ON [dbo].[CloudAccounts]([AWSAccountNumber] ASC);
GO

IF IndexProperty(Object_Id('CloudAccounts'), 'IX_CloudAccounts_AzureSubscriptionId', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_CloudAccounts_AzureSubscriptionId]
    ON [dbo].[CloudAccounts]([AzureSubscriptionId] ASC);
GO

IF IndexProperty(Object_Id('CloudAccounts'), 'IX_CloudAccounts_GoogleCloudAccountExists', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_CloudAccounts_GoogleCloudAccountExists]
    ON [dbo].[CloudAccounts]([GcClientId] ASC, [GCProjectId] ASC);
GO


-- Create a new table called 'CloudResources', if it doesn't exist
IF OBJECT_ID('[dbo].[CloudResources]', 'U') IS NULL
CREATE TABLE [dbo].[CloudResources] (
    [Id]                     BIGINT          IDENTITY (1, 1) NOT NULL,
    [UserId]                 VARCHAR (200)   NOT NULL,
    [CloudResourceId]        NVARCHAR (1000) NOT NULL,
    [Name]                   NVARCHAR (2000)  NOT NULL,
    [Location]               VARCHAR (1000)   NOT NULL,
    [InstanceType]           NVARCHAR (1000)   NULL,
    [Cost]                   DECIMAL (20, 4) NOT NULL,
    [CostOverriden]          bit             Default(0),
    [State]                  int  NOT NULL,
    [StateReason]            NVARCHAR (1000)  NULL,
    [ResourceType]           INT             NOT NULL,
    [IsMemberOfScalingGroup] BIT             NOT NULL,
    [CloudAccountId]         BIGINT          NOT NULL,
    [ScheduleId]             BIGINT          NULL,
    [AccountType]            INT             NOT NULL,
    [CloudAccountNumber]     VARCHAR (200)   NULL,
    [PurchaseModel]         Int,
    [UpFrontYears] int,
    [OsType] varchar(100),
    CONSTRAINT [PK_CloudResources] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

IF OBJECT_ID('FK_CloudResources_CloudAccounts', 'F') IS NULL
ALTER TABLE [dbo].[CloudResources]
    WITH CHECK ADD CONSTRAINT [FK_CloudResources_CloudAccounts] FOREIGN KEY([CloudAccountId])
    REFERENCES [dbo].[CloudAccounts] ([Id])
    ON DELETE CASCADE
GO

IF IndexProperty(Object_Id('CloudResources'), 'IX_CloudResources_CloudAccountId', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_CloudResources_CloudAccountId]
    ON [dbo].[CloudResources]([CloudAccountId] ASC);
GO

IF IndexProperty(Object_Id('CloudResources'), 'IX_CloudResources_Unix', 'IndexID') IS NULL
CREATE UNIQUE INDEX [IX_CloudResources_Unix]
  ON CloudResources (CloudResourceId, CloudAccountId);
GO


-- Create a new table called 'tags', if it doesn't exist
IF OBJECT_ID('[dbo].[tags]', 'U') IS NULL
CREATE TABLE [dbo].[tags] (
    [id]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [cloudresourceid] BIGINT         NOT NULL,
    [key]             NVARCHAR (200) NOT NULL,
    [value]           NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_Tags] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_Tags_CloudResources] FOREIGN KEY ([cloudresourceid]) REFERENCES [dbo].[CloudResources] ([Id]) ON DELETE CASCADE
);
GO



-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- - Scheduling Tables  -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Create a new table called 'Schedules', if it doesn't exist
IF OBJECT_ID('[dbo].[Schedules]', 'U') IS NULL
CREATE TABLE [dbo].[Schedules] (
    [Id]             BIGINT          IDENTITY (1, 1) NOT NULL,
    [OwnerAccountId] VARCHAR (200)   NOT NULL,
    [Name]           NVARCHAR (200)  NOT NULL,
    [Description]    NVARCHAR (1000) NULL,
    [TimeZoneName]   VARCHAR (100)   NULL,
    [IsActive]       BIT             DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

IF IndexProperty(Object_Id('Schedules'), 'IX_Schedules_OwnerAccountId', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_Schedules_OwnerAccountId]
    ON [dbo].[Schedules]([OwnerAccountId] ASC)
    INCLUDE([Id], [Name], [Description], [TimeZoneName], [IsActive]);
GO

IF IndexProperty(Object_Id('Schedules'), 'IX_Schedule_Name', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_Schedule_Name]
    ON [dbo].[Schedules]([Name] ASC)
    INCLUDE([Id], [Description], [TimeZoneName], [IsActive]);
GO

IF IndexProperty(Object_Id('Schedules'), 'IX_Schedule_Name_OwnerAccountId', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_Schedule_Name_OwnerAccountId]
    ON [dbo].[Schedules]([Name] ASC, [OwnerAccountId] ASC);
GO


-- Create a new table called 'ScheduleDetails', if it doesn't exist
IF OBJECT_ID('[dbo].[ScheduleDetails]', 'U') IS NULL
CREATE TABLE [dbo].[ScheduleDetails] (
    [Id]           BIGINT IDENTITY (1, 1) NOT NULL,
    [ScheduleId]   BIGINT NOT NULL,
    [DayOfTheWeek] INT    NOT NULL,
    [HourOfDay]    INT    NOT NULL,
    [Quarter1]     BIT    NULL,
    [Quarter2]     BIT    NULL,
    [Quarter3]     BIT    NULL,
    [Quarter4]     BIT    NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Schedule_ScheduleDetails] FOREIGN KEY ([ScheduleId]) REFERENCES [dbo].[Schedules] ([Id]) ON DELETE CASCADE
);
GO



-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- - Team Tables  -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Create a new table called 'Teams', if it doesn't exist
IF OBJECT_ID('[dbo].[Teams]', 'U') IS NULL
CREATE TABLE [dbo].[Teams] (
    [Id]      BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]    VARCHAR (100)  NOT NULL,
    [OwnerId] NVARCHAR (450) NOT NULL,
    CONSTRAINT [PK_Teams] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

IF IndexProperty(Object_Id('Teams'), 'IX_Teams_OwnerId', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_Teams_OwnerId]
    ON [dbo].[Teams]([OwnerId] ASC)
    INCLUDE([Id], [Name]);
GO

IF IndexProperty(Object_Id('Teams'), 'ix_Teams_OwnerId_Name', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [ix_Teams_OwnerId_Name]
    ON [dbo].[Teams]([OwnerId] ASC, [Name] ASC)
    INCLUDE([Id]);
GO


-- Create a new table called 'TeamUserAssociations', if it doesn't exist
IF OBJECT_ID('[dbo].[TeamUserAssociations]', 'U') IS NULL
CREATE TABLE [dbo].[TeamUserAssociations] (
    [Id]     BIGINT         IDENTITY (1, 1) NOT NULL,
    [TeamId] BIGINT         NOT NULL,
    [UserId] NVARCHAR (450) NOT NULL,
    CONSTRAINT [PK_TeamUserAssociations] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TeamUserAssociations_Teams] FOREIGN KEY ([TeamId]) REFERENCES [dbo].[Teams] ([Id])
);
GO

IF IndexProperty(Object_Id('TeamUserAssociations'), 'IX_TeamUserAssociations_TeamId_UserId', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_TeamUserAssociations_TeamId_UserId]
    ON [dbo].[TeamUserAssociations]([TeamId] ASC, [UserId] ASC)
    INCLUDE([Id]);
GO



-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- --  Users Tables  -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Create a new table called 'AspNetUsers', if it doesn't exist
IF OBJECT_ID('[dbo].[AspNetUsers]', 'U') IS NULL
CREATE TABLE [dbo].[AspNetUsers] (
    [Id]                   NVARCHAR (450)     NOT NULL,
    [UserName]             NVARCHAR (256)     NULL,
    [NormalizedUserName]   NVARCHAR (256)     NULL,
    [Email]                NVARCHAR (256)     NULL,
    [NormalizedEmail]      NVARCHAR (256)     NULL,
    [EmailConfirmed]       BIT                NOT NULL,
    [PasswordHash]         NVARCHAR (MAX)     NULL,
    [SecurityStamp]        NVARCHAR (MAX)     NULL,
    [ConcurrencyStamp]     NVARCHAR (MAX)     NULL,
    [PhoneNumber]          NVARCHAR (MAX)     NULL,
    [PhoneNumberConfirmed] BIT                NOT NULL,
    [TwoFactorEnabled]     BIT                NOT NULL,
    [LockoutEnd]           DATETIMEOFFSET (7) NULL,
    [LockoutEnabled]       BIT                NOT NULL,
    [AccessFailedCount]    INT                NOT NULL,
    [JoinedDateUTC]        DATETIME           DEFAULT (getutcdate()) NULL,
    CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

IF IndexProperty(Object_Id('AspNetUsers'), 'EmailIndex', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [EmailIndex]
    ON [dbo].[AspNetUsers]([NormalizedEmail] ASC);
GO

IF IndexProperty(Object_Id('AspNetUsers'), 'UserNameIndex', 'IndexID') IS NULL
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex]
    ON [dbo].[AspNetUsers]([NormalizedUserName] ASC) WHERE ([NormalizedUserName] IS NOT NULL);
GO

-- This trigger sets the default values for the new users
--   User exipration date to 100 years.
--   All users are premium users when they signup.
--
-- FYI: FreeTrial Users:       SubscriptionType = 1
--      Premium Subscription:  SubscriptionType = 2
IF OBJECT_ID('[dbo].[AspnetUsers_AddSubscription]', 'TR') IS NULL
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER AspnetUsers_AddSubscription
    ON AspNetUsers
    AFTER INSERT
AS
BEGIN
    DECLARE @userId VARCHAR(100)
    DECLARE @JoinedDateUtc datetime

    SELECT @userId=Id, @JoinedDateUtc=JoinedDateUTC
    FROM inserted;

    INSERT INTO Subscriptions (UserId,StartedDateUtc, ExpiresOnUtc, SubscriptionType,IsActive, NextUsageReportDateUtc)
    VALUES (@userId, @JoinedDateUtc,DateAdd(YEAR, 100,@JoinedDateUtc),2,1, DateAdd(YEAR, 700,@JoinedDateUtc) )
END'

-- Create a new table called 'AspNetUserLogins', if it doesn't exist
IF OBJECT_ID('[dbo].[AspNetUserLogins]', 'U') IS NULL
CREATE TABLE [dbo].[AspNetUserLogins] (
    [LoginProvider]       NVARCHAR (450) NOT NULL,
    [ProviderKey]         NVARCHAR (450) NOT NULL,
    [ProviderDisplayName] NVARCHAR (MAX) NULL,
    [UserId]              NVARCHAR (450) NOT NULL,
    CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED ([LoginProvider] ASC, [ProviderKey] ASC),
    CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
);
GO

IF IndexProperty(Object_Id('AspNetUserLogins'), 'IX_AspNetUserLogins_UserId', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId]
    ON [dbo].[AspNetUserLogins]([UserId] ASC);
GO


-- Create a new table called 'Environments', if it doesn't exist
IF OBJECT_ID('[dbo].[Environments]', 'U') IS NULL
CREATE TABLE [dbo].[Environments] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]           NVARCHAR (200) NOT NULL,
    [OwnerAccountId] NVARCHAR (450) NOT NULL,
    [Enabled]        BIT            NOT NULL,
    [ScheduleId]     BIGINT         NOT NULL,
    [QueryJSON]      NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_Environments] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Environments_AspNetUsers] FOREIGN KEY ([OwnerAccountId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [UQ_Name] UNIQUE NONCLUSTERED ([Name] ASC, [OwnerAccountId] ASC)
);
GO

IF IndexProperty(Object_Id('Environments'), 'IX_Env_Name', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_Env_Name]
    ON [dbo].[Environments]([Name] ASC)
    INCLUDE([Id], [OwnerAccountId], [Enabled], [ScheduleId], [QueryJSON]);
GO

IF IndexProperty(Object_Id('Environments'), 'IX_Environments_OwnerAccountId', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_Environments_OwnerAccountId]
    ON [dbo].[Environments]([OwnerAccountId] ASC)
    INCLUDE([Id], [Name], [Enabled], [ScheduleId], [QueryJSON]);
GO


-- Create a new table called 'AspNetUserTokens', if it doesn't exist
IF OBJECT_ID('[dbo].[AspNetUserTokens]', 'U') IS NULL
CREATE TABLE [dbo].[AspNetUserTokens] (
    [UserId]        NVARCHAR (450) NOT NULL,
    [LoginProvider] NVARCHAR (450) NOT NULL,
    [Name]          NVARCHAR (450) NOT NULL,
    [Value]         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED ([UserId] ASC, [LoginProvider] ASC, [Name] ASC),
    CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
);
GO

-- Create a new table called 'AspNetUserClaims', if it doesn't exist
IF OBJECT_ID('[dbo].[AspNetUserClaims]', 'U') IS NULL
CREATE TABLE [dbo].[AspNetUserClaims] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [UserId]     NVARCHAR (450) NOT NULL,
    [ClaimType]  NVARCHAR (MAX) NULL,
    [ClaimValue] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
);
GO

IF IndexProperty(Object_Id('AspNetUserClaims'), 'IX_AspNetUserClaims_UserId', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId]
    ON [dbo].[AspNetUserClaims]([UserId] ASC)
GO


-- Create a new table called 'AspNetRoles', if it doesn't exist
IF OBJECT_ID('[dbo].[AspNetRoles]', 'U') IS NULL
CREATE TABLE [dbo].[AspNetRoles] (
    [Id]               NVARCHAR (450) NOT NULL,
    [Name]             NVARCHAR (256) NULL,
    [NormalizedName]   NVARCHAR (256) NULL,
    [ConcurrencyStamp] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

IF IndexProperty(Object_Id('AspNetRoles'), 'RoleNameIndex', 'IndexID') IS NULL
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex]
    ON [dbo].[AspNetRoles]([NormalizedName] ASC) WHERE ([NormalizedName] IS NOT NULL);
GO


-- Create a new table called 'AspNetRoleClaims', if it doesn't exist
IF OBJECT_ID('[dbo].[AspNetRoleClaims]', 'U') IS NULL
CREATE TABLE [dbo].[AspNetRoleClaims] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [RoleId]     NVARCHAR (450) NOT NULL,
    [ClaimType]  NVARCHAR (MAX) NULL,
    [ClaimValue] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE
);
GO

IF IndexProperty(Object_Id('AspNetRoleClaims'), 'IX_AspNetRoleClaims_RoleId', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId]
    ON [dbo].[AspNetRoleClaims]([RoleId] ASC);
GO


-- Create a new table called 'AspNetUserRoles', if it doesn't exist
IF OBJECT_ID('[dbo].[AspNetUserRoles]', 'U') IS NULL
CREATE TABLE [dbo].[AspNetUserRoles] (
    [UserId] NVARCHAR (450) NOT NULL,
    [RoleId] NVARCHAR (450) NOT NULL,
    CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC),
    CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
);
GO

IF IndexProperty(Object_Id('AspNetUserRoles'), 'IX_AspNetUserRoles_RoleId', 'IndexID') IS NULL
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId]
    ON [dbo].[AspNetUserRoles]([RoleId] ASC);
GO
