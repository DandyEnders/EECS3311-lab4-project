note
	description: "A class to represent comparable coordinates."
	author: "CD, Jinho Hwang, Ato Koomson"
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
			-- the row of COORDINATE. ie [row, ]

	col: INTEGER
			-- the column of COORDINATE. ie [ ,column]
feature -- Queries

	is_less alias "<" (other: like Current): BOOLEAN
			-- current is "less-than" other iff ((current.row < other.row) OR (current.row = other.row and current.col < other.col)).
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
			-- current equals other iff current.row = other.row and current.col = other.col
		do
			if Current.row ~ other.row and Current.col ~ other.col then
				Result := True
			else
				Result := False
			end
		end

	add alias "+" (other: like Current): COORDINATE
			-- perform current + other, resulting in [row + other.row, col + other.col]
		do
			create Result.make ([row + other.row, col + other.col])
		end

	subtract alias "-" (other: like Current): COORDINATE
			-- perform current - other, resulting in [row - other.row, col - other.col]
		do
			create Result.make ([row - other.row, col - other.col])
		end

	is_direction: BOOLEAN
			-- result equals true iff current is equivelant to some COORDINATE in DIRECTION_UTILITY
		local
			d: DIRECTION_UTILITY
		do
			Result := current ~ d.n or current ~ d.s or current ~ d.w or current ~ d.e or current ~ d.nw or current ~ d.ne or current ~ d.sw or current ~ d.se
		end

	wrap_coordinate_to_coordinate (c, lower_bound, upper_bound: COORDINATE): COORDINATE
			--given COORDINATE c, result equals a COORDINATE that lies between lower_bound and upper_bound
		do
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
		end

feature -- out

	out: STRING -- output current as "(row:col)"
		do
			create Result.make_empty
			Result.append ("(")
			Result.append (out_colon)
			Result.append (")")
		end

	out_sqr_bracket: STRING -- output current as "[row:col]"
		do
			create Result.make_empty
			Result.append ("[")
			Result.append (out_colon)
			Result.append ("]")
		end

	out_colon: STRING -- output current as "row:col"
		do
			create Result.make_empty
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	out_sqr_bracket_comma: STRING -- output current as "[row,col]"
		do
			create Result.make_empty
			Result.append ("[")
			Result.append (row.out)
			Result.append (",")
			Result.append (col.out)
			Result.append ("]")
		end

end
