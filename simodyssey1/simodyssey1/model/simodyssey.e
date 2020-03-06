note
	description: "Summary description for {SIMODYSSEY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIMODYSSEY

create
	make

feature {NONE} -- Constructor

	make
		local
			r, c, n_quadrant: INTEGER
		do
			planet_threshold := 0
			r := shared_info.number_rows
			c := shared_info.number_columns
			n_quadrant := shared_info.quadrants_per_sector
			create galaxy.make(r, c, n_quadrant)
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



feature -- Command

	new_game(th: INTEGER)
		require
			valid_threshold:
				1 <= th and th <= 101
		local
			r, c, n_quadrant: INTEGER
		do
			planet_threshold := th

			r := shared_info.number_rows
			c := shared_info.number_columns
			n_quadrant := shared_info.quadrants_per_sector
			create galaxy.make(r, c, n_quadrant)
		end

feature -- Queries



end
