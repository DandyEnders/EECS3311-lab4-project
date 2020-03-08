note
	description: "Summary description for {LIFE}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	LIFE

create
	make

feature {NONE}
	make(a_max: INTEGER)
		do
			max := a_max
			value := max
			is_dead := false
		end


feature -- Attribute

	value: INTEGER

	max: INTEGER

	is_dead: BOOLEAN

feature -- Commands

	set_life(a_value: INTEGER)
		require
			valid_value(a_value)
			not is_dead
		do
			value := a_value
		end

	add_life(a_value: INTEGER)
			-- If a_value is too big, set vale to max. (Tolerant to big number)
		require
			a_value >= 0
			not is_dead
		do
			if value + a_value >= max then
				value := max
			else
				value := value + a_value
			end
		end

	subtract_life(a_value: INTEGER)
		require
			a_value >= 0
			not is_dead
		do
			if value - a_value <= 0 then
				value := 0
				is_dead := true
			else
				value := value - a_value
			end
		end

feature -- Queries

	valid_value(a_value: INTEGER): BOOLEAN
		do
			Result := a_value >= 0 and a_value <= max
		end

invariant
	min_0: value >= 0 and max >= 0
	value_max: value <= max
	no_revive: is_dead implies value = 0

end
