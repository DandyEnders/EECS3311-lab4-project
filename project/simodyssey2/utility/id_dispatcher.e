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

	count_up: BOOLEAN

feature -- Command

	reset
		do
			count := start
		end

feature -- Queries

	get_id: INTEGER
		do
			Result := count
		end
	update_id
		do
			if count_up then
				count := count + 1
			else
				count := count - 1
			end
		ensure
			count_up implies (count ~ (old count+1))
			(not count_up) implies (count ~ (old count-1))
		end

feature -- Attributes

	count: INTEGER

end
