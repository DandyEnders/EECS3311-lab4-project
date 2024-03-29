note
	description: "[
		A class to represent an ID_ENTITY that can change 
		its coordinate and is capable of death.
	]"
	author: "Jinho Hwang, Ato Koomson"
	date: "April 13, 2020"
	revision: "1"

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

	make (a_coordinate: COORDINATE; a_id, a_max_life: INTEGER; charac: CHARACTER)
		do
			id_entity_make (a_coordinate, a_id, charac)
			deathable_make (a_max_life)
			add_death_cause_type ("BLACKHOLE")
		end

feature -- Commands

	kill_by_blackhole (killer_id: INTEGER)
		do
			kill_by ("BLACKHOLE")
			killers_id := killer_id
		ensure
			is_dead_by_blackhole
		end

	check_health (sector: SECTOR)
			-- execute kill_by_blackhole if sector.has_blachole ~ true.
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

	set_coordinate (a_coordinate: COORDINATE)
			-- intialize coordinate to a_coordinate
		do
			coordinate := a_coordinate
		ensure
			coordinate ~ a_coordinate
		end

feature -- Queries

	is_dead_by_blackhole: BOOLEAN
			-- was killed by BLACKHOLE?
		do
			Result := is_dead and then get_death_cause ~ "BLACKHOLE"
		end

feature -- out

	out_death_description: STRING
			-- result -> "out_description,%N    out_death_message".
		require
			is_dead
		do
			create Result.make_from_string (msg.left_big_margin)
			Result.append (out_description)
			Result.append (",%N")
			Result.append (msg.left_big_margin)
			Result.append (out_death_message)
		end

	out_death_message: STRING
			-- result -> {Abstract State: Death Message from pg 26-27 relevant to this entity}
		require
			is_dead
		deferred
		end

end
