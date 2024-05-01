CREATE OR REPLACE FUNCTION inserisci_utilizzo()
RETURNS TRIGGER AS $$
BEGIN
IF (TG_OP= 'INSERT') THEN
  INSERT INTO Utilizzato (Username_fk, CodStrumento_fk, datautilizzo, oraInizio, oraFine)
  VALUES (NEW.Username_fk, NEW.CodStrumento_fk, NEW.data_prenotazioneS,NEW.ora_prenotaziones,new.ora_prenotaziones + interval'1 second'* extract(epoch from new.tempo_utilizzos));
  RETURN NEW;
ELSE IF(TG_OP='UPDATE') THEN
	UPDATE Utilizzato SET
    datautilizzo = NEW.data_prenotazioneS,
    oraInizio = NEW.ora_prenotaziones,
    oraFine = NEW.ora_prenotaziones + interval '1 second' * extract(epoch from NEW.tempo_utilizzos)
  WHERE Username_fk = NEW.Username_fk AND CodStrumento_fk = NEW.CodStrumento_fk;
  RETURN NEW;
ELSE IF (TG_OP = 'DELETE') THEN
	DELETE FROM Utilizzato
	WHERE Username_fk = OLD.Username_fk AND CodStrumento_fk = OLD.CodStrumento_fk;
	RETURN OLD;
	END IF;
  END IF;
 END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER inserisci_utilizzo_trigger
AFTER INSERT OR UPDATE OR DELETE  ON Prenotazione
FOR EACH ROW
EXECUTE FUNCTION inserisci_utilizzo();

DELETE FROM prenotazione 
where codprenotazione = 177

UPDATE prenotazione 
SET ora_prenotaziones = '08:02:00'
where codprenotazione = 177

INSERT INTO PRENOTAZIONE (data_prenotaziones,ora_prenotaziones,tempo_utilizzos,username_fk,codstrumento_fk)
VALUES ( '2023-03-19','08:00','00:30:00','lucacardone',20)