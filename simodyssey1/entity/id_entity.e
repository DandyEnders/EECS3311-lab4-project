note
	description: "Summary description for {ID_ENTITY}."
	author: "Jinho Hwang"
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

	make (a_coordinate: COORDINATE; a_id: INTEGER)
			-- Initialization for `Current'.
		do
			make_entity (a_coordinate)
			id := a_id
		end

feature -- Attribute

	id: INTEGER

feature -- Queries

	is_equal (other: like current): BOOLEAN
		do
			Result := coordinate ~ other.coordinate and character ~ other.character and id ~ other.id
		end

feature -- out

--	out_sqr_bracket_comma: STRING -- "[id,chracter]"
--		do
--			create Result.make_empty
--			Result.append ("[")
--			Result.append (id.out)
--			Result.append (",")
--			Result.append (character)
--			Result.append ("]")
--		end


	out_sqr_bracket: STRING -- "[id:character]" -> "[0:E]"
		do
			create Result.make_empty
			Result.append ("[")
			Result.append (id.out)
			Result.append (",")
			Result.append (character)
			Result.append ("]")
		end

	out_description: STRING -- "[id:character]->" -> "[0:E]->"
		do
			create Result.make_empty
			Result.append (out_sqr_bracket)
			Result.append ("->")
		end

end
