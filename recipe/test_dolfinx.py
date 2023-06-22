import os

import dolfinx  # noqa
import gmsh
import numpy as np
import pytest
import pyvista
from dolfinx.fem import Function, FunctionSpace
from dolfinx.mesh import (
    CellType,
    create_unit_square,
)
from dolfinx import plot
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
        "kahip",
    ],
)
def test_has(feature):
    assert getattr(common, f"has_{feature}")


def test_mesh():
    # from https://docs.fenicsproject.org/dolfinx/main/python/demos/demo_pyvista.html
    msh = create_unit_square(MPI.COMM_WORLD, 12, 12, cell_type=CellType.quadrilateral)
    V = FunctionSpace(msh, ("Lagrange", 1))
    u = Function(V, dtype=np.float64)
    u.interpolate(lambda x: np.sin(np.pi * x[0]) * np.sin(2 * x[1] * np.pi))


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


def test_pyvista():
    # from https://docs.fenicsproject.org/dolfinx/main/python/demos/demo_pyvista.html
    msh = create_unit_square(MPI.COMM_WORLD, 12, 12, cell_type=CellType.quadrilateral)
    V = FunctionSpace(msh, ("Lagrange", 1))
    u = Function(V, dtype=np.float64)
    u.interpolate(lambda x: np.sin(np.pi * x[0]) * np.sin(2 * x[1] * np.pi))

    # To visualize the function u, we create a VTK-compatible grid to
    # values of u to
    cells, types, x = plot.vtk_mesh(V)
    grid = pyvista.UnstructuredGrid(cells, types, x)
    grid.point_data["u"] = u.x.array

    # The function "u" is set as the active scalar for the mesh, and
    # warp in z-direction is set
    grid.set_active_scalars("u")
    warped = grid.warp_by_scalar()

    # A plotting window is created with two sub-plots, one of the scalar
    # values and the other of the mesh is warped by the scalar values in
    # z-direction
    subplotter = pyvista.Plotter(shape=(1, 2), off_screen=True)
    subplotter.subplot(0, 0)
    subplotter.add_text(
        "Scalar contour field", font_size=14, color="black", position="upper_edge"
    )
    subplotter.add_mesh(grid, show_edges=True, show_scalar_bar=True)
    subplotter.view_xy()

    subplotter.subplot(0, 1)
    subplotter.add_text(
        "Warped function", position="upper_edge", font_size=14, color="black"
    )
    sargs = dict(
        height=0.8,
        width=0.1,
        vertical=True,
        position_x=0.05,
        position_y=0.05,
        fmt="%1.2e",
        title_font_size=40,
        color="black",
        label_font_size=25,
    )
    subplotter.set_position([-3, 2.6, 0.3])
    subplotter.set_focus([3, -1, -0.15])
    subplotter.set_viewup([0, 0, 1])
    subplotter.add_mesh(warped, show_edges=True, scalar_bar_args=sargs)
    subplotter.screenshot("2D_function_warp.png")
