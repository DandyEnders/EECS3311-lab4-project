note
	description: "Summary description for {PLAY_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAY_STATE

inherit

	STATE

create
	make

feature -- Controller command / queries

--	initialization
--		do
--			if model.is_test_game then
--				msg_mode := "test"
--			else
--				msg_mode := "play"
--			end
--			msg_command_validity := "ok"
--			msg_content := model.out
--		end

	abort
		do
			create {MAIN_MENU_STATE} next_state.make (model, abstract_state)

			abstract_state.executed_no_turn_command
			next_state.set_msg_mode ("")
			next_state.set_msg_command_validity ("ok")
			next_state.set_msg_content ("  " + msg.abort)
		end

	land
		local
			tmp_s: STATE
		do
				--			-- model.explorer is in a sector with planet and yellow dwarf
			if model.is_explorer_landable then

				create {LANDED_STATE} tmp_s.make (model, abstract_state)
				next_state := tmp_s.next_state

				abstract_state.executed_turn_command
				msg_command_validity := "ok"

			else
				abstract_state.executed_invalid_command
				set_msg_mode(msg_mode)
				set_msg_command_validity ("error")
				if not model.e_sector_has_yellow_dwarf then -- TODO refactor it so its short
					msg_content := "  " + msg.land_error_no_yellow_dwarf (model.explorer_coordinate.row, model.explorer_coordinate.col)
				elseif not model.e_sector_has_planets then
					msg_content := "  " + msg.land_error_no_planets (model.explorer_coordinate.row, model.explorer_coordinate.col)
				elseif not model.e_sector_has_unvisted_attached_planets then
					msg_content := "  " + msg.land_error_no_visited_planets (model.explorer_coordinate.row, model.explorer_coordinate.col)
				end
			end
		end

	liftoff
		local
			c:COORDINATE
		do
			c := model.explorer_coordinate

			abstract_state.executed_invalid_command
			set_msg_mode(msg_mode)
			set_msg_command_validity ("error")
			set_msg_content ("  " + msg.liftoff_error_not_on_planet (c.row, c.col))
		end

	move (d: COORDINATE)
		local
			s_content: STRING
			c: COORDINATE
			s_tmp: STATE
		do
			if not model.sector_in_direction_is_full (d) and model.game_in_session then

				model.move_explorer (d)

				abstract_state.executed_turn_command
				set_msg_mode(msg_mode)
				set_msg_command_validity ("ok")
				create s_content.make_empty

				if model.is_explorer_alive then
					s_content.append (model.out)
				else
					if model.is_explorer_dead_by_out_of_fuel then -- TODO make the s_content cleaner
						c := model.explorer_coordinate
						if model.is_test_game then
							s_content.append ("  " + msg.explorer_death_out_of_fuel (c.row, c.col))
							s_content.append ("%N")
							s_content.append ("  " + msg.game_is_over)
							s_content.append ("%N")
							s_content.append (model.out)
							s_content.append ("%N")
							s_content.append ("  " + msg.explorer_death_out_of_fuel (c.row, c.col))
							s_content.append ("%N")
							s_content.append ("  " + msg.game_is_over)
						else
							s_content.append ("  " + msg.explorer_death_out_of_fuel (c.row, c.col))
							s_content.append ("%N")
							s_content.append ("  " + msg.game_is_over)
							s_content.append ("%N")
							s_content.append (model.out)
						end

					elseif model.is_explorer_dead_by_blackhole then
						c := model.explorer_coordinate
						if model.is_test_game then
							s_content.append ("  " + msg.explorer_death_blackhole (c.row, c.col, -1))
							s_content.append ("%N")
							s_content.append ("  " + msg.game_is_over)
							s_content.append ("%N")
							s_content.append (model.out)
							s_content.append ("%N")
							s_content.append ("  " + msg.explorer_death_blackhole (c.row, c.col, -1))
							s_content.append ("%N")
							s_content.append ("  " + msg.game_is_over)
						else
							s_content.append ("  " + msg.explorer_death_blackhole (c.row, c.col, -1))
							s_content.append ("%N")
							s_content.append ("  " + msg.game_is_over)
							s_content.append ("%N")
							s_content.append (model.out)
						end
					end
					create {MAIN_MENU_STATE} next_state.make (model, abstract_state)
					next_state.set_msg_command_validity (msg_command_validity)
					next_state.set_msg_mode (msg_mode)
					next_state.set_msg_content (s_content)
				end

				set_msg_content (s_content)

			else
				abstract_state.executed_invalid_command
				set_msg_mode(msg_mode)
				set_msg_command_validity ("error")
				set_msg_content ("  " + msg.move_error_sector_full)
			end
		end

	pass
		do
		end

	play
		do
		end

	status
		do
		end

	test (th: INTEGER)
		do
		end

	wormhole
		do
		end


end
