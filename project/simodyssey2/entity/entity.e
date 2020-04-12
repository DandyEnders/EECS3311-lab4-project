note
	description: "[
				A class to represent an entity in the game.
				]"
	author: "Jinho Hwang, Ato Kooomson"
	date: "$Date$"
	revision: "$Revision$"

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
			character:=charac
		end

feature -- Attributes

	character: CHARACTER
			-- the character used to represent the ENTITY. ie 'E'

	coordinate: COORDINATE
			-- the ENTITY's coordinate in GRID

feature {ENTITY} -- Attribute

	msg: MESSAGE

feature -- Queries

	is_equal (other: like current): BOOLEAN
			-- current "is_equal" to other if other.character ~ character and other.coordinate ~ coordinate
		do
			Result := character ~ other.character and coordinate ~ other.coordinate
		end

feature -- out

	out: STRING
			-- out ~ ('character' as a STRING).ie "E"
		do
			create Result.make_empty
			Result.append_character (character)
		end

end
