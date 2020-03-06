note
	description: "Summary description for {PLANET}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	PLANET

inherit
	MOVEABLE_ENTITY

create
	make

feature -- Attributes

	turns_left: INTEGER -- TODO: might make it a class, and means of modification

	visited: BOOLEAN

	attached_to_star: BOOLEAN

	support_life: BOOLEAN

feature -- Queries

	death_message: STRING = "SET THIS TO DEATH MESSAGE"

	character: STRING = "P"


end
