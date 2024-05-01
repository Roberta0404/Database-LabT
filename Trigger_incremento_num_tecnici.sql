--trigger che incrementa il numero di tecnici in un laboratorio quando viene inserito un nuovo tecnico
CREATE OR REPLACE FUNCTION incremento_num_tecnici()
RETURNS TRIGGER AS $$
BEGIN 
	UPDATE Laboratorio SET num_tecnici = num_tecnici + 1
	WHERE CodL = NEW.CodL_fk;
  	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER incremento_tecnici
AFTER INSERT ON Tecnico
FOR EACH ROW
	EXECUTE FUNCTION incremento_num_tecnici();