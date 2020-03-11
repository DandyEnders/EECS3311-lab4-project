note
	description: "Summary description for {UNIT_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNIT_TEST

inherit

	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
				--			add_boolean_case (agent t4)
				--			add_boolean_case (agent t5)
--			add_boolean_case (agent t6)
--			add_boolean_case (agent t7)
			add_boolean_case (agent t8)
		end

feature -- tests

	t8:BOOLEAN
		local
			s_o:SIMODYSSEY
		do
			comment ("t6: Testing Pass")
			create s_o.make
--			s_o.pass-- doesnt work if you're not in a game
			s_o.new_game (50, FALSE)
--			s_o.wormhole -- wormhole shouldn't work if I'm not in a sector with a blackhole.
			print ("%N")
			print ("%N")
			print (s_o.out_grid)
			s_o.pass
			print ("%N")
			print ("%N")
			print (s_o.out_grid)

		end


	t7:BOOLEAN
		local
			s_o:SIMODYSSEY
		do
			comment ("t6: Testing Wormhole")
			create s_o.make
--			s_o.wormhole -- doesnt work if you're not in a game
			s_o.new_game (50, FALSE)
--			s_o.wormhole -- wormhole shouldn't work if I'm not in a sector with a blackhole.
			print ("%N")
			print ("%N")
			print (s_o.out_grid)
			s_o.move_explorer ([-1,-1])
--			s_o.explorer.set_landed  -- wormhole shouldnt work if I'm already landed
			s_o.wormhole
			print ("%N")
			print ("%N")
			print (s_o.out_grid)

		end

	t6: BOOLEAN
		local
			s_o: SIMODYSSEY
		do
			comment ("t6: Testing SIMODYSSEY move_explorer. Does Fuel get spent every move?, does fuel recharge if you move into a sector with a star?, does explorer die if he goes into a sector with a blackhole. Do planets move as they do in the oracle?")
			create s_o.make
			s_o.new_game (50, FALSE)
			print ("%N")
			print ("%N")
			print (s_o.out_grid)
			s_o.move_explorer ([1, 1])
			print ("%N")
			print ("%N")
			print (s_o.out_grid)
			s_o.move_explorer ([1,0])
			print ("%N")
			print ("%N")
			print (s_o.out_grid)
			s_o.move_explorer ([1,0])

		Result:=TRUE
		end

	t5: BOOLEAN
		local
			s_o: SIMODYSSEY
		do
			comment ("t5: Testing SIMODYSSEY move_explorer. Does Fuel get spent every move?, does fuel recharge if you move into a sector with a star?")
			create s_o.make
			s_o.new_game (50, FALSE)

				-- Testing fuel exact filling fuel over flow
				--			print(s_o.explorer.fuel.out)
				--			print("%N")
				--			print("%N")
				--			print(s_o.out)
				--			print("%N")
				--			print("%N")
				--			s_o.move_explorer ([1,0])
				--			print(s_o.explorer.fuel.out)
				--			print("%N")
				--			print("%N")
				--			print(s_o.out)
				--			s_o.move_explorer ([1,0])
				--			print(s_o.explorer.fuel.out)
				--			print("%N")
				--			print("%N")
				--			print(s_o.out)
				--			s_o.move_explorer ([-1,0])
				--			print(s_o.explorer.fuel.out)
				--			print("%N")
				--			print("%N")
				--			print(s_o.out)
				--			s_o.move_explorer ([0,1])
				--			print(s_o.explorer.fuel.out)
				--			print("%N")
				--			print("%N")
				--			print(s_o.out)
				--
				-- Testing Fuel Under fill and fuel run out
				--			print(s_o.explorer.fuel.out)
				--			print("%N")
				--			print("%N")
				--			print(s_o.out)
				--			print("%N")
				--			print("%N")
				--			s_o.move_explorer ([1,0])
				--			print(s_o.explorer.fuel.out)
				--			print("%N")
				--			print("%N")
				--			print(s_o.out)
				--			s_o.move_explorer ([1,0])
				--			print(s_o.explorer.fuel.out)
				--			print("%N")
				--			print("%N")
				--			print(s_o.out)
				--			s_o.move_explorer ([-1,0])
				--			print(s_o.explorer.fuel.out)
				--			print("%N")
				--			print("%N")
				--			print(s_o.out)
				--			s_o.move_explorer ([0,-1])
				--			print(s_o.explorer.fuel.out)
				--			print("%N")
				--			print("%N")
				--			print(s_o.out)
				--			s_o.move_explorer ([0,-1])
				--			print(s_o.explorer.fuel.out)
				--			print("%N")
				--			print("%N")
				--			print(s_o.out)
				--			s_o.move_explorer ([0,-1])
				--			print(s_o.explorer.fuel.out)
				--			print("%N")
				--			print("%N")
				--			print(s_o.out)
				--
--			print (s_o.explorer.fuel.out) //query no longer works because explorer is private.
			print ("%N")
			print ("%N")
			print (s_o.out)
			print ("%N")
			print ("%N")
			s_o.move_explorer ([1, 0])
--			print (s_o.explorer.fuel.out)
			print ("%N")
			print ("%N")
			print (s_o.out)
			s_o.move_explorer ([1, 0])
--			print (s_o.explorer.fuel.out)
			print ("%N")
			print ("%N")
			print (s_o.out)
			s_o.move_explorer ([0, -1])
--			print (s_o.explorer.fuel.out)
			print ("%N")
			print ("%N")
			print (s_o.out)
			s_o.move_explorer ([1, 1])
--			print (s_o.explorer.fuel.out)
			print ("%N")
			print ("%N")
			print (s_o.out)
			s_o.move_explorer ([1, 0])
--			print (s_o.explorer.fuel.out)
			print ("%N")
			print ("%N")
			print (s_o.out)
			Result := TRUE
		end

	t4: BOOLEAN
		local
			s_o: SIMODYSSEY
			d: DIRECTION_UTILITY
		do
			comment ("t4: Testing SIMODYSSEY make and new_game() and partially move_explorer")
			create s_o.make
				-- testing new_game with multiple threshold values.
			s_o.new_game (30, FALSE)
				--			print(s_o.out)
				--			print("%N")
				--			print("%N")
			s_o.new_game (60, FALSE)
				--			print(s_o.out)
				--			print("%N")
				--			print("%N")
			s_o.new_game (100, FALSE)
				--			print(s_o.out)
			s_o.move_explorer (d.n) --moving the explorer S
			print (s_o.out)
			print ("%N")
			print ("%N")
			s_o.move_explorer (d.s) --moving the explorer N
			print (s_o.out)
			print ("%N")
			print ("%N")
			s_o.move_explorer (d.w) --moving the explorer E
			print (s_o.out)
			print ("%N")
			print ("%N")
			s_o.move_explorer (d.e) --moving the explorer W
			print (s_o.out)
			print ("%N")
			print ("%N")
			s_o.move_explorer (d.nw) --moving the explorer NE
			print (s_o.out)
			print ("%N")
			print ("%N")
			s_o.move_explorer (d.ne) --moving the explorer NW
			print (s_o.out)
			print ("%N")
			print ("%N")
			s_o.move_explorer (d.sw) --moving the explorer SE
			print (s_o.out)
			print ("%N")
			print ("%N")
			s_o.move_explorer (d.se) --moving the explorer SW
			print (s_o.out)
			print ("%N")
			print ("%N")
			s_o.move_explorer (d.s) --moving the explorer S
			s_o.move_explorer (d.s) --moving the explorer S
			s_o.move_explorer (d.s) --moving the explorer S
			s_o.move_explorer (d.e) --moving the explorer W
			print (s_o.out)
				--			s_o.move_explorer (d.e) --moving the explorer W -- add VIOLATION CASE. The premise is that this will cause an error because the sector at such location is full.
				--			print(s_o.out)
			Result := TRUE
		end

	t3: BOOLEAN
		local
			e: EXPLORER
			p: PLANET
				--			c: COORDINATE
				--			q: QUADRANT
				--			s: SECTOR
				--			id: INTEGER
			g: GRID
--			expected: STRING
		do
			comment ("t3: grid make")
			create g.make (5, 5, 4)
			create e.make ([1, 1], 0)
			create p.make ([1, 1], 1)
			g.add_at (e, [2, 2])
				--			print(g.out)
				--			expected :=  "[
				--    (1:1)  (1:2)  (1:3)  (1:4)  (1:5)
				--    ----   ----   ----   ----   ----
				--    (2:1)  (2:2)  (2:3)  (2:4)  (2:5)
				--    ----   ----   ----   ----   ----
				--    (3:1)  (3:2)  (3:3)  (3:4)  (3:5)
				--    ----   ----   E---   ----   ----
				--    (4:1)  (4:2)  (4:3)  (4:4)  (4:5)
				--    ----   ----   ----   ----   ----
				--    (5:1)  (5:2)  (5:3)  (5:4)  (5:5)
				--    ----   ----   ----   ----   ----
				--                                       ]"
				--			Result := expected ~ g.out
				--			check Result end

			g.remove (e)
				--			print("%N")
				--			print(g.out)

			g.add_at (e, [1, 1])

				--			print(g.out)
				--			print("%N%N")
			g.add_at (p, [3, 3])
			g.move (e, [3, 3])
				--			print(g.out)
				--			print("%N%N")
			g.remove (p) -- PE-- => remove P => -E--
				--			print(g.out)
				--			print("%N%N")
			Result := true
		end

	t2: BOOLEAN
		local
			e: EXPLORER
			c: COORDINATE
			q: QUADRANT
			s: SECTOR
			id: INTEGER
		do
			id := 0
			comment ("t2: sector remove")
			create c.make ([0, 0])
			Result := c.row = 0 and c.col = 0
			check
				Result
			end
			create e.make (c, id)
			Result := e.current_life = 3
			check
				Result
			end
			create q.make_empty (c)
			Result := q.is_empty
			check
				Result
			end
			q.set_entity (e)
			Result := not q.is_empty
			check
				Result
			end
			Result := q.has (e)
			check
				Result
			end
			create s.make_empty (c, 4)
			Result := not s.is_full
			check
				Result
			end
			s.add (e)
			Result := s.out_quadrants ~ "E---"
			check
				Result
			end
			s.remove (e)
			Result := s.out_quadrants ~ "----"
			check
				Result
			end

				--				s.add (e) TODO: make violation case

		end

	t1: BOOLEAN
		local
			e: EXPLORER
			c: COORDINATE
			q: QUADRANT
			s: SECTOR
			id: INTEGER
		do
			id := 0
			comment ("t1: test coordinate, explorer, quadrant, sector add")
			create c.make ([0, 0])
			Result := c.row = 0 and c.col = 0
			check
				Result
			end
			create e.make (c, id)
			Result := e.current_life = 3
			check
				Result
			end
			create q.make_empty (c)
			Result := q.is_empty
			check
				Result
			end
			q.set_entity (e)
			Result := not q.is_empty
			check
				Result
			end
			Result := q.has (e)
			check
				Result
			end
			create s.make_empty (c, 4)
			Result := not s.is_full
			check
				Result
			end
			s.add (e)
			Result := s.out_quadrants ~ "E---"
			check
				Result
			end

				--				s.add (e) TODO: make violation case

		end

end
