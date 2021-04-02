INSERT INTO s265092.LOCATION(LOC_NAME, POPULATION) VALUES('Hole', 20000);
INSERT INTO s265092.LOCATION(LOC_NAME, POPULATION) VALUES('Mage Realm', 100000);
INSERT INTO s265092.LOCATION(LOC_NAME, POPULATION) VALUES('Hell', 1000000);

INSERT INTO s265092.DRUG(NAME, DESCRIPTION, POWER_MULT, SIDE_EFFECT_CHANCE, COST) VALUES('Black Powder', 'Effective but known for its side effects', 1.75, 0.89, 500);
INSERT INTO s265092.DRUG(NAME, DESCRIPTION, POWER_MULT, SIDE_EFFECT_CHANCE, COST) VALUES('Cheap Enhancers', 'Fairly ineffective', 1.15, 0.57, 100);
INSERT INTO s265092.DRUG(NAME, DESCRIPTION, POWER_MULT, SIDE_EFFECT_CHANCE, COST) VALUES('Premium Stuff', 'Pricey yet the effect is barely noticable', 1.2, 0.55, 1000);

INSERT INTO s265092.SMOKE(ABILITY, DESCRIPTION, COST) VALUES('Healing', 'Heals all injuries, does not revive.', 2000);
INSERT INTO s265092.SMOKE(ABILITY, DESCRIPTION, COST) VALUES('Mushrooms', 'Turns any object into mushrooms upon contact.', 1500);
INSERT INTO s265092.SMOKE(ABILITY, DESCRIPTION, COST) VALUES('Slicing', 'Slices up anything, victims remain alive.', 1500);
INSERT INTO s265092.SMOKE(ABILITY, DESCRIPTION, COST) VALUES('Lizard Transformation', 'Transforms victim into a lizard', 750);
INSERT INTO s265092.SMOKE(ABILITY, DESCRIPTION, COST) VALUES('Destruction', 'Destroys things.', 200);


INSERT INTO s265092.ORGANIZATION(HEAD_ID, NAME, DESCRIPTION) VALUES(1, 'En Organization', 'The largest syndycate in the mage realm.');

INSERT INTO s265092.MAGE(SMOKE_ID, LOCALE_ID, ORG_ID, NAME, MASK, POWER_LVL, SIDE_EFFECT_CHANCE, MONEY) VALUES(2, 2, 1, 'En', 'Covers only half of his face, looks like muscle tissue.', 99, 0, 9999999);
INSERT INTO s265092.MAGE(SMOKE_ID, LOCALE_ID, ORG_ID, NAME, MASK, POWER_LVL, SIDE_EFFECT_CHANCE, MONEY) VALUES(1, 2, 1, 'Noi', 'Covers the entire head. Made of leather, has goggles.', 90, 0, 500000);
INSERT INTO s265092.MAGE(SMOKE_ID, LOCALE_ID, ORG_ID, NAME, MASK, POWER_LVL, SIDE_EFFECT_CHANCE, MONEY) VALUES(3, 2, 1, 'Shin', 'Looks like a heart.', 95, 0, 500000);
INSERT INTO s265092.MAGE(SMOKE_ID, LOCALE_ID, ORG_ID, NAME, MASK, POWER_LVL, SIDE_EFFECT_CHANCE, MONEY) VALUES(4, 2, 1, 'Ebisu', 'Looks like a skull.', 75, 0.3, 65000);
INSERT INTO s265092.MAGE(SMOKE_ID, LOCALE_ID, ORG_ID, NAME, MASK, POWER_LVL, SIDE_EFFECT_CHANCE, MONEY) VALUES(5, 2, 1, 'Fujita', 'Covers Fujita's eyes, has a long nose.', 38, 0.2, 700);
INSERT INTO s265092.MAGE(SMOKE_ID, LOCALE_ID, ORG_ID, NAME, MASK, POWER_LVL, SIDE_EFFECT_CHANCE, MONEY) VALUES(5, 2, 1, 'MRSELLER', 'Looks like a big cash register.', 10, 0, 500000);

INSERT INTO s265092.TRADE(SELLER_ID, BUYER_ID, SMOKE_ID, DRUG_ID, PRICE) VALUES(6, 5, NULL, 2, 100);
INSERT INTO s265092.TRADE(SELLER_ID, BUYER_ID, SMOKE_ID, DRUG_ID, PRICE) VALUES(5, 6, 5, NULL, 200);

INSERT INTO s265092.DEVIL(NAME) VALUES('Beelzebub');
INSERT INTO s265092.DEVIL(PREV_MAGE, NAME) VALUES(2, 'Noi From AU');

INSERT INTO s265092.TEST(MAGE_ID, DEVIL_ID, RESULT) VALUES(2, 2, 'That did not happen, but the example had to be done.');
INSERT INTO s265092.TEST(MAGE_ID, RESULT) VALUES(6, 'He does not even exist.');

INSERT INTO s265092.HUMAN(NAME, EFFECT, EFFECT_FROM) VALUES('Kaiman', 'Has a head of a lizard.', 4);
INSERT INTO s265092.HUMAN(NAME) VALUES('Nikaido');
INSERT INTO s265092.HUMAN(NAME) VALUES('Joe');

INSERT INTO s265092.TRAIN(LEAD_MAGE, SIDEKICK, VICTIM, RESULT) VALUES(3, 2, 3, 'Joe is sliced.');
INSERT INTO s265092.TRAIN(LEAD_MAGE, SIDEKICK, RESULT) VALUES(4, 5, 'The raid was a success.');