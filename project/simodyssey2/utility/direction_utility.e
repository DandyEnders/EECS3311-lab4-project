note
	description: "Summary description for {DIRECTION_UTILITY}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	DIRECTION_UTILITY

feature

	N: COORDINATE
		do
			create Result.make ([-1, 0])
		end

	E: COORDINATE
		do
			create Result.make ([0, 1])
		end

	S: COORDINATE
		do
			create Result.make ([1, 0])
		end

	W: COORDINATE
		do
			create Result.make ([0, -1])
		end

	NE: COORDINATE
		do
			Result := N + E
		end

	SE: COORDINATE
		do
			Result := S + E
		end

	SW: COORDINATE
		do
			Result := S + W
		end

	NW: COORDINATE
		do
			Result := N + W
		end

	direction_for_number (d: INTEGER): COORDINATE
			--1 means N, 2 means NE, 3 means E, 4 means SE, ... 8 means NW
		require
			d_is_in_range: d <= 8 and d >= 1
		do
			Result:= N

			if d ~ 1 then
				Result := N
			elseif d ~ 2 then
				Result := NE
			elseif d ~ 3 then
				Result := E
			elseif d ~ 4 then
				Result := SE
			elseif d ~ 5 then
				Result := S
			elseif d ~ 6 then
				Result := SW
			elseif d ~ 7 then
				Result := W
			elseif d ~ 8 then
				Result := NW
			end
		end

end
