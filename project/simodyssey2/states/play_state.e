note
	description: "[
		A class that defines valid, and invalid user commands 
		for when the user is in a game, and the explorer is not landed.
	]"
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

class
	PLAY_STATE

inherit

	STATE

create
	make

feature -- Commands

	abort
			-- execute abort command in SYMODYSSEY, and append “Mission aborted. Try test(3,5,7,15,30)” to "out"
		local
			s: STATE
		do
			game_model.abort_game
			abstract_state_numbers.executed_no_turn_command
			create {MAIN_MENU_STATE} s.make (game_model, abstract_state_numbers, msg.empty_string, msg.abort)
			transition_to (s)
		ensure then
			enter_main_menu_state: attached {MAIN_MENU_STATE} next_state
		end

	land
			-- if precondition for command "land_explorer" in SIMODYSSEY is not met,
			-- append one of Abstract State: Error Messages LAND [3 to 5] to "out"
			-- if land precondition in SIMODYSSEY is met, execute land in SIMODYSSEY.
			-- after succesfully executing "land_explorer", if "{SIMODYSSEY}.explorer_found_life", append “Tranquility base here - we've got a life!” to "out"
			-- after succesfully executing "land_explorer", if "not {SIMODYSSEY}.explorer_found_life", append “Explorer found no life as we know it at Sector:X:Y” to "out"
		local
			c: COORDINATE
			tmp_str: STRING
			s: STATE
		do
				-- model.explorer is in a sector with planet and yellow dwarf
			if game_model.explorer_sector_is_landable then
				game_model.land_explorer
				abstract_state_numbers.executed_valid_turn_command
				if game_model.explorer_found_life then
					create {MAIN_MENU_STATE} s.make (game_model, abstract_state_numbers, msg_mode, msg.land_life_found)
				else -- landed in no life planet
					c := game_model.explorer_coordinate
					create tmp_str.make_from_string (msg.land_life_not_found (c.row, c.col))
					tmp_str.append ("%N")
					tmp_str.append (game_model.out)
					create {LANDED_STATE} s.make (game_model, abstract_state_numbers, msg_mode, tmp_str)
				end
				transition_to (s)
			else
				abstract_state_numbers.executed_invalid_command
				set_msg_command_validity (msg.error)
				create tmp_str.make_empty
				if not game_model.explorer_sector_has_yellow_dwarf then
					tmp_str.append (msg.land_error_no_yellow_dwarf (game_model.explorer_coordinate.row, game_model.explorer_coordinate.col))
				elseif not game_model.explorer_sector_has_planets then
					tmp_str.append (msg.land_error_no_planets (game_model.explorer_coordinate.row, game_model.explorer_coordinate.col))
				elseif not game_model.explorer_sector_has_unvisted_attached_planets then
					tmp_str.append (msg.land_error_no_visited_planets (game_model.explorer_coordinate.row, game_model.explorer_coordinate.col))
				end
				set_msg_content (tmp_str)
			end
		ensure then
			if_explorer_is_not_landed_remain_in_play_state: ((not game_model.explorer_is_landed) implies (attached {PLAY_STATE} next_state))
			if_explorer_is_landed_and_explorer_did_not_find_life_enter_landed_state: (((game_model.explorer_is_landed) and (not game_model.explorer_found_life)) implies (attached {LANDED_STATE} next_state))
			if_explorer_is_landed_and_explorer_did_found_life_enter_main_menu_state: (((game_model.explorer_is_landed) and (game_model.explorer_found_life)) implies (attached {MAIN_MENU_STATE} next_state))
		end

	liftoff
			-- attempting to execute "liftoff_explorer" command of SIMODYSSEY while in PLAY_STATE and not LANDED_STATE,
			-- implies that preconditions of {SIMODYSSEY}.liftoff are not met,
			-- therefore append "Negative on that request:you are not on a planet at Sector:X:Y" to "out"
		local
			c: COORDINATE
		do
			c := game_model.explorer_coordinate
			abstract_state_numbers.executed_invalid_command
			set_msg_command_validity (msg.error)
			set_msg_content (msg.liftoff_error_not_on_planet (c.row, c.col))
		ensure then
			invalid_command_implies_remain_in_play_state: (attached {PLAY_STATE} next_state)
		end

	move (d: COORDINATE)
			-- if precondition for command "move_explorer" in SIMODYSSEY is not met,
			-- append "Cannot transfer to new location as it is full." to "out"
			-- if preconditions are met, execute "move_explorer" command in SIMODYSSEY.
			-- if explorer dies after succesffuly moving, append one of Abstract State: Death Messages EXPLORER [1 to 4] to "out"
		do
			if not game_model.sector_in_explorer_direction_is_full (d) then
				game_model.move_explorer (d)
				abstract_state_numbers.executed_valid_turn_command
				if game_model.explorer_is_alive then
					set_msg_command_validity (msg.ok)
					set_msg_content (game_model.out)
				else
					set_explorer_death_message
				end
			else -- model.sector_in_direction_is_full (d) or not model.game_in_session
				if game_model.sector_in_explorer_direction_is_full (d) then
					abstract_state_numbers.executed_invalid_command
					set_msg_command_validity (msg.error)
					set_msg_content (msg.move_error_sector_full)
				end
			end
		ensure then
			if_explorer_is_alive_after_succesfully_moving_remain_in_play_state: (game_model.explorer_is_alive) implies (attached {PLAY_STATE} next_state)
			if_explorer_is_dead_after_succesfully_moving_enter_in_main_menu_state: (not game_model.explorer_is_alive) implies (attached {MAIN_MENU_STATE} next_state)
		end

	pass
			-- execute "pass" command in SIMODYSSEY
			-- if explorer dies after succesffuly passing, append one of Abstract State: Death Messages EXPLORER [3 to 4] to "out"
		do
			game_model.pass_explorer_turn
			abstract_state_numbers.executed_valid_turn_command
			set_msg_command_validity (msg.ok)
			if game_model.explorer_is_alive then
				set_msg_content (game_model.out)
			else
				set_explorer_death_message
			end
		ensure then
			if_not_dead_remain_in_play_state: (game_model.explorer_is_alive) implies (attached {PLAY_STATE} next_state)
			if_dead_enter_main_menu_state: (not game_model.explorer_is_alive) implies (attached {MAIN_MENU_STATE} next_state)
		end

	play
			-- attempting to execute "new_game" command of SIMODYSSEY while in PLAY_STATE and not MAIN_MENU_STATE,
			-- implies that preconditions of {SIMODYSSEY}.new_game are not met,
			-- therefore append "To start a new mission, please abort the current one first." to "out"
		do
			abstract_state_numbers.executed_invalid_command
			set_msg_command_validity (msg.error)
			set_msg_content (msg.play_error_no_mission)
		ensure then
			invalid_command_implies_remain_in_play_state: (attached {PLAY_STATE} next_state)
		end

	status
			-- append “Explorer status report:Travelling at cruise speed at [X,Y,Z] Life units left:V, Fuel units left:W” to "out"
		do
			game_model.status_of_explorer
			abstract_state_numbers.executed_no_turn_command
			set_msg_command_validity (msg.ok)
			set_msg_content (game_model.out_status_explorer)
		ensure then
			status_should_not_change_the_state: (attached {PLAY_STATE} next_state)
		end

	test (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold: INTEGER)
			-- attempting to execute "new_game" command of SIMODYSSEY while in PLAY_STATE and not MAIN_MENU_STATE,
			-- implies that preconditions of {SIMODYSSEY}.new_game are not met,
			-- therefore append "To start a new mission, please abort the current one first." to "out"
		do
			abstract_state_numbers.executed_invalid_command
			set_msg_command_validity (msg.error)
			set_msg_content (msg.test_error_no_mission)
		ensure then
			invalid_command_implies_remain_in_play_state: (attached {PLAY_STATE} next_state)
		end

	wormhole
			-- if precondition for command "wormhole_explorer" in SIMODYSSEY is not met,
			-- append "Explorer couldn't find wormhole at Sector:X:Y" to "out"
			-- if preconditions are met, execute "wormhole_explorer" command in SIMODYSSEY.
			-- if explorer dies after succesffuly wormhole-ing, append one of Abstract State: Death Messages EXPLORER [1 to 4] to "out"
		local
			c: COORDINATE
		do
			c := game_model.explorer_coordinate
			if game_model.explorer_sector_has_wormhole then
				game_model.wormhole_explorer
				abstract_state_numbers.executed_valid_turn_command
				if game_model.explorer_is_alive then
					set_msg_command_validity (msg.ok)
					set_msg_content (game_model.out)
				else
					set_explorer_death_message
				end
			else
				if not game_model.explorer_sector_has_wormhole then
					abstract_state_numbers.executed_invalid_command
					set_msg_command_validity (msg.error)
					c := game_model.explorer_coordinate
					set_msg_content (msg.wormhole_error_explorer_not_found_wormhole (c.row, c.col))
				end
			end
		ensure then
			Explorer_is_alive_after_successful_wormhole_implies_remain_in_play_state: (game_model.explorer_is_alive) implies (attached {PLAY_STATE} next_state)
			Explorer_is_dead_after_successful_wormhole_implies_enter_main_menu_state: ((not game_model.explorer_is_alive)) implies (attached {MAIN_MENU_STATE} next_state)
		end

end
