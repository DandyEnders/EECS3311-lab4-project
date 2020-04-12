note
	description: "[
		A class that provides an interface for executing
		all nine user commands and updates the user
		output when commands are executed.
		
		Secret: 
		Attribute “game_state” is of type STATE which 
		means CONTROLLER is a client of STATE. 
		Note: “game_state” is polymorphic. 
		Post executing a command in CONTROLLER, 
		“game_state” transitions (changes its reference) 
		to a subclass of STATE that is appropriate 
		for the game.
	]"
	author: "Jinho Hwang, Ato Koomson"
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
		local
			msg: MESSAGE
		do
				-- initial state = main menu state
			create {MAIN_MENU_STATE} game_state.make (create {SIMODYSSEY}.make, create {ABSTRACT_STATE_NUMBERS}.make,msg.empty_string,msg.initial_message)
		end

feature -- Attributes

	game_state: STATE
			-- "game_state" is polymorphic
			-- provides the STATE (see description in STATE) of the current SIMODYSSEY game. eg PLAY_STATE, MAIN_MENU_STATE...

feature -- State Commands
	move_to_next_state
			-- transition "game_sate" to the STATE referenced by "game_state.next_state" such that "game_state" = "game_state.next_state".
			-- Note reference equality.
		do
			game_state := game_state.next_state
		ensure
			game_state = game_state.next_state
		end

feature -- User Commands

	abort
			--execute "abort" command in "game_state" followed by "move_to_next_state"
		do
			game_state.abort
			move_to_next_state
		end

	land
			--execute "land" command in "game_state" followed by "move_to_next_state"
		do
			game_state.land
			move_to_next_state
		end

	liftoff
			--execute "liftoff" command in "game_state" followed by "move_to_next_state"
		do
			game_state.liftoff
			move_to_next_state
		end

	move (d: INTEGER)
			--execute "move" command in "game_state" followed by "move_to_next_state"
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
			game_state.move (direction)
			move_to_next_state
		end

	pass
			--execute "pass" command in "game_state" followed by "move_to_next_state"
		do
			game_state.pass
			move_to_next_state
		end

	play
			--execute "play" command in "game_state" followed by "move_to_next_state"
		do
			game_state.play
			move_to_next_state
		end

	status
			--execute "status" command in "game_state" followed by "move_to_next_state"
		do
			game_state.status
			move_to_next_state
		end

	test (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold: INTEGER)
			--execute "test" command in the current "game_state" followed by "move_to_next_state"
		do
			game_state.test (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold) -- TODO
			move_to_next_state
		end

	wormhole
			--execute "wormhole" command in "game_state" followed by "move_to_next_state"
		do
			game_state.wormhole
			move_to_next_state
		end

	reset
			-- Reset model state.
		do
			make
		end

feature -- Queries

	out: STRING
			-- output "game_state"
		do
			Result := game_state.out
		ensure then
			Result ~ game_state.out
		end

end
