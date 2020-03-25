note
	description: "Summary description for {ASTEROID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ASTEROID

inherit

	NP_MOVEABLE_ENTITY
		redefine
			make,
			out_death_description,
			out_description
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
				check attached {BLACKHOLE} sector.get_stationary_entity as b_e then
					kill_by_blackhole (b_e.id)
				end
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
				sector.moveable_entities_in_increasing_order is me
			loop
				if attached {MALEVOLENT} me as m_me then
					m_me.kill_by_asteroid (current.id)
				elseif attached {BENIGN} me as b_me then
					b_me.kill_by_asteroid (current.id)
				elseif attached {JANITAUR} me as j_me then
					j_me.kill_by_asteroid (current.id)
				elseif attached {EXPLORER} me as e_me then
					if not e_me.landed then
						e_me.kill_by_asteroid (current.id)
					end
				end
			end
			set_turns_left (rng.rchoose (0, 2))
		end

	kill_by_blackhole (k_id: INTEGER)
		do
			turns_left := -1
			kill_by ("BLACKHOLE")
			killers_id := k_id
		end

	kill_by_janitaur (k_id: INTEGER)
		do
			turns_left := -1
			kill_by ("JANITAUR")
			killers_id := k_id
		ensure
			is_dead_by_janitaur
		end

feature -- out

	out_death_description: STRING -- "Outputs Abstract Death Message on pg 26"
		do
			Result:=precursor
			if is_dead_by_blackhole then
				Result.append (msg.moveable_entity_death_blackhole (current, coordinate.row, coordinate.col, killers_id))
			elseif is_dead_by_janitaur then
				Result.append (msg.death_by_janitaur (current, coordinate.row, coordinate.col, killers_id))
			end
		end

	out_description: STRING
		local
			turns_left_string: STRING
		do
			Result:=Precursor
			if turns_left < 0 then
				create turns_left_string.make_from_string ("N/A")
			else
				turns_left_string:=turns_left.out
			end
			Result.append ("turns_left:" + turns_left_string.out)
		end

end
