note
	description: "Controller"
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	CONTROLLER

inherit
	ANY
		redefine
			out
		end

create {CONTROLLER_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create s.make_empty
			i := 0
			create game_model.make
		end

feature -- model attributes
	s : STRING
	i : INTEGER
	game_model: SIMODYSSEY

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

feature -- Model input

	abort
		do
			-- TODO
		end

	land
		do
			-- TODO
		end

	liftoff
		do
			-- TODO
		end

	move(d: INTEGER)
		local
			direction: COORDINATE
			dir_cls: DIRECTION
		do
			inspect d
			when {ETF_TYPE_CONSTRAINTS}.N 	then direction := dir_cls.N
			when {ETF_TYPE_CONSTRAINTS}.NE 	then direction := dir_cls.NE
			when {ETF_TYPE_CONSTRAINTS}.E 	then direction := dir_cls.E
			when {ETF_TYPE_CONSTRAINTS}.SE 	then direction := dir_cls.SE
			when {ETF_TYPE_CONSTRAINTS}.S 	then direction := dir_cls.S
			when {ETF_TYPE_CONSTRAINTS}.SW 	then direction := dir_cls.SW
			when {ETF_TYPE_CONSTRAINTS}.W 	then direction := dir_cls.W
			else direction := dir_cls.NW end -- when {ETF_TYPE_CONSTRAINTS}.NW
			-- TODO
		end

	pass
		do
			-- TODO
		end

	play
		do
			-- TODO
		end

	status
		do
			-- TODO
		end

	test(th: INTEGER)
		do
			-- TODO
		end

	wormhole
		do
			-- TODO
		end


feature -- queries
	out : STRING
		do
			create Result.make_from_string ("  ")
			Result.append ("System State: default model state ")
			Result.append ("(")
			Result.append (i.out)
			Result.append (")")
		end

end




