note
	description: "Summary description for {MESSAGE}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	MESSAGE

feature -- Initial message

	initial_message: STRING = "Welcome! Try test(30)"

feature -- status

	status_not_landed (row, col, quad, life, fuel: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("  ")
			Result.append ("Explorer status report:Travelling at cruise speed at ")
			Result.append ("[")
			Result.append (row.out)
			Result.append (",")
			Result.append (col.out)
			Result.append (",")
			Result.append (quad.out)
			Result.append ("]")
			Result.append ("%N")
			Result.append ("  ")
			Result.append ("Life units left:")
			Result.append (life.out)
			Result.append (", Fuel units left:")
			Result.append (fuel.out)
		end

	status_landed (row, col, quad, life, fuel: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("  ")
			Result.append ("Explorer status report:Stationary on planet surface at ")
			Result.append ("[")
			Result.append (row.out)
			Result.append (",")
			Result.append (col.out)
			Result.append (",")
			Result.append (quad.out)
			Result.append ("]")
			Result.append ("%N")
			Result.append ("  ")
			Result.append ("Life units left:")
			Result.append (life.out)
			Result.append (", Fuel units left:")
			Result.append (fuel.out)
		end

	status_error_no_mission: STRING = "Negative on that request:no mission in progress."

feature -- land

	land_life_found: STRING = "Tranquility base here - weve got a life!"

	land_life_not_found (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("Explorer found no life as we know it at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	land_error_no_mission: STRING = "Negative on that request:no mission in progress."

	land_error_landed_already (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("Negative on that request:already landed on a planet at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	land_error_no_yellow_dwarf (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("Negative on that request:no yellow dwarf at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	land_error_no_planets (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("Negative on that request:no planets at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	land_error_no_visited_planets (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("Negative on that request:no unvisited attached planet at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

feature -- liftoff

	liftoff (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("Explorer has lifted off from planet at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	liftoff_error_no_mission: STRING = "Negative on that request:no mission in progress."

	liftoff_error_not_on_planet (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("Negative on that request:you are not on a planet at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

feature -- abort

	abort: STRING = "Mission aborted. Try test(30)"

	abort_error_no_mission: STRING = "Negative on that request:no mission in progress."

feature -- game_is_over

	game_is_over: STRING = "The game has ended. You can start a new game."

feature -- explorer

	explorer_death_out_of_fuel (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("Explorer got lost in space - out of fuel at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	explorer_death_blackhole (row, col, blackhole_id: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("Explorer got devoured by blackhole ")
			Result.append ("(id: ")
			Result.append (blackhole_id.out)
			Result.append (") at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

feature -- planet

	planet_death_blackhole (row, col, blackhole_id: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("Planet got devoured by blackhole ")
			Result.append ("(id: ")
			Result.append (blackhole_id.out)
			Result.append (") at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

feature -- move

	move_error_no_mission: STRING = "Negative on that request:no mission in progress."

	move_error_landed (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("Negative on that request:you are currently landed at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	move_error_sector_full: STRING = "Cannot transfer to new location as it is full."

feature -- pass

	pass_error_no_mission: STRING = "Negative on that request:no mission in progress."

feature -- play

	play_error_no_mission: STRING = "To start a new mission, please abort the current one first."

feature -- test

	test_error_no_mission: STRING = "To start a new mission, please abort the current one first."

feature -- wormhole

	wormhole_error_no_mission: STRING = "To start a new mission, please abort the current one first."

	wormhole_error_landed (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("Negative on that request:you are currently landed at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	wormhole_error_explorer_not_found_wormhole (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append ("Explorer couldn't find wormhole at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

end
