
# SWIFT/T SETTINGS

# Settings for building Swift/T
# This script is accessed internally by the build-*.sh scripts,
#      do not attempt to run it directly.

# Note that this script is source by each build-*.sh script-
#  thus, there is no need to export variables to the environment

# Unless otherwise noted, set option to 0 to turn off, 1 to turn on.
# Generally, settings that are given defaults here must not be left unset
#     (we run under 'set -e').

# Do not modify sections marked "Code:"

#+======================+
#|| Mandatory settings ||
#+======================+
# Please fill in all of these variables

# Install root: change to your install location
export SWIFT_T_PREFIX=/home/ubuntu/EQ-JL/swift-t-install

#+====================================+
#|| Optional configuration variables ||
#+====================================+
# These variables can be modified to enable/disable features or to
# provide information about your system and required software packages.
# For many systems the default settings are adequate.

# C compiler and flags
export CC=mpicc
# export CFLAGS=
# export LDFLAGS=

# Host to use when cross-compiling
# This is passed to configure as --host=CROSS_HOST
# CROSS_HOST=

# Location of Tcl to override autodetected Tcl
# TCL_INSTALL=${EXM_PREFIX}/tcl
# Tcl version: specify in case of multiple competing versions
# TCL_VERSION=8.6

# Specify details of non-standard Tcl layouts
# name of tclsh runnable on build system
# TCLSH_LOCAL=/usr/bin/tclsh
# directory containing Tcl library
# TCL_LIB_DIR=/path/to/tcl/lib
# directory containing tcl.h
# TCL_INCLUDE_DIR=/path/to/tcl/include
# tcl system library directory.  Must contain init.tcl in root or
# tcl${TCL_VERSION} subdirectory
# TCL_SYSLIB_DIR=/path/to/tcl/lib

# Location of MPI install to override autodetected location
# MPI_INSTALL=${EXM_PREFIX}/mpi
# MPE_INSTALL=${EXM_PREFIX}/mpe
# Set MPI version
# (version 3 required for parallel tasks but version 2 is also allowed)
MPI_VERSION=3

# MPI custom layouts (uncomment below options to enable)
# Check for mpicc (set to 0 to use, e.g., cc)
SWIFT_T_CHECK_MPICC=1
# Enable custom MPI settings
SWIFT_T_CUSTOM_MPI=0
# MPI_DIR=/path/to/mpi
# MPI_INCLUDE=/path/to/mpi/include
# MPI_LIB_DIR=/path/to/mpi/lib
# MPI_LIB_NAME=funny.mpi.a

# C build settings: Swift/T C compile settings default to -O2
# Optimized build (set to 1 to enable): Set -O3, NDEBUG
SWIFT_T_OPT_BUILD=0
# Debugging build (set to 1 to enable): Set -g -O0, enables logging
SWIFT_T_DEBUG_BUILD=0
# Trace build (set to 1 to enable): Enables trace logging
SWIFT_T_TRACE_BUILD=0

# NOTE: Python detection may require PYTHONPATH and PYTHONHOME
# in the environment
# Enable Python integration
ENABLE_PYTHON=0
# Specify the Python interpreter executable below;
# if empty, looks for python in PATH
PYTHON_EXE=""
# PYTHON_EXE=$HOME/sfw/Python-2.7.10/bin/python

# Enable R integration
ENABLE_R=0
# R_INSTALL is the directory returned in R by R.home()
# R_INSTALL=/path/to/R
# Define these if Rcpp and RInside are not autodetected
# RCPP_INSTALL=/path/to/Rcpp
# RINSIDE_INSTALL=/path/to/RInside

# Enable Julia integration
ENABLE_JULIA=1
JULIA_INSTALL=/home/ubuntu/julia-1.5.3

# Enable JVM scripting
ENABLE_JVM_SCRIPTING=0

# Enable MPE support
ENABLE_MPE=0

# Disable ADLB checkpoint functionality
DISABLE_XPT=1

# Manual zlib setup: required for checkpointing
DISABLE_ZLIB=1
# ZLIB_INSTALL=/path/to/zlib

# Disable build of static libraries and executables
DISABLE_STATIC=1

# Disable build of static package feature
DISABLE_STATIC_PKG=1

# Disable build of shared libraries and executables
DISABLE_SHARED=0

# HDF5 location (yes/no/PATH location of h5cc)
WITH_HDF5=no

# Enable more compile-time warnings:
SWIFT_T_DEV=0

#+================================+
#| Default build behavior         |
#+================================+
# These options control the default behavior of each build script, e.g.
# the extent to which it does a rebuild from scratch. These variables are
# overridden when you run other scripts like rebuild_all.sh.

# How to call Ant build tool
ANT=ant

# Ant arguments for STC build
STC_ANT_ARGS=""

# If Ant fails, it could be due to the Java installation used or the
# values of JAVA_HOME or ANT_HOME
# export JAVA_HOME=
# export ANT_HOME=

# Make build parallelism: increase to speed up builds
MAKE_PARALLELISM=1

#+================================+
#| Configure-time customizations  |
#+================================+

# These are additional arguments passed directly to the configure
# scripts for each C module for any settings not captured above:
CUSTOM_CFG_ARGS_C_UTILS=""
CUSTOM_CFG_ARGS_LB=""
CUSTOM_CFG_ARGS_TURBINE=""

#+=====================================+
#|| Optional directory layout control ||
#+=====================================+
# Specify non-standard source/install subdirectory locations

# Code: Find current directory - should already be in this directory
SCRIPT_DIR=$( /bin/pwd )
# Code: Find default source directory (current directory)
src_default()
{
  ${SCRIPT_DIR}/locate-src-root.sh ${SCRIPT_DIR} 3
}

# Root of source directory. Default is current directory.
# Override with SWIFT_T_SRC_ROOT environment variable
export SWIFT_T_SRC_ROOT=${SWIFT_T_SRC_ROOT:-$(src_default)}

# Source subdirectories. Modify to match your layout if needed
C_UTILS_SRC=${SWIFT_T_SRC_ROOT}/c-utils/code
LB_SRC=${SWIFT_T_SRC_ROOT}/lb/code
TURBINE_SRC=${SWIFT_T_SRC_ROOT}/turbine/code
STC_SRC=${SWIFT_T_SRC_ROOT}/stc/code

# Source subdirectory for external dependencies, if desired
#COASTER_SRC=

# Install subdirectories. Modify to match your layout if needed
LB_INSTALL=${SWIFT_T_PREFIX}/lb
C_UTILS_INSTALL=${SWIFT_T_PREFIX}/c-utils
TURBINE_INSTALL=${SWIFT_T_PREFIX}/turbine
STC_INSTALL=${SWIFT_T_PREFIX}/stc

#+======================================+
#|| Developer options (debugging, etc) ||
#+======================================+
# Verify integrity of bundled data
ENABLE_MKSTATIC_CRC=0

#+======================================+
#|| Compilers & Environment Modules    ||
#+======================================+

# Any Cray:
# export CRAYPE_LINK_TYPE=dynamic

# Cori:
# module swap PrgEnv-intel PrgEnv-gnu

# Theta:
# module swap PrgEnv-intel PrgEnv-gnu
# module load gcc

# Bebop:
# module load mvapich2 # or
# module load gcc/7.1.0-4bgguyp mpich/3.2-bsq4vhr

# Beagle:
# module unload PrgEnv-gnu
# module load PrgEnv-gnu
# module load cray-mpich

# Titan:
# module load deeplearning # If you want Python
# module swap PrgEnv-pgi PrgEnv-gnu
# module load java

# Summitdev:
# module load spectrum-mpi

# Midway:



#+===================+
#|| Editor settings ||
#+===================+

# Local Variables:
# mode: sh
# End:
