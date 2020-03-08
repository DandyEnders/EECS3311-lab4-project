note
	description: "Summary description for {PLANET}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	PLANET

inherit

	MOVEABLE_ENTITY
		rename
			out_description as id_entity_out_description
		end

create
	make

feature -- Attributes

	turns_left: INTEGER -- TODO: might make it a class, and means of modification

	visited: BOOLEAN

	attached_to_star: BOOLEAN

	support_life: BOOLEAN

feature -- Command

	set_turns_left (value: INTEGER)
		require
			valid_value: 0 <= value and value <= 2
		do
			turns_left := value
		end

	kill_planet
		do
			turns_left := -1
		end

feature -- Queries

	death_message: STRING = "SET THIS TO DEATH MESSAGE"

	character: STRING = "P"

feature -- Out

	out_description: STRING -- "[id, character]->Luminosity:2" -> "[0, E]->"
		do
			Result := id_entity_out_description
			Result.append ("attached?:")
			Result.append (attached_to_star.out)
			Result.append (", ")
			Result.append ("support_life?:")
			Result.append (support_life.out)
			Result.append (", ")
			Result.append ("visited?:")
			Result.append (visited.out)
			Result.append (", ")
			Result.append ("attached?:")
			if attached_to_star or turns_left ~ -1 then
				Result.append ("N/A")
			else
				Result.append (attached_to_star.out)
			end
		end

end
