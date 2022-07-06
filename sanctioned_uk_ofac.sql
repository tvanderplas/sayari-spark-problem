
with
-- get records with matching names
name_match as (
    select
        ofac.id as ofac_id,
        uk.id as uk_id,
        "name match" as reason
    from ofac
    join uk
        on ofac.name = uk.name
),
-- get records with matching ID numbers
ofac_id_numbers as (
    select
        id,
        explode(id_numbers) as id_number
    from ofac
),
uk_id_numbers as (
    select
        id,
        explode(id_numbers) as id_number
    from uk
),
id_number_match as (
    select
        uk.id as uk_id,
        ofac.id as ofac_id,
        "id number match" as reason
    from uk_id_numbers as uk
    join ofac_id_numbers as ofac
        on uk.id_number.value = ofac.id_number.value
),
-- union the different matches
all_matches as (
    select
        uk_id,
        ofac_id,
        reason
    from id_number_match
    union
    select
        uk_id,
        ofac_id,
        reason
    from name_match
)
select
    uk_id,
    ofac_id,
    concat_ws(',', collect_set(reason)) as reason
from all_matches
group by
    uk_id,
    ofac_id
