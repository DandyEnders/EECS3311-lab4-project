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

			-- initial state = main menu state
			create {MAIN_MENU_STATE} game_state.make(game_model)
		end

feature -- model attributes

	s: STRING

	i: INTEGER

	game_model: SIMODYSSEY

	game_state: STATE

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
			game_state.abort
		end

	land
		do
			game_state.land
		end

	liftoff
		do
			game_state.liftoff
		end

	move (d: INTEGER)
		local
			direction: COORDINATE
			dir_cls: DIRECTION_UTILITY
		do
			inspect d
			when {ETF_TYPE_CONSTRAINTS}.N then
				direction := dir_cls.N
			when {ETF_TYPE_CONSTRAINTS}.NE then
				direction := dir_cls.NE
			when {ETF_TYPE_CONSTRAINTS}.E then
				direction := dir_cls.E
			when {ETF_TYPE_CONSTRAINTS}.SE then
				direction := dir_cls.SE
			when {ETF_TYPE_CONSTRAINTS}.S then
				direction := dir_cls.S
			when {ETF_TYPE_CONSTRAINTS}.SW then
				direction := dir_cls.SW
			when {ETF_TYPE_CONSTRAINTS}.W then
				direction := dir_cls.W
			else
				direction := dir_cls.NW
			end -- when {ETF_TYPE_CONSTRAINTS}.NW
			game_state.move(d)
		end

	pass
		do
			game_state.pass
		end

	play
		do
			game_state.play
		end

	status
		do
			game_state.status
		end

	test (th: INTEGER)
			-- 1 <= th and th <= 101
		do
			game_state.test(th)
		end

	wormhole
		do
			game_state.wormhole
		end

feature -- queries

	out: STRING
		do
--			create Result.make_from_string ("  ")
--			Result.append ("System State: default model state ")
--			Result.append ("(")
--			Result.append (i.out)
--			Result.append (")")
			create Result.make_from_string (game_state.out)
		end

end
