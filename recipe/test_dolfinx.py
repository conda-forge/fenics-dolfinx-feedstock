import os

import numpy as np
from petsc4py.PETSc import ScalarType
import pytest

import dolfinx
from dolfinx.cpp import common


def test_petsc_scalar():
    scalar = os.environ["scalar"]
    is_complex = issubclass(ScalarType, np.complexfloating)
    if scalar == "complex":
        assert is_complex
    else:
        assert not is_complex


@pytest.mark.parametrize(
    "feature",
    [
        "adios2",
        "parmetis",
        "slepc",
        # kahip, # not yet
    ],
)
def test_has(feature):
    assert getattr(common, f"has_{feature}")
