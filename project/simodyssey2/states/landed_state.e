note
	description: "Summary description for {LANDED_STATE}."
	author: "Jinho Hwang"
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
		do
			model.abort
			create {MAIN_MENU_STATE} next_state.make (model, abstract_state)

			abstract_state.executed_no_turn_command
			next_state.set_msg_mode (msg.empty_string)
			next_state.set_msg_command_validity (msg.ok)
			next_state.set_msg_content (msg.abort)
		end

	land
		local
			c: COORDINATE
		do
			c := model.explorer_coordinate

			abstract_state.executed_no_turn_command
			next_state.set_msg_mode (msg_mode)
			next_state.set_msg_command_validity (msg.error)
			next_state.set_msg_content (msg.land_error_landed_already (c.row, c.col))

		end

	liftoff
		local
			s_tmp:STRING
			c: COORDINATE
		do
			c := model.explorer_coordinate

			model.liftoff
			create {PLAY_STATE} next_state.make (model, abstract_state)

			abstract_state.executed_turn_command
			next_state.set_msg_mode(msg_mode)
			next_state.set_msg_command_validity (msg.ok)

			create s_tmp.make_empty
			s_tmp.append (msg.liftoff (c.row, c.col))
			s_tmp.append ("%N")
			s_tmp.append (model.out)
			next_state.set_msg_content (s_tmp)
		end

	move (d: COORDINATE)
		local
			c: COORDINATE
		do
			c := model.explorer_coordinate

			abstract_state.executed_no_turn_command
			next_state.set_msg_mode (msg_mode)
			next_state.set_msg_command_validity (msg.error)
			next_state.set_msg_content (msg.move_error_landed (c.row, c.col))

		end

	pass
		do
			model.pass
			abstract_state.executed_turn_command
			set_msg_mode(msg_mode)
			set_msg_command_validity (msg.ok)
			set_msg_content (model.out)
		end

	play
		do
			abstract_state.executed_no_turn_command
			next_state.set_msg_mode (msg_mode)
			next_state.set_msg_command_validity (msg.error)
			next_state.set_msg_content (msg.play_error_no_mission)
		end

	status
		do
			abstract_state.executed_no_turn_command
			set_msg_mode(msg_mode)
			set_msg_command_validity (msg.ok)
			set_msg_content (model.out_status_explorer)
		end

	test (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold: INTEGER)
		do
			abstract_state.executed_no_turn_command
			next_state.set_msg_mode (msg_mode)
			next_state.set_msg_command_validity (msg.error)
			next_state.set_msg_content (msg.test_error_no_mission)
		end

	wormhole
		local
			c: COORDINATE
		do
			c := model.explorer_coordinate

			abstract_state.executed_no_turn_command
			next_state.set_msg_mode (msg_mode)
			next_state.set_msg_command_validity (msg.error)
			next_state.set_msg_content (msg.wormhole_error_landed (c.row, c.col))
		end

end
