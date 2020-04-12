note
	description: "A class for generating unique entity ids."
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

class
	ID_DISPATCHER

create
	make

feature {NONE} -- Constructor

	make (a_initial_id: INTEGER; a_id_up: BOOLEAN)
		do
			initial_id := a_initial_id
			id_up := a_id_up
			current_id := initial_id
		end

feature -- Commands

	reset
			-- initialize "current_id" to "initial_id".
		do
			current_id := initial_id
		ensure
			current_id ~ initial_id
		end

	update_id
			-- if "id_up" equals true, current_id will be incremented by 1. current_id will be decremented by 1 otherwise.
		do
			if id_up then
				current_id := current_id + 1
			else
				current_id := current_id - 1
			end
		ensure
			case_where_get_id_is_incremented:id_up implies (current_id ~ (old current_id+1))
			case_where_get_id_is_decremented:(not id_up) implies (current_id ~ (old current_id-1))
		end

feature -- Attributes

	current_id: INTEGER
			-- the current id in integer value

	id_up: BOOLEAN
			-- determines the behavior of "update_id". See command "update_id" for more.

	initial_id: INTEGER
			-- first unique id returned by "current_id".
end
