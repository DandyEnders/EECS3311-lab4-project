note
	description: "Summary description for {MOVEABLE_ENTITY}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MOVEABLE_ENTITY

inherit

	ID_ENTITY

	DEATHABLE
		rename
			make as deathable_make
		undefine
			out,
			is_equal
		end

feature -- Commands (2)

	check_health (sector: SECTOR)
		require
			sector.coordinate ~ coordinate
		deferred
		end

feature -- out

	out_death_description: STRING
		do
			create Result.make_from_string ("    ")
			Result.append (out_description)
			Result.append (",%N")
			Result.append ("      ")
		end

end
