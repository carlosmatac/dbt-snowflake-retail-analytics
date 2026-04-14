with source as (
    select * from {{ source('tpch', 'customer') }}
),

renamed as (
    select
        -- PK para el Hub (Hash Key)
        md5(cast(coalesce(cast(c_custkey as varchar), '') as varchar)) as customer_hk,
        
        -- Atributos
        c_custkey as customer_id,
        c_name as customer_name,
        c_address as address,
        c_nationkey as nation_id,
        c_phone as phone_number,
        c_acctbal as account_balance,
        c_mktsegment as market_segment,
        c_comment as comment,

        
        -- Hash Diff para el Satélite (comparamos todos los descriptivos)
        md5(concat_ws('|', 
            coalesce(c_name, ''), 
            coalesce(c_address, ''),
            coalesce(c_phone, ''),
            coalesce(cast(c_acctbal as varchar), ''),
            coalesce(c_mktsegment, '')
        )) as customer_hashdiff,

        -- Metadatos
        current_timestamp() as load_datetime,
        'SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER' as record_source

    from source
)

select * from renamed