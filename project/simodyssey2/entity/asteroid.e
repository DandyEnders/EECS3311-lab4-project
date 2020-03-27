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
			out_description
		end

create
	make

feature {NONE} -- Initialization

	make (a_coordinate: COORDINATE; a_id, t_left: INTEGER)
			-- Initialization for `Current'.
		do
			precursor (a_coordinate, a_id, t_left)
			add_death_cause_type ("JANITAUR")
		end

feature -- Queries

	character: STRING = "A"

	is_dead_by_janitaur: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "JANITAUR"
		end

feature -- Commands

	behave (sector: SECTOR)
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

	kill_by_janitaur (k_id: INTEGER)
		do
			kill_by ("JANITAUR")
			killers_id := k_id
		ensure
			is_dead_by_janitaur
		end

feature -- out

	out_death_message: STRING -- {Abstract State: Death Message for pg 26-27 relevant to this entity}
		do
			create Result.make_empty
			if is_dead_by_blackhole then
				Result.append (msg.moveable_entity_death_blackhole (current, coordinate.row, coordinate.col, killers_id))
			elseif is_dead_by_janitaur then
				Result.append (msg.death_by_janitaur (current, coordinate.row, coordinate.col, killers_id))
			end
		end

	out_description: STRING -- "[id, character]->fuel:cur_fuel/max_fuel, life:cur_life/max_life, actions_left_until_reproduction: c_value / reproduction_interval, turns_left: N/A or turns_left"
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
