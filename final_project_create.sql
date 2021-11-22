DROP DATABASE IF EXISTS tm;

create database tm;
use tm;

-- Player information
create table player (
	player_id INT PRIMARY KEY,
    p_name VARCHAR(50) NOT NULL,
    dob DATE,
    phone_number VARCHAR(20)
);

-- Tournament information
create table tournament(
	tournament_id INT PRIMARY KEY,
    tourn_name VARCHAR(50) NOT NULL,
    tourn_date DATE NOT NULL,
    tourn_time TIME NOT NULL,
    address VARCHAR(100) NOT NULL

);

-- A competitive division within a tournament
create table division(
	division_id INT PRIMARY KEY,
    div_name VARCHAR(50) NOT NULL,
    div_description VARCHAR(200),
    max_teams INT,
    
    tournament_id_FK INT NOT NULL,
    FOREIGN KEY (tournament_id_FK) REFERENCES tournament(tournament_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

-- Two players competing in a division together
create table team (
	team_id INT PRIMARY KEY,
    team_name VARCHAR(50) NOT NULL,
    
    division_id_FK INT NOT NULL,
    FOREIGN KEY (division_id_FK) REFERENCES division(division_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
    
	player1_FK INT NOT NULL,
    player2_FK INT NOT NULL,
    
    FOREIGN KEY (player1_FK) REFERENCES player(player_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (player2_FK) REFERENCES player(player_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

-- A registered school
create table school (
	school_id INT PRIMARY KEY,
    school_name VARCHAR(100) NOT NULL,
    address VARCHAR(100) NOT NULL,
    
    primary_contact_id_FK INT NOT NULL,
    FOREIGN KEY (primary_contact_id_FK) REFERENCES player(player_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

-- A group of 3 teams from the same school
create table squad (
	squad_id INT primary key,
    squad_name VARCHAR(100) NOT NULL,
    
    school_id_FK INT NOT NULL,
    FOREIGN KEY (school_id_FK) REFERENCES school(school_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    
    team1_FK INT NOT NULL,
    team2_FK INT NOT NULL,
    team3_FK INT NOT NULL,
    
    FOREIGN KEY (team1_FK) REFERENCES team(team_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (team2_FK) REFERENCES team(team_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (team3_FK) REFERENCES team(team_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);
	
-- General match data
create table match_data (
	match_id INT PRIMARY KEY,
    playTo INT NOT NULL,
    hardCap INT,
    
    division_id_FK INT NOT NULL,
    FOREIGN KEY (division_id_FK) REFERENCES division(division_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

-- A match between 2 teams
create table individual_match (
	bestOf INT NOT NULL,
    
    match_id_FK INT NOT NULL,
    FOREIGN KEY (match_id_FK) REFERENCES match_data(match_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
    
    winning_team_FK INT,
    FOREIGN KEY (winning_team_FK) references team(team_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

-- A match between 2 squads
create table squad_match (
	match_id_FK INT NOT NULL,
    FOREIGN KEY (match_id_FK) REFERENCES match_data(match_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
    
    winning_squad_FK INT,
    FOREIGN KEY (winning_squad_FK) references squad(squad_id),
    
    match1_FK INT NOT NULL,
    match2_FK INT NOT NULL,
    match3_FK INT NOT NULL,
    
    FOREIGN KEY (match1_FK) references individual_match(match_id_FK)
		ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (match2_FK) references individual_match(match_id_FK)
		ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (match3_FK) references individual_match(match_id_FK)
		ON UPDATE CASCADE ON DELETE CASCADE,
    
    squad1_FK INT NOT NULL,
    squad2_FK INT NOT NULL,
    
    FOREIGN KEY (squad1_FK) references squad(squad_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (squad2_FK) references squad(squad_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
    
);

-- Game data within a match
create table game_data (
	game_id INT PRIMARY KEY,
    team1_score INT,
    team2_score INT,
    
    team1_FK INT NOT NULL,
    team2_FK INT NOT NULL,
    
    FOREIGN KEY (team1_FK) REFERENCES team(team_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (team2_FK) REFERENCES team(team_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    
    match_id_FK INT NOT NULL,
    FOREIGN KEY (match_id_FK) REFERENCES individual_match(match_id_FK)
		ON UPDATE CASCADE ON DELETE CASCADE
);











