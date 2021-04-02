CREATE OR REPLACE FUNCTION apply_effect(APPLIER INTEGER, TRAINID INTEGER, APPEFFECT TEXT) RETURNS VOID AS 
$$
DECLARE
    VICTIMID INTEGER;
BEGIN
    VICTIMID = (SELECT VICTIM FROM TRAINING WHERE TRAINING.TRAIN_ID = TRAINID);
    UPDATE HUMAN 
    SET EFFECT = APPEFFECT,
        EFFECT_FROM = APPLIER
    WHERE PERSON_ID = VICTIMID;
END;
$$
    LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION remove_effect(HUMAN INTEGER, MAGE INTEGER) RETURNS VOID AS 
$$
DECLARE
    SMOKE VARCHAR(25);
BEGIN
    SMOKE = (SELECT ABILITY FROM SMOKE 
        JOIN MAGE ON MAGE.SMOKE_ID = SMOKE_ID WHERE MAGE.MAGE_ID = MAGE);
    IF (SMOKE == 'Healing') THEN
        UPDATE HUMAN
        SET HUMAN.EFFECT = NULL,
            HUMAN.EFFECT_FROM = NULL
        WHERE HUMAN.PERSON_ID = HUMAN;
    END IF;
END;
$$
    LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION do_trade(SELLER INTEGER, BUYER INTEGER, SMOKE_FOR_SALE INTEGER, DRUG_FOR_SALE INTEGER) RETURNS VOID AS
$$
DECLARE
    BUYER_BALANCE INTEGER;
    SELLER_BALANCE INTEGER;
    PRICE INTEGER;
    TRADEID INTEGER;
	NEW_POWER SMALLINT;
BEGIN
    PRICE = (SELECT COST FROM SMOKE WHERE SMOKE_ID = SMOKE_FOR_SALE) + (SELECT COST FROM DRUG WHERE DRUG_ID = DRUG_FOR_SALE);
    SELLER_BALANCE = (SELECT MONEY FROM MAGE WHERE MAGE_ID = SELLER);
    BUYER_BALANCE = (SELECT MONEY FROM MAGE WHERE MAGE_ID = BUYER);
    IF (BUYER_BALANCE >= PRICE) THEN

        INSERT INTO TRADE (SMOKE_ID, DRUG_ID) VALUES (SMOKE_FOR_SALE, DRUG_FOR_SALE);
        
        TRADEID = (SELECT TRADE_ID FROM TRADE ORDER BY TRADE_ID DESC LIMIT 1);

        INSERT INTO TRADE_MAGE (SELLER_ID, BUYER_ID, TRADE_ID) VALUES (SELLER, BUYER, TRADEID);
        NEW_POWER = (SELECT POWER_MULT FROM DRUG WHERE DRUG_ID = DRUG_FOR_SALE) * (SELECT POWER_LVL FROM MAGE WHERE MAGE_ID = BUYER);
		IF (NEW_POWER > 100) THEN
			NEW_POWER = 100;
		END IF;
        UPDATE MAGE
        SET MONEY = BUYER_BALANCE - PRICE,
			SIDE_EFFECT_CHANCE = (SELECT SIDE_EFFECT_CHANCE FROM DRUG WHERE DRUG_ID = DRUG_FOR_SALE),
			POWER_LVL = NEW_POWER
        WHERE MAGE_ID = BUYER;
    
        UPDATE MAGE
        SET MONEY = SELLER_BALANCE + PRICE
        WHERE MAGE_ID = SELLER;
		
    END IF;
END;
$$
    LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION demon_test(MAGEID INTEGER, NEW_NAME VARCHAR(25)) RETURNS VOID AS
$$
DECLARE
    CHANCE INTEGER;
    NEW_DEVIL SMALLINT;
	NEW_LOCALE SMALLINT;
-- 10 ВЕРХНЯЯ ГРАНИЦА, 1 НИЖНЯЯ
BEGIN
	UPDATE MAGE SET IN_TEST = TRUE WHERE MAGE_ID = MAGEID;
    CHANCE = (SELECT RANDOM() * 10) + (SELECT POWER_LVL FROM MAGE WHERE MAGE_ID = MAGEID); 
    IF (CHANCE > 90) THEN
        INSERT INTO DEVIL(PREV_MAGE, NAME) VALUES (MAGEID, NEW_NAME);
        NEW_DEVIL = (SELECT DEVIL_ID FROM DEVIL ORDER BY DEVIL_ID DESC LIMIT 1);
        INSERT INTO TEST(MAGE_ID, DEVIL_ID, RESULT) VALUES (MAGEID, NEW_DEVIL, TRUE);
    ELSE 
        UPDATE MAGE SET ALIVE = FALSE WHERE MAGE_ID = MAGEID;
		NEW_LOCALE = (SELECT LOCALE_ID FROM LOCATION WHERE LOC_NAME = 'Hell');
		INSERT INTO TEST(MAGE_ID, DEVIL_ID, RESULT) VALUES (MAGEID, NEW_DEVIL, FALSE);
		UPDATE MAGE SET LOCALE_ID = NEW_LOCALE WHERE MAGE_ID = MAGEID;
    END IF;
END;
$$
    LANGUAGE PLPGSQL;
	
CREATE OR REPLACE FUNCTION count_residents(LOC SMALLINT) RETURNS VOID AS
$$
DECLARE
	RESIDENTS INTEGER;
BEGIN
	RESIDENTS = (SELECT COUNT(MAGE_ID) FROM MAGE WHERE MAGE.LOCALE_ID = LOC and MAGE.ALIVE = true GROUP BY MAGE_ID) +
				(SELECT COUNT(HUMAN_ID) FROM HUMAN WHERE HUMAN.LOCALE_ID = LOC and HUMAN.ALIVE = true GROUP BY HUMAN_ID) +
				(SELECT COUNT(DEVIL_ID) FROM DEVIL WHERE DEVIL.LOCALE_ID = LOC GROUP BY DEVIL_ID);
	UPDATE LOC SET POPULATION = RESIDENTS;
END;
$$
    LANGUAGE PLPGSQL;



-------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION mage_in_train_func() RETURNS TRIGGER AS
$$
DECLARE
    IS_IN_TRAINING INTEGER;
BEGIN
    IS_IN_TRAINING = (SELECT COUNT(SIDEKICK) FROM TRAINING WHERE TRAINING.SIDEKICK = NEW.EFFECT_FROM GROUP BY SIDEKICK ORDER BY SIDEKICK) 
                    + (SELECT COUNT(LEAD_MAGE) FROM TRAINING WHERE TRAINING.LEAD_MAGE = NEW.EFFECT_FROM GROUP BY LEAD_MAGE ORDER BY LEAD_MAGE);
    IF (IS_IN_TRAINING == 0) THEN 
        RAISE EXCEPTION 'No mages were involed in the effect casting.';
    END IF;
END;
$$
    LANGUAGE PLPGSQL;

CREATE TRIGGER IS_MAGE_IN_THIS_TRAINING
    BEFORE UPDATE OF EFFECT
    ON HUMAN
EXECUTE PROCEDURE mage_in_train_func();


CREATE OR REPLACE FUNCTION mage_dead() RETURNS TRIGGER AS
$$
DECLARE
    OLD_LOC SMALLINT;
	NEW_LOC SMALLINT;
BEGIN
    IF (NOT(SELECT ALIVE FROM MAGE WHERE ALIVE = FALSE AND OLD.ALIVE = true)) THEN
        OLD_LOC = (SELECT LOCALE_ID FROM MAGE WHERE ALIVE = FALSE AND OLD.ALIVE = TRUE);
		NEW_LOC = (SELECT LOCALE_ID FROM LOCATION WHERE LOC_NAME = 'Hell');
		UPDATE LOCATION SET POPULATION = POPULATION - 1 WHERE LOCALE_ID = OLD_LOC;
		UPDATE LOCATION SET POPULATION = POPULATION + 1 WHERE LOCALE_ID = NEW_LOC;
		RETURN NEW;
    END IF;
	RETURN NULL;
END;
$$
    LANGUAGE PLPGSQL;

CREATE TRIGGER MAGE_DEAD_TRIGGER
    AFTER UPDATE OF ALIVE
    ON MAGE
	FOR EACH ROW
EXECUTE PROCEDURE mage_dead();

CREATE OR REPLACE FUNCTION human_dead() RETURNS TRIGGER AS
$$
DECLARE
    OLD_LOC SMALLINT;
BEGIN
    IF (NOT(SELECT ALIVE FROM HUMAN WHERE ALIVE = FALSE AND OLD.ALIVE = TRUE)) THEN
        OLD_LOC = (SELECT LOCALE_ID FROM HUMAN WHERE ALIVE = FALSE AND OLD.ALIVE = TRUE);
		UPDATE LOCATION SET POPULATION = POPULATION - 1 WHERE LOCALE_ID = OLD_LOC;
		RETURN NEW;
    END IF;
	RETURN NULL;
END;
$$
    LANGUAGE PLPGSQL;

CREATE TRIGGER HUMAN_DEAD_TRIGGER
    AFTER UPDATE OF ALIVE
    ON HUMAN
	FOR EACH ROW
EXECUTE PROCEDURE human_dead();