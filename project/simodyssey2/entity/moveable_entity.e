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
			is_alive
		deferred
		end

	kill_by_blackhole(k_id:INTEGER)
		deferred
		ensure
			is_dead_by_blackhole
		end

feature	-- Queries
	is_dead_by_blackhole: BOOLEAN
		deferred end

feature -- out

	out_death_description: STRING
		require
			is_dead
		do
			create Result.make_from_string ("    ")
			Result.append (out_description)
			Result.append (",%N")
			Result.append ("      ")
		end

end
