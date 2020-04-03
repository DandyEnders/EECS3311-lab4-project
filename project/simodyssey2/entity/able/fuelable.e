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
			-- current fuel value

	max_fuel: INTEGER
			-- maxiumum value of "fuel"

feature -- Commands

	spend_fuel_unit
			-- decrement "fuel" by one
		require
			fuel > 0
			-- calling this will cause fuel to decrease by 1
		do
			fuel := fuel - 1
		ensure
			fuel ~ (old fuel - 1)
		end

	charge_fuel (s: STAR)
			--given STAR, increment fuel by {STAR}.luminosity, up to max_fuel
		require
			s.luminosity >= 0
		do
			if (fuel + s.luminosity) >= max_fuel then
				fuel := max_fuel
			else
				fuel := (fuel + s.luminosity)
			end
		ensure
			max_fuel_does_not_change: max_fuel ~ old max_fuel
			never_charge_above_max_fuel:(((old fuel + s.luminosity) >= max_fuel) implies (fuel ~ max_fuel)) and (((old fuel + s.luminosity) < max_fuel) implies (fuel ~ (old fuel +s.luminosity)))
		end

feature -- Queries

	is_out_of_fuel: BOOLEAN
		do
			Result := fuel ~ 0
		ensure
			Result = (fuel ~ 0)
		end

invariant
	0 <= fuel and fuel <= max_fuel

end
