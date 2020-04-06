note
	description: "Summary description for {QUADRANT}."
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

class
	QUADRANT

inherit

	ANY
		redefine
			is_equal
		end

create
	make_empty

feature {NONE} -- Constructor

	make_empty (c: COORDINATE)
			-- An instance of QUADRANT will be created with coordinate ~ c and will contain a null entity.
		do
			coordinate := c
			remove_entity
		end

feature -- Attribute

	entity: ENTITY -- entity contained within the quadrant

	coordinate: COORDINATE -- coordinate of the quadrant

feature -- Commands

	remove_entity
			-- "remove" entity by replacing entity with an instance of NULL_ENTITY.
		local
			ne: NULL_ENTITY
		do
			create ne.make (coordinate)
			entity := ne
		ensure
			is_empty
		end

	set_entity (e: ID_ENTITY)
			-- "set" entity by replacing entity with an instance of ID_ENTITY.
		do
			e.set_coordinate (coordinate)
			entity := e
		ensure
			not is_empty
			e.coordinate ~ coordinate
			has (e)
		end

feature -- Queries

	is_empty: BOOLEAN
			-- Return true if entity in quadrant is an instance of NULL_ENTITY.
			-- Return false otherwise.
		do
			Result := attached {NULL_ENTITY} entity
		end

	has (ie: ID_ENTITY): BOOLEAN
			-- Return true if "ie" is object equivelant to entity.
			-- Return false otherwise.
		do
			Result := ie ~ entity
		end

	is_equal (other: like Current): BOOLEAN
			-- Current "is equal" to other if current.coordinate ~ other.coordinate and current.entity ~ other.entity
		do
			if current.coordinate ~ other.coordinate then
				if not is_empty then
					if not other.is_empty then
						check attached {ID_ENTITY} entity as id_entity and then attached {ID_ENTITY} other.entity as o_id_entity then
							if id_entity ~ o_id_entity then
								Result := True
							else
								Result := False
							end
						end
					else
						Result := FALSE
					end
				elseif is_empty then
					if not other.is_empty then
						Result := FALSE
					else
						Result := TRUE
					end
				end
			else
				Result := FALSE
			end
		end

feature -- Out

	out_abstract: STRING
			-- If "is_empty", then Result ~ "-"
			-- If "not is_empty" Result takes the form of {ID_ENTITY}.out_sqr_bracket which looks like "[id, character]".ie "[2, P]"
		do
			create Result.make_empty
			if attached {ID_ENTITY} entity as id_entity then --
				Result.append (id_entity.out_sqr_bracket)
			else
				Result.append (entity.out)
			end
		end

	out_character: STRING
			-- Result ~ "Character" For example, "E" for EXPLORER or "-" for NULL_ENTITY
		do
			Result := entity.out
		end

invariant
	entity_coordinate_is_equivelant_to_coordinate: entity.coordinate ~ coordinate
	-- The entity.coordinate must always be equivelant to coordinate.

end
