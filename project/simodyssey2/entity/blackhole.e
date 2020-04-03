note
	description: "Summary description for {BLACKHOLE}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

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
	make(a_coordinate: COORDINATE; a_id:INTEGER)
		do
			stationary_make(a_coordinate,a_id,'O')
		end
end
