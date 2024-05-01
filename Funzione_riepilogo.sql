CREATE OR REPLACE VIEW riepilogo AS 
	SELECT codStrumento, Anno, Mese, 
			sum(durata) as Durata_totale, Utente
	FROM (SELECT distinct codstrumento_fk as codStrumento, extract('year' from datautilizzo) as Anno, extract('month' from datautilizzo) as Mese, 
		  orafine - interval '1 second'*extract (epoch from orainizio) AS Durata, username_fk as Utente
		  FROM utilizzato) as T
	GROUP BY codStrumento, anno, mese, utente;

CREATE OR REPLACE FUNCTION riepilogo_strumenti(codS IN INTEGER, mesein IN INTEGER, annoin IN INTEGER)
RETURNS TABLE(codstrumento riepilogo.codstrumento%type,anno riepilogo.anno%type, mese riepilogo.mese%type,durata_totale riepilogo.durata_totale%type,utentemax riepilogo.utente%type ) AS $$
DECLARE 
	utente_max riepilogo.utente%TYPE; 
BEGIN

--questa select recupera l'utente che ha utilizzato di più uno specifico strumento in un determinato mese e anno, o in generale se non viene specificato il parametro del mese e/o anno.
--Più precisamente, la query seleziona la colonna utente dalla tabella riepilogo e la associa alla variabile utente_max tramite la clausola INTO.
--Successivamente, la clausola WHERE della query filtra i risultati in base al parametro cods, che rappresenta il codice dello strumento di interesse, e ai parametri opzionali mesein e annoin, che rappresentano rispettivamente il mese e l'anno di interesse.
--Infine, la clausola GROUP BY raggruppa i risultati in base alla colonna utente, e l'ORDER BY ordina i risultati in base al valore massimo della colonna durata_totale, in ordine decrescente (DESC).
--In questo modo, l'utente che ha utilizzato di più lo strumento di interesse sarà il primo risultato restituito dalla query.
	SELECT utente
	INTO utente_max
	FROM riepilogo as r 
	WHERE r.codstrumento = cods AND (r.mese=mesein OR mesein IS NULL) AND  (r.anno=annoin OR annoin IS NULL)
	GROUP BY utente 
	ORDER BY MAX(r.durata_totale) DESC;

	SELECT *
	INTO codStrumento, anno, mese, durata_totale, utentemax
	FROM riepilogo AS r
	WHERE r.utente=utente_max and r.codstrumento = cods AND (r.mese=mesein OR mesein IS NULL) AND (r.anno=annoin OR annoin IS NULL);
	
	IF NOT FOUND THEN
		raise exception 'Lo strumento % non è stato utilizzato il % dell''anno %', cods,mesein,annoin;
	else
		return next;
	END IF;
END;
$$ LANGUAGE PLPGSQL;

