note
	description: "A class to represent an asteroid entity."
	author: "Jinho Hwang, Ato Koomson"
	date: "April 13, 2020"
	revision: "1"

class
	ASTEROID

inherit

	NP_MOVEABLE_ENTITY
		rename
			make as np_moveable_make
		redefine
			out_description
		end

create
	make

feature {NONE} -- Initialization

	make (a_coordinate: COORDINATE; a_id, t_left: INTEGER)
			-- Initialization for `Current'.
		do
			np_moveable_make (a_coordinate, a_id, t_left, 'A')
			add_death_cause_type ("JANITAUR")
		end

feature -- Queries

	is_dead_by_janitaur: BOOLEAN
			-- was killed by JANITAUR?
		do
			Result := is_dead and then get_death_cause ~ "JANITAUR"
		end

feature -- Commands

	behave (sector: SECTOR)
			-- perform behavior algorithm that pertains to ASTEROID as seen on pg 36 of Project Specification
		local
			rng: RANDOM_GENERATOR_ACCESS
			destroyed_message: STRING
		do
			behavior_messages.make_empty
			across
				sector.moveable_entities_in_increasing_order is me
			loop
				if attached {MALEVOLENT} me as m_me then
					m_me.kill_by_asteroid (current.id)
					create destroyed_message.make_from_string (msg.left_margin + "destroyed " + m_me.out_sqr_bracket + " at " + sector.out_abstract_full_coordinate (m_me))
					behavior_messages.force (destroyed_message, behavior_messages.count + 1)
				elseif attached {BENIGN} me as b_me then
					b_me.kill_by_asteroid (current.id)
					create destroyed_message.make_from_string (msg.left_margin + "destroyed " + b_me.out_sqr_bracket + " at " + sector.out_abstract_full_coordinate (b_me))
					behavior_messages.force (destroyed_message, behavior_messages.count + 1)
				elseif attached {JANITAUR} me as j_me then
					j_me.kill_by_asteroid (current.id)
					create destroyed_message.make_from_string (msg.left_margin + "destroyed " + j_me.out_sqr_bracket + " at " + sector.out_abstract_full_coordinate (j_me))
					behavior_messages.force (destroyed_message, behavior_messages.count + 1)
				elseif attached {EXPLORER} me as e_me then
					if not e_me.landed then
						e_me.kill_by_asteroid (current.id)
						create destroyed_message.make_from_string (msg.left_margin + "destroyed " + e_me.out_sqr_bracket + " at " + sector.out_abstract_full_coordinate (e_me))
						behavior_messages.force (destroyed_message, behavior_messages.count + 1)
					end
				end
			end
			set_turns_left (rng.rchoose (0, 2))
		end

	kill_by_janitaur (killer_id: INTEGER)
		do
			kill_by ("JANITAUR")
			killers_id := killer_id
		ensure
			is_dead_by_janitaur
		end

feature -- out

	out_death_message: STRING
			-- result -> {Abstract State: Death Messages ASTEROID on pg 26-27}
		do
			create Result.make_empty
			if is_dead_by_blackhole then
				Result.append (msg.moveable_entity_death_by_blackhole (current, coordinate.row, coordinate.col, killers_id))
			elseif is_dead_by_janitaur then
				Result.append (msg.asteroid_death_by_janitaur (current, coordinate.row, coordinate.col, killers_id))
			end
		end

	out_description: STRING
			-- result -> "[id, character]->turns_left: N/A or turns_left"
		local
			turns_left_string: STRING
		do
			Result := Precursor
			if is_dead then
				create turns_left_string.make_from_string ("N/A")
			else
				turns_left_string := turns_left.out
			end
			Result.append ("turns_left:" + turns_left_string.out)
		end

end
