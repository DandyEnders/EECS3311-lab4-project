note
	description: "Summary description for {GRID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRID

inherit

	ANY
		redefine
			out
		end

	ITERABLE [SECTOR]
		redefine
			out
		end

create
	make

feature {NONE} -- Contstructor

	make (r, c, n_quadrant: INTEGER)
		require
			correct_row: r >= 0
			correct_col: c >= 0
			correct_quadrant: n_quadrant >= 0
		local
			sect: SECTOR
		do
			create sect.make_empty ([1, 1], 0)
			create sectors.make_filled (sect, r, c)
			create moveable_entities.make (100)
			create stationary_entities.make (100)
			across
				1 |..| r is i
			loop
				across
					1 |..| c is j
				loop
					create sect.make_empty ([i, j], n_quadrant)
					sectors [i, j] := sect
				end
			end
			row := sectors.height
			col := sectors.width
		end

feature {NONE} -- Attribute

	sectors: ARRAY2 [SECTOR]

	row: INTEGER

	col: INTEGER

	moveable_entities: HASH_TABLE [MOVEABLE_ENTITY, INTEGER]

	stationary_entities: HASH_TABLE [STATIONARY_ENTITY, INTEGER]

feature -- commands

	add (ie: ID_ENTITY)
			-- Add an ID_ENTITY to a sector with entity's coordinate.
		require
			valid_coordinate (ie.coordinate)
			not has (ie)
			not at (ie.coordinate).is_full
		do
			add_at (ie, ie.coordinate)
		ensure
			at (ie.coordinate).has (ie)
		end

	add_at (ie: ID_ENTITY; c: COORDINATE)
			-- Add an ID_ENTITY to a sector with specified coordinate c. (c overrides entitie's coordinate)
		require
			valid_coordinate (c)
			not has (ie)
			not at (c).is_full
		do
			at (c).add (ie)
			if attached {MOVEABLE_ENTITY} ie as me then
				moveable_entities.force (me, me.id)
			elseif attached {STATIONARY_ENTITY} ie as se then
				stationary_entities.force (se, se.id)
			end
		ensure
			at (c).has (ie)
		end

	remove (me: MOVEABLE_ENTITY) -- Before you were forcing "me" into moveable_entities but I'm guessing you wanted to remove instead.
			-- Removes moveable entity in me.coordinate.
		do
			at (me.coordinate).remove (me)
				--			moveable_entities.force (me, me.id) -- ato changed this
			moveable_entities.remove (me.id)
		ensure
			not at (me.coordinate).has (me)
		end

	move (ie: MOVEABLE_ENTITY; to_c: COORDINATE)
			-- Moves entity ie to to_c coordinate.
		require
			has (ie)
			not at (to_c).is_full
		do
			remove (ie)
			add_at (ie, to_c)
		ensure
			at (to_c).has (ie)
		end

feature -- Queries

	all_moveable_entities: ARRAY [MOVEABLE_ENTITY] -- I needed a way to return all movable_entities in accending order of their ids.
		local
			i: INTEGER
			c: INTEGER
		do
			create Result.make_empty

--			across -- stationary, negative id out
--					-- counting inversely
--				moveable_entities is i_me
			from
				i := 0
				c := moveable_entities.count
			until
				c < 1
			loop
				if attached moveable_entities[i] as i_me then
					Result.force(i_me, Result.count + 1)
					c := c - 1
				end
				i := i + 1
			end
		end

	all_stationary_entities: ARRAY [STATIONARY_ENTITY] -- I needed a way to return all stationary_entities in accending order of their ids.
		local
			i: INTEGER
		do
			create Result.make_empty

--			across -- stationary, negative id out
--								-- counting inversely
--				stationary_entities is i_se
			from
				i := (-1 - stationary_entities.count)
			until
				i > -1
			loop
				if attached stationary_entities [i] as i_se then
					Result.force (i_se, Result.count + 1)
				end
				i := i + 1
			end
		end

	at (c: COORDINATE): SECTOR
		require
			valid_coordinate (c)
		do
			Result := sectors [c.row, c.col]
		end

	sector_with (ie: ID_ENTITY): SECTOR -- galaxy.sector_with (explorer) <=> galaxy.at(explorer.coordinate)
		require
			has(ie)
		do
			Result := at (ie.coordinate)
		end

	valid_coordinate (c: COORDINATE): BOOLEAN
		do
			Result := 1 <= c.row and c.row <= row and 1 <= c.col and c.col <= col
		end

	has (ie: ID_ENTITY): BOOLEAN
			-- Check if ie is in grid by comparing its unique id.
		do
			Result := across sectors is i_s some i_s.has (ie) end
		end

feature -- Traversal

	new_cursor: ARRAY_ITERATION_CURSOR [SECTOR]
		do
			Result := sectors.new_cursor
		end

feature -- Out

	out_abstract_sectors: STRING -- Abstract Sectors out
			--   Sectors:
			-- 		[1,1]->[0,E],[36,P],[40,P],-
			--		[1,2]->[3,P],-,[4,P],-
			--		..
			-- 		[5,5]->[48,P],[32,P],[47,P],[15,P]
		local
			msg: MESSAGE
		do
			create Result.make_from_string (msg.left_margin)
			Result.append ("Sectors:")
			across
				1 |..| row is i
			loop
				across
					1 |..| col is j
				loop
					Result.append ("%N")
					Result.append (msg.left_big_margin)
					Result.append (sectors [i, j].out_abstract_sector)
				end
			end
		end

	out_abstract_description: STRING -- Abstract Description out
			--  Descriptions:
			--    [-11,*]->Luminosity:5
			--		..
			--    [-1,O]->
			--    [0,E]->fuel:3/3, life:3/3, landed?:F
			--    [1,P]->attached?:F, support_life?:F, visited?:F, turns_left:0
			-- 		..
		local
			msg: MESSAGE
		do
			create Result.make_from_string (msg.left_margin)
			Result.append ("Descriptions:")
			across
				all_stationary_entities is i_se
			loop
				Result.append ("%N")
				Result.append (msg.left_big_margin)
				Result.append (i_se.out_description)
			end

			across
				all_moveable_entities is i_me
			loop
				Result.append ("%N")
				Result.append (msg.left_big_margin)
				Result.append (i_me.out_description)
			end
		end

	out: STRING
		local
			msg: MESSAGE
		do
			create Result.make_empty
			across
				1 |..| row is i
			loop
				Result.append (msg.left_big_margin)
				across
					1 |..| col is j
				loop
					Result.append (sectors [i, j].out_coordinate)
					Result.append ("  ")
				end
				Result.append ("%N")
				Result.append (msg.left_big_margin)
				across
					1 |..| col is j
				loop
					Result.append (sectors [i, j].out_quadrants)
					Result.append ("   ")
				end
				if i < row then
					Result.append ("%N")
				end
			end
		end

end
