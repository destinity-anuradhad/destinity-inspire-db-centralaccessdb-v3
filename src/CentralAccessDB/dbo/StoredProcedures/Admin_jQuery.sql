
CREATE PROCEDURE [dbo].[Admin_jQuery]
	@TableName NVARCHAR(200),
	@CopyRights NVARCHAR(250)
AS
BEGIN
--DECLARE @TableName NVARCHAR(500)
--DECLARE @CopyRights NVARCHAR(500)
--SET @TableName = 'Users'
--SET @CopyRights = 'By Sachith Nuwan Kalehe Watta'

print '//iweb.simpleadmin.services.ui.'+LOWER(@TableName)+'.js'
SET @CopyRights = '//'+@CopyRights

SET NOCOUNT ON

SELECT *
INTO #tempTable
FROM
INFORMATION_SCHEMA.COLUMNS
WHERE
TABLE_NAME = @TableName

DECLARE @jsEdit NVARCHAR(MAX)
DECLARE @jsSave NVARCHAR(MAX)

DECLARE @currentColomn NVARCHAR(MAX)
DECLARE @currentDataType NVARCHAR(MAX)

SET @jsEdit = ''
SEt @jsSave = ''

--SELECT * FROM #tempTable
WHILE EXISTS (SELECT * FROM #tempTable)
BEGIN
	SELECT TOP 1 @currentColomn = COLUMN_NAME, @currentDataType  = DATA_TYPE FROM #tempTable
	
	IF(@currentDataType='bit')
	BEGIN
		
		SET @jsSave = @jsSave+ 'if($(''#'+@currentColomn+''').length > 0){obj.'+@currentColomn+'= $(''#'+@currentColomn+''').prop("checked");}'+CHAR(10)

		SET @jsEdit = @jsEdit + 'if($(''#'+@currentColomn+''').length > 0){'+CHAR(10)+
									'if (data.'+@currentColomn+') {
										$(''#'+@currentColomn+''').prop("checked", true);
									} else {
										$(''#'+@currentColomn+''').prop("checked", false);
									}'+CHAR(10)+
									'}'+CHAR(10)
	END
	ELSE
	BEGIN
		SET @jsSave = @jsSave+ 'if($(''#'+@currentColomn+''').length > 0){obj.'+@currentColomn+'= $(''#'+@currentColomn+''').val();}'+CHAR(10)
		SET @jsEdit = @jsEdit + 'if($(''#'+@currentColomn+''').length > 0){ $(''#'+@currentColomn+''').val(data.'+@currentColomn+');}'+CHAR(10)
	END
	

	DELETE TOP (1) FROM #tempTable
END

DROP TABLE #tempTable

--PRINT '//-- insert ----------'
--PRINT @jsSave
--PRINT '//-- end of insert ----------'

--PRINT '//-- update ----------'
--PRINT @jsEdit
--PRINT '//-- end of update ----------'

PRINT '//'+@CopyRights
PRINT '//'+CONVERT(NVARCHAR(20),GETDATE())
PRINT '$(document).ready(function () {
    $(''.form'').hide();
    $(''.grid'').show();
    FillGrid();
});'


PRINT '$(''body'').on(''click'', ''#btnForm'', function (e) {
    $(''.grid'').hide();
    ClearForm();
    $(''.form'').show();
});'

PRINT '$(''body'').on(''click'', ''#btnGrid'', function (e) {
    FillGrid();
    ShowGrid();
});'

PRINT '$(''body'').on(''click'', ''#btnSearch'', function (e) {
    e.preventDefault();
    FillGrid();
});'

PRINT '$(''body'').on(''submit'', ''#form'', function (e) {
    e.preventDefault();

    $(''#btnSubmit'').html(''<i class="fa fa-refresh fa-spin" style="font-size:14px"></i>  Please wait ....'');
    $(''#btnSubmit'').prop(''disabled'', true);

    var obj = {}
    '+@jsSave+'

    $.ajax({
        url: ''/'+LOWER(@tableName)+'/save'',
        dataType: ''JSON'',
        data: obj,
        beforeSend: function () {
            $(''#btnSubmit'').html(''<i class="fa fa-refresh fa-spin" style="font-size:14px"></i>  Please wait ....'');
            $(''#btnSubmit'').prop(''disabled'', true);
        },
        complete: function () {
            $(''#btnSubmit'').html(''Save'');
            $(''#btnSubmit'').prop(''disabled'', false);
        },
        method: ''POST'',
        success: function (data) {
            if (data.startsWith(''300-'')) {
                ShowErrorMessage(data.replace("300-", ""));
            } else {
                ShowSuccessMessage(''Record saved successfully.'');
                FillGrid();
            }

        },
        error: function (xhr, status, error) {
            console.log(error);
        }
    });
});'


PRINT 'function FillGrid() {
    if ($(''#grid'').length == 1) {
        $(''#grid tr'').not('':first-child'').remove();
        $.ajax({
            url: ''/'+LOWER(@tableName)+'/select?search='' + $(''#txtSearch'').val(),
            dataType: ''JSON'',
            beforeSend: function () {
                $(''.grid'').hide();
                $("#loadingProjects").show();
            },
            complete: function () {
				FillGrid();
                ShowGrid();
                $("#loadingProjects").hide();
            },
            method: ''POST'',
            success: function (data) {
                if (data.length == 0) {
                    $(''<tr><td colspan="4">No Record Found</td></tr>'').appendTo($(''#grid''));
                }

                $.each(data, function (index, item) {
                    var checked = "";
                    if (item.IsActive) {
                        checked = "checked";
                    }
                    var desc = item.Description;
                    if (desc.length > 100) {
                        desc = desc.substring(0, 100) + "...";
                    }
                    $(''<tr>'' +
                        ''<td>'' + item.Code + ''</td>'' +
                        ''<td>'' + item.Name + ''</td>'' +
                        ''<td><span title="'' + item.Description + ''" data-toggle="tooltip">'' + desc + ''</span></td>'' +
                        ''<td><input type="checkbox"  disabled="true" '' + checked + ''/></td>'' +
                        ''<td class="text-right">'' +
                        ''<a href="#" data-id="'' + item.Id + ''" class="btn btn-sm btn-default btnEdit" title="Edit" data-toggle="tooltip" style="margin-right:5px;">'' +
                        ''<span class="glyphicon glyphicon-edit"></span>'' +
                        ''</a>'' +
                        ''<a href="#"  data-href="/'+LOWER(@tableName)+'/delete/'' + item.Id + ''" class="btn btn-sm btn-default call-popup-model-delete btnDelete" title="Delete" data-toggle="tooltip">'' +
                        ''<span class="glyphicon glyphicon-trash"></span>'' +
						''</a>'' +
                        ''</td>'' +
                        ''</tr>'').appendTo($(''#grid''));
                });
            },
            error: function (xhr, status, error) {
                console.log(error);
            }
        });
    }
}'

PRINT '$(''body'').on(''click'', ''.btnEdit'', function (e) {
    e.preventDefault();
    ClearForm();
    $.ajax({
        url: ''/'+LOWER(@tableName)+'/edit/'',
        dataType: ''JSON'',
        data: { id: $(this).attr(''data-id'') },
        beforeSend: function () {
            $(''.btnEdit'').attr(''disabled'', true);
            $(''.btnDelete'').attr(''disabled'', true);
        },
        complete: function () {
            $(''.btnEdit'').attr(''disabled'', false);
            $(''.btnDelete'').attr(''disabled'', false);			
        },
        method: ''POST'',
        success: function (data) {
           
            if (data != null && data.Id > 0) {
                '+@jsEdit+'
                $(''.grid'').hide(''fast'');
                $(''.form'').show(''fast'');

            }

        },
        error: function (xhr, status, error) {
            console.log(error);
        }
    });
});'

END

GO

