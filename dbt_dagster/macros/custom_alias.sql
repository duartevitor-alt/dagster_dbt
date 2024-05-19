{#
    -- Renders a alias name given a custom alias name. If the custom
    -- alias name is none, then the resulting alias is just the filename of the
    -- model. If an alias override is specified, then that is used.

    -- This macro can be overriden in projects to define different semantics
    -- for rendering a alias name.

    -- Arguments:
    -- custom_alias_name: The custom alias name specified for a model, or none
    -- node: The available node that an alias is being generated for, or none

    {% do log(node.latest_version, info=true) %}
    {% do log(node.config.version, info=true) %}
    {% do log(node.config.schema, info=true) %}
    {% do log(node.version, info=true) %}
    {% do log(target.schema, info=true) %}
    {% do log(node_name, info=true) %}
#}

{% macro generate_alias_name(custom_alias_name=none, node=none) -%}
        {% do log('-----------------------executei---------------------', info=true) %}
    {% do return(adapter.dispatch('generate_alias_name', 'dbt')(custom_alias_name, node)) %}
    

{%- endmacro %}

{% macro default__generate_alias_name(custom_alias_name=none, node=none) -%}
    {# ---------------------------------------------------------------------- #}
    {# -- What: Node Version ------------------------------------------------ #}
    {# -- Why:  Account for dbt v1.5 model versioning in the model config.    #}
    {# {%- if node.latest_version and node.latest_version in (node.config.version, node.version)  %}

        {% set node_version = '' %}

    {%- else -%}
        {%- if node.config.version %}
            {% set node_version = "_v" ~ (node.config.version | replace(".", "_")) %}

        {%- elif node.version -%}
        {% do log('-----------------------entrei2---------------------', info=true) %}

            {% set node_version = "_v" ~ (node.version | replace(".", "_")) %}

        {%- else -%}
        {% do log('-----------------------entrei3---------------------', info=true) %}

            {% set node_version = '' %}

        {%- endif -%}

    {%- endif -%} #}
    {# {%- if custom_alias_name -%}
        {% set node_name = node_schema ~ custom_alias_name | trim | replace(" ", "_") ~ node_version %}

    {%- else -%}
        {% set node_name = node_schema ~ node.name ~ node_version %}

    {%- endif -%} #}
        {% do log('-----------------------entrei2---------------------', info=true) %}


    {# ---------------------------------------------------------------------- #}
    {# -- What: Node Schema ------------------------------------------------- #}
    {# -- Why:  dbt cannot create two resources with the same name. This      #}
    {# --       should ensure that models with the same name from different   #)
    {# --       schemas will be unique in the Sandbox schema.                 #}
    {%- if target.schema[0:7] | lower == 'sandbox' and node.config.schema %}
        {% set node_schema = node.config.schema ~ "_" %}

    {%- else -%}
        {% set node_schema = '' %}

    {%- endif -%}

    {# ---------------------------------------------------------------------- #}
    {# -- What: Custom Node Name -------------------------------------------- #}
    {# -- Why:  Create a unique model names as specified in the config alias  #}
    {# --       and/or version number. Otherwise default to the node name     #}
    {# --       aka the model filename and/or version number.                 #}
    {%- if custom_alias_name -%}
        {% set node_name = node_schema ~ custom_alias_name | trim | replace(" ", "_") ~ node_version %}

    {%- else -%}
        {% set node_name = node_schema ~ node.name ~ node_version %}

    {%- endif -%}

    {{ node_name }}

    {# ---------------------------------------------------------------------- #}
    {# -- What: Debugging Logic --------------------------------------------- #}
    {# -- Why:  Checking values for development and testing purposes          #}
    {# -- How:  Move if block or log items in and out of the comment block.   #}
    {# --       Comments ARE the curly-bracket/hash combinations.             #}
    {# --       The '--' is not a comments for dbt. Without the if, dbt will  #}
    {# --       generate log output for EVERY node in the manifest.           #}
    {# 
    {%- if env_var('DBT_TARGET') in ('sandbox') %}
        {% do log(node, info=true) %}
    {%- if node.name == 'domain_market_hierarchy' %}
        {% do log('---------------------------------------------', info=true) %}
        {% do log(node.latest_version, info=true) %}
        {% do log(node.config.version, info=true) %}
        {% do log(node.config.schema, info=true) %}
        {% do log(node.version, info=true) %}
        {% do log(target.schema, info=true) %}
        {% do log(node_name, info=true) %}
        {% do log('---------------------------------------------', info=true) %}
        
    {%- endif -%}
    #}
    {%- if target.name == 'default' %}
    {% do log(node, info=true) %}
    {%endif%}
    {% if node.name == 'refined_wta' %}
    {% do log(node.latest_version, info=true) %}
    {% do log(node.config.version, info=true) %}
    {% do log(node.config.schema, info=true) %}
    {% do log(node.version, info=true) %}
    {% do log(target.schema, info=true) %}
    {% do log(node_name, info=true) %}
    {%- endif -%}

{%- endmacro %}
