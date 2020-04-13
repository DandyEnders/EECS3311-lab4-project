note
	description: "A class to represent a blackhole entity."
	author: "Jinho Hwang, Ato Koomson"
	date: "April 13, 2020"
	revision: "1"

class
	BLACKHOLE

inherit

	STATIONARY_ENTITY
		rename
			make as stationary_make
		end

create
	make

feature {NONE} -- Initialization

	make (a_coordinate: COORDINATE; a_id: INTEGER)
		do
			stationary_make (a_coordinate, a_id, 'O')
		end

end
