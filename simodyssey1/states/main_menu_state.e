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

feature -- Out

	out: STRING
		do
			create Result.make_from_string ("  ")
			Result.append ("state:0., ok")
			Result.append ("%N")
			Result.append ("  ")
			Result.append (msg.initial_message)
		end

end
