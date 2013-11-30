__author__ = 'antoni'

from flask import Flask, make_response, render_template, request

app = Flask(__name__)

app.config['SECRET_KEY'] = 'gatekeeper_abc'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///gatekeeper.sqlite'

from util.admin import admin
from util.model import model, Gate, User
import json

model.app = app
model.init_app(app)
admin.init_app(app)

def make_json_response(obj):
    resp = make_response(json.dumps(obj))
    resp.headers['Content-Type'] = 'application/json'
    return resp

def make_json_error_response(error):
    return make_json_response({'error': error})

def user_for_request():
    token = request.headers.get('x-blegatekeeper-token')
    if token is None:
        return None
    user = User.query.filter_by(token=token).first()
    return user


@app.route("/gate/view/<int:gate_id>/")
def gate_view(gate_id):
    return render_template('gate_view.html', gate_id=gate_id)

@app.route("/gate/list")
def gate_list():
    gateObjects = Gate.query.all()
    gates = []
    for gateObject in gateObjects:
        gate = {'id': gateObject.gate_id,
                'name': gateObject.name,
                'major': gateObject.beacon_minor,
                'minor': gateObject.beacon_minor}

        gates.append(gate)

    return make_json_response(gates)

@app.route("/gate/<int:gate_id>/", methods=['GET', 'POST'])
def gate_control(gate_id):
    gateObject = Gate.query.filter_by(gate_id=gate_id).first()

    if gateObject is None:
        return make_json_error_response('no such gate')

    if request.method == 'POST':
        action = request.form.get('action', default=None)
        if action is None:
            return make_json_error_response('no action')
        elif action == 'open':
            gateObject.is_opened = True
            model.session.commit()
        elif action == 'close':
            gateObject.is_opened = False
            model.session.commit()
        else:
            return make_json_error_response('invalid action')

    gate = {'id': gateObject.gate_id,
            'name': gateObject.name,
            'major': gateObject.beacon_minor,
            'minor': gateObject.beacon_minor,
            'state': gateObject.is_opened}

    return make_json_response(gate)

if __name__ == '__main__':
    app.run(debug = True, host='0.0.0.0')