note
	description: "Summary description for {ID_ENTITY}."
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

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

	make (a_coordinate: COORDINATE; a_id: INTEGER ; charac: CHARACTER)
			-- Initialization for `Current'.
		do
			make_entity (a_coordinate,charac)
			id := a_id
		end

feature -- Attribute

	id: INTEGER
			-- the id of an ENTITY
feature -- Queries

	is_equal (other: like current): BOOLEAN
			-- current ~ other iff (character ~ other.character and coordinate ~ other.coordinate and id ~ other.id)
		do
			Result := character ~ other.character and coordinate ~ other.coordinate and id ~ other.id
		end

feature -- out
	out_sqr_bracket: STRING
			-- result ~ "[id:character]" ie. "[0,E]"
		do
			create Result.make_empty
			Result.append ("[")
			Result.append (id.out)
			Result.append (",")
			Result.append (out)
			Result.append ("]")
		end

	out_description: STRING
			-- result ~ ""out_sqr_bracket"->" ie. "[0,E]->"
		do
			create Result.make_empty
			Result.append (out_sqr_bracket)
			Result.append ("->")
		end

end
