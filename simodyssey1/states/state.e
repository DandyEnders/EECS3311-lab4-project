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

	make(m: SIMODYSSEY; abs_s: ABSTRACT_STATE)
		do
			model := m
			abstract_state := abs_s

			create msg_mode.make_empty
			create msg_command_validity.make_empty
			create msg_content.make_empty

			next_state := current
			initialization
		end

feature {STATE} -- Attribute

	model: SIMODYSSEY

	msg: MESSAGE

	abstract_state: ABSTRACT_STATE

feature {STATE} -- Message attribute

	-- "  {abstract_state.out}{, msg_mode}{, msg_command_validity}{%Nmsg_content}
	-- example
	--

	msg_mode: STRING

	msg_command_validity: STRING

	msg_content: STRING

feature -- Commands

	executed_valid_command
		do
			abstract_state.executed_valid_command
			msg_command_validity := "ok"
		end

	executed_turn_command
		do
			abstract_state.executed_turn_command
			msg_command_validity := "ok"
		end

	executed_invalid_command
		do
			abstract_state.executed_invalid_command
			msg_command_validity := "error"
		end

	executed_no_turn_command
		do
			abstract_state.executed_no_turn_command
			msg_command_validity := "error"
		end

feature -- Queries

	next_state: STATE

feature -- Controller command / queries

	initialization
		deferred
		end

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
		do
			create Result.make_from_string ("  ")
			Result.append (abstract_state.out)
			if not msg_mode.is_empty then
				Result.append (", mode:")
				Result.append (msg_mode)
			end
			Result.append (", ")
			Result.append (msg_command_validity)
			Result.append ("%N")
			Result.append (msg_content)
		end

end
