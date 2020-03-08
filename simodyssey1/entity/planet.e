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
			make as moveable_make,
			out_description as id_entity_out_description
		end

create
	make

feature {NONE} -- Constructor

	make (a_coordinate: COORDINATE; a_id: INTEGER)
		do
			moveable_make (a_coordinate, a_id)
			killable_make (1)

			add_death_cause_type("BLACKHOLE")
		end

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

	kill_by_blackhole
		do
			turns_left := -1
			kill_by("BLACKHOLE")
		end

feature -- Queries

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
			Result.append ("turns_left:")
			if attached_to_star or is_dead then
				Result.append ("N/A")
			else
				Result.append (turns_left.out)
			end
		end

end
