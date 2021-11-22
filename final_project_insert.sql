use tournamentmanager;

INSERT INTO Player (player_id, p_name, dob, phone_number) VALUES (1, "John", "2001-01-01", "213-481-4123");
INSERT INTO Player (player_id, p_name, dob, phone_number) VALUES (2, "Bob", "2002-01-01", "213-455-4173");
INSERT INTO Player (player_id, p_name, dob, phone_number) VALUES (3, "Dave", "2001-04-01", "293-451-4124");

INSERT INTO Player (player_id, p_name, dob, phone_number) VALUES (4, "Ron", "2003-05-07", "213-132-4123");
INSERT INTO Player (player_id, p_name, dob, phone_number) VALUES (5, "Liam", "2004-11-12", "412-451-4123");
INSERT INTO Player (player_id, p_name, dob, phone_number) VALUES (6, "Nate", "2002-02-23", "213-451-4143");

INSERT INTO Player (player_id, p_name, dob, phone_number) VALUES (7, "James", "2003-05-07", "213-132-4153");
INSERT INTO Player (player_id, p_name, dob, phone_number) VALUES (8, "Inigo", "2004-11-12", "412-434-4123");
INSERT INTO Player (player_id, p_name, dob, phone_number) VALUES (9, "Sadge", "2002-02-23", "213-451-2143");

INSERT INTO Tournament (tournament_id, tourn_name , tourn_date, tourn_time, address) VALUES (1, "Big T", "2019-01-01", "12:30:00", "Boston");
INSERT INTO Tournament (tournament_id, tourn_name , tourn_date, tourn_time, address) VALUES (2, "Big L", "2019-04-01", "12:45:00", "Dallas");
INSERT INTO Tournament (tournament_id, tourn_name , tourn_date, tourn_time, address) VALUES (3, "Big X", "2018-02-01", "01:00:00", "Marlough");

INSERT INTO Division (division_id, div_name, div_description, max_teams, tournament_id_FK) VALUES (1, "Division A", "Cool division", 4, 1);
INSERT INTO Division (division_id, div_name, div_description, max_teams, tournament_id_FK) VALUES (2, "Division B", "Cool division", 6, 1);

INSERT INTO Division (division_id, div_name, div_description, max_teams, tournament_id_FK) VALUES (3, "Division C", "Cool division", 4, 2);
INSERT INTO Division (division_id, div_name, div_description, max_teams, tournament_id_FK) VALUES (4, "Division D", "Cool division", 5, 2);

INSERT INTO Division (division_id, div_name, div_description, max_teams, tournament_id_FK) VALUES (5, "Division E", "Cool division", 2, 3);
INSERT INTO Division (division_id, div_name, div_description, max_teams, tournament_id_FK) VALUES (6, "Division F", "Cool division", 3, 3);

INSERT INTO Team (team_id, team_name, player1_FK, player2_FK, division_id_FK) VALUES (1, "The Boys", 1, 2, 1);
INSERT INTO Team (team_id, team_name, player1_FK, player2_FK, division_id_FK) VALUES (2, "Folks", 3, 4, 1);

INSERT INTO Team (team_id, team_name, player1_FK, player2_FK, division_id_FK) VALUES (3, "Hmmm", 5, 6, 2);
INSERT INTO Team (team_id, team_name, player1_FK, player2_FK, division_id_FK) VALUES (4, "Wonners", 1, 4, 2);

INSERT INTO Team (team_id, team_name, player1_FK, player2_FK, division_id_FK) VALUES (5, "Hmmm", 7, 8, 2);
INSERT INTO Team (team_id, team_name, player1_FK, player2_FK, division_id_FK) VALUES (6, "Wonners", 4, 9, 2);


INSERT INTO Squad (squad_id, squad_name, school_name, team1_FK, team2_FK, team3_FK) VALUES (1, "A Cool Squad", "Northeastern Uni", 1, 2, 3);
INSERT INTO Squad (squad_id, squad_name, school_name, team1_FK, team2_FK, team3_FK) VALUES (2, "A Not Cool Squad", "BU", 4, 5, 6);


INSERT INTO GameMatch (match_id, playTo, hardCap, division_id_FK) VALUES (1, 4, 5, 2);
INSERT INTO GameMatch (match_id, playTo, hardCap, division_id_FK) VALUES (2, 3, 4, 2);
INSERT INTO GameMatch (match_id, playTo, hardCap, division_id_FK) VALUES (3, 9, 10, 2);

INSERT INTO GameMatch (match_id, playTo, hardCap, division_id_FK) VALUES (4, 2, 4, 2);
INSERT INTO GameMatch (match_id, playTo, hardCap, division_id_FK) VALUES (5, 5, 8, 2);
INSERT INTO GameMatch (match_id, playTo, hardCap, division_id_FK) VALUES (6, 2, 7, 2);
INSERT INTO GameMatch (match_id, playTo, hardCap, division_id_FK) VALUES (7, 8, 5, 2);

INSERT INTO IndividualMatch (bestOf, match_id_FK, winning_team_FK) VALUES (7, 1, 2);
INSERT INTO IndividualMatch (bestOf, match_id_FK, winning_team_FK) VALUES (1, 2, 3);
INSERT INTO IndividualMatch (bestOf, match_id_FK, winning_team_FK) VALUES (5, 3, 5);
INSERT INTO IndividualMatch (bestOf, match_id_FK, winning_team_FK) VALUES (3, 4, 1);
INSERT INTO IndividualMatch (bestOf, match_id_FK, winning_team_FK) VALUES (5, 5, 4);
INSERT INTO IndividualMatch (bestOf, match_id_FK, winning_team_FK) VALUES (3, 6, 6);


INSERT INTO SquadMatch (match_id_FK, winning_squad_FK, match1_FK, match2_FK, match3_FK, squad1_FK, squad2_FK) 
	VALUES (7, 1, 1, 2, 3, 1, 2);

INSERT INTO Game (game_id, team1_score, team2_score, team1_FK, team2_FK, match_id_FK) VALUES (1, 20, 30, 1, 2, 1);
INSERT INTO Game (game_id, team1_score, team2_score, team1_FK, team2_FK, match_id_FK) VALUES (2, 50, 30, 3, 4, 2);

