note
	description: "Summary description for {ENTITY}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY

feature -- Attributes

	character: STRING
		deferred
		end

	coordinate: COORDINATE

feature -- Queries



feature -- Commands

	set_coordinate(c: COORDINATE)
		do

		end

end
