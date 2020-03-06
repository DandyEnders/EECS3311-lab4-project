note
	description: "Summary description for {ID_ENTITY}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ID_ENTITY

inherit
	ENTITY
		rename
			make as make_entity
		redefine
			is_equal
		end

feature {NONE} -- Initialization

	make(a_coordinate:COORDINATE; a_id: INTEGER)
			-- Initialization for `Current'.
		do
			make_entity(a_coordinate)
			id := a_id
		end

feature -- Attribute
	id: INTEGER

feature -- Queries

	is_equal (other: like current): BOOLEAN
		do
			Result := coordinate ~ other.coordinate and character ~ other.character
			and
			 id ~ other.id
		end

end
