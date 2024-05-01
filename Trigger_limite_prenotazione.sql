CREATE OR REPLACE FUNCTION verifica_limite_prenotazioni()
RETURNS TRIGGER AS $$
DECLARE
  cur CURSOR FOR SELECT CodPrenotazione, data_prenotazioneS, Username_fk 
  FROM Prenotazione 
  WHERE data_prenotazioneS = NEW.data_prenotazioneS AND Username_fk = NEW.Username_fk;
  contatore INTEGER;
  prenotazioneU cur%TYPE;
BEGIN
  contatore := 0;
  OPEN cur;
  LOOP 
    FETCH cur INTO prenotazioneU ;
    IF NOT FOUND THEN
      EXIT;
    END IF;
    contatore := contatore + 1;
    IF contatore >= 5 THEN
      RAISE EXCEPTION 'Non è possibile effettuare più di 5 prenotazioni in un giorno';
    END IF;
  END LOOP;
  CLOSE cur;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verifica_limite_prenotazioni_trigger
AFTER INSERT OR UPDATE ON Prenotazione
FOR EACH ROW
EXECUTE FUNCTION verifica_limite_prenotazioni();