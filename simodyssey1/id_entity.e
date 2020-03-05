note
	description: "Summary description for {ID_ENTITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ID_ENTITY

inherit
	ENTITY
		rename
			make as make_entity
		end

feature {NONE} -- Initialization

	make(a_coordinate:COORDINATE; a_id: INTEGER)
			-- Initialization for `Current'.
		do
			make_entity(a_coordinate)
			id := a_id
		end

feature
	id: INTEGER

end
