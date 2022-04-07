from config import Config
from datetime import datetime
import hashlib
from sqlalchemy.sql import func, text
from sqlalchemy.sql.functions import current_timestamp
from sqlalchemy.types import UserDefinedType
import os
from pytz import timezone
import random
from app import db
#from app.aws import save_s3, delete_s3
from .user import User


class Geometry(UserDefinedType):
    def get_col_spec(self):
        return "GEOMETRY"

    def bind_expression(self, bindvalue):
        return text("ST_SRID(POINT(0, 0), 3857)")

    def column_expression(self, col):
        return func.ST_AsText(col, type_=self)


class Market(db.Model):
    __tablename__ = 'markets'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    address = db.Column(db.String(255), nullable=False)
    opening_hours = db.Column(db.String(255), nullable=False)
    lat = db.Column(db.Float(), nullable=False)
    lng = db.Column(db.Float(), nullable=False)
    created_at = db.Column(db.DateTime, server_default=current_timestamp())

    @classmethod
    def create(cls, name, lat, lng, user_id):
        model = cls()
        db.session.add(model)
        db.session.commit()
        model.set_geopoint(lat, lng)
        model.filename = model.create_filename()
        model.user_id = user_id
        if model.filename == '':
            db.session.delete(model)
            db.session.commit()
            return None
        else:
            db.session.commit()
            #if os.getenv('SERVER_PLATFORM', '') != 'local':
            #    save_s3(model.pictureFilename("l"), image_l, "image/jpeg")
            #    save_s3(model.pictureFilename("m"), image_m, "image/jpeg")
            #    save_s3(model.pictureFilename("s"), image_s, "image/jpeg")
            return model

    @classmethod
    def delete(cls, id):
        model = cls.query.get(id)
        if model:
            #if os.getenv('SERVER_PLATFORM', '') != 'local':
            #    delete_s3(model.pictureFilename('l'))
            #    delete_s3(model.pictureFilename('m'))
            #    delete_s3(model.pictureFilename('s'))
            #from .spot_discovery import SpotDiscovery
            #SpotDiscovery.query.filter(SpotDiscovery.spot_id == id).update({SpotDiscovery.spot_id: None})
            db.session.delete(model)
            db.session.commit()

    def create_filename(self):
        filename = ''
        for x in range(1000):
            seed = 'map2{}{}'.format(self.id, random.randint(0, 1000))
            filename = hashlib.md5(seed.encode()).hexdigest()
            exist = Spot.query.filter_by(filename=filename).first()
            if not exist:
                break
        return filename

    def set_geopoint(self, lat, lng):
        query = text(f"UPDATE spots SET geopoint = ST_SRID(POINT({lat}, {lng}), 3857) WHERE id = {self.id}")
        db.session.execute(query)
        db.session.commit()

    def pictureFilename(self, size):
        return '{}_{}.jpg'.format(self.filename, size)

    def pictureUrl(self, size):
        return '{}{}'.format(Config.S3_URL, self.pictureFilename(size))

    def pst_created_at(self):
        return self.created_at.astimezone(timezone('America/Los_Angeles'))

    def latlng(self):
        lat, lng = self.geopoint[6:-1].split(' ')
        return float(lat), float(lng)

    def to_dict(self):
        return {
            'id': int(self.id),
            'name': self.name,
            'address': self.address,
            'opening_hours': self.opening_hours,
            'lat': self.lat,
            'lng': self.lng,
            'created_at': self.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        }

    @classmethod
    def spots(cls, lat, lng, distance, limit):
        query = text(f'''
            SELECT
                id
            FROM spots
            WHERE
                ST_Within(
                    geopoint,
                    ST_Buffer(
                        ST_GeomFromText(
                            'POINT({lat} {lng})' , 3857
                        ),
                        {distance} * 180.0 / 3.141592653589793 / 6378137.0
                    )
                )
            ORDER BY ST_Distance(
                    ST_GeomFromText('POINT({lat} {lng})', 3857),
                    geopoint
                )
            LIMIT {limit};
        ''')
        rs = db.session.execute(query)
        ids = [r.id for r in rs]
        spots = cls.query.filter(cls.id.in_(ids)).all()
        print(spots)
        return spots