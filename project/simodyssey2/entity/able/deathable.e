note
	description: "[
		 A class that encapsulates common queries, attributes, 
		 and commands for entities capable of death. 
		 (e.g. MOVEABLE_ENTITY)
		 
		 Secret: 
		 Private attribute “life” is of type LIFE which means
		 DEATHABLE is a client of LIFE.
		 The collection of all valid death causes is stored 
		 in an ARRAY.
	]"
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DEATHABLE

feature -- Constructor

	make (a_max_life: INTEGER)
		do
			create life.make (a_max_life)
			create death_cause.make_empty
			create death_cause_type.make_empty
			death_cause_type.compare_objects
			killers_id := 0
		end

feature {DEATHABLE} -- Killable Attribute

	killers_id: INTEGER

	life: LIFE

	death_cause: STRING

	death_cause_type: ARRAY [STRING]

feature {DEATHABLE} -- Killable Commands

	add_death_cause_type (a_death_cause_type: STRING)
		require
			not is_valid_death_cause (a_death_cause_type)
		do
			death_cause_type.force (a_death_cause_type, death_cause_type.count+1)
		end

feature {DEATHABLE} -- Killable Queries

	has_death_cause_type (a_death_cause_type: STRING): BOOLEAN
		do
			Result := death_cause_type.has (a_death_cause_type)
		end

feature -- Attribute

	current_life_point: INTEGER
			-- current life in value as an INTEGER
		do
			Result := life.point
		end

	max_life: INTEGER
			-- maximum value of "current_life_point"
		do
			Result := life.max
		end

feature -- Queries

	is_dead: BOOLEAN
			-- result ~ true iff "current_life_point" ~ 0
		do
			Result := life.is_dead
		end

	is_alive: BOOLEAN
		do
			Result := not is_dead
		ensure
			Result = (not is_dead)
		end

	is_valid_death_cause (a_death_cause: STRING): BOOLEAN
			-- is a_death_cause a valid death cause to use as an argument to execute "kill_by"
		do
			Result := has_death_cause_type (a_death_cause)
		end

	get_death_cause: STRING
			-- result is a string that describes the cause of death
		require
			is_dead
		do
			Result := death_cause
		end

feature -- Command

	kill_by (a_cause: STRING)
			-- kill an ENTITY using a valid death cause: defined by the ENTITY.
		require
			is_valid_death_cause (a_cause)
		do
			life.set_life (0)
			death_cause := a_cause
		ensure
			is_dead
			get_death_cause ~ a_cause
		end

end
