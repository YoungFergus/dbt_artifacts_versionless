{% macro get_table_content_values(dataset, objects_to_upload) %}

    {# Convert the results to data to be imported #}

    {% if dataset == 'model_executions' %}
        {% set content = dbt_artifacts_versionless.upload_model_executions(objects_to_upload) %}
    {% elif dataset == 'seed_executions' %}
        {% set content = dbt_artifacts_versionless.upload_seed_executions(objects_to_upload) %}
    {% elif dataset == 'test_executions' %}
        {% set content = dbt_artifacts_versionless.upload_test_executions(objects_to_upload) %}
    {% elif dataset == 'snapshot_executions' %}
        {% set content = dbt_artifacts_versionless.upload_snapshot_executions(objects_to_upload) %}
    {% elif dataset == 'exposures' %}
        {% set content = dbt_artifacts_versionless.upload_exposures(objects_to_upload) %}
    {% elif dataset == 'models' %}
        {% set content = dbt_artifacts_versionless.upload_models(objects_to_upload) %}
    {% elif dataset == 'seeds' %}
        {% set content = dbt_artifacts_versionless.upload_seeds(objects_to_upload) %}
    {% elif dataset == 'snapshots' %}
        {% set content = dbt_artifacts_versionless.upload_snapshots(objects_to_upload) %}
    {% elif dataset == 'sources' %}
        {% set content = dbt_artifacts_versionless.upload_sources(objects_to_upload) %}
    {% elif dataset == 'tests' %}
        {% set content = dbt_artifacts_versionless.upload_tests(objects_to_upload) %}
    {# Invocations only requires data from variables available in the macro #}
    {% elif dataset == 'invocations' %}
        {% set content = dbt_artifacts_versionless.upload_invocations() %}
    {% endif %}

    {{ return(content) }}

{% endmacro %}
