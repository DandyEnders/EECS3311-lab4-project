note
	description: "Summary description for {MOVEABLE_ENTITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MOVEABLE_ENTITY

inherit
	ID_ENTITY

feature -- queries

	death_message: STRING
		deferred end

end
