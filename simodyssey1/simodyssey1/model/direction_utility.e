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

end
