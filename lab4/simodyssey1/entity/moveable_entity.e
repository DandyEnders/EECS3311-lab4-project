note
	description: "Summary description for {MOVEABLE_ENTITY}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MOVEABLE_ENTITY

inherit

	ID_ENTITY

	KILLABLE
			rename
				make as killable_make
			undefine
				out,
				is_equal
			end

feature -- out
	out_death_description: STRING
		do
			create Result.make_from_string ("    ")
			Result.append (out_description)
			Result.append (",%N")
			Result.append ("      ")
		end

end
