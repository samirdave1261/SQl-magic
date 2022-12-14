
/********
Created By : SAMIR DAVE
*********/
Create FUNCTION [dbo].[MoneyToWords_convert] ---using Userdefined scalar function
(
	@Currency decimal(11,2)
)
RETURNS varchar(255)
AS
BEGIN
	DECLARE @tCurr varchar(12)
		,@RetVal varchar(255)

	SELECT @tCurr = CAST(@Currency AS varchar(12))
		,@RetVal = ''
	
	;WITH IndianCurrency (pos, ln, ord, sng, plr)
	AS
	(
		SELECT 1, 2, 5, 'cents', 'cents'
		UNION ALL SELECT 4, 3, 4,'',''
		--UNION ALL SELECT 4, 3, 4, 'Rupee', 'Rupees'
		UNION ALL SELECT 7, 2, 3, 'Thousand', 'Thousand'
		UNION ALL SELECT 9, 2, 2, 'Lakh', 'Lakhs'
		UNION ALL SELECT 11, 2, 1, 'Crore', 'Crores'
	), Split (Number, ord, sng, plr)
	AS
	(
		SELECT REVERSE(SUBSTRING(REVERSE(@tCurr), pos, ln))
			,ord, sng, plr
		FROM IndianCurrency
	), OrdWord (ord, Word)
	AS
	(
		SELECT ord
			,CASE
				WHEN @Currency >= 1 AND ord = 5 THEN ''
				WHEN W.Number < 0 AND ord = 4 THEN 'and '
				ELSE ''
			END
			+ COALESCE(W.NumberWord + ' ' + CASE WHEN W.Number = 1 and @Currency < 2 THEN S.sng ELSE S.plr END, '')
		FROM Split S
			LEFT JOIN NumberWords W
				ON S.Number = W.Number
		WHERE LEN(S.Number) > 0
	)
	SELECT @RetVal = @RetVal + COALESCE(' ' + Word, '')
	FROM OrdWord B
	WHERE LEN(Word) > 0
	ORDER BY ord

	RETURN UPPER(@RetVal)
END


--Select dbo.MoneyToWords_convert(1234)
