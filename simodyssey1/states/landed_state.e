note
	description: "Summary description for {LANDED_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LANDED_STATE

inherit
	STATE

create
	make

feature -- Controller command / queries

	initialization
		do
			model.land_explorer
			if model.is_landsite_has_life then
				create {MAIN_MENU_STATE} next_state.make(model, abstract_state)
				next_state.set_msg_content("  Tranquility base here - we've got a life!")
			end

			msg_content := "  landed"
		end

	abort
		do

		end

	land
		do

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
