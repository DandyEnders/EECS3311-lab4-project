note
	description: "Summary description for {PLAY_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAY_STATE

inherit
	STATE

create
	make

feature -- Controller command / queries

	initialization
		do
			model.new_game (30)

			msg_mode := "play"
			msg_command_validity := "ok"
			msg_content := model.out_movement
			msg_content.append("%N")
			msg_content.append(model.out_grid)
		end

	abort
		do
			executed_turn_command
			create {MAIN_MENU_STATE} next_state.make(model, abstract_state)
		end

	land
		do
			-- TODO
		end

	liftoff
		do

		end

	move (d: INTEGER)
		do

		end

	pass
		do

		end

	play
		do
		end

	status
		do
		end

	test (th: INTEGER)
		do
		end

	wormhole
		do
		end

end
