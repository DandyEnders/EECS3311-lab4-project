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
			create explorer.make ([1, 1], moveable_id.get_id)
			create blackhole.make ([3, 3], stationary_id.get_id)
				-- creating the board
			r := shared_info.number_rows
			c := shared_info.number_columns
			n_quadrant := shared_info.quadrants_per_sector
			create galaxy.make (r, c, n_quadrant)
				-- intializing game_in_session = FALSE
			is_test_game := FALSE
			is_aborted := FALSE
				-- moved_entities.is_empty = TRUE and dead_entity.is_empty = TRUE.
			create moved_entities.make_empty
			create dead_entity.make_empty
		end

feature -- Attribute

	galaxy: GRID

feature -- Queries relevant to play / test / abort

	is_test_game: BOOLEAN -- is this a test game?

	is_aborted: BOOLEAN -- has the game been aborted?

	game_in_session: BOOLEAN
			-- a game is in session if neither (the explorer's life or his fuel is equal to 0), the game was aborted and the explorer has not found life
		do
			Result := explorer.is_alive and explorer.fuel /~ 0 and not explorer.found_life and galaxy.has (explorer) and not is_aborted
		end

	valid_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold: INTEGER): BOOLEAN
		do
			Result := a_threshold <= j_threshold and j_threshold <= m_threshold and m_threshold <= b_threshold and b_threshold <= p_threshold
		end

feature -- Queries relevant to move_explorer (2)

	sector_in_direction_is_full (d: COORDINATE): BOOLEAN
			--Returns true if the sector in the direction specified is full.
		require
			is_a_direction: d.is_direction
		do
			Result := galaxy.at ((explorer.coordinate + d).wrap_coordinate ((explorer.coordinate + d), [1, 1], [shared_info.number_rows, shared_info.number_columns])).is_full
		end

	is_explorer_landed: BOOLEAN
		do
			Result := explorer.landed
		end

feature {NONE} -- Main MOVEABLE_ENTITY Attributes

	explorer: EXPLORER

	blackhole: BLACKHOLE

feature {NONE, UNIT_TEST} -- Private Attribute

	info_access: SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result := info_access.shared_info
		end
			--attributes that might be bad design. It works for now so dont change it until you have a solid solution to implement.

	rng: RANDOM_GENERATOR_ACCESS

		--ID dispatchers

	moveable_id: ID_DISPATCHER

	stationary_id: ID_DISPATCHER

		--moved_entities and dead entities

	moved_entities: ARRAY [STRING]

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

feature -- Command

	abort
		require
			game_in_session
		do
			is_aborted := TRUE
		end

	new_game (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold: INTEGER; is_test: BOOLEAN)
			-- TODO - MAKE THRESHOLD REFLECT
		require
			valid_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold)
			not game_in_session
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
		end

	move_explorer (d: COORDINATE)
		require
			game_in_session
			not sector_in_direction_is_full (d)
			not is_explorer_landed
		local
			destination_coord: COORDINATE
		do
			destination_coord := explorer.coordinate + d
			destination_coord := destination_coord.wrap_coordinate (destination_coord, [1, 1], [shared_info.number_rows, shared_info.number_columns])
				-- reset list of "moved" entities and "dead" entities
			create moved_entities.make_empty
			create dead_entity.make_empty
				-- relocate the explorer and spend fuel
			relocate_moveable_entity (explorer, destination_coord)
			explorer.spend_fuel_unit
				-- telling the explorer to behave in its new sector.
			default_turn_actions
		ensure
				-- If the explorer did not move to a black hole, Explorer should now exist in the sector that he wanted to go to
			If_not_lost_the_explorer_is_in_new_position: (is_explorer_alive) implies galaxy.at ((old explorer_coordinate + d).wrap_coordinate ((old explorer_coordinate + d), [1, 1], [shared_info.number_rows, shared_info.number_columns])).has (explorer) -- change so "explorer" attribute is not reffered to
		end

	wormhole
		require
			game_in_session
			explorer_is_not_landed: not is_explorer_landed
			stationary_entity_is_wormhole: is_explorer_with_wormhole
		do
				-- reset list of "moved" entities and "dead" entities
			create moved_entities.make_empty
			create dead_entity.make_empty
				--wormhole-ing
			wormhole_entity (explorer)
			default_turn_actions
		ensure
			If_not_lost_the_explorer_is_in_new_position: explorer.is_alive implies galaxy.at (explorer_coordinate).has (explorer) -- change so "explorer" attribute is not reffered to
			if_explorer_goes_blackhole_he_is_dead: galaxy.at (explorer_coordinate).has_blackhole implies explorer.is_dead
		end

	land_explorer
		require
			game_in_session
			not is_explorer_landed
			is_sector_has_yellow_dwarf
			is_sector_has_planets
			is_sector_has_unvisted_attached_planets
		do
				-- reset list of "moved" entities and "dead" entities
			create moved_entities.make_empty
			create dead_entity.make_empty
				--landing the explorer
			galaxy.sector_with (explorer).land_explorer (explorer)
			default_turn_actions
		end

	liftoff
		require
			game_in_session
			is_explorer_landed
		do
				-- reset list of "moved" entities and "dead" entities
			create moved_entities.make_empty
			create dead_entity.make_empty
			explorer.set_landed (FALSE)
			default_turn_actions
		end

	pass
		require
			game_in_session ---make sure that if the player dies, then this is false.
		do
				-- reset list of "moved" entities and "dead" entities
			create moved_entities.make_empty
			create dead_entity.make_empty
			default_turn_actions
		end

feature {NONE} -- Private Helper Commands

	reproduce (n_me: NP_MOVEABLE_ENTITY)
		local
			sector: SECTOR
			s: STRING
			id: INTEGER
			temp_me: NP_MOVEABLE_ENTITY
		do
			sector := galaxy.sector_with (n_me)
			if attached {REPRODUCEABLE} n_me as r_n_me then
				if (not sector.is_full) and r_n_me.ready_to_reproduce then
					id := moveable_id.get_id
					r_n_me.reproduce (sector, id)
						--doing pretty printing {must change, this is a temporary thing just for testing}
						-- TODO
					check attached {NP_MOVEABLE_ENTITY} sector.entity (id) as ne then
						temp_me := ne
					end
					create s.make_from_string ("  reproduced " + temp_me.out_sqr_bracket + " at " + sector.out_abstract_full_coordinate (temp_me))
					moved_entities.force (s, moved_entities.count + 1)
				else
					if not r_n_me.ready_to_reproduce then
						r_n_me.decrement_actions_left_by_one
					end
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

	relocate_moveable_entity (me: MOVEABLE_ENTITY; c: COORDINATE) -- (2)
		local
			s: STRING
			c_before: COORDINATE
			quad_before: INTEGER
		do
				--Storing Previous locaiton of me in a String (2)
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
			moved_entities.force (s, moved_entities.count + 1)
		end

	wormhole_entity (me: MOVEABLE_ENTITY) -- (2)
		local
			added: BOOLEAN
			temp_row: INTEGER
			temp_col: INTEGER
		do
			from
				added := FALSE
			until
				added
			loop
				temp_row := rng.rchoose (1, 5)
				temp_col := rng.rchoose (1, 5)
				if not galaxy.at ([temp_row, temp_col]).is_full then
					relocate_moveable_entity (me, [temp_row, temp_col])
					added := TRUE
				end
			end
		end

	move_entity (n_me: NP_MOVEABLE_ENTITY; direction_of_p: COORDINATE) -- (2)
			-- moves a planet in the given direction from its current coordinate
		local
			new_coordinate_of_p: COORDINATE
			s: STRING
		do
			new_coordinate_of_p := (n_me.coordinate + direction_of_p);
			new_coordinate_of_p := new_coordinate_of_p.wrap_coordinate (new_coordinate_of_p, [1, 1], [shared_info.number_rows, shared_info.number_columns])
			if not galaxy.at (new_coordinate_of_p).is_full then
				relocate_moveable_entity (n_me, new_coordinate_of_p)
				if attached {FUELABLE} n_me as n_me_f then --decrement fue only when a move was successful. If n_me is a planet, then this will be false.
					n_me_f.spend_fuel_unit
				end
			else
				create s.make_from_string (n_me.out_sqr_bracket)
				s.append (":")
				s.append (galaxy.sector_with (n_me).out_abstract_full_coordinate (n_me))
				moved_entities.force (s, moved_entities.count + 1)
			end
		end

	npc_action -- (2)
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
								move_entity (n_me, d.give_direction (direction_num))
							end --
							n_me.check_health (galaxy.sector_with (n_me))
							if not n_me.is_dead then
								if attached {REPRODUCEABLE} n_me then
									reproduce (n_me)
								end
								n_me.behave (galaxy.sector_with (n_me))
							end
							across
								galaxy.sector_with (n_me) is i_q -- collecting all dead entities in the secotr
							loop
								if attached {MOVEABLE_ENTITY} i_q.entity as me_d then
									if me_d.is_dead then
										galaxy.remove (me_d)
										dead_entity.force (me_d, dead_entity.count + 1)
									end
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
			a: ASTROID
			j: JANITAUR
			m: MALEVOLENT
			b: BENIGN
			p: PLANET
		do
			across
				galaxy is i_g
			loop
				if i_g.coordinate /~ [blackhole.coordinate.row, blackhole.coordinate.col] then
					numb_of_entity_per_sector := rng.rchoose (1, (shared_info.quadrants_per_sector - 1))
					across
						1 |..| numb_of_entity_per_sector is i
					loop
						value := rng.rchoose (1, 100)
						if value < astroid_threshold then
							create a.make (i_g.coordinate, moveable_id.get_id)
							a.set_turns_left (rng.rchoose (0, 2))
							galaxy.add (a)
						elseif value < janitaur_threshold then
							create j.make (i_g.coordinate, moveable_id.get_id)
							j.set_turns_left (rng.rchoose (0, 2))
							galaxy.add (j)
						elseif value < malevolent_threshold then
							create m.make (i_g.coordinate, moveable_id.get_id)
							m.set_turns_left (rng.rchoose (0, 2))
							galaxy.add (m)
						elseif value < benign_threshold then
							create b.make (i_g.coordinate, moveable_id.get_id)
							b.set_turns_left (rng.rchoose (0, 2))
							galaxy.add (b)
						elseif value < planet_threshold then
							create p.make (i_g.coordinate, moveable_id.get_id)
							p.set_turns_left (rng.rchoose (0, 2))
							galaxy.add (p)
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
						galaxy.add (create {YELLOW_DWARF}.make ([row, col], stationary_id.get_id))
					elseif s_entity_num ~ 2 then
						galaxy.add (create {BLUE_GIANT}.make ([row, col], stationary_id.get_id))
					elseif s_entity_num ~ 3 then
						galaxy.add (create {WORMHOLE}.make ([row, col], stationary_id.get_id))
					end
					loop_counter := loop_counter + 1
				end
			end
		end

	populate_galaxy --
		do
				-- adding explorer and blackhole
			galaxy.add (explorer) --
			galaxy.add (blackhole) --
				-- populating galaxy based on threshold values
			populate_galaxy_with_non_playable_moveable_entities
				-- populating stationary objects
			populate_galaxy_with_stationary_entities
		end

feature -- Queries

feature -- Interface

		--	get_explorer: EXPLORER
		--		do
		--			Result := explorer.deep_twin
		--		end
		-- export these features to explorer (I decided not to because you're right that it is an interface) If we were to export such features into the explorer, then explorer would need to store its SECTOR as an attribute.

	is_explorer_with_wormhole: BOOLEAN
		do
			Result := galaxy.sector_with (explorer).has_wormhole
		end

	is_explorer_found_life: BOOLEAN
		do
			Result := explorer.found_life
		end

	is_landsite_has_life: BOOLEAN
			-- is leftmost unvisited planet in a sector has a life?
		do
			Result := across explorer_sector is i_q some (attached {PLANET} i_q.entity as p) implies (not p.visited and (p.support_life)) end
		end

	explorer_coordinate: COORDINATE
		do
			Result := explorer.coordinate
		end

	is_explorer_alive: BOOLEAN
		do
			Result := explorer.is_alive
		end

	is_explorer_landable: BOOLEAN
			-- Not landable if
			-- 1. all planets in a sector are visited
			-- 2. there are no planets
			-- 3. there is a planet but therre are no stars
		do
			Result := is_sector_has_planets and is_sector_has_yellow_dwarf and is_sector_has_unvisted_attached_planets
		end

	is_explorer_dead_by_out_of_fuel: BOOLEAN
		do
			Result := explorer.is_dead_by_out_of_fuel
		end

	is_explorer_dead_by_blackhole: BOOLEAN
		do
			Result := explorer.is_dead_by_blackhole
		end

	is_sector_has_yellow_dwarf: BOOLEAN
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

	is_sector_has_planets: BOOLEAN
		do
			Result := galaxy.sector_with (explorer).has_planet
		end

	is_sector_has_unvisted_attached_planets: BOOLEAN
		do
			if is_sector_has_planets and is_sector_has_yellow_dwarf then
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

feature -- Out

	out: STRING
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
				--			--RNG debug
				--			Result.append ("%N")
				--			Result.append(rng.rng_debug_this_round)
				--			rng.reset_debug
		end

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
			if moved_entities.is_empty then
				Result.append ("none")
			else
				across
					moved_entities is i_s
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

	out_status_explorer: STRING
		local
			e_q: INTEGER
		do
			e_q := galaxy.sector_with (explorer).quadrant_at (explorer)
			create Result.make_empty
			Result.append (explorer.out_status (e_q))
		end

end
