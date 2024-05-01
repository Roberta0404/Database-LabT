CREATE OR REPLACE FUNCTION cancella_prenotazioni_scadute() 
RETURNS TRIGGER AS $$
DECLARE
	cur CURSOR FOR SELECT codprenotazione from prenotazione where data_prenotaziones < NOW() - INTERVAL '1 WEEK';
	codcorrente integer;
BEGIN
	open cur;
  	loop 
		fetch from cur into codcorrente;
		exit when not found;
		delete from prenotazione where codprenotazione=codcorrente;
	end loop;
	close cur;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER elimina_prenotazioni_scadute
AFTER INSERT ON prenotazione
FOR EACH ROW
EXECUTE FUNCTION cancella_prenotazioni_scadute();
