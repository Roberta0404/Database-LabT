CREATE OR REPLACE FUNCTION max_postazioni()
RETURNS TRIGGER AS $$ 
DECLARE 

lim_post INTEGER;
num_prenotaz INTEGER;	
postaz_pren VARCHAR(10);

BEGIN 

/*Selezioniamo il numero massimo di posti per la postazione in cui si trova 
lo strumento selezionato nella prenotazione*/
SELECT p.num_posti
INTO lim_post
FROM postazione as p JOIN strumento as s ON p.codpostazione = s.codpostazione_fk
WHERE p.codpostazione = s.codpostazione_fk AND s.codstrumento = new.codstrumento_fk;

/*Selezioniamo la postazione in cui è presente lo strumento selezionato
nella prenotazione*/

SELECT p.codpostazione
INTO postaz_pren 
FROM postazione as p JOIN strumento as s ON p.codpostazione = s.codpostazione_fk
WHERE s.codstrumento = new.codstrumento_fk;

/*Utilizzando count ci ricaviamo il numero di prenotazioni relative a quella 
postazione che si sovrappongono al tempo di utilizzo dello strumento, scelto
nella prenotazione. Per verificare ciò utilizziamo la funzione overlap*/

SELECT count(pr.codprenotazione)
	INTO num_prenotaz
		FROM prenotazione as pr JOIN strumento as s ON s.codStrumento = pr.codstrumento_fk 
		JOIN postazione as p ON p.codpostazione = s.codpostazione_fk
		WHERE pr.data_prenotaziones = new.data_prenotaziones 
		AND (pr.ora_prenotaziones, pr.ora_prenotaziones + 
		interval '1 second' * extract(epoch from pr.tempo_utilizzos)) 
		OVERLAPS
		(new.ora_prenotaziones, new.ora_prenotaziones 
		+ interval '1 second' * extract(epoch from new.tempo_utilizzos))
		AND p.codpostazione = postaz_pren;

-- Verifichiamo che le prenotazioni presenti siano inferiori della capienza
IF (lim_post <= num_prenotaz) THEN
-- Messaggio di errore nel caso il numero venga superato
RAISE EXCEPTION 'La postazione per l''ora scelta è piena, 
provare con un altro orario o giorno. Postazione: %, Capienza: %', postaz_pren, lim_post;
END IF;

RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER max_post
BEFORE INSERT ON prenotazione
FOR EACH ROW
EXECUTE FUNCTION max_postazioni();
