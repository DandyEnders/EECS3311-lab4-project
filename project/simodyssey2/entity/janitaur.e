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
			make,
			out_death_description,
			out_description
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

	is_dead_by_asteroid: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "ASTEROID"
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
				check attached {BLACKHOLE} sector.get_stationary_entity as b_e then
					kill_by_blackhole (b_e.id)
				end
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
				sector.moveable_entities_in_increasing_order is me
			loop
				if attached {ASTEROID} me as a_me and then load < max_load then
					a_me.kill_by_janitaur(current.id)
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

	kill_by_blackhole(k_id:INTEGER)
		do
			turns_left := -1
			kill_by ("BLACKHOLE")
			killers_id:=k_id
		end
	kill_by_out_of_fuel
		require
			fuel = 0
		do
			turns_left := -1
			kill_by ("OUT_OF_FUEL")
		ensure
			is_dead_by_out_of_fuel
		end

	kill_by_asteroid (k_id:INTEGER)
		do
			turns_left := -1
			kill_by ("ASTEROID")
			killers_id:=k_id
		ensure
			is_dead_by_asteroid
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

feature -- out
	out_death_description:STRING --Looks good but temporary version for now
		do
			Result:=precursor
			if is_dead_by_out_of_fuel then
				Result.append (msg.death_by_out_of_fuel (current,coordinate.row, coordinate.col))
			elseif is_dead_by_blackhole then
				Result.append (msg.moveable_entity_death_blackhole (current,coordinate.row, coordinate.col, killers_id))
			elseif is_dead_by_asteroid then
				Result.append (msg.death_by_asteroid (current,coordinate.row, coordinate.col, killers_id))
			end
		end

	out_description:STRING
		local
			turns_left_string: STRING
		do
			Result:=Precursor
			if turns_left < 0 then
				create turns_left_string.make_from_string ("N/A")
			else
				turns_left_string:=turns_left.out
			end
			Result.append ("fuel:" + fuel.out + "/" + max_fuel.out + ", " + "load:" + load.out + "/" + max_load.out + ", " + "actions_left_until_reproduction:" + actions_left_until_reproduction.out + "/" + reproduction_interval.out + ", " + "turns_left:" + turns_left_string.out)
		end

invariant
	is_alive implies (0 <= load and load <= max_load)
end
