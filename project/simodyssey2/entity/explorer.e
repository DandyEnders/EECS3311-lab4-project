note
	description: "A class to represent the explorer entity."
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER

inherit

	MOVEABLE_ENTITY
		rename
			make as moveable_make
		redefine
			check_health,
			out_description
		end

	FUELABLE
		rename
			make as fuelable_make
		undefine
			out,
			is_equal
		end

create
	make

feature {NONE} -- Constructor

	make (a_coordinate: COORDINATE; a_id: INTEGER)
		do
			moveable_make (a_coordinate, a_id, 3, 'E')
			fuelable_make (3)
			landed := false
			found_life := FALSE
			add_death_cause_type ("OUT_OF_FUEL")
			add_death_cause_type ("MALEVOLENT")
			add_death_cause_type ("ASTEROID")
		end

feature -- Attributes

	landed: BOOLEAN
			-- is landed on a PLANET?

	found_life: BOOLEAN
			-- has found life on a PLANET?

feature -- Queries

	is_dead_by_out_of_fuel: BOOLEAN
			-- was killed by out of fuel.
		do
			Result := is_dead and then get_death_cause ~ "OUT_OF_FUEL"
		end

	is_dead_by_malevolent: BOOLEAN
			-- was killed by MALEVOLENT?
		do
			Result := is_dead and then get_death_cause ~ "MALEVOLENT"
		end

	is_dead_by_asteroid: BOOLEAN
			-- was killed by ASTEROID?
		do
			Result := is_dead and then get_death_cause ~ "ASTEROID"
		end

feature {NONE} -- Commands

	set_landed (b: BOOLEAN)
		do
			landed := b
		ensure
			landed = b
		end

	set_found_life_true
		require
			landed
		do
			found_life := TRUE
		ensure
			found_life = TRUE
		end

feature -- Commands

	kill_by_malevolent (killer_id: INTEGER)
		do
			kill_by ("MALEVOLENT")
			killers_id := killer_id
		ensure
			is_dead_by_malevolent
		end

	kill_by_asteroid (killer_id: INTEGER)
		do
			kill_by ("ASTEROID")
			killers_id := killer_id
		ensure
			is_dead_by_asteroid
		end

	kill_by_out_of_fuel
		require
			is_out_of_fuel
		do
			kill_by ("OUT_OF_FUEL")
		ensure
			is_dead_by_out_of_fuel
		end

	check_health (sector: SECTOR)
			-- if sector.has_star ~ true recharge the explorer's fuel cells
			-- if "is_out_of_fuel" execute "kill_by_out_of_fuel".
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

	land_on (a_p: PLANET)
			-- land and visit a_p.
		require
			a_p.is_landable and not a_p.visited
		do
			set_landed (TRUE)
			a_p.set_visited
			if a_p.support_life then
				set_found_life_true
			end
		ensure
			a_p.visited and landed and (a_p.support_life implies found_life)
		end

	liftoff
			-- liftoff the planet explorer is currently landed on.
		require
			landed
		do
			set_landed (FALSE)
		ensure
			not landed
		end

feature -- Out

	out_status (quadrant: INTEGER): STRING
			-- result -> {Abstract State: Command-Specific Messages STATUS on pg 26}
		do
			create Result.make_empty
			if landed then
				Result.append (msg.status_landed (coordinate.row, coordinate.col, quadrant, life.point, fuel))
			else
				Result.append (msg.status_not_landed (coordinate.row, coordinate.col, quadrant, life.point, fuel))
			end
		end

	out_death_message: STRING
			-- result -> {Abstract State: Death Messages EXPLORER on pg 26-27 }
		do
			create Result.make_empty
			if is_dead_by_out_of_fuel then
				Result.append (msg.fuelable_moveable_entity_death_by_out_of_fuel (current, coordinate.row, coordinate.col))
			elseif is_dead_by_blackhole then
				Result.append (msg.moveable_entity_death_by_blackhole (current, coordinate.row, coordinate.col, killers_id))
			elseif is_dead_by_asteroid then
				Result.append (msg.moveable_entity_death_by_asteroid (current, coordinate.row, coordinate.col, killers_id))
			elseif is_dead_by_malevolent then
				Result.append (msg.explorer_death_by_malevolent (current, coordinate.row, coordinate.col))
			end
		end

	out_description: STRING
			-- result -> "[id, character]->fuel:cur_fuel/max_fuel, life:cur_life/max_life, landed?:boolean". ie. "[0,E]->fuel:2/3, life:3/3, landed?:F"
		do
			Result := precursor
			Result.append ("fuel:")
			Result.append (fuel.out)
			Result.append ("/")
			Result.append ("3")
			Result.append (", ")
			Result.append (life.out)
			Result.append (", ")
			Result.append ("landed?:")
			if landed then
				Result.append ("T")
			else
				Result.append ("F")
			end
		end

end
