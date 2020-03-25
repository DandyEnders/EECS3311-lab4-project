note
	description: "Summary description for {ASTROID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ASTROID

inherit

	NP_MOVEABLE_ENTITY
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_coordinate: COORDINATE; a_id: INTEGER)
			-- Initialization for `Current'.
		do
			precursor (a_coordinate, a_id)
			deathable_make (1)
			add_death_cause_type ("BLACKHOLE")
			add_death_cause_type ("JANITAUR")
		end

feature -- Queries

	character: STRING = "A"

	is_dead_by_blackhole: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "BLACKHOLE"
		end

	is_dead_by_janitaur: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "JANITAUR"
		end

feature {NONE} -- Commands

	confirm_health (sector: SECTOR)
		do
			if sector.has_blackhole then
				kill_by_blackhole
			end
		end

feature -- Commands

	check_health (sector: SECTOR)
		do
			confirm_health (sector)
		end

	behave (sector: SECTOR)
		local
			rng: RANDOM_GENERATOR_ACCESS
		do
			across
				sector.ordered_moveable_entities is me
			loop
				if attached {MALEVOLENT} me as m_me then
					m_me.kill_by_astroid
				elseif attached {BENIGN} me as b_me then
					b_me.kill_by_astroid
				elseif attached {JANITAUR} me as j_me then
					j_me.kill_by_astroid
				elseif attached {EXPLORER} me as e_me then
					if not e_me.landed then
						e_me.kill_by_astroid
					end
				end
			end
			set_turns_left (rng.rchoose (0, 2))
		end

	kill_by_blackhole
		do
			kill_by ("BLACKHOLE")
		end

	kill_by_janitaur
		do
			kill_by ("JANITAUR")
		end

end
