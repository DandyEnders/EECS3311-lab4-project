note
	description: "A class to represent comparable coordinates in a Maze game."
	author: "CD"
	date: "August 2019"

class
	COORDINATE

inherit

	COMPARABLE
		redefine
			is_equal,
			out
		end

	ANY
		redefine
			is_equal,
			out
		end

create
	make

convert
	make ({TUPLE [INTEGER, INTEGER]})

feature {NONE} -- Initialization

	make (c: TUPLE [row: INTEGER; col: INTEGER])
		do
			row := c.row
			col := c.col
		end

feature -- Attributes

	row: INTEGER

	col: INTEGER

feature -- Queries

	is_less alias "<" (other: like Current): BOOLEAN
			-- Compare by row first, then by column. Is Current less than other?
		do
			if Current.row < other.row then
				Result := True
			else
				if Current.row ~ other.row and Current.col < other.col then
					Result := True
				else
					Result := False
				end
			end
		end

	is_equal (other: like Current): BOOLEAN
			-- is Current equal to other?
		do
			if Current.row ~ other.row and Current.col ~ other.col then
				Result := True
			else
				Result := False
			end
		end

	add alias "+" (other: like Current): COORDINATE
			-- coord1 + coord2
		do
			create Result.make ([row + other.row, col + other.col])
		end

	subtract alias "-" (other: like Current): COORDINATE
			-- coord1 - coord2
		do
			create Result.make ([row - other.row, col - other.col])
		end

	is_direction: BOOLEAN
			--return true if current is a DIRECTION
		local
			d: DIRECTION_UTILITY
		do
			Result := current ~ d.n or current ~ d.s or current ~ d.w or current ~ d.e or current ~ d.nw or current ~ d.ne or current ~ d.sw or current ~ d.se
		end

	wrap_coordinate (c, lower_bound, upper_bound: COORDINATE): COORDINATE
			--given a coordinate, returns a coordinate that lies between lower_bound and upper_bound
		local
--			wrap_row, wrap_col: INTEGER
		do
			-- // => modulus
--			wrap_row := (c.row - lower_bound.row) // upper_bound.row + lower_bound.row
--			wrap_col := (c.col - lower_bound.col) // upper_bound.col + lower_bound.col
--			create Result.make ([wrap_row, wrap_col])
			Result := c
			if c.row ~ (lower_bound.row - 1) then
				Result := Result + create {COORDINATE}.make ([upper_bound.row, 0])
			elseif c.row ~ upper_bound.row + 1 then
				Result := Result - create {COORDINATE}.make ([upper_bound.row, 0])
			end
			if c.col ~ lower_bound.col - 1 then
				Result := Result + create {COORDINATE}.make ([0, upper_bound.col])
			elseif c.col ~ upper_bound.col + 1 then
				Result := Result - create {COORDINATE}.make ([0, upper_bound.col])
			end
		ensure
			((c).row ~ lower_bound.row - 1 implies Result.row ~ upper_bound.row) and ((c).row ~ upper_bound.row + 1 implies Result.row ~ lower_bound.row) and ((c).col ~ lower_bound.col - 1 implies Result.col ~ upper_bound.col) and ((c).col ~ upper_bound.col + 1 implies Result.col ~ lower_bound.col) and (((c).col /~ upper_bound.col + 1 and (c).col /~ lower_bound.col - 1) implies (Result.col ~ (c.col))) and (((c).row /~ upper_bound.row + 1 and (c).row /~ lower_bound.row - 1) implies (Result.row ~ (c.row)))
		end

feature -- out

	out: STRING -- "(row:column)"
		do
			create Result.make_empty
			Result.append ("(")
			Result.append (out_colon)
			Result.append (")")
		end

	out_sqr_bracket: STRING -- "[row:colum]"
		do
			create Result.make_empty
			Result.append ("[")
			Result.append (out_colon)
			Result.append ("]")
		end

	out_colon: STRING -- "row:column"
		do
			create Result.make_empty
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end
end
