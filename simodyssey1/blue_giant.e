note
	description: "Summary description for {BLUE_GIANT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLUE_GIANT

inherit
	STAR

create
	make

feature -- Attribute

	luminosity: INTEGER = 5

	character: STRING = "*"

feature {NONE} -- Initialization

	make(a_id: INTEGER; a_coordinate:COORDINATE)
			-- Initialization for `Current'.
		do
			id := a_id
			coordinate := a_coordinate
		end

end
