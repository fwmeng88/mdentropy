#!/bin/bash

# Print each line, exit on error
set -ev

# Install the built package
conda create --yes -n docenv python=$CONDA_PY
source activate docenv
conda install -yq --use-local mdentropy

# We don't use conda for these:
# sphinx_rtd_theme's latest releases are not available
# neither is msmb_theme
# neither is sphinx > 1.3.1 (fix #1892 autodoc problem)
pip install -I urllib3 sphinx_rtd_theme==0.1.9 msmb_theme==1.2.0

# Install doc requirements
conda install --yes --file docs/requirements.txt
conda install -yq -c bioconda nglview
jupyter nbextension enable --py --sys-prefix widgetsnbextension

# Make docs
cd docs && make html && cd -

# Move the docs into a versioned subdirectory
python devtools/travis-ci/set_doc_version.py

# Prepare versions.json
python devtools/travis-ci/update_versions_json.py
