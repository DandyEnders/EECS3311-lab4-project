note
	description: "[
		A class that controls the addition, removal,and movement 
		of entities in the galaxy and provides an interface for
		controlling the explorer’s actions in the galaxy.
		
		Secret:
		Post execution of a command, non-user-controlled entities 
		move, reproduce, behave, and check according to the 
		“turn" command algorithm on page 33 of the project
		specifications.
	]"
	author: "Jinho Hwang, Ato Koomson"
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
		do
				--setting the threshold of a planet to some default value
			astroid_threshold := 0
			janitaur_threshold := 0
			malevolent_threshold := 0
			benign_threshold := 0
			planet_threshold := 0
				--initializing global id object
			create moveable_id.make (0, TRUE)
			create stationary_id.make (-1, FALSE)
				--creating unique entities Explorer and Blackhole
			create explorer.make ([1, 1], moveable_id.current_id)
			moveable_id.update_id
			create blackhole.make ([3, 3], stationary_id.current_id)
			stationary_id.update_id
				-- creating the board
			number_rows := 5
			number_columns := 5
			number_stationary_entities := 10
			number_quadrants_per_sector := 4
			create galaxy.make (number_rows, number_columns, number_quadrants_per_sector)
				-- intializing game_in_session = FALSE
			is_test_game := FALSE
			is_aborted := FALSE
				-- moved_entities.is_empty = TRUE and dead_entity.is_empty = TRUE.
			create movement_output.make_empty
			create dead_entity.make_empty
		end

feature -- Attributes

	galaxy: GRID
			-- a GRID containing all live ENTITYs in the game.

feature {NONE} -- GRID Attributes

	number_rows: INTEGER
			-- The number of rows in the grid

	number_columns: INTEGER
			-- The number of columns in the  grid

	number_stationary_entities: INTEGER
			-- The number of stationary_items in the grid

	number_quadrants_per_sector: INTEGER

	rng: RANDOM_GENERATOR_ACCESS

		--ID dispatchers

feature -- State of Game Queries

	is_test_game: BOOLEAN
			-- result is true if query "game_is_in_session" is true AND command "new_game" was previously called with argument TRUE in-place for parameter "is_test". result is false otherwise.

	is_aborted: BOOLEAN
			-- result is true if query "game_is_in_session"is true AND THEN command "abort" is called. false otherwise.

	game_is_in_session: BOOLEAN
			-- result equals true means that a game_is_in_session.
		do
			Result := explorer.is_alive and not explorer.found_life and not is_aborted and galaxy.has (explorer)
		ensure
			valid_game_session: Result = (explorer_is_alive and (not explorer_found_life) and (not is_aborted) and galaxy.at (explorer_coordinate).has_id (explorer_id))
		end

	valid_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold: INTEGER): BOOLEAN
			-- result equals true if threshold values from left to right are passed (as arguments) in increasing order
		do
			Result := a_threshold <= j_threshold and j_threshold <= m_threshold and m_threshold <= b_threshold and b_threshold <= p_threshold
		end

feature {NONE} -- Main MOVEABLE_ENTITY Attributes

	explorer: EXPLORER

	blackhole: BLACKHOLE

	moveable_id: ID_DISPATCHER

	stationary_id: ID_DISPATCHER

		--moved_entities and dead entities

	movement_output: ARRAY [STRING]

	dead_entity: ARRAY [MOVEABLE_ENTITY]

		--threshold values

	astroid_threshold: INTEGER

	janitaur_threshold: INTEGER

	malevolent_threshold: INTEGER

	benign_threshold: INTEGER

	planet_threshold: INTEGER

feature {NONE} -- private queries

	explorer_sector: SECTOR
		do
			Result := galaxy.sector_with (explorer)
		end

feature -- Explorer Interface Commands

	abort_game
			-- abort the game
		require
			game_is_in_session
		do
			is_aborted := TRUE
		ensure
			is_aborted
			not game_is_in_session
		end

	new_game (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold: INTEGER; is_test: BOOLEAN)
			-- start a "new_game"
		require
			valid_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold)
			not game_is_in_session
		do
			make -- initializing (SYMODYSSEY attribtues to their defualt values)
				-- initializing the threshold values.
			astroid_threshold := a_threshold
			janitaur_threshold := j_threshold
			malevolent_threshold := m_threshold
			benign_threshold := b_threshold
			planet_threshold := p_threshold
				-- populating the galaxy randomly
			populate_galaxy
			is_test_game := is_test
		ensure
			game_is_in_session and (is_test_game = is_test)
		end

	move_explorer (d: COORDINATE)
			-- move the explorer away from its current sector and towards a sector in direction "d".
		require
			game_is_in_session
			d.is_direction
			not sector_in_explorer_direction_is_full (d)
			not explorer_is_landed
		local
			destination_coord: COORDINATE
		do
			destination_coord := explorer.coordinate + d
			destination_coord := destination_coord.wrap_coordinate_to_coordinate (destination_coord, [1, 1], [number_rows, number_columns])
				-- reset list of "moved" entities and "dead" entities
			create movement_output.make_empty
			create dead_entity.make_empty
				-- relocate the explorer and spend fuel
			relocate_moveable_entity (explorer, destination_coord)
			explorer.spend_fuel_unit
				-- telling the explorer to behave in its new sector.
			default_turn_actions
		ensure
			If_not_lost_the_explorer_is_in_new_sector: (explorer_is_alive) implies galaxy.at ((old explorer_coordinate + d).wrap_coordinate_to_coordinate ((old explorer_coordinate + d), [1, 1], [number_rows, number_columns])).has_id (explorer_id)
			If_explorer_is_not_at_new_sector_then_explorer_is_dead: (not galaxy.at ((old explorer_coordinate + d).wrap_coordinate_to_coordinate ((old explorer_coordinate + d), [1, 1], [number_rows, number_columns])).has_id (explorer_id)) implies (not explorer_is_alive)
		end

	wormhole_explorer
			-- wormhole the explorer into a sector.
		require
			game_is_in_session
			not explorer_is_landed
			explorer_sector_has_wormhole
		do
				-- reset list of "moved" entities and "dead" entities
			create movement_output.make_empty
			create dead_entity.make_empty
				--wormhole-ing
			wormhole_entity (explorer)
			default_turn_actions
		ensure
			If_not_lost_the_explorer_is_in_new_position: explorer_is_alive implies galaxy.at (explorer_coordinate).has_id (explorer_id)
			if_explorer_is_not_in_the_galaxy_is_dead: (not galaxy.at (explorer_coordinate).has_id (explorer_id)) implies ((not explorer_is_alive) and (not game_is_in_session))
		end

	land_explorer
			-- land the explorer on a landable planet
		require
			game_is_in_session
			not explorer_is_landed
			explorers_sector_is_landable: explorer_sector_has_planets and explorer_sector_has_yellow_dwarf and explorer_sector_has_unvisted_attached_planets
		local
			p: PLANET
		do
				-- reset list of "moved" entities and "dead" entities
			create movement_output.make_empty
			create dead_entity.make_empty
				--landing the explorer
			p := galaxy.sector_with (explorer).find_landable_planet
			explorer.land_on (p)
			default_turn_actions
		ensure
			explorer_is_alive
			explorer_is_landed
			if_found_life_then_game_is_over: (explorer_found_life implies (not game_is_in_session))
		end

	liftoff_explorer
			--  liftoff explorer.
		require
			game_is_in_session
			explorer_is_landed
		do
				-- reset list of "moved" entities and "dead" entities
			create movement_output.make_empty
			create dead_entity.make_empty
			explorer.liftoff
			default_turn_actions
		ensure
			not explorer_is_landed
			if_dead_then_game_is_over: ((not explorer_is_alive) implies (not game_is_in_session))
		end

	pass_explorer_turn
			-- pass the explorer's turn in the game.
		require
			game_is_in_session ---make sure that if the player dies, then this is false.
		do
				-- reset list of "moved" entities and "dead" entities
			create movement_output.make_empty
			create dead_entity.make_empty
			default_turn_actions
		ensure
			if_dead_game_is_over: (not explorer_is_alive) implies (not game_is_in_session)
		end

	status_of_explorer
		require
			game_is_in_session
		do
		ensure
			game_is_in_session
		end

feature {NONE} -- Private Helper Commands

	reproduce (r_n_me: REPRODUCEABLE_ENTITY)
		local
			sector: SECTOR
			id: INTEGER
			clone_e: like r_n_me
			s: STRING
			msg: MESSAGE
		do
			sector := galaxy.sector_with (r_n_me)
			if (not sector.is_full) and r_n_me.ready_to_reproduce then
				id := moveable_id.current_id
				moveable_id.update_id
				clone_e := r_n_me.reproduce (id)
				sector.add (clone_e)
					--Pretty Printing Movement: ie reproduced ...
				create s.make_from_string (msg.left_margin + "reproduced " + clone_e.out_sqr_bracket + " at " + sector.out_abstract_full_coordinate (clone_e))
				movement_output.force (s, movement_output.count + 1)
					-- end of pretty printing code.
			else
				if not r_n_me.ready_to_reproduce then
					r_n_me.decrement_actions_left_by_one
				end
			end
		end

	default_turn_actions -- every time a turn command occurs, these actions must be done.
		do
			explorer.check_health (galaxy.sector_with (explorer))
			if explorer.is_dead then
				galaxy.remove (explorer) -- I believe it is the job of SYMODYSSEY to remove the explorer from the game
				dead_entity.force (explorer, dead_entity.count + 1)
			end
				-- allowing npc's to move and behave.
			if not explorer.found_life then
				npc_action
			end
		end

	relocate_moveable_entity (me: MOVEABLE_ENTITY; c: COORDINATE)
		local
			s: STRING
			c_before: COORDINATE
			quad_before: INTEGER
		do
				--Storing Previous locaiton of me in a String
			create s.make_from_string (me.out_sqr_bracket)
			s.append (":")
			s.append (galaxy.sector_with (me).out_abstract_full_coordinate (me))
				-- Moving the me to COORDINATE c
			c_before := me.coordinate
			quad_before := galaxy.at (c_before).quadrant_at (me)
			galaxy.move (me, c)
				-- either coordinate change or quadrant change then do ->[1,1,1]
			if c_before /~ c or quad_before /~ galaxy.at (c_before).quadrant_at (me) then
				s.append ("->")
				s.append (galaxy.sector_with (me).out_abstract_full_coordinate (me))
			end
				-- Adding Explorer's "movement" to the list of moved enetities.
			movement_output.force (s, movement_output.count + 1)
		end

	wormhole_entity (me: MOVEABLE_ENTITY)
		local
			added: BOOLEAN
			temp_row: INTEGER
			temp_col: INTEGER
			c: COORDINATE
		do
			from
				added := FALSE
			until
				added
			loop
				temp_row := rng.rchoose (1, 5)
				temp_col := rng.rchoose (1, 5)
				create c.make ([temp_row, temp_col])
				if not galaxy.at (c).is_full then
						-- forum question suggests oracle change comming up {or (c ~ me.coordinate) }
					relocate_moveable_entity (me, [temp_row, temp_col])
					added := TRUE
				end
			end
		end

	move_entity (n_me: NP_MOVEABLE_ENTITY; direction_of_p: COORDINATE)
			-- moves a planet in the given direction from its current coordinate
		local
			new_coordinate_of_p: COORDINATE
			s: STRING
		do
			new_coordinate_of_p := (n_me.coordinate + direction_of_p);
			new_coordinate_of_p := new_coordinate_of_p.wrap_coordinate_to_coordinate (new_coordinate_of_p, [1, 1], [number_rows, number_columns])
			if not galaxy.at (new_coordinate_of_p).is_full then
				relocate_moveable_entity (n_me, new_coordinate_of_p)
				if attached {FUELABLE} n_me as n_me_f then --decrement fue only when a move was successful. If n_me is a planet, then this will be false.
					n_me_f.spend_fuel_unit
				end
			else
				create s.make_from_string (n_me.out_sqr_bracket)
				s.append (":")
				s.append (galaxy.sector_with (n_me).out_abstract_full_coordinate (n_me))
				movement_output.force (s, movement_output.count + 1)
			end
		end

	npc_action
		local
			direction_num: INTEGER
			d: DIRECTION_UTILITY
		do
				-- going across moveable entities except explorer by accending order
			across
				galaxy.all_moveable_entities is i_e
			loop
				if not i_e.is_dead and attached {NP_MOVEABLE_ENTITY} i_e as n_me then --checking if i_e.is_dead because there sometimes are dead entities in the list while all npc behave succesively
						-- if the planets turns left is 0, then check if there is a star in the sector
					if n_me.turns_left ~ 0 then
							-- specal case ( pg  28 )
						if galaxy.sector_with (n_me).has_star and attached {PLANET} n_me as p then
							p.behave (galaxy.sector_with (p))
						else -- turns_left = 0 and no star entity in same sector
								-- movement (pg  29)
							if galaxy.sector_with (n_me).has_wormhole and (attached {MALEVOLENT} n_me or attached {BENIGN} n_me) then
								wormhole_entity (n_me)
							else
								direction_num := rng.rchoose (1, 8)
									--move_entity and spend fuel spend fuel for janitaur, malevonent, and benign
								move_entity (n_me, d.number_for_direction (direction_num))
							end --
							n_me.check_health (galaxy.sector_with (n_me))
							if not n_me.is_dead then
								if attached {REPRODUCEABLE_ENTITY} n_me as r_n_me then
									reproduce (r_n_me)
								end
								n_me.behave (galaxy.sector_with (n_me))
									-- Pretty Printing Movement: ie deystroyed ..., attacked ....
								across
									n_me.behavior_messages is i_m
								loop
									movement_output.force (i_m, movement_output.count + 1)
								end
									-- End of Pretty Printing
							end
								-- removing all dead entities this round
							across
								galaxy.sector_with (n_me).moveable_entities_in_increasing_order is me_d -- collecting all dead entities in the secotr
							loop
								if me_d.is_dead then
									galaxy.remove (me_d)
									dead_entity.force (me_d, dead_entity.count + 1)
								end
							end
						end
					else
						n_me.set_turns_left (n_me.turns_left - 1)
					end
				end
			end
		end

	populate_galaxy_with_non_playable_moveable_entities -- (1)
		local
			numb_of_entity_per_sector: INTEGER
			value: INTEGER
			a: ASTEROID
			j: JANITAUR
			m: MALEVOLENT
			b: BENIGN
			p: PLANET
		do
			across
				galaxy is i_g
			loop
				if i_g.coordinate /~ [blackhole.coordinate.row, blackhole.coordinate.col] then
					numb_of_entity_per_sector := rng.rchoose (1, (number_quadrants_per_sector - 1))
					across
						1 |..| numb_of_entity_per_sector is i
					loop
						value := rng.rchoose (1, 100)
						if value < astroid_threshold then
							create a.make (i_g.coordinate, moveable_id.current_id, rng.rchoose (0, 2))
							moveable_id.update_id
							galaxy.add_at (a, a.coordinate)
						elseif value < janitaur_threshold then
							create j.make (i_g.coordinate, moveable_id.current_id, rng.rchoose (0, 2))
							moveable_id.update_id
							galaxy.add_at (j, j.coordinate)
						elseif value < malevolent_threshold then
							create m.make (i_g.coordinate, moveable_id.current_id, rng.rchoose (0, 2))
							moveable_id.update_id
							galaxy.add_at (m, m.coordinate)
						elseif value < benign_threshold then
							create b.make (i_g.coordinate, moveable_id.current_id, rng.rchoose (0, 2))
							moveable_id.update_id
							galaxy.add_at (b, b.coordinate)
						elseif value < planet_threshold then
							create p.make (i_g.coordinate, moveable_id.current_id, rng.rchoose (0, 2))
							moveable_id.update_id
							galaxy.add_at (p, p.coordinate)
						end
					end
				end
			end
		end

	populate_galaxy_with_stationary_entities
		local
			row: INTEGER
			col: INTEGER
			s_entity_num: INTEGER
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > 10
			loop
				row := rng.rchoose (1, 5)
				col := rng.rchoose (1, 5)
				if not galaxy.at ([row, col]).has_stationary_entity and not galaxy.at ([row, col]).is_full then
					s_entity_num := rng.rchoose (1, 3)
					if s_entity_num ~ 1 then
						galaxy.add_at (create {YELLOW_DWARF}.make ([row, col], stationary_id.current_id), [row, col])
						stationary_id.update_id
					elseif s_entity_num ~ 2 then
						galaxy.add_at (create {BLUE_GIANT}.make ([row, col], stationary_id.current_id), [row, col])
						stationary_id.update_id
					elseif s_entity_num ~ 3 then
						galaxy.add_at (create {WORMHOLE}.make ([row, col], stationary_id.current_id), [row, col])
						stationary_id.update_id
					end
					loop_counter := loop_counter + 1
				end
			end
		end

	populate_galaxy
		do
				-- adding explorer and blackhole
			galaxy.add_at (explorer, explorer.coordinate) --
			galaxy.add_at (blackhole, blackhole.coordinate) --
				-- populating galaxy based on threshold values
			populate_galaxy_with_non_playable_moveable_entities
				-- populating stationary objects
			populate_galaxy_with_stationary_entities
		end

feature -- Explorer Interface Boolean Queries

	sector_in_explorer_direction_is_full (d: COORDINATE): BOOLEAN
			-- result equals true if a sector in "galaxy" in direction d is full. result equals false otherwise.
		require
			d.is_direction
			game_is_in_session
		do
			Result := galaxy.at ((explorer.coordinate + d).wrap_coordinate_to_coordinate ((explorer.coordinate + d), [1, 1], [number_rows, number_columns])).is_full
		end

	explorer_is_landed: BOOLEAN
			-- result equals true if explorer is landed on a planet in "galaxy". false otherwise.
		do
			Result := explorer.landed
		end

	explorer_sector_has_wormhole: BOOLEAN
			-- result equals true if explorer is contained in a SECTOR that also contains a wormhole. false otherwise.
		require
			game_is_in_session
		do
			Result := galaxy.sector_with (explorer).has_wormhole
		end

	explorer_found_life: BOOLEAN
			-- result equals true if the explorer found life while landed on a planet. false otherwise
		do
			Result := explorer.found_life
		ensure
			(Result = TRUE) implies (explorer_is_landed and explorer_is_alive)
		end

	planet_in_explorer_sector_supports_life: BOOLEAN
			-- result equals true if there exists a planet in the explorer's sector that supports life. false otherwise.
		require
			game_is_in_session
		do
			Result := across explorer_sector is i_q some (attached {PLANET} i_q.entity as p) implies (not p.visited and (p.support_life)) end
		end

	explorer_is_alive: BOOLEAN
			-- result equals true if explorer is alive. false otherwise.
		do
			Result := explorer.is_alive
		end

	explorer_sector_is_landable: BOOLEAN
			-- result equals true if there exists (attached and unvisited) planet(s) in the explorer's sector and the explorer's sector contains a YELLOW_DWARF . false otherwise.
		require
			game_is_in_session
		do
			Result := galaxy.sector_with (explorer).is_landable
		ensure
			valid_properties_for_life: Result = (explorer_sector_has_planets and explorer_sector_has_yellow_dwarf and explorer_sector_has_unvisted_attached_planets)
		end

	explorer_dead_by_out_of_fuel: BOOLEAN
			-- result equals true if the explorer died by out of fuel. false otherwise.
		do
			Result := explorer.is_dead_by_out_of_fuel
		end

	explorer_dead_by_blackhole: BOOLEAN
			-- result equals true if the explorer died by blackhole. false otherwise.
		do
			Result := explorer.is_dead_by_blackhole
		end

	explorer_dead_by_asteroid: BOOLEAN
			-- result equals true if the explorer died by asteroid. false otherwise.
		do
			Result := explorer.is_dead_by_asteroid
		end

	explorer_dead_by_malevolent: BOOLEAN
			-- result equals true if the explorer died by malevolent. false otherwise.
		do
			Result := explorer.is_dead_by_malevolent
		end

	explorer_sector_has_yellow_dwarf: BOOLEAN
			-- result equals true if the explorer's SECTOR contains a YELLOW_DWARF. false otherwise.
		require
			game_is_in_session
		do
			if explorer_sector.has_stationary_entity then
				if attached {YELLOW_DWARF} explorer_sector.get_stationary_entity as y_d then
					Result := TRUE
				else
					Result := FALSE
				end
			else
				Result := FALSE
			end
		end

	explorer_sector_has_planets: BOOLEAN
			-- result equals true if the explorer's SECTOR contains PLANETs. false otherwise.
		require
			game_is_in_session
		do
			Result := galaxy.sector_with (explorer).has_planet
		end

	explorer_sector_has_unvisted_attached_planets: BOOLEAN
			-- result equals true if the explorer's SECTOR contains attached, yet unvisited PLANET's. false otherwise.
		require
			game_is_in_session
		do
			if explorer_sector_has_planets and explorer_sector_has_yellow_dwarf then
				across
					explorer_sector is i_q
				until
					Result
				loop
					if attached {PLANET} i_q.entity as p then
						if (p.attached_to_star and not p.visited) then
							Result := TRUE
						end
					end
				end
			else
				Result := FALSE
			end
		end

feature -- Explorer Interface non-Boolean Queries

	explorer_coordinate: COORDINATE
			-- result equals the explorer's coordinate in "galaxy"
		do
			Result := explorer.coordinate
		end

	explorer_id: INTEGER
			-- result equals explorer's id
		do
			Result := explorer.id
		end

feature -- Out

	out: STRING
			-- result equals output messages (Movement: ... Sectors: ... Description: ... Deaths This Turn: ... and galaxy.out) when "is_test_game" is true
		do
			create Result.make_empty
			Result.append (out_movement)
			Result.append ("%N")
			if is_test_game then
				Result.append (out_sectors)
				Result.append ("%N")
				Result.append (out_descriptions)
				Result.append ("%N")
				Result.append (out_deaths_this_turn)
				Result.append ("%N")
			end
			Result.append (out_grid)
				--				--RNG debug (Uncomment everything below to unleash The numbers)
				--			Result.append ("%N")
				--			Result.append (rng.rng_debug_this_round)
				--			rng.reset_debug
		end

	out_status_explorer: STRING
			-- explorer status message
		require
			explorer_is_alive
		local
			e_q: INTEGER
		do
			e_q := galaxy.sector_with (explorer).quadrant_at (explorer)
			create Result.make_empty
			Result.append (explorer.out_status (e_q))
		end

	explorer_death_message: STRING
			-- output message generated when the explorer dies
		require
			not explorer_is_alive
		do
			Result := explorer.out_death_message
		end

feature {NONE} -- Out

	out_grid: STRING
		do
			create Result.make_empty
			Result.append (galaxy.out)
		end

	out_movement: STRING
		local
			msg: MESSAGE
		do
			create Result.make_from_string (msg.left_margin)
			Result.append ("Movement:")
			if movement_output.is_empty then
				Result.append ("none")
			else
				across
					movement_output is i_s
				loop
					Result.append ("%N")
					Result.append (msg.left_big_margin)
					Result.append (i_s.out)
				end
			end
		end

	out_sectors: STRING
		do
			Result := galaxy.out_abstract_sectors
		end

	out_descriptions: STRING
		do
			Result := galaxy.out_abstract_description
		end

	out_deaths_this_turn: STRING
		local
			msg: MESSAGE
		do
			create Result.make_from_string (msg.left_margin)
			Result.append ("Deaths This Turn:")
			if dead_entity.is_empty then
				Result.append ("none")
			else
				across
					dead_entity is i_me
				loop
					Result.append ("%N")
					Result.append (i_me.out_death_description)
				end
			end
		end

end
