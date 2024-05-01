CREATE OR REPLACE FUNCTION no_prenotazioni_date_passate() 
RETURNS TRIGGER AS $$

DECLARE

data_di_oggi DATE = current_date;
ora_di_oggi TIME = current_time;
anno_corrente INTEGER = extract(year from data_di_oggi);
anno_prenotazione INTEGER = extract(year from NEW.data_prenotazioneS);

BEGIN 

	 IF(NEW.data_prenotazioneS < data_di_oggi) THEN	
		RAISE EXCEPTION 'Errore, stai provando a prenotare uno strumento per una data passata';	
	 END IF;
	 
	 IF(NEW.data_prenotazioneS = data_di_oggi AND NEW.ora_prenotazioneS < ora_di_oggi) THEN 
		RAISE EXCEPTION 'Errore, stai provando a prenotare uno strumento per un''ora passata';
	 END IF;
	 
	 IF((anno_prenotazione - anno_corrente) > 1 ) THEN
	 	RAISE EXCEPTION 'Non è possibile prenotare uno strumento per un anno il quale non sia quello corrente';
	END IF;
	RETURN NEW;

END 

$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER CONTROLLO_DATE_PASSATE
BEFORE INSERT on PRENOTAZIONE
FOR EACH ROW 
EXECUTE FUNCTION no_prenotazioni_date_passate();

	