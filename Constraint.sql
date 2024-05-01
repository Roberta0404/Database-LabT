ALTER TABLE laboratorio
ADD CONSTRAINT orariol
CHECK (orario_apertura='08:00:00' AND orario_chiusura='20:00:00');

ALTER TABLE laboratorio 
ADD CONSTRAINT num_tecnici_valido
CHECK (num_tecnici between 0 AND 100);

ALTER TABLE laboratorio
ADD CONSTRAINT num_postazioni_valido
CHECK (num_postazioni between 0 and 50);

ALTER TABLE TECNICO
ADD CONSTRAINT codicefiscale_valido
CHECK(length (codfiscale)=16);

ALTER TABLE TECNICO
ADD CONSTRAINT telefono_valido
CHECK (length (telefono)=10);

ALTER TABLE tecnico
ADD CONSTRAINT email_validot
CHECK ( position('@' in email) > 1);

ALTER TABLE utente
ADD CONSTRAINT username_valido
CHECK (username NOT LIKE '%-%' AND username NOT LIKE '%"%' AND username NOT LIKE '%?%' AND LENGTH(username) >= 10);

ALTER TABLE utente
ADD CONSTRAINT email_valido
CHECK ( position('@' in email) > 1);

ALTER TABLE postazione 
ADD CONSTRAINT num_posti_valido
CHECK (num_posti>=0);

ALTER TABLE utilizzato
ADD CONSTRAINT ora_valida
CHECK (orafine>=orainizio)

