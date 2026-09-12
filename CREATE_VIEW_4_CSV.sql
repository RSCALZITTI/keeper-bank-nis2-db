CREATE OR REPLACE VIEW vista_export_profilo_acn AS
SELECT 
    o.ragione_sociale AS azienda,
    o.tipologia_nis2,
    s.codice_servizio,
    s.nome_servizio,
    s.criticita AS criticita_servizio,
    a.codice_asset,
    a.nome_asset,
    a.tipologia AS tipologia_asset,
    a.stato_operativo AS stato_asset,
    a.versione AS versione_asset,
    a.livello_criticita AS criticita_asset,
    COALESCE(f.ragione_sociale, 'Gestione Interna') AS fornitore_terzo,
    COALESCE(f.livello_rischio_supply_chain, 'N/A') AS rischio_fornitore,
    r_asset.nome || ' ' || r_asset.cognome AS referente_tecnico_asset,
    r_asset.email AS email_referente_asset
FROM organizzazioni o
JOIN servizi s ON o.id_organizzazione = s.id_organizzazione
JOIN servizi_asset sa ON s.id_servizio = sa.id_servizio
JOIN asset a ON sa.id_asset = a.id_asset
JOIN responsabili r_asset ON a.id_asset_owner = r_asset.id_responsabile
LEFT JOIN fornitori f ON a.id_fornitore = f.id_fornitore;

-- Esportazione lato client (da eseguire tramite psql):
-- \copy (SELECT * FROM vista_export_profilo_acn) TO 'profilo_nis2_keeperbank.csv' WITH (FORMAT csv, HEADER, DELIMITER ';');

-- Interrogazione della vista per la verifica a video dei dati:
SELECT * FROM vista_export_profilo_acn;
