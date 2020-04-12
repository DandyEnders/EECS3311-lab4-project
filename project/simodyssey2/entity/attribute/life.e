note
	description: "A class that encapsulates an DEATHABLE's life."
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

class
	LIFE

inherit

	ANY
		redefine
			out
		end

create {DEATHABLE}
	make

feature {DEATHABLE}

	make (a_max: INTEGER)
		do
			max := a_max
			point := max
		end

feature -- Attribute

	point: INTEGER
			-- "life-point" as an INTEGER

	max: INTEGER
			-- maximum integer value of "point"

	is_dead: BOOLEAN
		do
			Result:= (point ~ 0)
		ensure
			Result = (point ~ 0)
		end


feature -- Commands

	set_life (a_value: INTEGER)
			-- initialize the value of "point" to  a_value
		require
			valid_value (a_value)
			not is_dead
		do
			point := a_value
		ensure
			point= a_value
		end

	add_life (a_value: INTEGER)
			-- increment "point" by "a_value" up to "max"
		require
			a_value >= 0
			not is_dead
		do
			if point + a_value >= max then
				point := max
			else
				point := point + a_value
			end
		end

	subtract_life (a_value: INTEGER)
			-- decrement "point" by "a_value" down to 0.
		require
			a_value >= 0
			not is_dead
		do
			if point - a_value <= 0 then
				point := 0
			else
				point := point - a_value
			end
		end

feature -- Queries

	valid_value (a_value: INTEGER): BOOLEAN
		do
			Result := a_value >= 0 and a_value <= max
		ensure
			Result = (a_value >= 0 and a_value <= max)
		end

	out: STRING
			-- result ~ "life:point/max" ie. "life:2/3"
		do
			create Result.make_from_string ("life:")
			Result.append (point.out)
			Result.append ("/")
			Result.append (max.out)
		end

invariant
	min_0: point >= 0 and max >= 0
	value_max: point <= max
	no_revive: (is_dead) = (point = 0)

end
