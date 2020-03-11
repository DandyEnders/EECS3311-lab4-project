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
			out
		end

	ITERABLE [QUADRANT]
		redefine
			out
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
			create quadrants.make (max_num_quadrants)
			from
				i := 1
			until
				i > max_num_quadrants
			loop
				quadrants.force (create {QUADRANT}.make_empty (coordinate))
				i := i + 1
			end
		end

feature -- Attribute

	quadrants: ARRAYED_LIST [QUADRANT] -- SEQ[QUADRANT]

	coordinate: COORDINATE

	max_num_quadrants: INTEGER

feature -- Command

	land_explorer (e: EXPLORER)
		require
			is_landable
		local
			min_id:INTEGER
			min_p:detachable PLANET
		do
			min_id:=min_id.max_value
			across
				quadrants is i_q
			loop
				if attached {PLANET} i_q.entity as p then
					if p.attached_to_star and not p.visited then
						if p.id < min_id then
							min_id:=p.id
							min_p:=p
						end
					end
				end
			end
			if attached min_p as a_p then
				a_p.set_visited
				e.set_landed (TRUE)
				if a_p.support_life then
				e.set_found_life_true
				end
			end

		end

	remove (me: MOVEABLE_ENTITY)
		local
			removed: BOOLEAN
		do
			removed := false
			across
				quadrants is i_q
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
				quadrants is i_q
			until
				added
			loop
				if i_q.is_empty then
					i_q.set_entity (e)
					added := true
				end
			end
				--		ensure
				--			old contents are not affected except one we are adding. TODO
				--			(old quadrants.deep_twin).
		end

feature -- Queries

	is_landable: BOOLEAN
		do
			if has_planet and has_star then
				across
					quadrants is i_q
				until
					Result
				loop
					if attached {PLANET} i_q.entity as p then
						if (p.attached_to_star and not p.visited) then
							Result := TRUE
						end
					end
				end
			else
				Result := FALSE
			end
		end

	has_planet:BOOLEAN
		do
			Result:= across quadrants is i_q
			some
				 attached {PLANET} i_q.entity
			end

		end

	new_cursor: ARRAYED_LIST_ITERATION_CURSOR [QUADRANT]
		do
			Result := quadrants.new_cursor
		end

	is_full: BOOLEAN
			-- Return true if quadrants is full.
		do
			Result := count ~ max_num_quadrants
		end

	count: INTEGER
		do
			Result := 0
			across
				quadrants is i_q
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
				quadrants is i_q
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
			Result := across quadrants is i_q some i_q.has (me) end
		end

	quadrant_at (me: ID_ENTITY): INTEGER
		require
			has (me)
		do
			Result := 1
			across
				1 |..| quadrants.count is i
			loop
				if attached {ID_ENTITY} quadrants [i].entity as id_entity then
					if me ~ id_entity then
						Result := i
					end
				end
			end
		end

	has_stationary_entity: BOOLEAN --
		do
			Result := FALSE
			across
				quadrants is i_q
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
				quadrants is i_q
			loop
				if attached {MOVEABLE_ENTITY} i_q.entity then
					Result := Result + 1
				end
			end
		end

feature -- Output

	out_abstract_full_coordinate (me: MOVEABLE_ENTITY): STRING -- "[x, y, q]" -> "[2, 2, 4]"
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

	out_abstract_sector: STRING -- "[x, y]->[0, E],-,-,[2,P]"
		do
			create Result.make_empty
			Result.append (coordinate.out_sqr_bracket_comma)
			Result.append ("->")
			across
				1 |..| quadrants.count is i
			loop
				Result.append (quadrants [i].out_abstract)
				if i < quadrants.count then
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
				quadrants is i_q
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
	--	unique_entities: TODO
	--		across quadrants is i_q all
	--			if not i_q.is_empty then
	--				not has(i_q.entity)
	--			end -- AA-C
	--		end

end
