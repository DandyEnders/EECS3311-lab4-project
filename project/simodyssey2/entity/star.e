note
	description: "[
		A class to represent a STATIONARY_ENTITY and its
		luminosity value.
	]"
	author: "Jinho Hwang, Ato Koomson"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STAR

inherit

	STATIONARY_ENTITY
		rename
			make as stationary_entity_make
		redefine
			out_description
		end

feature {NONE} -- Initialization

	make(a_coordinate: COORDINATE; a_id,lumin:INTEGER; charac: CHARACTER)
		do
			stationary_entity_make(a_coordinate,a_id,charac)
			luminosity:=lumin
		end

feature -- Attribute

	luminosity: INTEGER
			-- luminosity value of a STAR.

feature -- Out

	out_description:STRING
			-- result ~ "[id, character]->Luminosity: luminosity". ie. "[0, E]->Luminosity:2"
		do
			Result := Precursor
			Result.append("Luminosity:")
			Result.append(luminosity.out)
		end

end
