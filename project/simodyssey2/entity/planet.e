note
	description: "A class to represent a planet entity."
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

class
	PLANET

inherit

	NP_MOVEABLE_ENTITY
		rename
			make as np_moveable_make
		redefine
			out_description
		end

create
	make

feature {NONE} -- Constructor

	make (a_coordinate: COORDINATE; a_id, t_left: INTEGER)
		do
			np_moveable_make (a_coordinate, a_id, t_left, 'P')
			visited := FALSE
			attached_to_star := FALSE
			support_life := FALSE
			is_landable := FALSE
		end

feature -- Attributes

	visited: BOOLEAN
			-- was visited by EXPLORER?

	attached_to_star: BOOLEAN
			-- is attached to a STAR?

	support_life: BOOLEAN
			-- supports life?

	is_landable: BOOLEAN
			-- is landable?

feature -- Command

	set_attached_to_star (s: STAR)
			-- attach to STAR.
		require
			star_is_in_same_sector: s.coordinate ~ coordinate
			turns_left ~ 0
			is_alive
		do
			attached_to_star := TRUE
			if attached {YELLOW_DWARF} s then
				is_landable := TRUE
			else
				is_landable := FALSE
			end
		ensure
			attached_to_star = TRUE
			turns_left ~ 0
			is_alive
			if_attached_to_yellow_star_then_current_is_landable: (attached {YELLOW_DWARF} s) implies is_landable
			if_not_attached_to_yellow_star_then_is_landable_false: (not (attached {YELLOW_DWARF} s)) implies (not is_landable)
		end

	set_support_life (b: BOOLEAN)
			-- initialize support_life to b
		require
			attached_to_star
			turns_left ~ 0
			is_alive
		do
			support_life := b
		ensure
			support_life = b
			is_alive
			turns_left ~ 0
		end

	set_visited
			-- initialize visited to true
		require
			attached_to_star
			is_alive
			is_landable
		do
			visited := TRUE
			is_landable:=FALSE
		ensure
			visited
			is_alive
			attached_to_star
			not is_landable
		end

	behave (sector: SECTOR)
			-- perform behavior algorithm that pertains to PLANET as seen on pg 36
		local
			rng: RANDOM_GENERATOR_ACCESS
			sup_life_prob: INTEGER
		do
			if sector.has_star and not attached_to_star then
					-- If there is a star in the sector then set attached for the planet to true.
				check attached {STAR} sector.get_stationary_entity as s_star then
					set_attached_to_star (s_star)
				end
					-- If this star is a yellow dwarf then rchoose if this planet should support life?
				if attached {YELLOW_DWARF} sector.get_stationary_entity then
					sup_life_prob := rng.rchoose (1, 2) -- num = 2 means life
					if sup_life_prob = 2 then
						set_support_life (TRUE)
					end
				end
			elseif not attached_to_star then -- you should only set the turns again if planet is not attached to a star pg 19
				set_turns_left (rng.rchoose (0, 2))
			end
		end

feature -- Out

	out_death_message: STRING
			-- result -> {Abstract State: Death Messages PLANET on pg 26-27}
		do
			create Result.make_empty
			if is_dead_by_blackhole then
				Result.append (msg.moveable_entity_death_by_blackhole (current, coordinate.row, coordinate.col, killers_id))
			end
		end

	out_description: STRING
			--result -> "[id, character]->attached?:T or F, support_life?:T or F, visited:T or F, turns_left: N/A or turns_left"
		do
			Result := precursor
			Result.append ("attached?:")
			if attached_to_star then
				Result.append ("T")
			else
				Result.append ("F")
			end
			Result.append (", ")
			Result.append ("support_life?:")
			if support_life then
				Result.append ("T")
			else
				Result.append ("F")
			end
			Result.append (", ")
			Result.append ("visited?:")
			if visited then
				Result.append ("T")
			else
				Result.append ("F")
			end
			Result.append (", ")
			Result.append ("turns_left:")
			if attached_to_star or is_dead then
				Result.append ("N/A")
			else
				Result.append (turns_left.out)
			end
		end

end
