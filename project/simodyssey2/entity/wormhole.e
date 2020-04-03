note
	description: "Summary description for {WORMHOLE}."
	author: "Jinho Hwang"
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
