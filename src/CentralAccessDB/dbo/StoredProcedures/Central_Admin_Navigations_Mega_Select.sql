-- Central_Admin_Navigations_Mega_Select 40
--[dbo].[Central_Admin_Navigations_Mega_Select]4169
CREATE PROCEDURE [dbo].[Central_Admin_Navigations_Mega_Select]
@UserId INT=-1
AS
--BEGIN
	
--	 select X.* FROM 
--	(	SELECT 
--		Id, ISNULL(Name,'') AS 'Name', ISNULL(Description,'') AS 'Description', ISNULL(Url,'') AS 'Url', ISNULL(DisplayOrder,1) AS 'DisplayOrder', ISNULL(IsActive,0) AS 'IsActive' ,ISNULL(TemplateId,1) AS TemplateId,
--		(
--			SELECT Id, ISNULL(MainNavigationId,0) AS 'MainNavigationId', ISNULL(Name,'') AS 'Name', ISNULL(Description,'') AS 'Description', ISNULL(Url,'') AS 'Url', ISNULL(DisplayOrder,1) AS 'DisplayOrder', ISNULL(IsActive,0) AS 'IsActive', ISNULL(ImageUrl,'') AS 'ImageUrl',
--			(
--				SELECT Id, ISNULL(RootPageId,0) AS 'RootPageId', ISNULL(AreaId,0) AS 'AreaId', ISNULL(Name,'') AS 'Name', LOWER(ISNULL(Url,'')) AS 'Url', ISNULL(Icon,'') AS 'Icon', ISNULL(ImageURL,'') AS 'ImageUrl', ISNULL(DispayOrder,'') AS 'DispayOrder' , ISNULL(IsActive,'') AS 'IsActive', ISNULL(ImageUrl,'') AS 'ImageUrl'
--				FROM Admin_Nav_AreasWisePages 
--				WHERE AreaId = MNA.Id 
--				AND ISNULL(IsActive,0) = 1
--				ORDER BY ISNULL(DisplayOrder,99999) ASC FOR JSON AUTO
--				) AS 'Pages'
--			FROM [dbo].[Admin_Nav_MainNavigationWiseAreas] MNA 
--			WHERE MainNavigationId =  MN.Id 
--			AND ISNULL(IsActive,0) = 1
--			ORDER BY ISNULL(DisplayOrder,99999) ASC
--			FOR JSON AUTO
--			) AS 'Areas'
--		FROM 
--		[dbo].[Admin_Nav_MainNavigations] MN 	
--		WHERE ISNULL(IsActive,0) = 1					
--	) as x
--	ORDER BY ISNULL(X.DisplayOrder,99999)

--	----//---------------------------------------------------------------------------------------------------------------
--	--DECLARE  @MenuItems TABLE
--	--(
--	--	Id  INT,
--	--	Name NVARCHAR(500),
--	--	URL NVARCHAR(200),
--	--	IsActive BIT,
--	--	AreaString NVARCHAR(MAX)
--	--)

--	--DECLARE  @ModuleWiseAreas TABLE
--	--(
--	--	MenuItemId INT,
--	--	Id INT,
--	--	MainNavigation INT,
--	--	Name NVARCHAR(250),
--	--	Description NVARCHAR(500),
--	--	DisplayOrder INT ,
--	--	ImageUrl NVARCHAR(100),
--	--	PagesString NVARCHAR(MAX)
--	--)

--	--DECLARE  @ModuleWisePages TABLE
--	--(
--	--	MenuItemId INT,
--	--	Id INT ,
--	--	RootPageId INT,
--	--	AreaId INT,
--	--	Name NVARCHAR(250),
--	--	Url NVARCHAR(250),
--	--	Icon NVARCHAR(250) ,
--	--	ImageUrl NVARCHAR(250),
--	--	DisplayOrder INT,
--	--	IsActive BIT 
--	--)

--	--DECLARE @Pages TABLE
--	--(
--	--	MenuItemId INT,
--	--	Pages NVARCHAR(MAX)
--	--)

--	--DECLARE @AreaJSon NVARCHAR(MAX)
--	--DECLARE @PagesJSon NVARCHAR(MAX)
--	--DECLARE @MenuItemId INT

--	--INSERT INTO @MenuItems 
--	--EXEC [CentralAccessDB]..[Central_UserWiseMenuItems_Select]@UserId,3

--	--WHILE EXISTS(SELECT AreaString FROM @MenuItems)
--	--	BEGIN
--	--		SET @AreaJSon = (SELECT TOP 1 AreaString FROM @MenuItems)
--	--		SET @MenuItemId = (SELECT TOP 1 Id FROM @MenuItems)
--	--		INSERT INTO @ModuleWiseAreas
--	--        --SELECT * INTO #tempAreaWiseModules
--	--		SELECT @MenuItemId,* FROM 
--	--		OPENJSON (@AreaJSon)
--	--	    WITH (
--	--		   Id INT '$.Id',
--	--		   MainNavigation INT '$.MainNavigation',
--	--		   Name NVARCHAR(250) '$.Name',
--	--		   Description NVARCHAR(500) '$.Description',
--	--		   DisplayOrder INT '$.DisplayOrder',
--	--		   ImageUrl NVARCHAR(100) '$.ImageUrl',
--	--		   PagesString NVARCHAR(MAX) '$.PagesString'
--	--		   )
			   
--	--		   DELETE Top(1) FROM @MenuItems

--	--		END

--	--		INSERT INTO @Pages(MenuItemId,Pages)
--	--		SELECT MenuItemId,PagesString 
--	--		FROM @ModuleWiseAreas

--	--		WHILE EXISTS(SELECT * FROM @Pages)
--	--			BEGIN
--	--			SET @PagesJSon = (SELECT TOP 1 Pages FROM @Pages)
--	--			SET @MenuItemId = (SELECT TOP 1 MenuItemId FROM @Pages)
--	--			INSERT INTO @ModuleWisePages
--	--			SELECT @MenuItemId,*
--	--			FROM 
--	--			OPENJSON (@PagesJSon)
--	--			WITH (
--	--			   Id INT '$.Id',
--	--			   RootPageId INT '$.RootPageId',
--	--			   AreaId INT '$.AreaId',
--	--			   Name NVARCHAR(250) '$.Name',
--	--			   Url NVARCHAR(250) '$.Url',
--	--			   Icon NVARCHAR(250) '$.Icon',
--	--			   ImageUrl NVARCHAR(250) '$.ImageUrl',
--	--			   DisplayOrder INT '$.DisplayOrder',
--	--			   IsActive BIT '$.IsActive'
--	--			   )
			   
--	--			   DELETE Top(1) FROM @Pages

--	--			END
	
--	--	INSERT INTO @MenuItems 
--	--	EXEC [CentralAccessDB]..[Central_UserWiseMenuItems_Select]@UserId,3


--	--	SELECT M.Id,M.Name,'' As 'Description',M.URL,1 As 'DisplayOrder',M.IsActive,1 as 'TemplateId',
--	--	(	SELECT Id,ISNULL(MainNavigation,0) As MainNavigation,Name,ISNULL(Description,'') As Description,
--	--		ISNULL(DisplayOrder,1) AS DisplayOrder ,1 As IsActive,ISNULL(ImageUrl,'') as ImageUrl,
--	--		(
--	--			SELECT Id,ISNULL(RootPageId,0) as RootPageId ,ISNULL(AreaId,0) As AreaId,Name,ISNULL(Url,'') As Url,
--	--			ISNULL(Icon,'') As Icon,ISNULL(ImageUrl,'') As ImageUrl,
--	--			ISNULL(DisplayOrder,0) As DisplayOrder ,ISNULL(IsActive,0) As IsActive
--	--			FROM @ModuleWisePages MP WHERE MP.MenuItemId = M.Id FOR JSON AUTO 
--	--		) AS 'Pages'
--	--		FROM  @ModuleWiseAreas WHERE MenuItemId = M.Id FOR JSON AUTO
--	--	) AS 'Areas'
--	--	FROM @MenuItems M 				
--END
BEGIN


	DECLARE  @MenuItems TABLE
	(
		Id  INT,
		Name NVARCHAR(500),
		URL NVARCHAR(200),
		IsActive BIT,
		MenuType CHAR(1),
		AreaString NVARCHAR(MAX)
		
	)

	DECLARE  @ModuleWiseAreas TABLE
	(
		MenuItemId INT,
		Id INT,
		MainNavigation INT,
		Name NVARCHAR(250),
		Description NVARCHAR(500),
		URL NVARCHAR(500),
		DisplayOrder INT ,
		ImageUrl NVARCHAR(100),
		PagesString NVARCHAR(MAX)
	)

	DECLARE  @ModuleWisePages TABLE
	(
		MenuItemId INT,
		Id INT ,
		RootPageId INT,
		AreaId INT,
		Name NVARCHAR(250),
		URL NVARCHAR(250),
		Icon NVARCHAR(250) ,
		ImageUrl NVARCHAR(250),
		DisplayOrder INT,
		IsActive BIT 
	)

	DECLARE @Pages TABLE
	(	
		AreaId INT,
		MenuItemId INT,
		Pages NVARCHAR(MAX)
	)



	DECLARE @AreaJSon NVARCHAR(MAX)
	DECLARE @PagesJSon NVARCHAR(MAX)
	DECLARE @MenuItemId INT
	DECLARE @AreaId INT


	INSERT INTO @MenuItems 
	EXEC [CentralAccessDB]..[Central_UserWiseMenuItems_Select]@UserId,8

	--select * from @MenuItems

	WHILE EXISTS(SELECT AreaString FROM @MenuItems)
		BEGIN
			SET @AreaJSon = (SELECT TOP 1 AreaString FROM @MenuItems)
			SET @MenuItemId = (SELECT TOP 1 Id FROM @MenuItems)
			INSERT INTO @ModuleWiseAreas
	        --SELECT * INTO #tempAreaWiseModules
			SELECT @MenuItemId,Id,@MenuItemId,Name,Description,URL,DisplayOrder,ImageUrl,PagesString 
			FROM 
			OPENJSON (@AreaJSon)
		    WITH (
			   Id INT '$.Id',
			   Name NVARCHAR(250) '$.Name',
			   Description NVARCHAR(500) '$.Description',
			   URL NVARCHAR(500) '$.URL',
			   DisplayOrder INT '$.DisplayOrder',
			   ImageUrl NVARCHAR(100) '$.ImageUrl',
			   PagesString NVARCHAR(MAX) '$.PagesString'
			   )
			   
			   DELETE Top(1) FROM @MenuItems

			END

			INSERT INTO @Pages(MenuItemId,Pages,AreaId)
			SELECT MenuItemId,PagesString,Id
			FROM @ModuleWiseAreas

			WHILE EXISTS(SELECT * FROM @Pages)
				BEGIN
				SET @PagesJSon = (SELECT TOP 1 Pages FROM @Pages)
				SET @MenuItemId = (SELECT TOP 1 MenuItemId FROM @Pages)
				SET @AreaId = (SELECT TOP 1 AreaId FROM @Pages)
				INSERT INTO @ModuleWisePages
				SELECT @MenuItemId,Id,RootPageId,@AreaId,Name,URL,Icon,ImageUrl,DisplayOrder,IsActive
				FROM 
				OPENJSON (@PagesJSon)
				WITH (
				   Id INT '$.Id',
				   RootPageId INT '$.RootPageId',
				   Name NVARCHAR(250) '$.Name',
				   URL NVARCHAR(250) '$.URL',
				   Icon NVARCHAR(250) '$.Icon',
				   ImageUrl NVARCHAR(250) '$.ImageUrl',
				   DisplayOrder INT '$.DisplayOrder',
				   IsActive BIT '$.IsActive',
				   ImageUrl NVARCHAR(250) '$.ImageUrl'
				   )			   
				   DELETE Top(1) FROM @Pages

				END
	
		INSERT INTO @MenuItems 
		EXEC [CentralAccessDB]..[Central_UserWiseMenuItems_Select]@UserId,3




		SELECT DISTINCT M.Id,M.Name,'' As 'Description',M.URL,1 As 'DisplayOrder',M.IsActive,1 as 'TemplateId',
		(	SELECT Id,ISNULL(MainNavigation,0) As MainNavigation,Name,ISNULL(Description,'') As Description,ISNULL(URL,'') As URL,
			ISNULL(DisplayOrder,1) AS DisplayOrder ,1 As IsActive,ISNULL(ImageUrl,'') as ImageUrl,
			(
				SELECT DISTINCT Id,ISNULL(RootPageId,0) as RootPageId ,ISNULL(AreaId,0) As AreaId,Name,ISNULL(URL,'') As URL,
				ISNULL(Icon,'') As Icon,ISNULL(ImageUrl,'') As ImageUrl,
				ISNULL(DisplayOrder,0) As DisplayOrder ,ISNULL(IsActive,0) As IsActive,ISNULL(ImageUrl,'') As ImageUrl
				FROM @ModuleWisePages MP WHERE (MP.MenuItemId = M.Id 
				AND MP.AreaId = MA.Id 
				) FOR JSON AUTO 
			) AS 'Pages'
			FROM  @ModuleWiseAreas MA WHERE(MenuItemId = M.Id 
			) FOR JSON AUTO
		) AS 'Areas'
		FROM @MenuItems M 
		WHERE M.MenuType = 'N'
		
		
END

GO

