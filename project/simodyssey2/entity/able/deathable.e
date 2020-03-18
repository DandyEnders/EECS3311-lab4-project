note
	description: "Summary description for {DEATHABLE}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DEATHABLE

feature -- Constructor
	make(a_max_life:INTEGER)
		do
			create life.make(a_max_life)
			create death_cause.make_empty
			create death_cause_type.make(10)


		end

feature {DEATHABLE} -- Killable Attribute

	life: LIFE

	death_cause: STRING

	death_cause_type: HASH_TABLE[INTEGER, STRING]

feature {DEATHABLE} -- Killable Commands

	add_death_cause_type(a_death_cause_type: STRING)
		require
			not is_valid_death_cause(a_death_cause_type)
		do
			-- 0 is dummy value. I only use the hash key part to check uniqueness.
			death_cause_type[a_death_cause_type] := 0
		end

feature {DEATHABLE} -- Killable Queries

	has_death_cause_type(a_death_cause_type: STRING): BOOLEAN
		do
			Result := death_cause_type.has (a_death_cause_type)
		end

feature -- Attribute

	current_life: INTEGER
		do
			Result := life.value
		end

	max_life: INTEGER
		do
			Result := life.max
		end

feature -- Queries

	is_dead: BOOLEAN
		do
			Result := life.is_dead
		end

	is_alive: BOOLEAN
		do
			Result := not is_dead
		end

	is_valid_death_cause(a_death_cause: STRING): BOOLEAN
		do
			Result := has_death_cause_type(a_death_cause)
		end

	get_death_cause: STRING
		require
			is_dead
		do
			Result := death_cause
		end

feature -- Command

	kill_by(a_cause:STRING)
		require
			is_valid_death_cause(a_cause)
		do
			life.set_life(0)
			death_cause := a_cause
		end

end
