note
	description: "[
		A class to represent the absence of an ENTITY. 
		
		Secret: 
		(see QUADRANT secret).
	]"
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

create {QUADRANT}
	make

feature {QUADRANT}

	make (a_coordinate: COORDINATE)
		do
			entity_make (a_coordinate, '-')
		end

end
