note
	description: "[
		A container for storing an ENTITY in a SECTOR
		
		Secret: 
		QUADRANT. “is_empty” = true, implies “entity”
		attribute refers to a NULL_ENTITY.
	]"
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
		local
			ne: NULL_ENTITY
		do
			coordinate := c
			create ne.make (coordinate)
			entity := ne
		end

feature -- Attribute

	entity: ENTITY
		-- entity contained

	coordinate: COORDINATE
		-- coordinate of the QUADRANT

feature -- Commands

	remove_entity
			-- remove entity's current refference
		require
			cannot_remove_a_stationary_entity: not (attached {STATIONARY_ENTITY} entity)
		local
			ne: NULL_ENTITY
		do
			create ne.make (coordinate)
			entity := ne
		ensure
			is_empty
		end

	set_entity (e: ID_ENTITY)
			-- replace entity's current refference with e.
		require
			stationary_entities_cannot_change_coordinate: attached {STATIONARY_ENTITY} e implies e.coordinate ~ coordinate
		do
			if attached {MOVEABLE_ENTITY} e as me then
				me.set_coordinate (coordinate)
			end
			entity := e
		ensure
			not is_empty
			e.coordinate ~ coordinate
			has (e)
		end

feature -- Queries

	is_empty: BOOLEAN
			-- does QUADRANT contain an ENTITY?
		do
			Result := attached {NULL_ENTITY} entity
		end

	has (ie: ID_ENTITY): BOOLEAN
			-- does QUADRANT contain ie?
		do
			Result := ie ~ entity
		end

	is_equal (other: like Current): BOOLEAN
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
			-- if is_empty, then result -> "-"
			-- if not is_empty, then result -> "[id, character]"
		do
			create Result.make_empty
			if attached {ID_ENTITY} entity as id_entity then --
				Result.append (id_entity.out_sqr_bracket)
			else
				Result.append (entity.out)
			end
		end

	out_character: STRING
			-- Result -> "entity.out"
		do
			Result := entity.out
		end

invariant
	entity_coordinate_is_equivelant_to_quadrant_coordinate: entity.coordinate ~ coordinate

end
