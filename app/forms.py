from flask_wtf import FlaskForm
from wtforms import StringField, BooleanField, SubmitField, SelectField
from wtforms.validators import DataRequired


class HumanHealForm(FlaskForm):
    human_hh = StringField('Human\'s name', validators=[DataRequired()])
    mage_hh = StringField('Mage\'s name', validators=[DataRequired()])
    submithh = SubmitField('Remove effect')


class HumanReviveForm(FlaskForm):
    human_hr = StringField('Human\'s name', validators=[DataRequired()])
    mage_hr = StringField('Mage\'s name', validators=[DataRequired()])
    submithr = SubmitField('Revive')


class MageReviveForm(FlaskForm):
    mage_revived = StringField('Dead mage\'s name', validators=[DataRequired()])
    mage_reviving = StringField('Reviving mage\'s name', validators=[DataRequired()])
    submitmr = SubmitField('Revive')


class TradeForm(FlaskForm):
    seller = StringField('Seller\'s Name', validators=[DataRequired()])
    buyer = StringField('Buyer\'s Name', validators=[DataRequired()])
    smoke_sold = BooleanField('Will smoke be sold?')
    drug = SelectField('Drug\'s Name', choices=['None', 'Black Powder', 'Cheap Enhancers', 'Premium Stuff'])
    submit = SubmitField('Trade')


class TrainForm(FlaskForm):
    mage = StringField('Leader\'s Name', validators=[DataRequired()])
    sk = StringField('Sidekick\'s Name')
    vic = StringField('Victim\'s Name')
    res = StringField('Expected result')
    submit = SubmitField('Commence')

class TravelForm(FlaskForm):
    mage = StringField('Mage\'s Name', validators=[DataRequired()])
    submit = SubmitField('Depart')
