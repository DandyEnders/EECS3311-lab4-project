note
	description: "Summary description for {EXPLORER}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER

inherit

	MOVEABLE_ENTITY

create
	make

feature -- Attributes

	life: INTEGER -- TODO: might make it a class

	fuel: INTEGER -- TODO: might make it a class

	landed: BOOLEAN

feature -- Queries

	death_message: STRING = "SET THIS TO DEATH MESSAGE"

	character: STRING = "E"

end
