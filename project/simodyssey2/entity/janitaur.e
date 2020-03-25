note
	description: "Summary description for {JANITAUR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JANITAUR

inherit

	NP_MOVEABLE_ENTITY
		redefine
			make
		end

	FUELABLE
		rename
			make as fuelable_make
		undefine
			out,
			is_equal
		end

	REPRODUCEABLE
		rename
			make as reproduceable_make
		undefine
			out,
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_coordinate: COORDINATE; a_id: INTEGER)
			-- Initialization for `Current'.
		do
			precursor (a_coordinate, a_id)
			deathable_make (1)
			fuelable_make (5)
			reproduceable_make (2)
			add_death_cause_type ("BLACKHOLE")
			add_death_cause_type ("OUT_OF_FUEL")
			add_death_cause_type ("ASTROID")
			max_load := 2
			load := 0
		end

feature -- Command

feature -- Attributes

	max_load: INTEGER

	load: INTEGER

feature -- Queries

	character: STRING = "J"

	is_dead_by_blackhole: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "BLACKHOLE"
		end

	is_dead_by_out_of_fuel: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "OUT_OF_FUEL"
		end

	is_dead_by_astroid: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "ASTROID"
		end

feature {NONE} --Commands

	confirm_health (sector: SECTOR)
		do
				-- check if explorer dies out of fuel
			if is_out_of_fuel then
					-- if the explorer ran out of fuel, he should lose his life and be removed from the galaxy
				kill_by_out_of_fuel
					-- check if explorer dies out of blackhole
			elseif sector.has_blackhole then
				kill_by_blackhole
			end
		end

feature -- Commands

	increment_load_by_one
		require
			load /~ max_load
		do
			load := load + 1
		ensure
			0 <= load and load <= max_load
		end

	clear_load (w: WORMHOLE)
		require
			w.coordinate ~ coordinate
		do
			load := 0
		ensure
			load = 0
		end

	check_health (sector: SECTOR)
		do
			if sector.has_stationary_entity then
					-- if the explorer's new sector has a star, then recharge.
				if attached {STAR} sector.get_stationary_entity as i_star then
					charge_fuel (i_star)
				end
			end
			confirm_health (sector)
		end

	behave (sector: SECTOR)
		local
			rng: RANDOM_GENERATOR_ACCESS
		do
			across
				sector.ordered_moveable_entities is me
			loop
				if attached {ASTROID} me as a_me and then load < max_load then
					a_me.kill_by_janitaur
					increment_load_by_one
				end
			end
			if sector.has_wormhole then
				check attached {WORMHOLE} sector.get_stationary_entity as w then
					clear_load (w)
				end
			end
			set_turns_left (rng.rchoose (0, 2))
		end

	kill_by_blackhole
		do
			kill_by ("BLACKHOLE")
		end

	kill_by_out_of_fuel
		require
			fuel = 0
		do
			kill_by ("OUT_OF_FUEL")
		end

	kill_by_astroid
		do
			kill_by ("ASTROID")
		end

	reproduce (sector: SECTOR; moveable_id: INTEGER)
		local
			n_me: NP_MOVEABLE_ENTITY
			rng: RANDOM_GENERATOR_ACCESS
		do
			create {like current} n_me.make (sector.coordinate, moveable_id)
			sector.add (n_me)
			n_me.set_turns_left (rng.rchoose (0, 2))
			actions_left_until_reproduction := reproduction_interval
		end

end
