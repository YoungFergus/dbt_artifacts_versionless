{% macro upload_seeds(seeds) -%}
    {{ return(adapter.dispatch("get_seeds_dml_sql", "dbt_artifacts_versionless")(seeds)) }}
{%- endmacro %}

{% macro default__get_seeds_dml_sql(seeds) -%}

    {% if seeds != [] %}
        {% set seed_values %}
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
            {{ adapter.dispatch('parse_json', 'dbt_artifacts_versionless')(adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(10)) }},
            {{ adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(11) }},
            {{ adapter.dispatch('parse_json', 'dbt_artifacts_versionless')(adapter.dispatch('column_identifier', 'dbt_artifacts_versionless')(12)) }}
        from values
        {% for seed in seeds -%}
            (
                '{{ invocation_id }}', {# command_invocation_id #}
                '{{ seed.unique_id }}', {# node_id #}
                '{{ run_started_at }}', {# run_started_at #}
                '{{ seed.database }}', {# database #}
                '{{ seed.schema }}', {# schema #}
                '{{ seed.name }}', {# name #}
                '{{ seed.package_name }}', {# package_name #}
                '{{ seed.original_file_path | replace('\\', '\\\\') }}', {# path #}
                '{{ seed.checksum.checksum | replace('\\', '\\\\') }}', {# checksum #}
                '{{ tojson(seed.config.meta) | replace("\\", "\\\\") | replace("'","\\'") | replace('"', '\\"') }}', {# meta #}
                '{{ seed.alias }}', {# alias #}
                {% if var('dbt_artifacts_exclude_all_results', false) %}
                    null
                {% else %}
                    '{{ tojson(seed) | replace("\\", "\\\\") | replace("'","\\'") | replace('"', '\\"') }}' {# all_results #}
                {% endif %}
            )
            {%- if not loop.last %},{%- endif %}
        {%- endfor %}
        {% endset %}
        {{ seed_values }}
    {% else %} {{ return("") }}
    {% endif %}
{% endmacro -%}

{% macro bigquery__get_seeds_dml_sql(seeds) -%}
    {% if seeds != [] %}
        {% set seed_values %}
            {% for seed in seeds -%}
                (
                    '{{ invocation_id }}', {# command_invocation_id #}
                    '{{ seed.unique_id }}', {# node_id #}
                    '{{ run_started_at }}', {# run_started_at #}
                    '{{ seed.database }}', {# database #}
                    '{{ seed.schema }}', {# schema #}
                    '{{ seed.name }}', {# name #}
                    '{{ seed.package_name }}', {# package_name #}
                    '{{ seed.original_file_path | replace('\\', '\\\\') }}', {# path #}
                    '{{ seed.checksum.checksum | replace('\\', '\\\\')}}', {# checksum #}
                    {{ adapter.dispatch('parse_json', 'dbt_artifacts_versionless')(tojson(seed.config.meta)) }}, {# meta #}
                    '{{ seed.alias }}', {# alias #}
                    {% if var('dbt_artifacts_exclude_all_results', false) %}
                        null
                    {% else %}
                        {{ adapter.dispatch('parse_json', 'dbt_artifacts_versionless')(tojson(seed) | replace("\\", "\\\\") | replace("'","\\'") | replace('"', '\\"')) }} {# all_results #}
                    {% endif %}
                )
                {%- if not loop.last %},{%- endif %}
            {%- endfor %}
        {% endset %}
        {{ seed_values }}
    {% else %} {{ return("") }}
    {% endif %}
{%- endmacro %}

{% macro postgres__get_seeds_dml_sql(seeds) -%}
    {% if seeds != [] %}
        {% set seed_values %}
            {% for seed in seeds -%}
                (
                    '{{ invocation_id }}', {# command_invocation_id #}
                    '{{ seed.unique_id }}', {# node_id #}
                    '{{ run_started_at }}', {# run_started_at #}
                    '{{ seed.database }}', {# database #}
                    '{{ seed.schema }}', {# schema #}
                    '{{ seed.name }}', {# name #}
                    '{{ seed.package_name }}', {# package_name #}
                    '{{ seed.original_file_path | replace('\\', '\\\\') }}', {# path #}
                    '{{ seed.checksum.checksum }}', {# checksum #}
                    $${{ tojson(seed.config.meta) }}$$, {# meta #}
                    '{{ seed.alias }}', {# alias #}
                    {% if var('dbt_artifacts_exclude_all_results', false) %}
                        null
                    {% else %}
                        $${{ tojson(seed) }}$$ {# all_results #}
                    {% endif %}
                )
                {%- if not loop.last %},{%- endif %}
            {%- endfor %}
        {% endset %}
        {{ seed_values }}
    {% else %} {{ return("") }}
    {% endif %}
{%- endmacro %}

{% macro sqlserver__get_seeds_dml_sql(seeds) -%}

    {% if seeds != [] %}
        {% set seed_values %}
        select "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"
        from ( values
        {% for seed in seeds -%}
            (
                '{{ invocation_id }}', {# command_invocation_id #}
                '{{ seed.unique_id }}', {# node_id #}
                '{{ run_started_at }}', {# run_started_at #}
                '{{ seed.database }}', {# database #}
                '{{ seed.schema }}', {# schema #}
                '{{ seed.name }}', {# name #}
                '{{ seed.package_name }}', {# package_name #}
                '{{ seed.original_file_path }}', {# path #}
                '{{ seed.checksum.checksum }}', {# checksum #}
                '{{ tojson(seed.config.meta) | replace("'","''") }}', {# meta #}
                '{{ seed.alias }}', {# alias #}
                {% if var('dbt_artifacts_exclude_all_results', false) %}
                    null
                {% else %}
                    '{{ tojson(seed) | replace("'","''") }}' {# all_results #}
                {% endif %}
            )
            {%- if not loop.last %},{%- endif %}
        {%- endfor %}

        ) v ("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")

        {% endset %}
        {{ seed_values }}
    {% else %} {{ return("") }}
    {% endif %}
{% endmacro -%}

