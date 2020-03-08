note
	description: "Summary description for {GRID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRID

inherit

	ANY
		redefine
			out
		end

	ITERABLE [SECTOR]
		redefine
			out
		end

create
	make

feature {NONE} -- Contstructor

	make (r, c, n_quadrant: INTEGER)
		require
			correct_row: r >= 0
			correct_col: c >= 0
			correct_quadrant: n_quadrant >= 0
		local
			sect: SECTOR
		do
			create sect.make_empty ([1, 1], 0)
			create sectors.make_filled (sect, r, c)
			across
				1 |..| r is i
			loop
				across
					1 |..| c is j
				loop
					create sect.make_empty ([i, j], n_quadrant)
					sectors [i, j] := sect
				end
			end
			row := sectors.height
			col := sectors.width
		end

feature {NONE} -- Attribute

	sectors: ARRAY2 [SECTOR]

	row: INTEGER

	col: INTEGER

feature -- Commands

	add (ie: ID_ENTITY; c: COORDINATE)
		require
			valid_coordinate (c)
			not has (ie)
			not at (c).is_full
		do
			at (c).add (ie)
		ensure
			at (c).has (ie)
		end

	remove (ie: MOVEABLE_ENTITY)
		do
			at (ie.coordinate).remove (ie)
		ensure
			not at (ie.coordinate).has (ie)
		end

	move (ie: MOVEABLE_ENTITY; to_c: COORDINATE)
		require
			has (ie)
			not at (to_c).is_full
		do
			remove (ie)
			add (ie, to_c)
		ensure
			at (to_c).has (ie)
		end

feature -- Queries

	at (c: COORDINATE): SECTOR
		require
			valid_coordinate (c)
		do
			Result := sectors [c.row, c.col]
		end

	valid_coordinate (c: COORDINATE): BOOLEAN
		do
			Result := 1 <= c.row and c.row <= row and 1 <= c.col and c.col <= col
		end

	has (ie: ID_ENTITY): BOOLEAN
		do
			Result := across sectors is i_s some i_s.has (ie) end
		end

feature -- Traversal

	new_cursor: ARRAY_ITERATION_CURSOR [SECTOR]
		do
			Result := sectors.new_cursor
		end

feature -- Out

	out: STRING
		do
			create Result.make_empty
			across
				1 |..| row is i
			loop
				Result.append ("    ")
				across
					1 |..| col is j
				loop
					Result.append (sectors [i, j].out_coordinate)
					Result.append ("  ")
				end
				Result.append ("%N")
				Result.append ("    ")
				across
					1 |..| col is j
				loop
					Result.append (sectors [i, j].out_quadrants)
					Result.append ("   ")
				end
				if i < row then
					Result.append ("%N")
				end
			end
		end

end
