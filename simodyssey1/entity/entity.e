note
	description: "Summary description for {ENTITY}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY

feature {NONE} -- Initialization

	make(a_coordinate:COORDINATE)
			-- Initialization for `Current'.
		do
			coordinate := a_coordinate
		end


feature -- Attributes

	character: STRING
		deferred
		end

	coordinate: COORDINATE

feature -- Queries



feature -- Commands

	set_coordinate(a_coordinate: COORDINATE)
		do
			coordinate := a_coordinate
		end

end
