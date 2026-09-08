
CREATE PROCEDURE [dbo].[Central_User_T_PasswordTerminationRemainder_Exist]
@Username as NVARCHAR(50)
AS
BEGIN
	DECLARE @TerminationDate			DATE
	DECLARE @NextPasswordTerminationReminderOn	DATE,
	@NextPasswordTerminationReminderBeforeOn DATE,
	@IsReminderBeforeToday	BIT
	--@NextPasswordTerminationReminderBeforeTwoDays		DATE
	DECLARE @Remark						VARCHAR(MAX), @ReminderBeforeRemark NVARCHAR(MAX)

	SELECT 
		@TerminationDate = TerminationDate,
		@NextPasswordTerminationReminderOn = NextPasswordTerminationReminderOn
	FROM [dbo].[Central_Users] 
	WHERE Username = @Username

	--SELECT @NextPasswordTerminationReminderOn

	SET @NextPasswordTerminationReminderBeforeOn =  CONVERT(DATE, DATEADD(DAY, -1, @TerminationDate))

	--SET @NextPasswordTerminationReminderBeforeTwoDays = CONVERT(DATE, DATEADD(DAY, -2, @TerminationDate))

	--SELECT @NextPasswordTerminationReminderBeforeOn,@NextPasswordTerminationReminderBeforeTwoDays

	IF (CONVERT(DATE,@NextPasswordTerminationReminderOn) < CONVERT(DATE,GETDATE())) AND (CONVERT(DATE,@NextPasswordTerminationReminderBeforeOn)<> CONVERT(DATE,GETDATE()))
	BEGIN
		SET @Remark = 'Your password is going to expire on ' + CONVERT(varchar(20),@TerminationDate) + '. Please reset your password to avoid termination'
		RAISERROR(@Remark,16,1)		
	END
	ELSE IF (CONVERT(DATE,@NextPasswordTerminationReminderOn) < CONVERT(DATE,GETDATE())) AND (CONVERT(DATE,@NextPasswordTerminationReminderBeforeOn) =  CONVERT(DATE,GETDATE()))
	BEGIN
		SET @IsReminderBeforeToday = 1
		SELECT @IsReminderBeforeToday AS IsReminderBeforeToday
	END
	ELSE
	BEGIN
		SELECT 1
	END
END

GO

