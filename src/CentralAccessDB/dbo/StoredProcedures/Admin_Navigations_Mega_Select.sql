
CREATE PROCEDURE [dbo].[Admin_Navigations_Mega_Select]
AS
BEGIN
	
	 select X.* FROM 
	(	SELECT 
		Id, ISNULL(Name,'') AS 'Name', ISNULL(Description,'') AS 'Description', ISNULL(Url,'') AS 'Url', ISNULL(DisplayOrder,1) AS 'DisplayOrder', ISNULL(IsActive,0) AS 'IsActive' ,ISNULL(TemplateId,1) AS TemplateId,
		(
			SELECT Id, ISNULL(MainNavigationId,0) AS 'MainNavigationId', ISNULL(Name,'') AS 'Name', ISNULL(Description,'') AS 'Description', ISNULL(Url,'') AS 'Url', ISNULL(DisplayOrder,1) AS 'DisplayOrder', ISNULL(IsActive,0) AS 'IsActive', ISNULL(ImageUrl,'') AS 'ImageUrl',
			(
				SELECT Id, ISNULL(RootPageId,0) AS 'RootPageId', ISNULL(AreaId,0) AS 'AreaId', ISNULL(Name,'') AS 'Name', LOWER(ISNULL(Url,'')) AS 'Url', ISNULL(Icon,'') AS 'Icon', ISNULL(ImageURL,'') AS 'ImageUrl', ISNULL(DispayOrder,'') AS 'DispayOrder' , ISNULL(IsActive,'') AS 'IsActive', ISNULL(ImageUrl,'') AS 'ImageUrl'
				FROM Admin_Nav_AreasWisePages 
				WHERE AreaId = MNA.Id 
				AND ISNULL(IsActive,0) = 1 AND ModuleId=2
				ORDER BY ISNULL(DisplayOrder,99999) ASC FOR JSON AUTO
				) AS 'Pages'
			FROM [dbo].[Admin_Nav_MainNavigationWiseAreas] MNA 
			WHERE MainNavigationId =  MN.Id 
			AND ISNULL(IsActive,0) = 1 AND MNA.ModuleId=2
			ORDER BY ISNULL(DisplayOrder,99999) ASC
			FOR JSON AUTO
			) AS 'Areas'
		FROM 
		[dbo].[Admin_Nav_MainNavigations] MN 	
		WHERE ISNULL(IsActive,0) = 1 AND MN.ModuleId=2					
	) as x
	ORDER BY ISNULL(X.DisplayOrder,99999)

					
END

GO

