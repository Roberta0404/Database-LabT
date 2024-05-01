CREATE OR REPLACE VIEW calendario (codice_strumento,descrizione_strumento,nome_sede,data_prenotazione,ora_inizio,ora_fine) AS
(
	SELECT s.codStrumento, s.descrizione, se.nome, pr.data_prenotazioneS, pr.ora_prenotazioneS, 
		(pr.ora_prenotazioneS + interval '1 second' * extract(epoch from pr.tempo_utilizzoS))
		FROM strumento AS s	JOIN sede AS se ON s.codSede_fk = se.cods
  			LEFT JOIN prenotazione AS pr ON pr.codstrumento_fk = s.codstrumento
)

--LEFT JOIN per includere tutte le informazioni sullo strumento, anche se non è stato prenotato. 
--In questo modo, le colonne della tabella Calendario che riguardano la prenotazione avranno un valore NULL se lo strumento non è stato prenotato. 

CREATE OR REPLACE FUNCTION calendario_prenotazioni_s(IN descrizione_in VARCHAR(200), IN sede_in VARCHAR(50)) 
RETURNS TABLE (codice_strumento INTEGER, descrizione_strumento VARCHAR(200),nome_sede VARCHAR(50), data_prenotazione DATE, ora_inizio TIME, ora_fine TIME) AS $$		 
DECLARE 
	riga_tab_ritorno calendario%rowtype;
BEGIN 
	FOR riga_tab_ritorno IN 
		SELECT *
		FROM calendario as ca
		WHERE  (ca.descrizione_strumento ILIKE '%' ||descrizione_in|| '%' OR descrizione_in='') AND (ca.nome_sede ILIKE '%' ||sede_in|| '%' OR sede_in = '')
		ORDER BY ca.data_prenotazione DESC

	LOOP
	 		codice_strumento := riga_tab_ritorno.codice_strumento;
	 		descrizione_strumento := riga_tab_ritorno.descrizione_strumento;
	 		nome_sede := riga_tab_ritorno.nome_sede;
	 		data_prenotazione := riga_tab_ritorno.data_prenotazione;
	 		ora_inizio := riga_tab_ritorno.ora_inizio;
	 		ora_fine := riga_tab_ritorno.ora_fine;
	 		RETURN NEXT;--restituisce riga per riga il risualtato di una query
	END LOOP;
END;
$$ LANGUAGE plpgsql;
