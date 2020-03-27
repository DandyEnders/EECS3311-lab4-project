note
	description: "Summary description for {EXPLORER}."
	author: "Jinho Hwang"
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
			moveable_make (a_coordinate, a_id, 3)
			fuelable_make (3)
			landed := false
			found_life := FALSE
			add_death_cause_type ("OUT_OF_FUEL")
			add_death_cause_type ("MALEVOLENT")
			add_death_cause_type ("ASTEROID")
		end

feature -- Attributes

	landed: BOOLEAN

	found_life: BOOLEAN

feature -- Queries

	character: STRING = "E"

	is_dead_by_out_of_fuel: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "OUT_OF_FUEL"
		end

	is_dead_by_malevolent: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "MALEVOLENT"
		end

	is_dead_by_asteroid: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "ASTEROID"
		end

feature {UNIT_TEST} -- testing Commands Delete after finalized

feature -- Commands

	set_landed (b: BOOLEAN)
		do
			landed := b
		end

	set_found_life_true
		require
			landed
		do
			found_life := TRUE
		end

	kill_by_malevolent
		do
			kill_by ("MALEVOLENT")
		end

	kill_by_asteroid (k_id: INTEGER)
		do
			kill_by ("ASTEROID")
			killers_id := k_id
		ensure
			is_dead_by_asteroid
		end

	kill_by_out_of_fuel
		require
			fuel = 0
		do
			kill_by ("OUT_OF_FUEL")
		ensure
			is_dead_by_out_of_fuel
		end

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

	land_on (a_p: PLANET)
		require
			a_p.attached_to_star and not a_p.visited
		do
			a_p.set_visited
			set_landed (TRUE)
			if a_p.support_life then
				set_found_life_true
			end
		ensure
			a_p.visited
			and landed
			and (a_p.support_life implies found_life)
		end

feature -- Out

	out_status (quadrant: INTEGER): STRING -- {Abstract State: Command-Specific Messages on pg 26}
		do
			create Result.make_empty
			if landed then
				Result.append (msg.status_landed (coordinate.row, coordinate.col, quadrant, life.value, fuel))
			else
				Result.append (msg.status_not_landed (coordinate.row, coordinate.col, quadrant, life.value, fuel))
			end
		end

	out_death_message: STRING -- {Abstract State: Death Message for pg 26-27 relevant to this entity}
		do
			create Result.make_empty
			if is_dead_by_out_of_fuel then
				Result.append (msg.death_by_out_of_fuel (current, coordinate.row, coordinate.col))
			elseif is_dead_by_blackhole then
				Result.append (msg.death_by_blackhole (current, coordinate.row, coordinate.col, killers_id))
			elseif is_dead_by_asteroid then
				Result.append (msg.death_by_asteroid (current, coordinate.row, coordinate.col, killers_id))
			elseif is_dead_by_malevolent then
				Result.append (msg.death_by_malevolent (current, coordinate.row, coordinate.col))
			end
		end

	out_description: STRING -- "[id, character]->fuel:cur_fuel/max_fuel, life:cur_life/max_life, landed?:boolean"
			-- "[0,E]->fuel:2/3, life:3/3, landed?:F"
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
