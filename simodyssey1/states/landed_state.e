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
			msg_content := "  " + msg.initial_message
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
