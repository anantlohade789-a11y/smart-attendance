"""Initialize the schema and default administrator."""
from app import create_app
from seed_data import seed_database

app = create_app()
seed_database(app=app)
