note
	description: "Summary description for {ID_DISPATCHER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ID_DISPATCHER

create
	make

feature {NONE} -- Constructor

	make (a_start: INTEGER; a_count_up: BOOLEAN)
		do
			start := a_start
			count_up := a_count_up
			count := start
		end

feature {NONE} -- Attribute

	start: INTEGER

	count: INTEGER

	count_up: BOOLEAN

feature -- Command

	reset
		do
			count := start
		end

feature -- Queries

	get_id: INTEGER -- command query seperation principle is broken
		do
			Result := count
			if count_up then
				count := count + 1
			else
				count := count - 1
			end
		end

end
