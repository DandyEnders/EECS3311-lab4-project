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
		end

create
	make

feature {NONE} -- Constructor

	make (a_coordinate: COORDINATE; a_id: INTEGER)
		do
			moveable_make (a_coordinate, a_id)
			life := 3
			fuel := 3
			landed := false
			found_life := FALSE
		end

feature -- Attributes

	life: INTEGER -- TODO: might make it a class

	fuel: INTEGER -- TODO: might make it a class

	landed: BOOLEAN

	found_life: BOOLEAN

feature -- Queries

	death_message: STRING = "SET THIS TO DEATH MESSAGE"

	character: STRING = "E"

feature -- Commands

	spend_fuel_unit
			-- calling this will cause fuel to decrease by 1
		do
			fuel := fuel - 1
		end

	set_found_life
		require
			landed
		do
			found_life := TRUE
		end

	charge_fuel (s: STAR)
			--given a star, can recharge fuel.
		do
			if (fuel + s.luminosity) > fuel then
				fuel := 3
			else
				fuel := (fuel + s.luminosity)
			end
		end

	lose_life
		do
			life := 0
		end

end
