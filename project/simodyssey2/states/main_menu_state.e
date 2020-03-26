note
	description: "Summary description for {MAIN_MENU_STATE}."
	author: "Jinho Hwang"
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
		do
			abstract_state.executed_invalid_command
			set_msg_mode (msg.empty_string)
			set_msg_command_validity (msg.error)
			set_msg_content (msg.abort_error_no_mission)
		end

	move (d: COORDINATE)
		do
			abstract_state.executed_invalid_command
			set_msg_mode (msg.empty_string)
			set_msg_command_validity (msg.error)
			set_msg_content (msg.move_error_no_mission)
		end

	play
		do
			model.new_game (3, 5, 7, 15, 30, FALSE)
			create {PLAY_STATE} next_state.make (model, abstract_state)
			abstract_state.executed_turn_command
			next_state.set_msg_mode (msg.play)
			next_state.set_msg_command_validity (msg.ok)
			next_state.set_msg_content (model.out)
		end

	test (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold: INTEGER)
		do
			if model.valid_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold) then
				model.new_game (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold, TRUE)
				create {PLAY_STATE} next_state.make (model, abstract_state)
				abstract_state.executed_turn_command
				next_state.set_msg_mode (msg.test)
				next_state.set_msg_command_validity (msg.ok)
				next_state.set_msg_content (model.out)
			else
				abstract_state.executed_invalid_command
				set_msg_mode (msg.empty_string)
				set_msg_command_validity (msg.error)
				set_msg_content (msg.test_error_threshold)
			end
		end

end
