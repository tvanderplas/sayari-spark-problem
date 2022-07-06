
with
-- get records with matching names
name_match as (
    select
        ofac.id as ofac_id,
        gbr.id as gbr_id,
        "name match" as reason
    from ofac
    join gbr
        on ofac.name = gbr.name
),
-- get records with matching ID numbers
ofac_id_numbers as (
    select
        id,
        explode(id_numbers) as id_number
    from ofac
),
gbr_id_numbers as (
    select
        id,
        explode(id_numbers) as id_number
    from gbr
),
id_number_match as (
    select
        gbr.id as gbr_id,
        ofac.id as ofac_id,
        "id number match" as reason
    from gbr_id_numbers as gbr
    join ofac_id_numbers as ofac
        on gbr.id_number.value = ofac.id_number.value
),
-- union the different matches
all_matches as (
    select
        gbr_id,
        ofac_id,
        reason
    from id_number_match
    union
    select
        gbr_id,
        ofac_id,
        reason
    from name_match
)
select
    gbr_id,
    ofac_id,
    concat_ws(',', collect_set(reason)) as reason
from all_matches
group by
    gbr_id,
    ofac_id
