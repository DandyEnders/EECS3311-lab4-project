note
	description: "Summary description for {NP_MOVEABLE_ENTITY}."
	author: "Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NP_MOVEABLE_ENTITY --(2)

inherit

	MOVEABLE_ENTITY
		rename
			make as moveable_make
		end

feature {NONE} -- Initialization

	make (a_coordinate: COORDINATE; a_id, t_left: INTEGER;charac:CHARACTER)
			-- Initialization for `Current'.
		do
			moveable_make (a_coordinate, a_id, 1,charac)
			set_turns_left (t_left)
			create behavior_messages.make_empty
		end
feature {SIMODYSSEY} -- Attributes

	behavior_messages: ARRAY [STRING]

feature -- Attributes	

	turns_left: INTEGER
			-- turns_left for the ENTITY to behave

	set_turns_left (value: INTEGER)
			-- initialize "turns_left" to value
		require
			valid_value: 0 <= value and value <= 2
		do
			turns_left := value
		ensure
			turns_left ~ value
		end

feature -- Commands

	behave (sector: SECTOR)
			-- allow current to interact with ENTITY's in its SECTOR.
			-- perform behavior algorithm that pertains to current's type as seen on pg 36
		require
			sector.coordinate ~ coordinate
			turns_left ~ 0
		deferred
		ensure
			is_alive
			sector.coordinate ~ coordinate
		end

invariant
	0 <= turns_left and turns_left <= 2

end
