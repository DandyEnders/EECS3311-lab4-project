note
	description: "Summary description for {STARTER_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STARTER_TESTS

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			add_boolean_case (agent t1)
--			add_boolean_case (agent t2)
--			add_boolean_case (agent t3)
--			add_boolean_case (agent t4)
--			add_boolean_case (agent t5)
		end

feature -- tests

	t1: BOOLEAN
			local
				e: EXPLORER
				c: COORDINATE
				q: QUADRANT
				id: INTEGER
			do
				id := 0

				comment ("t1: Test creation of quadrant")
				create c.make([0,0])

				Result := c.row = 0 and c.col = 0
				check Result end

				create e.make(c, id)
				Result := e.life = 3
				check Result end

				create q.make (e)
				Result := q.has (e)
				check Result end
			end


end
