use tm;

-- Player Data
INSERT INTO player (player_id, p_name, dob, phone_number) VALUES (1, "John", "2001-01-01", "213-481-4123");
INSERT INTO player (player_id, p_name, dob, phone_number) VALUES (2, "Bob", "2002-01-01", "213-455-4173");
INSERT INTO player (player_id, p_name, dob, phone_number) VALUES (3, "Dave", "2001-04-01", "293-451-4124");

INSERT INTO player (player_id, p_name, dob, phone_number) VALUES (4, "Ron", "2003-05-07", "213-132-4123");
INSERT INTO player (player_id, p_name, dob, phone_number) VALUES (5, "Liam", "2004-11-12", "412-451-4123");
INSERT INTO player (player_id, p_name, dob, phone_number) VALUES (6, "Nate", "2002-02-23", "213-451-4143");

INSERT INTO player (player_id, p_name, dob, phone_number) VALUES (7, "James", "2003-05-07", "213-132-4153");
INSERT INTO player (player_id, p_name, dob, phone_number) VALUES (8, "Inigo", "2004-11-12", "412-434-4123");
INSERT INTO player (player_id, p_name, dob, phone_number) VALUES (9, "Sadge", "2002-02-23", "213-451-2143");

-- Tournament Data
INSERT INTO tournament (tournament_id, tourn_name , tourn_date, tourn_time, address) VALUES (1, "Big T", "2019-01-01", "12:30:00", "Boston");
INSERT INTO tournament (tournament_id, tourn_name , tourn_date, tourn_time, address) VALUES (2, "Big L", "2019-04-01", "12:45:00", "Dallas");
INSERT INTO tournament (tournament_id, tourn_name , tourn_date, tourn_time, address) VALUES (3, "Big X", "2018-02-01", "01:00:00", "Marlough");

-- Division Data
INSERT INTO division (division_id, div_name, div_description, max_teams, tournament_id_FK) VALUES (1, "Division A", "Cool division", 4, 1);
INSERT INTO division (division_id, div_name, div_description, max_teams, tournament_id_FK) VALUES (2, "Division B", "Cool division", 6, 1);

INSERT INTO division (division_id, div_name, div_description, max_teams, tournament_id_FK) VALUES (3, "Division C", "Cool division", 4, 2);
INSERT INTO division (division_id, div_name, div_description, max_teams, tournament_id_FK) VALUES (4, "Division D", "Cool division", 5, 2);

INSERT INTO division (division_id, div_name, div_description, max_teams, tournament_id_FK) VALUES (5, "Division E", "Cool division", 2, 3);
INSERT INTO division (division_id, div_name, div_description, max_teams, tournament_id_FK) VALUES (6, "Division F", "Cool division", 3, 3);

-- Team Data
INSERT INTO team (team_id, team_name, player1_FK, player2_FK, division_id_FK) VALUES (1, "The Boys", 1, 2, 1);
INSERT INTO team (team_id, team_name, player1_FK, player2_FK, division_id_FK) VALUES (2, "Folks", 3, 4, 1);

INSERT INTO team (team_id, team_name, player1_FK, player2_FK, division_id_FK) VALUES (3, "Hmmm", 5, 6, 2);
INSERT INTO team (team_id, team_name, player1_FK, player2_FK, division_id_FK) VALUES (4, "Wonners", 1, 4, 2);

INSERT INTO team (team_id, team_name, player1_FK, player2_FK, division_id_FK) VALUES (5, "Hmmm", 7, 8, 2);
INSERT INTO team (team_id, team_name, player1_FK, player2_FK, division_id_FK) VALUES (6, "Wonners", 4, 9, 2);

-- School Data
INSERT INTO school (school_id, school_name, address, primary_contact_id_FK) VALUES (1, "Northeastern University", "Boston", 1);
INSERT INTO school (school_id, school_name, address, primary_contact_id_FK) VALUES (2, "Boston University", "Boston", 4);

-- Squad Data
INSERT INTO squad (squad_id, squad_name, school_id_FK, team1_FK, team2_FK, team3_FK) VALUES (1, "A Cool Squad", 1, 1, 2, 3);
INSERT INTO squad (squad_id, squad_name, school_id_FK, team1_FK, team2_FK, team3_FK) VALUES (2, "A Not Cool Squad", 2, 4, 5, 6);

-- Match Data
INSERT INTO match_data (match_id, playTo, hardCap, division_id_FK) VALUES (1, 4, 5, 2);
INSERT INTO match_data (match_id, playTo, hardCap, division_id_FK) VALUES (2, 3, 4, 2);
INSERT INTO match_data (match_id, playTo, hardCap, division_id_FK) VALUES (3, 9, 10, 2);

INSERT INTO match_data (match_id, playTo, hardCap, division_id_FK) VALUES (4, 2, 4, 2);
INSERT INTO match_data (match_id, playTo, hardCap, division_id_FK) VALUES (5, 5, 8, 2);
INSERT INTO match_data (match_id, playTo, hardCap, division_id_FK) VALUES (6, 2, 7, 2);
INSERT INTO match_data (match_id, playTo, hardCap, division_id_FK) VALUES (7, 8, 5, 2);

-- Individual Matches
INSERT INTO individual_match (bestOf, match_id_FK, winning_team_FK) VALUES (7, 1, 2);
INSERT INTO individual_match (bestOf, match_id_FK, winning_team_FK) VALUES (1, 2, 3);
INSERT INTO individual_match (bestOf, match_id_FK, winning_team_FK) VALUES (5, 3, 5);
INSERT INTO individual_match (bestOf, match_id_FK, winning_team_FK) VALUES (3, 4, 1);
INSERT INTO individual_match (bestOf, match_id_FK, winning_team_FK) VALUES (5, 5, 4);
INSERT INTO individual_match (bestOf, match_id_FK, winning_team_FK) VALUES (3, 6, 6);

-- Sqaud Matches
INSERT INTO squad_match (match_id_FK, winning_squad_FK, match1_FK, match2_FK, match3_FK, squad1_FK, squad2_FK)
	VALUES (7, 1, 1, 2, 3, 1, 2);

-- Game Data
INSERT INTO game_data (game_id, team1_score, team2_score, team1_FK, team2_FK, match_id_FK) VALUES (1, 20, 30, 1, 2, 1);
INSERT INTO game_data (game_id, team1_score, team2_score, team1_FK, team2_FK, match_id_FK) VALUES (2, 50, 30, 3, 4, 2);
