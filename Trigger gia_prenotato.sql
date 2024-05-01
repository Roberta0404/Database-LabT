CREATE OR REPLACE FUNCTION check_prenotazione()
RETURNS TRIGGER AS $$
DECLARE
    tempo_utilizzo_sec integer;
	contatore INTEGER;
BEGIN
    tempo_utilizzo_sec = extract(epoch from NEW.tempo_utilizzoS);

    SELECT count(*) INTO contatore
    FROM prenotazione
	-- LE DATE DI PRENOTAZIONE DEVONO CORRISPONDERE
    WHERE data_prenotazioneS = NEW.data_prenotazioneS 
		   AND codstrumento_fk = NEW.codstrumento_fk AND
		   (ora_prenotazioneS, ora_prenotazioneS + interval '1 second' * extract(epoch from prenotazione.tempo_utilizzoS))
			OVERLAPS (NEW.ora_prenotazioneS, NEW.ora_prenotazioneS + interval '1 second' * tempo_utilizzo_sec);
    IF (contatore > 0) THEN
        RAISE EXCEPTION 'Strumento già prenotato per questo orario';
    END IF;
				
				RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_prenotazione_trigger
BEFORE INSERT ON prenotazione
FOR EACH ROW
EXECUTE FUNCTION check_prenotazione();

DELETE FROM PRENOTAZIONE WHERE codprenotazione= 232

insert into prenotazione (data_prenotaziones,ora_prenotaziones,tempo_utilizzos,username_fk,codstrumento_fk)
values ('2023-03-23','12:04','00:05:00','lucacardone',21)
