USE [powerbimonitor]
GO

CREATE OR ALTER VIEW [raw].[ActivityEvents] AS

SELECT 
  Activity, 
  ActivityEventId, 
  ActivityId, 
  AggregatedWorkspaceCount, 
  AggregatedWorkspacesByCapacitySku, 
  AggregatedWorkspacesByType, 
  AppName, 
  AppReportId, 
  ArtifactId, 
  ArtifactName, 
  CapacityId, 
  CapacityName, 
  ClientIP, 
  ConsumptionMethod, 
  CreationTime, 
  DashboardId, 
  DashboardName, 
  DataConnectivityMode, 
  DataflowAccessTokenEntityName,
  DataflowAccessTokenLifetimeInMinutes,
  DataflowAccessTokenPartitionUri,
  DataflowAccessTokenPermissions,
  DataflowId,
  DataflowName,
  DataflowType,
  DatasetCertificationStage, 
  DatasetId, 
  DatasetName, 
  Datasets, 
  DatasourceObjectIds, 
  DistributionMethod, 
  EmbedTokenId,
  ExportEventEndDateTimeParameter,
  ExportEventStartDateTimeParameter,
  ExportedArtifactArtifactId,
  ExportedArtifactArtifactType,
  ExportedArtifactExportType,
  ExternalSubscribeeInformation,
  FolderAccessRequests, 
  FolderAccessRequestsUserId, 
  FolderAccessRequestsRolePermissions, 
  FolderAccessRequestsUserObjectId, 
  FolderAccessRequestsGroupObjectId, 
  FolderDisplayName, 
  FolderObjectId, 
  GatewayId, 
  GenerateScreenshotEngineType, 
  GenerateScreenshotExportFormat, 
  GenerateScreenshotExportSourceType, 
  GenerateScreenshotExportType, 
  GenerateScreenshotExportUrl, 
  ImportDisplayName, 
  ImportId, 
  ImportSource, 
  ImportType, 
  IsSuccess, 
  ItemName, 
  LastRefreshTime, 
  ModelId, 
  ModelsSnapshots, 
  Monikers, 
  ObjectId, 
  Operation, 
  OrgAppPermission, 
  OrgAppPermissionRecipients, 
  OrganizationId, 
  RLSIdentitiesDatasets, 
  RLSIdentitiesRoles, 
  RLSIdentitiesUsername, 
  RecordType, 
  RefreshType, 
  ReportId, 
  ReportName, 
  ReportType, 
  RequestId, 
  SharingAction, 
  SharingInformation, 
  SubscribeeInformation,
  SubscriptionSchedule,
  SubscriptionScheduleEndDate,
  SubscriptionScheduleStartDate,
  SubscriptionScheduleTime,
  SubscriptionScheduleTimeZone,
  SubscriptionScheduleType,
  SubscriptionScheduleWeekDays,
  SwitchState, 
  UserAgent, 
  UserId, 
  UserKey, 
  UserType, 
  WorkSpaceName, 
  Workload, 
  WorkspaceId, 
  CAST(CAST(rows.filepath(1) AS VARCHAR(4)) AS INT) AS EventYear, 
  CAST(CAST(rows.filepath(2) AS VARCHAR(2)) AS INT) AS EventMonth,
  CAST(LEFT(RIGHT(CAST(rows.filepath(3) AS VARCHAR(50)),13),8) AS DATE) AS EventDate, 
  ADF_PipelineRunId, 
  ADF_PipelineTriggerTime
FROM 
  OPENROWSET(
    BULK 'https://[StorageAccountName].dfs.core.windows.net/raw/powerbi-tenant/activityevents/year=*/month=*/*', 
    FORMAT = 'CSV', 
    FIELDQUOTE = '0x0b', 
    FIELDTERMINATOR = '0x0b'
  ) WITH (
    jsonContent varchar(MAX)
  ) AS [rows] CROSS APPLY openjson (jsonContent) WITH (
    activityEventEntities NVARCHAR(MAX) AS JSON, 
    ADF_PipelineRunId VARCHAR(200) '$.ADF_PipelineRunId',
    ADF_PipelineTriggerTime DATETIME2 '$.ADF_PipelineTriggerTime'
  ) CROSS APPLY openjson (activityEventEntities) WITH (
    Activity VARCHAR(200) '$.Activity',
    ActivityEventId VARCHAR(50) '$.Id',
    ActivityId VARCHAR(50) '$.ActivityId',
    AggregatedWorkspaceCount INT '$.AggregatedWorkspaceInformation.WorkspaceCount', 
    AggregatedWorkspacesByCapacitySku VARCHAR(200) '$.AggregatedWorkspaceInformation.WorkspacesByCapacitySku', 
    AggregatedWorkspacesByType VARCHAR(200) '$.AggregatedWorkspaceInformation.WorkspacesByType', 
    AppName VARCHAR(200) '$.AppName',
    AppReportId VARCHAR(50) '$.AppReportId',
    ArtifactId VARCHAR(50) '$.ArtifactId', 
    ArtifactName VARCHAR(200) '$.ArtifactName', 
    CapacityId VARCHAR(200) '$.CapacityId',
    CapacityName VARCHAR(200) '$.CapacityName',
    ClientIP VARCHAR(200) '$.ClientIP',
    ConsumptionMethod VARCHAR(200) '$.ConsumptionMethod',
    CreationTime DATETIME '$.CreationTime',
    DashboardId VARCHAR(50) '$.DashboardId', 
    DashboardName VARCHAR(200) '$.DashboardName', 
    DataConnectivityMode VARCHAR(200) '$.DataConnectivityMode', 
    DataflowAccessTokenEntityName VARCHAR(255) '$.DataflowAccessTokenRequestParameters.entityName',
    DataflowAccessTokenLifetimeInMinutes INT '$.DataflowAccessTokenRequestParameters.tokenLifetimeInMinutes',
    DataflowAccessTokenPartitionUri VARCHAR(255) '$.DataflowAccessTokenRequestParameters.partitionUri',
    DataflowAccessTokenPermissions INT '$.DataflowAccessTokenRequestParameters.permissions',
    DataflowId VARCHAR(50) '$.DataflowId',
    DataflowName VARCHAR(200) '$.DataflowName',
    DataflowType VARCHAR(200) '$.DataflowType',
    DatasetCertificationStage VARCHAR(50) '$.DatasetCertificationStage', 
    DatasetId VARCHAR(50) '$.DatasetId',
    DatasetName VARCHAR(200) '$.DatasetName',
    Datasets NVARCHAR(MAX) '$.Datasets' AS JSON, 
    DatasourceObjectIds NVARCHAR(MAX) '$.DatasourceObjectIds' AS JSON, 
    DistributionMethod VARCHAR(200) '$.DistributionMethod',
    EmbedTokenId VARCHAR(50) '$.EmbedTokenId',
    ExportEventEndDateTimeParameter DATETIMEOFFSET '$.ExportEventEndDateTimeParameter',
    ExportEventStartDateTimeParameter DATETIMEOFFSET '$.ExportEventStartDateTimeParameter',
    ExportedArtifactArtifactId INT '$.ExportedArtifactInfo.ArtifactId',
    ExportedArtifactArtifactType VARCHAR(200) '$.ExportedArtifactInfo.ArtifactType',
    ExportedArtifactExportType VARCHAR(50) '$.ExportedArtifactInfo.ExportType',
    ExternalSubscribeeInformation NVARCHAR(MAX) '$.ExternalSubscribeeInformation' AS JSON,
    FolderAccessRequests NVARCHAR(MAX) '$.FolderAccessRequests' AS JSON, 
    FolderAccessRequestsUserId VARCHAR(200) '$.FolderAccessRequests[0].UserId', 
    FolderAccessRequestsRolePermissions VARCHAR(200) '$.FolderAccessRequests[0].RolePermissions', 
    FolderAccessRequestsUserObjectId VARCHAR(200) '$.FolderAccessRequests[0].UserObjectId', 
    FolderAccessRequestsGroupObjectId VARCHAR(200) '$.FolderAccessRequests[0].GroupObjectId', 
    FolderDisplayName VARCHAR(200) '$.FolderDisplayName', 
    FolderObjectId VARCHAR(50) '$.FolderObjectId', 
    GatewayId VARCHAR(50) '$.GatewayId', 
    GenerateScreenshotEngineType INT '$.GenerateScreenshotInformation.ScreenshotEngineType', 
    GenerateScreenshotExportFormat VARCHAR(200) '$.GenerateScreenshotInformation.ExportFormat', 
    GenerateScreenshotExportSourceType VARCHAR(200) '$.GenerateScreenshotInformation.ExportSourceType', 
    GenerateScreenshotExportType INT '$.GenerateScreenshotInformation.ExportType', 
    GenerateScreenshotExportUrl VARCHAR(200) '$.GenerateScreenshotInformation.ExportUrl', 
    ImportDisplayName VARCHAR(200) '$.ImportDisplayName', 
    ImportId VARCHAR(50) '$.ImportId', 
    ImportSource VARCHAR(50) '$.ImportSource', 
    ImportType VARCHAR(50) '$.ImportType', 
    IsSuccess BIT '$.IsSuccess',
    ItemName VARCHAR(200) '$.ItemName',
    LastRefreshTime DATETIME '$.LastRefreshTime', 
    ModelId INT '$.ModelId', 
    ModelsSnapshots NVARCHAR(MAX) '$.ModelsSnapshots' AS JSON, 
    Monikers VARCHAR(200) '$.Monikers', 
    ObjectId VARCHAR(50) '$.ObjectId',
    Operation VARCHAR(200) '$.Operation',
    OrgAppPermission VARCHAR(200) '$.OrgAppPermission.permissions',
    OrgAppPermissionRecipients VARCHAR(200) '$.OrgAppPermission.recipients',
    OrganizationId VARCHAR(50) '$.OrganizationId',
    RLSIdentitiesDatasets VARCHAR(50) '$.RLSIdentities[0].Datasets[0]',
    RLSIdentitiesRoles VARCHAR(200) '$.RLSIdentities[0].Roles[0]',
    RLSIdentitiesUsername VARCHAR(200) '$.RLSIdentities[0].Username',
    RecordType INT '$.RecordType',
    RefreshType VARCHAR(50) '$.RefreshType', 
    ReportId VARCHAR(50) '$.ReportId',
    ReportName VARCHAR(200) '$.ReportName',
    ReportType VARCHAR(200) '$.ReportType',
    RequestId VARCHAR(50) '$.RequestId',
    SharingAction VARCHAR(200) '$.SharingAction', 
    SharingInformation NVARCHAR(MAX) '$.SharingInformation' AS JSON, 
    SubscribeeInformation NVARCHAR(MAX) '$.SubscribeeInformation' AS JSON,
    SubscriptionSchedule NVARCHAR(MAX) '$.SubscriptionSchedule' AS JSON,
    SubscriptionScheduleEndDate DATETIME '$.SubscriptionSchedule.EndDate',
    SubscriptionScheduleStartDate DATETIME '$.SubscriptionSchedule.StartDate',
    SubscriptionScheduleTime NVARCHAR(MAX) '$.SubscriptionSchedule.Time' AS JSON,
    SubscriptionScheduleTimeZone VARCHAR(50) '$.SubscriptionSchedule.TimeZone',
    SubscriptionScheduleType VARCHAR(50) '$.SubscriptionSchedule.Type',
    SubscriptionScheduleWeekDays NVARCHAR(MAX) '$.SubscriptionSchedule.WeekDays' AS JSON,
    SwitchState VARCHAR(200) '$.SwitchState', 
    UserAgent VARCHAR(200) '$.UserAgent',
    UserId VARCHAR(50) '$.UserId',
    UserKey VARCHAR(20) '$.UserKey',
    UserType INT '$.UserType',
    WorkSpaceName VARCHAR(200) '$.WorkSpaceName',
    Workload VARCHAR(50) '$.Workload',
    WorkspaceId VARCHAR(200) '$.WorkspaceId'
)
