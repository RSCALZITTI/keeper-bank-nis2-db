-- Indici su tabelle di relazione (FK) per velocizzare le JOIN
CREATE INDEX idx_servizi_organizzazione ON servizi(id_organizzazione);
CREATE INDEX idx_servizi_service_owner ON servizi(id_service_owner);
CREATE INDEX idx_asset_owner ON asset(id_asset_owner);
CREATE INDEX idx_asset_fornitore ON asset(id_fornitore);

-- Indici per filtri di ricerca frequenti nelle analisi ACN e NIS2
CREATE INDEX idx_asset_criticita ON asset(livello_criticita);
CREATE INDEX idx_asset_stato ON asset(stato_operativo);
CREATE INDEX idx_fornitori_rischio ON fornitori(livello_rischio_supply_chain);
CREATE INDEX idx_log_audit_asset_id ON log_audit_asset(id_asset);
