note
	description: "Summary description for {NULL_ENTITY}."
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

class
	NULL_ENTITY

inherit

	ENTITY
		rename
			make as entity_make
		end

	ANY
		undefine
			out,
			is_equal
		end

create
	make

feature	{NONE}
	make(a_coordinate: COORDINATE)
		do
			entity_make(a_coordinate,'-')
		end

end
