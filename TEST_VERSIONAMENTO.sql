-- Prima select vuota perche non ci sono modifiche
SELECT id_log, id_asset, data_modifica, utente_modifica, tipo_operazione, stato_precedente, stato_nuovo
FROM log_audit_asset;


-- Esecuzione di una modifica di test su un asset
BEGIN;

UPDATE asset 
SET versione = '2.5', stato_operativo = 'In Manutenzione' 
WHERE codice_asset = 'HW-SRV-01';

COMMIT;

-- Verifica della registrazione dello storico di Audit
SELECT id_log, id_asset, data_modifica, utente_modifica, tipo_operazione, stato_precedente, stato_nuovo
FROM log_audit_asset;
