rule all:
    input:
        required_outputs="$ATLAS_PROD/OpenTargets_dumps/upload_ot_diff_export.done"

rule upload_ot_diff_export:
    log: "$ATLAS_PROD/OpenTargets_dumps/upload_ot_diff_export.log"
    conda: "envs/gsutil.yaml"
    params:
        atlas_bucket="otar010-atlas",
    input:
        ot_diff_export_dump=config['dump_json']
    output:
        done=touch("$ATLAS_PROD/OpenTargets_dumps/upload_ot_diff_export.done")
    shell:
        """
        set -e # snakemake on the cluster doesn't stop on error when --keep-going is set

        exec &> "{log}"

        GS_PREFIX="gs://{params.atlas_bucket}/"
        
        gsutil cp ${input.ot_diff_export_dump} \
            $GS_PREFIX/

        touch ${output.done}
        """
