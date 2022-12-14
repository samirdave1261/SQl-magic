

-- =============================================
-- Author:		<Samir Dave>
-- Create date: <2-jun-2022>
-- Description:	<User defined table Split-Function>
-- =============================================
Create FUNCTION [dbo].[SplitData]
(
  @List      nvarchar(max),
  @Delimiter nchar(1)
)
RETURNS @t table (Item nvarchar(max))
AS
BEGIN
  SET @List += @Delimiter;
  ;WITH a(f,t) AS  
  (
    SELECT CAST(1 AS bigint), CHARINDEX(@Delimiter, @List)
    UNION ALL
    SELECT t + 1, CHARINDEX(@Delimiter, @List, t + 1) 
    FROM a WHERE CHARINDEX(@Delimiter, @List, t + 1) > 0
  )  
  INSERT @t SELECT SUBSTRING(@List, f, t - f) FROM a OPTION (MAXRECURSION 0);
  RETURN;  
END


--SELECT * FROM dbo.SplitData('1,2,3,4',',');	