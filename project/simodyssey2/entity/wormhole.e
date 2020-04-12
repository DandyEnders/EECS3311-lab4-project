note
	description: "A class to represent a wormhole entity."
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

class
	WORMHOLE

inherit

	STATIONARY_ENTITY
		rename
			make as stationary_make
		end

create
	make

feature {NONE} -- Initialization
	make(a_coordinate: COORDINATE; a_id:INTEGER)
		do
			stationary_make(a_coordinate,a_id,'W')
		end
end
