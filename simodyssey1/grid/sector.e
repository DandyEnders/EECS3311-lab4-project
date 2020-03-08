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

create
	make_empty

feature {NONE} -- Constructor

	make_empty(a_coordinate: COORDINATE; num_quadrants: INTEGER)
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



feature  -- Attribute

	quadrants: ARRAYED_LIST[QUADRANT] -- SEQ[QUADRANT]
	coordinate: COORDINATE
	max_num_quadrants: INTEGER

feature -- Command

	remove(me: MOVEABLE_ENTITY)
		local
			removed: BOOLEAN
		do
			removed := false
			across
				quadrants is i_q
			until
				removed
			loop
				if
					i_q.has(me)
				then
					i_q.remove_entity
					removed := true
				end
			end
		ensure
			not has(me)
		end

	add (e: ID_ENTITY)
		require
			not_full: not is_full
			not_has_already: not has(e)
		local
			added: BOOLEAN
		do
			added := false
			across
				quadrants is i_q
			until
				added
			loop
				if
					i_q.is_empty
				then
					i_q.set_entity(e)
					added := true
				end
			end
--		ensure
--			old contents are not affected except one we are adding. TODO
--			(old quadrants.deep_twin).
		end

feature -- Queries

	is_full: BOOLEAN
			-- Return true if quadrants is full.
		do
			Result := count = max_num_quadrants
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
	has_star:BOOLEAN
		do
			Result :=
					across
						quadrants is i_q
					some
						i_q.entity.character ~ "*" or i_q.entity.character ~ "Y"
					end
		end
	get_star: STAR
		require
			has_star
		do
			Result:=create {YELLOW_DWARF}.make ([1,1], 30) --creating random star. Note, this will never get returned
				across
					quadrants is i_q
				loop
					if  i_q.entity.character ~ "*" then
						Result:= create {BLUE_GIANT}.make (coordinate, i_q.entity_id)
					elseif  i_q.entity.character ~ "Y" then
						Result:= create {YELLOW_DWARF}.make (coordinate, i_q.entity_id)
					end
				end
		end
	has(me: ID_ENTITY): BOOLEAN
		do
			Result :=
				across
					quadrants is i_q
				some
					i_q.has(me)
				end
		end
	stationary_entity_count:INTEGER
		do
			Result:=0
			across quadrants is i_q
			loop
				if i_q.entity.character /~ "E" and i_q.entity.character /~ "P" and i_q.entity.character /~ "-"then
					Result:=Result+1
				end
			end
		end
	moveable_entity_count:INTEGER
		do
			Result:=0
			across quadrants is i_q
			loop
				if i_q.entity.character ~ "E" or i_q.entity.character ~ "P" then
					Result:=Result+1
				end
			end
		end
feature -- Output

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
				Result.append(i_q.out)
			end
		end

	out: STRING -- for debugging "(row:column) ----"
		do
			create Result.make_empty
			Result.append(out_coordinate)
			Result.append(" ")
			Result.append(out_quadrants)
		end

invariant
	min_max_count:
		0 <= count and  count <= max_num_quadrants
--	unique_entities: TODO
--		across quadrants is i_q all
--			if not i_q.is_empty then
--				not has(i_q.entity)
--			end -- AA-C
--		end


end
