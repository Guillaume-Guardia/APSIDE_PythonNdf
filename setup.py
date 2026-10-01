#!/usr/bin/env python

import sys
from setuptools import setup

with open("requirements.txt", encoding="utf-8") as f:
    required = [line.strip() for line in f if line.strip() and not line.startswith("#")]

sys.path.append(__file__)

setup(
    name="pyndf",
    version="1.2",
    author="Guillaume Guardia",
    author_email="guardia.1903@apside-groupe.com",
    packages=["pyndf"],
    package_dir={"": "src"},
    package_data={"pyndf": ["data/test.xlsx"]},
    license="LICENSE.txt",
    description="Do NDF for Apside",
    long_description=open("README.md", encoding="utf-8").read(),
    python_requires=">=3.14",
    install_requires=required,
)
