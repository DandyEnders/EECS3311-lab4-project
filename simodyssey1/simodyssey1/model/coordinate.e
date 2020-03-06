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
			create Result.make([row + other.row, col + other.col])
		end

	out: STRING -- "(row:column)"
		do
			create Result.make_empty
			Result.append("(")
			Result.append(row.out)
			Result.append(":")
			Result.append(col.out)
			Result.append(")")
		end

end
