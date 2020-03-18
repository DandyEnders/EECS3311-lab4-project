# Project

# Jinho will work on ...

## MESSAGE
1. [ ] Refactor death message. (Take out hard-coded death messages and make them deal in entity level)
1. [ ] Move all "hard-coded" strings out of classes and stack them in MESSAGE class.
1. [ ] Refactor MESSAGE class so that they take COORDINATES instead of rows and columns.
1. [ ] Redo acceptance tests' "test" command (project has 4 more arguments, like test(3,5,7,15,30))

## SIMODYSSEY
1. [ ] (Suggestion) Make the entity the actor of its behavior (For example, it is explorer's job to move to next sector. So it needs to hold the reference to **galaxy:GRID**. This will take a long time to refactor but might be more syntactically easy to use (For example, explorer.move(d:COORDINATE), blackhole.kill(s:SECTOR), ...) and this encapsulates what an entity can do. (For example, Moveable entities can have feature to move; move(s:SECTOR).)

## ENTITIES
1. [ ] Add MURDERABLE
1. [ ] Rename KILLABLE to "DEATHABLE" (Due to addition of "MURDERABLE"
1. [ ] Add REPRODUCEABLE
1. [ ] Add TURNABLE -> has turn-related attributes
1. [ ] Make fuel a class -> maybe make a class of FUELABLE ?

# Ato will work on ...
