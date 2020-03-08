# EECS3311-lab4-project
# TODO
Implement
1. [x] Grid cluster (make board appear)
1. [ ] Test(thereshold: INTEGER)
1. [ ] States(not clearly defined how to do this)
1. [ ] User input translation in controller(like move(d:INTEGER) d-> direction...)

Jinho will currently work on...
1. [ ] States

Ato will currently work on...
1. [x] Given a threshold, new_game() command of GRID will populate the game board with planets and stationary entities
1. [x] added move_explorer() command to SIMODYSSEY. 
       1. EDIT 1:
              1. This command fulfills the requirement that "If the explorer is in any sector, it can travel to any of the 8 adjacent sector normally"
              1. It also fufills the requirement that "The grid wraps along its boundaries meaning if we go north from a sector in the first row, we will move into the fifth row at the bottom of the grid" 
              1. To acheive this I added more features to the project. LOOK BELOW TO SEE THE CHANGES I MADE.
       1. EDIT 2:
              SIMODYSSEY CHANGES
              1. To fulfill the command that "The game is over when the explorer’s life runs out, the explorer’s fuel runs out, a planet with life is found, or the game is aborted."
                     added game_in_session query to SIMODYSSEY
                     added game_aborted attribute to SIMODYSSEY
              1. To fulfill "a new game can be started when the game is over"
                     new_game() now requries a not game_in_session. 
                     new_game also sets game_aborted to FALSE. Note: game_aborted is TRUE when SIMODYSSEY object is first created
              1. To fulfill "Fuel decrease by 1 each time the explorer uses the move command successfully"
                     move_explorer() now calls explorer.spend_fuel_unit
              1. To fulfill "Fuel is gained when in a sector with a star based on the star’s luminosity intensity."
                     move_explorer() now recharges the explorer's fuel if he is in a sector with a star by calling explorer.charge_fuel().
              1. To fulfill "Explorer has a life value of three, which is reduced to zero when running out of fuel or entering a region with a black hole)"
                     move_explorer() now calls explorer.lose_life given the if-statement conditions.
               To acheive this I added more features to the project. LOOK BELOW TO SEE THE CHANGES I MADE.
       
       

Changes #1
----------
SIMODYSSEY CHANGES
1. Added explorer attribute to SIMODYSSEY 
1. Altered the make routine of SIMODYSSEY -> Now it creates a filled(with NULL ENTITY) galaxy:GRID and initializes the explorer attribute.
1. Added move_explorer command to SIMODYSSEY as explained above
1. Added sector_in_direction_is_full():BOOLEAN query to SIMODYSSEY
1. info_access and shared_info attributes of SIMODYSSEY are no longer private. -> I did this because the post condition of move_explorer() command in SIMODYSSEY uses shared_info.number_rows and shared_info.number_columns.

COORDINATE CHANGES
1. Added subtract():COORDINATE query to COORDINATE
1. Added is_direction():BOOLEAN query to COORDINATE
1. Added wrap_coordinate():COORDINATE query to COORDINATE

GRID CHANGES
1. Added "not at(to_c).is_full" precondition to move() command of GRID
1. Added "not at(c).is_full" precondition to add() command of GRID

Changes #2
----------
EXPLORER CHANGES
found_life is an attribute of EXPLORER
set_found_life is a commmand in EXPLORER that asserts found_life to true
added spend_fuel_unit command to EXPLORER
added charge_fuel() command to EXPLORER

QUADRANT CHANGES
set_entity() command of QUADRANT now only accepts id entites
remove_entity command of QUADRANT no longer calls set_enetity
added entity_id() query of QUADRANT -> it is to be called only if the quadrant is not empty
has() query now only accepts ID_ENTITY now.
added e_id as a private attribute that holds the id of an id_entity if the QUADRANT is not empty.

SECTOR CHANGES
added has_star():BOOLEAN query to SECTOR -> it returns true if the sector has a star
added get_star to SECTOR -> it requires that has_star():BOOLEAN is true and if so, returns the STAR of that SECTOR

UNIT_TEST CHANGES
added t6 boolean tests

