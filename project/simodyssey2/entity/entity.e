note
	description: "[
		A class to represent an entity in a QUADRANT.
	]"
	author: "Jinho Hwang, Ato Kooomson"
	date: "April 13, 2020"
	revision: "1"

deferred class
	ENTITY

inherit

	ANY
		redefine
			out,
			is_equal
		end

feature {NONE} -- Initialization

	make (a_coordinate: COORDINATE; charac: CHARACTER)
			-- Initialization for `Current'.
		do
			coordinate := a_coordinate
			character := charac
		end

feature -- Attributes

	character: CHARACTER
			-- result -> ie 'E'

	coordinate: COORDINATE
			-- coordinate in GRID

feature {ENTITY} -- Attribute

	msg: MESSAGE

feature -- Queries

	is_equal (other: like current): BOOLEAN
		do
			Result := character ~ other.character and coordinate ~ other.coordinate
		end

feature -- out

	out: STRING
			-- result -> ie "E"
		do
			create Result.make_empty
			Result.append_character (character)
		end

end
