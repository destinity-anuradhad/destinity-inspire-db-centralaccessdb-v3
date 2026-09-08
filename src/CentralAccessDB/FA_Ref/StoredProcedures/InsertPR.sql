
CREATE PROCEDURE [FA_Ref].[InsertPR] (@JsonData NVARCHAR(MAX))

AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
	    DECLARE @sErrorProcedure	VARCHAR(200),
				@sLog				VARCHAR(500),
				@sErrorMessage		VARCHAR(500),
				@DocumentNo			NVARCHAR(10),
				@BranchCode			NVARCHAR(250),
				@DepatId			INT,
				@SubDeptId			INT,
				@TransactionType	NCHAR(2)



		SELECT @BranchCode = BranchId,@DepatId = DepartmentId,@SubDeptId =SubDepartmentId
		FROM OpenJson(@JsonData) WITH 
		(
			[BranchId] INT, 
			[DepartmentId] INT,
			[SubDepartmentId] INT
		)



	
        SET @DocumentNo = dbo.FN_GetNextDocumentNumber(@BranchCode, @DepatId, @SubDeptId,'PR');


        IF @DocumentNo IS NULL
        BEGIN
            INSERT INTO [FA_Ref].TransactionTypeWiseNextNumbers
            (
                TxnType,
                BranchCode,
                DepartmentId,
                SubDepartmentId,
                LengthOfFormatting,
				NextNumber
            )
            VALUES
            ('PR', @BranchCode, @DepatId, @SubDeptId,6,1);
            SET @DocumentNo = dbo.FN_GetNextDocumentNumber(@BranchCode, @DepatId, @SubDeptId,'PR');
        END;
        DECLARE @Code VARCHAR(MAX) = 'PR';

        SET @DocumentNo = @Code + '/' + @DocumentNo;

        UPDATE  [FA_Ref].TransactionTypeWiseNextNumbers
        SET NextNumber = NextNumber + 1
        WHERE BranchCode = @BranchCode
              AND TxnType = 'PR'



		INSERT INTO FA_Tran.PurchaseRequestHeader(BranchId, DepartmentId,SubDepartmentId,Reason,SpecialInstruction,CreatedUser,CreatedDate,PRNo) 
		SELECT BranchId, DepartmentId,SubDepartmentId,Reason,SpecialInstruction,CreatedUser,GETDATE(),@DocumentNo
		FROM OpenJson(@JsonData) WITH 
		(
			[BranchId] INT, 
			[DepartmentId] INT,
			[SubDepartmentId] INT,
			[Reason] NVARCHAR(500),
			[SpecialInstruction] NVARCHAR(500),
			[CreatedUser] INT
			
		)

		INSERT INTO FA_Tran.PurchaseRequestDetails(ItemNo,CategoryLevel1Id,CategoryLevel2Id,CategoryLevel3Id,
		Description,Quantity,CreatedDate,RequestHeaderId) SELECT 
			JSON_VALUE(d.value,'$.Id') AS Id,
			JSON_VALUE(d.value,'$.CategoryLevel1ID') AS CategoryLevel1ID,
			JSON_VALUE(d.value,'$.CategoryLevel2ID') AS CategoryLevel2ID,
			JSON_VALUE(d.value,'$.CategoryLevel3ID') AS CategoryLevel3ID,
			JSON_VALUE(d.value,'$.Description') AS Description,
			JSON_VALUE(d.value,'$.Quantity') AS Quantity,
			GETDATE() AS CreatedDate,
			SCOPE_IDENTITY() AS RequestHeaderId
		FROM OPENJSON(@JsonData,'$.FillData') AS d


	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		DECLARE @iErrorNumber INT

		SELECT	@sErrorProcedure=ERROR_PROCEDURE()
		SELECT	@sErrorMessage=ERROR_MESSAGE()
		SELECT	@iErrorNumber=ERROR_NUMBER()

		RAISERROR (@sErrorMessage,16,1)

		RETURN 0
	END CATCH

END

GO

