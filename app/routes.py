from flask import render_template, flash, redirect, url_for, abort, request


from app import app, db
from app.forms import HumanHealForm, HumanReviveForm, MageReviveForm, TradeForm, TrainForm, TravelForm
from app.models import pg_functions, Mage, Human, Devil, Drug, Location, Organization


@app.route('/train/<exec_id>', methods=['GET', 'POST'])
def train(exec_id):
    form = TrainForm()
    if form.validate_on_submit():
        l_mage = Mage.query.filter_by(name=form.mage.data).first()
        sk_mage = Mage.query.filter_by(name=form.sk.data).first()
        person = Human.query.filter_by(name=form.vic.data).first()
        result = form.res.data
        if l_mage is None or l_mage == '':
            flash('The training session could not be initiated without the leading mage.')
            return redirect(url_for('train', exec_id=0))
        if sk_mage is None or sk_mage == '':
            side_m = None
        else:
            side_m = sk_mage.mage_id
        if person is None or person == '':
            v_id = None
        else:
            v_id = person.person_id

        flash(pg_functions.insert_training(l_mage.mage_id, side_m, v_id, result))
        return redirect(url_for('train', exec_id=0))

    all_train = pg_functions.get_trainings()
    return render_template('train.html', trainings=all_train, trfunc=pg_functions.apply_effect, exec_id=exec_id, form=form)


@app.route('/travel/', methods=['GET', 'POST'])
def travel():
    form = TravelForm()
    if form.validate_on_submit():
        t_mage = Mage.query.filter_by(name=form.mage.data).first()
        if t_mage is None or form.mage.data == '':
            flash('Please enter the name of the mage.')
            return redirect(url_for('travel'))
        if pg_functions.mage_relocate(t_mage.mage_id) == 0:
            flash("Travel successful.")
            return redirect(url_for('mage', mage_id=t_mage.mage_id))
        else:
            flash("This mage is not able to travel.")
            return redirect(url_for('mage', mage_id=t_mage.mage_id))

    return render_template('travel.html', form=form)


@app.route('/test/')
def test():
    all_test = pg_functions.get_test_data()
    return render_template('test.html', tests=all_test)


@app.route('/test/<mage_id>')
def testres(mage_id):
    if mage_id is None:
        return redirect(url_for('test'))
    else:
        pg_functions.demon_test(mage_id)
        return redirect(url_for('test'))


@app.route('/')
@app.route('/mage/')
def mages():
    mage_data = db.session.query(Mage).order_by('mage_id').all()
    return render_template('mage_list.html', mage_info=mage_data)


@app.route('/mage/<mage_id>')
def mage(mage_id):
    mage_data = db.session.query(Mage).filter_by(mage_id=mage_id).first()
    trade_data = pg_functions.get_purchases(mage_id)
    return render_template('mage.html', mage_info=mage_data, trade_info=trade_data)

@app.route('/org/<org_id>')
def org(org_id):
    org_data = db.session.query(Organization).filter_by(org_id=org_id).first()
    return render_template('org.html', org_info=org_data)

@app.route('/human/<human_id>')
def human(human_id):
    human_data = db.session.query(Human).filter_by(person_id=human_id).first()
    return render_template('human.html', human_info=human_data)


@app.route('/devil/<devil_id>')
def devil(devil_id):
    devil_data = db.session.query(Devil).filter_by(devil_id=devil_id).first()
    return render_template('devil.html', devil_info=devil_data)


@app.route('/hospital/', methods=['GET', 'POST'])
def hospital():
    hh_form = HumanHealForm()
    if hh_form.validate_on_submit():
        person = Human.query.filter_by(name=hh_form.human_hh.data).first()
        rem_mage = Mage.query.filter_by(name=hh_form.mage_hh.data).first()
        if person is None or rem_mage is None:
            flash('Enter the names of the affected human and the healing mage.')
            return redirect(url_for('hospital'))
        res = pg_functions.remove_effect(person.person_id, rem_mage.mage_id)
        if res == 0:
            flash('Effect lifted.')
            return redirect(url_for('human', human_id=person.person_id))
        elif res == 1:
            flash('Selected mage does not possess healing abilities.')
            return redirect(url_for('hospital'))
        elif res == 2:
            flash('The patient has no effects currently.')
            return redirect(url_for('hospital'))

    hr_form = HumanReviveForm()
    if hr_form.validate_on_submit():
        person = Human.query.filter_by(name=hr_form.human_hr.data).first()
        rev_mage = Mage.query.filter_by(name=hr_form.mage_hr.data).first()
        if person is None or rev_mage is None:
            flash('Enter the names of the affected human and the reviving mage.')
            return redirect(url_for('hospital'))
        res = pg_functions.revive_human(person.person_id, rev_mage.mage_id)
        if res == 0:
            flash('Target revived.')
            return redirect(url_for('human', human_id=person.person_id))
        elif res == 1:
            flash('Selected mage does not possess revival abilities.')
            return redirect(url_for('hospital'))
        elif res == 2:
            flash('The patient does not need to be revived.')
            return redirect(url_for('hospital'))

    mr_form = MageReviveForm()
    if mr_form.validate_on_submit():
        d_mage = Mage.query.filter_by(name=mr_form.mage_revived.data).first()
        rev_mage = Mage.query.filter_by(name=mr_form.mage_reviving.data).first()
        if d_mage is None or rev_mage is None:
            flash('Enter the names of the deceased mage and the reviving mage.')
            return redirect(url_for('hospital'))
        res = pg_functions.revive_mage(d_mage.mage_id, rev_mage.mage_id)
        if res == 0:
            flash('Target revived.')
            return redirect(url_for('mage', mage_id=d_mage.mage_id))
        elif res == 1:
            flash('Selected mage does not possess revival abilities.')
            return redirect(url_for('hospital'))
        elif res == 2:
            flash('The patient does not have the funds for revival.')
            return redirect(url_for('hospital'))
        elif res == 3:
            flash('The patient does not need to be revived.')
            return redirect(url_for('hospital'))

    return render_template('hospital.html', hhform=hh_form, hrform=hr_form, mrform=mr_form)


@app.route('/market/', methods=['GET', 'POST'])
def trade():
    form = TradeForm()
    if form.validate_on_submit():
        seller = Mage.query.filter_by(name=form.seller.data).first()
        buyer = Mage.query.filter_by(name=form.buyer.data).first()
        smoke_sold = form.smoke_sold.data
        if form.drug.data == '' or form.drug.data == 'None' or form.drug.data is None:
            drug = None
        else:
            drug = Drug.query.filter_by(name=form.drug.data).first().drug_id
        if seller is None or buyer is None or seller.mage_id == buyer.mage_id or not seller.alive or not buyer.alive:
            flash('The deal cannot be done without two partners.')
            return redirect(url_for('trade'))
        res = pg_functions.do_trade(seller.mage_id, buyer.mage_id, smoke_sold, drug)
        if res == 0:
            flash('Trade successful.')
            return redirect(url_for('trade'))
        elif res == 1:
            flash('The buyer cannot afford the deal.')
            return redirect(url_for('trade'))
        elif res == 2:
            flash('No goods were offered.')
            return redirect(url_for('trade'))

    return render_template('trade.html', form=form)


@app.route('/locale/<locale_id>')
def locale(locale_id):
    loc_data = db.session.query(Location).filter_by(locale_id=locale_id).first()
    return render_template('locale.html', loc_info=loc_data)

@app.route('/invalid')
def invalid_access():
    return render_template('invalid_access.html')
