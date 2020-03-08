note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	CONTROLLER_ACCESS

feature

	m: CONTROLLER
		once
			create Result.make
		end

invariant
	m = m

end
