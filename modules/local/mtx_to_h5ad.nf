process MTX_TO_H5AD {
    tag "$meta.id"
    label 'process_medium'

    conda (params.enable_conda ? "conda-forge::scanpy conda-forge::python-igraph conda-forge::leidenalg" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/scanpy:1.7.2--pyhdfd78af_0' :
        'quay.io/biocontainers/scanpy:1.7.2--pyhdfd78af_0' }"

    input:
    tuple val(meta), path(cellranger_outdir)

    output:
    path "matrix.h5ad.gz", emit: h5ad

    script:
    """
    mtx_to_h5ad.py \\
        -m filtered_feature_bc_matrix \\
        -o matrix.h5ad
    
    gzip -c matrix.h5ad > matrix.h5ad.gz
    """
}
