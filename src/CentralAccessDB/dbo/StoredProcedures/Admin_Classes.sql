
-- [dbo].[Admin_Classes] 'ReservationCategories','Sachith'
create PROCEDURE [dbo].[Admin_Classes]
	@TableName NVARCHAR(200),
	@CopyRights NVARCHAR(250)
AS
BEGIN

--DECLARE @TableName NVARCHAR(500)
--DECLARE @CopyRights NVARCHAR(500)
--SET @TableName = 'Users'
--SET @CopyRights = 'By Sachith Nuwan Kalehe Watta'
SET @CopyRights = '--'+@CopyRights

SET NOCOUNT ON

SELECT *
INTO #tempTable
FROM
INFORMATION_SCHEMA.COLUMNS
WHERE
TABLE_NAME = @TableName

DECLARE @spParameters NVARCHAR(MAX)
DECLARE @classProperties NVARCHAR(MAX)

SET @spParameters = ''
SEt @classProperties = ''

WHILE EXISTS (SELECT * FROM #tempTable)
BEGIN

	SELECT TOP 1
	@spParameters = @spParameters +CHAR(9)+'sqlParameters.Add(new SqlParameters { DataType = '+
									(	CASE DATA_TYPE WHEN 'int' THEN 'DataType.Int32' 
										WHEN 'bit' THEN 'DataType.Boolean'  
										WHEN 'datetime' THEN 'DataType.DateTime' 
										ELSE 'DataType.String' END
									)+', Name = "@'+COLUMN_NAME+'", Value = obj.'+COLUMN_NAME+' });'+CHAR(10),

	@classProperties = @classProperties+ CHAR(9)+'public '+(	CASE DATA_TYPE WHEN 'int' THEN 'int' 
										WHEN 'bit' THEN 'bool'  
										WHEN 'datetime' THEN 'DateTime' 
										WHEN 'nvarchar' THEN 'string' 
										WHEN 'varchar' THEN 'string' 
										WHEN 'char' THEN 'string' 
										WHEN 'decimal' THEN 'decimal' 
										WHEN 'money' THEN 'decimal' 
										ELSE 'string' END
									)+' '+COLUMN_NAME+'{ get; set; }'+CHAR(10)
	FROM #tempTable

	DELETE TOP (1) FROM #tempTable
END

DROP TABLE #tempTable

DECLARE @funSave NVARCHAR(MAX)
DECLARE @funSelectAll NVARCHAR(MAX)
DECLARE @funSelectById NVARCHAR(MAX)
DECLARE @funSearch NVARCHAR(MAX)
DECLARE @funDelete NVARCHAR(MAX)

SET @funSave = 'public void Save('+@TableName+' obj)'+CHAR(10)+'{'+CHAR(10)+CHAR(9)+'List<SqlParameters> sqlParameters = new List<SqlParameters>();'+CHAR(10)+@spParameters+CHAR(9)+'new DbConnectivity().ExecuteSP("'+@TableName+'_M_Save", sqlParameters);'+CHAR(10) +'}'
SET @funSelectAll = 'public List<'+@TableName+'> Select()'+CHAR(10)+'{'+CHAR(10)+CHAR(9)+'return new DbConnectivity().ExecuteSelectSP<'+@TableName+'>("'+@TableName+'_M_Select").ToList();'+CHAR(10) +'}'
SET @funSelectById = 'public '+@TableName+' SelectById(int id)'+CHAR(10)+'{'+CHAR(10)+CHAR(9)+'List<SqlParameters> sqlParameters = new List<SqlParameters>();'+CHAR(10)+CHAR(9)+'sqlParameters.Add(new SqlParameters { DataType = DataType.Int32, Name = "@Id", Value = id });'+CHAR(10)+CHAR(9)+'return new DbConnectivity().ExecuteSelectSP<'+@TableName+'>("'+@TableName+'_M_SelectById", sqlParameters).FirstOrDefault();'+CHAR(10) +'}'
SET @funDelete = 'public void Delete(int id)'+CHAR(10)+'{'+CHAR(10)+CHAR(9)+'List<SqlParameters> sqlParameters = new List<SqlParameters>();'+CHAR(10)+CHAR(9)+'sqlParameters.Add(new SqlParameters { DataType = DataType.Int32, Name = "@Id", Value = id });'+CHAR(10)+CHAR(9)+'new DbConnectivity().ExecuteSP("'+@TableName+'_M_Delete", sqlParameters);'+CHAR(10) +'}'
SET @funSearch = 'public List<'+@TableName+'> Search(string keyword)'+CHAR(10)+'{'+CHAR(10)+CHAR(9)+'List<SqlParameters> sqlParameters = new List<SqlParameters>();'+CHAR(10)+CHAR(9)+'sqlParameters.Add(new SqlParameters { DataType = DataType.String, Name = "@Keyword", Value = keyword });'+CHAR(10)+CHAR(9)+'return new DbConnectivity().ExecuteSelectSP<'+@TableName+'>("'+@TableName+'_M_Search", sqlParameters).ToList();'+CHAR(10) +'}'

--PRINT @funSave
--PRINT @funSelectAll
--PRINT @funSelectById
--PRINT @funSearch
--PRINT @funDelete

PRINT '//-------------- Domain.cs ---------------------'
PRINT 
'//'+@CopyRights+CHAR(10)+'//'+CONVERT(NVARCHAR(30),GETDATE())+CHAR(10)+
'public class '+@TableName+
'{'+CHAR(10)+
@classProperties+
'}'
PRINT '//-------------- End of Domain.cs ---------------------'+CHAR(10)

PRINT '//-------------- Service.cs ---------------------'
PRINT 

'//'+@CopyRights+CHAR(10)+'//'+CONVERT(NVARCHAR(30),GETDATE())+CHAR(10)+
'public class '+@TableName+'Service
    {
        public void Save('+@TableName+' obj)
        {
            CustomValidatations.ValidateModel<'+@TableName+'>(obj);

            if (obj.Id == 0)
                new '+@TableName+'Entry().Save(obj);
            else
                new '+@TableName+'Entry().Save(obj);
        }
        public void Delete(Int32 id)
        {
            FindById(id);
            new '+@TableName+'Entry().Delete(id);
        }
        public '+@TableName+' Select(int id)
        {
            return FindById(id);
        }

		public List<'+@TableName+'> Search(string keyword)
        {
            return new '+@TableName+'Entry().Search(keyword);
        }


        public List<'+@TableName+'> Select(String type = null)
        {
            if (type == null)
                return new '+@TableName+'Entry().Select();

            switch (type.ToLower())
            {
               case SelectType.ActiveOnly:
                    return new  '+@TableName+'Entry().Select().Where(x=>x.IsActive).ToList();
                case SelectType.InactiveOnly:
                    return new '+@TableName+'Entry().Select().Where(x => x.IsActive == false).ToList();
                default:
                    return new '+@TableName+'Entry().Select();            
            }
        }

        #region PrivateMethods
        private '+@TableName+' FindById(int id)
        {
            '+@TableName+' obj = new '+@TableName+'Entry().SelectById(id);            
            if (obj == null || obj.Id == 0)
                throw new ModelInvalidException(CommonValidationMessages.RecordNotExistsInDb);
            return obj;
        }
        #endregion
    }
'
PRINT '//-------------- End of Service.cs ---------------------'


PRINT '//-------------- Entry.cs ---------------------'
PRINT 
'//'+@CopyRights+CHAR(10)+'//'+CONVERT(NVARCHAR(30),GETDATE())+CHAR(10)+
'public class '+@TableName+'Entry'+CHAR(10)+'{'+CHAR(10)+
@funSave+CHAR(10)+
@funSelectAll+CHAR(10)+
@funSelectById+CHAR(10)+
@funSearch+CHAR(10)+
@funDelete+CHAR(10)+
'}'+CHAR(10)
PRINT '//-------------- End of Entry.cs ---------------------'



PRINT '//-- Controller ------------------------'
PRINT 
'//'+@CopyRights+CHAR(10)+'//'+CONVERT(NVARCHAR(30),GETDATE())+CHAR(10)+
'public class '+@TableName+'Controller : BaseController

    {
        [VerifyLoggedUser]
        public ActionResult Index()
        {
            return View();
        }

        [VerifyLoggedUser]
        public JsonResult Select(string search = null)
        {
           if (string.IsNullOrWhiteSpace(search))
            {
                return Json(new '+@TableName+'Service().Select(SelectType.All), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new '+@TableName+'Service().Search(search), JsonRequestBehavior.AllowGet);
            }
        }


        [VerifyLoggedUser]
        public JsonResult SelectActive()
        {
            return Json(new '+@TableName+'Service().Select(SelectType.ActiveOnly), JsonRequestBehavior.AllowGet);
        }

        [VerifyLoggedUser]
        public ActionResult Save('+@TableName+' obj)
        {
            try
            {
                '+@TableName+'Service ps = new '+@TableName+'Service();
                //string imageUrl = BaseController.UploadImage("'+@TableName+'", obj.ImageURL, obj.Name);
                //if (imageUrl == "300")
                //{
                //    return Json("300-Image uploading fail,Please check image type. Only JPG & PNG allowed", JsonRequestBehavior.AllowGet);
                //}
                //obj.ImageURL = imageUrl;
                ps.Save(obj);
                return Json("OK", JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json("300-" + ex.Message, JsonRequestBehavior.AllowGet);
            }
        }

        [VerifyLoggedUser]
        public ActionResult Delete(int id)
        {
            try
            {
                '+@TableName+'Service ps = new '+@TableName+'Service();
                ps.Delete(id);
                return Json("OK", JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json("300-" + ex.Message, JsonRequestBehavior.AllowGet);
            }
        }

        [VerifyLoggedUser]
        public ActionResult Edit(int id)
        {
            try
            {
                '+@TableName+'Service ps = new '+@TableName+'Service();
                '+@TableName+' p = ps.Select(id);
                return Json(p, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json("300-" + ex.Message, JsonRequestBehavior.AllowGet);
            }
        }
    }'
PRINT '//-- End of Controller ------------------'



END

GO

