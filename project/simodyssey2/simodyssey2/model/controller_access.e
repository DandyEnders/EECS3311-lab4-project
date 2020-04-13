note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "April 13, 2020"
	revision: "1"

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
