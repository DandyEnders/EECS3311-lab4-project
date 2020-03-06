note
	description: "Summary description for {SIMODYSSEY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIMODYSSEY

inherit
	ANY
	redefine
		out
	end
create
	make

feature {NONE} -- Constructor

	make
		local
		do
			planet_threshold := 0
			create galaxy.make (0, 0, 0)
			--initializing global id object
			create moveable_id.make(0,TRUE)
			create stationary_id.make(0,FALSE)
		end

feature -- Attribute

	galaxy: GRID

feature {NONE} -- Private Attribute

	rng: RANDOM_GENERATOR_ACCESS

	info_access: SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result := info_access.shared_info
		end

	planet_threshold: INTEGER
	moveable_id:ID_DISPATCHER
	stationary_id:ID_DISPATCHER
feature -- Command

	new_game (th: INTEGER)
		require
			valid_threshold: 1 <= th and th <= 101
		local
			r, c, n_quadrant: INTEGER
			explorer:EXPLORER --
			blackhole:BLACKHOLE --
			p:PLANET
			numb_of_entity:INTEGER
		do
			make --calling make in order to initialize global ids every new game
			planet_threshold := th
			r := shared_info.number_rows
			c := shared_info.number_columns
			n_quadrant := shared_info.quadrants_per_sector
			create galaxy.make (r, c, n_quadrant)
			--adding explorer and blackhole
			create explorer.make([1,1],moveable_id.get_id) --
			galaxy.add (explorer, explorer.coordinate) --
			create blackhole.make([3,3],stationary_id.get_id)--
			galaxy.add (blackhole, blackhole.coordinate)--
			-- populating planets based on threshold
			across galaxy  is i_g
			loop
				if i_g.coordinate /~ [3,3] then
					numb_of_entity := rng.rchoose (1, shared_info.quadrants_per_sector-1)
					across 1 |..| numb_of_entity is i
					loop
						if rng.rchoose (1, 100) < planet_threshold then
							create p.make (i_g.coordinate, moveable_id.get_id)
							galaxy.add (p, p.coordinate)
							p.set_turns_left (rng.rchoose (0, 2))

						end
					end
				end
			end
			-- tod - populate stationary objects
		end

feature -- Queries
	out:STRING
	do
		create Result.make_empty
		Result.append(galaxy.out)
	end
end
