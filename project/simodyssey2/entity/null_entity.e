note
	description: "Summary description for {NULL_ENTITY}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	NULL_ENTITY

inherit

	ENTITY

	ANY
		undefine
			out,
			is_equal
		end

create
	make

feature -- Attributes
	character: STRING = "-"

end
