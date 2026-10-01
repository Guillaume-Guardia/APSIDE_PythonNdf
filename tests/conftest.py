# -*- coding: utf-8 -*-

import os
import shutil
import tempfile

# Use a temporary database, to not modify the database of the user (src/pyndf/db/pydb.db).
# Must be set before pyndf is imported: the database path is read at import.
_DB_DIR = tempfile.mkdtemp(prefix="pyndf_tests_")
os.environ["NDF_DB"] = os.path.join(_DB_DIR, "pydb.db")


def pytest_unconfigure(config):
    # Close the connections, else Windows can't remove the database file
    from pyndf.db.session import db

    db.db_engine.dispose()
    shutil.rmtree(_DB_DIR, ignore_errors=True)
