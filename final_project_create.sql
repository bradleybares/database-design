DROP DATABASE IF EXISTS tm;

create database tm;
use tm;

-- A registered school
create table school (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(100) NOT NULL
);

-- Player information
create table player (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    dob DATE,
    phone_number VARCHAR(20),

    school_id_FK INT,
    FOREIGN KEY(school_id_FK) REFERENCES School(id)
);

-- Tournament information
create table tournament(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    address VARCHAR(100) NOT NULL

);

-- A competitive division within a tournament
create table division(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    max_teams INT,
    
    tournament_id_FK INT NOT NULL,
    FOREIGN KEY (tournament_id_FK) REFERENCES tournament(id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

-- Two players competing in a division together
create table team (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    
    division_id_FK INT NOT NULL,
    FOREIGN KEY (division_id_FK) REFERENCES division(id)
		ON UPDATE CASCADE ON DELETE CASCADE,
    
	player1_id_FK INT NOT NULL,
    player2_id_FK INT NOT NULL,
    
    FOREIGN KEY (player1_id_FK) REFERENCES player(id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (player2_id_FK) REFERENCES player(id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);


-- A group of 3 teams from the same school
create table squad (
	id INT AUTO_INCREMENT primary key,
    name VARCHAR(100) NOT NULL,
    
    school_id_FK INT NOT NULL,
    FOREIGN KEY (school_id_FK) REFERENCES school(id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    
    team1_id_FK INT NOT NULL,
    team2_id_FK INT NOT NULL,
    team3_id_FK INT NOT NULL,
    
    FOREIGN KEY (team1_id_FK) REFERENCES team(id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (team2_id_FK) REFERENCES team(id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (team3_id_FK) REFERENCES team(id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);
	
-- General match data
create table match_data (
	id INT AUTO_INCREMENT PRIMARY KEY,
    playTo INT NOT NULL,
    hardCap INT,
    
    division_id_FK INT NOT NULL,
    FOREIGN KEY (division_id_FK) REFERENCES division(id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

-- A match between 2 teams
create table individual_match (
	bestOf INT NOT NULL,
    
    match_id_FK INT NOT NULL,
    FOREIGN KEY (match_id_FK) REFERENCES match_data(id)
		ON UPDATE CASCADE ON DELETE CASCADE,
    
    winning_team_id_FK INT,
    FOREIGN KEY (winning_team_id_FK) references team(id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

-- A match between 2 squads
create table squad_match (
	match_id_FK INT NOT NULL,
    FOREIGN KEY (match_id_FK) REFERENCES match_data(id)
		ON UPDATE CASCADE ON DELETE CASCADE,
    
    winning_squad_id_FK INT,
    FOREIGN KEY (winning_squad_id_FK) references squad(id),
    
    match1_id_FK INT NOT NULL,
    match2_id_FK INT NOT NULL,
    match3_id_FK INT NOT NULL,
    
    FOREIGN KEY (match1_id_FK) references individual_match(match_id_FK)
		ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (match2_id_FK) references individual_match(match_id_FK)
		ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (match3_id_FK) references individual_match(match_id_FK)
		ON UPDATE CASCADE ON DELETE CASCADE,
    
    squad1_id_FK INT NOT NULL,
    squad2_id_FK INT NOT NULL,
    
    FOREIGN KEY (squad1_id_FK) references squad(id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (squad2_id_FK) references squad(id)
		ON UPDATE CASCADE ON DELETE RESTRICT
    
);

-- Game data within a match
create table game_data (
	id INT AUTO_INCREMENT PRIMARY KEY,
    team1_score INT,
    team2_score INT,
    
    team1_id_FK INT NOT NULL,
    team2_id_FK INT NOT NULL,
    
    FOREIGN KEY (team1_id_FK) REFERENCES team(id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (team2_id_FK) REFERENCES team(id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    
    match_id_FK INT NOT NULL,
    FOREIGN KEY (match_id_FK) REFERENCES individual_match(match_id_FK)
		ON UPDATE CASCADE ON DELETE CASCADE
);











