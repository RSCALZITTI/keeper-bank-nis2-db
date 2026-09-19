-- Prima select vuota perche non ci sono modifiche
SELECT id_log, id_asset, data_modifica, utente_modifica, tipo_operazione, stato_precedente, stato_nuovo
FROM log_audit_asset;


-- Esecuzione di una modifica di test su un asset
BEGIN;

UPDATE asset 
SET versione = '2.5', stato_operativo = 'In Manutenzione' 
WHERE codice_asset = 'HW-SRV-01';

COMMIT;

-- Verifica presenza nuova riga nel log di audit
SELECT id_log, id_asset, data_modifica, utente_modifica, tipo_operazione, stato_precedente, stato_nuovo
FROM log_audit_asset;

-- Esecuzione di una seconda modifica di test su un asset
BEGIN;

UPDATE asset 
SET stato_operativo = 'Dismesso',
    livello_criticita = 'Bassa',
    descrizione = 'Server rimosso dalla produzione per fine ciclo di vita'
WHERE codice_asset = 'HW-SRV-01';

COMMIT;

-- Verifica presenza nuova riga nel log di audit

SELECT id_log, id_asset, data_modifica, utente_modifica, tipo_operazione, stato_precedente, stato_nuovo
FROM log_audit_asset;

-- Esecuzione di una delete di test su un asset

BEGIN;

DELETE FROM asset 
WHERE codice_asset = 'HW-SRV-01';

COMMIT;

-- Verifica presenza nuova riga di delete nel log di audit

SELECT id_log, id_asset, data_modifica, utente_modifica, tipo_operazione, stato_precedente, stato_nuovo
FROM log_audit_asset;

