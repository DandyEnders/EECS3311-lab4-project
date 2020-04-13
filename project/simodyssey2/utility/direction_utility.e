note
	description: "[
				A class that contains common direction COORDINATEs
		 		(e.g. N -> [-1,0], E -> [0,1] …)
	]"
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	DIRECTION_UTILITY

feature -- Attributes

	N: COORDINATE
			-- result -> [-1,0]
		do
			create Result.make ([-1, 0])
		end

	E: COORDINATE
			-- result -> [0,1]
		do
			create Result.make ([0, 1])
		end

	S: COORDINATE
			-- result -> [1,0]
		do
			create Result.make ([1, 0])
		end

	W: COORDINATE
			-- result -> [0,-1]
		do
			create Result.make ([0, -1])
		end

	NE: COORDINATE
			-- result -> [-1,1]
		do
			Result := N + E
		end

	SE: COORDINATE
			-- result -> [1,1]
		do
			Result := S + E
		end

	SW: COORDINATE
			-- result -> [1,-1]
		do
			Result := S + W
		end

	NW: COORDINATE
			-- result -> [-1,-1]
		do
			Result := N + W
		end

feature -- Queries

	number_for_direction (d: INTEGER): COORDINATE
			-- 1 implies result -> N, 2 implies result -> NE, 3 implies result -> E, 4 implies result -> SE, ... 8 implies result -> NW
		require
			d_is_in_range: d <= 8 and d >= 1
		do
			Result := N
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
		ensure
			Result.is_direction
		end

end
