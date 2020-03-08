note
	description: "Summary description for {STATE}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STATE

inherit

	ANY
		undefine
			out
		end

feature -- Constructor

	make (c: SIMODYSSEY)
		do
			set_context (c)
		end

feature {STATE} -- Attribute

	context: SIMODYSSEY

	msg: MESSAGE

feature -- Commands

	set_context (c: SIMODYSSEY)
		do
			context := c
		end

feature -- Queries

feature -- Controller command / queries

	abort
		deferred
		end

	land
		deferred
		end

	liftoff
		deferred
		end

	move (d: INTEGER)
		deferred
		end

	pass
		deferred
		end

	play
		deferred
		end

	status
		deferred
		end

	test (th: INTEGER)
		deferred
		end

	wormhole
		deferred
		end

feature -- Out

	out: STRING
		deferred
		end

end
