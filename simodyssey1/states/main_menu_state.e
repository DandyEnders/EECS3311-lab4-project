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
			set_msg_mode("")
			set_msg_command_validity ("error")
			set_msg_content ("  " + msg.abort_error_no_mission)
		end

	move (d: COORDINATE)
		do
			abstract_state.executed_invalid_command
			set_msg_mode("")
			set_msg_command_validity ("error")
			set_msg_content ("  " + msg.abort_error_no_mission)
		end

	play
		do
			model.new_game (30, FALSE)
			create {PLAY_STATE} next_state.make(model, abstract_state)

			abstract_state.executed_turn_command
			next_state.set_msg_mode ("play")
			next_state.set_msg_command_validity ("ok")
			next_state.set_msg_content (model.out)
		end

	test (th: INTEGER)
		do
			model.new_game (th, TRUE)
			create {PLAY_STATE} next_state.make(model, abstract_state)

			abstract_state.executed_turn_command
			next_state.set_msg_mode ("test")
			next_state.set_msg_command_validity ("ok")
			next_state.set_msg_content (model.out)
		end

end
