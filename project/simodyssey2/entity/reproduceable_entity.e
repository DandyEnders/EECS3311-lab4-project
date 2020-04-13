note
	description: "[
		A class to represent an NP_MOVEABLE_ENTITY that can reproduce.
	]"
	author: "Jinho Hwang, Ato Koomson"
	date: "April 13, 2020"
	revision: "1"

deferred class
	REPRODUCEABLE_ENTITY

inherit

	NP_MOVEABLE_ENTITY
		rename
			make as np_moveable_entity_make
		end

feature {NONE} -- Initialization

	make (a_coordinate: COORDINATE; a_id, t_left, r_interval: INTEGER; charac: CHARACTER)
		do
			np_moveable_entity_make (a_coordinate, a_id, t_left, charac)
			reproduction_interval := r_interval
			actions_left_until_reproduction := reproduction_interval
		end

feature -- Attributes

	actions_left_until_reproduction: INTEGER

	reproduction_interval: INTEGER
			-- maximum value of actions_left_until_reproduction

feature -- Queries

	ready_to_reproduce: BOOLEAN
		do
			Result := actions_left_until_reproduction ~ 0
		ensure
			Result = (actions_left_until_reproduction ~ 0)
		end

feature -- Commands

	decrement_actions_left_by_one
			-- decrement actions_left_until_reproduction by 1
		require
			actions_left_until_reproduction > 0
		do
			actions_left_until_reproduction := actions_left_until_reproduction - 1
		ensure
			actions_left_until_reproduction = (old actions_left_until_reproduction - 1)
		end

feature -- Commands

	reset_actions_left_until_reproduction
			-- initialize actions_left_until_reproduction to reproduction_interval
		do
			actions_left_until_reproduction := reproduction_interval
		ensure
			reproduction_interval ~ actions_left_until_reproduction
		end

	reproduce (moveable_id: INTEGER): like current
			-- create another ENTITY of type {like current} with the same coordinate as current.
		require
			ready_to_reproduce
		deferred
		ensure
			is_alive
			reproduction_interval_is_reset: actions_left_until_reproduction ~ reproduction_interval
			clone_and_current_are_different_entities: (Result /~ Current)
			clone_and_current_have_same_coordinates: Result.coordinate ~ coordinate
		end

invariant
	0 <= actions_left_until_reproduction and actions_left_until_reproduction <= reproduction_interval

end
