note
	description: "Summary description for {FUELABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FUELABLE

create
	make

feature {NONE} -- Initialization

	make (max: INTEGER)
			-- Initialization for `Current'.
		do
			max_fuel := max
			fuel := max_fuel
		end

feature -- Attributes

	fuel: INTEGER

	max_fuel: INTEGER

feature -- Commands

	spend_fuel_unit
		require
			fuel > 0
			-- calling this will cause fuel to decrease by 1
		do
			fuel := fuel - 1
		end

	charge_fuel (s: STAR)
			--given a star, can recharge fuel.
		require
			s.luminosity >= 0
		do
			if (fuel + s.luminosity) >= max_fuel then
				fuel := max_fuel
			else
				fuel := (fuel + s.luminosity)
			end
		end

feature -- Queries

	is_out_of_fuel: BOOLEAN
		do
			Result := fuel ~ 0
		end

invariant
	0 <= fuel and fuel <= max_fuel

end