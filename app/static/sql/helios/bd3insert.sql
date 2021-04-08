INSERT INTO s265092.LOCATION(LOC_NAME, POPULATION) VALUES('Hole', 20000),
('Mage Realm', 100000),
('Hell', 1000000);

SELECT count_residents(1);
SELECT count_residents(2);
SELECT count_residents(3);

INSERT INTO s265092.DRUG(NAME, DESCRIPTION, POWER_MULT, SIDE_EFFECT_CHANCE, COST) VALUES('Black Powder', 'Effective but known for its side effects', 1.75, 0.89, 500),
('Cheap Enhancers', 'Fairly ineffective', 1.15, 0.57, 100),
('Premium Stuff', 'Pricey yet the effect is barely noticeable', 1.2, 0.55, 1000);

INSERT INTO s265092.SMOKE(ABILITY, DESCRIPTION, COST) VALUES
('Healing', 'The affected is healed.', 2000),
('Mushrooms', 'Turned into mushrooms.', 1500),
('Slicing', 'Sliced up, remains alive.', 1500),
('Lizard Transformation', 'Turned into a lizard.', 750),
('Destruction', 'Destroyed.', 200),
('Revival', 'Revived.', 50000),
('Dispelling', 'Curse lifted.', 25000);
('Unknown', 'Only some mess is left over.', 1);
('Poison', 'The target is poisoned.', 500);


INSERT INTO s265092.ORGANIZATION(HEAD_ID, NAME, DESCRIPTION) VALUES
(1, 'En Organization', 'The largest syndycate in the mage realm.'),
(9, 'Cross-Eyes', 'A group that resists the main organization. Responsible for black powder.');

INSERT INTO s265092.MAGE(SMOKE_ID, LOCALE_ID, ORG_ID, NAME, MASK, POWER_LVL, SIDE_EFFECT_CHANCE, MONEY) VALUES
	(2, 2, 1, 'En', 'Covers only half of his face, looks like muscle tissue.', 99, 0, 9999999),
	(1, 2, 1, 'Noi', 'Covers the entire head. Made of leather, has goggles.', 90, 0, 500000),
	(3, 2, 1, 'Shin', 'Looks like a heart.', 95, 0, 500000),
	(4, 2, 1, 'Ebisu', 'Looks like a skull.', 75, 0.3, 65000),
	(5, 2, 1, 'Fujita', 'Covers Fujitas eyes, has a long nose.', 38, 0.2, 700),
	(5, 2, 1, 'MRSELLER', 'Looks like a big cash register.', 10, 0, 500000),
	(6, 2, 1, 'Kikurage', 'Has a cutout for the mouth, stitches and horns.', 95, 0, 0),
	(7, 2, 1, 'Chota', 'Covered in black featgers, has a beak.', 45, 0, 96452),
	(8, 2, 2, 'Kai', 'No mask, has crosses painted on his eyes.', 99, 1, 0),
	(9, 2, 2, 'Dokuga', 'Looks like a moth.', 70, 1, 330);

INSERT INTO s265092.TRADE(SMOKE_ID, DRUG_ID) VALUES
(2, 2),
(3, 3);

INSERT INTO s265092.TRADE_MAGE(SELLER_ID, BUYER_ID, TRADE_ID) VALUES
(6, 5, 1)
(6, 4, 2);

INSERT INTO s265092.DEVIL(NAME, LOCALE_ID) VALUES
('Beelzebub', 3),
('Chidaruma', 3);
INSERT INTO s265092.DEVIL(PREV_MAGE, NAME, LOCALE_ID) VALUES(2, 'Noi From AU', 3);


INSERT INTO s265092.HUMAN(NAME, LOCALE_ID, EFFECT, EFFECT_FROM) VALUES('Kaiman', 1, 'Has a head of a lizard.', 4);
INSERT INTO s265092.HUMAN(NAME, LOCALE_ID) VALUES
('Nikaido', 1);
('Joe', 1),
('Vaux', 1),
('Kasukabe', 1);


INSERT INTO s265092.TRAINING(LEAD_MAGE, SIDEKICK, VICTIM, RESULT) VALUES(3, 2, 3, 'Joe is sliced.');
INSERT INTO s265092.TRAINING(LEAD_MAGE, SIDEKICK, RESULT) VALUES(4, 5, 'The raid was a success.');