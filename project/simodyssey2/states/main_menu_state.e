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
		ensure then
			invalid_command_implies_remain_in_main_menu_state:(attached {MAIN_MENU_STATE} next_state)
			model_does_remain_the_same: model ~ old model
		end

	move (d: COORDINATE)
		do
			abstract_state.executed_invalid_command
			set_msg_mode (msg.empty_string)
			set_msg_command_validity (msg.error)
			set_msg_content (msg.move_error_no_mission)
		ensure then
			invalid_command_implies_remain_in_main_menu_state:(attached {MAIN_MENU_STATE} next_state)
			model_does_remain_the_same: model ~ old model
		end

	play
		do
			model.new_game (3, 5, 7, 15, 30, FALSE)
			create {PLAY_STATE} next_state.make (model, abstract_state)
			abstract_state.executed_valid_turn_command
			next_state.set_msg_mode (msg.play)
			next_state.set_msg_command_validity (msg.ok)
			next_state.set_msg_content (model.out)
		ensure then
			enter_play_state: (attached {PLAY_STATE} next_state)
			model_does_not_remain_the_same: model /~ old model
		end

	test (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold: INTEGER)
		do
			if model.valid_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold) then
				model.new_game (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold, TRUE)
				create {PLAY_STATE} next_state.make (model, abstract_state)
				abstract_state.executed_valid_turn_command
				next_state.set_msg_mode (msg.test)
				next_state.set_msg_command_validity (msg.ok)
				next_state.set_msg_content (model.out)
			else
				abstract_state.executed_invalid_command
				set_msg_mode (msg.empty_string)
				set_msg_command_validity (msg.error)
				set_msg_content (msg.test_error_threshold)
			end
		ensure then
			valid_thresholds_implies_enter_play_state: model.valid_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold) implies (attached {PLAY_STATE} next_state)
			if_valid_thresholds_implies_model_does_not_remain_the_same: (model.valid_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold)) implies (model /~ old model)
			invalid_thresholds_implies_remain_in_main_menu_state:(not model.valid_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold)) implies (attached {MAIN_MENU_STATE} next_state)
			if_invalid_thresholds_implies_model_remains_the_same: (not model.valid_thresholds (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold)) implies (model ~ old model)
		end

end
