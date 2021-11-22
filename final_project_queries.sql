# Procedures
use tm;

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
	SELECT * FROM player where player_id = P_ID;
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
	SELECT * FROM tournament where tournament_id = T_ID;
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
	SELECT * FROM division where division_id = D_ID;
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
	SELECT * FROM team where team_id = T_ID;
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
    FROM (select * from gamematch where division_id_FK = D_ID) as gm
		left join individualmatch as im
			on gm.match_id = im.match_id_FK
		left join squadmatch as sm
			on gm.match_id = sm.match_id_FK;
END //
DELIMITER ;

call view_all_division_matches(2);

-- Gets specific match info
drop procedure if exists view_specific_match;
DELIMITER //
create procedure view_specific_match(IN M_ID INT)
BEGIN
	SELECT *
    FROM (select * from gamematch where match_id = M_ID) as gm
		left join individualmatch as im
			on gm.match_id = im.match_id_FK
		left join squadmatch as sm
			on gm.match_id = sm.match_id_FK;
END //
DELIMITER ;

call view_specific_match(3);

-- GAME PROCEDURES

-- Gets all game info for a specific match
drop procedure if exists view_all_match_games;
DELIMITER //
create procedure view_all_match_games(IN M_ID INT)
BEGIN
	SELECT * FROM game where match_id_FK = M_ID;
END //
DELIMITER ;

call view_all_match_games(2);

-- Gets specific game info
drop procedure if exists view_specific_game;
DELIMITER //
create procedure view_specific_game(IN G_ID INT)
BEGIN
	SELECT * FROM game where game_id = G_ID;
END //
DELIMITER ;

call view_specific_game(3);

