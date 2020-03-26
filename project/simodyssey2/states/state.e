note
	description: "Summary description for {STATE}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STATE

inherit

	ANY
		undefine
			out
		end

feature -- Constructor

	make (m: SIMODYSSEY; abs_s: ABSTRACT_STATE)
		do
			model := m
			abstract_state := abs_s
			create msg_mode.make_empty
			create msg_command_validity.make_empty
			create msg_content.make_empty
			next_state := current
		end

feature {STATE} -- Attribute

	model: SIMODYSSEY

	msg: MESSAGE

	abstract_state: ABSTRACT_STATE

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

feature -- Controller command / queries

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

	set_explorer_dead_message
		require
			not model.explorer_alive
		local
			s_explorer_death: STRING
			s_content: STRING
		do
			create s_content.make_empty
			create s_explorer_death.make_from_string (model.explorer_death_message)
			s_explorer_death.append ("%N")
			s_explorer_death.append (msg.game_is_over)
			if model.is_test_game then
				s_content.append (s_explorer_death)
				s_content.append ("%N")
				s_content.append (model.out)
				s_content.append ("%N")
				s_content.append (s_explorer_death)
			else
				s_content.append (s_explorer_death)
				s_content.append ("%N")
				s_content.append (model.out)
			end
			create {MAIN_MENU_STATE} next_state.make (model, abstract_state)
			next_state.set_msg_command_validity (msg_command_validity)
			next_state.set_msg_mode (msg_mode)
			next_state.set_msg_content (s_content)
		end

feature -- Out

	out: STRING
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
	if_next_state_is_main_menu_state_then_game_is_not_in_session: attached {MAIN_MENU_STATE} next_state implies not model.game_in_session
	if_next_state_is_play_state_then_game_is_in_session: attached {PLAY_STATE} next_state implies model.game_in_session and not model.is_explorer_landed
	if_next_state_is_landed_state_then_game_is_in_session: attached {LANDED_STATE} next_state implies model.game_in_session and model.is_explorer_landed

end
