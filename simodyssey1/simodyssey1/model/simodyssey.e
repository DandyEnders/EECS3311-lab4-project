note
	description: "Summary description for {SIMODYSSEY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIMODYSSEY

inherit

	ANY
		redefine
			out
		end

create
	make

feature {NONE} -- Constructor

	make
		local
			r, c, n_quadrant: INTEGER
		do
				--initializing global id object
			create moveable_id.make (0, TRUE)
			create stationary_id.make (-1, FALSE)
				-- creating the board
			r := shared_info.number_rows
			c := shared_info.number_columns
			n_quadrant := shared_info.quadrants_per_sector
			create galaxy.make (r, c, n_quadrant)
				--creating the explorer
			create explorer.make ([1, 1], moveable_id.get_id) --
				--setting the threshold of a planet to some default value
			planet_threshold := 0
				-- setting the game to be in an aborted state so game_in_session is false
			game_aborted := TRUE
		end

feature -- Attribute

	galaxy: GRID

	explorer: EXPLORER

	info_access: SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result := info_access.shared_info
		end
			--attributes that might be bad design. It works for now so dont change it until you have a solid solution to implement.

	game_aborted: BOOLEAN -- set to true when the game is aborted using abort command.

feature {NONE} -- Private Attribute

	rng: RANDOM_GENERATOR_ACCESS

	planet_threshold: INTEGER

	moveable_id: ID_DISPATCHER

	stationary_id: ID_DISPATCHER

feature -- Command

	new_game (th: INTEGER)
		require
			valid_threshold: 1 <= th and th <= 101
			not game_in_session
		do
			make --calling make in order to initialize global ids and the board every new game
				-- initializing the planet threshold
			planet_threshold := th
				-- populating the galaxy randomly
			populate_galaxy
			game_aborted := FALSE
		end

	move_explorer (d: COORDINATE)
		require
			not sector_in_direction_is_full (d)
			game_in_session
		local
			destination_coord: COORDINATE
		do
			destination_coord := explorer.coordinate + d
			destination_coord := destination_coord.wrap_coordinate (destination_coord, [1, 1], [shared_info.number_rows, shared_info.number_columns])
			galaxy.move (explorer, destination_coord)
			explorer.spend_fuel_unit
				-- if the explorer's new sector has a star, then recharge.
			if galaxy.at (explorer.coordinate).has_star then
				explorer.charge_fuel (galaxy.at (explorer.coordinate).get_star)
			end
				-- if the explorer ran out of fuel or he encountered a blackhole, he should lose his life and be removed from the galaxy
			if galaxy.at (explorer.coordinate).has (create {BLACKHOLE}.make ([3, 3], -1)) or explorer.fuel ~ 0 then
				explorer.lose_life
				galaxy.at (explorer.coordinate).remove (explorer)
			end
		ensure
				-- If the explorer did not move to a black hole, Explorer should now exist in the sector that he wanted to go to
			(explorer.life /~ 0) implies galaxy.at ((old explorer.coordinate + d).wrap_coordinate ((old explorer.coordinate + d), [1, 1], [shared_info.number_rows, shared_info.number_columns])).has (explorer)
		end

feature {NONE} -- Private Helper Commands

	populate_galaxy
		local
			blackhole: BLACKHOLE
			p: PLANET
			numb_of_entity: INTEGER
			row: INTEGER
			col: INTEGER
			s_entity_num: INTEGER
			loop_counter: INTEGER
		do
				-- adding explorer and blackhole
			galaxy.add (explorer, explorer.coordinate) --
			create blackhole.make ([3, 3], stationary_id.get_id) --
			galaxy.add (blackhole, blackhole.coordinate) --
				-- populating planets based on threshold
			across
				galaxy is i_g
			loop
				if i_g.coordinate /~ [3, 3] then
					numb_of_entity := rng.rchoose (1, shared_info.quadrants_per_sector - 1)
					across
						1 |..| numb_of_entity is i
					loop
						if rng.rchoose (1, 100) < planet_threshold then
							create p.make (i_g.coordinate, moveable_id.get_id)
							p.set_turns_left (rng.rchoose (0, 2)) -- changed the order of this instruction. It used to be below galaxy.add
							galaxy.add (p, p.coordinate)
						end
					end
				end
			end
				-- populating stationary objects
			from
				loop_counter := 1
			until
				loop_counter > 10
			loop
				row := rng.rchoose (1, 5)
				col := rng.rchoose (1, 5)
				if galaxy.at ([row, col]).stationary_entity_count ~ 0 and not galaxy.at ([row, col]).is_full then
					s_entity_num := rng.rchoose (1, 3)
					if s_entity_num ~ 1 then
						galaxy.at ([row, col]).add (create {YELLOW_DWARF}.make ([row, col], stationary_id.get_id))
					elseif s_entity_num ~ 2 then
						galaxy.at ([row, col]).add (create {BLUE_GIANT}.make ([row, col], stationary_id.get_id))
					elseif s_entity_num ~ 3 then
						galaxy.at ([row, col]).add (create {WORMHOLE}.make ([row, col], stationary_id.get_id))
					end
					loop_counter := loop_counter + 1
				end
			end
		end

feature -- Queries

	out: STRING
		do
			create Result.make_empty
			Result.append (galaxy.out)
		end

	sector_in_direction_is_full (d: COORDINATE): BOOLEAN
			--Returns true if the sector in the direction specified is full.
		require
			is_a_direction: d.is_direction
		do
			Result := galaxy.at ((explorer.coordinate + d).wrap_coordinate ((explorer.coordinate + d), [1, 1], [shared_info.number_rows, shared_info.number_columns])).is_full
		end

	game_in_session: BOOLEAN
			-- a game is in session if neither (the explorer's life or his fuel is equal to 0), the game was aborted and the explorer has not found life
		do
			Result := explorer.life /~ 0 and explorer.fuel /~ 0 and not game_aborted and not explorer.found_life
		end

end
