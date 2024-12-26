{% macro upload_snapshot_executions(snapshots) -%}
    {{ return(adapter.dispatch("get_snapshot_executions_dml_sql", "dbt_artifacts_versionless")(snapshots)) }}
{%- endmacro %}

{% macro default__get_snapshot_executions_dml_sql(snapshots) -%}
    {% if snapshots != [] %}
        {% set snapshot_execution_values %}
        select
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(1) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(2) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(3) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(4) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(5) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(6) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(7) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(8) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(9) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(10) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(11) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(12) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(13) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(14) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(15) }},
            {{ adapter.dispatch('parse_json', 'dbt_artifacts_versionless')(adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(16)) }}
        from values
        {% for model in snapshots -%}
            (
                '{{ invocation_id }}', {# command_invocation_id #}
                '{{ model.node.unique_id }}', {# node_id #}
                '{{ run_started_at }}', {# run_started_at #}

                {% set config_full_refresh = model.node.config.full_refresh %}
                {% if config_full_refresh is none %}
                    {% set config_full_refresh = flags.FULL_REFRESH %}
                {% endif %}
                '{{ config_full_refresh }}', {# was_full_refresh #}

                '{{ model.thread_id }}', {# thread_id #}
                '{{ model.status }}', {# status #}

                {% set compile_started_at = (model.timing | selectattr("name", "eq", "compile") | first | default({}))["started_at"] %}
                {% if compile_started_at %}'{{ compile_started_at }}'{% else %}null{% endif %}, {# compile_started_at #}
                {% set query_completed_at = (model.timing | selectattr("name", "eq", "execute") | first | default({}))["completed_at"] %}
                {% if query_completed_at %}'{{ query_completed_at }}'{% else %}null{% endif %}, {# query_completed_at #}

                {{ model.execution_time }}, {# total_node_runtime #}
                null, -- rows_affected not available {# Only available in Snowflake #}
                '{{ model.node.config.materialized }}', {# materialization #}
                '{{ model.node.schema }}', {# schema #}
                '{{ model.node.name }}', {# name #}
                '{{ model.node.alias }}', {# alias #}
                '{{ model.message | replace("\\", "\\\\") | replace("'", "\\'") | replace('"', '\\"') }}', {# message #}
                '{{ tojson(model.adapter_response) | replace("\\", "\\\\") | replace("'", "\\'") | replace('"', '\\"') }}' {# adapter_response #}
            )
            {%- if not loop.last %},{%- endif %}
        {%- endfor %}
        {% endset %}
        {{ snapshot_execution_values }}
    {% else %} {{ return("") }}
    {% endif %}
{% endmacro -%}

{% macro bigquery__get_snapshot_executions_dml_sql(snapshots) -%}
    {% if snapshots != [] %}
        {% set snapshot_execution_values %}
        {% for model in snapshots -%}
            (
                '{{ invocation_id }}', {# command_invocation_id #}
                '{{ model.node.unique_id }}', {# node_id #}
                '{{ run_started_at }}', {# run_started_at #}

                {% set config_full_refresh = model.node.config.full_refresh %}
                {% if config_full_refresh is none %}
                    {% set config_full_refresh = flags.FULL_REFRESH %}
                {% endif %}
                {{ config_full_refresh }}, {# was_full_refresh #}

                '{{ model.thread_id }}', {# thread_id #}
                '{{ model.status }}', {# status #}

                {% set compile_started_at = (model.timing | selectattr("name", "eq", "compile") | first | default({}))["started_at"] %}
                {% if compile_started_at %}'{{ compile_started_at }}'{% else %}null{% endif %}, {# compile_started_at #}
                {% set query_completed_at = (model.timing | selectattr("name", "eq", "execute") | first | default({}))["completed_at"] %}
                {% if query_completed_at %}'{{ query_completed_at }}'{% else %}null{% endif %}, {# query_completed_at #}

                {{ model.execution_time }}, {# total_node_runtime #}
                null, -- rows_affected not available {# Databricks #}
                '{{ model.node.config.materialized }}', {# materialization #}
                '{{ model.node.schema }}', {# schema #}
                '{{ model.node.name }}', {# name #}
                '{{ model.node.alias }}', {# alias #}
                '{{ model.message | replace("\\", "\\\\") | replace("'", "\\'") | replace('"', '\\"') | replace("\n", "\\n") }}', {# message #}
                {{ adapter.dispatch('parse_json', 'dbt_artifacts_versionless')(tojson(model.adapter_response) | replace("\\", "\\\\") | replace("'", "\\'") | replace('"', '\\"')) }} {# adapter_response #}
            )
            {%- if not loop.last %},{%- endif %}
        {%- endfor %}
        {% endset %}
        {{ snapshot_execution_values }}
    {% else %} {{ return("") }}
    {% endif %}
{% endmacro -%}

{% macro snowflake__get_snapshot_executions_dml_sql(snapshots) -%}
    {% if snapshots != [] %}
        {% set snapshot_execution_values %}
        select
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(1) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(2) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(3) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(4) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(5) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(6) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(7) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(8) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(9) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(10) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(11) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(12) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(13) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(14) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(15) }},
            {{ adapter.dispatch('parse_json', 'dbt_artifacts_versionless')(adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(16)) }}
        from values
        {% for model in snapshots -%}
            (
                '{{ invocation_id }}', {# command_invocation_id #}
                '{{ model.node.unique_id }}', {# node_id #}
                '{{ run_started_at }}', {# run_started_at #}

                {% set config_full_refresh = model.node.config.full_refresh %}
                {% if config_full_refresh is none %}
                    {% set config_full_refresh = flags.FULL_REFRESH %}
                {% endif %}
                '{{ config_full_refresh }}', {# was_full_refresh #}

                '{{ model.thread_id }}', {# thread_id #}
                '{{ model.status }}', {# status #}

                {% set compile_started_at = (model.timing | selectattr("name", "eq", "compile") | first | default({}))["started_at"] %}
                {% if compile_started_at %}'{{ compile_started_at }}'{% else %}null{% endif %}, {# compile_started_at #}
                {% set query_completed_at = (model.timing | selectattr("name", "eq", "execute") | first | default({}))["completed_at"] %}
                {% if query_completed_at %}'{{ query_completed_at }}'{% else %}null{% endif %}, {# query_completed_at #}

                {{ model.execution_time }}, {# total_node_runtime #}
                try_cast('{{ model.adapter_response.rows_affected }}' as int), {# rows_affected #}
                '{{ model.node.config.materialized }}', {# materialization #}
                '{{ model.node.schema }}', {# schema #}
                '{{ model.node.name }}', {# name #}
                '{{ model.node.alias }}', {# alias #}
                '{{ model.message | replace("\\", "\\\\") | replace("'", "\\'") | replace('"', '\\"') }}', {# message #}
                '{{ tojson(model.adapter_response) | replace("\\", "\\\\") | replace("'", "\\'") | replace('"', '\\"') }}' {# adapter_response #}
            )
            {%- if not loop.last %},{%- endif %}
        {%- endfor %}
        {% endset %}
        {{ snapshot_execution_values }}
    {% else %} {{ return("") }}
    {% endif %}
{% endmacro -%}

{% macro postgres__get_snapshot_executions_dml_sql(snapshots) -%}
    {% if snapshots != [] %}
        {% set snapshot_execution_values %}
        {% for model in snapshots -%}
            (
                '{{ invocation_id }}', {# command_invocation_id #}
                '{{ model.node.unique_id }}', {# node_id #}
                '{{ run_started_at }}', {# run_started_at #}

                {% set config_full_refresh = model.node.config.full_refresh %}
                {% if config_full_refresh is none %}
                    {% set config_full_refresh = flags.FULL_REFRESH %}
                {% endif %}
                {{ config_full_refresh }}, {# was_full_refresh #}

                '{{ model.thread_id }}', {# thread_id #}
                '{{ model.status }}', {# status #}

                {% if model.timing != [] %}
                    {% for stage in model.timing if stage.name == "compile" %}
                        {% if loop.length == 0 %}
                            null, {# compile_started_at #}
                        {% else %}
                            '{{ stage.started_at }}', {# compile_started_at #}
                        {% endif %}
                    {% endfor %}

                    {% for stage in model.timing if stage.name == "execute" %}
                        {% if loop.length == 0 %}
                            null, {# query_completed_at #}
                        {% else %}
                            '{{ stage.completed_at }}', {# query_completed_at #}
                        {% endif %}
                    {% endfor %}
                {% else %}
                    null, {# compile_started_at #}
                    null, {# query_completed_at #}
                {% endif %}

                {{ model.execution_time }}, {# total_node_runtime #}
                null, {# rows_affected #}
                '{{ model.node.config.materialized }}', {# materialization #}
                '{{ model.node.schema }}', {# schema #}
                '{{ model.node.name }}', {# name #}
                '{{ model.node.alias }}', {# alias #}
                $${{ model.message }}$$, {# message #}
                $${{ tojson(model.adapter_response) }}$$ {# adapter_response #}
            )
            {%- if not loop.last %},{%- endif %}
        {%- endfor %}
        {% endset %}
        {{ snapshot_execution_values }}
    {% else %} {{ return("") }}
    {% endif %}
{% endmacro -%}

{% macro sqlserver__get_snapshot_executions_dml_sql(snapshots) -%}
    {% if snapshots != [] %}
        {% set snapshot_execution_values %}
        select
            "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"
        from ( values
        {% for model in snapshots -%}
            (
                '{{ invocation_id }}', {# command_invocation_id #}
                '{{ model.node.unique_id }}', {# node_id #}
                '{{ run_started_at }}', {# run_started_at #}

                {% set config_full_refresh = model.node.config.full_refresh %}
                {% if config_full_refresh is none %}
                    {% set config_full_refresh = flags.FULL_REFRESH %}
                {% endif %}
                '{{ config_full_refresh }}', {# was_full_refresh #}

                '{{ model.thread_id }}', {# thread_id #}
                '{{ model.status }}', {# status #}

                {% set compile_started_at = (model.timing | selectattr("name", "eq", "compile") | first | default({}))["started_at"] %}
                {% if compile_started_at %}'{{ compile_started_at }}'{% else %}null{% endif %}, {# compile_started_at #}
                {% set query_completed_at = (model.timing | selectattr("name", "eq", "execute") | first | default({}))["completed_at"] %}
                {% if query_completed_at %}'{{ query_completed_at }}'{% else %}null{% endif %}, {# query_completed_at #}

                {{ model.execution_time }}, {# total_node_runtime #}
                null, -- rows_affected not available {# Only available in Snowflake #}
                '{{ model.node.config.materialized }}', {# materialization #}
                '{{ model.node.schema }}', {# schema #}
                '{{ model.node.name }}', {# name #}
                '{{ model.node.alias }}', {# alias #}
                '{{ model.message  | replace("'", "''") }}', {# message #}
                '{{ tojson(model.adapter_response) | replace("'", "''") }}' {# adapter_response #}
            )
            {%- if not loop.last %},{%- endif %}
        {%- endfor %}

        ) v ("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16")

        {% endset %}
        {{ snapshot_execution_values }}
    {% else %} {{ return("") }}
    {% endif %}
{% endmacro -%}

