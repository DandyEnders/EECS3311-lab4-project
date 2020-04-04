note
	description: "Summary description for {DIRECTION_UTILITY}."
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	DIRECTION_UTILITY

feature

	N: COORDINATE
			-- result equals a COORDINATE after taking a unit-step, away from the origin [0,0] in the north direction. ie [-1,0]
		do
			create Result.make ([-1, 0])
		end

	E: COORDINATE
			-- result equals a COORDINATE after taking a unit-step, away from the origin [0,0] in the east direction. ie [0,1]
		do
			create Result.make ([0, 1])
		end

	S: COORDINATE
			-- result equals a coordinate after taking a unit-step, away from the origin [0,0] in the south direction. ie [1,0]
		do
			create Result.make ([1, 0])
		end

	W: COORDINATE
			-- result equals a COORDINATE after taking a unit-step, away from the origin [0,0] in the west direction. ie [0,-1]
		do
			create Result.make ([0, -1])
		end

	NE: COORDINATE
			-- result equals a COORDINATE after taking a unit-step, away from the origin [0,0] in the north-east direction. ie [-1,1]
		do
			Result := N + E
		end

	SE: COORDINATE
			-- result equals a COORDINATE after taking a unit-step, away from the origin [0,0] in the south-east direction. ie [1,1]
		do
			Result := S + E
		end

	SW: COORDINATE
			-- result equals a COORDINATE after taking a unit-step, away from the origin [0,0] in the south-west direction. ie [1,-1]
		do
			Result := S + W
		end

	NW: COORDINATE
			-- result equals a COORDINATE after taking a unit-step, away from the origin [0,0] in the north-west direction. ie [-1,-1]
		do
			Result := N + W
		end

	number_for_direction (d: INTEGER): COORDINATE
			-- result "is_direction" indicated by "d". ie 1 for a value of d returns N, 2 returns NE, 3 returns E, 4 returns SE, ... 8 returns NW
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
