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
	make_empty

feature {NONE} -- Constructor

	make_empty (c: COORDINATE)
		do
			coordinate := c
			remove_entity
		end

feature -- Attribute

	entity: ENTITY

	coordinate: COORDINATE

feature -- Command

	remove_entity
			-- "remove" entity by replacing entity with null entity.
		local
			ne: NULL_ENTITY
		do
			create ne.make (coordinate)
			entity := ne
		end

	set_entity (e: ID_ENTITY)
		do
			e.set_coordinate (coordinate)
			entity := e
		end

feature -- Queries

	is_empty: BOOLEAN
			-- Return true if entity in quadrant is null entity.
			-- Return false otherwise.
		do
			Result := attached {NULL_ENTITY} entity -- (create {NULL_ENTITY}.make (coordinate)) ~ (entity)
		end

	has (ie: ID_ENTITY): BOOLEAN
			-- Return true if "ie" is entity.
			-- Return false otherwise.
		do
			Result := ie ~ entity
		end

feature -- Out

	out_abstract: STRING -- "[id, character]" -> "[2, P]", "-"
		do
			create Result.make_empty
			if attached {ID_ENTITY} entity as id_entity then -- "[2, P]"
				Result.append (id_entity.out_sqr_bracket)
			else -- "-"
				Result.append (entity.out)
			end
		end

	out: STRING
		do
			Result := entity.out
		end

invariant
	entity.coordinate ~ coordinate

end
