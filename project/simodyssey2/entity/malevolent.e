note
	description: "Summary description for {MALEVOLENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MALEVOLENT

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
			-- Initialization for `Current'.
		do
			reproduceable_make (a_coordinate, a_id, t_left, 1,'M')
			fuelable_make (3)
			add_death_cause_type ("OUT_OF_FUEL")
			add_death_cause_type ("ASTEROID")
			add_death_cause_type ("BENIGN")
		end

feature -- Queries

	is_dead_by_out_of_fuel: BOOLEAN
			-- result ~ true if current was killed by executing "kill_by_out_of_fuel".
		do
			Result := is_dead and then get_death_cause ~ "OUT_OF_FUEL"
		end

	is_dead_by_asteroid: BOOLEAN
			-- result ~ true if current was killed by executing "kill_by_asteroid".
		do
			Result := is_dead and then get_death_cause ~ "ASTEROID"
		end

	is_dead_by_benign: BOOLEAN
			-- result ~ true if current was killed by executing "kill_by_benign".
		do
			Result := is_dead and then get_death_cause ~ "BENIGN"
		end

feature -- Commands

	check_health (sector: SECTOR)
			-- if sector.has_star ~ true recharge the current's fuel cells
			-- execute "kill_by_blackhole" if sector.has_blachole ~ true.
			-- execute "kill_by_out_of_fuel" if "is_out_of_fuel" ~ true.
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
			-- allow current to interact with ENTITY's in its SECTOR.
			-- perform behavior algorithm that pertains to MALEVOLENT as seen on pg 36
		local
			rng: RANDOM_GENERATOR_ACCESS
			benign_at_sector: BOOLEAN
			attacked_message: STRING
		do
			behavior_messages.make_empty
			benign_at_sector := (across sector.moveable_entities_in_increasing_order is me some attached {BENIGN} me end)
			if not benign_at_sector then --if there does not exists a benign at the sector
				across
					sector.moveable_entities_in_increasing_order is me
				loop
					if attached {EXPLORER} me as e_me then -- if there is an explorer and he is not landed then proceed
						if not e_me.landed then
							if e_me.life.point ~ 1 then -- if there is an explorer and he is almost dead
								e_me.kill_by_malevolent(id)
							else
								e_me.life.subtract_life (1)
							end
							create attacked_message.make_from_string (msg.left_margin + "attacked " + e_me.out_sqr_bracket + " at " + sector.out_abstract_full_coordinate (e_me))
							behavior_messages.force (attacked_message, behavior_messages.count + 1)
						end
					end
				end
			end
			set_turns_left (rng.rchoose (0, 2))
		end

	kill_by_out_of_fuel
			-- given fuel ~ 0, kill current by out of fuel
		require
			fuel = 0
		do
			kill_by ("OUT_OF_FUEL")
		ensure
			is_dead_by_out_of_fuel
		end

	kill_by_asteroid (killer_id: INTEGER)
			-- given the id a ASTEROID, kill current by ASTEROID
		do
			kill_by ("ASTEROID")
			killers_id := killer_id
		ensure
			is_dead_by_asteroid
		end

	kill_by_benign (killer_id: INTEGER)
			-- given the id a BENIGN, kill current by BENGIN
		do
			kill_by ("BENIGN")
			killers_id := killer_id
		ensure
			is_dead_by_benign
		end

feature {NONE} -- Implementation

	cloner (a_id, t_left: INTEGER): like current
		local
			m: like current
		do
			create m.make (current.coordinate.deep_twin, a_id, t_left)
			Result := m
		end

feature -- out

	out_death_message: STRING
			-- result ~ {Abstract State: Death Messages MALEVOLENT on pg 26-27}
		do
			create Result.make_empty
			if is_dead_by_out_of_fuel then
				Result.append (msg.fuelable_moveable_entity_death_by_out_of_fuel (current, coordinate.row, coordinate.col))
			elseif is_dead_by_blackhole then
				Result.append (msg.moveable_entity_death_by_blackhole (current, coordinate.row, coordinate.col, killers_id))
			elseif is_dead_by_asteroid then
				Result.append (msg.moveable_entity_death_by_asteroid (current, coordinate.row, coordinate.col, killers_id))
			elseif is_dead_by_benign then
				Result.append (msg.malevolent_death_by_benign (current, coordinate.row, coordinate.col, killers_id))
			end
		end

	out_description: STRING
			-- result ~ "[id, character]->fuel:cur_fuel/max_fuel, actions_left_until_reproduction: c_value / reproduction_interval, turns_left: N/A or turns_left"
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
