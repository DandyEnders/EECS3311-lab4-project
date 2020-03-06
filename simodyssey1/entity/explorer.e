note
	description: "Summary description for {EXPLORER}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER

inherit

	MOVEABLE_ENTITY
		rename
			make as moveable_make
		end

create
	make

feature {NONE} -- Constructor

	make(a_coordinate:COORDINATE; a_id: INTEGER)
		do
			moveable_make(a_coordinate, a_id)
			life := 3
			fuel := 3
			landed := false
		end

feature -- Attributes

	life: INTEGER -- TODO: might make it a class

	fuel: INTEGER -- TODO: might make it a class

	landed: BOOLEAN

feature -- Queries

	death_message: STRING = "SET THIS TO DEATH MESSAGE"

	character: STRING = "E"

end
