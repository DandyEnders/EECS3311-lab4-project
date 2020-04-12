note
	description: "A class for generating Abstract State messages."
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	MESSAGE

feature -- Format related messages

	empty_string: STRING = ""

	left_margin: STRING = "  "

	left_big_margin: STRING = "    "

feature -- First line: Validity

	ok: STRING = "ok"

	error: STRING = "error"

feature -- First line: Mode

	play: STRING = "play"

	test: STRING = "test"

feature -- Abstract State: Command-Specific Messages INITIAL MESSAGE

	initial_message: STRING
			-- result ~ "  Welcome! Try test(3,5,7,15,30)"
		do
			create Result.make_from_string (left_margin)
			Result.append ("Welcome! Try test(3,5,7,15,30)")
		end

feature -- Abstract State: Command-Specific Messages STATUS

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

feature -- Abstract State: Error Messages STATUS

	status_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append ("Negative on that request:no mission in progress.")
		end

feature -- Abstract State: Command-Specific Messages LAND

	land_life_found: STRING
		do
			create Result.make_from_string (left_margin)
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

feature -- Abstract State: Error Messages LAND

	land_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
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

feature -- Abstract State: Command-Specific Messages LIFTOFF

	liftoff (row, col: INTEGER): STRING
		do
			create Result.make_empty
			Result.append (left_margin)
			Result.append ("Explorer has lifted off from planet at Sector:")
			Result.append (row.out)
			Result.append (":")
			Result.append (col.out)
		end

feature -- Abstract State: Error Messages LIFTOFF

	liftoff_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
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

feature -- Abstract State: Command-Specific Messages ABORT

	abort: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append ("Mission aborted. Try test(3,5,7,15,30)")
		end

feature -- Abstract State: Error Messages ABORT

	abort_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append ("Negative on that request:no mission in progress.")
		end

feature -- Abstract State: Command-Specific Messages GAME IS OVER

	game_is_over: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append ("The game has ended. You can start a new game.")
		end

feature {NONE} -- Helper Query

	moveable_entity_type (np: MOVEABLE_ENTITY): STRING
			-- result ~ "  Benign "
		do
			create Result.make_empty
			Result.append (left_margin)
			if attached {BENIGN} np then
				Result.append ("Benign ")
			elseif attached {MALEVOLENT} np then
				Result.append ("Malevolent ")
			elseif attached {JANITAUR} np then
				Result.append ("Janitaur ")
			elseif attached {ASTEROID} np then
				Result.append ("Asteroid ")
			elseif attached {PLANET} np then
				Result.append ("Planet ")
			elseif attached {EXPLORER} np then
				Result.append ("Explorer ")
			end
		end

feature -- Abstract State: Death Messages (Death due to blackhole.)

	moveable_entity_death_by_blackhole (np: MOVEABLE_ENTITY; sector_row, sector_col, blackhole_id: INTEGER): STRING
			-- result ~ "  {MOVEABLE_ENTITY} got devoured by blackhole (id: -1) at Sector:row:col"
		require
			np.is_dead_by_blackhole
			blackhole_id ~ -1
			valid_sector_of_death: sector_row ~ 3 and sector_col ~ 3
		do
			create Result.make_empty
			Result.append (moveable_entity_type (np))
			Result.append ("got devoured by blackhole " + "(id: " + blackhole_id.out + ") ")
			Result.append ("at Sector:" + sector_row.out + ":" + sector_col.out)
		end

feature -- Abstract State: Death Messages (Death due to janitaur.)

	asteroid_death_by_janitaur (a: ASTEROID; sector_row, sector_col, janitaur_id: INTEGER): STRING
			-- result ~ "  Asteroid got imploded by janitaur (id: id) at Sector:row:col"
		require
			a.is_dead_by_janitaur
			valid_sector_of_death: a.coordinate.row ~ sector_row and a.coordinate.col ~ sector_col
		do
			create Result.make_empty
			Result.append (moveable_entity_type (a))
			Result.append ("got imploded by janitaur " + "(id: " + janitaur_id.out + ") " )
			Result.append ("at Sector:" + sector_row.out + ":" + sector_col.out)
		end

feature -- Abstract State: Death Messages (Death due to asteroid.)

	moveable_entity_death_by_asteroid (me: MOVEABLE_ENTITY; sector_row, sector_col, asteroid_id: INTEGER): STRING
			-- result ~ "  {MOVEABLE_ENTITY} got destroyed by asteroid (id: id) at Sector:row:col"
		require
			me_is_not_a_planet: not attached {PLANET} me
			me_is_not_an_asteroid: not attached {ASTEROID} me
			me.is_dead
			valid_sector_of_death: me.coordinate.row ~ sector_row and me.coordinate.col ~ sector_col
		do
			create Result.make_empty
			Result.append (moveable_entity_type (me))
			Result.append ("got destroyed by asteroid (id: " + asteroid_id.out + ") ")
			Result.append ("at Sector:" + sector_row.out + ":" + sector_col.out)
		end

feature -- Abstract State: Death Messages (Death due to benign.)

	malevolent_death_by_benign (m: MALEVOLENT; sector_row, sector_col, benign_id: INTEGER): STRING
			-- result ~ "  Malevolent got destroyed by benign (id: id) at Sector:row:col"
		require
			m.is_dead_by_benign
			valid_sector_of_death: m.coordinate.row ~ sector_row and m.coordinate.col ~ sector_col
		do
			create Result.make_empty
			Result.append (moveable_entity_type (m))
			Result.append ("got destroyed by benign (id: " + benign_id.out + ") ")
			Result.append ("at Sector:" + sector_row.out + ":" + sector_col.out)
		end

feature -- Abstract State: Death Messages (Out of fuel.)

	fuelable_moveable_entity_death_by_out_of_fuel (f: MOVEABLE_ENTITY; sector_row, sector_col: INTEGER): STRING
			-- result ~ "  {MOVEABLE_ENTITY} got lost in space - out of fuel at Sector:row:col"
		require
			f_is_fuelable: attached {FUELABLE} f
			f_is_out_of_fuel: (attached {FUELABLE} f as f_e) implies f_e.is_out_of_fuel
			f.is_dead
			valid_sector_of_death: f.coordinate.row ~ sector_row and f.coordinate.col ~ sector_col
		do
			create Result.make_empty
			Result.append (moveable_entity_type (f))
			Result.append ("got lost in space - out of fuel ")
			Result.append ("at Sector:" + sector_row.out + ":" + sector_col.out)
		end

feature -- Abstract State: Death Messages (Death due to malevolent.)

	explorer_death_by_malevolent (e: EXPLORER; sector_row, sector_col: INTEGER): STRING
			-- result ~ "  Explorer got lost in space - out of life support at Sector:row:col"
		require
			e.is_dead_by_malevolent
			valid_sector_of_death: e.coordinate.row ~ sector_row and e.coordinate.col ~ sector_col
		do
			create Result.make_empty
			Result.append (moveable_entity_type (e))
			Result.append ("got lost in space - out of life support ")
			Result.append ("at Sector:" + sector_row.out + ":" + sector_col.out)
		end

feature -- Abstract State: Error Messages MOVE

	move_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append ("Negative on that request:no mission in progress.")
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
			Result.append ("Cannot transfer to new location as it is full.")
		end

feature -- Abstract State: Error Messages PASS

	pass_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append ("Negative on that request:no mission in progress.")
		end

feature -- Abstract State: Error Messages PLAY

	play_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append ("To start a new mission, please abort the current one first.")
		end

feature -- Abstract State: Error Messages TEST

	test_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append ("To start a new mission, please abort the current one first.")
		end

	test_error_threshold: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append ("Thresholds should be non-decreasing order.")
		end

feature -- Abstract State: Error Messages WORMHOLE

	wormhole_error_no_mission: STRING
		do
			create Result.make_from_string (left_margin)
			Result.append ("To start a new mission, please abort the current one first.")
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
