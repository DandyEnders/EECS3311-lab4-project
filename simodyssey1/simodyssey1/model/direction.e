note
	description: "Summary description for {DIRECTION}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	DIRECTION

inherit
	COORDINATE

feature
	N: COORDINATE
		once
			create Result.make([-1, 0])
		end

	E: COORDINATE
		once
			create Result.make([0, 1])
		end

	S: COORDINATE
		once
			create Result.make([1, 0])
		end

	W: COORDINATE
		once
			create Result.make([0, -1])
		end

	NE: COORDINATE
		once
			Result := N + E
		end

	SE: COORDINATE
		once
			Result := S + E
		end

	SW: COORDINATE
		once
			Result := S + W
		end

	NW: COORDINATE
		once
			Result := N + W
		end

end
