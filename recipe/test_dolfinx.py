import os
import sys

import basix.ufl
import ufl
import dolfinx  # noqa
import gmsh
import numpy as np
import pytest
from dolfinx.cpp import common
from dolfinx.io import gmshio
from mpi4py import MPI
from dolfinx import default_scalar_type

skip_win = pytest.mark.skipif(sys.platform == "win32", reason="not on windows")

@skip_win
def test_petsc_scalar():
    print(repr(default_scalar_type))
    scalar = os.environ["scalar"]
    is_complex = issubclass(default_scalar_type, np.complexfloating)
    if scalar == "complex":
        assert is_complex
    else:
        assert not is_complex

@skip_win
@pytest.mark.parametrize("feature", [
        "adios2",
        "parmetis",
        "slepc",
        "kahip",
        "petsc",
        # "scotch",
    ])
def test_has(feature):
    assert getattr(common, f"has_{feature}")


def test_mpi():
    comm = MPI.COMM_WORLD
    print(f"{comm.rank=}")
    print(f"{comm.size=}")
    A = np.ones(10)
    print("broadcasting")
    B = comm.bcast(A, root=0)
    assert (B == A).all()
    print("broadcasted")

def test_mesh():
    print("test mesh")
    nodes = np.array([[1.0, 0.0], [2.0, 0.0], [3.0, 2.0], [1, 3]], dtype=np.float64)
    connectivity = np.array([[0, 1, 2], [0, 2, 3]], dtype=np.int64)
    print("ufl.Mesh")
    c_el = ufl.Mesh(basix.ufl.element("Lagrange", "triangle", 1, shape=(nodes.shape[1],)))
    print("create_mesh")
    domain = dolfinx.mesh.create_mesh(MPI.COMM_SELF, connectivity, nodes, c_el)
    print("mesh created")

def test_gmshio():
    # meshing example taken from https://jsdokken.com/dolfinx-tutorial/chapter1/membrane_code.html
    print("initialize")
    gmsh.initialize()
    membrane = gmsh.model.occ.addDisk(0, 0, 0, 1, 1)
    gmsh.model.occ.synchronize()
    gdim = 2
    print("physical")
    gmsh.model.addPhysicalGroup(gdim, [membrane], 1)
    print("generate")
    gmsh.model.mesh.generate(gdim)

    gmsh_model_rank = 0
    mesh_comm = MPI.COMM_WORLD
    print("model_to_mesh")
    domain, cell_markers, facet_markers = gmshio.model_to_mesh(
        gmsh.model, mesh_comm, gmsh_model_rank, gdim=2
    )
    print("finalize")
    gmsh.finalize()
    print("finalized")
