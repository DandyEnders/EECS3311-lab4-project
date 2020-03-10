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
			make as moveable_make,
			out_description as id_entity_out_description
		end

create
	make

feature {NONE} -- Constructor

	make (a_coordinate: COORDINATE; a_id: INTEGER)
		do
			moveable_make (a_coordinate, a_id)
			killable_make (3)
			fuel := 3
			landed := false
			found_life := FALSE

			add_death_cause_type("BLACKHOLE")
			add_death_cause_type("OUT_OF_FUEL")
		end

feature -- Attributes

	fuel: INTEGER -- TODO: might make it a class

	landed: BOOLEAN

	found_life: BOOLEAN

feature -- Queries

	character: STRING = "E"

	is_out_of_fuel: BOOLEAN
		do
			Result := fuel = 0
		end

	is_dead_by_out_of_fuel: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "OUT_OF_FUEL"
		end

	is_dead_by_blackhole: BOOLEAN
		do
			Result := is_dead and then get_death_cause ~ "BLACKHOLE"
		end

feature -- Commands

	spend_fuel_unit
			-- calling this will cause fuel to decrease by 1
		do
			fuel := fuel - 1
		end

	set_found_life_true 
		require
			landed
		do
			found_life := TRUE
		end

	charge_fuel (s: STAR)
			--given a star, can recharge fuel.
		do
			if (fuel + s.luminosity) > 3 then
				fuel := 3
			else
				fuel := (fuel + s.luminosity)
			end
		end

	kill_by_blackhole
		do
			kill_by("BLACKHOLE")
		end

	kill_by_out_of_fuel
		require
			fuel = 0
		do
			kill_by("OUT_OF_FUEL")
		end



feature -- Out

	out_description:STRING -- "[id, character]->fuel:cur_fuel/max_fuel, life:cur_life/max_life, landed?:boolean"
		-- "[0,E]->fuel:2/3, life:3/3, landed?:F"
		do
			Result := id_entity_out_description

			Result.append("fuel:")
			Result.append(fuel.out)
			Result.append("/")
			Result.append("3")
			Result.append(", ")

			Result.append("life:")
			Result.append(life.out)
			Result.append("/")
			Result.append("3")
			Result.append(", ")

			Result.append("landed?:")
			Result.append(landed.out)
		end

end
