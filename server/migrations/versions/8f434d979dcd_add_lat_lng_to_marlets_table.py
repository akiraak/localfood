"""Add lat & lng to marlets table

Revision ID: 8f434d979dcd
Revises: b60f8c69e31f
Create Date: 2022-04-06 17:15:15.994655

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '8f434d979dcd'
down_revision = 'b60f8c69e31f'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('markets', sa.Column('lat', sa.Float(), nullable=False))
    op.add_column('markets', sa.Column('lng', sa.Float(), nullable=False))
    op.drop_index('ix_markets_geopoint', table_name='markets')
    op.drop_column('markets', 'geopoint')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('markets', sa.Column('geopoint', sa.NullType(), nullable=False))
    op.create_index('ix_markets_geopoint', 'markets', ['geopoint'], unique=False)
    op.drop_column('markets', 'lng')
    op.drop_column('markets', 'lat')
    # ### end Alembic commands ###
