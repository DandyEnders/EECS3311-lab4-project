note
	description: "Summary description for {SECTOR}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	SECTOR

create
	make,
	make_empty

feature -- Constants

	num_quadrants: INTEGER = 4

feature {NONE} -- Constructor

	make_empty(a_coordinate: COORDINATE)
		do
			coordinate := a_coordinate
		end

feature  -- Attribute

	quadrants: ARRAYED_LIST[QUADRANT] -- SEQ[QUADRANT]
	coordinate: COORDINATE

feature -- Command

	remove(me: MOVEABLE_ENTITY)
		local
			i: INTEGER
		do
			from
				i := quadrants.lower
			until
				i := quadrants.upper + 1
			loop
				if quadrants then

				end
				i := i + 1
			end
		end

	add (e: ENTITY)
		require
			not is_full
		do
			-- TODO
		end

feature -- Queries

	is_full: BOOLEAN
			-- Return true if quadrants is full.
		do
			Result := quadrants.count == num_quadrants
		end

	count: INTEGER
		do
			Result := 0
			across
				quadrants is i_q
			loop
				if not i_q.is_empty then
					Result := Result + 1
				end
			end
		end

	has(me: MOVEABLE_ENTITY): BOOLEAN
		do
			Result := quadrants.has(me)
		end

feature -- Output

	out: STRING
		do
			Result.make_empty
			across
				quadrants is i_q
			loop
				Result.append(i_q.out)
			end
		end

invariant
	min_max_count:
	0 <= count <= num_quadrants


end
