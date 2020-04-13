note
	description: "[
		A class to represent an ENTITY and its identification number.
	]"
	author: "Jinho Hwang, Ato Koomson"
	date: "April 13, 2020"
	revision: "1"

deferred class
	ID_ENTITY

inherit

	ENTITY
		rename
			make as make_entity
		redefine
			is_equal
		end

feature {NONE} -- Initialization

	make (a_coordinate: COORDINATE; a_id: INTEGER; charac: CHARACTER)
			-- Initialization for `Current'.
		do
			make_entity (a_coordinate, charac)
			id := a_id
		end

feature -- Attribute

	id: INTEGER

feature -- Queries

	is_equal (other: like current): BOOLEAN
		do
			Result := character ~ other.character and coordinate ~ other.coordinate and id ~ other.id
		end

feature -- out

	out_sqr_bracket: STRING
			-- result -> "[id:character]"
		do
			create Result.make_empty
			Result.append ("[")
			Result.append (id.out)
			Result.append (",")
			Result.append (out)
			Result.append ("]")
		end

	out_description: STRING
			-- result -> "out_sqr_bracket->"
		do
			create Result.make_empty
			Result.append (out_sqr_bracket)
			Result.append ("->")
		end

end
