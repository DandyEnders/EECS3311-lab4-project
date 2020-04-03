note
	description: "Summary description for {YELLOW_DWARF}."
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

class
	YELLOW_DWARF

inherit

	STAR
		rename
			make as star_make
		end

create
	make

feature {NONE} -- Initialization

	make(a_coordinate: COORDINATE;a_id:INTEGER)
		do
			star_make(a_coordinate,a_id,2,'Y')
		end

end
