note
	description: "Summary description for {STAR}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STAR

inherit

	STATIONARY_ENTITY
		redefine
			out_description
		end

feature

	luminosity: INTEGER
		deferred
		end

feature -- Out

	out_description:STRING -- "[id, character]->Luminosity:2" -> "[0, E]->Luminosity:2"
		do
			Result := Precursor
			Result.append("Luminosity:")
			Result.append(luminosity.out)
		end

end
