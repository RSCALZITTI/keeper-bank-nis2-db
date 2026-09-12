BEGIN;

-- 1. Inserimento dell'Organizzazione
INSERT INTO organizzazioni (ragione_sociale, partita_iva, settore, tipologia_nis2, referente_acn_email)
VALUES ('Keeper Bank S.p.A.', '09876543210', 'Bancario', 'Essenziale', 'acn-compliance@keeperbank.it');

-- 2. Inserimento dei Responsabili
INSERT INTO responsabili (nome, cognome, email, telefono, ruolo, dipartimento) VALUES
('Marco', 'Rossi', 'm.rossi@keeperbank.it', '+39 02 111111', 'CISO', 'Cybersecurity'),
('Laura', 'Bianchi', 'l.bianchi@keeperbank.it', '+39 02 222222', 'Asset Owner', 'IT Infrastructure'),
('Giuseppe', 'Verdi', 'g.verdi@keeperbank.it', '+39 02 333333', 'Service Owner', 'Digital Banking'),
('Elena', 'Neri', 'e.neri@keeperbank.it', '+39 02 444444', 'Asset Owner', 'Core Systems'),
('Roberto', 'Ferrari', 'r.ferrari@keeperbank.it', '+39 02 555555', 'Referente ACN', 'Compliance & Legal');

-- 3. Inserimento dei Servizi Essenziali
INSERT INTO servizi (codice_servizio, nome_servizio, descrizione, criticita, id_organizzazione, id_service_owner) VALUES
('SE01', 'Home & Mobile Banking', 'Piattaforma di erogazione servizi di e-banking web ed app mobile', 'Critico', 1, 3),
('SE02', 'Autorizzazione Pagamenti & POS', 'Gestione autorizzazioni transazioni carte di credito/debito ed ATM', 'Critico', 1, 3),
('SE03', 'Core Banking & Contabilità', 'Piattaforma centrale saldi e movimenti dei conti correnti', 'Critico', 1, 4),
('SE04', 'Rete Interbancaria SWIFT/SEPA', 'Canali dedicati al regolamento bonifici e trasferimenti interbancari', 'Alta', 1, 4);

-- 4. Inserimento dei Fornitori (Supply Chain)
INSERT INTO fornitori (ragione_sociale, partita_iva, referente_contatto, email_contatto, livello_rischio_supply_chain) VALUES
('Cloud Horizon S.r.l.', 'IT11223344556', 'Stefano Conti', 'support@cloudhorizon.it', 'Alto'),
('SecPay Tech S.p.A.', 'IT99887766554', 'Andrea Valli', 'soc@secpaytech.it', 'Alto'),
('CyberGuard Solutions', 'IT55667788990', 'Paolo Moretti', 'incident@cyberguard.it', 'Medio');

-- 5. Inserimento degli Asset
INSERT INTO asset (codice_asset, nome_asset, tipologia, descrizione, stato_operativo, livello_criticita, versione, id_asset_owner, id_fornitore) VALUES
('HW-SRV-01', 'Cluster Server Web Banking', 'Hardware', 'Cluster di server dedicati all app web Home Banking', 'Attivo', 'Critica', '2.4', 2, 1),
('SW-DBMS-01', 'PostgreSQL Cluster DB', 'Software', 'Database cluster contenente i dati di sessione e anagrafici', 'Attivo', 'Critica', '14.2', 4, NULL),
('NET-FW-01', 'Firewall Perimetrale DMZ', 'Rete', 'Apparato Firewall di protezione DMZ perimetrale', 'Attivo', 'Critica', '8.1', 2, 3),
('SW-API-01', 'API Gateway Pagamenti', 'Software', 'Middleware di integrazione con i circuiti POS e carte', 'Attivo', 'Critica', '3.0', 4, 2),
('HW-HSM-01', 'Modulo HSM Crittografico', 'Hardware', 'Apparato Hardware Security Module per chiavi di cifratura SWIFT', 'Attivo', 'Alta', '1.1', 2, NULL),
('DAT-ANAG-01', 'DB Anagrafica Clienti', 'Dati', 'Banca dati anagrafica istituzionale dei correntisti', 'Attivo', 'Critica', '1.0', 4, NULL);

-- 6. Mappatura Servizi - Asset (Relazione M:N)
INSERT INTO servizi_asset (id_servizio, id_asset) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 3),
(2, 4),
(3, 2),
(3, 6),
(4, 5);

COMMIT;
