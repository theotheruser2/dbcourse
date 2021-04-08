DROP FUNCTION apply_effect(integer);
DROP FUNCTION remove_effect(integer, integer);
DROP FUNCTION revive_human(integer, integer);
DROP FUNCTION revive_mage(integer, integer);
DROP FUNCTION do_trade(integer, integer, boolean, integer);
DROP FUNCTION demon_test(integer, varchar(25));
DROP FUNCTION count_residents(integer);
DROP FUNCTION mage_relocate(integer);
DROP FUNCTION get_purchases(MAGEID integer);
DROP FUNCTION get_trainings();
DROP FUNCTION get_test_data();
DROP FUNCTION mage_in_train_func();
DROP FUNCTION human_dead();
DROP FUNCTION mage_dead();
DROP FUNCTION mage_relocated();



DROP TABLE MAGE CASCADE;
DROP TABLE SMOKE CASCADE;
DROP TABLE LOCATION CASCADE;
DROP TABLE DRUG CASCADE;
DROP TABLE ORGANIZATION;
DROP TABLE HUMAN CASCADE;
DROP TABLE DEVIL CASCADE;
DROP TABLE TEST;
DROP TABLE TRADE CASCADE;
DROP TABLE TRADE_MAGE;
DROP TABLE TRAINING;