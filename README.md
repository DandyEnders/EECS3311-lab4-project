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
       This command fulfills the requirement that "If the explorer is in any sector, it can travel to any of the 8 adjacent sector normally"
       It also fufills the requirement that "The grid wraps along its boundaries meaning if we go north from a sector in the first row, we will move into the fifth row at the bottom of the grid" 
       To acheive this I added more features to the project. Look below to see the changes I made.
       

Changes
1. Added explorer attribute to SIMODYSSEY 
1. Altered the make routine of SIMODYSSEY -> Now it creates a filled(with NULL ENTITY) galaxy:GRID and initializes the explorer attribute.
1. Added move_explorer command to SIMODYSSEY as explained above
1. Added sector_in_direction_is_full():BOOLEAN query to SIMODYSSEY
1. info_access and shared_info attributes of SIMODYSSEY are no longer private. -> I did this because the post condition of move_explorer() command in SIMODYSSEY uses shared_info.number_rows and shared_info.number_columns.
1. Added subtract():COORDINATE query to COORDINATE
1. Added is_direction():BOOLEAN query to COORDINATE
1. Added wrap_coordinate():COORDINATE query to COORDINATE
1. Added "not at(to_c).is_full" precondition to move() command of GRID
1. Added "not at(c).is_full" precondition to add() command of GRID
