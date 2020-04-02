note
	description: "Summary description for {MOVEABLE_ENTITY}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MOVEABLE_ENTITY

inherit

	ID_ENTITY
		rename
			make as id_entity_make
		end

	DEATHABLE
		rename
			make as deathable_make
		undefine
			out,
			is_equal
		end

feature {NONE} --Initialization

	make(a_coordinate: COORDINATE; a_id, a_max_life:INTEGER)
		do
			id_entity_make(a_coordinate,a_id)
			deathable_make(a_max_life)
			add_death_cause_type ("BLACKHOLE")
		end

feature -- Commands

	kill_by_blackhole(k_id:INTEGER)
		do
			kill_by ("BLACKHOLE")
			killers_id:=k_id
		ensure
			is_dead_by_blackhole
		end

	check_health (sector: SECTOR)
		require
			sector.coordinate ~ coordinate
			is_alive
		do
			if sector.has_blackhole then
				check attached {BLACKHOLE} sector.get_stationary_entity as b_e then
					kill_by_blackhole (b_e.id)
				end
			end
		ensure
			alive_or_dead_current_remains_in_sector: sector.coordinate ~ coordinate
		end
feature	-- Queries
	is_dead_by_blackhole: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "BLACKHOLE"
		end

feature -- out

	out_death_description: STRING
		require
			is_dead
		do
			create Result.make_from_string (msg.left_big_margin)
			Result.append (out_description)
			Result.append (",%N")
			Result.append (msg.left_big_margin)
			Result.append (out_death_message)
		end

	out_death_message: STRING -- {Abstract State: Death Message for pg 26-27 relevant to this entity}
		require
			is_dead
		deferred
		end

end
