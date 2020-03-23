note
	description: "Summary description for {PLANET}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	PLANET

inherit

	NP_MOVEABLE_ENTITY
		rename
			make as moveable_make
		redefine
			out_description,
			out_death_description
		end

create
	make

feature {NONE} -- Constructor

	make (a_coordinate: COORDINATE; a_id: INTEGER)
		do
			moveable_make (a_coordinate, a_id)
			killable_make (1)
			add_death_cause_type ("BLACKHOLE")
			visited := FALSE
			attached_to_star := FALSE
			support_life := FALSE
		end

feature -- Attributes

	visited: BOOLEAN

	attached_to_star: BOOLEAN

	support_life: BOOLEAN

feature -- Command

	kill_by_blackhole
		do
			turns_left := -1
			kill_by ("BLACKHOLE")
		end

	set_attached_to_star (b: BOOLEAN) --
		do
			attached_to_star := b
		end

	set_support_life (b: BOOLEAN) --
		do
			support_life := b
		end

	set_visited
		do
			visited := TRUE
		end

	behave (sector: SECTOR) -- (2)
		local
			rng: RANDOM_GENERATOR_ACCESS
			sup_life_prob: INTEGER
		do
			if sector.has_blackhole then
				kill_by_blackhole
			elseif sector.has_star and not attached_to_star then
					-- If there is a star in the sector then set attached for the planet to true.
				set_attached_to_star (TRUE)
					-- If this star is a yellow dwarf then rchoose if this planet should support life?
				if attached {YELLOW_DWARF} sector.get_stationary_entity then
					sup_life_prob := rng.rchoose (1, 2) -- num = 2 means life
					if sup_life_prob = 2 then
						set_support_life (TRUE)
					end
				end
			elseif not sector.has_star then -- you should only set the turns again if the current sector does not have a star
				set_turns_left (rng.rchoose (0, 2))
			end
		end

feature -- Queries

	character: STRING = "P"

	is_dead_by_blackhole: BOOLEAN -- TODO put this in moveable entity by inheritance
		do
			Result := is_dead and then get_death_cause ~ "BLACKHOLE"
		end

feature -- Out

	out_death_description: STRING -- "[0,E]->fuel:2/3, life:3/3, landed?:F,%N{DEATH_MESSAGE}"
		do
			Result := precursor
			if is_dead_by_blackhole then
				Result.append (msg.planet_death_blackhole (coordinate.row, coordinate.col, -1))
			end
		end

	out_description: STRING -- "[id, character]->Luminosity:2" -> "[0, E]->"
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
