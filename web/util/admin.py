__author__ = 'antoni'

from flask_admin import Admin
from flask_admin.contrib.sqla import ModelView

from model import model, User, Gate

admin = Admin()
admin.add_view(ModelView(User, model.session))
admin.add_view(ModelView(Gate, model.session))