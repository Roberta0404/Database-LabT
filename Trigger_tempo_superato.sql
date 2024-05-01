--Trigger che impedisce che il tempo di prenotazione di uno strumento superi il massimo tempo d'uso consentito per lo strumento
CREATE OR REPLACE FUNCTION tempo_superato()
RETURNS TRIGGER AS $$
DECLARE
	tempo_max TIME;
	strumentod varchar(200);
BEGIN
	
	--selezione descrizione strumento per codice errore.
	SELECT s.descrizione
	INTO strumentod
	FROM strumento AS s JOIN prenotazione AS pr ON s.codStrumento=NEW.codStrumento_fk;
	
	SELECT tempoMaxUso
	INTO tempo_max
	FROM strumento as s join prenotazione as pr on s.codStrumento=pr.codStrumento_fk
	WHERE s.codStrumento=NEW.codStrumento_fk;
		
	IF tempo_max< new.tempo_utilizzoS THEN
		RAISE EXCEPTION 'Il tempo scelto è MAGGIORE del tempo massimo consentito per questo strumento % che è %',strumentod,tempo_max;
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER controllo_tempo
AFTER INSERT OR UPDATE ON prenotazione
FOR EACH ROW
	execute function tempo_superato();

	



	