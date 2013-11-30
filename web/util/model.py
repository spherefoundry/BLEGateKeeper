__author__ = 'antoni'

from flask_sqlalchemy import SQLAlchemy
from random import SystemRandom

model = SQLAlchemy()

class User(model.Model):
    user_id = model.Column(model.Integer, primary_key=True)
    email = model.Column(model.String(120), unique=False)
    token = model.Column(model.String(7), unique=False)

    def __init__(self, email, token=None):
        self.email = email
        if token is None:
            random = SystemRandom()
            self.token = ''
            for i in range(0, 16):
                self.token += chr(random.randint(ord('a'), ord('z')))
        else:
            self.token = token

    def __repr__(self):
        return '<User %r %r %r>' % (self.user_id, self.email, self.token)

class Gate(model.Model):
    gate_id = model.Column(model.Integer, primary_key=True)
    name = model.Column(model.String(100), unique=False)
    beacon_major = model.Column(model.Integer, unique=False)
    beacon_minor = model.Column(model.Integer, unique=False)
    is_opened = model.Column(model.Boolean, unique=False)

    def __init__(self, name, beacon_major, beacon_minor):
        self.name = name
        self.beacon_major = beacon_major
        self.beacon_minor = beacon_minor
        self.is_opened = False

    def __repr__(self):
        return '<Gate %r %r %r>' % (self.gate_id, self.beacon_major, self.beacon_minor)

def setup_model(app):
    model.app = app
    model.init_app(app)
    model.drop_all()
    model.create_all()

    admin = User('admin@example.com')
    guest = User('guest@example.com')

    model.session.add(admin)
    model.session.add(guest)

    gate1 = Gate('blueberry pie gate', 26814, 1)
    gate2 = Gate('icy marshmallow gate', 26814, 2)
    gate3 = Gate('mint cocktail gate', 26814, 3)

    model.session.add(gate1)
    model.session.add(gate2)
    model.session.add(gate3)

    model.session.commit()
    print admin
    print guest
    print gate1
    print gate2
    print gate3
