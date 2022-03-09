--
-- Adds demo data for the SaveOnClouds database
--

/*
* User characteristics
* 
* |====== | ============= | ======= | ============= | ========= | ============================================= |
* | Email |  Subscription | Billing | Cloud Account | Schedules | Resources									    |
* |====== | ============= | ======= | ============= | ========= | ============================================= |
* | dev+1 |    Premium    |   None  |      AWS      |    Yes    | 2 x EC2 									    |
* | dev+2 |    Premium    |   Yes   |      None     |    None   | None   									    |
* | dev+3 |     Trial     |   None  |      None     |    None   | None   									    |
* |====== | ============= | ======= | ============= | ========= | ============================================= |
* 
* All users are active users.
*/

USE SaveOnClouds;
GO

-- Password to all users: `Dev@1234`
INSERT INTO SaveOnClouds.dbo.AspNetUsers (Id,UserName,NormalizedUserName,Email,NormalizedEmail,EmailConfirmed,PasswordHash,SecurityStamp,ConcurrencyStamp,PhoneNumber,PhoneNumberConfirmed,TwoFactorEnabled,LockoutEnd,LockoutEnabled,AccessFailedCount,JoinedDateUTC) VALUES
	 (N'002d5bf6-b013-4366-ae1a-acaa5d706eaa',N'dev+1@tidalmigrations.com',N'DEV+1@TIDALMIGRATIONS.COM',N'dev+1@tidalmigrations.com',N'DEV+1@TIDALMIGRATIONS.COM',1,N'AQAAAAEAACcQAAAAEEz90+EQJVhCvp80a1ue0sh2QlvA7Y4CYVeodjcTV/ML73lrRrjk2dikooN5hcxRVQ==',N'W5RNTQJHXR6VPDPARH64YKRK4AKZ3IVJ',N'0b15fa38-992d-4be7-8c32-3d68a2151ade',NULL,0,0,NULL,1,0,'2021-07-20 11:59:43.583'),
	 (N'b7ee482b-5dfe-4cb2-afce-b18a50d89782',N'dev+2@tidalmigrations.com',N'DEV+2@TIDALMIGRATIONS.COM',N'dev+2@tidalmigrations.com',N'DEV+2@TIDALMIGRATIONS.COM',1,N'AQAAAAEAACcQAAAAEEz90+EQJVhCvp80a1ue0sh2QlvA7Y4CYVeodjcTV/ML73lrRrjk2dikooN5hcxRVQ==',N'UXGL3HI4RWJSQ6Q4625MGRHZJPNKKQUI',N'732a226c-7979-4d6c-9312-4ee2cf5b459b',NULL,0,0,NULL,1,0,'2020-12-19 01:48:01.887'),
	 (N'01362194-3d22-4528-b12e-6fd76cbdc2c4',N'dev+3@tidalmigrations.com',N'DEV+3@TIDALMIGRATIONS.COM',N'dev+3@tidalmigrations.com',N'DEV+3@TIDALMIGRATIONS.COM',1,N'AQAAAAEAACcQAAAAEEz90+EQJVhCvp80a1ue0sh2QlvA7Y4CYVeodjcTV/ML73lrRrjk2dikooN5hcxRVQ==',N'JRLXSUUDPCYFPKEHADFKIGKJ7D4ZEEAI',N'bf7ebcda-14ae-49a0-85d3-5da45eb5b1f3',NULL,0,0,NULL,1,0,'2021-08-11 12:11:53.54');
GO

INSERT INTO SaveOnClouds.dbo.CloudAccounts (CreatorUserID,CreatedDateTimeUTC,AccountType,AccountName,AWSRoleArn,AWSAccountNumber,AWSRegionName,SourceAccountNumber,ExternalID,GCProjectId,GCJsonBody,GcClientId,AzureSubscriptionId,AzureTenantId,AzureClientId,AzureclientSecret) VALUES
	 (N'002d5bf6-b013-4366-ae1a-acaa5d706eaa','2021-08-27 06:52:39.253',1,N'939744386038',N'arn:aws:iam::939744386038:role/SaveOnClouds-Access-Provider-2',N'939744386038',NULL,NULL,N'002d5bf6-b013-4366-ae1a-acaa5d706eaa',N'',N'',N'',N'',N'',N'',N'');
GO

-- For Billing lambdas:
--   NextUsageReportDateUtc need to be today.
--   NextBillingDateUtc is kept at 10 days after today and LastSuccessfulBillDateUtc is kept at 10 days before today.
--   SubscriptionType need to be 2.
INSERT INTO SaveOnClouds.dbo.Subscriptions (UserId,StartedDateUtc,ExpiresOnUtc,SubscriptionType,NextBillingDateUtc,LastSuccessfulBillDateUtc,StripeCustomerId,StripeSubscriptionItemId,IsActive,NextUsageReportDateUtc,StripeSubscriptionId,Contacted) VALUES
	 (N'002d5bf6-b013-4366-ae1a-acaa5d706eaa','2021-07-20 10:00:00.000','2099-07-27 10:00:00.000',2,DATEADD(day,10,GETDATE()),DATEADD(day,-10,GETDATE()),N'cus_XX1',N'si_YY1',1,CURRENT_TIMESTAMP,N'sub_ZZ1',0),
	 (N'b7ee482b-5dfe-4cb2-afce-b18a50d89782','2021-07-20 10:00:00.000','2099-07-20 10:00:00.000',2,DATEADD(day,10,GETDATE()),DATEADD(day,-10,GETDATE()),N'cus_XX2',N'si_YY2',1,CURRENT_TIMESTAMP,N'sub_ZZ2',0),
	 (N'01362194-3d22-4528-b12e-6fd76cbdc2c4','2021-07-20 10:00:00.000','2099-07-20 10:00:00.000',1,NULL,NULL,NULL,NULL,1,CURRENT_TIMESTAMP,NULL,0);
GO

INSERT INTO SaveOnClouds.dbo.Schedules (OwnerAccountId,Name,Description,TimeZoneName,IsActive) VALUES
	 (N'002d5bf6-b013-4366-ae1a-acaa5d706eaa',N'Thu-15Min',N'Thu 15 mins',N'Australia/Melbourne',1),
	 (N'002d5bf6-b013-4366-ae1a-acaa5d706eaa',N'Fri-15Min',N'Fri 15 mins',N'Australia/Melbourne',1);
GO

-- Manually fetch the AccountName field from the CloudAccounts because of the ForeignKey: FK_CloudResources_CloudAccounts
--    CloudAccounts.AccountName == CloudResources.CloudAccountId
DECLARE @IntegratedAwsAccount NVARCHAR (200), @IntegratedAwsAccountName NVARCHAR (200),
		@ScheduleOneId BIGINT, @ScheduleTwoId BIGINT;

SET @IntegratedAwsAccount = '939744386038';

SELECT @IntegratedAwsAccountName = Id FROM SaveOnClouds.dbo.CloudAccounts WHERE AccountName = @IntegratedAwsAccount;
SELECT @ScheduleOneId = Id FROM SaveOnClouds.dbo.Schedules WHERE Name = 'Thu-15Min';
SELECT @ScheduleTwoId = Id FROM SaveOnClouds.dbo.Schedules WHERE Name = 'Fri-15Min';


INSERT INTO SaveOnClouds.dbo.CloudResources (UserId,CloudResourceId,Name,Location,InstanceType,Cost,CostOverriden,State,StateReason,ResourceType,IsMemberOfScalingGroup,CloudAccountId,ScheduleId,AccountType,CloudAccountNumber,PurchaseModel,UpFrontYears,OsType) VALUES
	 (N'002d5bf6-b013-4366-ae1a-acaa5d706eaa',N'i-05f3f369d10f782c8',N'i-05f3f369d10f782c8',N'US East (Virginia)',N't2.micro',0.00,0,2,N'Client.UserInitiatedShutdown: User initiated shutdown',1,0,@IntegratedAwsAccountName,@ScheduleOneId,1,@IntegratedAwsAccount,1,0,N'linux'),
	 (N'002d5bf6-b013-4366-ae1a-acaa5d706eaa',N'i-0154de46bd6f0af6b',N'i-0154de46bd6f0af6b',N'US East (Virginia)',N't2.micro',0.00,0,2,N'Client.UserInitiatedShutdown: User initiated shutdown',1,0,@IntegratedAwsAccountName,@ScheduleTwoId,1,@IntegratedAwsAccount,1,0,N'linux'),
	 (N'002d5bf6-b013-4366-ae1a-acaa5d706eaa',N'i-09d410d5aa156d427',N'i-09d410d5aa156d427',N'Asia Pacific (Sydney)',N't2.micro',0.00,0,2,N'Client.UserInitiatedShutdown: User initiated shutdown',1,0,@IntegratedAwsAccountName,@ScheduleOneId,1,@IntegratedAwsAccount,1,0,N'linux'),
	 (N'002d5bf6-b013-4366-ae1a-acaa5d706eaa',N'i-0774b8ab17d9efdff',N'i-0774b8ab17d9efdff',N'Asia Pacific (Sydney)',N't2.micro',0.00,0,2,N'Client.UserInitiatedShutdown: User initiated shutdown',1,0,@IntegratedAwsAccountName,@ScheduleTwoId,1,@IntegratedAwsAccount,1,0,N'linux');
GO

-- Manually fetch the Id (Primary key) field from the Schedules table because of the ForeignKey: FK_Schedule_ScheduleDetails
--   Schedules.ScheduleId == ScheduleDetails.ScheduleId
DECLARE @ScheduleOneId BIGINT,
		@ScheduleTwoId BIGINT;

SELECT @ScheduleOneId = Id FROM SaveOnClouds.dbo.Schedules WHERE Name = 'Thu-15Min';
SELECT @ScheduleTwoId = Id FROM SaveOnClouds.dbo.Schedules WHERE Name = 'Fri-15Min';

INSERT INTO SaveOnClouds.dbo.ScheduleDetails (ScheduleId,DayOfTheWeek,HourOfDay,Quarter1,Quarter2,Quarter3,Quarter4) VALUES
	 (@ScheduleOneId,2,18,0,0,1,0),
	 (@ScheduleTwoId,2,19,1,0,1,0);


-- Manually fetch the Id (Primary key) field from the CloudResources table because of the ForeignKey: FK_Tags_CloudResources
--   CloudResources.Id == tags.cloudresourceid
DECLARE @ResourceOne BIGINT,
		@ResourceTwo BIGINT;

SELECT @ResourceOne = Id FROM SaveOnClouds.dbo.CloudResources WHERE CloudResourceId = 'i-05f3f369d10f782c8';
SELECT @ResourceTwo = Id FROM SaveOnClouds.dbo.CloudResources WHERE CloudResourceId = 'i-0774b8ab17d9efdff';

INSERT INTO SaveOnClouds.dbo.tags (cloudresourceid,[key],value) VALUES
	 (@ResourceOne,N'Name',N'ubuntu-server'),
	 (@ResourceTwo,N'Name',N'temp-1');
GO

-- This webhook URL points to #sandbox-cloud-cost Slack channel.
-- Running the notifications lambda will send the message to this slack webhook.
INSERT INTO SaveOnClouds.dbo.Channels (OwnerUserId,ChannelType,Name,WebHookAddress,InstanceStop,InstanceStart,EnvStop,EnvStart,AccountErrors,Enabled) VALUES
	 (N'002d5bf6-b013-4366-ae1a-acaa5d706eaa',1,N'Slack Webhook',N'https://hooks.slack.com/services/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',1,1,1,1,1,1),
	 (N'002d5bf6-b013-4366-ae1a-acaa5d706eaa',2,N'Any Webhook',N'https://hooks.slack.com/services/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',1,1,1,1,1,1);
GO
