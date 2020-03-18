note
	description: "Summary description for {MESSAGE}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	MESSAGE

feature -- Common message

	empty_string: STRING = ""

	left_margin: STRING = "  "

	left_big_margin: STRING = "    "

feature -- Validity

	ok: STRING = "ok"

	error: STRING = "error"

feature -- Mode

	play: STRING = "play"

	test: STRING = "test"

feature -- Initial message

	initial_message: STRING
		do
			create Result.make_from_string(left_margin)
			Result.append("Welcome! Try test(3,5,7,15,30)")
		end

feature -- status

	status_not_landed (row, col, quad, life, fuel: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
			Result.append ("Explorer status report:Travelling at cruise speed at ")
			Result.append ("[")
			Result.append (row.out)
			Result.append (",")
			Result.append (col.out)
			Result.append (",")
			Result.append (quad.out)
			Result.append ("]")
			Result.append ("%N")
			Result.append (left_margin)
			Result.append ("Life units left:")
			Result.append (life.out)
			Result.append (", Fuel units left:")
			Result.append (fuel.out)
		end

	status_landed (row, col, quad, life, fuel: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
			Result.append ("Explorer status report:Stationary on planet surface at ")
			Result.append ("[")
			Result.append (row.out)
			Result.append (",")
			Result.append (col.out)
			Result.append (",")
			Result.append (quad.out)
			Result.append ("]")
			Result.append ("%N")
			Result.append (left_margin)
			Result.append ("Life units left:")
			Result.append (life.out)
			Result.append (", Fuel units left:")
			Result.append (fuel.out)
		end

	status_error_no_mission: STRING
		do
			create Result.make_from_string(left_margin)
			Result.append("Negative on that request:no mission in progress.")
		end

feature -- land

	land_life_found: STRING
		do
			create Result.make_from_string(left_margin)
			Result.append ("Tranquility base here - we've got a life!")
		end

	land_life_not_found (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
			Result.append ("Explorer found no life as we know it at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	land_error_no_mission: STRING
		do
			create Result.make_from_string(left_margin)
			Result.append ("Negative on that request:no mission in progress.")
		end

	land_error_landed_already (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
			Result.append ("Negative on that request:already landed on a planet at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	land_error_no_yellow_dwarf (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
			Result.append ("Negative on that request:no yellow dwarf at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	land_error_no_planets (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
			Result.append ("Negative on that request:no planets at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	land_error_no_visited_planets (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
			Result.append ("Negative on that request:no unvisited attached planet at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

feature -- liftoff

	liftoff (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
			Result.append ("Explorer has lifted off from planet at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	liftoff_error_no_mission: STRING
		do
			create Result.make_from_string(left_margin)
			Result.append ("Negative on that request:no mission in progress.")
		end

	liftoff_error_not_on_planet (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
			Result.append ("Negative on that request:you are not on a planet at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

feature -- abort

	abort: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append("Mission aborted. Try test(30)")
		end

	abort_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append("Negative on that request:no mission in progress.")
		end


feature -- game_is_over

	game_is_over: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append("The game has ended. You can start a new game.")
		end

feature -- explorer

	explorer_death_out_of_fuel (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
			Result.append ("Explorer got lost in space - out of fuel at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	explorer_death_blackhole (row, col, blackhole_id: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
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

	move_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append("Negative on that request:no mission in progress.")
		end

	move_error_landed (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
			Result.append ("Negative on that request:you are currently landed at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	move_error_sector_full: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append("Cannot transfer to new location as it is full.")
		end

feature -- pass

	pass_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append("Negative on that request:no mission in progress.")
		end

feature -- play

	play_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append("To start a new mission, please abort the current one first.")
		end

feature -- test

	test_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append("To start a new mission, please abort the current one first.")
		end

	test_error_threshold: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append("Thresholds should be non-decreasing order.")
		end


feature -- wormhole

	wormhole_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append("To start a new mission, please abort the current one first.")
		end

	wormhole_error_landed (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
			Result.append ("Negative on that request:you are currently landed at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

	wormhole_error_explorer_not_found_wormhole (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
			Result.append ("Explorer couldn't find wormhole at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

end