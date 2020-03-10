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
			model.new_game (30)
			msg_mode := "play"
			msg_command_validity := "ok"
			msg_content := model.out_movement
			msg_content.append ("%N")
			msg_content.append (model.out_grid)
		end

	abort
		do
			executed_turn_command
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

	move (d: INTEGER)
		do
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
