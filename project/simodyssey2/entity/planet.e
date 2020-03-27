note
	description: "Summary description for {PLANET}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	PLANET

inherit

	NP_MOVEABLE_ENTITY
		redefine
			make,
			out_description
		end

create
	make

feature {NONE} -- Constructor

	make (a_coordinate: COORDINATE; a_id, t_left: INTEGER)
		do
			precursor (a_coordinate, a_id, t_left)
			visited := FALSE
			attached_to_star := FALSE
			support_life := FALSE
		end

feature -- Attributes

	visited: BOOLEAN

	attached_to_star: BOOLEAN

	support_life: BOOLEAN

feature -- Command

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
			if sector.has_star and not attached_to_star then
					-- If there is a star in the sector then set attached for the planet to true.
				set_attached_to_star (TRUE)
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

feature -- Queries

	character: STRING = "P"

feature -- Out

	out_death_message: STRING -- {Abstract State: Death Message for pg 26-27 relevant to this entity}
		do
			create Result.make_empty
			if is_dead_by_blackhole then
				Result.append (msg.death_by_blackhole (current, coordinate.row, coordinate.col, killers_id))
			end
		end

	out_description: STRING -- "[id, character]->attached?:T or F, support_life?:T or F, visited:T or F, turns_left: N/A or turns_left"
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
