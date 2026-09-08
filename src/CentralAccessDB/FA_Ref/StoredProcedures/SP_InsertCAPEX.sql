CREATE PROCEDURE [FA_Ref].[SP_InsertCAPEX](@JsonData NVARCHAR(MAX))

AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		    DECLARE @sErrorProcedure	VARCHAR(200),
				@sLog				VARCHAR(500),
				@sErrorMessage		VARCHAR(500)

				
		INSERT INTO FA_Tran.CAPEXHeader([CAPEXNo],[CAPEXDate],[DepartmentId],[BranchCode],[SubDepartmentId],[Remarks],[CAPEXTypeId],[SupplierCode],[PRNo],[RequestedDate]) 
		SELECT CAPEXNo, CDate,Department,BranchCode,SubDept,Remarks,CAEXType,SupplierCode,NULLIF(PRNo, ''), RequestedDate
		FROM OpenJson(@JsonData) WITH 
		(
		CAPEXNo NVARCHAR(200),
		CDate DATE,
		Department INT,
		BranchCode NVARCHAR(250),
		SubDept INT,
		Remarks NVARCHAR(500),
		CAEXType INT,
		SupplierCode NVARCHAR(250),
		PRNo NVARCHAR(200), 
		RequestedDate DATE			
		)

		INSERT INTO [FA_Tran].[CAPEXDetails]([CAPEXHeaderId],[ItemDescription],[DelivaeryDate],[MainCatId],[Quantity],
		[CategoryId],[Price],[SubCatId],[BudgetBalance],[BudgetRefId])  SELECT 
		    SCOPE_IDENTITY() AS CAPEXHeaderId,
			JSON_VALUE(d.value,'$.description') AS description,
			JSON_VALUE(d.value,'$.deliverydate') AS deliverydate,
			JSON_VALUE(d.value,'$.mainCatId') AS mainCatId,
			JSON_VALUE(d.value,'$.qty') AS qty,
			JSON_VALUE(d.value,'$.catId') AS catId,
			JSON_VALUE(d.value,'$.price') AS price,
			JSON_VALUE(d.value,'$.subCatId') AS subCatId,
			JSON_VALUE(d.value,'$.budgetBalance') AS budgetBalance,
			JSON_VALUE(d.value,'$.budgetRefId') AS budgetRefId			
		FROM OPENJSON(@JsonData,'$.ItemList') AS d


	COMMIT TRANSACTION
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

