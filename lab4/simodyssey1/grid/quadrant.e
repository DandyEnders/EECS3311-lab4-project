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
			out,
			is_equal
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

feature -- Commands

	remove_entity
			-- "remove" entity by replacing entity with null entity.
		local
			ne: NULL_ENTITY
		do
			create ne.make (coordinate)
			entity := ne
		ensure
			is_empty
		end

	set_entity (e: ID_ENTITY)
			-- "set" entity by replacing an entity with an id entity.
		do
			e.set_coordinate (coordinate)
			entity := e
		ensure
			not is_empty
			has(e)
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

	is_equal (other: like Current): BOOLEAN
			-- is Current equal to other?
		do
			if current.coordinate ~ other.coordinate then
				if not is_empty then
					if not other.is_empty then
						check attached {ID_ENTITY} entity as id_entity and then attached {ID_ENTITY} other.entity as o_id_entity then
							if id_entity ~o_id_entity  then
								Result := True
							else
								Result := False
							end
						end
					else
						Result:=FALSE
					end
				elseif is_empty then
					if not other.is_empty then
						Result:=FALSE
					else
						Result:=TRUE
					end
				end
			else
				Result:=FALSE
			end
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
