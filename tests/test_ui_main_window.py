# -*- coding: utf-8 -*-

import os
import shutil
import tempfile
import unittest
from unittest import mock
import yaml
from pyndf.constants import CONST
from pyndf.qtlib import QtCore, QtGui
from pyndf.app import App
from pyndf.gui.windows.main import MainWindow


class TestMainWindow(unittest.TestCase):
    """Test Class"""

    @classmethod
    def setUpClass(cls):
        """Before all tests"""
        cls.directory = tempfile.mkdtemp()

        # Use a temporary settings file to not modify the settings of the user
        settings_file = os.path.join(cls.directory, "settings.ini")
        settings_class = QtCore.QSettings
        cls.patcher = mock.patch.object(
            QtCore, "QSettings", lambda *args: settings_class(settings_file, settings_class.Format.IniFormat)
        )
        cls.patcher.start()

        # Remembered output directories: one exists, the other is unreachable (network share, USB drive...)
        cls.unreachable = os.path.join(cls.directory, "unreachable")
        QtCore.QSettings().setValue(CONST.TYPE.OUT, yaml.dump({cls.directory, cls.unreachable}))

        cls.app = App("fr", use_gui=True)
        cls.app.load_translator()
        cls.app.load_window(None, None, None)

    def test_window(self):
        self.assertIsInstance(self.app.window, MainWindow)

    def test_shortcuts(self):
        shortcuts = [action.shortcut().toString() for action in self.app.window.findChildren(QtGui.QAction)]
        self.assertIn("Ctrl+Q", shortcuts)

    def test_unreachable_paths(self):
        # The unreachable path is hidden in the window...
        self.assertEqual(self.app.window.output, {self.directory})

        # ...but kept in the settings when the window is closed
        self.app.window.close()
        saved = yaml.load(QtCore.QSettings().value(CONST.TYPE.OUT), Loader=yaml.FullLoader)
        self.assertEqual(saved, {self.directory, self.unreachable})

    @classmethod
    def tearDownClass(cls):
        cls.app.window.close()
        cls.patcher.stop()
        shutil.rmtree(cls.directory, ignore_errors=True)


if __name__ == "__main__":
    unittest.main()
