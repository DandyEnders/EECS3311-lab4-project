note
	description: "[
		A STATE defines valid and invalid
		 user commands in the current SIMODYSSEY game
		 and the output generated when such commands
		 are executed.
	]"
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STATE

inherit

	ANY
		undefine
			out
		end

feature {NONE} -- Constructor

	make (m: SIMODYSSEY; abs_s: ABSTRACT_STATE_NUMBERS)
		do
			game_model := m
			abstract_state := abs_s
			create msg_mode.make_empty
			create msg_command_validity.make_empty
			create msg_content.make_empty
			transition_to (current)
		end

feature {STATE} -- Attribute

	game_model: SIMODYSSEY

	msg: MESSAGE

	abstract_state: ABSTRACT_STATE_NUMBERS

feature {STATE, CONTROLLER} -- Message attribute

		-- "  {abstract_state.out}{, msg_mode}{, msg_command_validity}{%Nmsg_content}
		-- example
		--

	msg_mode: STRING

	msg_command_validity: STRING

	msg_content: STRING

	set_msg_content (s: STRING)
		do
			msg_content := s
		end

	set_msg_mode (s: STRING)
		do
			msg_mode := s
		end

	set_msg_command_validity (s: STRING)
		do
			msg_command_validity := s
		end

feature -- Queries

	next_state: STATE
			-- after creation next_state = current. Note refference equality
			-- hence forth, the refference of next_state is modified by execturing commands (eg. abort, land...) in current.
			-- AFTER executing a command (eg. abort, land...) in current,
			-- next_state stores a refference to the "resultant STATE" of the system.
			-- This "resultant STATE" can be "transitioned to" by any client of STATE. "See {CONTROLLER}.move_to_next_state for an example"
			-- next_state is polymorphic and can occupy an instance of PLAY_STATE, MAIN_MENU_STATE and LANDED_STATE

feature -- Commands

	abort
		deferred
		end

	land
		deferred
		end

	liftoff
		deferred
		end

	move (d: COORDINATE)
		deferred
		end

	pass
		deferred
		end

	play
		deferred
		end

	status
		deferred
		end

	test (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold: INTEGER)
		deferred
		end

	wormhole
		deferred
		end

feature {NONE} -- Helper Method (Handling explorer death messages)

	transition_to (s: STATE)
		do
			next_state := s
		ensure
			next_state = s
		end

	set_explorer_death_message
		require
			not game_model.explorer_is_alive
		local
			s_explorer_death: STRING
			s_content: STRING
			s: STATE
		do
			create s_content.make_empty
			create s_explorer_death.make_from_string (game_model.explorer_death_message)
			s_explorer_death.append ("%N")
			s_explorer_death.append (msg.game_is_over)
			if game_model.is_test_game then
				s_content.append (s_explorer_death)
				s_content.append ("%N")
				s_content.append (game_model.out)
				s_content.append ("%N")
				s_content.append (s_explorer_death)
			else
				s_content.append (s_explorer_death)
				s_content.append ("%N")
				s_content.append (game_model.out)
			end
			create {MAIN_MENU_STATE} s.make (game_model, abstract_state)
			s.set_msg_command_validity (msg_command_validity)
			s.set_msg_mode (msg_mode)
			s.set_msg_content (s_content)
			transition_to (s)
		end

feature -- Out

	out: STRING
			-- after a command in current is executed, this is the output the user sees.
		do
			create Result.make_from_string (msg.left_margin)
			Result.append (abstract_state.out)
			if not msg_mode.is_empty then
				Result.append (", mode:")
				Result.append (msg_mode)
			end
			Result.append (", ")
			Result.append (msg_command_validity)
			Result.append ("%N")
			Result.append (msg_content)
		end

invariant
	if_next_state_is_main_menu_state_then_game_is_not_in_session: attached {MAIN_MENU_STATE} next_state implies not game_model.game_is_in_session
	if_next_state_is_play_state_then_game_is_in_session: attached {PLAY_STATE} next_state implies (game_model.game_is_in_session and not game_model.explorer_is_landed)
	if_next_state_is_landed_state_then_game_is_in_session: attached {LANDED_STATE} next_state implies (game_model.game_is_in_session and game_model.explorer_is_landed)

end
