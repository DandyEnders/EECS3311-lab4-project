note
	description: "Summary description for {QUADRANT}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	QUADRANT

create
	make,
	make_empty

feature {NONE} -- Constructor

	make(e: ENTITY)
		do
			set_entity(e)
		end

	make_empty(c: COORDINATE)
		do
			set_entity(create {NULL_ENTITY}.make(c))
		end

feature -- Attribute

	entity: ENTITY

feature -- Command

	remove_entity
		do
			entity := create {NULL_ENTITY}.make(entity.coordinate)
		end

	set_entity (e: ENTITY)
		do
			entity := e
		end

feature -- Queries

	is_empty: BOOLEAN
		do
			Result := entity.same_type ({NULL_ENTITY})
		end

feature

end
