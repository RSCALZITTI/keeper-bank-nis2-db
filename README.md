# keeper-bank-nis2-db
Progettazione di una base dati PostgreSQL per la gestione degli asset informatici in ambito NIS2/ACN

================================================================================
DOCUMENTAZIONE TECNICA: NORMALIZZAZIONE, TRADE-OFF E DEPLOYMENT
================================================================================

1. ANALISI DI NORMALIZZAZIONE (3NF)
--------------------------------------------------------------------------------
Lo schema relazionale è stato progettato per garantire il rispetto rigoroso 
della Terza Forma Normale (3NF):

- Prima Forma Normale (1NF):
  Ogni colonna contiene unicamente valori atomici e indivisibili. Non sono 
  presenti attributi multi-valore o gruppi di attributi ripetuti. Ogni tabella 
  è dotata di una chiave primaria univoca.

- Seconda Forma Normale (2NF):
  Lo schema è in 1NF e tutti gli attributi non-chiave dipendono interamente 
  dall'intera chiave primaria. Nella tabella di giunzione 'servizi_asset', 
  l'attributo 'data_associazione' dipende dalla chiave primaria composta 
  (id_servizio, id_asset).

- Terza Forma Normale (3NF):
  Lo schema è in 2NF e non esistono dipendenze funzionali transitive tra 
  attributi non-chiave. Le anagrafiche dei responsabili interni e dei fornitori 
  esterni sono state separate dalle entità principali ('servizi' e 'asset'), 
  eliminando ogni ridondanza informativa e rischio di anomalia in fase di 
  aggiornamento o inserimento.


2. SCELTE PROGETTUALI E TRADE-OFF ARCHITETTURALI
--------------------------------------------------------------------------------
- Storico Modifiche tramite JSONB vs Normalizzazione dell'Audit:
  Scelta: Per la tabella 'log_audit_asset', si è scelto di memorizzare lo stato 
  precedente (OLD) e nuovo (NEW) sotto forma di oggetti JSONB gestiti via 
  Trigger PL/pgSQL.
  Trade-off: Questa scelta denormalizza il log ma garantisce il disaccoppiamento 
  strutturale: eventuali evoluzioni o modifiche alle colonne della tabella 
  'asset' non richiederanno mai la modifica della tabella di audit, riducendo la 
  complessità manutentiva e garantendo l'immutabilità dello storico.

- Gestione dell'Integrità Referenziale (RESTRICT vs SET NULL / CASCADE):
  Scelta: Per le chiavi esterne legate a 'organizzazioni' e 'responsabili' è 
  stato adottato ON DELETE RESTRICT per bloccare la cancellazione accidentale 
  di entità con servizi o asset attivi. Per i 'fornitori', si è scelto ON DELETE 
  SET NULL, mentre per la giunzione N:M ('servizi_asset') si è applicato ON DELETE CASCADE.
  Trade-off: Il vincolo SET NULL sui fornitori assicura che un asset permanga a 
  sistema anche in caso di cessazione del contratto con la terza parte, 
  preservando la continuità operativa dell'analisi NIS2/DORA.


================================================================================
3. ISTRUZIONI PER IL DEPLOYMENT E SEQUENZA DEGLI SCRIPT
================================================================================

- Dipendenze Database:
  * Motore DB: PostgreSQL (versione 14 o superiore).
  * Linguaggi ed Estensioni: Supporto nativo a PL/pgSQL e tipo dati JSONB.

- Ordine Sequenziale di Esecuzione:
  Per rispettare i vincoli di chiave esterna (FK) e le dipendenze degli oggetti, 
  gli script SQL devono essere eseguiti esattamente nel seguente ordine:

  1. CREATE_TABLE_DDL.sql          (Creazione strutture tabelle e vincoli)
  2. CREATE_INDEX.sql              (Creazione indici sulle FK e sui filtri ACN)
  3. CREATE_TRIGGER_WITH_FUNCTION.sql (Definizione logica di audit log)
  4. INSERT.sql                    (Popolamento dataset Keeper Bank S.p.A.)
  5. CREATE_VIEW_4_CSV.sql         (Creazione vista per export ACN)
  6. SELECT_ACN.sql                (Query di reporting e verifica NIS2)
  7. TEST_VERSIONAMENTO.sql        (Test di modifica asset e verifica trigger)
================================================================================
