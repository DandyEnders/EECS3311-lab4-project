note
	description: "[
			A class that defines valid, and invalid user commands 
			for when the user is in a game and the explorer 
			is landed.
	]"
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

class
	LANDED_STATE

inherit

	STATE

create
	make

feature -- Controller command / queries

	abort
			-- execute abort command in SYMODYSSEY, and append “Mission aborted. Try test(3,5,7,15,30)” to "out"
		local
			s: STATE
		do
			game_model.abort
			create {MAIN_MENU_STATE} s.make (game_model, abstract_state_numbers,msg.empty_string,msg.abort)
			abstract_state_numbers.executed_no_turn_command
			transition_to(s)
		ensure then
			enter_main_menu_state: (attached {MAIN_MENU_STATE} next_state)
		end

	land
			-- attempting to execute "land_explorer" command of SIMODYSSEY while in LANDED_STATE and not PLAY_STATE,
			-- implies that preconditions of {SIMODYSSEY}. land_explorer are not met,
			-- therefore append "Negative on that request:you are currently landed at Sector:X:Y" to "out"
		local
			c: COORDINATE
		do
			c := game_model.explorer_coordinate
			abstract_state_numbers.executed_no_turn_command
			set_msg_command_validity (msg.error)
			set_msg_content (msg.land_error_landed_already (c.row, c.col))
		ensure then
			invalid_command_implies_remain_in_landed_state: (attached {LANDED_STATE} next_state)
		end

	liftoff
			-- execute abort command in SYMODYSSEY
			-- if not {SIMOSYSSEY}.explorer_alive, append one of Abstract State: Death Messages EXPLORER [3 to 4] to "out"
		local
			s_tmp: STRING
			c: COORDINATE
			s: STATE
		do
			c := game_model.explorer_coordinate
			game_model.liftoff_explorer
			abstract_state_numbers.executed_valid_turn_command
			create s_tmp.make_empty
			if game_model.explorer_is_alive then
				s_tmp.append (msg.liftoff (c.row, c.col))
				s_tmp.append ("%N")
				s_tmp.append (game_model.out)
				create {PLAY_STATE} s.make (game_model, abstract_state_numbers,msg_mode,s_tmp)
				transition_to(s)
			else
				set_explorer_death_message
			end
		ensure then
			if_explorer_is_dead_enter_main_menu_state: (not game_model.explorer_is_alive) implies (attached {MAIN_MENU_STATE} next_state)
			if_explorer_is_alive_enter_play_state: (game_model.explorer_is_alive) implies (attached {PLAY_STATE} next_state)
		end

	move (d: COORDINATE)
			-- attempting to execute "move_explorer" command of SIMODYSSEY while in LANDED_STATE and not PLAY_STATE,
			-- implies that preconditions of {SIMODYSSEY}.move_explorer are not met,
			-- therefore append "Negative on that request:you are currently landed at Sector:X:Y" to "out"
		local
			c: COORDINATE
		do
			c := game_model.explorer_coordinate
			abstract_state_numbers.executed_no_turn_command
			set_msg_command_validity (msg.error)
			set_msg_content (msg.move_error_landed (c.row, c.col))
		ensure then
			invalid_command_implies_remain_in_landed_state: (attached {LANDED_STATE} next_state)
		end

	pass
			-- execute "pass" command in SIMODYSSEY
		do
			game_model.pass
			abstract_state_numbers.executed_valid_turn_command
			set_msg_command_validity (msg.ok)
			set_msg_content (game_model.out)
		ensure then
			remain_in_landed_state: (attached {LANDED_STATE} next_state)
		end

	play
			-- attempting to execute "new_game" command of SIMODYSSEY while in LANDED_STATE and not MAIN_MENU_STATE,
			-- implies that preconditions of {SIMODYSSEY}.new_game are not met,
			-- therefore append "To start a new mission, please abort the current one first." to "out"
		do
			abstract_state_numbers.executed_no_turn_command
			set_msg_command_validity (msg.error)
			set_msg_content (msg.play_error_no_mission)
		ensure then
			invalid_command_implies_remain_in_landed_state: (attached {LANDED_STATE} next_state)
		end

	status
			-- append "Negative on that request:already landed on a planet at Sector:X:Y" to "out"
		do
			abstract_state_numbers.executed_no_turn_command
			set_msg_command_validity (msg.ok)
			set_msg_content (game_model.out_status_explorer)
		ensure then
			remain_in_landed_state: (attached {LANDED_STATE} next_state)
		end

	test (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold: INTEGER)
			-- attempting to execute "new_game" command of SIMODYSSEY while in LANDED_STATE and not MAIN_MENU_STATE,
			-- implies that preconditions of {SIMODYSSEY}.new_game are not met,
			-- therefore append "To start a new mission, please abort the current one first." to "out"
		do
			abstract_state_numbers.executed_no_turn_command
			set_msg_command_validity (msg.error)
			set_msg_content (msg.test_error_no_mission)
		ensure then
			invalid_command_implies_remain_in_landed_state: (attached {LANDED_STATE} next_state)
		end

	wormhole
			-- attempting to execute "wormhole_explorer" command of SIMODYSSEY while in LANDED_STATE and not PLAY_STATE,
			-- implies that preconditions of {SIMODYSSEY}.wormhole_explorer are not met,
			-- therefore append "Negative on that request:you are currently landed at Sector:X:Y" to "out"
		local
			c: COORDINATE
		do
			c := game_model.explorer_coordinate
			abstract_state_numbers.executed_no_turn_command
			set_msg_command_validity (msg.error)
			set_msg_content (msg.wormhole_error_landed (c.row, c.col))
		ensure then
			invalid_command_implies_remain_in_landed_state: (attached {LANDED_STATE} next_state)
		end

end
