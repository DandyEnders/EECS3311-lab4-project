note
	description: "Summary description for {REPRODUCEABLE_ENTITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REPRODUCEABLE_ENTITY

inherit

	NP_MOVEABLE_ENTITY
		rename
			make as np_moveable_entity_make
		end

feature {NONE} -- Initialization

	make (a_coordinate: COORDINATE; a_id, t_left, r_interval: INTEGER;charac: CHARACTER)
		do
			np_moveable_entity_make (a_coordinate, a_id, t_left,charac)
			reproduction_interval := r_interval
			actions_left_until_reproduction := reproduction_interval
			create reproduction_message.make_empty
		end

feature -- Attributes

	actions_left_until_reproduction: INTEGER
			-- actions left until ENTITY can attempt to reproduce.

	reproduction_interval: INTEGER
			-- minimum number of actions ENTITY must execute until it can attempt to reproduce.

feature {SIMODYSSEY} -- Attributes
	reproduction_message: STRING

feature -- Queries

	ready_to_reproduce: BOOLEAN
		do
			Result := actions_left_until_reproduction ~ 0
		ensure
			Result = (actions_left_until_reproduction ~ 0)
		end

feature -- Commands

	decrement_actions_left_by_one
			-- decrement "actions_left_until_reproduction" by one
		require
			actions_left_until_reproduction > 0
		do
			actions_left_until_reproduction := actions_left_until_reproduction - 1
		ensure
			actions_left_until_reproduction = (old actions_left_until_reproduction - 1)
		end
feature -- Commands
	reset_actions_left_until_reproduction
			-- initialize "actions_left_until_reproduction" to "reproduction_interval"
		do
			actions_left_until_reproduction := reproduction_interval
		ensure
			reproduction_interval ~ actions_left_until_reproduction
		end

	reproduce (sector: SECTOR; moveable_id: INTEGER)
			-- succesfully create another ENTITY with current's type in current's sector
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
			reset_actions_left_until_reproduction
		ensure
			is_alive
			reproduction_interval_is_reset: (not ready_to_reproduce) and actions_left_until_reproduction ~ reproduction_interval
			sector_has_both_current_and_new_clone:sector.has (current) and sector.has_id (moveable_id)
			sector_count_incremented: (sector.count ~ (old sector.count +1))
			previous_entities_in_sector_have_not_been_removed: (across ((old sector.deep_twin).quadrants) is i_q all attached {ID_ENTITY} i_q.entity as i_q_e implies (sector.has (i_q_e)) end)
		end

feature {NONE} -- Private Attributes

	cloner (a_id, t_left: INTEGER): like current
		deferred
		ensure
			Result /= Current
			Result /~ Current
			Result.id ~ a_id
			Result.turns_left ~ t_left
		end

invariant
	0 <= actions_left_until_reproduction and actions_left_until_reproduction <= reproduction_interval

end
