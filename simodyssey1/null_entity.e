note
	description: "Summary description for {NULL_ENTITY}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	NULL_ENTITY

inherit

	ENTITY
		redefine
			is_equal
		end

	ANY
		redefine
			is_equal
		end

create
	make

feature -- constructor
	make(c: COORDINATE)
		do
			coordinate := c
		end

feature -- attributes

	character: STRING = "-"

feature -- queries

	is_equal (other: like current): BOOLEAN
		do
			Result := other.conforms_to (current)
		end

feature -- commands

end
