from app import db
from sqlalchemy.sql.functions import current_timestamp


class DailyPush(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.Text, nullable=False)
    body = db.Column(db.Text, nullable=False)
    send_time = db.Column(db.String(120), nullable=False)
    created_at = db.Column(db.DateTime, server_default=current_timestamp())


def after_control(mapper, connection, target):
    import scheduler
    scheduler.update_job_send_daily_push()


db.event.listen(DailyPush, 'after_insert', after_control)
db.event.listen(DailyPush, 'after_update', after_control)
db.event.listen(DailyPush, 'after_delete', after_control)
