CREATE TABLE organizzazioni (
    id_organizzazione SERIAL PRIMARY KEY,
    ragione_sociale VARCHAR(150) NOT NULL,
    partita_iva VARCHAR(16) NOT NULL UNIQUE,
    settore VARCHAR(50) NOT NULL,
    tipologia_nis2 VARCHAR(20) NOT NULL CONSTRAINT chk_nis2_tipologia CHECK (tipologia_nis2 IN ('Essenziale', 'Importante')),
    referente_acn_email VARCHAR(100) NOT NULL
);

CREATE TABLE responsabili (
    id_responsabile SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    ruolo VARCHAR(50) NOT NULL,
    dipartimento VARCHAR(50) NOT NULL
);

CREATE TABLE servizi (
    id_servizio SERIAL PRIMARY KEY,
    codice_servizio VARCHAR(20) NOT NULL UNIQUE,
    nome_servizio VARCHAR(100) NOT NULL,
    descrizione TEXT,
    criticita VARCHAR(20) NOT NULL CONSTRAINT chk_servizio_criticita CHECK (criticita IN ('Critico', 'Alta', 'Media', 'Bassa')),
    id_organizzazione INT NOT NULL REFERENCES organizzazioni(id_organizzazione) ON DELETE RESTRICT,
    id_service_owner INT NOT NULL REFERENCES responsabili(id_responsabile) ON DELETE RESTRICT
);

CREATE TABLE fornitori (
    id_fornitore SERIAL PRIMARY KEY,
    ragione_sociale VARCHAR(150) NOT NULL,
    partita_iva VARCHAR(20) UNIQUE,
    referente_contatto VARCHAR(100) NOT NULL,
    email_contatto VARCHAR(100) NOT NULL,
    livello_rischio_supply_chain VARCHAR(10) NOT NULL CONSTRAINT chk_fornitore_rischio CHECK (livello_rischio_supply_chain IN ('Alto', 'Medio', 'Basso'))
);

CREATE TABLE asset (
    id_asset SERIAL PRIMARY KEY,
    codice_asset VARCHAR(30) NOT NULL UNIQUE,
    nome_asset VARCHAR(100) NOT NULL,
    tipologia VARCHAR(30) NOT NULL CONSTRAINT chk_asset_tipologia CHECK (tipologia IN ('Hardware', 'Software', 'Rete', 'Dati')),
    descrizione TEXT,
    stato_operativo VARCHAR(20) NOT NULL CONSTRAINT chk_asset_stato CHECK (stato_operativo IN ('Attivo', 'In Manutenzione', 'Dismesso')),
    livello_criticita VARCHAR(20) NOT NULL CONSTRAINT chk_asset_criticita CHECK (livello_criticita IN ('Critica', 'Alta', 'Media', 'Bassa')),
    versione VARCHAR(20) NOT NULL DEFAULT '1.0',
    id_asset_owner INT NOT NULL REFERENCES responsabili(id_responsabile) ON DELETE RESTRICT,
    id_fornitore INT REFERENCES fornitori(id_fornitore) ON DELETE SET NULL
);

CREATE TABLE servizi_asset (
    id_servizio INT NOT NULL REFERENCES servizi(id_servizio) ON DELETE CASCADE,
    id_asset INT NOT NULL REFERENCES asset(id_asset) ON DELETE CASCADE,
    data_associazione TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_servizio, id_asset)
);

CREATE TABLE log_audit_asset (
    id_log SERIAL PRIMARY KEY,
    id_asset INT REFERENCES asset(id_asset) ON DELETE SET NULL,
    data_modifica TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    utente_modifica VARCHAR(50) DEFAULT CURRENT_USER NOT NULL,
    tipo_operazione VARCHAR(10) NOT NULL CHECK (tipo_operazione IN ('INSERT', 'UPDATE', 'DELETE')),
    stato_precedente JSONB,
    stato_nuovo JSONB
);
