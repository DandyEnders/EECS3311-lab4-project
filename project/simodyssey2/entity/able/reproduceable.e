note
	description: "Summary description for {REPRODUCEABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REPRODUCEABLE

inherit

	NP_MOVEABLE_ENTITY
		rename
			make as np_moveable_entity_make
		end

feature {NONE} -- Initialization

	make (a_coordinate: COORDINATE; a_id, t_left, r_interval: INTEGER)
		do
			np_moveable_entity_make (a_coordinate, a_id, t_left)
			reproduction_interval := r_interval
			actions_left_until_reproduction := reproduction_interval
			create reproduction_message.make_empty
		end

feature -- Attributes

	actions_left_until_reproduction: INTEGER

	reproduction_interval: INTEGER

	reproduction_message: STRING

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
		local
			rng: RANDOM_GENERATOR_ACCESS
			n_me: NP_MOVEABLE_ENTITY
		do
			reproduction_message.make_empty
			n_me := cloner (moveable_id, rng.rchoose (0, 2))
			sector.add (n_me)
			reproduction_message.make_from_string (msg.left_margin + "reproduced " + n_me.out_sqr_bracket + " at " + sector.out_abstract_full_coordinate (n_me))
			actions_left_until_reproduction := reproduction_interval
		ensure
			not ready_to_reproduce
			actions_left_until_reproduction ~ reproduction_interval
			not reproduction_message.is_empty
		end

feature {NONE} -- Implementation

	cloner (a_id, t_left: INTEGER): like current
		deferred
		ensure
			Result /~ Current
			Result.id ~ a_id
			Result.turns_left ~ t_left
		end

invariant
	0 <= actions_left_until_reproduction and actions_left_until_reproduction <= reproduction_interval

end
