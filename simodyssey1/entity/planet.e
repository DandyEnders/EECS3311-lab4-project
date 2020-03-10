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
			make as moveable_make
		redefine
			out_description
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
			turns_left := 0
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

feature -- Queries

	character: STRING = "P"

feature -- Out

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
