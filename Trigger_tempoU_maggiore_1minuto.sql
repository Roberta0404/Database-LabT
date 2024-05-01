CREATE OR REPLACE FUNCTION check_minuti()
RETURNS TRIGGER AS $$
BEGIN
   IF NEW.tempo_utilizzoS <= INTERVAL '1 minute' THEN
    RAISE EXCEPTION 'Durata minima di utilizzo deve essere superiore a 1 minuto.';
	END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER minuti
BEFORE INSERT ON prenotazione
FOR EACH ROW
EXECUTE FUNCTION check_minuti();
