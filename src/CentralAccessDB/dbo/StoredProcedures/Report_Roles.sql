CREATE PROCEDURE [dbo].[Report_Roles]
AS
BEGIN
	SELECT
    B.Name AS Role,
	B.CreatedDate,
	B.IsActive,
	D.FullName AS CreatedUser,
	E.FullName AS ModifiedUser,
	B.ModifiedDate,
	ISNULL(B.HierarchicalLevel,1) AS HierarchicalLevel,
    STUFF (                                   -- remove leading comma+space
        (   SELECT DISTINCT ', ' + C.Name
            FROM Central_UserRoleWiseMenuItems AS A  WITH (NOLOCK)
            INNER JOIN Central_Modules         AS C  WITH (NOLOCK) ON A.ModuleId = C.Id
            WHERE A.UserRoleId = B.Id         -- keep names in a deterministic order
            FOR XML PATH(''), TYPE             -- concatenate into one XML fragment
        ).value('.', 'nvarchar(max)')
    , 1, 2, '') AS Modules
	FROM Central_UserRoles AS B WITH (NOLOCK)
	INNER JOIN Central_Users D WITH(NOLOCK) ON D.Id = B.CreatedUserId
	INNER JOIN Central_Users E WITH(NOLOCK) ON E.Id = B.ModifiedUserId
	ORDER BY B.Name

END

GO

