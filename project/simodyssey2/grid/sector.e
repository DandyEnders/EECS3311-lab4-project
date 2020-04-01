note
	description: "Summary description for {SECTOR}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	SECTOR

inherit

	ANY
		redefine
			out,
			is_equal
		end

	ITERABLE [QUADRANT]
		redefine
			out,
			is_equal
		end

create
	make_empty

feature {NONE} -- Constructor

	make_empty (a_coordinate: COORDINATE; num_quadrants: INTEGER)
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

feature -- Attribute

	coordinate: COORDINATE

	max_num_quadrants: INTEGER

feature -- Command

	find_landable_planet_for (e: EXPLORER): PLANET
		require
			is_landable
		local
			min_id: INTEGER
			min_p: PLANET
		do
			min_id := min_id.max_value
			create min_p.make (coordinate, min_id,0)
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
				Result:=min_p
		ensure
			Result.attached_to_star
			and (not Result.visited)
			and has(Result)
		end

	remove (me: MOVEABLE_ENTITY)
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
			Entities_in_current_sector_are_contained_in_the_old_sector: across (quadrants).deep_twin is i_q all attached {ID_ENTITY} i_q.entity as i_q_e implies ((old current).has (i_q_e)) end
			count ~ (old count) - 1
			max_num_quadrants = old max_num_quadrants
		end

	add (e: ID_ENTITY)
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
			Entities_in_old_sector_remain_in_current_sector: across (old quadrants).deep_twin is i_q all attached {ID_ENTITY} i_q.entity as i_q_e implies (current.has (i_q_e)) end
			has(e)
			count ~ (old count) + 1
			max_num_quadrants = old max_num_quadrants
		end

feature -- Queries

	is_equal(other: like current): BOOLEAN
		do
			if other.coordinate ~ coordinate and quadrants ~ other.quadrants then
				Result:=TRUE
			else
				Result:=FALSE
			end
		end

	is_sorted (a: ARRAY [MOVEABLE_ENTITY]): BOOLEAN
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
		do
			Result:=implementation
			Result.compare_objects
		end

	is_landable: BOOLEAN
		do
			if has_planet and has_star then
				across
					moveable_entities_in_increasing_order is i_m
				until
					Result
				loop
					if attached {PLANET} i_m as p then
						if (p.attached_to_star and not p.visited) then
							Result := TRUE
						end
					end
				end
			else
				Result := FALSE
			end
		end

	has_planet: BOOLEAN
		do
			Result := across implementation is i_q some attached {PLANET} i_q.entity end
		end

	new_cursor: INDEXABLE_ITERATION_CURSOR [QUADRANT]
		do
			Result := implementation.new_cursor
		end

	is_full: BOOLEAN
			-- Return true if implementation is full.
		do
			Result := count ~ max_num_quadrants
		end

	count: INTEGER
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
		require
			has_stationary_entity
		local
			found: BOOLEAN
		do
			Result := create {YELLOW_DWARF}.make ([1, 1], 0) --creating random star. Note, this will never get returned
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
		do
			Result := across implementation is i_q some i_q.has (me) end
		end

	has_id (id: INTEGER): BOOLEAN
		do
			Result :=
			across implementation is i_q some (attached {ID_ENTITY} i_q.entity as id_e) and then (id_e.id ~ id)	end
		end

	quadrant_at (me: ID_ENTITY): INTEGER
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
			attached {ID_ENTITY} quadrants[Result].entity as id_e and then id_e~me
		end

	has_stationary_entity: BOOLEAN --
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
		do
			Result := False
			if has_stationary_entity then
				Result := attached {STAR} get_stationary_entity
			end
		end

	has_wormhole: BOOLEAN
		do
			Result := False
			if has_stationary_entity then
				Result := attached {WORMHOLE} get_stationary_entity
			end
		end

	has_blackhole: BOOLEAN
		do
			Result := False
			if has_stationary_entity then
				Result := attached {BLACKHOLE} get_stationary_entity
			end
		end

	moveable_entity_count: INTEGER --
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
			all_moveable_entities_in_result_are_in_current_sector: across Result is me all has(me)  end
			Result.count ~ moveable_entity_count
			is_sorted (Result)
		end
feature -- Output

	out_abstract_full_coordinate (me: MOVEABLE_ENTITY): STRING -- "[x,y,q]" -> "[2,2,4]"
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

	out_abstract_sector: STRING -- "[x,y]->[0,E],-,-,[2,P]"
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

	out_coordinate: STRING -- "(row:column)"
		do
			Result := coordinate.out
		end

	out_quadrants: STRING -- "E--*", "----"
		do
			create Result.make_empty
			across
				implementation is i_q
			loop
				Result.append (i_q.out)
			end
		end

	out: STRING -- for debugging "(row:column) ----"
		do
			create Result.make_empty
			Result.append (out_coordinate)
			Result.append (" ")
			Result.append (out_quadrants)
		end

invariant
	min_max_count: 0 <= count and count <= max_num_quadrants
	entity_coordinates_are_same_as_coordinate: across quadrants is i_q all i_q.entity.coordinate ~ coordinate  end
end
