note
	description: "A class to represent a blue_giant entity."
	author: "Jinho Hwang, Ato Koomson"
	date: "April 13, 2020"
	revision: "1"

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

	make (a_coordinate: COORDINATE; a_id: INTEGER)
		do
			star_make (a_coordinate, a_id, 5, '*')
		end

end
