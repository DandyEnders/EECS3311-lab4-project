note
	description: "[
		A collection of SECTOR objects arranged in a 2-D grid.
		
		Secret: 
		The collection of STATIONARY_ENTITY in the GRID 
		is stored in a HASH_TABLE, to allow efficient 
		implementation of “all_stationary_entities” query.
		A similar approach is used to implement 
		“all_moveable_entities” query.
	]"
	author: "Jinho Hwang, Ato Koomson"
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
			create stationary_entities.make (125)
			sectors.compare_objects
			stationary_entities.compare_objects
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
			max_row := sectors.height
			max_col := sectors.width
		end

feature {NONE} -- Attribute

	stationary_entities: HASH_TABLE [STATIONARY_ENTITY, INTEGER]

feature -- Attributes

	sectors: ARRAY2 [SECTOR]

	max_row: INTEGER
			-- maximum number of rows

	max_col: INTEGER
			-- maximum number of columns

feature {NONE} -- Queries

	moveable_entities: HASH_TABLE [MOVEABLE_ENTITY, INTEGER]
		do
			create Result.make (125)
			across
				sectors is i_s
			loop
				across
					i_s.moveable_entities_in_increasing_order is me
				loop
					Result.force (me, me.id)
				end
			end
			Result.compare_objects
		end

feature -- Commands

	add_at (ie: ID_ENTITY; c: COORDINATE)
			-- add ie to a SECTOR with coordinate ~ c.
		require
			valid_coordinate (c)
			not has (ie)
			not at (c).is_full
		do
			at (c).add (ie)
			if attached {STATIONARY_ENTITY} ie as se then
				stationary_entities.force (se, se.id)
			end
		ensure
			me_is_added_at_correct_sector: at (c).has (ie)
			count_is_incremented_by_one: entity_count ~ (old entity_count + 1)
		end

	remove (me: MOVEABLE_ENTITY)
			-- remove me.
		require
			has (me)
		do
			at (me.coordinate).remove (me)
		ensure
			me_is_removed: not has (me)
			count_is_decremented_by_one: entity_count ~ (old entity_count - 1)
		end

	move (ie: MOVEABLE_ENTITY; to_c: COORDINATE)
			-- move ie away from its SECTOR to a SECTOR in GRID with (coordinate ~ to_c)
		require
			has (ie)
			valid_coordinate (to_c)
			new_sector_is_not_full_or_already_contains_ie: (not at (to_c).is_full or at (to_c).has (ie))
		do
			remove (ie)
			add_at (ie, to_c)
		ensure
			ie_is_at_new_coordinate: at (to_c).has (ie)
			count_is_incremented_by_one: entity_count ~ entity_count
		end

feature -- Queries

	entity_count: INTEGER
			-- the culmulative sum of all STATIONARY_ENTITY and MOVEABLE_ENTITY contained
		do
			Result := stationary_entities.count + moveable_entities.count
		end

	has_sector (s: SECTOR): BOOLEAN
			-- result is true if GRID contains SECTOR s.
		do
			Result := sectors.has (s)
		end

	all_moveable_entities: ARRAY [MOVEABLE_ENTITY]
			-- The collection of all MOVEABLE_ENTITY contained; arranged in increasing order ids.
		local
			i: INTEGER
			c: INTEGER
			temp: HASH_TABLE [MOVEABLE_ENTITY, INTEGER]
		do
			create Result.make_empty
			from
				i := 0
				temp := moveable_entities
				c := temp.count
			until
				c < 1
			loop
				if attached temp [i] as i_me then
					Result.force (i_me, Result.count + 1)
					c := c - 1
				end
				i := i + 1
			end
			Result.compare_objects
		end

	all_stationary_entities: ARRAY [STATIONARY_ENTITY]
			-- The collection of all STATIONARY_ENTITY contained; arranged in increasing order ids.
		local
			i: INTEGER
		do
			create Result.make_empty
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
			Result.compare_objects
		end

	at (c: COORDINATE): SECTOR
			-- the SECTOR in grid with coordinate ~ c
		require
			valid_coordinate (c)
		do
			Result := sectors [c.row, c.col]
		ensure
			matching_sector_coordinate: Result.coordinate ~ c
			result_is_contained_in_grid: has_sector (Result)
		end

	sector_with (ie: ID_ENTITY): SECTOR
			-- the SECTOR in GRID that contains ie.
		require
			has (ie)
		do
			Result := at (ie.coordinate)
		ensure
			result_has_ie: Result.has (ie)
			result_is_contained_in_grid: has_sector (Result)
		end

	valid_coordinate (c: COORDINATE): BOOLEAN
			-- true if c lies between [0,0] and [max_row,max_col]
		do
			Result := 1 <= c.row and c.row <= max_row and 1 <= c.col and c.col <= max_col
		end

	has (ie: ID_ENTITY): BOOLEAN
			-- result equals true if "ie" is contained in any SECTOR in GRID
		do
			Result := across sectors is i_s some i_s.has (ie) end
		end

feature -- Traversal

	new_cursor: INDEXABLE_ITERATION_CURSOR [SECTOR]
			-- facilitate traversal of GRID using across notation
		do
			Result := sectors.new_cursor
		end

feature -- Out

	out_abstract_sectors: STRING
			-- result -> (below)
			-- Sectors:
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
				1 |..| max_row is i
			loop
				across
					1 |..| max_col is j
				loop
					Result.append ("%N")
					Result.append (msg.left_big_margin)
					Result.append (sectors [i, j].out_abstract_sector)
				end
			end
		end

	out_abstract_description: STRING
			-- result -> (below)
			-- Descriptions:
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
			-- result -> (below)
			--   (1:1) (1:2) (1:3) (1:4) (1:5)
			--   M---  *---  B---  ----  ----
			--   (2:1) (2:2) (2:3) (2:4) (2:5)
			--   ----  ----  W---  W---  ----
			--   (3:1) (3:2) (3:3) (3:4)
			--   PY--  ----  O---

		local
			msg: MESSAGE
		do
			create Result.make_empty
			across
				1 |..| max_row is i
			loop
				Result.append (msg.left_big_margin)
				across
					1 |..| max_col is j
				loop
					Result.append (sectors [i, j].out_coordinate)
					Result.append ("  ")
				end
				Result.append ("%N")
				Result.append (msg.left_big_margin)
				across
					1 |..| max_col is j
				loop
					Result.append (sectors [i, j].out_quadrants)
					Result.append ("   ")
				end
				if i < max_row then
					Result.append ("%N")
				end
			end
		end

end
