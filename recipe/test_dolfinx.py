import os

import dolfinx
import gmsh
import numpy as np
import pytest
from dolfinx.cpp import common
from dolfinx.io import gmshio
from mpi4py import MPI
from petsc4py.PETSc import ScalarType


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
