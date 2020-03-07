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
--			add_boolean_case (agent t1)
--			add_boolean_case (agent t2)
--			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
--			add_boolean_case (agent t5)
		end

feature -- tests

	t4: BOOLEAN
		local
			s_o:SIMODYSSEY
		do
			comment ("t4: Testing SIMODYSSEY make and new_game()")
			create s_o.make
			-- testing new_game with multiple threshold values.
			s_o.new_game (30)
--			print(s_o.out)
--			print("%N")
--			print("%N")
			s_o.new_game (60)
--			print(s_o.out)
--			print("%N")
--			print("%N")
			s_o.new_game (100)
--			print(s_o.out)

		Result:=TRUE
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
			expected: STRING
		do
			comment ("t3: grid make")
			create g.make(5, 5, 4)

			create e.make ([1,1], 0)
			create p.make ([1,1], 1)

			g.add (e, [2,2])
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

			g.remove(e)
--			print("%N")
--			print(g.out)

			g.add (e, [1,1])

--			print(g.out)
--			print("%N%N")
			g.add (p, [3,3])
			g.move (e, [3,3])
--			print(g.out)
--			print("%N%N")
			g.remove (p)	-- PE-- => remove P => -E--
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
				create c.make([0,0])

				Result := c.row = 0 and c.col = 0
				check Result end

				create e.make(c, id)
				Result := e.life = 3
				check Result end

				create q.make_empty (c)

				Result := q.is_empty
				check Result end

				q.set_entity (e)

				Result := not q.is_empty
				check Result end

				Result := q.has (e)
				check Result end

				create s.make_empty(c, 4)

				Result := not s.is_full
				check Result end

				s.add (e)

				Result := s.out_quadrants ~ "E---"
				check Result end

				s.remove (e)

				Result := s.out_quadrants ~ "----"
				check Result end


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
				create c.make([0,0])

				Result := c.row = 0 and c.col = 0
				check Result end

				create e.make(c, id)
				Result := e.life = 3
				check Result end

				create q.make_empty (c)

				Result := q.is_empty
				check Result end

				q.set_entity (e)

				Result := not q.is_empty
				check Result end

				Result := q.has (e)
				check Result end

				create s.make_empty(c, 4)

				Result := not s.is_full
				check Result end

				s.add (e)
				Result := s.out_quadrants ~ "E---"
				check Result end

--				s.add (e) TODO: make violation case


			end




end
