note
	description: "Summary description for {QUADRANT}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	QUADRANT

inherit
	ANY
		redefine
			out
		end

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
			-- "remove" entity by replacing entity with null entity.
		local
			ne: NULL_ENTITY
		do
			create ne.make(entity.coordinate)
			set_entity(ne)
		end

	set_entity (e: ENTITY)
		do
			entity := e
		end

feature -- Queries

	is_empty: BOOLEAN
			-- Return true if entity in quadrant is null entity.
			-- Return false otherwise.
		do
			Result := entity.same_type ({NULL_ENTITY})
		end

	has(ie: ID_ENTITY): BOOLEAN
			-- Return true if "ie" is entity.
			-- Return false otherwise.
		do
			Result := ie ~ entity
		end

feature -- Out

	out: STRING
		do
			Result := entity.out
		end

end
