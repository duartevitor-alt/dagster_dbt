{% macro default__create_schema(relation) -%}


{%- call statement('create_schema') -%}
    
    {%- set default_schema = target.schema -%}

    {% if default_schema == 'RAW' %}

      CALL DAGSTER_TEST.PUBLIC.CREATE_SCHEMA( '{{ relation.without_identifier() }}' )
    
    {% else %}

    create schema if not exists {{ relation.without_identifier() }} 

    {% endif %}
  
{% endcall %}
      
{% endmacro %}
