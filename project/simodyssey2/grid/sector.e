note
	description: "[
		A collection of QUADRANT objects arranged in a LIST.
		
		Secret:
		The collection of QUADRANT is stored in an 
		ARRAYED_LIST.
	]"
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

class
	SECTOR

inherit

	ANY
		redefine
			is_equal
		end

	ITERABLE [QUADRANT]
		redefine
			is_equal
		end

create
	make_empty

feature {NONE} -- Constructor

	make_empty (a_coordinate: COORDINATE; num_quadrants: INTEGER)
			-- an instance of SECTOR will be created at coordinate ~ a_coordinate, with max_num_quadrants = num_quadrants
		local
			i: INTEGER
		do
			coordinate := a_coordinate
			max_num_quadrants := num_quadrants
			create implementation.make (max_num_quadrants)
			implementation.compare_objects
			from
				i := 1
			until
				i > max_num_quadrants
			loop
				implementation.force (create {QUADRANT}.make_empty (coordinate))
				i := i + 1
			end
		end

feature {NONE} --Attributes

	implementation: ARRAYED_LIST [QUADRANT]

feature -- Attributes

	coordinate: COORDINATE
			-- coordinate of the SECTOR

	max_num_quadrants: INTEGER
			-- maximum number of quadrants the SECTOR can occupy

feature -- Commands

	remove (me: MOVEABLE_ENTITY)
			--remove me from the SECTOR. note: only MOVEABLE_ENTITY can be removed once added.
		require
			has (me)
		local
			removed: BOOLEAN
		do
			removed := false
			across
				implementation is i_q
			until
				removed
			loop
				if i_q.has (me) then
					i_q.remove_entity
					removed := true
				end
			end
		ensure
			not has (me)
			entities_in_current_sector_are_contained_in_the_old_sector: across (quadrants).deep_twin is i_q all attached {ID_ENTITY} i_q.entity as i_q_e implies ((old current).has (i_q_e)) end
			count_has_decreased_by_one: count = (old count - 1)
		end

	add (e: ID_ENTITY)
			-- add e to the SECTOR
		require
			not_full: not is_full
			not_has_already: not has (e)
		local
			added: BOOLEAN
		do
			added := false
			across
				implementation is i_q
			until
				added
			loop
				if i_q.is_empty then
					i_q.set_entity (e)
					added := true
				end
			end
		ensure
			has (e)
			entities_in_old_sector_remain_in_current_sector: across (old quadrants).deep_twin is i_q all attached {ID_ENTITY} i_q.entity as i_q_e implies (current.has (i_q_e)) end
			count_is_incremented_by_one: count ~ (old count) + 1
		end

feature -- Queries

	find_landable_planet: PLANET
			-- the PLANET contained in the SECTOR with the lowest id and is_landable.
		require
			is_landable
		local
			min_id: INTEGER
			min_p: PLANET
		do
			min_id := min_id.max_value
			create min_p.make (coordinate, min_id, 0)
			across
				moveable_entities_in_increasing_order is i_m
			loop
				if attached {PLANET} i_m as p then
					if p.attached_to_star and not p.visited then
						if p.id < min_id then
							min_id := p.id
							min_p := p
						end
					end
				end
			end
			Result := min_p
		ensure
			result_is_landable: Result.attached_to_star and (not Result.visited)
			result_is_contained_in_sector: has (Result)
		end

	is_equal (other: like current): BOOLEAN
		do
			if other.coordinate ~ coordinate and quadrants ~ other.quadrants then
				Result := TRUE
			else
				Result := FALSE
			end
		end

	is_sorted (a: ARRAY [MOVEABLE_ENTITY]): BOOLEAN
			-- is the collection of MOVEABLE_ENTITY contained in a, arranged in increasing order id?
		local
			i: INTEGER
		do
			Result := TRUE
			from
				i := 1
			until
				i + 1 > a.count
			loop
				if not (a [i].id < a [i + 1].id) then
					Result := FALSE
				end
				i := i + 1
			end
		end

	quadrants: LIST [QUADRANT]
			-- the collection of QUADRANTS contained in the SECTOR
		do
			Result := implementation
			Result.compare_objects
		end

	is_landable: BOOLEAN
			-- does the SECTOR contain landable PLANET(s)?
		do
			if has_planet and has_star then
				across
					moveable_entities_in_increasing_order is i_m
				until
					Result
				loop
					if attached {PLANET} i_m as p then
						if p.is_landable and p.attached_to_star and (not p.visited) then
							Result := TRUE
						end
					end
				end
			else
				Result := FALSE
			end
		end

	has_planet: BOOLEAN
			-- does the SECTOR contain PLANET(s)?
		do
			Result := across implementation is i_q some attached {PLANET} i_q.entity end
		end

	new_cursor: INDEXABLE_ITERATION_CURSOR [QUADRANT]
			-- facilitate the traversal over the SECTOR using "across" notation
		do
			Result := implementation.new_cursor
		end

	is_full: BOOLEAN
			-- are all QUADRANTs in the SECTOR occupied with ID_ENTITYs?
		do
			Result := count ~ max_num_quadrants
		end

	count: INTEGER
			-- the number of ID_ENTITY contained in the SECTOR
		do
			Result := 0
			across
				implementation is i_q
			loop
				if not i_q.is_empty then
					Result := Result + 1
				end
			end
		end

	get_stationary_entity: STATIONARY_ENTITY
			-- the STATIONARY_ENTITY contained in the SECTOR
		require
			has_stationary_entity
		local
			found: BOOLEAN
		do
			Result := create {YELLOW_DWARF}.make ([1, 1], 0)
			found := false
			across
				implementation is i_q
			until
				found
			loop
				if attached {STATIONARY_ENTITY} i_q.entity as i_stat then
					Result := i_stat
					found := true
				end
			end
		end

	has (me: ID_ENTITY): BOOLEAN
			-- does the SECTOR contain me?
		do
			Result := across implementation is i_q some i_q.has (me) end
		end

	has_id (a_id: INTEGER): BOOLEAN
			-- does the SECTOR contain an ID_ENTITY with id = a_id?
		do
			Result := across implementation is i_q some (attached {ID_ENTITY} i_q.entity as id_e) and then (id_e.id ~ a_id) end
		end

	quadrant_at (me: ID_ENTITY): INTEGER
			-- result -> the numerical position of me's QUADRANT when looking from left to right in the SECTOR
		require
			has (me)
		do
			Result := 1
			across
				1 |..| implementation.count is i
			loop
				if attached {ID_ENTITY} implementation [i].entity as id_entity then
					if me ~ id_entity then
						Result := i
					end
				end
			end
		ensure
			valid_position_in_sector: attached {ID_ENTITY} quadrants [Result].entity as id_e and then id_e ~ me
		end

	has_stationary_entity: BOOLEAN
			-- does the SECTOR contain a STATIONARY_ENTITY?
		do
			Result := FALSE
			across
				implementation is i_q
			loop
				if attached {STATIONARY_ENTITY} i_q.entity then
					Result := TRUE
				end
			end
		end

	has_star: BOOLEAN
			-- does the SECTOR contain a STAR?
		do
			Result := False
			if has_stationary_entity then
				Result := attached {STAR} get_stationary_entity
			end
		end

	has_wormhole: BOOLEAN
			-- does the SECTOR contain a WORMHOLE?
		do
			Result := False
			if has_stationary_entity then
				Result := attached {WORMHOLE} get_stationary_entity
			end
		end

	has_blackhole: BOOLEAN
			-- does the SECTOR contain a BLACKHOLE?
		do
			Result := False
			if has_stationary_entity then
				Result := attached {BLACKHOLE} get_stationary_entity
			end
		end

	moveable_entity_count: INTEGER
			-- the number of all MOVEABLE_ENTITY contained in the SECTOR.
		do
			Result := 0
			across
				implementation is i_q
			loop
				if attached {MOVEABLE_ENTITY} i_q.entity then
					Result := Result + 1
				end
			end
		end

	moveable_entities_in_increasing_order: ARRAY [MOVEABLE_ENTITY]
			-- the collection of all MOVEABLE_ENTITY contained in the SECTOR; arranged in increasing order id.
		local
			i, n: INTEGER
			temp: MOVEABLE_ENTITY
		do
			create Result.make_empty
			across -- placing all moveable entities into an array
				implementation is i_q
			loop
				if attached {MOVEABLE_ENTITY} i_q.entity as me then
					Result.force (me, Result.count + 1)
				end
			end
			from
				n := 0
			until
				n = Result.count
			loop
				from
					i := 1
				until
					i + 1 > Result.count
				loop
					if Result [i + 1].id < Result [i].id then
						temp := Result [i + 1]
						Result.put (Result [i], i + 1)
						Result.put (temp, i)
					end
					i := i + 1
				end
				n := n + 1
			end
			Result.compare_objects
		ensure
			all_moveable_entities_in_result_are_in_current_sector: across Result is me all has (me) end
			result_has_correct_count: Result.count ~ moveable_entity_count
			result_is_sorted: is_sorted (Result)
		end

feature -- Output

	out_abstract_full_coordinate (me: MOVEABLE_ENTITY): STRING
			 -- result -> "[x,y,q]" ie "[2,2,4]" where x and y are coordinate.row/coordinate.col respectively, and q is quadrant_at(me).
		require
			has (me)
		do
			create Result.make_empty
			Result.append ("[")
			Result.append (coordinate.row.out)
			Result.append (",")
			Result.append (coordinate.col.out)
			Result.append (",")
			Result.append (quadrant_at (me).out)
			Result.append ("]")
		end

	out_abstract_sector: STRING
			-- result -> "[x,y]->[0,E],-,-,[2,P]" where x and y are are coordinate.row/coordinate.col respectively, and the remaining text is the out_abstract of each QUADRANT in the SECTOR
		do
			create Result.make_empty
			Result.append (coordinate.out_sqr_bracket_comma)
			Result.append ("->")
			across
				1 |..| implementation.count is i
			loop
				Result.append (implementation [i].out_abstract)
				if i < implementation.count then
					Result.append (",")
				end
			end
		end

	out_coordinate: STRING
			-- result -> "(row:col)" where row and col are coordinate.row and coordinate.col respectively
		do
			Result := coordinate.out
		end

	out_quadrants: STRING
			-- result -> "E--*" or "----" where each character represents an ENTITY in the SECTOR.
		do
			create Result.make_empty
			across
				implementation is i_q
			loop
				Result.append (i_q.out_character)
			end
		end

invariant
	min_max_count: 0 <= count and count <= max_num_quadrants
	entity_coordinates_are_same_as_coordinate: across quadrants is i_q all i_q.entity.coordinate ~ coordinate end

end
