note
	description: "A class to represent a janitaur entity."
	author: "Jinho Hwang, Ato Koomson"
	date: "April 13, 2020"
	revision: "1"

class
	JANITAUR

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
			reproduceable_make (a_coordinate, a_id, t_left, 2, 'J')
			fuelable_make (5)
			add_death_cause_type ("OUT_OF_FUEL")
			add_death_cause_type ("ASTEROID")
			max_load := 2
			load := 0
		end

feature -- Attributes

	max_load: INTEGER
			-- maximum value of load

	load: INTEGER

feature -- Queries

	is_dead_by_out_of_fuel: BOOLEAN
			-- was killed by out of fuel?
		do
			Result := is_dead and then get_death_cause ~ "OUT_OF_FUEL"
		end

	is_dead_by_asteroid: BOOLEAN
			-- was killed by JANITAUR?
		do
			Result := is_dead and then get_death_cause ~ "ASTEROID"
		end

feature -- Commands

	increment_load_by_one
			-- increment load by one.
		require
			load /~ max_load
		do
			load := load + 1
		ensure
			load ~ (old load + 1)
		end

	clear_load (w: WORMHOLE)
			-- initialize load to 0.
		require
			wormhole_in_sector: w.coordinate ~ coordinate
		do
			load := 0
		ensure
			load = 0
		end

	check_health (sector: SECTOR)
			-- if sector.has_star ~ true recharge the janitaur's fuel cells
			-- execute kill_by_blackhole if sector.has_blachole ~ true.
			-- execute kill_by_out_of_fuel if "is_out_of_fuel" ~ true.
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
			-- perform behavior algorithm that pertains to JANITAUR as seen on pg 36
		local
			rng: RANDOM_GENERATOR_ACCESS
			destroyed_message: STRING
		do
			behavior_messages.make_empty
			across
				sector.moveable_entities_in_increasing_order is me
			loop
				if attached {ASTEROID} me as a_me and then load < max_load then
					a_me.kill_by_janitaur (current.id)
					increment_load_by_one
					create destroyed_message.make_from_string (msg.left_margin + "destroyed " + a_me.out_sqr_bracket + " at " + sector.out_abstract_full_coordinate (a_me))
					behavior_messages.force (destroyed_message, behavior_messages.count + 1)
				end
			end
			if sector.has_wormhole then
				check attached {WORMHOLE} sector.get_stationary_entity as w then
					clear_load (w)
				end
			end
			set_turns_left (rng.rchoose (0, 2))
		end

	kill_by_out_of_fuel
		require
			fuel = 0
		do
			kill_by ("OUT_OF_FUEL")
		ensure
			is_dead_by_out_of_fuel
		end

	kill_by_asteroid (killer_id: INTEGER)
		do
			kill_by ("ASTEROID")
			killers_id := killer_id
		ensure
			is_dead_by_asteroid
		end

	reproduce (moveable_id: INTEGER): like current
		local
			rng: RANDOM_GENERATOR_ACCESS
		do
			create Result.make (current.coordinate, moveable_id, rng.rchoose (0, 2))
			reset_actions_left_until_reproduction
		end

feature -- out

	out_death_message: STRING
			-- result -> {Abstract State: Death Messages JANITAUR on pg 26-27}
		do
			create Result.make_empty
			if is_dead_by_out_of_fuel then
				Result.append (msg.fuelable_moveable_entity_death_by_out_of_fuel (current, coordinate.row, coordinate.col))
			elseif is_dead_by_blackhole then
				Result.append (msg.moveable_entity_death_by_blackhole (current, coordinate.row, coordinate.col, killers_id))
			elseif is_dead_by_asteroid then
				Result.append (msg.moveable_entity_death_by_asteroid (current, coordinate.row, coordinate.col, killers_id))
			end
		end

	out_description: STRING
			-- result -> "[id, character]->fuel:cur_fuel/max_fuel, actions_left_until_reproduction: c_value / reproduction_interval, turns_left: N/A or turns_left"
		local
			turns_left_string: STRING
		do
			Result := Precursor
			if is_dead then
				create turns_left_string.make_from_string ("N/A")
			else
				turns_left_string := turns_left.out
			end
			Result.append ("fuel:" + fuel.out + "/" + max_fuel.out + ", " + "load:" + load.out + "/" + max_load.out + ", " + "actions_left_until_reproduction:" + actions_left_until_reproduction.out + "/" + reproduction_interval.out + ", " + "turns_left:" + turns_left_string.out)
		end

invariant
	0 <= load and load <= max_load

end
