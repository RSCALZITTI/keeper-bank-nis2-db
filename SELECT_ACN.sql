SELECT 
    f.ragione_sociale AS fornitore,
    f.livello_rischio_supply_chain,
    f.referente_contatto,
    f.email_contatto,
    a.codice_asset,
    a.nome_asset,
    a.livello_criticita AS criticita_asset,
    s.nome_servizio AS servizio_impattato
FROM fornitori f
JOIN asset a ON f.id_fornitore = a.id_fornitore
JOIN servizi_asset sa ON a.id_asset = sa.id_asset
JOIN servizi s ON sa.id_servizio = s.id_servizio
WHERE f.livello_rischio_supply_chain = 'Alto'
ORDER BY f.ragione_sociale;

SELECT 
    s.codice_servizio,
    s.nome_servizio,
    s.criticita AS criticita_servizio,
    r_serv.nome || ' ' || r_serv.cognome AS service_owner,
    a.codice_asset,
    a.nome_asset,
    a.tipologia AS tipologia_asset,
    a.livello_criticita AS criticita_asset,
    r_asset.nome || ' ' || r_asset.cognome AS asset_owner
FROM servizi s
JOIN responsabili r_serv ON s.id_service_owner = r_serv.id_responsabile
JOIN servizi_asset sa ON s.id_servizio = sa.id_servizio
JOIN asset a ON sa.id_asset = a.id_asset
JOIN responsabili r_asset ON a.id_asset_owner = r_asset.id_responsabile
ORDER BY s.codice_servizio, a.livello_criticita DESC;
