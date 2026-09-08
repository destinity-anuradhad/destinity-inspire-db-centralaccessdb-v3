CREATE FUNCTION [dbo].[FN_GetNextDocumentNumber](@BranchCode NVARCHAR(250),@DepatId INT, @SubDeptId INT, @TransactionType char(2))
returns varchar(max)
begin

declare @nextDocumentNumber bigint, @LengthOfFormatting INT

    select  @nextDocumentNumber=NextNumber , @LengthOfFormatting=LengthOfFormatting from [FA_Ref].TransactionTypeWiseNextNumbers
	where BranchCode=@BranchCode and TxnType=@TransactionType and DepartmentId = @DepatId AND SubDepartmentId = @SubDeptId

	return right('000000000000000000000'+convert(varchar(max),@nextDocumentNumber),@LengthOfFormatting)
end

GO

