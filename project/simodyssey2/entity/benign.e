note
	description: "Summary description for {BENIGN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BENIGN

inherit

	FUELABLE
		rename
			make as fuelable_make
		undefine
			out,
			is_equal
		end

	REPRODUCEABLE_ENTITY
		rename
			make as reproduceable_make
		redefine
			check_health,
			out_description
		end

create
	make

feature {NONE} -- Initialization

	make (a_coordinate: COORDINATE; a_id, t_left: INTEGER)
		do
			reproduceable_make (a_coordinate, a_id, t_left, 1)
			fuelable_make (3)
			add_death_cause_type ("OUT_OF_FUEL")
			add_death_cause_type ("ASTEROID")
		end

feature -- Command

	check_health (sector: SECTOR)
		local
			are_you_killed_yet: BOOLEAN
		do
			are_you_killed_yet := FALSE
			if sector.has_stationary_entity then
					-- if the explorer's new sector has a star, then recharge.
				if attached {STAR} sector.get_stationary_entity as i_star then
					charge_fuel (i_star)
				end
			end
			if is_out_of_fuel then
					-- if the explorer ran out of fuel, he should lose his life and be removed from the galaxy
				kill_by_out_of_fuel
					-- check if explorer dies out of blackhole
				are_you_killed_yet := TRUE
			end
			if not are_you_killed_yet then
				precursor (sector)
			end
		end

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
					m_me.kill_by_benign (current.id)
					create destroyed_message.make_from_string (msg.left_margin + "destroyed " + m_me.out_sqr_bracket + " at " + sector.out_abstract_full_coordinate (m_me))
					behavior_messages.force (destroyed_message, behavior_messages.count + 1)
				end
			end
			set_turns_left (rng.rchoose (0, 2))
		end

feature -- Queries

	character: STRING = "B"

	is_dead_by_out_of_fuel: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "OUT_OF_FUEL"
		end

	is_dead_by_asteroid: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "ASTEROID"
		end

feature -- Commands

	kill_by_out_of_fuel
		require
			fuel = 0
		do
			kill_by ("OUT_OF_FUEL")
		ensure
			is_dead_by_out_of_fuel
		end

	kill_by_asteroid (k_id: INTEGER)
		do
			kill_by ("ASTEROID")
			killers_id := k_id
		ensure
			is_dead_by_asteroid
		end

feature {NONE} -- Implementation

	cloner (a_id, t_left: INTEGER): like current
		local
			m: like current
		do
			create m.make (current.coordinate.deep_twin, a_id, t_left)
			Result := m
		end

feature -- Output

	out_death_message: STRING -- {Abstract State: Death Message for pg 26-27 relevant to this entity}
		do
			create Result.make_empty
			if is_dead_by_out_of_fuel then
				Result.append (msg.death_by_out_of_fuel (current, coordinate.row, coordinate.col))
			elseif is_dead_by_blackhole then
				Result.append (msg.death_by_blackhole (current, coordinate.row, coordinate.col, killers_id))
			elseif is_dead_by_asteroid then
				Result.append (msg.death_by_asteroid (current, coordinate.row, coordinate.col, killers_id))
			end
		end

	out_description: STRING -- "[id, character]->fuel:cur_fuel/max_fuel, life:cur_life/max_life, actions_left_until_reproduction: c_value / reproduction_interval, turns_left: N/A or turns_left"
		local
			turns_left_string: STRING
		do
			Result := precursor
			if is_dead then
				create turns_left_string.make_from_string ("N/A")
			else
				turns_left_string := turns_left.out
			end
			Result.append ("fuel:" + fuel.out + "/" + max_fuel.out + ", " + "actions_left_until_reproduction:" + actions_left_until_reproduction.out + "/" + reproduction_interval.out + ", " + "turns_left:" + turns_left_string.out)
		end

end
