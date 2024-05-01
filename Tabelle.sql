CREATE TABLE IF NOT EXISTS Laboratorio
(
	CodL VARCHAR (3) PRIMARY KEY,
	descrizione VARCHAR (2000) NOT NULL,
	orario_Apertura TIME NOT NULL,
	orario_Chiusura TIME NOT NULL,
	num_tecnici SMALLINT NOT NULL,
	num_postazioni SMALLINT NOT NULL
);

CREATE TABLE IF NOT EXISTS Sede
(
	CodS SERIAL PRIMARY KEY,
	nome VARCHAR (35) NOT NULL,
	indirizzo VARCHAR (60) NOT NULL,
	responsabile VARCHAR (70) NOT NULL
);

CREATE TABLE IF NOT EXISTS Appartenenza
(
	CodL_fk VARCHAR (3) REFERENCES Laboratorio (CodL)
		on delete cascade
		on update cascade,
	CodS_fk INTEGER REFERENCES Sede (CodS)
		on delete cascade
		on update cascade
	
);

CREATE TABLE IF NOT EXISTS Tecnico
(
	Matricola VARCHAR (10) PRIMARY KEY,
	nome VARCHAR(20) NOT NULL,
	cognome VARCHAR(20) NOT NULL,
	codfiscale VARCHAR(16) UNIQUE,
	telefono VARCHAR(10),
	email VARCHAR(30) UNIQUE,
	CodL_fk VARCHAR(3) REFERENCES Laboratorio(CodL)
		On delete cascade
		On update cascade	
);

CREATE TABLE IF NOT EXISTS Postazione
(
	CodPostazione VARCHAR(3) PRIMARY KEY,
	num_posti SMALLINT NOT NULL,
	CodL_fk VARCHAR(3) REFERENCES Laboratorio(CodL)
		On delete cascade
		On update cascade
);

CREATE TABLE IF NOT EXISTS Strumento
(
	CodStrumento SERIAL PRIMARY KEY,
	caratteristiche_tecniche VARCHAR(1000) NOT NULL,
	descrizione VARCHAR(200) NOT NULL,
	tempoMaxUso TIME NOT NULL,
	CodPostazione_fk VARCHAR(3) REFERENCES Postazione(CodPostazione)
		On delete cascade
		On update cascade,
	CodSede_fk INTEGER REFERENCES Sede(CodS)
		on delete cascade
		on update cascade
);

CREATE TABLE IF NOT EXISTS Utente
(
	Username VARCHAR(20) PRIMARY KEY,
	email VARCHAR(30) UNIQUE,
	pw VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS Prenotazione
(
	CodPrenotazione SERIAL PRIMARY KEY,
	data_prenotazioneS DATE NOT NULL,
	ora_prenotazioneS TIME NOT NULL,
	tempo_utilizzoS TIME NOT NULL,
	Username_fk VARCHAR(20) REFERENCES Utente(Username)
		On delete cascade
		On update cascade,
	CodStrumento_fk INTEGER REFERENCES Strumento(CodStrumento)
		On delete cascade
		On update cascade
);

CREATE TABLE IF NOT EXISTS Occupato
(	
	Username_fk VARCHAR(20) REFERENCES Utente(Username)
		On delete cascade
		On update cascade,
	CodPostazione_fk VARCHAR(3) REFERENCES Postazione(CodPostazione)
		On delete cascade
		On update cascade	
);

CREATE TABLE IF NOT EXISTS Utilizzato
(
	Username_fk VARCHAR(20) REFERENCES Utente(Username)
		On delete cascade
		On update cascade,
	CodStrumento_fk INTEGER REFERENCES Strumento(CodStrumento)
		On delete cascade
		On update cascade,
	datautilizzo DATE,
	oraInizio TIME,
	oraFine TIME
);








