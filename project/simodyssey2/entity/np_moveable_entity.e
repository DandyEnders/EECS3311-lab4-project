note
	description: "Summary description for {NP_MOVEABLE_ENTITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NP_MOVEABLE_ENTITY --(2)

inherit

	MOVEABLE_ENTITY
		redefine
			make
		end

feature {NONE} -- Initialization

	make (a_coordinate: COORDINATE; a_id: INTEGER)
			-- Initialization for `Current'.
		do
			precursor (a_coordinate, a_id)
			set_turns_left (0)
		end

feature -- Attributes

	turns_left: INTEGER

	set_turns_left (value: INTEGER)
		require
			valid_value: 0 <= value and value <= 2
		do
			turns_left := value
		end

feature -- Commands

	behave (sector: SECTOR)
		require
			sector.coordinate ~ coordinate
			turns_left ~ 0
		deferred
		end

invariant
	0 <= turns_left and turns_left <= 2

end
