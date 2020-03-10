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

	initialization
		do
			msg_command_validity := "ok"
			msg_content := "  " + msg.initial_message

		end

	abort, land, liftoff, pass, status, wormhole
		do
			executed_invalid_command
			msg_content := "  " + msg.abort_error_no_mission
		end

	move (d: COORDINATE)
		do
			executed_invalid_command
			msg_content := "  " + msg.abort_error_no_mission
		end

	play
		do
			executed_turn_command
			create {PLAY_STATE} next_state.make(model, abstract_state)
			model.new_game (30, FALSE)
			msg_content := model.out
		end

	test (th: INTEGER)
		do
			executed_turn_command
			model.new_game (th, TRUE)
			create {PLAY_STATE} next_state.make(model, abstract_state)
			msg_content := model.out
		end

end
