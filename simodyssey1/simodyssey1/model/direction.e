note
	description: "Summary description for {DIRECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DIRECTION

inherit
	COORDINATE
		rename
			make as coordinate_make
		end

create
	make

feature {NONE} -- Initialization

	make (c: TUPLE [row: INTEGER; col: INTEGER])
			-- Initialization for `Current'.
		require
			is_unit_coordinate(c)
		do
			coordinate_make(c)
		end

feature -- Queries

	is_unit_coordinate(c: COORDINATE): BOOLEAN
		do
			Result := -1 <= c.row and c.row <= 1 and -1 <= c.col and c.col <= 1 and not (c.row = 0 and c.col ~ 0)
		end

invariant
	unit_coordinate: -1 <= row and row <= 1 and -1 <= col and col <= 1
	not_empty: not (row = 0 and col ~ 0)

end
