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

	abort
		do
			model.abort
			create {MAIN_MENU_STATE} next_state.make (model, abstract_state)
			abstract_state.executed_no_turn_command
			next_state.set_msg_mode (msg.empty_string)
			next_state.set_msg_command_validity (msg.ok)
			next_state.set_msg_content (msg.abort)
		end

	land
		local
			c: COORDINATE
			tmp_str: STRING
		do
				--			-- model.explorer is in a sector with planet and yellow dwarf
			if model.is_explorer_landable then
				model.land_explorer
				if model.is_explorer_found_life then
					create {MAIN_MENU_STATE} next_state.make (model, abstract_state)
					abstract_state.executed_turn_command
					next_state.set_msg_mode (msg_mode)
					next_state.set_msg_command_validity (msg.ok)
					next_state.set_msg_content (msg.land_life_found)
				else -- landed in no life planet
					create {LANDED_STATE} next_state.make (model, abstract_state)
					abstract_state.executed_turn_command
					next_state.set_msg_mode (msg_mode)
					next_state.set_msg_command_validity (msg.ok)
					c := model.explorer_coordinate
					create tmp_str.make_from_string (msg.land_life_not_found (c.row, c.col))
					tmp_str.append ("%N")
					tmp_str.append (model.out)
					next_state.set_msg_content (tmp_str)
				end
			else
				abstract_state.executed_invalid_command
				set_msg_mode (msg_mode)
				set_msg_command_validity (msg.error)
				create tmp_str.make_empty
				if not model.is_sector_has_yellow_dwarf then -- TODO refactor it so its short
					tmp_str.append (msg.land_error_no_yellow_dwarf (model.explorer_coordinate.row, model.explorer_coordinate.col))
				elseif not model.is_sector_has_planets then
					tmp_str.append (msg.land_error_no_planets (model.explorer_coordinate.row, model.explorer_coordinate.col))
				elseif not model.is_sector_has_unvisted_attached_planets then
					tmp_str.append (msg.land_error_no_visited_planets (model.explorer_coordinate.row, model.explorer_coordinate.col))
				end
				set_msg_content (tmp_str)
			end
		end

	liftoff
		local
			c: COORDINATE
		do
			c := model.explorer_coordinate
			abstract_state.executed_invalid_command
			set_msg_mode (msg_mode)
			set_msg_command_validity (msg.error)
			set_msg_content (msg.liftoff_error_not_on_planet (c.row, c.col))
		end

	move (d: COORDINATE)
		do
			if not model.sector_in_direction_is_full (d) then
				model.move_explorer (d)
				abstract_state.executed_turn_command
				if model.explorer_alive then
					set_msg_command_validity (msg.ok)
					set_msg_mode (msg_mode)
					set_msg_content (model.out)
				else
					set_explorer_death_message
				end
			else -- model.sector_in_direction_is_full (d) or not model.game_in_session
				if model.sector_in_direction_is_full (d) then
					abstract_state.executed_invalid_command
					set_msg_mode (msg_mode)
					set_msg_command_validity (msg.error)
					set_msg_content (msg.move_error_sector_full)
				end
			end
		end

	pass
		do
			model.pass
			abstract_state.executed_turn_command
			if model.explorer_alive then
				set_msg_command_validity (msg.ok)
				set_msg_mode (msg_mode)
				set_msg_content (model.out)
			else
				set_explorer_death_message
			end
		end

	play
		do
			abstract_state.executed_invalid_command
			set_msg_mode (msg_mode)
			set_msg_command_validity (msg.error)
			set_msg_content (msg.play_error_no_mission)
		end

	status
		do
			abstract_state.executed_no_turn_command
			set_msg_mode (msg_mode)
			set_msg_command_validity (msg.ok)
			set_msg_content (model.out_status_explorer)
		end

	test (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold: INTEGER)
		do
			abstract_state.executed_invalid_command
			set_msg_mode (msg_mode)
			set_msg_command_validity (msg.error)
			set_msg_content (msg.test_error_no_mission)
		end

	wormhole
		local
			c: COORDINATE
		do
			c := model.explorer_coordinate
			if model.explorer_with_wormhole then
				model.wormhole
				abstract_state.executed_turn_command
				if model.explorer_alive then
					set_msg_command_validity (msg.ok)
					set_msg_mode (msg_mode)
					set_msg_content (model.out)
				else
					set_explorer_death_message
				end
			else
				if not model.explorer_with_wormhole then
					c := model.explorer_coordinate
					abstract_state.executed_invalid_command
					set_msg_mode (msg_mode)
					set_msg_command_validity (msg.error)
					set_msg_content (msg.wormhole_error_explorer_not_found_wormhole (c.row, c.col))
				end
			end
		end

end
