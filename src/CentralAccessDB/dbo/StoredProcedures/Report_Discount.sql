

-- =============================================
-- Author:		Banu
-- Create date: 06/12/2018
-- Description:	Discount Report
-- =============================================
----EXEC Report_Discount '101','29/04/2021','29/04/2021', 1
CREATE PROCEDURE [dbo].[Report_Discount]
	 @Outlet		VARCHAR(10),
	 @FromDate		DATETIME,      
	 @ToDate		DATETIME,
	 @PropertyId	INT
AS
BEGIN
	SET DATEFORMAT DMY

	SELECT L.description, SUM(BH.Subtotal) AS SubTotal, SUM(BH.TaxVal1+BH.TaxVal2+BH.TaxVal3+BH.TaxVal4) AS Tax,      
		BH.OrderNo, BH.OrderDate, 0 AS 'Pax', SUM(BH.Discount) AS Discount, SUM(BH.ServiceCharge) AS ServiceCharge        
	FROM BillHeader BH      
	INNER JOIN PayTrans PT ON BH.OrderNo = PT.OrderNo AND BH.OrderDate = PT.OrderDate AND BH.Outlet = PT.Outlet        
	INNER JOIN PaymentTypes PYT ON PT.PayCode = PYT.PayCode       
	INNER JOIN Location_Ref L ON BH.Outlet = L.code      	    
	WHERE	(BH.OrderDate >= CONVERT(DATETIME,@FromDate,103)) AND         
			(BH.OrderDate <= CONVERT(DATETIME,@ToDate,103))     
			AND BH.Outlet IN (SELECT * FROM STRING_SPLIT(@Outlet,','))       
	GROUP BY BH.OrderNo,BH.OrderDate, L.description       
	HAVING SUM(BH.Discount) > 0 
	ORDER BY L.description , BH.OrderNo  

	--SELECT LR.description, BT.OrderNo, SUM(BT.Qty * BT.Rate) AS SubTotal 
	--FROM BillTrans BT
	--INNER JOIN BillHeader BH ON BH.Outlet = BT.Outlet AND BH.OrderDate = BT.OrderDate AND BH.OrderNo = BT.OrderNo
	--INNER JOIN Location_Ref LR ON LR.code = BT.Outlet
	--WHERE	CONVERT(DATE, BT.OrderDate) BETWEEN CONVERT(DATE, @FromDate) AND CONVERT(DATE, @ToDate)
	--		AND BT.Outlet IN (SELECT * FROM STRING_SPLIT(@Outlet,','))
	--		AND LEN(BT.DisCode) > 0
	--GROUP BY LR.description, BT.OrderNo
END

GO

