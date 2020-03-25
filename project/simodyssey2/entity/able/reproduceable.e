note
	description: "Summary description for {REPRODUCEABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REPRODUCEABLE

feature {NONE} -- Initialization

	make (r_interval: INTEGER)
		do
			reproduction_interval := r_interval
			actions_left_until_reproduction := reproduction_interval
		end

feature -- Attributes

	actions_left_until_reproduction: INTEGER

	reproduction_interval: INTEGER

feature -- Queries

	ready_to_reproduce: BOOLEAN
		do
			Result := actions_left_until_reproduction ~ 0
		end

feature -- Commands

	decrement_actions_left_by_one
		require
			actions_left_until_reproduction > 0
		do
			actions_left_until_reproduction := actions_left_until_reproduction - 1
		ensure
			actions_left_until_reproduction = (old actions_left_until_reproduction - 1)
		end

	reset_actions_left_until_reproduction: INTEGER
		do
			actions_left_until_reproduction := reproduction_interval
		ensure
			reproduction_interval = actions_left_until_reproduction
		end

	reproduce (sector: SECTOR; moveable_id: INTEGER)
		require
			not sector.is_full
			ready_to_reproduce
		deferred
		ensure
			not ready_to_reproduce
			actions_left_until_reproduction ~ reproduction_interval
		end

invariant
	0 <= actions_left_until_reproduction and actions_left_until_reproduction <= reproduction_interval

end
