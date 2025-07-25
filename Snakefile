import os

# Path to the final output marker file
rule all:
    input:
        required_outputs=os.path.join(os.environ["ATLAS_PROD"], "OpenTargets_dumps", "upload_ot_diff_export.done")

# Rule to upload the JSON file to GCP
rule upload_ot_diff_export:
    log:
        os.path.join(os.environ["ATLAS_PROD"], "OpenTargets_dumps", "upload_ot_diff_export.log")
    conda:
        "envs/gsutil.yaml"  # YAML environment should include gsutil (e.g., google-cloud-sdk)
    params:
        atlas_bucket="otar010-atlas",
    input:
        ot_diff_export_dump=config["dump_json"]
    output:
        done=os.path.join(os.environ["ATLAS_PROD"], "OpenTargets_dumps", "upload_ot_diff_export.done")
    shell:
        """
        set -e  # Exit on error

        exec > {log} 2>&1  # Redirect all output to log

        GS_PREFIX="gs://{params.atlas_bucket}/"

        echo "Uploading {input.ot_diff_export_dump} to $GS_PREFIX"
        gsutil cp {input.ot_diff_export_dump} $GS_PREFIX

        echo "Upload complete, creating done file"
        touch {output.done}
        """
