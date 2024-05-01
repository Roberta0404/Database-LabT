CREATE OR REPLACE FUNCTION check_ora_prenotazione()
RETURNS TRIGGER AS $$
DECLARE
	ora_apertural TIME;
	ora_chiusural TIME;
BEGIN
  	SELECT orario_apertura,orario_chiusura
	INTO ora_apertural,ora_chiusural
	FROM laboratorio;
	
	IF(ora_apertural > NEW.ora_prenotazioneS OR ora_chiusural < NEW.ora_prenotazioneS) THEN
    	RAISE EXCEPTION 'Lo strumento non può essere prenotato per quell''ora.Il laboratorio è chiuso.';
	END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER ora
BEFORE INSERT ON prenotazione
FOR EACH ROW
EXECUTE FUNCTION check_ora_prenotazione();
