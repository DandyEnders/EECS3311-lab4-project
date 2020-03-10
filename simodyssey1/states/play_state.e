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

	initialization
		do
			if model.is_test_game then
				msg_mode := "test"
			else
				msg_mode := "play"
			end
			msg_command_validity := "ok"
			msg_content := model.out
		end

	abort
		do
			executed_no_turn_command
			create {MAIN_MENU_STATE} next_state.make (model, abstract_state)
		end

	land
		local
			tmp_s: STATE
		do
				--			-- model.explorer is in a sector with planet and yellow dwarf
			if model.is_explorer_landable then
				executed_turn_command
					--				create {LANDED_STATE} next_state.make(model, abstract_state)
				create {LANDED_STATE} tmp_s.make (model, abstract_state)
				next_state := tmp_s.next_state
			else
				executed_invalid_command
				if not model.e_sector_has_yellow_dwarf then -- TODO refactor it so its short
					msg_content := "  " + msg.land_error_no_yellow_dwarf (model.explorer_coordinate.row, model.explorer_coordinate.col)
				elseif not model.e_sector_has_planets then
					msg_content := "  " + msg.land_error_no_planets (model.explorer_coordinate.row, model.explorer_coordinate.col)
				elseif not model.e_sector_has_unvisted_attached_planets then
					msg_content := "  " + msg.land_error_no_visited_planets (model.explorer_coordinate.row, model.explorer_coordinate.col)
				end
			end

				--				create {LANDED_STATE} next_state.make(model, abstract_state)
				--			else
				--
				--			end
		end

	liftoff
		do
		end

	move (d: COORDINATE)
		do
			if not model.sector_in_direction_is_full (d) and model.game_in_session then
				executed_turn_command

				model.move_explorer (d)
				msg_content := model.out
--				check model.is_explorer_alive end

			else
				executed_invalid_command
				msg_content := "  " + msg.move_error_sector_full
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
