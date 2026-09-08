CREATE PROCEDURE [dbo].[Central_UserWiseIndividualReportAccess_M_Select_ByUrl]

@pageUrl NVARCHAR(250)

AS
BEGIN

	DECLARE @urlFirstString NVARCHAR(100)

	SET  @urlFirstString = SUBSTRING(@pageUrl,0,CHARINDEX('/reservations',@pageUrl))

	IF(@pageUrl LIKE '%/CashieringAndPosting/Posting/Landing/InHouse%')
	BEGIN
		SET @pageUrl='/CashieringAndPosting/Posting/Landing/InHouse'
	END

	IF(@pageUrl LIKE '%/cashieringandposting/posting/landing/rebate%')
	BEGIN
		SET @pageUrl='/cashieringandposting/posting/landing/rebate'
	END

	IF(@urlFirstString='/reservation' OR @urlFirstString='/Reservation')
	BEGIN
		IF(@pageUrl='/Reservation/Reservations/List/inhouse')
		BEGIN
			SET @pageUrl=@pageUrl
		END
		ELSE IF(@pageUrl='/Reservation/Reservations/List/checkout')
		BEGIN
			SET @pageUrl=@pageUrl
		END
		ELSE
		BEGIN
			SET @pageUrl='/reservation/reservations/list'
		END
	END
	ELSE
	BEGIN
		IF(@pageUrl='/CentralUsers/UserLockUnlock/1')
		BEGIN
			SET @pageUrl=@pageUrl
		END
		ELSE IF(@pageUrl='/CentralUsers/UserLockUnlock/3')
		BEGIN
			SET @pageUrl=@pageUrl
		END
		ELSE IF(@pageUrl='/CentralUsers/UserLockUnlock/2')
		BEGIN
			SET @pageUrl=@pageUrl
		END
		ELSE IF(@pageUrl='/CashieringAndPosting/Posting/Landing/Rebate')
		BEGIN
			SET @pageUrl=@pageUrl
		END
		ELSE IF(@pageUrl='/CashieringAndPosting/Posting/Landing/InHouse')
		BEGIN
			SET @pageUrl=@pageUrl
		END
		ELSE
		BEGIN
			SET @pageUrl=@pageUrl
		END
	END
	
	SELECT [Id] AS PageId
	FROM [dbo].[Admin_Nav_AreasWisePages]
	Where [Url] = @pageUrl
	AND IsActive=1

END

GO

