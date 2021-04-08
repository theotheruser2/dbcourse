from app import db
from sqlalchemy.exc import IntegrityError, InternalError


class Mage(db.Model):
    __tablename__ = 'mage'

    mage_id = db.Column(db.Integer, primary_key=True)
    smoke_id = db.Column(db.SmallInteger, db.ForeignKey('smoke.smoke_id'), nullable=False)
    locale_id = db.Column(db.SmallInteger, db.ForeignKey('location.locale_id'), nullable=False)
    org_id = db.Column(db.SmallInteger, db.ForeignKey('organization.org_id'))
    name = db.Column(db.String(20), nullable=False)
    mask = db.Column(db.Text)
    in_test = db.Column(db.Boolean, default=False)
    power_lvl = db.Column(db.SmallInteger, nullable=False, default=20)
    side_effect_chance = db.Column(db.Numeric, nullable=False, default=0)
    alive = db.Column(db.Boolean, default=True)
    money = db.Column(db.Integer, nullable=False, default=0)


class Smoke(db.Model):
    __tablename__ = 'smoke'

    smoke_id = db.Column(db.SmallInteger, primary_key=True)
    ability = db.Column(db.String(25), nullable=False)
    description = db.Column(db.Text)
    cost = db.Column(db.Integer, nullable=False)


class Location(db.Model):
    __tablename__ = 'location'

    locale_id = db.Column(db.SmallInteger, primary_key=True)
    loc_name = db.Column(db.String(25), nullable=False)
    population = db.Column(db.Integer, nullable=False)


class Organization(db.Model):
    __tablename__ = 'organization'

    org_id = db.Column(db.SmallInteger, primary_key=True)
    head_id = db.Column(db.Integer, nullable=False)
    name = db.Column(db.String(20), nullable=False)
    description = db.Column(db.Text)


class Human(db.Model):
    __tablename__ = 'human'

    person_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(25), nullable=False)
    locale_id = db.Column(db.SmallInteger, db.ForeignKey('location.locale_id'), nullable=False)
    effect_from = db.Column(db.Integer, db.ForeignKey('mage.mage_id'))
    effect = db.Column(db.Text)
    alive = db.Column(db.Boolean, default=True)


class Training(db.Model):
    __tablename__ = 'training'

    train_id = db.Column(db.Integer, primary_key=True)
    lead_mage = db.Column(db.Integer, db.ForeignKey('mage.mage_id'), nullable=False)
    sidekick = db.Column(db.Integer, db.ForeignKey('mage.mage_id'))
    victim = db.Column(db.Integer, db.ForeignKey('human.person_id'))
    result = db.Column(db.Text)


class Drug(db.Model):
    __tablename__ = 'drug'

    drug_id = db.Column(db.SmallInteger, primary_key=True)
    name = db.Column(db.String(25), nullable=False)
    description = db.Column(db.Text)
    power_mult = db.Column(db.Numeric, nullable=False, default=1.0)
    side_effect_chance = db.Column(db.Numeric, nullable=False, default=0.5)
    cost = db.Column(db.Integer, nullable=False)


class Trade(db.Model):
    __tablename__ = 'trade'

    trade_id = db.Column(db.Integer, primary_key=True)
    smoke_id = db.Column(db.SmallInteger, db.ForeignKey('smoke.smoke_id'))
    drug_id = db.Column(db.SmallInteger, db.ForeignKey('drug.drug_id'))


class Trade_Mage(db.Model):
    __tablename__ = 'trade_mage'

    trade_id = db.Column(db.Integer, db.ForeignKey('trade.trade_id'), primary_key=True)
    seller_id = db.Column(db.Integer, db.ForeignKey('mage.mage_id'), primary_key=True)
    buyer_id = db.Column(db.Integer, db.ForeignKey('mage.mage_id'), primary_key=True)


class Devil(db.Model):
    __tablename__ = 'devil'

    devil_id = db.Column(db.SmallInteger, primary_key=True)
    name = db.Column(db.String(25), nullable=False)
    locale_id = db.Column(db.SmallInteger, db.ForeignKey('location.locale_id'), nullable=False, default=3)
    prev_mage = db.Column(db.Integer, db.ForeignKey('mage.mage_id'))


class Test(db.Model):
    __tablename__ = 'test'

    mage_id = db.Column(db.Integer, db.ForeignKey('mage.mage_id'), nullable=False, primary_key=True)
    devil_id = db.Column(db.Integer, db.ForeignKey('devil.devil_id'))
    result = db.Column(db.Boolean, default=False)


class PgFunctionWrapper:
    def apply_effect(self, trainid):
        stmt = db.select([db.column('apply_effect')]).select_from(db.func.apply_effect(trainid))
        res = db.session.execute(stmt).fetchone().apply_effect
        if res is not None:
            db.session.commit()
            if res != 0:
                return 'Training executed successfully.'
            else:
                return 'The target cannot be affected by magic.'
        else:
            db.session.rollback()
            return 'The training could not be commenced.'

    def demon_test(self, mage_id):
        new_name = db.session.query(Mage).filter_by(mage_id=mage_id).first().name
        new_name = new_name + 'mon'
        try:
            stmt = db.select([db.column('demon_test')]).select_from(db.func.demon_test(mage_id, new_name))
            db.session.execute(stmt)
        except IntegrityError:
            db.session.rollback()
            return
        db.session.commit()
        return

    def remove_effect(self, human_id, mage_id):
        stmt = db.select([db.column('remove_effect')]).select_from(db.func.remove_effect(human_id, mage_id))
        res = db.session.execute(stmt)
        if stmt is not None:
            db.session.commit()
        else:
            db.session.rollback()
        return res.fetchone().remove_effect

    def revive_human(self, human_id, mage_id):
        stmt = db.select([db.column('revive_human')]).select_from(db.func.revive_human(human_id, mage_id))
        res = db.session.execute(stmt)
        if stmt is not None:
            db.session.commit()
        else:
            db.session.rollback()
        return res.fetchone().revive_human

    def revive_mage(self, dead_mage, mage_id):
        stmt = db.select([db.column('revive_mage')]).select_from(db.func.revive_mage(dead_mage, mage_id))
        res = db.session.execute(stmt)
        if stmt is not None:
            db.session.commit()
        else:
            db.session.rollback()
        return res.fetchone().revive_mage

    def do_trade(self, seller, buyer, sms, drug):
        stmt = db.select([db.column('do_trade')]).select_from(db.func.do_trade(seller, buyer, sms, drug))
        res = db.session.execute(stmt)
        if stmt is not None:
            db.session.commit()
        else:
            db.session.rollback()
        return res.fetchone().do_trade

    def mage_relocate(self, mage_id):
        try:
            stmt = db.select([db.column('mage_relocate')]).select_from(db.func.mage_relocate(mage_id))
            db.session.execute(stmt)
        except InternalError:
            db.session.rollback()
            return 1
        db.session.commit()
        return 0

    def get_purchases(self, mage_id):
        purchases = [
            db.column('tradeid'),
            db.column('buyer_name'),
            db.column('seller_name'),
            db.column('seller_id'),
            db.column('smoke_ab'),
            db.column('drug_name')
        ]
        stmt = db.select(purchases).select_from(db.func.get_purchases(mage_id))
        return db.session.execute(stmt).fetchall()

    def insert_training(self, mage_id, sidekick_id, vict_id, result):
        try:
            stmt = db.insert(Training).values(lead_mage=mage_id, sidekick=sidekick_id, victim=vict_id, result=result)
            db.session.execute(stmt)
        except IntegrityError:
            db.session.rollback()
            return 'Could not add training.'
        db.session.commit()
        return 'Training added successfully.'

    def get_trainings(self):
        trainings = [
            db.column('train_id'),
            db.column('lead_mage'),
            db.column('sidekick'),
            db.column('victim'),
            db.column('lm_id'),
            db.column('sk_id'),
            db.column('v_id'),
            db.column('res')
        ]
        stmt = db.select(trainings).select_from(db.func.get_trainings())
        return db.session.execute(stmt).fetchall()

    def get_test_data(self):
        tests = [
            db.column('mage_id'),
            db.column('devil_id'),
            db.column('mage_name'),
            db.column('new_devil'),
            db.column('res')
        ]
        stmt = db.select(tests).select_from(db.func.get_test_data())
        return db.session.execute(stmt).fetchall()


pg_functions = PgFunctionWrapper()

