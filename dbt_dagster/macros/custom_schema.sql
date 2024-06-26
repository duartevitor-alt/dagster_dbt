{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {%- if default_schema == "RAW" -%}
        {{ custom_schema_name | trim }}

    {%- else -%} 
        {{ default_schema }}

    {%- endif -%}
    
{%- endmacro %}
