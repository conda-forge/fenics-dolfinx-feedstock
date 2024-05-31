import os
import sys

import dolfinx  # noqa
import gmsh
import numpy as np
import pytest
from dolfinx.cpp import common
from dolfinx.io import gmshio
from mpi4py import MPI
from dolfinx import default_scalar_type


def test_petsc_scalar():
    print(repr(default_scalar_type))
    scalar = os.environ["scalar"]
    is_complex = issubclass(default_scalar_type, np.complexfloating)
    if scalar == "complex":
        assert is_complex
    else:
        assert not is_complex

if sys.platform == "win32":
    features = ["scotch"]
else:
    features = [
        "adios2",
        "parmetis",
        "slepc",
        "kahip",
        "petsc",
        # "scotch",
    ]

@pytest.mark.parametrize("feature", features)
def test_has(feature):
    assert getattr(common, f"has_{feature}")


def test_gmshio():
    # meshing example taken from https://jsdokken.com/dolfinx-tutorial/chapter1/membrane_code.html
    gmsh.initialize()
    membrane = gmsh.model.occ.addDisk(0, 0, 0, 1, 1)
    gmsh.model.occ.synchronize()
    gdim = 2
    gmsh.model.addPhysicalGroup(gdim, [membrane], 1)
    gmsh.model.mesh.generate(gdim)

    gmsh_model_rank = 0
    mesh_comm = MPI.COMM_WORLD
    domain, cell_markers, facet_markers = gmshio.model_to_mesh(
        gmsh.model, mesh_comm, gmsh_model_rank, gdim=2
    )
    gmsh.finalize()
