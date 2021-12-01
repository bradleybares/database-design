use tm;

-- MISC PROCEDURES

-- Gets all columns from a table
drop procedure if exists get_columns_from_table;
DELIMITER //
create procedure get_columns_from_table(IN tab_name VARCHAR(255))
BEGIN
    SELECT COLUMN_NAME, DATA_TYPE, COLUMN_KEY
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = tab_name;
END //
DELIMITER ;

call get_columns_from_table('squad');

-- SCHOOL PROCEDURES

-- Gets all school info
drop procedure if exists view_all_schools;
DELIMITER //
create procedure view_all_schools()
BEGIN
    SELECT * FROM school;
END //
DELIMITER ;

call view_all_schools();

-- Gets specific school info
drop procedure if exists view_specific_school;
DELIMITER //
create procedure view_specific_school(IN S_ID INT)
BEGIN
	SELECT * FROM school where id = S_ID;
END //
DELIMITER ;

call view_specific_school(0);

-- Gets all the players from this specific school
drop procedure if exists get_players_from_school;
DELIMITER //
create procedure get_players_from_school(IN S_ID INT)
BEGIN
    SELECT * FROM player where school_id_FK = S_ID;
END //
DELIMITER ;

call get_players_from_school(0);


-- PLAYER PROCEDURES

-- Gets all player info
drop procedure if exists view_all_players;
DELIMITER //
create procedure view_all_players()
BEGIN
	SELECT * FROM player;
END //
DELIMITER ;

call view_all_players();

-- Gets specific player info
drop procedure if exists view_specific_player;
DELIMITER //
create procedure view_specific_player(IN P_ID INT)
BEGIN
	SELECT * FROM player where id = P_ID;
END //
DELIMITER ;

call view_specific_player(1);


-- TOURNAMENT PROCEDURES

-- Gets all tournament info
drop procedure if exists view_all_tournaments;
DELIMITER //
create procedure view_all_tournaments()
BEGIN
	SELECT * FROM tournament;
END //
DELIMITER ;

call view_all_tournaments();

-- Gets specific tournament info
drop procedure if exists view_specific_tournament;
DELIMITER //
create procedure view_specific_tournament(IN T_ID INT)
BEGIN
	SELECT * FROM tournament where id = T_ID;
END //
DELIMITER ;

call view_specific_tournament(2);


-- DIVISION PROCEDURES

-- Gets all division info for a specific tournament
drop procedure if exists view_all_tournament_divisions;
DELIMITER //
create procedure view_all_tournament_divisions(IN T_ID INT)
BEGIN
	SELECT * FROM division where tournament_id_FK = T_ID;
END //
DELIMITER ;

call view_all_tournament_divisions(2);

-- Gets specific division info
drop procedure if exists view_specific_division;
DELIMITER //
create procedure view_specific_division(IN D_ID INT)
BEGIN
	SELECT * FROM division where id = D_ID;
END //
DELIMITER ;

call view_specific_division(2);


-- TEAM PROCEDURES

-- Gets all team info for a specific division
drop procedure if exists view_all_division_teams;
DELIMITER //
create procedure view_all_division_teams(IN D_ID INT)
BEGIN
	SELECT * FROM team where division_id_FK = D_ID;
END //
DELIMITER ;

call view_all_division_teams(2);

-- Gets specific team info
drop procedure if exists view_specific_division;
DELIMITER //
create procedure view_specific_division(IN T_ID INT)
BEGIN
	SELECT * FROM team where id = T_ID;
END //
DELIMITER ;

call view_specific_division(3);


-- MATCH PROCEDURES

-- Gets all match info for a specific division
drop procedure if exists view_all_division_matches;
DELIMITER //
create procedure view_all_division_matches(IN D_ID INT)
BEGIN
	SELECT *
    FROM (select * from match_data where division_id_FK = D_ID) as gm
		left join individual_match as im
			on gm.id = im.match_id_FK
		left join squad_match as sm
			on gm.id = sm.match_id_FK;
END //
DELIMITER ;

call view_all_division_matches(2);

-- Gets specific match info
drop procedure if exists view_specific_match;
DELIMITER //
create procedure view_specific_match(IN M_ID INT)
BEGIN
	SELECT *
    FROM (select * from match_data where id = M_ID) as gm
		left join individual_match as im
			on gm.id = im.match_id_FK
		left join squad_match as sm
			on gm.id = sm.match_id_FK;
END //
DELIMITER ;

call view_specific_match(3);


-- GAME PROCEDURES

-- Gets all game info for a specific match
drop procedure if exists view_all_match_games;
DELIMITER //
create procedure view_all_match_games(IN M_ID INT)
BEGIN
	SELECT * FROM game_data where match_id_FK = M_ID;
END //
DELIMITER ;

call view_all_match_games(2);

-- Gets specific game info
drop procedure if exists view_specific_game;
DELIMITER //
create procedure view_specific_game(IN G_ID INT)
BEGIN
	SELECT * FROM game_data where id = G_ID;
END //
DELIMITER ;

call view_specific_game(3);

