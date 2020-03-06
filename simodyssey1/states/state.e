note
	description: "Summary description for {STATE}."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STATE

feature -- Constructor

	make(c: like context)
		do
			context := c
		end

feature {STATE} -- Attribute

	context: SIMODYSSEY

feature -- Commands

feature -- Queries

	read
		deferred end

--	answer TODO

	choice

end
