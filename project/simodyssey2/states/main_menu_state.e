note
	description: "[
			A class that defines valid, and invalid user commands 
			for when the user is not in a game.
	]"
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

class
	MAIN_MENU_STATE

inherit

	STATE

create
	make

feature -- Controller command / queries

	abort, land, liftoff, pass, status, wormhole
			-- attempting to execute "abort, land, liftoff, pass, status, wormhole" commands of SIMODYSSEY while in MAIN_MENU_STATE and not PLAY_STATE,
			-- implies that preconditions of such commands in SIMODYSSEY are not met,
			-- therefore append "Negative on that request:no mission in progress." to "out"
		do
			abstract_state_numbers.executed_invalid_command
			set_msg_mode (msg.empty_string)
			set_msg_command_validity (msg.error)
			set_msg_content (msg.abort_error_no_mission)
		ensure then
			invalid_command_implies_remain_in_main_menu_state:(attached {MAIN_MENU_STATE} next_state)
		end

	move (d: COORDINATE)
			-- attempting to execute "move_explorer" command of SIMODYSSEY while in MAIN_MENU_STATE and not PLAY_STATE,
			-- implies that preconditions of {SIMODYSSEY}.move_explorer are not met,
			-- therefore append "Negative on that request:no mission in progress." to "out"
		do
			abstract_state_numbers.executed_invalid_command
			set_msg_mode (msg.empty_string)
			set_msg_command_validity (msg.error)
			set_msg_content (msg.move_error_no_mission)
		ensure then
			invalid_command_implies_remain_in_main_menu_state:(attached {MAIN_MENU_STATE} next_state)
		end

	play
		--  execute "new_game" command in SIMODYSSEY
		local
			s: STATE
		do
			game_model.new_game (3, 5, 7, 15, 30, FALSE)
			create {PLAY_STATE} s.make (game_model, abstract_state_numbers,msg.play,game_model.out)
			abstract_state_numbers.executed_valid_turn_command
			transition_to(s)
		ensure then
			enter_play_state: (attached {PLAY_STATE} next_state)
		end

	test (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold: INTEGER)
			-- if precondition for command "new_game" in SIMODYSSEY is not met,
			-- append "Thresholds should be non-decreasing order." to "out"
			-- if preconditions are met, execute "new_game" command in SIMODYSSEY
		local
			s:STATE
		do
			if game_model.valid_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold) then
				game_model.new_game (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold, TRUE)
				create {PLAY_STATE} s.make (game_model, abstract_state_numbers,msg.test,game_model.out)
				abstract_state_numbers.executed_valid_turn_command
				transition_to(s)
			else
				abstract_state_numbers.executed_invalid_command
				set_msg_mode (msg.empty_string)
				set_msg_command_validity (msg.error)
				set_msg_content (msg.test_error_threshold)
			end
		ensure then
			valid_thresholds_implies_enter_play_state: game_model.valid_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold) implies (attached {PLAY_STATE} next_state)
			invalid_thresholds_implies_remain_in_main_menu_state:(not game_model.valid_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold)) implies (attached {MAIN_MENU_STATE} next_state)

		end

end
