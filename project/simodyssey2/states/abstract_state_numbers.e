note
	description: "[
		A class to manage the first and second number
		as seen in the user output “e.g state: 3.1”.
	]"
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

class
	ABSTRACT_STATE_NUMBERS

inherit

	ANY
		redefine
			out
		end

create
	make

feature {NONE} -- Constructor

	make
		do
			first_number := 0
			second_number := 0
		end

feature -- Attibute

	first_number: INTEGER
			-- first number as seen in ie. state: 3.0
			-- signifies the number of valid turn/play/test commands executed during the course of the program.
			-- incremented by one after a valid turn command is executed in a subclass of STATE. ie state: 3.0 -> state: 4.0

	second_number: INTEGER
			-- second number as seen in ie. state: 3.2
			-- signifies the number of valid non-turn commands executed and invalid commands attempted after the last successful turn/play/test command was executed.
			-- incremented by one after valid non-turn commands are executed or invalid commands are attempted by a subclass of STATE. ie
			-- initialized to zero after a valid turn command is exectured in a subclass of STATE. ie state: 3.4 -> state: 4.0

feature {NONE} -- Private Command

	increment_first_number
		do
			first_number := first_number + 1
			second_number := 0
		end

	increment_second_number
		do
			second_number := second_number + 1
		end

feature {STATE} -- Command

	executed_valid_turn_command
			-- to be called after executing a valid turn command.
			-- increments "first_number" by one and initializes "second_number" to zero.
		do
			increment_first_number
		ensure
			first_number ~ (old first_number +1)
			second_number ~ 0
		end

	executed_invalid_command
			-- to be called after executing a valid turn command.
			-- increments "first_number" by one and initializes "second_number" to zero.
		do
			increment_second_number
		ensure
			second_number ~ (old second_number +1)
		end

	executed_no_turn_command
		do
			increment_second_number
		ensure
			second_number ~ (old second_number +1)
		end

feature -- Queries

	out: STRING -- output first_number and second_number into a form like "state:12.3"
		do
			create Result.make_empty
			Result.append ("state:")
			Result.append (first_number.out)
			Result.append (".")
			Result.append (second_number.out)
		end

end
