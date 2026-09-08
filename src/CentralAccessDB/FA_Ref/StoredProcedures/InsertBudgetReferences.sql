CREATE PROCEDURE [FA_Ref].[InsertBudgetReferences] 
(
	@JsonData	VARCHAR(MAX), 
	@operation	CHAR(1),
	@SkipApproval bit=1
)
AS
BEGIN
	--SET NOCOUNT ON;
	SET XACT_ABORT,
	QUOTED_IDENTIFIER,
	ARITHABORT,
	ANSI_NULLS,
	ANSI_PADDING,
	ANSI_WARNINGS,
	CONCAT_NULL_YIELDS_NULL ON;
	SET NUMERIC_ROUNDABORT OFF;
  
    DECLARE @sErrorProcedure	VARCHAR(200),
			@sLog				VARCHAR(500),
			@sErrorMessage		VARCHAR(500),
			@datetoday			DATE,
            @Id					INT,
            @ReferenceId		VARCHAR(MAX),
			@NewPrioritySeq     INT,
			@HaveApprovals      BIT=0,
			@DBName				VARCHAR(100) =DB_NAME(),
			@UserID				INT,
			@ModuleID			INT=4,
			@HaveValidaton		BIT=0,
			@BudgetReferenceID		INT,
			@Description		VARCHAR(50)

    BEGIN TRY
		BEGIN TRANSACTION

		
		create table #TempUserId(UserID int)

		if(@operation = 'I')
			insert into #TempUserId(UserID) select UserID  from OPENJSON(@JsonData) with (UserID int)
		else
			insert into #TempUserId(UserID) select UserID  from OPENJSON(@JsonData, '$.NewData') with (UserID int)

		select @UserID = UserID from #TempUserId
		
		declare @CustomText varchar(500) ='Approavl for Holder Types ' + case when @operation='I' then 'Insert' else 'Update' end 
		 
		IF @SkipApproval=0
			exec [CheckApprovalsForMasterData] @datetoday,@UserID,@ModuleID,'[fa_ref].[BudgetReferences] ',' [fa_ref].[InsertBudgetReferences] ',@DBName,@operation,@JsonData,1,-999,@HaveApprovals OUTPUT	, @CustomText 

		IF @HaveApprovals = 0
		BEGIN
			IF @operation='I'
			BEGIN

				SELECT	BudgetReferenceID , Name , IsActive, UserID , getdate() Txndate
				INTO	#TemData
				FROM	OPENJSON(@JsonData)  
				WITH 
				(	BudgetReferenceID		INT, 
					Name				VARCHAR(200), 
					IsActive			BIT , 
					UserID				INT			
				) 

				SELECT @Description = Name FROM #TemData

				IF EXISTS(SELECT TOP(1) BudgetReferenceID FROM [fa_ref].[BudgetReferences]
				WHERE Name = @Description)
				BEGIN
					SET @HaveValidaton = 1
					RAISERROR('A record already exists for Description!',16,1)
					RETURN 0
				END

				INSERT	[fa_ref].[BudgetReferences] ( Name, IsActive, CreatedUserID, CreatedDate, ModifiedUserID, ModifiedDate)
				SELECT	Name, IsActive, UserID  , txndate, UserID, txndate
				FROM	#TemData 

				SET @datetoday = GETDATE();
				SET @Id = SCOPE_IDENTITY();
				SET @ReferenceId = CAST(@Id AS VARCHAR);

				SELECT @ReferenceId as BudgetReferenceID

				EXEC InsertAuditMaster 4,'I', 'BudgetReferenceID', @ReferenceId,@Id,@UserID,'192.168.1.1','BudgetReferences',
									   @datetoday,@datetoday,'Test', @JsonData;

				--EXEC	[fa_ref].[MasterData] @datetoday,1,'BudgetReferences','InsertBudgetReferences','eFinancials','I',@JsonData,1,@ReferenceId;

			END 
			ELSE
			BEGIN
			
				SELECT	BudgetReferenceID , Name , IsActive, UserID , getdate() Txndate
				INTO	#TemData1
				FROM	OPENJSON(@JsonData, '$.NewData')
				WITH 
				(
					budgetReferenceID		INT, 
					Name			VARCHAR(500), 
					IsActive			BIT , 
					UserID				INT
				) 

				--SELECT	@Id = BudgetReferenceID
				--FROM	#TemData1;

				SELECT @BudgetReferenceID = BudgetReferenceID, @Description = Name FROM #TemData1

				IF EXISTS(SELECT TOP(1) BudgetReferenceID FROM [fa_ref].[BudgetReferences]
				WHERE BudgetReferenceID <> @BudgetReferenceID AND Name = @Description)
				BEGIN
					SET @HaveValidaton = 1
					RAISERROR('A record already exists for Description!',16,1)
					RETURN 0
				END

			 

				UPDATE	o
				SET		o.Name= t.Name, 
						o.IsActive = t.IsActive,
						o.ModifiedUserID=t.UserID, 
						o.ModifiedDate= t.Txndate
				FROM	[fa_ref].[BudgetReferences] o 
						INNER JOIN #TemData1 t ON o.BudgetReferenceID= t.BudgetReferenceID

				select * from #TemData1

				SET @datetoday = GETDATE();
				SET @ReferenceId = CAST(@BudgetReferenceID AS VARCHAR);


				EXEC InsertAuditMaster 4,'U','BudgetReferenceID', @ReferenceId,@BudgetReferenceID,@UserID,'192.168.1.1','BudgetReferences',
									   @datetoday,@datetoday,'Test',@JsonData;

				--EXEC	[fa_ref].[MasterData] @datetoday,1,'BudgetReferences','InsertBudgetReferences','eFinancials','U',@JsonData,1,@ReferenceId;

			END 
		END

 
		--select @JsonData DATA,Getdate() logDATE into JsondataCHan

	
    	IF @@TRANCOUNT>0
			COMMIT TRANSACTION
			RETURN 1
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION

		DECLARE @iErrorNumber INT

		SELECT	@sErrorProcedure=ERROR_PROCEDURE()
		SELECT	@sErrorMessage=ERROR_MESSAGE()
		SELECT	@iErrorNumber=ERROR_NUMBER()

		IF(@HaveValidaton = 1)
		BEGIN
			EXEC sp_addmessage @msgnum = 50005, @severity = 1, @msgtext = @sErrorMessage,@replace = 'REPLACE';
			RAISERROR (50005,11,1)
		END
		ELSE
			RAISERROR (@sErrorMessage,16,1)

		RETURN 0
  
    END CATCH  
END

GO

