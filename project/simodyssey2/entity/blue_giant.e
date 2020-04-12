note
	description: "A class to represent a blue_giant entity."
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

class
	BLUE_GIANT

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
			star_make(a_coordinate,a_id,5,'*')
		end

end
