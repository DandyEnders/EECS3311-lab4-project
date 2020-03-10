note
	description: "Summary description for {SIMODYSSEY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIMODYSSEY

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

feature {NONE} -- Private Attribute

	game_aborted: BOOLEAN -- set to true when the game is aborted using abort command.

	explorer: EXPLORER

	info_access: SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result := info_access.shared_info
		end
			--attributes that might be bad design. It works for now so dont change it until you have a solid solution to implement.

	rng: RANDOM_GENERATOR_ACCESS

	planet_threshold: INTEGER

	moveable_id: ID_DISPATCHER

	stationary_id: ID_DISPATCHER

feature {NONE} -- private queries

	explorer_sector: SECTOR
		do
			Result := galaxy.at (explorer.coordinate)
		end

feature -- Command

	new_game (th: INTEGER)
		require
			valid_threshold: 1 <= th and th <= 101
--			TODISCUSS: even if we are in seesion, we should be able to override it.
--				It's state's job to check if we should call new_game when we suppose to.
--			not game_in_session
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

			-- TODISCUSS: The order which "check" is done in document are in this order: (pg 30)
			explorer.spend_fuel_unit

			-- check if explorer can charge
			if galaxy.at (explorer.coordinate).has_stationary_entity then
				-- if the explorer's new sector has a star, then recharge.
				if attached {STAR} galaxy.at (explorer.coordinate).get_stationary_entity as i_star then
					explorer.charge_fuel (i_star)
				end
			end

 			-- check if explorer dies out of fuel
			if explorer.is_out_of_fuel then
				-- if the explorer ran out of fuel, he should lose his life and be removed from the galaxy
				explorer.kill_by_out_of_fuel
				galaxy.remove (explorer)
			end

--					-- if the explorer's new sector has a star, then recharge.
--				if attached {STAR} galaxy.at (explorer.coordinate).get_stationary_entity as i_star then
--					explorer.charge_fuel (i_star)
--						-- if explorer encountered a blackhole, he should lose his life and be removed from the galaxy
--				else

			-- check if explorer dies out of blackhole
			if galaxy.at (explorer.coordinate).has_stationary_entity then
				if attached {BLACKHOLE} galaxy.at (explorer.coordinate).get_stationary_entity then
					explorer.kill_by_blackhole
					galaxy.remove (explorer)
				end
			end

			npc_action
		ensure
				-- If the explorer did not move to a black hole, Explorer should now exist in the sector that he wanted to go to
			If_not_lost_the_explorer_is_in_new_position: (explorer.is_alive) implies galaxy.at ((old explorer.coordinate + d).wrap_coordinate ((old explorer.coordinate + d), [1, 1], [shared_info.number_rows, shared_info.number_columns])).has (explorer)
		end

	wormhole
		require
			game_in_session
			stationary_entity_exists_at_location: galaxy.at (explorer_coordinate).has_stationary_entity
			stationar_entity_is_wormhole: attached {WORMHOLE} galaxy.at (explorer_coordinate).get_stationary_entity
		do
		end

	land_explorer
		require
			game_in_session
		do
		end

	liftoff
		require
			game_in_session
		do
		end

	pass
		require
			game_in_session
		do
		end

feature {NONE} -- Private Helper Commands

	move_planet (p: PLANET; direction_of_p: COORDINATE)
			-- moves a planet in the given direction from its current coordinate
		local
			new_coordinate_of_p: COORDINATE
		do
			new_coordinate_of_p := (p.coordinate + direction_of_p);
			new_coordinate_of_p := new_coordinate_of_p.wrap_coordinate (new_coordinate_of_p, [1, 1], [shared_info.number_rows, shared_info.number_columns])
			if not galaxy.at (new_coordinate_of_p).is_full then
				galaxy.move (p, new_coordinate_of_p)
			end
		end

	npc_action
		local
			sup_life_prob: INTEGER
			direction_num: INTEGER
			d: DIRECTION_UTILITY
		do
				-- going across moveable entities except explorer by accending order
			across
				galaxy.all_moveable_entities is i_e
			loop
				if attached {PLANET} i_e as p then
						-- if the planets turns left is 0, then check if there is a star in the sector
					if p.turns_left ~ 0 then
						if galaxy.at (p.coordinate).has_stationary_entity and attached {STAR} galaxy.at (p.coordinate).get_stationary_entity as star then
								-- If there is a star in the sector then set attached for the planet to true.
							p.set_attached_to_star (TRUE)
								-- If this star is a yellow dwarf then rchoose if this planet should support life?
							if attached {YELLOW_DWARF} star as y_star then
								sup_life_prob := rng.rchoose (1, 2) -- num = 2 means life
								if sup_life_prob = 2 then
									p.set_support_life (TRUE)
								end
							end
						else
								-- move the planet
							direction_num := rng.rchoose (1, 8)
							move_planet (p, d.give_direction (direction_num))
								--check if the planet has entered a sector with a blackhole. Kill the planet if this is the case
							if galaxy.at (p.coordinate).has_stationary_entity and attached {BLACKHOLE} galaxy.at (p.coordinate).get_stationary_entity then
								p.kill_by_blackhole
								galaxy.remove (p)
							end
								-- If the planet did not encounter a blackhole
							if galaxy.has (p) then

									--behave the planet
									-- If there is a star in the new sector sector then set attached for the planet to true.
								if galaxy.at (p.coordinate).has_stationary_entity and attached {STAR} galaxy.at (p.coordinate).get_stationary_entity as star then
									p.set_attached_to_star (TRUE)
										-- if this star is a yellow dwarf then rchoose if this planet should support life?
									if attached {YELLOW_DWARF} star as y_star then
										sup_life_prob := rng.rchoose (1, 2) -- num = 2 means life
										if sup_life_prob = 2 then
											p.set_support_life (TRUE)
										end
									end
								else
									p.set_turns_left (rng.rchoose (0, 2))
								end
							end
						end
					else
						p.set_turns_left (p.turns_left - 1)
					end
				end
			end
		end

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
			galaxy.add (explorer) --
			galaxy.move (explorer, [1, 1])
			create blackhole.make ([3, 3], stationary_id.get_id) --
			galaxy.add (blackhole) --
				-- populating planets based on threshold
			across
				galaxy is i_g
			loop
				if i_g.coordinate /~ [3, 3] then
					numb_of_entity := rng.rchoose (1, (shared_info.quadrants_per_sector - 1))
					across
						1 |..| numb_of_entity is i
					loop
						if rng.rchoose (1, 100) < planet_threshold then
							create p.make (i_g.coordinate, moveable_id.get_id)
							p.set_turns_left (rng.rchoose (0, 2)) -- changed the order of this instruction. It used to be below galaxy.add
							galaxy.add (p)
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
				if not galaxy.at ([row, col]).has_stationary_entity and not galaxy.at ([row, col]).is_full then
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
			Result := explorer.is_alive and explorer.fuel /~ 0 and not game_aborted and not explorer.found_life
		end

feature -- Interface

		--	get_explorer: EXPLORER
		--		do
		--			Result := explorer.deep_twin
		--		end
		-- export these features to explorer (I decided not to because you're right that it is an interface) If we were to export such features into the explorer, then explorer would need to store its SECTOR as an attribute.

	is_landsite_has_life: BOOLEAN
			-- is leftmost unvisited planet in a sector has a life?
		do
			Result := across explorer_sector is i_q some (attached {PLANET} i_q.entity as p) implies (not p.visited and (p.support_life)) end
		end

	explorer_coordinate: COORDINATE
		do
			Result := explorer.coordinate
		end

	is_explorer_landable: BOOLEAN
			-- Not landable if
			-- 1. all planets in a sector are visited
			-- 2. there are no planets
			-- 3. there is a planet but therre are no stars
		do
			Result := e_sector_has_planets and e_sector_has_yellow_dwarf and e_sector_has_unvisted_attached_planets
		end

	e_sector_has_yellow_dwarf: BOOLEAN
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

	e_sector_has_planets: BOOLEAN
		do
			if explorer_sector.moveable_entity_count > 1 then
				Result := TRUE
			else
				Result := FALSE
			end
		end

	e_sector_has_unvisted_attached_planets: BOOLEAN
		do
			if e_sector_has_planets and e_sector_has_yellow_dwarf then
				Result := across explorer_sector is i_q some (attached {PLANET} i_q.entity as p) implies (p.attached_to_star and not p.visited) end
			else
				Result := FALSE
			end
		end

feature -- Out

	out_grid: STRING
		do
			create Result.make_empty
			Result.append (galaxy.out)
		end

	out_movement: STRING -- TODO@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		do
			create Result.make_from_string ("  ")
		end

	out_sectors: STRING
		do
			create Result.make_from_string ("  ")
		end

	out_descriptions: STRING
		do
			create Result.make_from_string ("  ")
		end

	out_deaths_this_turn: STRING
		do
			create Result.make_from_string ("  ")
		end

end
