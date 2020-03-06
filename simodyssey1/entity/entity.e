note
	description: "Summary description for {ENTITY}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY

inherit

	ANY
		redefine
			out,
			is_equal
		end

feature {NONE} -- Initialization

	make (a_coordinate: COORDINATE)
			-- Initialization for `Current'.
		do
			coordinate := a_coordinate
		end

feature -- Attributes

	character: STRING
		deferred
		end

	coordinate: COORDINATE

feature -- Queries

feature -- Commands

	set_coordinate (a_coordinate: COORDINATE)
		do
			coordinate := a_coordinate
		end

feature -- out

	out: STRING
		do
			create Result.make_empty
			Result.append (character);
		end

	is_equal (other: like current): BOOLEAN
		do
			Result := character ~ other.character
			and
			 coordinate ~ other.coordinate
		end

end
