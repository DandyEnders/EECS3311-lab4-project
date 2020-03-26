note
	description: "Summary description for {ABSTRACT_STATE}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	ABSTRACT_STATE

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

		-- First number is incremented by one after executing a valid command
		-- that constitutes a turn or after a valid play or test command.

	first_number: INTEGER

		-- Second number is incremented if the command is invalid or it doe not
		-- constitudes a turn.

	second_number: INTEGER

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

feature -- Command

	executed_turn_command
		do
			increment_first_number
		end

	executed_invalid_command
		do
			increment_second_number
		end

	executed_no_turn_command
		do
			increment_second_number
		end

feature -- Queries

	out: STRING -- "state:12.3"
		do
			create Result.make_empty
			Result.append ("state:")
			Result.append (first_number.out)
			Result.append (".")
			Result.append (second_number.out)
		end

end
