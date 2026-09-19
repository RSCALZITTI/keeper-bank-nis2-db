-- Funzione PL/pgSQL che cattura lo stato dell'asset prima e dopo la modifica

CREATE OR REPLACE FUNCTION trg_audit_asset_func()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        INSERT INTO log_audit_asset (
            id_asset,
            tipo_operazione,
            stato_precedente,
            stato_nuovo
        )
        VALUES (
            OLD.id_asset,
            'UPDATE',
            to_jsonb(OLD),
            to_jsonb(NEW)
        );
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO log_audit_asset (
            id_asset,
            tipo_operazione,
            stato_precedente,
            stato_nuovo
        )
        VALUES (
            NULL,
            'DELETE',
            to_jsonb(OLD),
            NULL
        );
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- Definizione del Trigger legato alla tabella asset
CREATE TRIGGER trg_audit_asset
AFTER UPDATE OR DELETE ON asset
FOR EACH ROW
EXECUTE FUNCTION trg_audit_asset_func();